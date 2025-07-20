namespace eTouristAgencyAPI.Models.RequestModels.Room
{
    public class UpdateRoomRequest
    {
        public Guid Id { get; set; }

        public Guid RoomTypeId { get; set; }

        public decimal PricePerPerson { get; set; }

        public decimal ChildDiscount { get; set; }
        
        public int Quantity { get; set; }

        public string? ShortDescription { get; set; }
    }
}
