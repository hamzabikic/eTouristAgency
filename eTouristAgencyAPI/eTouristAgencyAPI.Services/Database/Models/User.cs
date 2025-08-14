using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services.Database.Models;

[Table("User")]
[Index("Username", Name = "UQ__User__536C85E4D22B85BE", IsUnique = true)]
[Index("Email", Name = "UQ__User__A9D105345CE04165", IsUnique = true)]
public partial class User
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Username { get; set; } = null!;

    [Unicode(false)]
    public string PasswordHash { get; set; } = null!;

    [StringLength(100)]
    public string FirstName { get; set; } = null!;

    [StringLength(100)]
    public string LastName { get; set; } = null!;

    [StringLength(255)]
    [Unicode(false)]
    public string Email { get; set; } = null!;

    [StringLength(50)]
    [Unicode(false)]
    public string PhoneNumber { get; set; } = null!;

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public bool IsActive { get; set; }

    public bool IsVerified { get; set; }

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<City> CityCreatedByNavigations { get; set; } = new List<City>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<City> CityModifiedByNavigations { get; set; } = new List<City>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<Country> CountryCreatedByNavigations { get; set; } = new List<Country>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<Country> CountryModifiedByNavigations { get; set; } = new List<Country>();

    [InverseProperty("User")]
    public virtual ICollection<EmailVerification> EmailVerifications { get; set; } = new List<EmailVerification>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<EntityCodeValue> EntityCodeValueCreatedByNavigations { get; set; } = new List<EntityCodeValue>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<EntityCodeValue> EntityCodeValueModifiedByNavigations { get; set; } = new List<EntityCodeValue>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<Hotel> HotelCreatedByNavigations { get; set; } = new List<Hotel>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<HotelImage> HotelImageCreatedByNavigations { get; set; } = new List<HotelImage>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<HotelImage> HotelImageModifiedByNavigations { get; set; } = new List<HotelImage>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<Hotel> HotelModifiedByNavigations { get; set; } = new List<Hotel>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<Offer> OfferCreatedByNavigations { get; set; } = new List<Offer>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<OfferDiscount> OfferDiscountCreatedByNavigations { get; set; } = new List<OfferDiscount>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<OfferDiscount> OfferDiscountModifiedByNavigations { get; set; } = new List<OfferDiscount>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<OfferDocument> OfferDocumentCreatedByNavigations { get; set; } = new List<OfferDocument>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<OfferDocument> OfferDocumentModifiedByNavigations { get; set; } = new List<OfferDocument>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<OfferImage> OfferImageCreatedByNavigations { get; set; } = new List<OfferImage>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<OfferImage> OfferImageModifiedByNavigations { get; set; } = new List<OfferImage>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<Offer> OfferModifiedByNavigations { get; set; } = new List<Offer>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<Reservation> ReservationCreatedByNavigations { get; set; } = new List<Reservation>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<Reservation> ReservationModifiedByNavigations { get; set; } = new List<Reservation>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<ReservationPayment> ReservationPaymentCreatedByNavigations { get; set; } = new List<ReservationPayment>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<ReservationPayment> ReservationPaymentModifiedByNavigations { get; set; } = new List<ReservationPayment>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<ReservationReview> ReservationReviewCreatedByNavigations { get; set; } = new List<ReservationReview>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<ReservationReview> ReservationReviewModifiedByNavigations { get; set; } = new List<ReservationReview>();

    [InverseProperty("User")]
    public virtual ICollection<Reservation> ReservationUsers { get; set; } = new List<Reservation>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<Room> RoomCreatedByNavigations { get; set; } = new List<Room>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<Room> RoomModifiedByNavigations { get; set; } = new List<Room>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<RoomType> RoomTypeCreatedByNavigations { get; set; } = new List<RoomType>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<RoomType> RoomTypeModifiedByNavigations { get; set; } = new List<RoomType>();

    [ForeignKey("UserId")]
    [InverseProperty("Users")]
    public virtual ICollection<Role> Roles { get; set; } = new List<Role>();
}
