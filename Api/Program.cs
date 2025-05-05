
using EmployeeManagement.Data;
using EmployeeManagement.Data.Contract;
using EmployeeManagement.Service;
using EmployeeManagement.Service.Contract;
using Microsoft.Extensions.DependencyInjection;

namespace EmployeeManagement
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            var epConnectionString = builder.Configuration.GetConnectionString("EmployeeConnectionString");

            #region DI

            builder.Services
                .AddScoped<IEmployeeRepository>(s => new EmployeeRepository(epConnectionString))
                .AddScoped<IEmployeeService, EmployeeService>();

            #endregion

            builder.Services.AddCors();


            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseCors(policy =>
            {
                policy.WithOrigins("http://localhost:4200", "https://krunal12345.github.io")
                    .AllowAnyHeader()
                    .AllowAnyMethod();
            });

            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
