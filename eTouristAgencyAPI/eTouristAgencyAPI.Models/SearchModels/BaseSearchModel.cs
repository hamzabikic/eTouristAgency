namespace eTouristAgencyAPI.Models.SearchModels
{
    public class BaseSearchModel : PaginationModel
    {
        public string? SearchText { get; set; }
        public bool SortedAscending { get; set; } = false;
        public bool SortedDescending { get; set; } = true;
    }
}
