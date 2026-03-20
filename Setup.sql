CREATE DATABASE TimesheetDB;
GO

USE TimesheetDB;
GO

-- Employees table
-- =============
CREATE TABLE Employees (
	EmployeeID INT PRIMARY KEY,
	FullName NVARCHAR(100) NOT NULL,
	Email NVARCHAR(100) NOT NULL UNIQUE,
	HireDate DATE NOT NULL,
	Salary DECIMAL(10,2) CHECK (Salary > 0)
);
GO

-- PROJECTS TABLE
-- =============
CREATE TABLE Projects (
	ProjectID Int PRIMARY KEY,
	ProjectName NVARCHAR(50) NOT NULL UNIQUE,
	ClientName NVARCHAR(50) NOT NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	Status NVARCHAR(20) NOT NULL
		CHECK (Status IN ('Active', 'Completed', 'On Hold'))
);
GO

-- TIMESHEETS TABLE
-- ==============
CREATE TABLE Timesheets (
	TimesheetID INT PRIMARY KEY,
	EmployeeID INT NOT NULL,
	ProjectID INT NOT NULL,
	WorkDate DATE NOT NULL,

	HoursWorked Decimal(4,2) NOT NULL
		CHECK (HoursWorked > 0 AND HoursWorked < 24),

	WorkType NVARCHAR(20) NOT NULL
		CHECK (WorkType IN ('Office', 'Work From Home')),

	DetailsJson NVARCHAR(MAX) NULL
		CHECK (ISJSON(DetailsJson) = 1 OR DetailsJson IS NULL),

	CONSTRAINT FK_Timesheets_Employees
		FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),

	CONSTRAINT FK_Timesheets_Projects
        FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);
GO

-- INSERT EMPLOYEES DATA
-- ============================
INSERT INTO Employees (EmployeeID, FullName, Email, HireDate, Salary)
VALUES
	(1, 'Ana Popescu', 'ana.popescu@company.com', '2022-03-15', 5000.00),
    (2, 'Mihai Ionescu', 'mihai.ionescu@company.com', '2021-07-10', 6200.00),
    (3, 'Elena Georgescu', 'elena.georgescu@company.com', '2023-01-20', 4800.00),
    (4, 'Radu Marin', 'radu.marin@company.com', '2020-11-05', 7100.00),
    (5, 'Ioana Dumitru', 'ioana.dumitru@company.com', '2024-02-01', 4500.00);
GO

-- INSERT PROJECTS DATA
-- =====================
INSERT INTO Projects (ProjectID, ProjectName, ClientName, StartDate, EndDate, Status)
VALUES
    (1, 'Timesheet App', 'Endava Internal', '2025-01-10', '2033-04-14', 'Active'),
    (2, 'CRM Upgrade', 'ABC Corporation', '2024-09-01', '2024-12-21', 'Active'),
    (3, 'Data Migration', 'XYZ Bank', '2024-03-15', '2025-02-28', 'Completed'),
    (4, 'HR Portal', 'Global HR Ltd', '2025-04-01', '2026-01-11', 'On Hold');
GO

-- INSERT TIMESHEETS DATA
-- =========================
INSERT INTO Timesheets (TimesheetID, EmployeeID, ProjectID, WorkDate, HoursWorked, WorkType, DetailsJson)
VALUES
	(1, 1, 1, '2025-06-01', 8.00, 'Office', NULL),
    (2, 1, 2, '2025-06-02', 6.50, 'Work From Home', '{"task":"Client meeting","billable":true,"location":"Remote"}'),
    (3, 2, 1, '2025-06-01', 7.50, 'Office', NULL),
    (4, 2, 3, '2025-06-03', 4.00, 'Work From Home', NULL),
    (5, 3, 2, '2025-06-01', 8.00, 'Office', '{"task":"Testing","billable":true,"location":"Cluj"}'),
    (6, 3, 2, '2025-06-02', 7.00, 'Work From Home', '{"task":"Bug fixing","billable":true,"location":"Remote"}'),
    (7, 4, 1, '2025-06-01', 5.50, 'Office', NULL),
    (8, 4, 4, '2025-06-04', 3.00, 'Office', '{}');
GO

-- INDEX
--============
-- Index pentru zile
CREATE INDEX IDX_Timesheets_WorkDate
ON Timesheets(WorkDate);

-- Index pentru WorkType
CREATE INDEX IDX_Timesheets_WorkType
ON Timesheets(WorkType);
GO