using LocationTrackerLib.Models;

namespace LocationTracker.Models
{
    public class LocationReportView
    {
        public string Name { get; set; }

        public string Mobile { get; set; }

        public string CreatedDateTime { get; set; }

        public string CreatedBy { get; set; }

        public string StatusString { get {
               

                switch(this.Status)
                {
                    case LocationReportStatus.SMS_SENT:
                        return "SMS Sent";
                        break;
                    case LocationReportStatus.LOCATION_RECEIVED:
                        return "Location Received";
                        break;
                    default:
                        return "";
                }
            
            } }

        public LocationReportStatus Status { get; set; }

        public double Lat { get; set; }

        public double Long { get; set; }

       public string EastingsNorthings { get; set; }
    }
}