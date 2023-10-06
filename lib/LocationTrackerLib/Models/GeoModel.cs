using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocationTrackerLib.Models
{
    public struct EastingsNorthing
    {
        public double X { get; private set; }
        public double Y { get; private set; }

        public EastingsNorthing(double x, double y)
        {
            X = x;
            Y = y;
        }
    }

    public struct LatLon
    {
        public double Lat { get; private set; }
        public double Lon { get; private set; }

        public LatLon(double lat, double lon)
        {
            Lat = lat;

            Lon = lon;
        }
    }
}

