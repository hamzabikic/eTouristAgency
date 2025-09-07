namespace eTouristAgencyAPI.Services.Helpers
{
    public static class VerificationCodeGenerator
    {
        public static string GenerateVerificationCode()
        {
            var random = new Random();
            string chars = "qwertzuiopasdfghjklyxcvbnm1234567890".ToUpper();
            string code = "";

            for (int i = 0; i < 6; i++)
            {
                code += chars[random.Next(0, chars.Length)];
            }

            return code;
        }
    }
}