namespace eTouristAgencyAPI.Models.RequestModels.Passenger
{
    public class AddUpdatePassengerDocumentRequest
    {
        public byte[] DocumentBytes { get; set; }
        public string DocumentName { get; set; }
    }
}
