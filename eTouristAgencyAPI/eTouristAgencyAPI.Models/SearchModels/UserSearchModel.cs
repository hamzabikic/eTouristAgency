namespace eTouristAgencyAPI.Models.SearchModels
{
    public class UserSearchModel : BaseSearchModel
    {
        public Guid? RoleId { get; set; }

        public bool? IsActive { get; set; }
    }
}