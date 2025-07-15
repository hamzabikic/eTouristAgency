namespace eTouristAgencyAPI.Models.RequestModels.User
{
    public class ResetPasswordRequest
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public string VerificationKey { get; set; }
    }
}
