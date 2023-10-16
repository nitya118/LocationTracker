using Amazon.DynamoDBv2.DataModel;

namespace LocationTrackerLib.Models
{
    public enum LocationReportStatus
    {
        SMS_SENT = 1,

        LOCATION_RECEIVED = 3
    }

    [DynamoDBTable("LocationReports")]
    public class LocationReport
    {
        private DateTime _createdDateTime;

        [DynamoDBHashKey]
        public string Id { get; set; }

        [DynamoDBProperty]
        public string Name { get; set; }

        [DynamoDBProperty]
        public string CreatedBy { get; set; }

        [DynamoDBProperty]
        public string Mobile { get; set; }

        [DynamoDBProperty]
        public DateTime CreatedDateTimeUTC
        {
            get { return _createdDateTime; }
            set
            {
                _createdDateTime = value;

                var dt = (new DateTime(value.Ticks, DateTimeKind.Utc)).AddHours(24);

                var dtOffset = new DateTimeOffset(dt);

                TimeToLive= dtOffset.ToUnixTimeSeconds();
            }
        }

        [DynamoDBProperty]
        public LocationReportStatus Status { get; set; }

        [DynamoDBProperty]
        public double Lat { get; set; }

        [DynamoDBProperty]
        public double Long { get; set; }

        [DynamoDBProperty]
        public DateTime LocationupdatedUTCDatetime { get; set; }

        [DynamoDBProperty]
        public long TimeToLive
        {
            get;set;
        }
    }
}