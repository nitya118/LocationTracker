using LocationTrackerLib.Models;

namespace LocationTrackerLib.Services
{
    public interface ILocationReportDataService
    {
        public Task<LocationReport> LoadRecordAsync(string id);

        public Task SaveRecordAsync(LocationReport report);

        public Task DeleteAsyncRecord(string id);

        public  Task<IEnumerable<LocationReport>> GetRecordsAsync(string user, DateTime from, DateTime to);
    }
}