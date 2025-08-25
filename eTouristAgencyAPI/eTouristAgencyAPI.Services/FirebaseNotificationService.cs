using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using eTouristAgencyAPI.Services.Configuration;
using eTouristAgencyAPI.Services.Interfaces;
using eTouristAgencyAPI.Services.Messaging.Firebase;
using Google.Apis.Auth.OAuth2;
using Microsoft.Extensions.Options;

namespace eTouristAgencyAPI.Services
{
    public class FirebaseNotificationService : IFirebaseNotificationService
    {
        private readonly FirebaseConfig _firebaseConfig;

        public FirebaseNotificationService(IOptions<FirebaseConfig> firebaseConfigOptions)
        {
            _firebaseConfig = firebaseConfigOptions.Value;
        }

        private async Task<string> GetAccessTokenAsync()
        {
            using var stream = new System.IO.MemoryStream(Encoding.UTF8.GetBytes(_firebaseConfig.FirebaseConfigJson));
            var credential = GoogleCredential.FromStream(stream).CreateScoped("https://www.googleapis.com/auth/firebase.messaging");

            return await credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
        }

        public async Task SendNotificationAsync(string deviceToken, string title, string body, FirebaseNotificationData data)
        {
            var accessToken = await GetAccessTokenAsync();

            using var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var payload = new
            {
                message = new
                {
                    token = deviceToken,
                    notification = new
                    {
                        title,
                        body
                    },
                    data
                }
            };

            var json = JsonSerializer.Serialize(payload);
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            var url = $"https://fcm.googleapis.com/v1/projects/{_firebaseConfig.FirebaseProjectId}/messages:send";

            await client.PostAsync(url, content);
        }
    }
}
