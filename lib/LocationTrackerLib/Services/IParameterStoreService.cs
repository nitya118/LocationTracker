using LocationTrackerLib.Models;

namespace LocationTrackerLib.Services
{
    public interface IParameterStoreService
    {
        public Task<ParameterStoreModel> GetParameterStoreModel();
    }
}