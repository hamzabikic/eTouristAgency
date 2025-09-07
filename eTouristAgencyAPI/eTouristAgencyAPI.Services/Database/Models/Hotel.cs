using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("Hotel")]
public partial class Hotel
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(255)]
    public string Name { get; set; } = null!;

    public Guid CityId { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public int StarRating { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    [ForeignKey("CityId")]
    [InverseProperty("Hotels")]
    public virtual City City { get; set; } = null!;

    [ForeignKey("CreatedBy")]
    [InverseProperty("HotelCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [InverseProperty("Hotel")]
    public virtual ICollection<HotelImage> HotelImages { get; set; } = new List<HotelImage>();

    [ForeignKey("ModifiedBy")]
    [InverseProperty("HotelModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;

    [InverseProperty("Hotel")]
    public virtual ICollection<Offer> Offers { get; set; } = new List<Offer>();
}
