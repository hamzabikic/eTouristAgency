using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class ReservationPayment
{
    public Guid Id { get; set; }

    public byte[] DocumentBytes { get; set; } = null!;

    public Guid ReservationId { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    public string DocumentName { get; set; } = null!;

    public virtual User CreatedByNavigation { get; set; } = null!;

    public virtual User ModifiedByNavigation { get; set; } = null!;

    public virtual Reservation Reservation { get; set; } = null!;
}
