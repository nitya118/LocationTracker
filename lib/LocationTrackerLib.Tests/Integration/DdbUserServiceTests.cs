using LocationTrackerLib.Models;
using LocationTrackerLib.Services;
using Xunit;

namespace LocationTrackerLib.Tests.Integration
{
    public class DdbUserServiceTests
    {
        [Xunit.Fact]
        public async Task Should_save_a_user()
        {
            var sut = new DdbUserService();

            var user = new User()
            {
                UserName = "alice@contoso.com",
                CanLogin = true,
                CanSendSms = true,
                IsSupervisor = false,
            };

            await sut.SaveUser(user);

            var saved = await sut.LoadUser(user.UserName);

            Assert.NotNull(saved);
        }

        [Fact]
        public async Task Should_be_able_to_delete_a_user()
        {
            var sut = new DdbUserService();

            var user = new User()
            {
                UserName = "delete@contoso.com",
                CanLogin = true,
                CanSendSms = true,
                IsSupervisor = false,
            };

            await sut.SaveUser(user);

            var saved = await sut.LoadUser(user.UserName);

            Assert.NotNull(saved);

            await sut.DeleteUser(user);

            var ret =await sut.LoadUser(user.UserName);

            Assert.Null(ret);
        }
    }
}