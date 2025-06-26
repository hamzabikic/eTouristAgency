namespace eTouristAgencyAPI.Models.SearchModels
{
    public class PaginationModel
    {
        public int Page { get; set; } = 1;
        public int RecordsPerPage { get; set; } = 10;
    }
}
