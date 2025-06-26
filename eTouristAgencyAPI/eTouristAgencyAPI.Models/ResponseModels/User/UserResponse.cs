using System.Data;
using eTouristAgencyAPI.Models.ResponseModels.Role;

namespace eTouristAgencyAPI.Models.ResponseModels.User
{
    public class UserResponse
    {
        public Guid Id { get; set; }

        public string Username { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Email { get; set; }

        public string PhoneNumber { get; set; }

        public DateTime CreatedOn { get; set; }

        public DateTime ModifiedOn { get; set; }

        public bool IsActive { get; set; }

        public bool IsVerified { get; set; }

        public List<RoleResponse> Roles { get; set; }
    }
}