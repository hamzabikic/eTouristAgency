using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eTouristAgencyAPI.Services.Migrations
{
    /// <inheritdoc />
    public partial class Initial_Migration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "EntityCode",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__EntityCo__3214EC075BF0FCF7", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Role",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Role__3214EC0714C62030", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "User",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Username = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: false),
                    PasswordHash = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    FirstName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Email = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: false),
                    PhoneNumber = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsVerified = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__User__3214EC0746353BBB", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Country",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Country__3214EC0770F2D1F2", x => x.Id);
                    table.ForeignKey(
                        name: "FKCountry505983",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKCountry744364",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "EntityCodeValue",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    EntityCodeId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__EntityCo__3214EC07AD59F1BA", x => x.Id);
                    table.ForeignKey(
                        name: "FKEntityCode596278",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKEntityCode668051",
                        column: x => x.EntityCodeId,
                        principalTable: "EntityCode",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKEntityCode834659",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "RoomType",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    RoomCapacity = table.Column<int>(type: "int", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__RoomType__3214EC07690A4341", x => x.Id);
                    table.ForeignKey(
                        name: "FKRoomType400671",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKRoomType639052",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "UserFirebaseToken",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    FirebaseToken = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__UserFire__3214EC07549D845B", x => x.Id);
                    table.ForeignKey(
                        name: "FK__UserFireb__UserI__41B8C09B",
                        column: x => x.UserId,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "UserRole",
                columns: table => new
                {
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    RoleId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__UserRole__AF2760ADD5D51AE1", x => new { x.UserId, x.RoleId });
                    table.ForeignKey(
                        name: "FKUserRole407378",
                        column: x => x.UserId,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKUserRole885973",
                        column: x => x.RoleId,
                        principalTable: "Role",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "UserTag",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Tag = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__UserTag__3214EC076AFBE017", x => x.Id);
                    table.ForeignKey(
                        name: "FK__UserTag__UserId__1B9317B3",
                        column: x => x.UserId,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "City",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    CountryId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__City__3214EC07312A9241", x => x.Id);
                    table.ForeignKey(
                        name: "FKCity241283",
                        column: x => x.CountryId,
                        principalTable: "Country",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKCity641978",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKCity880359",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "EmailVerification",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    VerificationKey = table.Column<string>(type: "varchar(20)", unicode: false, maxLength: 20, nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ValidFrom = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ValidTo = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EmailVerificationTypeId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__EmailVer__3214EC0745ED4E1C", x => x.Id);
                    table.ForeignKey(
                        name: "FKEmailVerif613795",
                        column: x => x.UserId,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKEmailVerif701141",
                        column: x => x.EmailVerificationTypeId,
                        principalTable: "EntityCodeValue",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Hotel",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    CityId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    StarRating = table.Column<int>(type: "int", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Hotel__3214EC07EB0C59A4", x => x.Id);
                    table.ForeignKey(
                        name: "FKHotel65883",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKHotel717322",
                        column: x => x.CityId,
                        principalTable: "City",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKHotel827501",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "HotelImage",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ImageBytes = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    HotelId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ImageName = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    DisplayOrderWithinHotel = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__HotelIma__3214EC070ECAAFD2", x => x.Id);
                    table.ForeignKey(
                        name: "FKHotelImage10912",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKHotelImage536976",
                        column: x => x.HotelId,
                        principalTable: "Hotel",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKHotelImage772530",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Offer",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TripStartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    NumberOfNights = table.Column<int>(type: "int", nullable: false),
                    TripEndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Carriers = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    FirstPaymentDeadline = table.Column<DateTime>(type: "datetime2", nullable: false),
                    LastPaymentDeadline = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    DeparturePlace = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    HotelId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    OfferStatusId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    BoardTypeId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    OfferNo = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Offer__3214EC07D16F6D7A", x => x.Id);
                    table.ForeignKey(
                        name: "FKOffer118351",
                        column: x => x.HotelId,
                        principalTable: "Hotel",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKOffer644415",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKOffer728835",
                        column: x => x.OfferStatusId,
                        principalTable: "EntityCodeValue",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKOffer882796",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Offer__BoardType__4D5F7D71",
                        column: x => x.BoardTypeId,
                        principalTable: "EntityCodeValue",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "OfferDiscount",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DiscountTypeId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Discount = table.Column<decimal>(type: "decimal(15,2)", nullable: false),
                    OfferId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ValidFrom = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ValidTo = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__OfferDis__3214EC072C962493", x => x.Id);
                    table.ForeignKey(
                        name: "FKOfferDisco517182",
                        column: x => x.OfferId,
                        principalTable: "Offer",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKOfferDisco532645",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKOfferDisco771026",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKOfferDisco780000",
                        column: x => x.DiscountTypeId,
                        principalTable: "EntityCodeValue",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "OfferDocument",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DocumentBytes = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DocumentName = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__OfferDoc__3214EC072A97EF5E", x => x.Id);
                    table.ForeignKey(
                        name: "FKOfferDocum308409",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKOfferDocum70028",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKOfferDocum817671",
                        column: x => x.Id,
                        principalTable: "Offer",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "OfferImage",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ImageBytes = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ImageName = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__OfferIma__3214EC07B466F2B3", x => x.Id);
                    table.ForeignKey(
                        name: "FKOfferImage255475",
                        column: x => x.Id,
                        principalTable: "Offer",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKOfferImage632224",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKOfferImage870605",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Room",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    RoomTypeId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    OfferId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    PricePerPerson = table.Column<decimal>(type: "decimal(15,2)", nullable: false),
                    ChildDiscount = table.Column<decimal>(type: "decimal(15,2)", nullable: false),
                    Quantity = table.Column<int>(type: "int", nullable: false),
                    ShortDescription = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    DisplayOrderWithinOffer = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Room__3214EC07CAD05FC9", x => x.Id);
                    table.ForeignKey(
                        name: "FKRoom188940",
                        column: x => x.RoomTypeId,
                        principalTable: "RoomType",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKRoom189514",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKRoom427895",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKRoom493867",
                        column: x => x.OfferId,
                        principalTable: "Offer",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Reservation",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CancellationDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    TotalCost = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    OfferDiscountId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    ReservationStatusId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    RoomId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ReservationNo = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PaidAmount = table.Column<decimal>(type: "decimal(15,2)", nullable: false),
                    Note = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Reservat__3214EC0763351517", x => x.Id);
                    table.ForeignKey(
                        name: "FKReservatio127771",
                        column: x => x.ReservationStatusId,
                        principalTable: "EntityCodeValue",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKReservatio194016",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKReservatio730164",
                        column: x => x.UserId,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKReservatio911731",
                        column: x => x.OfferDiscountId,
                        principalTable: "OfferDiscount",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKReservatio955634",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Reservati__RoomI__3B40CD36",
                        column: x => x.RoomId,
                        principalTable: "Room",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Passenger",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    FullName = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    PhoneNumber = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ReservationId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DateOfBirth = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DisplayOrderWithinReservation = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Passenge__3214EC07ED8E0702", x => x.Id);
                    table.ForeignKey(
                        name: "FK__Passenger__Creat__7849DB76",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Passenger__Modif__793DFFAF",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Passenger__Reser__756D6ECB",
                        column: x => x.ReservationId,
                        principalTable: "Reservation",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "ReservationPayment",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DocumentBytes = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    ReservationId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DocumentName = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    DisplayOrderWithinReservation = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Reservat__3214EC070E3A6F26", x => x.Id);
                    table.ForeignKey(
                        name: "FKReservatio196729",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKReservatio264129",
                        column: x => x.ReservationId,
                        principalTable: "Reservation",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKReservatio536480",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "ReservationReview",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    AccommodationRating = table.Column<int>(type: "int", nullable: false),
                    ServiceRating = table.Column<int>(type: "int", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Reservat__3214EC078CCCD554", x => x.Id);
                    table.ForeignKey(
                        name: "FKReservatio350886",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKReservatio885176",
                        column: x => x.Id,
                        principalTable: "Reservation",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FKReservatio887494",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "PassengerDocument",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DocumentBytes = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    DocumentName = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    ModifiedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Passenge__3214EC07FBE8BD9F", x => x.Id);
                    table.ForeignKey(
                        name: "FK__PassengerDoc__Id__2EA5EC27",
                        column: x => x.Id,
                        principalTable: "Passenger",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Passenger__Creat__318258D2",
                        column: x => x.CreatedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Passenger__Modif__32767D0B",
                        column: x => x.ModifiedBy,
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_City_CountryId",
                table: "City",
                column: "CountryId");

            migrationBuilder.CreateIndex(
                name: "IX_City_CreatedBy",
                table: "City",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_City_ModifiedBy",
                table: "City",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Country_CreatedBy",
                table: "Country",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Country_ModifiedBy",
                table: "Country",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_EmailVerification_EmailVerificationTypeId",
                table: "EmailVerification",
                column: "EmailVerificationTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_EmailVerification_UserId",
                table: "EmailVerification",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_EntityCodeValue_CreatedBy",
                table: "EntityCodeValue",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_EntityCodeValue_EntityCodeId",
                table: "EntityCodeValue",
                column: "EntityCodeId");

            migrationBuilder.CreateIndex(
                name: "IX_EntityCodeValue_ModifiedBy",
                table: "EntityCodeValue",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Hotel_CityId",
                table: "Hotel",
                column: "CityId");

            migrationBuilder.CreateIndex(
                name: "IX_Hotel_CreatedBy",
                table: "Hotel",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Hotel_ModifiedBy",
                table: "Hotel",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_HotelImage_CreatedBy",
                table: "HotelImage",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_HotelImage_HotelId",
                table: "HotelImage",
                column: "HotelId");

            migrationBuilder.CreateIndex(
                name: "IX_HotelImage_ModifiedBy",
                table: "HotelImage",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Offer_BoardTypeId",
                table: "Offer",
                column: "BoardTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Offer_CreatedBy",
                table: "Offer",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Offer_HotelId",
                table: "Offer",
                column: "HotelId");

            migrationBuilder.CreateIndex(
                name: "IX_Offer_ModifiedBy",
                table: "Offer",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Offer_OfferStatusId",
                table: "Offer",
                column: "OfferStatusId");

            migrationBuilder.CreateIndex(
                name: "UQ__Offer__8EBC0FBBA8F908E0",
                table: "Offer",
                column: "OfferNo",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_OfferDiscount_CreatedBy",
                table: "OfferDiscount",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_OfferDiscount_DiscountTypeId",
                table: "OfferDiscount",
                column: "DiscountTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_OfferDiscount_ModifiedBy",
                table: "OfferDiscount",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_OfferDiscount_OfferId",
                table: "OfferDiscount",
                column: "OfferId");

            migrationBuilder.CreateIndex(
                name: "IX_OfferDocument_CreatedBy",
                table: "OfferDocument",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_OfferDocument_ModifiedBy",
                table: "OfferDocument",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_OfferImage_CreatedBy",
                table: "OfferImage",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_OfferImage_ModifiedBy",
                table: "OfferImage",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Passenger_CreatedBy",
                table: "Passenger",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Passenger_ModifiedBy",
                table: "Passenger",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Passenger_ReservationId",
                table: "Passenger",
                column: "ReservationId");

            migrationBuilder.CreateIndex(
                name: "IX_PassengerDocument_CreatedBy",
                table: "PassengerDocument",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_PassengerDocument_ModifiedBy",
                table: "PassengerDocument",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Reservation_CreatedBy",
                table: "Reservation",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Reservation_ModifiedBy",
                table: "Reservation",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Reservation_OfferDiscountId",
                table: "Reservation",
                column: "OfferDiscountId");

            migrationBuilder.CreateIndex(
                name: "IX_Reservation_ReservationStatusId",
                table: "Reservation",
                column: "ReservationStatusId");

            migrationBuilder.CreateIndex(
                name: "IX_Reservation_RoomId",
                table: "Reservation",
                column: "RoomId");

            migrationBuilder.CreateIndex(
                name: "IX_Reservation_UserId",
                table: "Reservation",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_ReservationPayment_CreatedBy",
                table: "ReservationPayment",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_ReservationPayment_ModifiedBy",
                table: "ReservationPayment",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_ReservationPayment_ReservationId",
                table: "ReservationPayment",
                column: "ReservationId");

            migrationBuilder.CreateIndex(
                name: "IX_ReservationReview_CreatedBy",
                table: "ReservationReview",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_ReservationReview_ModifiedBy",
                table: "ReservationReview",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Room_CreatedBy",
                table: "Room",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Room_ModifiedBy",
                table: "Room",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Room_OfferId",
                table: "Room",
                column: "OfferId");

            migrationBuilder.CreateIndex(
                name: "IX_Room_RoomTypeId",
                table: "Room",
                column: "RoomTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_RoomType_CreatedBy",
                table: "RoomType",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_RoomType_ModifiedBy",
                table: "RoomType",
                column: "ModifiedBy");

            migrationBuilder.CreateIndex(
                name: "UQ__User__536C85E4D22B85BE",
                table: "User",
                column: "Username",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "UQ__User__A9D105345CE04165",
                table: "User",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserFirebaseToken_UserId",
                table: "UserFirebaseToken",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRole_RoleId",
                table: "UserRole",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_UserTag_UserId",
                table: "UserTag",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "EmailVerification");

            migrationBuilder.DropTable(
                name: "HotelImage");

            migrationBuilder.DropTable(
                name: "OfferDocument");

            migrationBuilder.DropTable(
                name: "OfferImage");

            migrationBuilder.DropTable(
                name: "PassengerDocument");

            migrationBuilder.DropTable(
                name: "ReservationPayment");

            migrationBuilder.DropTable(
                name: "ReservationReview");

            migrationBuilder.DropTable(
                name: "UserFirebaseToken");

            migrationBuilder.DropTable(
                name: "UserRole");

            migrationBuilder.DropTable(
                name: "UserTag");

            migrationBuilder.DropTable(
                name: "Passenger");

            migrationBuilder.DropTable(
                name: "Role");

            migrationBuilder.DropTable(
                name: "Reservation");

            migrationBuilder.DropTable(
                name: "OfferDiscount");

            migrationBuilder.DropTable(
                name: "Room");

            migrationBuilder.DropTable(
                name: "RoomType");

            migrationBuilder.DropTable(
                name: "Offer");

            migrationBuilder.DropTable(
                name: "Hotel");

            migrationBuilder.DropTable(
                name: "EntityCodeValue");

            migrationBuilder.DropTable(
                name: "City");

            migrationBuilder.DropTable(
                name: "EntityCode");

            migrationBuilder.DropTable(
                name: "Country");

            migrationBuilder.DropTable(
                name: "User");
        }
    }
}
