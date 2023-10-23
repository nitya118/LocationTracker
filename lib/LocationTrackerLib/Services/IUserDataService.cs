﻿using LocationTrackerLib.Models;

namespace LocationTrackerLib.Services
{
    public interface IUserDataService
    {
        public Task<User> LoadUser(string username);

        Task<IEnumerable<User>> GetUsers();

        public Task SaveUser(User user);

        public Task DeleteUser(User user);


        public Task<User> GetGlobalUser();

        public Task SaveGlobalSettings(bool canLogin, bool canSendSms);
    }
}