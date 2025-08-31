using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Enums;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VerificationCodeController : ControllerBase
    {
        private readonly IVerificationCodeService _emailVerificationService;

        public VerificationCodeController(IVerificationCodeService emailVerificationService)
        {
            _emailVerificationService = emailVerificationService;
        }

        [Authorize(Roles = Roles.Client)]
        [HttpPost("email-verification")]
        public async Task<ActionResult> SendEmailVerificationCode()
        {
            try
            {
                await _emailVerificationService.AddVerificationCodeAsync(EmailVerificationType.EmailVerification);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [AllowAnonymous]
        [HttpPost("reset-password")]
        public async Task<ActionResult> SendPasswordVerificationCode([FromQuery] string email)
        {
            try
            {
                await _emailVerificationService.AddVerificationCodeAsync(EmailVerificationType.ResetPassword, email);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [AllowAnonymous]
        [HttpGet("reset-password/exists")]
        public async Task<ActionResult<bool>> PasswordVerificationCodeExists([FromQuery] string verificationKey)
        {
            try
            {
                var result = await _emailVerificationService.PasswordVerificationCodeExists(verificationKey);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
