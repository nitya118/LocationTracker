using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LocationTrackerAPI.Models;

namespace LocationTrackerAPI.Services
{
    public interface IDataService
    {
        public bool IdExists(string id);

        public void UpdateRecord(LocationInfo locationInfo);
    }
}
