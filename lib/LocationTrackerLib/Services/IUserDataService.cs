using LocationTrackerLib.Models;

namespace LocationTrackerLib.Services
{
    public interface IUserDataService
    {
        public Task<User> LoadUser(string username);

        public Task SaveUser(User user);

        public Task DeleteUser(User user);
    }
}