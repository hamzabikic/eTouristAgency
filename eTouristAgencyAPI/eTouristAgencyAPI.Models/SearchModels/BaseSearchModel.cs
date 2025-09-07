namespace eTouristAgencyAPI.Models.SearchModels
{
    public class BaseSearchModel : PaginationModel
    {
        public string? SearchText { get; set; }
    }
}
