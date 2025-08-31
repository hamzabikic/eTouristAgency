using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("PassengerDocument")]
public partial class PassengerDocument
{
    [Key]
    public Guid Id { get; set; }

    public byte[] DocumentBytes { get; set; } = null!;

    [StringLength(255)]
    public string DocumentName { get; set; } = null!;

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("PassengerDocumentCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("Id")]
    [InverseProperty("PassengerDocument")]
    public virtual Passenger IdNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("PassengerDocumentModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;
}
