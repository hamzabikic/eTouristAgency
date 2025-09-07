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
        private readonly HttpClient _httpClient;

        public FirebaseNotificationService(IOptions<FirebaseConfig> firebaseConfigOptions)
        {
            _firebaseConfig = firebaseConfigOptions.Value;
            _httpClient = new HttpClient();
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

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

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

            await _httpClient.PostAsync(url, content);
        }
    }
}
