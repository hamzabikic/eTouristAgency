namespace eTouristAgencyAPI.Models.RequestModels.Passenger
{
    public class UpdatePassengerRequest
    {
        public Guid? Id { get; set; }
        public string FullName { get; set; }
        public string PhoneNumber { get; set; }
        public DateTime? DateOfBirth { get; set; }
    }
}
