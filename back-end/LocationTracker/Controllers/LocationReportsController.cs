using LocationTracker.Models;
using Microsoft.AspNetCore.Mvc;

namespace LocationTracker.Controllers
{
    public class LocationReportsController : Controller
    {
        private readonly IConfiguration _configuration;

        public LocationReportsController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public IActionResult Index()
        {
            var lrConfigModel = new LocationReportConfigModel()
            {
                PoolId = _configuration.GetValue<string>("ASPNETCORE_POOL_ID"),
                MapName = _configuration.GetValue<string>("ASPNETCORE_MAP_NAME"),
                Region = _configuration.GetValue<string>("ASPNETCORE_REGION"),
            };

            return View("~/Views/Home/LocationReports.cshtml", lrConfigModel);
        }
    }
}