namespace eTouristAgencyAPI.Services.Helpers
{
    public static class PasswordGenerator
    {
        public static string GeneratePassword()
        {
            var random = new Random();
            string chars = "qwertzuiopasdfghjklyxcvbnm.,-!#$%&/()=?*1234567890";
            string password = "";

            for (int i = 0; i < 8; i++)
            {
                password += chars[random.Next(0, chars.Length)];
            }

            return password;
        }
    }
}
