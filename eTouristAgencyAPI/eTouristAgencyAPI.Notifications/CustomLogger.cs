namespace eTouristAgencyAPI.Notifications
{
    public static class CustomLogger
    {
        public static string GetFilePath()
        {
            var pathToFolder = Path.Combine(Directory.GetCurrentDirectory(), "..", "..", "..", "Logs");

            if (!Directory.Exists(pathToFolder))
                Directory.CreateDirectory(pathToFolder);

            var fileName = $"log_{DateTime.Now.ToString("dd-MM-yyyy")}.txt";

            return Path.Combine(pathToFolder, fileName);
        }

        public static async Task LogError(string message)
        {
            var pathToFile = GetFilePath();
            var text = $"{DateTime.Now.ToString("dd.MM.yyyy HH:mm:ss")} - ERROR - {message}{Environment.NewLine}{Environment.NewLine}";

            await File.AppendAllTextAsync(pathToFile, text);
        }

        public static async Task LogInfo(string message)
        {
            var pathToFile = GetFilePath();
            var text = $"{DateTime.Now.ToString("dd.MM.yyyy HH:mm:ss")} - INFO - {message}{Environment.NewLine}{Environment.NewLine}";

            await File.AppendAllTextAsync(pathToFile, text);
        }
    }
}
