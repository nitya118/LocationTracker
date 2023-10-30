using LocationTrackerLib.Services;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.Identity.Web;

namespace LocationTracker
{
    /**
     * Applying Azure AD authentication to a .net core app
     * https://www.faciletechnolab.com/blog/2021/4/13/how-to-implement-azure-ad-authentication-in-aspnet-core-50-web-application
     *
     * Adding back the startup class for a .net core 6.0 app
     * https://www.c-sharpcorner.com/article/how-to-add-startup-cs-class-in-asp-net-core-6-project/
     */

    public class Startup
    {
        public IConfiguration configRoot
        {
            get;
        }

        public Startup(IConfiguration configuration)
        {
            configRoot = configuration;
        }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddAuthentication(OpenIdConnectDefaults.AuthenticationScheme)
          .AddMicrosoftIdentityWebApp(configRoot.GetSection("AzureAd"));

            services.AddControllersWithViews(options =>
            {
                var policy = new AuthorizationPolicyBuilder()
                    .RequireAuthenticatedUser()
                    .Build();
                options.Filters.Add(new AuthorizeFilter(policy));
            });

            services.AddRazorPages();

            services.AddSingleton<ILocationReportDataService, DdbLocationReportDataService>();

            services.AddSingleton<IUserDataService, DdbUserService>();

            services.AddSingleton<IGeoService, GeoService>();

            services.AddSingleton<ITimeService, TimeService>();

            services.AddSingleton<ISmsNotifier, SmsNotifier>();

            services.AddSingleton<IParameterStoreService, ParameterStoreService>();

            services.AddSingleton<IConfiguration>(provider => configRoot);
        }

        public void Configure(WebApplication app, IWebHostEnvironment env)
        {
            //if (!app.Environment.IsDevelopment())
            //{
            //    app.UseExceptionHandler("/Error");
            //    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
            //    app.UseHsts();
            //}
            //app.UseHttpsRedirection();
            //app.UseStaticFiles();
            //app.UseRouting();
            //app.UseAuthorization();
            //app.MapRazorPages();
            //app.Run();

            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Home/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseCookiePolicy(new CookiePolicyOptions
            {
                Secure = CookieSecurePolicy.Always
            });

            //app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthentication();

            app.UseAuthorization();

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}/{id?}");

            app.Run();
        }
    }
}