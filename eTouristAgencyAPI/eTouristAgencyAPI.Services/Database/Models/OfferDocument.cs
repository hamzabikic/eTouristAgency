using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class OfferDocument
{
    public Guid Id { get; set; }

    public byte[] DocumentBytes { get; set; } = null!;

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    public string DocumentName { get; set; } = null!;

    public virtual User CreatedByNavigation { get; set; } = null!;

    public virtual Offer IdNavigation { get; set; } = null!;

    public virtual User ModifiedByNavigation { get; set; } = null!;
}
