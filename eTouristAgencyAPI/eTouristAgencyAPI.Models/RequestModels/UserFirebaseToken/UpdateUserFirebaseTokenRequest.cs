namespace eTouristAgencyAPI.Models.RequestModels.UserFirebaseToken
{
    public class UpdateUserFirebaseTokenRequest
    {
        public string OldFirebaseToken { get; set; }
        public string NewFirebaseToken { get; set; }
    }
}
