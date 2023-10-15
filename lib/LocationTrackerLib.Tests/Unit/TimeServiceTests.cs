using LocationTrackerLib.Models;
using LocationTrackerLib.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace LocationTrackerLib.Tests.Unit
{
    public class TimeServiceTests
    {

        [Fact]
        public void TTL_property_should_return_unix_epoch_which_is_24_hours_after_creation()
        {
            LocationReport report = new LocationReport()
            {
                Id = "SomeId",
                CreatedBy = "someone@sowhere.com",
                CreatedDateTimeUTC = new DateTime(2023, 10, 18, 13, 0, 0)
            };

            //check from online sources , I used https://www.epochconverter.com/
            long expectedTTLEpoch = 1697720400;

            Assert.True(report.TimeToLive == expectedTTLEpoch);
        }


        [Fact]
        public void time_conversion_should_return_correct_time_during_summer()
        {
            var tzSut = new TimeService();

            //Oct 01 2023, we are still in BST , provide the time in utc
            var date = new DateTime(2023, 10, 01, 10, 0, 0, 0);

            var ret=tzSut.ConvertUTCToBST(date);

            //expect local time to be 1 hour ahead
            var ts = ret - date;

            Assert.True(ts.Hours == 1);

        }



        [Fact]
        public void time_conversion_should_return_correct_time_during_winter()
        {
            var tzSut = new TimeService();

            //Dec 01 2023, we are still in GMT , provide the time in utc
            var date = new DateTime(2023, 12, 01, 10, 0, 0, 0);

            var ret = tzSut.ConvertUTCToBST(date);

            //expect local time to be 1 hour ahead
            var ts = ret - date;

            Assert.True(ts.Hours == 0);

        }


    }
}
