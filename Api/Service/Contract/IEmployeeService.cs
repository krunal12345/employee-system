using EmployeeManagement.Models;

namespace EmployeeManagement.Service.Contract
{
    public interface IEmployeeService
    {
        public Task<IEnumerable<EmployeeDetails>> GetEmployeeListAsync(string? search);
        public Task<IEnumerable<PositionDetails>> GetPositionDetailsAsync();
        public Task<EmployeeDetails> AddEmployeeAsync(EmployeeDetails employeeData);
    }
}
