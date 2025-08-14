using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("Reservation")]
[Index("ReservationNo", Name = "UQ__Reservat__B7ED239E9C9A742A", IsUnique = true)]
public partial class Reservation
{
    [Key]
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    [Column(TypeName = "decimal(15, 2)")]
    public decimal PaidAmount { get; set; }

    public DateTime CancellationDate { get; set; }

    public long ReservationNo { get; set; }

    [Column(TypeName = "decimal(10, 2)")]
    public decimal TotalCost { get; set; }

    public string PassengersJson { get; set; } = null!;

    public Guid OfferDiscountId { get; set; }

    public Guid ReservationStatusId { get; set; }

    public Guid ModifiedBy { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid RoomId { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("ReservationCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("ReservationModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;

    [ForeignKey("OfferDiscountId")]
    [InverseProperty("Reservations")]
    public virtual OfferDiscount OfferDiscount { get; set; } = null!;

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
}
