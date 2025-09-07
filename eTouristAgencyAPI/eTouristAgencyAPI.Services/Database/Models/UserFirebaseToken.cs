using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("UserFirebaseToken")]
public partial class UserFirebaseToken
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(255)]
    public string FirebaseToken { get; set; } = null!;

    public Guid UserId { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    [ForeignKey("UserId")]
    [InverseProperty("UserFirebaseTokens")]
    public virtual User User { get; set; } = null!;
}
