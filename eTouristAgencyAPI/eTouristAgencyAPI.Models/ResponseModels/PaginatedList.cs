namespace eTouristAgencyAPI.Models.ResponseModels
{
    public class PaginatedList<TResponseModel>
    {
        public List<TResponseModel> listOfRecords { get; set; }

        public int TotalPages { get; set; }
    }
}