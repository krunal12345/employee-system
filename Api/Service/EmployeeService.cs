using EmployeeManagement.Data.Contract;
using EmployeeManagement.Models;
using EmployeeManagement.Service.Contract;

namespace EmployeeManagement.Service
{
    public class EmployeeService: IEmployeeService
    {
        private readonly IEmployeeRepository _employeeRepository;

        public EmployeeService(IEmployeeRepository employeeRepository) {
            _employeeRepository = employeeRepository;
        }

        public async Task<IEnumerable<EmployeeDetails>> GetEmployeeListAsync(string? search)
        {
            return await this._employeeRepository.GetEmployeeListAsync(search);
        }

        public async Task<IEnumerable<PositionDetails>> GetPositionDetailsAsync()
        {
            return await this._employeeRepository.GetPositionDetailsAsync();
        }

        public async Task<EmployeeDetails> AddEmployeeAsync(EmployeeDetails employeeData)
        {
            return await this._employeeRepository.AddEmployeeAsync(employeeData);
        }

        public async Task<bool> HasSSNNumberAsync(string ssn)
        {
            return await this._employeeRepository.HasSSNNumberAsync(ssn);
        }
    }
}
