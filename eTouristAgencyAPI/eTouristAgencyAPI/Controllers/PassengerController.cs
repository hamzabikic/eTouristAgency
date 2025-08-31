using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    [Route("api/[controller]")]
    public class PassengerController : ControllerBase
    {
        private readonly IPassengerService _passengerService;

        public PassengerController(IPassengerService passengerService)
        {
            _passengerService = passengerService;
        }

        [HttpGet("{id}/document")]
        public async Task<ActionResult> GetDocumentById(Guid id)
        {
            try
            {
                var passengerDocument = await _passengerService.GetDocumentByIdAsync(id);

                Response.Headers.Add("DocumentName", passengerDocument.DocumentName);
                return File(passengerDocument.DocumentBytes, "application/octet-stream", passengerDocument.DocumentName);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
