using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class EmailVerification
{
    public Guid Id { get; set; }

    public string VerificationKey { get; set; } = null!;

    public Guid UserId { get; set; }

    public DateTime ValidFrom { get; set; }

    public DateTime ValidTo { get; set; }

    public Guid EmailVerificationTypeId { get; set; }

    public virtual EntityCodeValue EmailVerificationType { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
