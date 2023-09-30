using Microsoft.AspNetCore.Mvc;

using Amazon.SimpleNotificationService;
using Amazon.SimpleNotificationService.Model;

namespace LocationTracker.Controllers
{
    public class SMSController : Controller
    {


        private string _message = "Hello from the location tracker app." +
            "Please click this url to confirm your location.http://google.co.uk";


        private AmazonSimpleNotificationServiceClient snsClient = new AmazonSimpleNotificationServiceClient(Amazon.RegionEndpoint.EUWest1);

        [HttpGet]
        public IActionResult Index()
        {
            return View("~/Views/Home/sms.cshtml");
        }

        [HttpPost]
        public async Task<IActionResult> Index(string mobileNumber)
        {

            if (string.IsNullOrEmpty(mobileNumber))
            {
                return View("~/Views/Home/sms.cshtml");
            }

            var request = new PublishRequest()
            {
                Message = _message,
                PhoneNumber = mobileNumber
            };


            await snsClient.PublishAsync(request);

            return View("~/Views/Home/sms.cshtml");
        }


    }
}
