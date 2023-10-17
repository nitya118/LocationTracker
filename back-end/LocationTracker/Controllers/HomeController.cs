using LocationTracker.Models;
using LocationTrackerLib.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace LocationTracker.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        private readonly ILocationReportDataService _locationReportDataService;

        private readonly ITimeService _timeService;

        private readonly IGeoService _geoService;

        private readonly ISmsNotifier _smsNotifier;

        public HomeController(ILogger<HomeController> logger, ILocationReportDataService locationReportDataService, ITimeService timeService, IGeoService geoService, ISmsNotifier smsNotifier)
        {
            _logger = logger;

            _locationReportDataService = locationReportDataService;

            _timeService = timeService;

            _geoService = geoService;

            _smsNotifier = smsNotifier;
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> LogOut()
        {
            await HttpContext.SignOutAsync("Cookies");

            await HttpContext.SignOutAsync("OpenIdConnect");

            return RedirectToAction("Index");
        }

        [HttpGet]
        public async Task<JsonResult> GetLocationReports()
        {
            var fromDate = new DateTime(2023, 10, 1, 0, 0, 0);

            var toDate = new DateTime(2023, 10, 31, 0, 0, 0);

            var reports = await _locationReportDataService.GetRecordsAsync("", fromDate, toDate);

            return Json(reports);
        }

        [HttpPost]
        public async Task<IActionResult> CreateLocationReport(string name, string mobile)
        {
            if (string.IsNullOrEmpty(name))
            {
                return StatusCode(400, "Name cannot be empty.");
            }

            if (string.IsNullOrEmpty(mobile))
            {
                return StatusCode(400, "Mobile cannot be empty.");
            }

            return StatusCode(200);
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