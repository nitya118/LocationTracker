using Amazon.SimpleNotificationService;
using Amazon.SimpleNotificationService.Model;

namespace LocationTrackerLib.Services
{
    public class SmsNotifier : ISmsNotifier
    {
        private AmazonSimpleNotificationServiceClient snsClient = new AmazonSimpleNotificationServiceClient(Amazon.RegionEndpoint.EUWest1);

        public async Task SendReport(string mobile, string message)
        {
            var request = new PublishRequest()
            {
                Message = message,
                PhoneNumber = mobile
            };

            await snsClient.PublishAsync(request);
        }
    }
}