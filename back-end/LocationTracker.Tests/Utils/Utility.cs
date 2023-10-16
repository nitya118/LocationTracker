using Xunit;

namespace LocationTracker.Tests.Utils
{
    public class Utility
    {
        [Theory]
        [InlineData("07456 789 012", true)]
        [InlineData("+44 7447813453", true)]
        public void function_should_validate_uk_mobile_numbers(string mobile, bool isValid)
        {
            var result = LocationTracker.Utils.Utility.IsValidateUKMobileNumber(mobile);

            Assert.True(result == isValid);
        }

        [Theory]
        [InlineData("07456 789 012", "+447456789012")]
        public void converting_uk_mobile_to_international_format(string mobile,string expected)
        {
            var result = LocationTracker.Utils.Utility.ConvertUkMobileToInternational(mobile);

            Assert.True(result == expected);
        }


    }
}