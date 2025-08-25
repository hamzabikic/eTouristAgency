using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Database;

public partial class eTouristAgencyDbContext : DbContext
{
    public eTouristAgencyDbContext()
    {
    }

    public eTouristAgencyDbContext(DbContextOptions<eTouristAgencyDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<Country> Countries { get; set; }

    public virtual DbSet<EmailVerification> EmailVerifications { get; set; }

    public virtual DbSet<EntityCode> EntityCodes { get; set; }

    public virtual DbSet<EntityCodeValue> EntityCodeValues { get; set; }

    public virtual DbSet<Hotel> Hotels { get; set; }

    public virtual DbSet<HotelImage> HotelImages { get; set; }

    public virtual DbSet<Offer> Offers { get; set; }

    public virtual DbSet<OfferDiscount> OfferDiscounts { get; set; }

    public virtual DbSet<OfferDocument> OfferDocuments { get; set; }

    public virtual DbSet<OfferImage> OfferImages { get; set; }

    public virtual DbSet<Passenger> Passengers { get; set; }

    public virtual DbSet<Reservation> Reservations { get; set; }

    public virtual DbSet<ReservationPayment> ReservationPayments { get; set; }

    public virtual DbSet<ReservationReview> ReservationReviews { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<Room> Rooms { get; set; }

    public virtual DbSet<RoomType> RoomTypes { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserTag> UserTags { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<City>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__City__3214EC07312A9241");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.Country).WithMany(p => p.Cities)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKCity241283");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.CityCreatedByNavigations).HasConstraintName("FKCity880359");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.CityModifiedByNavigations).HasConstraintName("FKCity641978");
        });

        modelBuilder.Entity<Country>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Country__3214EC0770F2D1F2");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.CountryCreatedByNavigations).HasConstraintName("FKCountry505983");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.CountryModifiedByNavigations).HasConstraintName("FKCountry744364");
        });

        modelBuilder.Entity<EmailVerification>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__EmailVer__3214EC0745ED4E1C");

            entity.Property(e => e.Id).ValueGeneratedNever();

            entity.HasOne(d => d.EmailVerificationType).WithMany(p => p.EmailVerifications)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKEmailVerif701141");

            entity.HasOne(d => d.User).WithMany(p => p.EmailVerifications)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKEmailVerif613795");
        });

        modelBuilder.Entity<EntityCode>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__EntityCo__3214EC075BF0FCF7");

            entity.Property(e => e.Id).ValueGeneratedNever();
        });

        modelBuilder.Entity<EntityCodeValue>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__EntityCo__3214EC07AD59F1BA");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.EntityCodeValueCreatedByNavigations).HasConstraintName("FKEntityCode596278");

            entity.HasOne(d => d.EntityCode).WithMany(p => p.EntityCodeValues)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKEntityCode668051");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.EntityCodeValueModifiedByNavigations).HasConstraintName("FKEntityCode834659");
        });

        modelBuilder.Entity<Hotel>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Hotel__3214EC07EB0C59A4");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.City).WithMany(p => p.Hotels)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotel717322");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.HotelCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotel65883");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.HotelModifiedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotel827501");
        });

        modelBuilder.Entity<HotelImage>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__HotelIma__3214EC070ECAAFD2");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.HotelImageCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotelImage772530");

            entity.HasOne(d => d.Hotel).WithMany(p => p.HotelImages)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotelImage536976");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.HotelImageModifiedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotelImage10912");
        });

        modelBuilder.Entity<Offer>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Offer__3214EC07D16F6D7A");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.OfferNo).ValueGeneratedOnAdd();

            entity.HasOne(d => d.BoardType).WithMany(p => p.OfferBoardTypes).HasConstraintName("FK__Offer__BoardType__4D5F7D71");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.OfferCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOffer882796");

            entity.HasOne(d => d.Hotel).WithMany(p => p.Offers)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOffer118351");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.OfferModifiedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOffer644415");

            entity.HasOne(d => d.OfferStatus).WithMany(p => p.OfferOfferStatuses)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOffer728835");
        });

        modelBuilder.Entity<OfferDiscount>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__OfferDis__3214EC072C962493");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.OfferDiscountCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDisco532645");

            entity.HasOne(d => d.DiscountType).WithMany(p => p.OfferDiscounts)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDisco780000");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.OfferDiscountModifiedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDisco771026");

            entity.HasOne(d => d.Offer).WithMany(p => p.OfferDiscounts)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDisco517182");
        });

        modelBuilder.Entity<OfferDocument>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__OfferDoc__3214EC072A97EF5E");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.OfferDocumentCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDocum70028");

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.OfferDocument)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDocum817671");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.OfferDocumentModifiedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDocum308409");
        });

        modelBuilder.Entity<OfferImage>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__OfferIma__3214EC07B466F2B3");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.OfferImageCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferImage632224");

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.OfferImage)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferImage255475");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.OfferImageModifiedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferImage870605");
        });

        modelBuilder.Entity<Passenger>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Passenge__3214EC07ED8E0702");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.PassengerCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Passenger__Creat__7849DB76");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.PassengerModifiedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Passenger__Modif__793DFFAF");

            entity.HasOne(d => d.Reservation).WithMany(p => p.Passengers)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Passenger__Reser__756D6ECB");
        });

        modelBuilder.Entity<Reservation>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Reservat__3214EC0763351517");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ReservationNo).ValueGeneratedOnAdd();

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.ReservationCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio194016");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.ReservationModifiedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio955634");

            entity.HasOne(d => d.OfferDiscount).WithMany(p => p.Reservations).HasConstraintName("FKReservatio911731");

            entity.HasOne(d => d.ReservationStatus).WithMany(p => p.Reservations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio127771");

            entity.HasOne(d => d.Room).WithMany(p => p.Reservations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Reservati__RoomI__3B40CD36");

            entity.HasOne(d => d.User).WithMany(p => p.ReservationUsers)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio730164");
        });

        modelBuilder.Entity<ReservationPayment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Reservat__3214EC070E3A6F26");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.ReservationPaymentCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio536480");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.ReservationPaymentModifiedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio196729");

            entity.HasOne(d => d.Reservation).WithMany(p => p.ReservationPayments)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio264129");
        });

        modelBuilder.Entity<ReservationReview>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Reservat__3214EC078CCCD554");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.ReservationReviewCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio887494");

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.ReservationReview)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio885176");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.ReservationReviewModifiedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio350886");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Role__3214EC0714C62030");

            entity.Property(e => e.Id).ValueGeneratedNever();
        });

        modelBuilder.Entity<Room>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Room__3214EC07CAD05FC9");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.RoomCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRoom427895");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.RoomModifiedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRoom189514");

            entity.HasOne(d => d.Offer).WithMany(p => p.Rooms)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRoom493867");

            entity.HasOne(d => d.RoomType).WithMany(p => p.Rooms)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRoom188940");
        });

        modelBuilder.Entity<RoomType>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__RoomType__3214EC07690A4341");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.RoomTypeCreatedByNavigations).HasConstraintName("FKRoomType639052");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.RoomTypeModifiedByNavigations).HasConstraintName("FKRoomType400671");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__User__3214EC0746353BBB");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasMany(d => d.Roles).WithMany(p => p.Users)
                .UsingEntity<Dictionary<string, object>>(
                    "UserRole",
                    r => r.HasOne<Role>().WithMany()
                        .HasForeignKey("RoleId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FKUserRole885973"),
                    l => l.HasOne<User>().WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FKUserRole407378"),
                    j =>
                    {
                        j.HasKey("UserId", "RoleId").HasName("PK__UserRole__AF2760ADD5D51AE1");
                        j.ToTable("UserRole");
                    });
        });

        modelBuilder.Entity<UserTag>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__UserTag__3214EC076AFBE017");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.User).WithMany(p => p.UserTags)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__UserTag__UserId__1B9317B3");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
