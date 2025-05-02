
-- Create Employee table 
CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    SSN CHAR(11) NOT NULL UNIQUE,
    DOB DATE NOT NULL
        CHECK (DOB BETWEEN DATEADD(YEAR, -64, GETDATE()) 
                      AND DATEADD(YEAR, -22, GETDATE())),
    Address NVARCHAR(200) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    State CHAR(2) NOT NULL,
    Zip CHAR(10) NOT NULL, 
    Phone VARCHAR(20) NOT NULL,
    JoinDate DATE NOT NULL,
    ExitDate DATE NULL,
    CONSTRAINT CHK_EmployeeDates 
        CHECK (ExitDate IS NULL OR ExitDate >= JoinDate)
);

GO

-- Create EmployeeSalary table without subquery constraint
CREATE TABLE EmployeeSalary (
    SalaryID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    FromDate DATE NOT NULL,
    ToDate DATE NULL,
    Title NVARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    
    CONSTRAINT UQ_EmployeeSalary_Period 
        UNIQUE (EmployeeID, FromDate),
    
    CONSTRAINT CHK_SalaryPeriod 
        CHECK (ToDate IS NULL OR ToDate > FromDate),
    
    FOREIGN KEY (EmployeeID) 
        REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE
);
GO

-- Index for Title - useful for queries filtering employee based on name
CREATE NONCLUSTERED INDEX IX_Employee_Name ON Employee(Name);
GO

-- Index for Title - useful for queries analyzing job titles
CREATE NONCLUSTERED INDEX IX_EmployeeSalary_Title ON EmployeeSalary(Title);
GO

-- Index for current salary records (where ToDate is NULL)
CREATE NONCLUSTERED INDEX IX_EmployeeSalary_Current
ON EmployeeSalary(EmployeeID, Salary)
WHERE ToDate IS NULL;

