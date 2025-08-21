using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("Room")]
public partial class Room
{
    [Key]
    public Guid Id { get; set; }

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public Guid RoomTypeId { get; set; }

    public Guid OfferId { get; set; }

    public Guid CreatedBy { get; set; }

    public Guid ModifiedBy { get; set; }

    [Column(TypeName = "decimal(15, 2)")]
    public decimal PricePerPerson { get; set; }

    [Column(TypeName = "decimal(15, 2)")]
    public decimal ChildDiscount { get; set; }

    public int Quantity { get; set; }

    [StringLength(255)]
    public string? ShortDescription { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("RoomCreatedByNavigations")]
    public virtual User CreatedByNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("RoomModifiedByNavigations")]
    public virtual User ModifiedByNavigation { get; set; } = null!;

    [ForeignKey("OfferId")]
    [InverseProperty("Rooms")]
    public virtual Offer Offer { get; set; } = null!;

    [InverseProperty("Room")]
    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();

    [ForeignKey("RoomTypeId")]
    [InverseProperty("Rooms")]
    public virtual RoomType RoomType { get; set; } = null!;

    [NotMapped]
    public bool IsAvalible { get; set; }

    [NotMapped]
    public decimal DiscountedPrice { get; set; }
}
