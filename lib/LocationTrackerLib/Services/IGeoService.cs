using LocationTrackerLib.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocationTrackerLib.Services
{
    public interface IGeoService
    {
        public EastingsNorthing ConvertFromLatLon(LatLon latLon);
    }
}
