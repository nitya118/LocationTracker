using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.DataModel;
using LocationTrackerLib.Models;

namespace LocationTrackerLib.Services
{
    public class DdbLocationReportDataService : ILocationReportDataService
    {
        private readonly AmazonDynamoDBClient _dbClient;

        private const string TABLE_NAME = "LocationReports";

        public DdbLocationReportDataService()
        {
            _dbClient = new AmazonDynamoDBClient();
        }

        public async Task DeleteAsyncRecord(string id)
        {
            var item = await LoadRecordAsync(id);

            using (var dbContext = new DynamoDBContext(_dbClient))
            {
                await dbContext.DeleteAsync(item);
            }
        }

        public async Task<LocationReport> LoadRecordAsync(string id)
        {
            using (var dbContext = new DynamoDBContext(_dbClient))
            {
                var ls = await dbContext.LoadAsync<LocationReport>(id);

                return ls;
            }
        }

        public async Task SaveRecordAsync(LocationReport report)
        {
            using (var dbContext = new DynamoDBContext(_dbClient))
            {
                await dbContext.SaveAsync(report);
            }
        }

        public async Task<IEnumerable<LocationReport>> GetRecordsAsync(string createdBy, DateTime from, DateTime to)
        {
            using (var dbContext = new DynamoDBContext(_dbClient))
            {
                var retVal = new List<LocationReport>();

                var scanCondtions = new List<ScanCondition>();

                if (!String.IsNullOrEmpty(createdBy))
                {
                    scanCondtions.Add
                   (new ScanCondition("CreatedBy", Amazon.DynamoDBv2.DocumentModel.ScanOperator.Equal, createdBy));
                }

                var unixEpoch = DateTimeOffset.Now.ToUnixTimeSeconds();

                scanCondtions.Add(new ScanCondition("CreatedDateTimeUTC", Amazon.DynamoDBv2.DocumentModel.ScanOperator.Between, from, to));

                scanCondtions.Add(new ScanCondition("TimeToLive", Amazon.DynamoDBv2.DocumentModel.ScanOperator.GreaterThan, unixEpoch));

                var ret = dbContext.ScanAsync<LocationReport>(scanCondtions);

                while (!ret.IsDone)
                {
                    var ls = await ret.GetRemainingAsync();

                    retVal.AddRange(ls);
                }

                var ordered = retVal.OrderByDescending(x => x.CreatedBy);

                return ordered;
            }
        }
    }
}