using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("EntityCodeValue")]
public partial class EntityCodeValue
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(255)]
    public string Name { get; set; } = null!;

    public Guid EntityCodeId { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid? CreatedBy { get; set; }

    public Guid? ModifiedBy { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("EntityCodeValueCreatedByNavigations")]
    public virtual User? CreatedByNavigation { get; set; }

    [InverseProperty("EmailVerificationType")]
    public virtual ICollection<EmailVerification> EmailVerifications { get; set; } = new List<EmailVerification>();

    [ForeignKey("EntityCodeId")]
    [InverseProperty("EntityCodeValues")]
    public virtual EntityCode EntityCode { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("EntityCodeValueModifiedByNavigations")]
    public virtual User? ModifiedByNavigation { get; set; }

    [InverseProperty("BoardType")]
    public virtual ICollection<Offer> OfferBoardTypes { get; set; } = new List<Offer>();

    [InverseProperty("DiscountType")]
    public virtual ICollection<OfferDiscount> OfferDiscounts { get; set; } = new List<OfferDiscount>();

    [InverseProperty("OfferStatus")]
    public virtual ICollection<Offer> OfferOfferStatuses { get; set; } = new List<Offer>();

    [InverseProperty("ReservationStatus")]
    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();
}
