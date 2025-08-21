using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("ReservationPayment")]
public partial class ReservationPayment
{
    [Key]
    public Guid Id { get; set; }

    public byte[] DocumentBytes { get; set; } = null!;

    public Guid ReservationId { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    [StringLength(255)]
    public string DocumentName { get; set; } = null!;

    [ForeignKey("CreatedBy")]
    [InverseProperty("ReservationPaymentCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("ReservationPaymentModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;

    [ForeignKey("ReservationId")]
    [InverseProperty("ReservationPayments")]
    public virtual Reservation Reservation { get; set; } = null!;
}
