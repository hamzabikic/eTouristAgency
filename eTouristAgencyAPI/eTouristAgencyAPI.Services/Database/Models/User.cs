using System;
using System.Collections.Generic;

namespace eTouristAgencyAPI.Services.Database.Models;

public partial class User
{
    public Guid Id { get; set; }

    public string Username { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string PhoneNumber { get; set; } = null!;

    public DateTime CreatedOn { get; set; }

    public DateTime ModifiedOn { get; set; }

    public bool IsActive { get; set; }

    public bool IsVerified { get; set; }

    public virtual ICollection<City> CityCreatedByNavigations { get; set; } = new List<City>();

    public virtual ICollection<City> CityModifiedByNavigations { get; set; } = new List<City>();

    public virtual ICollection<Country> CountryCreatedByNavigations { get; set; } = new List<Country>();

    public virtual ICollection<Country> CountryModifiedByNavigations { get; set; } = new List<Country>();

    public virtual ICollection<EmailVerification> EmailVerifications { get; set; } = new List<EmailVerification>();

    public virtual ICollection<EntityCodeValue> EntityCodeValueCreatedByNavigations { get; set; } = new List<EntityCodeValue>();

    public virtual ICollection<EntityCodeValue> EntityCodeValueModifiedByNavigations { get; set; } = new List<EntityCodeValue>();

    public virtual ICollection<Hotel> HotelCreatedByNavigations { get; set; } = new List<Hotel>();

    public virtual ICollection<HotelImage> HotelImageCreatedByNavigations { get; set; } = new List<HotelImage>();

    public virtual ICollection<HotelImage> HotelImageModifiedByNavigations { get; set; } = new List<HotelImage>();

    public virtual ICollection<Hotel> HotelModifiedByNavigations { get; set; } = new List<Hotel>();

    public virtual ICollection<Offer> OfferCreatedByNavigations { get; set; } = new List<Offer>();

    public virtual ICollection<OfferDiscount> OfferDiscountCreatedByNavigations { get; set; } = new List<OfferDiscount>();

    public virtual ICollection<OfferDiscount> OfferDiscountModifiedByNavigations { get; set; } = new List<OfferDiscount>();

    public virtual ICollection<OfferDocument> OfferDocumentCreatedByNavigations { get; set; } = new List<OfferDocument>();

    public virtual ICollection<OfferDocument> OfferDocumentModifiedByNavigations { get; set; } = new List<OfferDocument>();

    public virtual ICollection<OfferImage> OfferImageCreatedByNavigations { get; set; } = new List<OfferImage>();

    public virtual ICollection<OfferImage> OfferImageModifiedByNavigations { get; set; } = new List<OfferImage>();

    public virtual ICollection<Offer> OfferModifiedByNavigations { get; set; } = new List<Offer>();

    public virtual ICollection<Passenger> PassengerCreatedByNavigations { get; set; } = new List<Passenger>();

    public virtual ICollection<Passenger> PassengerModifiedByNavigations { get; set; } = new List<Passenger>();

    public virtual ICollection<Reservation> ReservationCreatedByNavigations { get; set; } = new List<Reservation>();

    public virtual ICollection<Reservation> ReservationModifiedByNavigations { get; set; } = new List<Reservation>();

    public virtual ICollection<ReservationPayment> ReservationPaymentCreatedByNavigations { get; set; } = new List<ReservationPayment>();

    public virtual ICollection<ReservationPayment> ReservationPaymentModifiedByNavigations { get; set; } = new List<ReservationPayment>();

    public virtual ICollection<ReservationReview> ReservationReviewCreatedByNavigations { get; set; } = new List<ReservationReview>();

    public virtual ICollection<ReservationReview> ReservationReviewModifiedByNavigations { get; set; } = new List<ReservationReview>();

    public virtual ICollection<Reservation> ReservationUsers { get; set; } = new List<Reservation>();

    public virtual ICollection<Room> RoomCreatedByNavigations { get; set; } = new List<Room>();

    public virtual ICollection<Room> RoomModifiedByNavigations { get; set; } = new List<Room>();

    public virtual ICollection<RoomType> RoomTypeCreatedByNavigations { get; set; } = new List<RoomType>();

    public virtual ICollection<RoomType> RoomTypeModifiedByNavigations { get; set; } = new List<RoomType>();

    public virtual ICollection<Role> Roles { get; set; } = new List<Role>();
}
