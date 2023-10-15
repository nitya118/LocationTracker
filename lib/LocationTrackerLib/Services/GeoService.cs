using GeoUK.Coordinates;
using GeoUK.Ellipsoids;
using GeoUK;
using LocationTrackerLib.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GeoUK.Projections;

namespace LocationTrackerLib.Services
{
    public class GeoService : IGeoService
    {
        /// <summary>
        /// https://github.com/IeuanWalker/GeoUK
        /// Turns Lat and Long to Eastings and Northings
        /// </summary>
        /// <param name="latLon"></param>
        /// <returns></returns>
        public EastingsNorthing ConvertFromLatLon(LatLon latLon)
        {
            LatitudeLongitude latLong = new LatitudeLongitude(latLon.Lat, latLon.Lon);

            Cartesian cartesian = GeoUK.Convert.ToCartesian(new Wgs84(), latLong);

            Cartesian bngCartesian = Transform.Etrs89ToOsgb36(cartesian);

            EastingNorthing bngEN = GeoUK.Convert.ToEastingNorthing(new Airy1830(), new BritishNationalGrid(), bngCartesian);

            return new EastingsNorthing(bngEN.Easting, bngEN.Northing);
        }
    }
}
