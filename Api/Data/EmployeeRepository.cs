using Dapper;
using EmployeeManagement.Data.Contract;
using EmployeeManagement.Models;
using Microsoft.IdentityModel.Tokens;
using System.Data;

namespace EmployeeManagement.Data
{
    public class EmployeeRepository: IEmployeeRepository
    {
        private readonly string _connectionString;
        public EmployeeRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public IDbConnection GetConnection()
        {
            return new Microsoft.Data.SqlClient.SqlConnection(this._connectionString);
        }

        public async Task<IEnumerable<EmployeeDetails>> GetEmployeeListAsync(string? search)
        {
            using(IDbConnection connection = this.GetConnection())
            {
                string query = @"SELECT es.Employeeid, Name, ssn, dob, address, city, state, 
                        zip, phone, joinDate, ExitDate, es.title as currentTitle, 
                        es.salary as currentSalary, es.fromdate, es.todate
                    FROM employee e
                    LEFT JOIN employeeSalary es ON es.EmployeeID = e.EmployeeID
                    WHERE (es.toDate IS NULL OR es.todate >= @today) AND 
                        (@searchterm IS NULL OR (e.name like @searchterm OR es.title like @searchterm ))";

                return await connection.QueryAsync<EmployeeDetails>(query, new
                {
                    searchTerm = search.IsNullOrEmpty() ? null : $"%{search}%",
                    today = System.DateTime.UtcNow
                }, commandType: CommandType.Text);
            }
        }

        public async Task<IEnumerable<PositionDetails>> GetPositionDetailsAsync()
        {
            using(IDbConnection connection = this.GetConnection())
            {
                string query = @"SELECT Title, MAX(SALARY) as MaxSalary, MIN(SALARY) as MinSalary
                    FROM EmployeeSalary
                    GROUP BY title";

                return await connection.QueryAsync<PositionDetails>(query, commandType: CommandType.Text);
            }
        }

        public async Task<EmployeeDetails> AddEmployeeAsync(EmployeeDetails employeeData)
        {
            using(IDbConnection connection = this.GetConnection())
            {
                connection.Open();

                IDbTransaction transaction = connection.BeginTransaction();

                string insertEmployeeQuery = @"INSERT INTO Employee (Name, SSN, DOB, Address, 
                        City, State, Zip, Phone, JoinDate) OUTPUT INSERTED.EmployeeID 
                    VALUES (@Name, @SSN, @DOB, @Address, @City, @State, @Zip, @Phone, 
                        @JoinDate);";

                string insertSalaryQuery = @"INSERT INTO EmployeeSalary (EmployeeId, Title, 
                        FromDate, ToDate, Salary) VALUES (@EmployeeId, @CurrentTitle, @JoinDate, NULL, @currentSalary)";

                string selectQuery = @"SELECT es.Employeeid, Name, ssn, dob, address, city, state, 
                        zip, phone, joinDate, ExitDate, es.title as currentTitle, 
                        es.salary as currentSalary, es.fromdate, es.todate
                    FROM employee e
                    LEFT JOIN employeeSalary es ON es.EmployeeID = e.EmployeeID
                    WHERE e.EmployeeID = @employeeId;";

                try
                {
                    int id = await connection.ExecuteScalarAsync<int>(insertEmployeeQuery, employeeData,  transaction:transaction, 
                        commandType: CommandType.Text);
                    employeeData.EmployeeId = id;

                    await connection.ExecuteAsync(insertSalaryQuery, employeeData, transaction: transaction, 
                        commandType: CommandType.Text);

                    var data = await connection.QuerySingleOrDefaultAsync<EmployeeDetails>(selectQuery, new
                    {
                        employeeId = id,
                    }, transaction: transaction, commandType: CommandType.Text);

                    transaction.Commit();

                    return data;
                }
                catch (Exception e)
                {
                    transaction.Rollback();
                    throw e;
                }
                finally
                {
                    transaction.Dispose();
                }
            }
        }
    }
}
