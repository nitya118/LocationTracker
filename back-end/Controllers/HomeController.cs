using Amazon;
using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.DocumentModel;
using LocationTracker.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Formatters;
using System.Diagnostics;

namespace LocationTracker.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public async Task<IActionResult> Index()
        {

            var locationReports =new List<LocationReport>();

            var client = new AmazonDynamoDBClient(RegionEndpoint.EUWest1);

            Table table = Table.LoadTable(client, "LocationReports");


            var scanConfig = new ScanOperationConfig()
            {
                Select = SelectValues.SpecificAttributes,
                AttributesToGet = new List<string> { "Id", "DateTimeUTC" }
            };

            Search search = table.Scan(scanConfig);


            while (!search.IsDone)
            {
                var matches= await search.GetNextSetAsync();
                foreach(var match in matches)
                {
                    locationReports.Add(new LocationReport()
                    {
                        Id = Convert.ToString(match["Id"]),
                        UTCDateString= Convert.ToString(match["DateTimeUTC"])

                    });
                }
            }

            return View(locationReports);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            

            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}