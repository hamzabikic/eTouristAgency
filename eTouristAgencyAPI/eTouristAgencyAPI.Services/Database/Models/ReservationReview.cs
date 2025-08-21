using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("ReservationReview")]
public partial class ReservationReview
{
    [Key]
    public Guid Id { get; set; }

    public int AccommodationRating { get; set; }

    public int ServiceRating { get; set; }

    public string Description { get; set; } = null!;

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("ReservationReviewCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("Id")]
    [InverseProperty("ReservationReview")]
    public virtual Reservation IdNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("ReservationReviewModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;
}
