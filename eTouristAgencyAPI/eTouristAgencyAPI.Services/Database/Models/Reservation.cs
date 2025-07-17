using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class Reservation
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public decimal PaidAmount { get; set; }

    public DateTime CancellationDate { get; set; }

    public long ReservationNo { get; set; }

    public decimal TotalCost { get; set; }

    public string PassengersJson { get; set; } = null!;

    public Guid OfferDiscountId { get; set; }

    public Guid ReservationStatusId { get; set; }

    public Guid ModifiedBy { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid RoomId { get; set; }

    public virtual User CreatedByNavigation { get; set; } = null!;

    public virtual User ModifiedByNavigation { get; set; } = null!;

    public virtual OfferDiscount OfferDiscount { get; set; } = null!;

    public virtual ICollection<ReservationPayment> ReservationPayments { get; set; } = new List<ReservationPayment>();

    public virtual ReservationReview? ReservationReview { get; set; }

    public virtual EntityCodeValue ReservationStatus { get; set; } = null!;

    public virtual Room Room { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
