using LocationTrackerLib.Models;
using LocationTrackerLib.Services;
using Xunit;

namespace LocationTrackerLib.Tests.Integration
{
    public class DdbLocationReportServiceTests
    {
        [Fact]
        public async Task Creating_a_record()
        {
            var sut = new DdbLocationReportDataService();

            var ls = new LocationReport()
            {
                Id = System.Guid.NewGuid().ToString(),
                Lat = 1.1,
                Long = 2.2,
                CreatedDateTimeUTC = DateTime.UtcNow,
                Mobile = "07555522",
                Name = "ash",
                Status = LocationReportStatus.SMS_SENT
            };

            await sut.SaveRecordAsync(ls);
        }

        [Fact]
        public async Task loading_non_existing_record_should_return_null()
        {
            var sut = new DdbLocationReportDataService();

            var ls = await sut.LoadRecordAsync("non_exsiting_id");

            Assert.Null(ls);
        }

        [Fact]
        public async Task should_be_able_to_search_by_user()
        {
            var sut = new DdbLocationReportDataService();

            DateTime from = new DateTime(2023, 10, 10, 0, 0, 0);

            DateTime to = new DateTime(2023, 10, 31, 0, 0, 0);

            var ls = await sut.GetRecordsAsync("mallory@contoso.com", from, to);

            Assert.NotNull(ls);
        }

        [Fact]
        public async Task Should_be_able_to_delete_by_record()
        {
            var ls = new LocationReport()
            {
                Id = "del-test_id",
                Lat = 1.1,
                Long = 2.2,
                CreatedDateTimeUTC = DateTime.UtcNow,
                Mobile = "07555522",
                Name = "ash",
                Status = LocationReportStatus.SMS_SENT
            };

            var sut = new DdbLocationReportDataService();

            await sut.SaveRecordAsync(ls);

            var savedRecord = await sut.LoadRecordAsync(ls.Id);

            Assert.NotNull(savedRecord);

            //now delete it

            await sut.DeleteAsyncRecord("del-test_id");

            savedRecord = await sut.LoadRecordAsync(ls.Id);

            Assert.Null(savedRecord);
        }

        [Fact]
        public async Task Should_be_able_to_update_record()
        {
            var ls = new LocationReport()
            {
                Id = "update-test_id",
                Lat = 1.1,
                Long = 2.2,
                CreatedDateTimeUTC = DateTime.UtcNow,
                Mobile = "07555522",
                Name = "ash",
                CreatedBy = "alice@contoso.com",
                Status = LocationReportStatus.SMS_SENT
            };

            var sut = new DdbLocationReportDataService();

            await sut.SaveRecordAsync(ls);

            var updatedRecord = await sut.LoadRecordAsync(ls.Id);

            updatedRecord.Status = LocationReportStatus.LOCATION_RECEIVED;

            updatedRecord.LocationupdatedUTCDatetime = updatedRecord.CreatedDateTimeUTC.AddMinutes(16);

            updatedRecord.Lat = -11;

            updatedRecord.Long = -22;

            await sut.SaveRecordAsync(updatedRecord);

            var check = await sut.LoadRecordAsync(updatedRecord.Id);

            Assert.NotNull(check);

            Assert.True(check.Status == LocationReportStatus.LOCATION_RECEIVED);

            Assert.True(check.Lat == -11);

            Assert.True(check.Lat == -22);
        }

        [Fact()]
        public async Task GenerateTestData()
        {
            Random random = new Random();

            int NumOfRecords = 500;

            string[] agents = { "alice@contoso.com", "bob@contoso.com", "mallory@contoso.com", "frank@contoso.com" };
            string[] firstNames = { "Emma", "James", "Olivia", "Liam", "Sophia", "Noah", "Isabella", "Lucas", "Oliver", "Mia" };
            string[] lastNames = { "Smith", "Johnson", "Brown", "Wilson", "Taylor", "Anderson", "Lee", "Harris", "Clark", "Lewis" };

            var generateRandomMob = () =>
            {
                string prefix = "07";
                string suffix = random.Next(10_000_000, 99_999_999).ToString();
                return prefix + suffix;
            };

            var generateRandomAgent = () =>
            {
                var agent = agents[random.Next(agents.Length)];

                return agent;
            };

            var generateRandomName = () =>
            {
                string firstName = firstNames[random.Next(firstNames.Length)];
                string lastName = lastNames[random.Next(lastNames.Length)];
                return firstName + " " + lastName;
            };

            var createNewRecord = async (string createdBy, string name, string mobile, DateTime currentDateTime) =>
            {
                var ls = new LocationReport()
                {
                    Id = System.Guid.NewGuid().ToString(),
                    Status = LocationReportStatus.SMS_SENT,
                    Name = name,
                    CreatedBy = createdBy,
                    Mobile = mobile,
                    CreatedDateTimeUTC = currentDateTime,
                };

                var sut = new DdbLocationReportDataService();

                await sut.SaveRecordAsync(ls);
            };

            var createdDate = new DateTime(2023, 10, 16, 7, 0, 0); ;

            for (int i = 0; i < NumOfRecords; i++)
            {
                var name = generateRandomName();

                var mobile = generateRandomMob();

                var agent = generateRandomAgent();

                await createNewRecord(agent, name, mobile, createdDate);

                createdDate = createdDate.AddMinutes(10);
            }
        }
    }
}