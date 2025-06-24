using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class Offer
{
    public Guid Id { get; set; }

    public DateTime TripStartDate { get; set; }

    public int NumberOfNights { get; set; }

    public DateTime TripEndDate { get; set; }

    public string Carriers { get; set; } = null!;

    public string Description { get; set; } = null!;

    public DateTime FirstPaymentDeadline { get; set; }

    public DateTime LastPaymentDeadline { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public long OfferNo { get; set; }

    public string DeparturePlace { get; set; } = null!;

    public Guid HotelId { get; set; }

    public Guid OfferStatusId { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    public virtual User CreatedByNavigation { get; set; } = null!;

    public virtual Hotel Hotel { get; set; } = null!;

    public virtual User ModifiedByNavigation { get; set; } = null!;

    public virtual ICollection<OfferDiscount> OfferDiscounts { get; set; } = new List<OfferDiscount>();

    public virtual OfferDocument? OfferDocument { get; set; }

    public virtual OfferImage? OfferImage { get; set; }

    public virtual EntityCodeValue OfferStatus { get; set; } = null!;

    public virtual ICollection<Room> Rooms { get; set; } = new List<Room>();
}
