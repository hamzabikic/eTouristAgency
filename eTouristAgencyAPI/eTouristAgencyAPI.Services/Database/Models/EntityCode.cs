using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("EntityCode")]
public partial class EntityCode
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(255)]
    public string Name { get; set; } = null!;

    [InverseProperty("EntityCode")]
    public virtual ICollection<EntityCodeValue> EntityCodeValues { get; set; } = new List<EntityCodeValue>();
}
