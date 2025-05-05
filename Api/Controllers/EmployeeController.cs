using EmployeeManagement.Models;
using EmployeeManagement.Service.Contract;
using Microsoft.AspNetCore.Mvc;

namespace EmployeeManagement.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        private readonly IEmployeeService _employeeService;

        public EmployeeController(IEmployeeService employeeService)
        {
            _employeeService = employeeService;
        }


        [HttpGet]
        [Route("employees")]
        public async Task<ActionResult<IEnumerable<EmployeeDetails>>> GetEmployeeDetailsAsync(string? searchTerm)
        {
            return Ok(await _employeeService.GetEmployeeListAsync(searchTerm));
        }


        [HttpGet]
        [Route("positions")]
        public async Task<ActionResult<IEnumerable<PositionDetails>>> GetPositionDetailsAsync(string? searchTerm)
        {
            return Ok(await _employeeService.GetPositionDetailsAsync());
        }

        [HttpGet]
        [Route("hasSSN")]
        public async Task<ActionResult<bool>> HasSSNNumberAsync(string ssn)
        {
            return Ok(await this._employeeService.HasSSNNumberAsync(ssn));
        }

        [HttpPost]
        [Route("employees")]
        public async Task<ActionResult<EmployeeDetails>> AddEmployeeDetailsAsync(EmployeeDetails employeeDetails)
        {
            return await _employeeService.AddEmployeeAsync(employeeDetails);
        }
    }
}
