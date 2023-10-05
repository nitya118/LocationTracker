using LocationTrackerLib.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocationTrackerLib.Services
{
    public  interface ILocationReportDataService
    {
        public bool RecordExists(string id);

        public void SaveRecord(LocationReport report);

        public void DeleteRecord(string id);
    }
}
