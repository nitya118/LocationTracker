using Amazon;
using Amazon.DynamoDBv2;
using LocationTrackerAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocationTrackerAPI.Services
{
    public  class DDbDataService:IDataService
    {
        public DDbDataService()
        {
            var client = new AmazonDynamoDBClient(RegionEndpoint.EUWest1);
        }

        public bool IdExists(string id)
        {
            throw new NotImplementedException();
        }

        public void UpdateRecord(LocationInfo locationInfo)
        {
            throw new NotImplementedException();
        }
    }
}
