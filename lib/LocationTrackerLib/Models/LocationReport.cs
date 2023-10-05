namespace LocationTrackerLib.Models
{
    public enum LocationReportStatus
    {
        SMS_SENT = 1,

        LOCATION_RECEIVED = 3
    }

    public class LocationReport
    {
        public string Id { get; set; }

        public string Name { get; set; }

        public string Mobile { get; set; }

        public DateTime UTCCreateDateTime { get; set; }

        public LocationReportStatus Status { get; set; }

        public decimal Lat { get; set; }

        public decimal Long { get; set; }

        public DateTime LocationupdatedUTCDatetime { get; set; }

        
    }
}