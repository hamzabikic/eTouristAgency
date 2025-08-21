using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("EmailVerification")]
public partial class EmailVerification
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(20)]
    [Unicode(false)]
    public string VerificationKey { get; set; } = null!;

    public Guid UserId { get; set; }

    public DateTime ValidFrom { get; set; }

    public DateTime ValidTo { get; set; }

    public Guid EmailVerificationTypeId { get; set; }

    [ForeignKey("EmailVerificationTypeId")]
    [InverseProperty("EmailVerifications")]
    public virtual EntityCodeValue EmailVerificationType { get; set; } = null!;

    [ForeignKey("UserId")]
    [InverseProperty("EmailVerifications")]
    public virtual User User { get; set; } = null!;
}
