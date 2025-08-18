using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class ReservationReview
{
    public Guid Id { get; set; }

    public int AccommodationRating { get; set; }

    public int ServiceRating { get; set; }

    public string Description { get; set; } = null!;

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    public virtual User CreatedByNavigation { get; set; } = null!;

    public virtual Reservation IdNavigation { get; set; } = null!;

    public virtual User ModifiedByNavigation { get; set; } = null!;
}
