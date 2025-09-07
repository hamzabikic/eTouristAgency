using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("OfferImage")]
public partial class OfferImage
{
    [Key]
    public Guid Id { get; set; }

    public byte[] ImageBytes { get; set; } = null!;

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    [StringLength(255)]
    public string ImageName { get; set; } = null!;

    [ForeignKey("CreatedBy")]
    [InverseProperty("OfferImageCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("Id")]
    [InverseProperty("OfferImage")]
    public virtual Offer IdNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("OfferImageModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;
}
