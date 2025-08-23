using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("Offer")]
[Index("OfferNo", Name = "UQ__Offer__8EBC0FBBA8F908E0", IsUnique = true)]
public partial class Offer
{
    [Key]
    public Guid Id { get; set; }

    public DateTime TripStartDate { get; set; }

    public int NumberOfNights { get; set; }

    public DateTime TripEndDate { get; set; }

    [StringLength(255)]
    public string Carriers { get; set; } = null!;

    public string Description { get; set; } = null!;

    public DateTime FirstPaymentDeadline { get; set; }

    public DateTime LastPaymentDeadline { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    [StringLength(255)]
    public string DeparturePlace { get; set; } = null!;

    public Guid HotelId { get; set; }

    public Guid OfferStatusId { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    public Guid? BoardTypeId { get; set; }

    public long OfferNo { get; set; }

    [ForeignKey("BoardTypeId")]
    [InverseProperty("OfferBoardTypes")]
    public virtual EntityCodeValue? BoardType { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("OfferCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("HotelId")]
    [InverseProperty("Offers")]
    public virtual Hotel Hotel { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("OfferModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;

    [InverseProperty("Offer")]
    public virtual ICollection<OfferDiscount> OfferDiscounts { get; set; } = new List<OfferDiscount>();

    [InverseProperty("IdNavigation")]
    public virtual OfferDocument? OfferDocument { get; set; }

    [InverseProperty("IdNavigation")]
    public virtual OfferImage? OfferImage { get; set; }

    [ForeignKey("OfferStatusId")]
    [InverseProperty("OfferOfferStatuses")]
    public virtual EntityCodeValue OfferStatus { get; set; } = null!;

    [InverseProperty("Offer")]
    public virtual ICollection<Room> Rooms { get; set; } = new List<Room>();

    [NotMapped]
    public bool IsLastMinuteDiscountActive { get; set; }

    [NotMapped]
    public bool IsFirstMinuteDiscountActive { get; set; }

    [NotMapped]
    public decimal MinimumPricePerPerson { get; set; }

    [NotMapped]
    public int RemainingSpots { get; set; }
}
