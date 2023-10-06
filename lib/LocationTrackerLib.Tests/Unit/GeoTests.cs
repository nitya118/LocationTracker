using LocationTrackerLib.Services;
using Xunit;

namespace LocationTrackerLib.Tests.Unit
{
    public class GeoTests
    {
        /*
          Example Test Data
            1) Slalom London: 2 London Bridge, London, SE1 9RA: 532750.1, 180364.7
            2) The Shard, 32 London Bridge St, London SE1 9SG: 532900.1, 180114
            3) Big Ben, London SW1A 0AA: 530270.4, 179640
            4) City Ground, West Bridgeford, Nottingham NG2 5FJ: 458367, 338405.7

            lat and lon were picked up by the front end esri based map

            use the tool below to cross check conversions
            https://gridreferencefinder.com

         */

        [Theory]
        [InlineData("Slalom London: 2 London Bridge, London, SE1 9RA", 51.506630, -0.088616893, 532750.1, 180364.7)]
        [InlineData("The Shard, 32 London Bridge St, London SE1 9SG", 51.504341, -0.086551245, 532900.1, 180114)]
        [InlineData("Big Ben, London SW1A 0AA", 51.500693, -0.12459313, 530270.4, 179640)]
        [InlineData("City Ground, West Bridgeford, Nottingham NG2 5FJ", 52.939880, -1.1329526, 458367, 338405.7)]
        public void test_converting_LatLon_to_NorthingsEastings(string address, double lat, double lon, double expectedX, double expectedY)
        {
            var geoService = new GeoService();

            var en = geoService.ConvertFromLatLon(new Models.LatLon(lat, lon));

            var xDiff = Math.Abs(expectedX - en.X);

            var yDiff = Math.Abs(expectedY - en.Y);

            Assert.True(xDiff < 2);

            Assert.True(yDiff < 2);
        }
    }
}