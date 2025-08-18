using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class EntityCode
{
    public Guid Id { get; set; }

    public string Name { get; set; } = null!;

    public virtual ICollection<EntityCodeValue> EntityCodeValues { get; set; } = new List<EntityCodeValue>();
}
