using System;
using System.Reflection;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;

namespace eTouristAgencyAPI.Services
{
    public class EmailContentService : IEmailContentService
    {
        private readonly string PATH_TO_DIRECTORY = "eTouristAgencyAPI.Services.EmailTemplates.EmailContents";

        public async Task<string> GetReservationStatusChangeTitleAsync()
        {
            var assembly = Assembly.GetExecutingAssembly();
            var htmlResourceName = $"{PATH_TO_DIRECTORY}.reservationStatusChangeTitle.html";

            using var textStream = assembly.GetManifestResourceStream(htmlResourceName);
            using var textReader = new StreamReader(textStream);
            string text = await textReader.ReadToEndAsync();

            return text;
        }

        public async Task<string> GetReservationStatusChangeTextAsync(Reservation reservation)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var htmlResourceName = $"{PATH_TO_DIRECTORY}.reservationStatusChangeText.html";

            using var textStream = assembly.GetManifestResourceStream(htmlResourceName);
            using var textReader = new StreamReader(textStream);
            string text = await textReader.ReadToEndAsync();

            text = text.Replace("{FullName}", $"{reservation.User.FirstName} {reservation.User.LastName}");
            text = text.Replace("{ReservationNo}", reservation.ReservationNo.ToString());
            text = text.Replace("{ReservationStatus}", reservation.ReservationStatus.Name);
            text = text.Replace("{PaidAmount}", reservation.PaidAmount.ToString("N2"));
            text = text.Replace("{TotalCost}", reservation.TotalCost.ToString("N2"));

            return text;
        }

        public async Task<string> GetEmailVerificationTitleAsync()
        {
            var assembly = Assembly.GetExecutingAssembly();
            var htmlResourceName = $"{PATH_TO_DIRECTORY}.emailVerificationTitle.html";

            using var textStream = assembly.GetManifestResourceStream(htmlResourceName);
            using var textReader = new StreamReader(textStream);
            string text = await textReader.ReadToEndAsync();

            return text;
        }

        public async Task<string> GetEmailVerificationTextAsync(string firstName, string lastName, string verificationKey)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var htmlResourceName = $"{PATH_TO_DIRECTORY}.emailVerificationText.html";

            using var textStream = assembly.GetManifestResourceStream(htmlResourceName);
            using var textReader = new StreamReader(textStream);
            string text = await textReader.ReadToEndAsync();

            text = text.Replace("{FullName}", $"{firstName} {lastName}");
            text = text.Replace("{VerificationKey}", verificationKey);

            return text;
        }

        public async Task<string> GetResetPasswordTitleAsync()
        {
            var assembly = Assembly.GetExecutingAssembly();
            var htmlResourceName = $"{PATH_TO_DIRECTORY}.resetPasswordTitle.html";

            using var textStream = assembly.GetManifestResourceStream(htmlResourceName);
            using var textReader = new StreamReader(textStream);
            string text = await textReader.ReadToEndAsync();

            return text;
        }

        public async Task<string> GetResetPasswordTextAsync(string firstName, string lastName, string verificationKey)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var htmlResourceName = $"{PATH_TO_DIRECTORY}.resetPasswordText.html";

            using var textStream = assembly.GetManifestResourceStream(htmlResourceName);
            using var textReader = new StreamReader(textStream);
            string text = await textReader.ReadToEndAsync();

            text = text.Replace("{FullName}", $"{firstName} {lastName}");
            text = text.Replace("{VerificationKey}", verificationKey);

            return text;
        }

        public async Task<string> GetOfferRecommendationTitleAsync(Offer offer)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var htmlResourceName = $"{PATH_TO_DIRECTORY}.offerRecommendationTitle.html";

            using var textStream = assembly.GetManifestResourceStream(htmlResourceName);
            using var textReader = new StreamReader(textStream);
            string text = await textReader.ReadToEndAsync();

            text = text.Replace("{OfferShortDescription}", $"{offer.Hotel.City.Name} -> {offer.TripStartDate.ToString("dd.MM.yyyy")} - {offer.TripEndDate.ToString("dd.MM.yyyy")}");

            return text;
        }

        public async Task<string> GetOfferRecommendationTextAsync(Offer offer)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var htmlResourceName = $"{PATH_TO_DIRECTORY}.offerRecommendationText.html";

            using var textStream = assembly.GetManifestResourceStream(htmlResourceName);
            using var textReader = new StreamReader(textStream);
            string text = await textReader.ReadToEndAsync();

            var pricePerPerson = offer.Rooms.Min(x => x.PricePerPerson);
            var offerDiscount = offer.OfferDiscounts.FirstOrDefault(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeFirstMinute);
            var discount = offerDiscount?.Discount ?? 0;
            var minPrice = pricePerPerson - (pricePerPerson * (discount / 100));

            text = text.Replace("{HotelName}", offer.Hotel.Name);
            text = text.Replace("{CityName}", offer.Hotel.City.Name);
            text = text.Replace("{CountryName}", offer.Hotel.City.Country.Name);
            text = text.Replace("{OfferDateFrom}", offer.TripStartDate.ToString("dd.MM.yyyy"));
            text = text.Replace("{OfferDateTo}", offer.TripEndDate.ToString("dd.MM.yyyy"));
            text = text.Replace("{OfferPrice}", minPrice.ToString("N2"));
            text = text.Replace("{ShortDescription}", offer.Description);

            return text;
        }

        public async Task<string> GetGeneratedPasswordTitleAsync()
        {
            var assembly = Assembly.GetExecutingAssembly();
            var htmlResourceName = $"{PATH_TO_DIRECTORY}.generatedPasswordTitle.html";

            using var textStream = assembly.GetManifestResourceStream(htmlResourceName);
            using var textReader = new StreamReader(textStream);
            string text = await textReader.ReadToEndAsync();

            return text;
        }

        public async Task<string> GetGeneratedPasswordTextAsync(string generatedPassword)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var htmlResourceName = $"{PATH_TO_DIRECTORY}.generatedPasswordText.html";

            using var textStream = assembly.GetManifestResourceStream(htmlResourceName);
            using var textReader = new StreamReader(textStream);
            string text = await textReader.ReadToEndAsync();

            text = text.Replace("{Password}", generatedPassword);

            return text;
        }
    }
}
