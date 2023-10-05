namespace LocationTracker.Models
{
    public class LocationReport
    {
        public string Id { get; set; }

        public string UTCDateString { get; set; }

        public static LocationReport CreateNew()
        {
            return new LocationReport()
            {
                Id = Guid.NewGuid().ToString(),

                UTCDateString = DateTime.UtcNow.ToString(),
            };
        }
    }
}
