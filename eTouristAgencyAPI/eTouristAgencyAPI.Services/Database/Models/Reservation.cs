using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("Reservation")]
public partial class Reservation
{
    [Key]
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public DateTime? CancellationDate { get; set; }

    [Column(TypeName = "decimal(10, 2)")]
    public decimal TotalCost { get; set; }

    public Guid? OfferDiscountId { get; set; }

    public Guid ReservationStatusId { get; set; }

    public Guid ModifiedBy { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid RoomId { get; set; }

    public long ReservationNo { get; set; }

    [Column(TypeName = "decimal(15, 2)")]
    public decimal PaidAmount { get; set; }

    public string? Note { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("ReservationCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("ReservationModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;

    [ForeignKey("OfferDiscountId")]
    [InverseProperty("Reservations")]
    public virtual OfferDiscount? OfferDiscount { get; set; }

    [InverseProperty("Reservation")]
    public virtual ICollection<Passenger> Passengers { get; set; } = new List<Passenger>();

    [InverseProperty("Reservation")]
    public virtual ICollection<ReservationPayment> ReservationPayments { get; set; } = new List<ReservationPayment>();

    [InverseProperty("IdNavigation")]
    public virtual ReservationReview? ReservationReview { get; set; }

    [ForeignKey("ReservationStatusId")]
    [InverseProperty("Reservations")]
    public virtual EntityCodeValue ReservationStatus { get; set; } = null!;

    [ForeignKey("RoomId")]
    [InverseProperty("Reservations")]
    public virtual Room Room { get; set; } = null!;

    [ForeignKey("UserId")]
    [InverseProperty("ReservationUsers")]
    public virtual User User { get; set; } = null!;

    [NotMapped]
    public bool IsEditable { get; set; }

    [NotMapped]
    public bool IsReviewable { get; set; }
}
