using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("UserTag")]
public partial class UserTag
{
    [Key]
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    [StringLength(255)]
    public string Tag { get; set; } = null!;

    public DateTime CreatedOn { get; set; }

    [ForeignKey("UserId")]
    [InverseProperty("UserTags")]
    public virtual User User { get; set; } = null!;
}
