using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("City")]
public partial class City
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(100)]
    public string Name { get; set; } = null!;

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid? CreatedBy { get; set; }

    public Guid? ModifiedBy { get; set; }

    public Guid CountryId { get; set; }

    [ForeignKey("CountryId")]
    [InverseProperty("Cities")]
    public virtual Country Country { get; set; } = null!;

    [ForeignKey("CreatedBy")]
    [InverseProperty("CityCreatedByNavigations")]
    public virtual User? CreatedByNavigation { get; set; }

    [InverseProperty("City")]
    public virtual ICollection<Hotel> Hotels { get; set; } = new List<Hotel>();

    [ForeignKey("ModifiedBy")]
    [InverseProperty("CityModifiedByNavigations")]
    public virtual User? ModifiedByNavigation { get; set; }
}
