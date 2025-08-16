using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("OfferDiscount")]
public partial class OfferDiscount
{
    [Key]
    public Guid Id { get; set; }

    public Guid DiscountTypeId { get; set; }

    [Column(TypeName = "decimal(15, 2)")]
    public decimal Discount { get; set; }

    public Guid OfferId { get; set; }

    public DateTime ValidFrom { get; set; }

    public DateTime ValidTo { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("OfferDiscountCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("DiscountTypeId")]
    [InverseProperty("OfferDiscounts")]
    public virtual EntityCodeValue DiscountType { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("OfferDiscountModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;

    [ForeignKey("OfferId")]
    [InverseProperty("OfferDiscounts")]
    public virtual Offer Offer { get; set; } = null!;

    [InverseProperty("OfferDiscount")]
    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();
}
