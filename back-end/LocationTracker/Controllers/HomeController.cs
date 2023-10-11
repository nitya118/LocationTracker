using Amazon;
using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.DocumentModel;
using LocationTracker.Models;
using LocationTrackerLib.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Formatters;
using System.Diagnostics;

namespace LocationTracker.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        private readonly ILocationReportDataService _locationReportDataService;

        public HomeController(ILogger<HomeController> logger, ILocationReportDataService locationReportDataService)
        {
            _logger = logger;

            _locationReportDataService = locationReportDataService;
        }

        public async Task<IActionResult> Index()
        {

            var locationReports =new List<LocationReport>();

          

            return View(locationReports);
        }

        [HttpGet]
        public async Task<JsonResult> GetLocationReports()
        {

            var fromDate = new DateTime(2023, 10, 1, 0, 0, 0);

            var toDate = new DateTime(2023, 10, 15, 0, 0, 0);

            var reports = await _locationReportDataService.GetRecordsAsync("", fromDate, toDate);

            return Json(reports);
        }

      
        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            

            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}