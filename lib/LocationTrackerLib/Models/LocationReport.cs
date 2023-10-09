using Amazon.DynamoDBv2.DataModel;
using System.Diagnostics.CodeAnalysis;

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
        [DynamoDBHashKey]
        public string Id { get; set; }

        [DynamoDBProperty]
        
        public string Name { get; set; }

        [DynamoDBProperty]
        public string CreatedBy { get; set; }

        [DynamoDBProperty]
        public string Mobile { get; set; }

        [DynamoDBProperty]
        public DateTime CreatedDateTimeUTC { get; set; }

        [DynamoDBProperty]
        public LocationReportStatus Status { get; set; }

        [DynamoDBProperty]
        public double Lat { get; set; }

        [DynamoDBProperty]
        public double Long { get; set; }

        [DynamoDBProperty]
        public DateTime LocationupdatedUTCDatetime { get; set; }
    }
}