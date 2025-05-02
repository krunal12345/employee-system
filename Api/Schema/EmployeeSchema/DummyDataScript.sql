-- SQL Server Data Generation Script for Employee and EmployeeSalary tables
-- This script will create 200 realistic employee records with at least one salary record each

SET NOCOUNT ON;

-- Clear existing data if needed
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EmployeeSalary')
BEGIN
    DELETE FROM EmployeeSalary;
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Employee')
BEGIN
    DELETE FROM Employee;
END

-- Declare variables to store names and other data
DECLARE @FirstNames TABLE (FirstName NVARCHAR(50));
DECLARE @LastNames TABLE (LastName NVARCHAR(50));
DECLARE @Streets TABLE (Street NVARCHAR(100));
DECLARE @Cities TABLE (City NVARCHAR(100), State CHAR(2), ZipPrefix CHAR(3));
DECLARE @JobTitles TABLE (Title NVARCHAR(50), BaseSalary DECIMAL(10,2));

-- Insert sample first names (100 diverse names)
INSERT INTO @FirstNames VALUES 
('James'), ('Mary'), ('Robert'), ('Patricia'), ('John'), ('Jennifer'), ('Michael'), ('Linda'), ('William'), ('Elizabeth'),
('David'), ('Susan'), ('Richard'), ('Jessica'), ('Joseph'), ('Sarah'), ('Thomas'), ('Karen'), ('Charles'), ('Nancy'),
('Christopher'), ('Lisa'), ('Daniel'), ('Margaret'), ('Matthew'), ('Betty'), ('Anthony'), ('Sandra'), ('Mark'), ('Ashley'),
('Donald'), ('Emily'), ('Steven'), ('Kimberly'), ('Paul'), ('Donna'), ('Andrew'), ('Michelle'), ('Joshua'), ('Carol'),
('Kenneth'), ('Amanda'), ('Kevin'), ('Dorothy'), ('Brian'), ('Melissa'), ('George'), ('Deborah'), ('Timothy'), ('Stephanie'),
('Ronald'), ('Rebecca'), ('Edward'), ('Sharon'), ('Jason'), ('Laura'), ('Jeffrey'), ('Cynthia'), ('Ryan'), ('Kathleen'),
('Jacob'), ('Amy'), ('Gary'), ('Angela'), ('Nicholas'), ('Shirley'), ('Eric'), ('Brenda'), ('Jonathan'), ('Emma'),
('Stephen'), ('Anna'), ('Larry'), ('Pamela'), ('Justin'), ('Nicole'), ('Scott'), ('Samantha'), ('Brandon'), ('Katherine'),
('Benjamin'), ('Helen'), ('Samuel'), ('Christine'), ('Gregory'), ('Debra'), ('Alexander'), ('Rachel'), ('Frank'), ('Carolyn'),
('Patrick'), ('Janet'), ('Raymond'), ('Maria'), ('Jack'), ('Catherine'), ('Dennis'), ('Heather'), ('Jerry'), ('Diane'),
('Tyler'), ('Olivia'), ('Aaron'), ('Julie'), ('Jose'), ('Joyce'), ('Adam'), ('Victoria'), ('Nathan'), ('Kelly');

-- Insert sample last names (100 diverse names)
INSERT INTO @LastNames VALUES 
('Smith'), ('Johnson'), ('Williams'), ('Brown'), ('Jones'), ('Garcia'), ('Miller'), ('Davis'), ('Rodriguez'), ('Martinez'),
('Hernandez'), ('Lopez'), ('Gonzalez'), ('Wilson'), ('Anderson'), ('Thomas'), ('Taylor'), ('Moore'), ('Jackson'), ('Martin'),
('Lee'), ('Perez'), ('Thompson'), ('White'), ('Harris'), ('Sanchez'), ('Clark'), ('Ramirez'), ('Lewis'), ('Robinson'),
('Walker'), ('Young'), ('Allen'), ('King'), ('Wright'), ('Scott'), ('Torres'), ('Nguyen'), ('Hill'), ('Flores'),
('Green'), ('Adams'), ('Nelson'), ('Baker'), ('Hall'), ('Rivera'), ('Campbell'), ('Mitchell'), ('Carter'), ('Roberts'),
('Gomez'), ('Phillips'), ('Evans'), ('Turner'), ('Diaz'), ('Parker'), ('Cruz'), ('Edwards'), ('Collins'), ('Reyes'),
('Stewart'), ('Morris'), ('Morales'), ('Murphy'), ('Cook'), ('Rogers'), ('Gutierrez'), ('Ortiz'), ('Morgan'), ('Cooper'),
('Peterson'), ('Bailey'), ('Reed'), ('Kelly'), ('Howard'), ('Ramos'), ('Kim'), ('Cox'), ('Ward'), ('Richardson'),
('Watson'), ('Brooks'), ('Chavez'), ('Wood'), ('James'), ('Bennett'), ('Gray'), ('Mendoza'), ('Ruiz'), ('Hughes'),
('Price'), ('Alvarez'), ('Castillo'), ('Sanders'), ('Patel'), ('Myers'), ('Long'), ('Ross'), ('Foster'), ('Jimenez');

-- Insert sample street names
INSERT INTO @Streets VALUES 
('Main St'), ('Oak Ave'), ('Maple Dr'), ('Cedar Ln'), ('Pine St'), ('Elm Rd'), ('Washington Ave'), ('Park Blvd'), 
('Highland Ave'), ('Sunset Dr'), ('Lake St'), ('Meadow Ln'), ('River Rd'), ('Valley View Dr'), ('Mountain Ave'),
('Forest Dr'), ('Spring St'), ('Willow Ave'), ('Chestnut St'), ('Cherry Ln'), ('Broadway'), ('2nd St'), ('3rd Ave'),
('4th St'), ('5th Ave'), ('Lincoln St'), ('Jefferson Ave'), ('Madison St'), ('Monroe Ave'), ('Adams Blvd');

-- Insert sample cities with corresponding states and zip code prefixes
INSERT INTO @Cities VALUES 
('New York', 'NY', '100'), ('Los Angeles', 'CA', '900'), ('Chicago', 'IL', '606'), ('Houston', 'TX', '770'),
('Phoenix', 'AZ', '850'), ('Philadelphia', 'PA', '191'), ('San Antonio', 'TX', '782'), ('San Diego', 'CA', '921'),
('Dallas', 'TX', '752'), ('San Jose', 'CA', '951'), ('Austin', 'TX', '787'), ('Jacksonville', 'FL', '322'),
('Fort Worth', 'TX', '761'), ('Columbus', 'OH', '432'), ('Charlotte', 'NC', '282'), ('San Francisco', 'CA', '941'),
('Indianapolis', 'IN', '462'), ('Seattle', 'WA', '981'), ('Denver', 'CO', '802'), ('Washington', 'DC', '200'),
('Boston', 'MA', '021'), ('El Paso', 'TX', '799'), ('Nashville', 'TN', '372'), ('Portland', 'OR', '972'),
('Las Vegas', 'NV', '891'), ('Detroit', 'MI', '482'), ('Memphis', 'TN', '381'), ('Atlanta', 'GA', '303'),
('Baltimore', 'MD', '212'), ('Miami', 'FL', '331');

-- Insert job titles with base salary ranges
INSERT INTO @JobTitles VALUES 
('Software Engineer', 85000.00), ('Senior Software Engineer', 115000.00), ('Principal Engineer', 145000.00),
('Product Manager', 90000.00), ('Senior Product Manager', 120000.00), ('Marketing Specialist', 65000.00),
('Marketing Manager', 85000.00), ('Sales Representative', 55000.00), ('Sales Manager', 85000.00),
('Customer Service Rep', 45000.00), ('Customer Service Manager', 65000.00), ('Accountant', 65000.00),
('Senior Accountant', 85000.00), ('Financial Analyst', 70000.00), ('HR Specialist', 60000.00),
('HR Manager', 80000.00), ('Operations Coordinator', 55000.00), ('Operations Manager', 85000.00),
('Data Analyst', 75000.00), ('Data Scientist', 95000.00);

-- Generate Random Employee Data
DECLARE @EmployeeCount INT = 200;
DECLARE @i INT = 1;
DECLARE @CurrentDate DATE = GETDATE();
DECLARE @MinBirthDate DATE = DATEADD(YEAR, -64, @CurrentDate);
DECLARE @MaxBirthDate DATE = DATEADD(YEAR, -22, @CurrentDate);
DECLARE @MinJoinDate DATE = DATEADD(YEAR, -20, @CurrentDate);

-- First, insert all employees
WHILE @i <= @EmployeeCount
BEGIN
    DECLARE @FirstName NVARCHAR(50);
    DECLARE @LastName NVARCHAR(50);
    DECLARE @FullName NVARCHAR(100);
    DECLARE @DOB DATE;
    DECLARE @SSN CHAR(11);
    DECLARE @Street NVARCHAR(100);
    DECLARE @HouseNumber INT;
    DECLARE @City NVARCHAR(100);
    DECLARE @State CHAR(2);
    DECLARE @ZipPrefix CHAR(3);
    DECLARE @Zip CHAR(10);
    DECLARE @Address NVARCHAR(200);
    DECLARE @AreaCode CHAR(3);
    DECLARE @PhonePrefix CHAR(3);
    DECLARE @PhoneLineNumber CHAR(4);
    DECLARE @Phone VARCHAR(20);
    DECLARE @JoinDate DATE;
    DECLARE @ExitDate DATE = NULL;
    
    -- Generate random employee data
    SELECT TOP 1 @FirstName = FirstName FROM @FirstNames ORDER BY NEWID();
    SELECT TOP 1 @LastName = LastName FROM @LastNames ORDER BY NEWID();
    SET @FullName = @FirstName + ' ' + @LastName;
    
    -- Generate random DOB between min and max age
    SET @DOB = DATEADD(DAY, CAST(RAND() * DATEDIFF(DAY, @MinBirthDate, @MaxBirthDate) AS INT), @MinBirthDate);
    
    -- Generate random SSN (format: XXX-XX-XXXX)
    SET @SSN = RIGHT('00' + CAST(CAST(RAND() * 900 + 100 AS INT) AS VARCHAR), 3) + '-' +
              RIGHT('0' + CAST(CAST(RAND() * 90 + 10 AS INT) AS VARCHAR), 2) + '-' +
              RIGHT('000' + CAST(CAST(RAND() * 9000 + 1000 AS INT) AS VARCHAR), 4);
    
    -- Generate random address
    SET @HouseNumber = CAST(RAND() * 9900 + 100 AS INT);
    SELECT TOP 1 @Street = Street FROM @Streets ORDER BY NEWID();
    SELECT TOP 1 @City = City, @State = State, @ZipPrefix = ZipPrefix FROM @Cities ORDER BY NEWID();
    SET @Zip = @ZipPrefix + RIGHT('0' + CAST(CAST(RAND() * 90 + 10 AS INT) AS VARCHAR), 2) + '-' + 
               RIGHT('000' + CAST(CAST(RAND() * 9000 + 1000 AS INT) AS VARCHAR), 4);
    SET @Address = CAST(@HouseNumber AS NVARCHAR) + ' ' + @Street;
    
    -- Generate random phone (format: (XXX) XXX-XXXX)
    SET @AreaCode = RIGHT('00' + CAST(CAST(RAND() * 900 + 100 AS INT) AS VARCHAR), 3);
    SET @PhonePrefix = RIGHT('00' + CAST(CAST(RAND() * 900 + 100 AS INT) AS VARCHAR), 3);
    SET @PhoneLineNumber = RIGHT('000' + CAST(CAST(RAND() * 9000 + 1000 AS INT) AS VARCHAR), 4);
    SET @Phone = '(' + @AreaCode + ') ' + @PhonePrefix + '-' + @PhoneLineNumber;
    
    -- Generate random join date within last 20 years
    SET @JoinDate = DATEADD(DAY, CAST(RAND() * DATEDIFF(DAY, @MinJoinDate, @CurrentDate) AS INT), @MinJoinDate);
    
    -- About 20% of employees have left the company
    IF RAND() < 0.2
    BEGIN
        SET @ExitDate = DATEADD(DAY, CAST(RAND() * DATEDIFF(DAY, @JoinDate, @CurrentDate) AS INT), @JoinDate);
    END
    
    -- Check if SSN already exists
    IF NOT EXISTS (SELECT 1 FROM Employee WHERE SSN = @SSN)
    BEGIN
        -- Insert employee record
        INSERT INTO Employee (Name, SSN, DOB, Address, City, State, Zip, Phone, JoinDate, ExitDate)
        VALUES (@FullName, @SSN, @DOB, @Address, @City, @State, @Zip, @Phone, @JoinDate, @ExitDate);
        
        SET @i = @i + 1;
    END
END

-- Now create a table that will hold employee IDs and info for salary generation
DECLARE @EmployeeInfo TABLE (
    EmployeeID INT,
    JoinDate DATE,
    ExitDate DATE
);

-- Populate the employee info table
INSERT INTO @EmployeeInfo
SELECT EmployeeID, JoinDate, ExitDate FROM Employee;

-- Generate Salary Records
DECLARE @EmployeeTableRowCount INT = (SELECT COUNT(*) FROM @EmployeeInfo);

-- Loop through all employees
DECLARE @EmpCounter INT = 1;
DECLARE @CurrentEmployeeID INT;
DECLARE @EmpJoinDate DATE;
DECLARE @EmpExitDate DATE;

DECLARE EmployeeCursor CURSOR FOR
SELECT EmployeeID, JoinDate, ExitDate FROM @EmployeeInfo;

OPEN EmployeeCursor;
FETCH NEXT FROM EmployeeCursor INTO @CurrentEmployeeID, @EmpJoinDate, @EmpExitDate;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @NumberOfSalaryRecords INT;
    DECLARE @j INT = 1;
    DECLARE @FromDate DATE;
    DECLARE @ToDate DATE;
    DECLARE @Title NVARCHAR(50);
    DECLARE @BaseSalary DECIMAL(10,2);
    DECLARE @Salary DECIMAL(10,2);
    
    -- Determine number of salary records (1-5) based on time with company
    DECLARE @YearsWithCompany INT = DATEDIFF(YEAR, @EmpJoinDate, ISNULL(@EmpExitDate, @CurrentDate));
    SET @NumberOfSalaryRecords = CASE
                                     WHEN @YearsWithCompany < 2 THEN 1
                                     WHEN @YearsWithCompany < 5 THEN 1 + CAST(RAND() * 2 AS INT)
                                     WHEN @YearsWithCompany < 10 THEN 2 + CAST(RAND() * 3 AS INT)
                                     ELSE 3 + CAST(RAND() * 3 AS INT)
                                 END;
    
    -- Generate salary records
    SET @FromDate = @EmpJoinDate;
    WHILE @j <= @NumberOfSalaryRecords
    BEGIN
        -- Select a job title and base salary
        SELECT TOP 1 @Title = Title, @BaseSalary = BaseSalary 
        FROM @JobTitles 
        ORDER BY NEWID();
        
        -- Adjust salary based on seniority and random factor
        SET @Salary = @BaseSalary * (1 + ((@j - 1) * 0.15)) * (0.9 + (RAND() * 0.2));
        SET @Salary = ROUND(@Salary, 2);
        
        -- Set the end date for all except the last record
        IF @j = @NumberOfSalaryRecords
        BEGIN
            SET @ToDate = @EmpExitDate;  -- NULL if still employed
        END
        ELSE
        BEGIN
            -- Calculate a random to date between from date and exit date or current date
            DECLARE @MaxToDate DATE = ISNULL(@EmpExitDate, @CurrentDate);
            DECLARE @DaysBetween INT = DATEDIFF(DAY, @FromDate, @MaxToDate);
            
            -- Make sure we have enough days for proper distribution
            IF @DaysBetween > @NumberOfSalaryRecords
            BEGIN
                DECLARE @SegmentSize INT = @DaysBetween / (@NumberOfSalaryRecords - @j + 1);
                SET @ToDate = DATEADD(DAY, CAST(RAND() * @SegmentSize + (@SegmentSize * 0.5) AS INT), @FromDate);
            END
            ELSE
            BEGIN
                -- Not enough days, just use max date
                SET @ToDate = @MaxToDate;
            END
        END
        
        -- Insert salary record
        INSERT INTO EmployeeSalary (EmployeeID, FromDate, ToDate, Title, Salary)
        VALUES (@CurrentEmployeeID, @FromDate, @ToDate, @Title, @Salary);
        
        -- Next period starts after previous period ends
        IF @ToDate IS NOT NULL
        BEGIN
            SET @FromDate = DATEADD(DAY, 1, @ToDate);
        END
        
        SET @j = @j + 1;
    END
    
    FETCH NEXT FROM EmployeeCursor INTO @CurrentEmployeeID, @EmpJoinDate, @EmpExitDate;
END

CLOSE EmployeeCursor;
DEALLOCATE EmployeeCursor;

-- Verify record counts
SELECT 'Employee count: ' + CAST(COUNT(*) AS VARCHAR) FROM Employee;
SELECT 'Salary records count: ' + CAST(COUNT(*) AS VARCHAR) FROM EmployeeSalary;
SELECT 'Employees with at least one salary record: ' + 
       CAST(COUNT(DISTINCT EmployeeID) AS VARCHAR) FROM EmployeeSalary;

-- Sample data preview
SELECT TOP 10 * FROM Employee;
SELECT TOP 10 * FROM EmployeeSalary;