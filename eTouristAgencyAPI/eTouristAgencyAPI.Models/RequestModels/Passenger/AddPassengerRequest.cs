namespace eTouristAgencyAPI.Models.RequestModels.Passenger
{
    public class AddPassengerRequest
    {
        public string FullName { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string PhoneNumber { get; set; }
    }
}
