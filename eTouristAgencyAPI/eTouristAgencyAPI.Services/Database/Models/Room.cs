using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class Room
{
    public Guid Id { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid RoomTypeId { get; set; }

    public Guid OfferId { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    public virtual User CreatedByNavigation { get; set; } = null!;

    public virtual User ModifiedByNavigation { get; set; } = null!;

    public virtual Offer Offer { get; set; } = null!;

    public virtual ICollection<RoomOffer> RoomOffers { get; set; } = new List<RoomOffer>();

    public virtual RoomType RoomType { get; set; } = null!;
}
