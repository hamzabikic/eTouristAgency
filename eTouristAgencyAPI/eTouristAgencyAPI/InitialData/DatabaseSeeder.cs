using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using Microsoft.AspNetCore.Identity;

namespace eTouristAgencyAPI.InitialData
{
    public static class DatabaseSeeder
    {
        static public void SeedDatabase(eTouristAgencyDbContext db)
        {
            // --- Countries ---
            if (!db.Countries.Any())
            {
                db.Countries.AddRange(
                    new Country { Id = Guid.Parse("1ab4b721-baec-4c58-a01e-21b233dd78f9"), Name = "Srbija", CreatedOn = DateTime.Parse("2025-08-09T05:44:57.1633333"), ModifiedOn = DateTime.Parse("2025-08-09T05:45:12.6799596"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new Country { Id = Guid.Parse("1c2f3fe5-788b-46e0-9a1e-886cb5513225"), Name = "Hrvatska", CreatedOn = DateTime.Parse("2025-07-18T19:37:59.2000000"), ModifiedOn = DateTime.Parse("2025-07-18T19:37:59.2000000"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new Country { Id = Guid.Parse("6805331c-de6d-4c2b-8fa8-c3141e3fb658"), Name = "Bosna i Hercegovina", CreatedOn = DateTime.Parse("2025-07-15T00:53:27.7533333"), ModifiedOn = DateTime.Parse("2025-07-15T00:56:56.0802236"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") }
                );
                db.SaveChanges();
            }

            // --- Cities ---
            if (!db.Cities.Any())
            {
                db.Cities.AddRange(
                    new City { Id = Guid.Parse("a0b5db51-8e2b-40c1-a932-38523038348c"), Name = "Banja Luka", CountryId = Guid.Parse("6805331c-de6d-4c2b-8fa8-c3141e3fb658"), CreatedOn = DateTime.Parse("2025-08-16T23:21:35.7400000"), ModifiedOn = DateTime.Parse("2025-08-16T23:21:35.7400000"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new City { Id = Guid.Parse("13fa8b1a-a040-45b5-acc3-5d5275fef6a8"), Name = "Zagreb", CountryId = Guid.Parse("1c2f3fe5-788b-46e0-9a1e-886cb5513225"), CreatedOn = DateTime.Parse("2025-08-09T03:05:28.1300000"), ModifiedOn = DateTime.Parse("2025-08-09T03:12:57.0281069"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new City { Id = Guid.Parse("e6b4ae11-30e9-4036-91de-6b7f3a226faf"), Name = "Tuzla", CountryId = Guid.Parse("6805331c-de6d-4c2b-8fa8-c3141e3fb658"), CreatedOn = DateTime.Parse("2025-07-15T00:57:34.0500000"), ModifiedOn = DateTime.Parse("2025-07-15T00:58:47.4340328"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new City { Id = Guid.Parse("c513f74a-1e8b-4ca1-82ca-c93b738df225"), Name = "Makarska", CountryId = Guid.Parse("1c2f3fe5-788b-46e0-9a1e-886cb5513225"), CreatedOn = DateTime.Parse("2025-07-18T19:38:51.4800000"), ModifiedOn = DateTime.Parse("2025-07-18T19:38:51.4800000"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new City { Id = Guid.Parse("f9390b86-01bb-4561-87f0-d2fd79b23eaa"), Name = "Mostar", CountryId = Guid.Parse("6805331c-de6d-4c2b-8fa8-c3141e3fb658"), CreatedOn = DateTime.Parse("2025-07-15T00:59:33.3633333"), ModifiedOn = DateTime.Parse("2025-07-15T00:59:33.3633333"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new City { Id = Guid.Parse("202fcfe0-3445-460c-8f9e-e5154f417561"), Name = "Beograd", CountryId = Guid.Parse("1ab4b721-baec-4c58-a01e-21b233dd78f9"), CreatedOn = DateTime.Parse("2025-08-09T05:45:44.2266667"), ModifiedOn = DateTime.Parse("2025-08-09T05:45:44.2266667"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new City { Id = Guid.Parse("5ba677d0-7eb2-44ed-94f5-f1d527586398"), Name = "Neum", CountryId = Guid.Parse("6805331c-de6d-4c2b-8fa8-c3141e3fb658"), CreatedOn = DateTime.Parse("2025-08-03T00:43:28.8900000"), ModifiedOn = DateTime.Parse("2025-08-03T00:43:28.8900000"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") }
                );
                db.SaveChanges();
            }

            // --- EntityCodes ---
            if (!db.EntityCodes.Any())
            {
                db.EntityCodes.AddRange(
                    new EntityCode { Id = Guid.Parse("bfae64f5-c544-4f93-b193-034f6d0971d7"), Name = "Offer Discount Type" },
                    new EntityCode { Id = Guid.Parse("5ee27a9c-ef7a-4d8c-90be-29007cdc2425"), Name = "Email Verification Types" },
                    new EntityCode { Id = Guid.Parse("0a50e072-8431-46ce-ad96-5972d230f254"), Name = "Reservation Status" },
                    new EntityCode { Id = Guid.Parse("7229ab0f-9a93-42eb-9fac-6343d0eaae72"), Name = "Offer Status" },
                    new EntityCode { Id = Guid.Parse("e53faa3d-7993-4803-98be-dd18319bc1f6"), Name = "Board Type" }
                );
                db.SaveChanges();
            }

            // --- EntityCodeValues ---
            if (!db.EntityCodeValues.Any())
            {
                db.EntityCodeValues.AddRange(
                    // Reservation Status (0a50e072-8431-46ce-ad96-5972d230f254)
                    new EntityCodeValue { Id = Guid.Parse("39f2fffd-d1f6-4bec-a4dd-0c99b4037928"), Name = "Uplaćeno", EntityCodeId = Guid.Parse("0a50e072-8431-46ce-ad96-5972d230f254"), CreatedOn = DateTime.Parse("2025-08-18T01:03:37.8900000"), ModifiedOn = DateTime.Parse("2025-08-18T01:03:37.8900000") },
                    new EntityCodeValue { Id = Guid.Parse("962a3c05-fa18-4183-b0fe-84a3e88fd4aa"), Name = "Otkazano", EntityCodeId = Guid.Parse("0a50e072-8431-46ce-ad96-5972d230f254"), CreatedOn = DateTime.Parse("2025-08-18T16:03:14.7200000"), ModifiedOn = DateTime.Parse("2025-08-18T16:03:27.8730649"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new EntityCodeValue { Id = Guid.Parse("b3ee8a83-4b17-48e4-b547-ad099f03717e"), Name = "Djelimično uplaćeno", EntityCodeId = Guid.Parse("0a50e072-8431-46ce-ad96-5972d230f254"), CreatedOn = DateTime.Parse("2025-08-18T01:03:37.8900000"), ModifiedOn = DateTime.Parse("2025-08-18T01:03:37.8900000") },
                    new EntityCodeValue { Id = Guid.Parse("c55bc19b-7276-416c-8bb1-b7cd78245ac0"), Name = "Nije uplaćeno", EntityCodeId = Guid.Parse("0a50e072-8431-46ce-ad96-5972d230f254"), CreatedOn = DateTime.Parse("2025-08-18T01:03:37.8900000"), ModifiedOn = DateTime.Parse("2025-08-18T01:03:37.8900000") },

                    // Offer Discount Type (bfae64f5-c544-4f93-b193-034f6d0971d7)
                    new EntityCodeValue { Id = Guid.Parse("d7913839-e8d7-4b66-aa66-38e7bf1f86e1"), Name = "Last Minute", EntityCodeId = Guid.Parse("bfae64f5-c544-4f93-b193-034f6d0971d7"), CreatedOn = DateTime.Parse("2025-07-18T00:10:58.4333333"), ModifiedOn = DateTime.Parse("2025-07-18T00:10:58.4333333") },
                    new EntityCodeValue { Id = Guid.Parse("974801dd-fd63-4aa6-af62-7c62186f5db1"), Name = "First Minute", EntityCodeId = Guid.Parse("bfae64f5-c544-4f93-b193-034f6d0971d7"), CreatedOn = DateTime.Parse("2025-07-18T00:10:58.4333333"), ModifiedOn = DateTime.Parse("2025-07-18T00:10:58.4333333") },

                    // Board Type (e53faa3d-7993-4803-98be-dd18319bc1f6)
                    new EntityCodeValue { Id = Guid.Parse("ec1615e7-243c-4193-9d8a-3dbb99956915"), Name = "All inclusive", EntityCodeId = Guid.Parse("e53faa3d-7993-4803-98be-dd18319bc1f6"), CreatedOn = DateTime.Parse("2025-08-05T00:56:36.1566667"), ModifiedOn = DateTime.Parse("2025-08-05T20:28:02.3749103"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new EntityCodeValue { Id = Guid.Parse("f1887801-505d-4071-a506-4ce6308f8edf"), Name = "Polupansion s doručkom", EntityCodeId = Guid.Parse("e53faa3d-7993-4803-98be-dd18319bc1f6"), CreatedOn = DateTime.Parse("2025-07-18T00:48:55.5400000"), ModifiedOn = DateTime.Parse("2025-07-18T00:48:55.5400000") },
                    new EntityCodeValue { Id = Guid.Parse("8da0b8b8-834c-44e0-9f22-5103639fe127"), Name = "Puni pansion", EntityCodeId = Guid.Parse("e53faa3d-7993-4803-98be-dd18319bc1f6"), CreatedOn = DateTime.Parse("2025-07-18T00:48:55.5400000"), ModifiedOn = DateTime.Parse("2025-07-18T00:48:55.5400000") },
                    new EntityCodeValue { Id = Guid.Parse("772decc8-aa46-4574-b2bf-75e2b87659a4"), Name = "Polupansion sa doručkom i večerom", EntityCodeId = Guid.Parse("e53faa3d-7993-4803-98be-dd18319bc1f6"), CreatedOn = DateTime.Parse("2025-08-05T01:09:59.8433333"), ModifiedOn = DateTime.Parse("2025-08-05T01:09:59.8433333"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new EntityCodeValue { Id = Guid.Parse("c9a6519a-2407-4cfe-83d2-96556e0ace76"), Name = "Noćenje", EntityCodeId = Guid.Parse("e53faa3d-7993-4803-98be-dd18319bc1f6"), CreatedOn = DateTime.Parse("2025-08-05T01:05:49.6600000"), ModifiedOn = DateTime.Parse("2025-08-05T01:05:49.6600000"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new EntityCodeValue { Id = Guid.Parse("95499003-7ec1-4b03-9409-ab8e18b31eb7"), Name = "Ultra premium all inclusive", EntityCodeId = Guid.Parse("e53faa3d-7993-4803-98be-dd18319bc1f6"), CreatedOn = DateTime.Parse("2025-08-05T00:59:52.3200000"), ModifiedOn = DateTime.Parse("2025-08-05T00:59:52.3200000"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new EntityCodeValue { Id = Guid.Parse("a852eb17-0f65-43a6-9057-badac69e1045"), Name = "Polupansion", EntityCodeId = Guid.Parse("e53faa3d-7993-4803-98be-dd18319bc1f6"), CreatedOn = DateTime.Parse("2025-07-20T04:37:03.9800000"), ModifiedOn = DateTime.Parse("2025-07-20T04:37:03.9800000"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new EntityCodeValue { Id = Guid.Parse("660afccd-22e0-4a20-b72e-d90a01d8d211"), Name = "Ultra all inclusive", EntityCodeId = Guid.Parse("e53faa3d-7993-4803-98be-dd18319bc1f6"), CreatedOn = DateTime.Parse("2025-08-05T01:12:07.9966667"), ModifiedOn = DateTime.Parse("2025-08-05T01:12:07.9966667"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },

                    // Offer Status (7229ab0f-9a93-42eb-9fac-6343d0eaae72)
                    new EntityCodeValue { Id = Guid.Parse("57c12c77-c593-424d-a481-40becb061b3a"), Name = "Draft", EntityCodeId = Guid.Parse("7229ab0f-9a93-42eb-9fac-6343d0eaae72"), CreatedOn = DateTime.Parse("2025-07-18T00:07:42.2600000"), ModifiedOn = DateTime.Parse("2025-07-18T00:07:42.2600000") },
                    new EntityCodeValue { Id = Guid.Parse("2785e992-531b-40bd-8311-62541ad85b88"), Name = "Otkazana", EntityCodeId = Guid.Parse("7229ab0f-9a93-42eb-9fac-6343d0eaae72"), CreatedOn = DateTime.Parse("2025-07-18T00:07:42.2600000"), ModifiedOn = DateTime.Parse("2025-07-18T00:07:42.2600000") },
                    new EntityCodeValue { Id = Guid.Parse("1126543d-d3cc-4278-a919-68d82d761f95"), Name = "Aktivna", EntityCodeId = Guid.Parse("7229ab0f-9a93-42eb-9fac-6343d0eaae72"), CreatedOn = DateTime.Parse("2025-07-18T00:07:42.2600000"), ModifiedOn = DateTime.Parse("2025-07-18T00:07:42.2600000") },

                    // Email Verification Types (5ee27a9c-ef7a-4d8c-90be-29007cdc2425)
                    new EntityCodeValue { Id = Guid.Parse("f20d5a32-e3af-4b29-9431-6bb1a9726b79"), Name = "Email verification", EntityCodeId = Guid.Parse("5ee27a9c-ef7a-4d8c-90be-29007cdc2425"), CreatedOn = DateTime.Parse("2025-07-06T01:38:42.6233333"), ModifiedOn = DateTime.Parse("2025-07-06T01:38:42.6233333") },
                    new EntityCodeValue { Id = Guid.Parse("114ef7b1-2d3c-402a-bb74-9c49cdfd3d42"), Name = "Reset password", EntityCodeId = Guid.Parse("5ee27a9c-ef7a-4d8c-90be-29007cdc2425"), CreatedOn = DateTime.Parse("2025-07-12T15:30:50.6000000"), ModifiedOn = DateTime.Parse("2025-07-12T15:30:50.6000000") }
                );
                db.SaveChanges();
            }

            // --- RoomTypes ---
            if (!db.RoomTypes.Any())
            {
                db.RoomTypes.AddRange(
                    new RoomType { Id = Guid.Parse("c16d3c06-f875-4b80-8212-75b3eec12601"), Name = "Četverokrevetna", RoomCapacity = 4, CreatedOn = DateTime.Parse("2025-07-18T20:04:09.7400000"), ModifiedOn = DateTime.Parse("2025-07-18T20:04:09.7400000") },
                    new RoomType { Id = Guid.Parse("c4b38c29-968a-49b5-95a0-7bb66436c403"), Name = "Dvokrevetna", RoomCapacity = 2, CreatedOn = DateTime.Parse("2025-07-18T20:04:09.7400000"), ModifiedOn = DateTime.Parse("2025-07-18T20:04:09.7400000") },
                    new RoomType { Id = Guid.Parse("dfe05a3e-80d8-467e-83a5-a103e5eb583a"), Name = "Jednokrevetna", RoomCapacity = 1, CreatedOn = DateTime.Parse("2025-07-20T04:50:56.5800000"), ModifiedOn = DateTime.Parse("2025-07-20T04:51:37.5410229"), CreatedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785"), ModifiedBy = Guid.Parse("ae8f4cc0-6e84-41cc-b34a-a5ae8221e785") },
                    new RoomType { Id = Guid.Parse("a57611c4-2585-44c3-a551-b6d080df682d"), Name = "Trokrevetna", RoomCapacity = 3, CreatedOn = DateTime.Parse("2025-07-18T20:04:09.7400000"), ModifiedOn = DateTime.Parse("2025-07-18T20:04:09.7400000") }
                );
                db.SaveChanges();
            }

            // --- Roles ---
            if (!db.Roles.Any())
            {
                db.Roles.AddRange(
                    new Role { Id = Guid.Parse("ecc8e410-5e61-493e-a99e-51ade8e1aa1d"), Name = "Admin" },
                    new Role { Id = Guid.Parse("f193f30a-7406-4e10-b226-dde0ee5f5e57"), Name = "Client" }
                );
                db.SaveChanges();
            }

            // --- Users ---
            if (!db.Users.Any())
            {
                PasswordHasher<User> passwordHasher = new PasswordHasher<User>();

                var userDesktop = new User
                {
                    Id = Guid.NewGuid(),
                    FirstName = "Desktop",
                    LastName = "Test",
                    Username = "desktop",
                    PhoneNumber = "000000000",
                    Email = "izmijeniti_email@gmail.com",
                    IsActive = true,
                    IsVerified = true,
                    Roles = db.Roles.Where(x => x.Name == "Admin").ToList()
                };

                userDesktop.PasswordHash = passwordHasher.HashPassword(userDesktop, "test");

                var userMobile = new User
                {
                    Id = Guid.NewGuid(),
                    FirstName = "Mobile",
                    LastName = "Test",
                    Username = "mobile",
                    PhoneNumber = "111111111",
                    Email = "email_izmijeniti@gmail.com",
                    IsActive = true,
                    IsVerified = true,
                    Roles = db.Roles.Where(x => x.Name == "Client").ToList()
                };

                userMobile.PasswordHash = passwordHasher.HashPassword(userDesktop, "test");

                db.Users.AddRange(userDesktop, userMobile);
                db.SaveChanges();
            }
        }
    }
}