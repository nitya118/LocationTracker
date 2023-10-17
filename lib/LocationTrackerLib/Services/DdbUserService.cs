using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.DataModel;
using LocationTrackerLib.Models;

namespace LocationTrackerLib.Services
{
    public class DdbUserService : IUserDataService
    {
        private readonly AmazonDynamoDBClient _dbClient;

        private const string TABLE_NAME = "LocationReports";

        public DdbUserService()
        {
            _dbClient = new AmazonDynamoDBClient();
        }

        public async Task DeleteUser(User user)
        {
            using (var dbContext = new DynamoDBContext(_dbClient))
            {
                await dbContext.DeleteAsync(user);
            }
        }

        public async Task<User> LoadUser(string username)
        {
            using (var dbContext = new DynamoDBContext(_dbClient))
            {
                var user = await dbContext.LoadAsync<User>(username);

                return user;
            }
        }

        public async Task SaveUser(User user)
        {
            using (var dbContext = new DynamoDBContext(_dbClient))
            {
                await dbContext.SaveAsync(user);
            }
        }

        public async Task<IEnumerable<User>> GetUsers()
        {
            using (var dbContext = new DynamoDBContext(_dbClient))
            {
                var retVal = new List<User>();

                var scanCondtions = new List<ScanCondition>();

                var ret = dbContext.ScanAsync<User>(scanCondtions);

                while (!ret.IsDone)
                {
                    var ls = await ret.GetRemainingAsync();

                    retVal.AddRange(ls);
                }

                var ordered = retVal.OrderBy(x => x.UserName);

                return ordered;
            }
        }
    }
}