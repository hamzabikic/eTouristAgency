namespace eTouristAgencyAPI.Models.ResponseModel
{
    public class PaginatedList<TResponseModel>
    {
        public List<TResponseModel> listOfRecords { get; set; }

        public int TotalPages { get; set; }
    }
}
