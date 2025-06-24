namespace eTouristAgencyAPI.Models.SearchModels
{
    public class BaseSearchModel
    {
        public string? SearchText { get; set; }
        public int Page { get; set; } = 1;
        public int RecordsPerPage { get; set; } = 10;
        public bool SortedAscending { get; set; } = false;
        public bool SortedDescending { get; set; } = true;
    }
}
