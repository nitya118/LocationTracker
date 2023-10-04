using Microsoft.AspNetCore.Mvc;

using Amazon.SimpleNotificationService;
using Amazon.SimpleNotificationService.Model;
using Microsoft.Graph;
using Microsoft.Graph;
using Azure.Identity;
using Microsoft.Identity.Client;
using Azure.Core;

namespace LocationTracker.Controllers
{
    public class SMSController : Controller
    {


        private string _message = "Hello from the location tracker app." +
            "Please click this url to confirm your location.http://google.co.uk";


        private AmazonSimpleNotificationServiceClient snsClient = new AmazonSimpleNotificationServiceClient(Amazon.RegionEndpoint.EUWest1);

        [HttpGet]
        public async Task<IActionResult> IndexAsync()
        {

            //https://stackoverflow.com/questions/75234868/not-able-to-get-all-users-from-azure-active-directory

            var scopes = new[] { "https://graph.microsoft.com/.default" };

            var clientSecretCredential = new ClientSecretCredential("d42058a0-e138-4897-97c8-d8d80dfc1764", "628b2fa9-ef94-4db5-86d6-bd8316ada49c", "a4B8Q~ehjrKD1bGpuHYaBH8VvSFNhvECs4e4Tddk");

            var graphClient = new GraphServiceClient(clientSecretCredential, scopes);

            var users = await graphClient.Users.GetAsync();

           if (users != null)
            {
               for(var i=0; i<users.Value.Count; i++)
                {
                    var user = users.Value[i].UserPrincipalName;
                }
            }
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
