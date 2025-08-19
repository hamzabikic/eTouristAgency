using System.Text;
using eTouristAgencyAPI.Models.ResponseModels.RoomType;

namespace eTouristAgencyAPI.Models.ResponseModels.Room
{
    public class RoomResponse
    {
        public Guid Id { get; set; }

        public Guid RoomTypeId { get; set; }

        public Guid OfferId { get; set; }

        public decimal PricePerPerson { get; set; }

        public decimal DiscountedPrice { get; set; }

        public decimal ChildDiscount { get; set; }

        public int Quantity { get; set; }

        public string ShortDescription { get; set; }

        public RoomTypeResponse RoomType { get; set; }

        public bool IsAvalible { get; set; }
    }
}
