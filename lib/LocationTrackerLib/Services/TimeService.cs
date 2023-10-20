using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocationTrackerLib.Services
{
    public class TimeService : ITimeService
    {
        public DateTime ConvertUTCToBST(DateTime utc)
        {
            var BritishZone = TimeZoneInfo.FindSystemTimeZoneById("GMT Standard Time");

            DateTime dt = DateTime.SpecifyKind(utc, DateTimeKind.Utc);

            var bst= TimeZoneInfo.ConvertTime(dt, TimeZoneInfo.Utc, BritishZone);

            return bst;
        }

        public DateTime GetCurrentUTCDateTime()
        {
            return System.DateTime.UtcNow;
        }

      
    }
}
