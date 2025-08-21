using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("OfferDocument")]
public partial class OfferDocument
{
    [Key]
    public Guid Id { get; set; }

    public byte[] DocumentBytes { get; set; } = null!;

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    [StringLength(255)]
    public string DocumentName { get; set; } = null!;

    [ForeignKey("CreatedBy")]
    [InverseProperty("OfferDocumentCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("Id")]
    [InverseProperty("OfferDocument")]
    public virtual Offer IdNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("OfferDocumentModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;
}
