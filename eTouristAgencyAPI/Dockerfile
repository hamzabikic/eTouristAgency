# Baza za runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5000 5001

# SDK za build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .

# Build API
WORKDIR /src/eTouristAgencyAPI
RUN dotnet restore "eTouristAgencyAPI.csproj"
RUN dotnet publish "eTouristAgencyAPI.csproj" -c Release -o /app/api

# Build Notifications CLI
WORKDIR /src/eTouristAgencyAPI.Notifications
RUN dotnet restore "eTouristAgencyAPI.Notifications.csproj"
RUN dotnet publish "eTouristAgencyAPI.Notifications.csproj" -c Release -o /app/notifications

# Stvori certifikat u SDK stage
RUN dotnet dev-certs https -ep /app/aspnetapp.pfx -p YourPassword123

# Final image
FROM base AS final
WORKDIR /app
COPY --from=build /app/api .
COPY --from=build /app/notifications ./Notifications
COPY --from=build /app/aspnetapp.pfx ./aspnetapp.pfx

ENV ASPNETCORE_Kestrel__Certificates__Default__Password="YourPassword123"
ENV ASPNETCORE_Kestrel__Certificates__Default__Path="/app/aspnetapp.pfx"

ENTRYPOINT ["dotnet", "eTouristAgencyAPI.dll"]