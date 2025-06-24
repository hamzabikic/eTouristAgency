using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class HotelImage
{
    public Guid Id { get; set; }

    public byte[] ImageBytes { get; set; } = null!;

    public Guid HotelId { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    public virtual User CreatedByNavigation { get; set; } = null!;

    public virtual Hotel Hotel { get; set; } = null!;

    public virtual User ModifiedByNavigation { get; set; } = null!;
}
