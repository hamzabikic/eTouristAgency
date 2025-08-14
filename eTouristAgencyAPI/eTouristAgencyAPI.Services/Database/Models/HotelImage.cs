using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("HotelImage")]
public partial class HotelImage
{
    [Key]
    public Guid Id { get; set; }

    public byte[] ImageBytes { get; set; } = null!;

    public Guid HotelId { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("HotelImageCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("HotelId")]
    [InverseProperty("HotelImages")]
    public virtual Hotel Hotel { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("HotelImageModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;
}
