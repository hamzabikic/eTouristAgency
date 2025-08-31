using eTouristAgencyAPI.Authentication;
using eTouristAgencyAPI.InitialData;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.IoC;
using Mapster;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddDbContext<eTouristAgencyDbContext>(x => x.UseSqlServer(builder.Configuration.GetConnectionString("DbConnection")));
builder.Services.AddAuthentication().AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", options => { });
builder.Services.AddHttpContextAccessor();
builder.Services.AddMapster();
builder.Services.AddConfiguration(builder.Configuration);
builder.Services.AddServices();

builder.Services.AddControllers(options =>
{
    options.Filters.Add(new AuthorizeFilter());
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "eTouristAgencyAPI", Version = "v1" });
    c.AddSecurityDefinition("basic", new OpenApiSecurityScheme
    {
        Name = "Authorization", //name of header variable
        Type = SecuritySchemeType.Http,
        Scheme = "basic",
        In = ParameterLocation.Header,
        Description = "Basic Authorization header using the Bearer scheme."
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                          new OpenApiSecurityScheme
                            {
                                Reference = new OpenApiReference
                                {
                                    Type = ReferenceType.SecurityScheme,
                                    Id = "basic"
                                }
                            },
                            new string[] {}
                    }
                });
});

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();

//var retry = 0;
//var maxRetry = 10;
//while (retry < maxRetry)
//{
//    try
//    {
//        using var scope = app.Services.CreateScope();
//        var db = scope.ServiceProvider.GetRequiredService<eTouristAgencyDbContext>();

//        db.Database.Migrate();
//        DatabaseSeeder.SeedDatabase(db);
//        break;
//    }
//    catch (SqlException)
//    {
//        retry++;
//        Thread.Sleep(5000);
//    }
//}

app.UseSwagger();
app.UseSwaggerUI();

app.UseCors();

app.UseAuthorization();

app.MapControllers();

app.Run();
