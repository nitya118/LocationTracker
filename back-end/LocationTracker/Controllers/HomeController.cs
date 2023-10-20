using LocationTracker.Models;
using LocationTracker.Utils;
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

        private readonly IUserDataService _userDataService;

        public HomeController(ILogger<HomeController> logger, ILocationReportDataService locationReportDataService, ITimeService timeService, IGeoService geoService, ISmsNotifier smsNotifier, IUserDataService userDataService)
        {
            _logger = logger;

            _locationReportDataService = locationReportDataService;

            _timeService = timeService;

            _geoService = geoService;

            _smsNotifier = smsNotifier;

            _userDataService = userDataService;
        }

        public async Task<IActionResult> Index()
        {
            //implement user authorization checks here

            var globalUser = await _userDataService.GetGlobalUser();

            if (globalUser == null)
            {
                //create the global user if not already there
                await _userDataService.SaveGlobalSettings(true, true);
            }

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
            var fromDate = new DateTime(2023, 10, 1);

            var toDate = fromDate.AddDays(35);

            var reports = await _locationReportDataService.GetRecordsAsync("", fromDate, toDate);

            var lrv = reports.Select(x => new LocationReportView()
            {
                CreatedDateTime = string.Format("{0:dd MMM HH:mm}", x.CreatedDateTimeUTC), //dynamoDB automatically does conversion to local
                CreatedBy = x.CreatedBy,
                Name = x.Name,
                Mobile = x.Mobile,
                Status = x.Status,
                Lat = x.Lat,
                Long = x.Long,
                EastingsNorthings = string.Format("X={0},\r\nY={1}", _geoService.ConvertFromLatLon(new LocationTrackerLib.Models.LatLon(x.Lat, x.Long)).X, _geoService.ConvertFromLatLon(new LocationTrackerLib.Models.LatLon(x.Lat, x.Long)).Y)
            });

            return Json(lrv);
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

            if (!Utility.IsValidateUKMobileNumber(mobile))
            {
                return StatusCode(400, "Incorrect mobile number format.");
            }


            mobile=Utility.ConvertUkMobileToInternational(mobile);


            var lr = new LocationTrackerLib.Models.LocationReport()
            {
                Id = System.Guid.NewGuid().ToString(),
                CreatedBy = User.Identity.Name.Split("@")[0],
                Name = name,
                Mobile = mobile,
                CreatedDateTimeUTC = _timeService.GetCurrentUTCDateTime(),
                Status = LocationTrackerLib.Models.LocationReportStatus.SMS_SENT
            };

            var message = $"Hello from the Location Track App. Please enter your location here.https://d2rqqna7prrzjd.cloudfront.net/?id={lr.Id}";

            await _smsNotifier.SendReport(mobile, message);

            await _locationReportDataService.SaveRecordAsync(lr);

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