using EmployeeManagement.Models;

namespace EmployeeManagement.Data.Contract
{
    public interface IEmployeeRepository
    {
        public Task<IEnumerable<EmployeeDetails>> GetEmployeeListAsync(string? search);
        public Task<IEnumerable<PositionDetails>> GetPositionDetailsAsync();
        public Task<EmployeeDetails> AddEmployeeAsync(EmployeeDetails employeeData);

    }
}
