using LocationTracker.Controllers;
using LocationTrackerLib.Models;
using LocationTrackerLib.Services;
using Moq;
using Xunit;

namespace LocationTracker.Tests.Controllers
{
    public class UserControllerTests
    {
        [Fact]
        public async Task should_have_username_supplied_or_should_return_bad_request()
        {
            var mockUserDataService = new Mock<IUserDataService>();

            var sut = new UserController(mockUserDataService.Object);

            var payLoad = new User()
            {
                UserName = "",
            };

           var resp= await sut.SaveUser(payLoad);

            mockUserDataService.Verify(x=>x.SaveUser(payLoad),Times.Never());

            //Assert.True(resp=="BadRequest")
        }
    }
}