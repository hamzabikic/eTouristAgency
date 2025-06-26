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

    public virtual DbSet<Reservation> Reservations { get; set; }

    public virtual DbSet<ReservationPayment> ReservationPayments { get; set; }

    public virtual DbSet<ReservationReview> ReservationReviews { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<Room> Rooms { get; set; }

    public virtual DbSet<RoomOffer> RoomOffers { get; set; }

    public virtual DbSet<RoomType> RoomTypes { get; set; }

    public virtual DbSet<User> Users { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<City>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__City__3214EC07312A9241");

            entity.ToTable("City");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Name).HasMaxLength(100);

            entity.HasOne(d => d.Country).WithMany(p => p.Cities)
                .HasForeignKey(d => d.CountryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKCity241283");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.CityCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .HasConstraintName("FKCity880359");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.CityModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .HasConstraintName("FKCity641978");
        });

        modelBuilder.Entity<Country>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Country__3214EC0770F2D1F2");

            entity.ToTable("Country");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Name).HasMaxLength(255);

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.CountryCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .HasConstraintName("FKCountry505983");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.CountryModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .HasConstraintName("FKCountry744364");
        });

        modelBuilder.Entity<EmailVerification>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__EmailVer__3214EC0745ED4E1C");

            entity.ToTable("EmailVerification");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.VerificationKey)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.EmailVerificationType).WithMany(p => p.EmailVerifications)
                .HasForeignKey(d => d.EmailVerificationTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKEmailVerif701141");

            entity.HasOne(d => d.User).WithMany(p => p.EmailVerifications)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKEmailVerif613795");
        });

        modelBuilder.Entity<EntityCode>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__EntityCo__3214EC075BF0FCF7");

            entity.ToTable("EntityCode");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.Name).HasMaxLength(255);
        });

        modelBuilder.Entity<EntityCodeValue>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__EntityCo__3214EC07AD59F1BA");

            entity.ToTable("EntityCodeValue");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Name).HasMaxLength(255);

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.EntityCodeValueCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .HasConstraintName("FKEntityCode596278");

            entity.HasOne(d => d.EntityCode).WithMany(p => p.EntityCodeValues)
                .HasForeignKey(d => d.EntityCodeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKEntityCode668051");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.EntityCodeValueModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .HasConstraintName("FKEntityCode834659");
        });

        modelBuilder.Entity<Hotel>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Hotel__3214EC07EB0C59A4");

            entity.ToTable("Hotel");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Name).HasMaxLength(255);

            entity.HasOne(d => d.City).WithMany(p => p.Hotels)
                .HasForeignKey(d => d.CityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotel717322");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.HotelCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotel65883");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.HotelModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotel827501");
        });

        modelBuilder.Entity<HotelImage>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__HotelIma__3214EC070ECAAFD2");

            entity.ToTable("HotelImage");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.HotelImageCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotelImage772530");

            entity.HasOne(d => d.Hotel).WithMany(p => p.HotelImages)
                .HasForeignKey(d => d.HotelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotelImage536976");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.HotelImageModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKHotelImage10912");
        });

        modelBuilder.Entity<Offer>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Offer__3214EC07D16F6D7A");

            entity.ToTable("Offer");

            entity.HasIndex(e => e.OfferNo, "UQ__Offer__8EBC0FBB66409E29").IsUnique();

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.Carriers).HasMaxLength(255);
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.DeparturePlace).HasMaxLength(255);
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.OfferCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOffer882796");

            entity.HasOne(d => d.Hotel).WithMany(p => p.Offers)
                .HasForeignKey(d => d.HotelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOffer118351");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.OfferModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOffer644415");

            entity.HasOne(d => d.OfferStatus).WithMany(p => p.Offers)
                .HasForeignKey(d => d.OfferStatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOffer728835");
        });

        modelBuilder.Entity<OfferDiscount>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__OfferDis__3214EC072C962493");

            entity.ToTable("OfferDiscount");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Discount).HasColumnType("decimal(15, 2)");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.OfferDiscountCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDisco532645");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.OfferDiscountModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDisco771026");

            entity.HasOne(d => d.Offer).WithMany(p => p.OfferDiscounts)
                .HasForeignKey(d => d.OfferId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDisco517182");
        });

        modelBuilder.Entity<OfferDocument>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__OfferDoc__3214EC072A97EF5E");

            entity.ToTable("OfferDocument");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.OfferDocumentCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDocum70028");

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.OfferDocument)
                .HasForeignKey<OfferDocument>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDocum817671");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.OfferDocumentModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferDocum308409");
        });

        modelBuilder.Entity<OfferImage>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__OfferIma__3214EC07B466F2B3");

            entity.ToTable("OfferImage");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.OfferImageCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferImage632224");

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.OfferImage)
                .HasForeignKey<OfferImage>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferImage255475");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.OfferImageModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOfferImage870605");
        });

        modelBuilder.Entity<Reservation>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Reservat__3214EC0763351517");

            entity.ToTable("Reservation");

            entity.HasIndex(e => e.ReservationNo, "UQ__Reservat__B7ED239E9C9A742A").IsUnique();

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.PaidAmount).HasColumnType("decimal(15, 2)");
            entity.Property(e => e.TotalCost).HasColumnType("decimal(10, 2)");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.ReservationCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio194016");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.ReservationModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio955634");

            entity.HasOne(d => d.OfferDiscount).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.OfferDiscountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio911731");

            entity.HasOne(d => d.ReservationStatus).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.ReservationStatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio127771");

            entity.HasOne(d => d.RoomOffer).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.RoomOfferId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio505422");

            entity.HasOne(d => d.User).WithMany(p => p.ReservationUsers)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio730164");
        });

        modelBuilder.Entity<ReservationPayment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Reservat__3214EC070E3A6F26");

            entity.ToTable("ReservationPayment");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.ReservationPaymentCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio536480");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.ReservationPaymentModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio196729");

            entity.HasOne(d => d.Reservation).WithMany(p => p.ReservationPayments)
                .HasForeignKey(d => d.ReservationId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio264129");
        });

        modelBuilder.Entity<ReservationReview>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Reservat__3214EC078CCCD554");

            entity.ToTable("ReservationReview");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.ReservationReviewCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio887494");

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.ReservationReview)
                .HasForeignKey<ReservationReview>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio885176");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.ReservationReviewModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKReservatio350886");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Role__3214EC0714C62030");

            entity.ToTable("Role");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Room>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Room__3214EC07CAD05FC9");

            entity.ToTable("Room");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.RoomCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRoom427895");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.RoomModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRoom189514");

            entity.HasOne(d => d.Offer).WithMany(p => p.Rooms)
                .HasForeignKey(d => d.OfferId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRoom493867");

            entity.HasOne(d => d.RoomType).WithMany(p => p.Rooms)
                .HasForeignKey(d => d.RoomTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRoom188940");
        });

        modelBuilder.Entity<RoomOffer>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__RoomOffe__3214EC0750842904");

            entity.ToTable("RoomOffer");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.ChildDiscount).HasColumnType("decimal(15, 2)");
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.PricePerPerson).HasColumnType("decimal(15, 2)");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.RoomOfferCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRoomOffer602746");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.RoomOfferModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRoomOffer364365");

            entity.HasOne(d => d.OfferRoom).WithMany(p => p.RoomOffers)
                .HasForeignKey(d => d.OfferRoomId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRoomOffer670665");
        });

        modelBuilder.Entity<RoomType>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__RoomType__3214EC07690A4341");

            entity.ToTable("RoomType");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.RoomTypeCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .HasConstraintName("FKRoomType639052");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.RoomTypeModifiedByNavigations)
                .HasForeignKey(d => d.ModifiedBy)
                .HasConstraintName("FKRoomType400671");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__User__3214EC0746353BBB");

            entity.ToTable("User");

            entity.HasIndex(e => e.Username, "UQ__User__536C85E4D22B85BE").IsUnique();

            entity.HasIndex(e => e.Email, "UQ__User__A9D105345CE04165").IsUnique();

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.FirstName).HasMaxLength(100);
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.ModifiedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.PasswordHash).IsUnicode(false);
            entity.Property(e => e.PhoneNumber)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Username)
                .HasMaxLength(100)
                .IsUnicode(false);

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

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
