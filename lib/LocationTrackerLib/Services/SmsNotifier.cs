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

            var smsAttributes = new SetSMSAttributesRequest();

            smsAttributes.Attributes.Add("DefaultSenderID", "LEAKS");

            //await snsClient.SetSMSAttributesAsync(smsAttributes);

            await snsClient.PublishAsync(request);
        }
    }
}