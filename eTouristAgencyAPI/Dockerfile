# Baza za runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5000 5001
ENV ASPNETCORE_URLS=https://+:5000;http://+:5001

# SDK za build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .

# Build API
WORKDIR /src/eTouristAgencyAPI
RUN dotnet restore "eTouristAgencyAPI.csproj"
RUN dotnet build "eTouristAgencyAPI.csproj" -c Release -o /app/build

# Build Notifications CLI
WORKDIR /src/eTouristAgencyAPI.Notifications
RUN dotnet restore "eTouristAgencyAPI.Notifications.csproj"
RUN dotnet build "eTouristAgencyAPI.Notifications.csproj" -c Release -o /app/notifications_build

# Publish API
FROM build AS publish
WORKDIR /src/eTouristAgencyAPI
RUN dotnet publish "eTouristAgencyAPI.csproj" -c Release -o /app

# Final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app .  
COPY --from=build /app/notifications_build ./Notifications

# Pokretanje API po defaultu (CLI se može pokrenuti posebno kroz docker-compose)
ENTRYPOINT ["dotnet","eTouristAgencyAPI.dll"]