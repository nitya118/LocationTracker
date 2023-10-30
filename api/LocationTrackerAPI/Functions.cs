using Amazon.Lambda.Annotations;
using Amazon.Lambda.Annotations.APIGateway;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using LocationTrackerAPI.Models;
using LocationTrackerLib.Services;
using System.Text.Json;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace LocationTrackerAPI;

public class Functions
{
    private readonly ILocationReportDataService _locationReportDataService;

    private readonly ITimeService _timeService;

    private readonly IParameterStoreService _parameterStoreService;

    /// <summary>
    /// Default constructor that Lambda will invoke.
    /// </summary>
    ///
    public Functions() : this(null, null, null)
    {
    }

    public Functions(ILocationReportDataService locationReportDataService, ITimeService timeService, IParameterStoreService parameterStoreService)
    {
        _locationReportDataService = _locationReportDataService ?? new DdbLocationReportDataService();

        _timeService = timeService ?? new TimeService();

        _parameterStoreService = parameterStoreService ?? new ParameterStoreService();
    }

    private APIGatewayProxyResponse CreateNotFoundResponse()
    {
        return new APIGatewayProxyResponse()
        {
            StatusCode = 404,
        };
    }

    private APIGatewayProxyResponse CreateOkResponse(ResponseData body)
    {
        return new APIGatewayProxyResponse()
        {
            StatusCode = 200,
            Body = JsonSerializer.Serialize(body)
        };
    }

    /// <summary>
    /// A Lambda function to respond to HTTP Get methods from API Gateway
    /// </summary>
    /// <remarks>
    /// This uses the <see href="https://github.com/aws/aws-lambda-dotnet/blob/master/Libraries/src/Amazon.Lambda.Annotations/README.md">Lambda Annotations</see>
    /// programming model to bridge the gap between the Lambda programming model and a more idiomatic .NET model.
    ///
    /// This automatically handles reading parameters from an APIGatewayProxyRequest
    /// as well as syncing the function definitions to serverless.template each time you build.
    ///
    /// If you do not wish to use this model and need to manipulate the API Gateway
    /// objects directly, see the accompanying Readme.md for instructions.
    /// </remarks>
    /// <param name="context">Information about the invocation, function, and execution environment</param>
    /// <returns>The response as an implicit <see cref="APIGatewayProxyResponse"/></returns>
    [LambdaFunction(Policies = "AWSLambdaBasicExecutionRole", MemorySize = 256, Timeout = 30)]
    [RestApi(LambdaHttpMethod.Any, "/")]
    public async Task<APIGatewayProxyResponse> LocationReport(APIGatewayProxyRequest request, ILambdaContext context)
    {
        // context.Logger.LogInformation("Handling the 'Get' Request");

        var id = request.QueryStringParameters?["id"];

        if (!string.IsNullOrEmpty(id))
        {
            var ls = await _locationReportDataService.LoadRecordAsync(id);

            if (ls == null)
            {
                return CreateNotFoundResponse();
            }

            if (ls.Status != LocationTrackerLib.Models.LocationReportStatus.SMS_SENT)
            {
                return CreateNotFoundResponse();
            }

            var pm = await _parameterStoreService.GetParameterStoreModel();

            var responseDataModel = new ResponseData()
            {
                MapName = pm.MapName,
                PoolId = pm.MapPoolId,
                Region = pm.MapRegion
            };

            return CreateOkResponse(responseDataModel);
        }
        else
        {
            if (string.IsNullOrEmpty(request.Body))
            {
                return CreateNotFoundResponse();
            }

            var obj = JsonSerializer.Deserialize<LocationInfo>(request.Body);

            if (obj == null)
            {
                return CreateNotFoundResponse();
            }

            if (string.IsNullOrEmpty(obj.Id))
            {
                return CreateNotFoundResponse();
            }

            var ls = await _locationReportDataService.LoadRecordAsync(obj.Id);

            if (ls == null)
            {
                return CreateNotFoundResponse();
            }

            if (ls.Status != LocationTrackerLib.Models.LocationReportStatus.SMS_SENT)
            {
                return CreateNotFoundResponse();
            }

            //update the record
            ls.Status = LocationTrackerLib.Models.LocationReportStatus.LOCATION_RECEIVED;
            ls.Lat = obj.Lat;
            ls.Long = obj.Lon;
            ls.LocationupdatedUTCDatetime = _timeService.GetCurrentUTCDateTime();

            await _locationReportDataService.SaveRecordAsync(ls);

            return CreateOkResponse(null);
        }
    }
}