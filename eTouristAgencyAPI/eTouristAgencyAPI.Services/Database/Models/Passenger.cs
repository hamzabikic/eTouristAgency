using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("Passenger")]
public partial class Passenger
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(255)]
    public string FullName { get; set; } = null!;

    [StringLength(50)]
    public string PhoneNumber { get; set; } = null!;

    public Guid ReservationId { get; set; }

    public DateTime DateOfBirth { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    public int? DisplayOrderWithinReservation { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("PassengerCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("PassengerModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;

    [InverseProperty("IdNavigation")]
    public virtual PassengerDocument? PassengerDocument { get; set; }

    [ForeignKey("ReservationId")]
    [InverseProperty("Passengers")]
    public virtual Reservation Reservation { get; set; } = null!;
}
