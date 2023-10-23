using Amazon.DynamoDBv2.DataModel;

namespace LocationTrackerLib.Models
{
    [DynamoDBTable("Users")]
    public class User
    {
        [DynamoDBHashKey]
        public string UserName { get; set; }

        [DynamoDBProperty]
        public bool IsSystem { get; set; }

        [DynamoDBProperty]
        public bool IsSupervisor { get; set; }

        [DynamoDBProperty]
        public bool CanSendSms { get; set; }

        [DynamoDBProperty]
        public bool CanLogin { get; set; }
    }
}