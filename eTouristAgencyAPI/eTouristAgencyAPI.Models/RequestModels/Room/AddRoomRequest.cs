namespace eTouristAgencyAPI.Models.RequestModels.Room
{
    public class AddRoomRequest
    {
        public Guid RoomTypeId { get; set; }

        public decimal PricePerPerson { get; set; }

        public decimal ChildDiscount { get; set; }
    }
}
