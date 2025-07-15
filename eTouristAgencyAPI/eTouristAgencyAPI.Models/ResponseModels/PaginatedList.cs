namespace eTouristAgencyAPI.Models.ResponseModels
{
    public class PaginatedList<TResponseModel>
    {
        public List<TResponseModel> ListOfRecords { get; set; }

        public int TotalPages { get; set; }
    }
}