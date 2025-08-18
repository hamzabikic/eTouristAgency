using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class OfferDiscount
{
    public Guid Id { get; set; }

    public Guid DiscountTypeId { get; set; }

    public decimal Discount { get; set; }

    public Guid OfferId { get; set; }

    public DateTime ValidFrom { get; set; }

    public DateTime ValidTo { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    public virtual User CreatedByNavigation { get; set; } = null!;

    public virtual EntityCodeValue DiscountType { get; set; } = null!;

    public virtual User ModifiedByNavigation { get; set; } = null!;

    public virtual Offer Offer { get; set; } = null!;

    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();
}
