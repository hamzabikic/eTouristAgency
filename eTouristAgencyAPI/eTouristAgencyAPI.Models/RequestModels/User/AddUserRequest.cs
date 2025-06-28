namespace eTouristAgencyAPI.Models.RequestModels.User
{
    public class AddUserRequest
    {
        public string Username { get; set; }

        public string Password { get; set; }

        public string ConfirmPassword { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Email { get; set; }

        public string PhoneNumber { get; set; }

        public List<Guid> RoleIds { get; set; } = new List<Guid> { };
    }
}