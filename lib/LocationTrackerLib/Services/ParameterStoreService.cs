using Amazon.SimpleSystemsManagement;
using Amazon.SimpleSystemsManagement.Model;
using LocationTrackerLib.Models;

namespace LocationTrackerLib.Services
{
    public class ParameterStoreService : IParameterStoreService
    {
        public async Task<ParameterStoreModel> GetParameterStoreModel()
        {
            var pm = new ParameterStoreModel();

            var client = new AmazonSimpleSystemsManagementClient();

            pm.MapName = (await client.GetParameterAsync(new GetParameterRequest() { Name = "map_name" })).Parameter.Value;

            pm.MapPoolId = (await client.GetParameterAsync(new GetParameterRequest() { Name = "map_pool_id"})).Parameter.Value;

            pm.MapRegion = (await client.GetParameterAsync(new GetParameterRequest() { Name = "map_region" })).Parameter.Value;

            return pm;
        }
    }
}