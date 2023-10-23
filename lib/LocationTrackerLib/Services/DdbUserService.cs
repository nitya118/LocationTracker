using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.DataModel;
using LocationTrackerLib.Models;

namespace LocationTrackerLib.Services
{
    public class DdbUserService : IUserDataService
    {
        private readonly AmazonDynamoDBClient _dbClient;

        private const string TABLE_NAME = "LocationReports";

        private const string GLOBAL_USER = "GlobalUser";

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

        public async Task<User> GetGlobalUser()
        {
            var user = await LoadUser(GLOBAL_USER);

            if (user == null) return null;

            if (user.IsSystem)
            { 
                return user; 
            }
            else
            {
                return null;
            }
        }

        public async Task SaveGlobalSettings(bool canLogin, bool canSendSms)
        {
            var user = new User()
            {
                UserName = GLOBAL_USER,
                IsSystem = true,
                IsSupervisor = true,
                CanLogin = canLogin,
                CanSendSms = canSendSms
            };


            await SaveUser(user);

        }
    }
}