using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocationTrackerAPI.Models
{
    public class LocationInfo
    {
        public string Id { get; set; }

        public decimal Lat { get;set; }

        public decimal Long { get; set; }
    }
}
