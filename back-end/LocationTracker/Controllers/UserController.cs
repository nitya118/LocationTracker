using LocationTrackerLib.Models;
using LocationTrackerLib.Services;
using Microsoft.AspNetCore.Mvc;

namespace LocationTracker.Controllers
{
    public class UserController : Controller
    {
        private readonly IUserDataService _userDataService;

        public UserController(IUserDataService userDataService)
        {
            _userDataService = userDataService;
        }

        public IActionResult Index()
        {
            return View("~/Views/Home/User.cshtml");
        }

        [HttpGet]
        public async Task<JsonResult> GetUsers()
        {
            var users = await _userDataService.GetUsers();

            return Json(users);
        }

        [HttpGet]
        public async Task<JsonResult> GetUser(string username)
        {
            var user = await _userDataService.LoadUser(username);

            return Json(user);
        }


        [HttpPost]
        public async Task<IActionResult> SaveUser([FromBody] User user)
        {
            if (string.IsNullOrEmpty(user.UserName))
            {
                return BadRequest("");
            }
            
            await _userDataService.SaveUser(user);

            return Ok();
        }


        [HttpPost]
        public async Task<IActionResult> DeleteUser(string username)
        {
            var user=await _userDataService.LoadUser(username);

            await _userDataService.DeleteUser(user);    

            return Ok();
        }


    }
}