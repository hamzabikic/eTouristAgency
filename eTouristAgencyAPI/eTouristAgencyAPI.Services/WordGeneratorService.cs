using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Xceed.Document.NET;
using Xceed.Words.NET;

namespace eTouristAgencyAPI.Services
{
    public class WordGeneratorService : IWordGeneratorService
    {
        public byte[] GetPassengerListDocument(Offer offer)
        {
            var passengers = new List<Passenger>();

            foreach (var room in offer.Rooms)
            {
                foreach (var reservation in room.Reservations.Where(x=> x.ReservationStatusId == AppConstants.FixedReservationStatusPaid))
                {
                    passengers.AddRange(reservation.Passengers);
                }
            }

            using (var ms = new MemoryStream())
            {
                using (var doc = DocX.Create(ms))
                {
                    var title = doc.InsertParagraph($"Spisak putnika za putovanje br. {offer.OfferNo}")
                                   .FontSize(12)
                                   .Bold()
                                   .Alignment = Alignment.center;

                    doc.InsertParagraph().SpacingAfter(20);

                    var table = doc.AddTable(passengers.Count + 1, 3);
                    table.Design = TableDesign.TableGrid;
                    table.SetWidthsPercentage(new float[] { 50f, 25f, 25f }, doc.PageWidth - doc.MarginLeft - doc.MarginRight);

                    table.Rows[0].Cells[0].Paragraphs[0].Append("Ime i prezime")
                                                        .Bold()
                                                        .SpacingBefore(10)
                                                        .SpacingAfter(10);

                    table.Rows[0].Cells[1].Paragraphs[0].Append("Datum rođenja")
                                                        .Bold()
                                                        .SpacingBefore(10)
                                                        .SpacingAfter(10);
                    
                    table.Rows[0].Cells[2].Paragraphs[0].Append("Broj telefona")
                                                        .Bold()
                                                        .SpacingBefore(10)
                                                        .SpacingAfter(10);

                    for (int i = 0; i < passengers.Count; i++)
                    {
                        table.Rows[i + 1].Cells[0].Paragraphs[0].Append(passengers[i].FullName)
                                                                .SpacingBefore(10)
                                                                .SpacingAfter(10);

                        table.Rows[i + 1].Cells[1].Paragraphs[0].Append(passengers[i].DateOfBirth.ToString("dd.MM.yyyy"))
                                                                .SpacingBefore(10)
                                                                .SpacingAfter(10);

                        table.Rows[i + 1].Cells[2].Paragraphs[0].Append(passengers[i].PhoneNumber)
                                                                .SpacingBefore(10)
                                                                .SpacingAfter(10);
                    }

                    doc.InsertTable(table);
                    doc.Save();
                }

                return ms.ToArray();
            }
        }
    }
}
