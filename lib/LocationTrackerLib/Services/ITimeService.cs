using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocationTrackerLib.Services
{
    public  interface ITimeService
    {
        public DateTime GetCurrentUTCDateTime();

        public DateTime ConvertUTCToBST(DateTime utc);
    }
}
