namespace eTouristAgencyAPI.Models.ResponseModels.Passenger
{
    public class PassengerResponse
    {
        public Guid Id { get; set; }
        public string FullName { get; set; }
        public string PhoneNumber { get; set; }
        public DateTime? DateOfBirth { get; set; }
    }
}
