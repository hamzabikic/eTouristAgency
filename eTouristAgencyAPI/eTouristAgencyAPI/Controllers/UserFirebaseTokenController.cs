using System.ComponentModel.DataAnnotations;
using Azure.Core;
using eTouristAgencyAPI.Models.RequestModels.UserFirebaseToken;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    [Route("api/[controller]")]
    [Authorize(Roles = Roles.Client)]
    public class UserFirebaseTokenController : ControllerBase
    {
        private readonly IUserFirebaseTokenService _userFirebaseTokenService;

        public UserFirebaseTokenController(IUserFirebaseTokenService userFirebaseTokenService)
        {
            _userFirebaseTokenService = userFirebaseTokenService;
        }

        [HttpPost]
        public async Task<ActionResult> Add([FromBody] AddUserFirebaseTokenRequest request)
        {
            try
            {
                await _userFirebaseTokenService.AddAsync(request);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPatch]
        public async Task<ActionResult> UpdateToken([FromBody] UpdateUserFirebaseTokenRequest request)
        {
            try
            {
                await _userFirebaseTokenService.UpdateAsync(request);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpDelete] 
        public async Task<ActionResult> Delete([FromQuery][Required] string firebaseToken)
        {
            try
            {
                await _userFirebaseTokenService.DeleteAsync(firebaseToken);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
