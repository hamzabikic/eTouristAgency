using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class RoomType
{
    public Guid Id { get; set; }

    public int RoomCapacity { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid? CreatedBy { get; set; }

    public Guid? ModifiedBy { get; set; }

    public virtual User? CreatedByNavigation { get; set; }

    public virtual User? ModifiedByNavigation { get; set; }

    public virtual ICollection<Room> Rooms { get; set; } = new List<Room>();
}
