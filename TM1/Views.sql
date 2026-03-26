USE TimesheetDB;
GO

-- VIEW
-- Afisare pontaje angajat + nume proiect
-- =================================
CREATE VIEW vw_TimesheetDetails AS
SELECT
    t.TimesheetID,
    e.FullName AS EmployeeName,
    p.ProjectName,
    t.WorkDate,
    t.HoursWorked,
    t.WorkType,
    t.DetailsJson
FROM Timesheets t
INNER JOIN Employees e ON t.EmployeeID = e.EmployeeID
INNER JOIN Projects p ON t.ProjectID = p.ProjectID;
GO

-- Afiseaza continutul view-ului creat
SELECT * 
FROM vw_TimesheetDetails;
GO

-- INDEXED VIEW (materialized view equivalent in SQL Server)
-- ===========================
CREATE VIEW dbo.vw_EmployeeProjectHours
WITH SCHEMABINDING
AS
SELECT
    t.EmployeeID,
    t.ProjectID,
    COUNT_BIG(*) AS EntryCount,
    SUM(t.HoursWorked) AS TotalHours
FROM dbo.Timesheets AS t
GROUP BY
    t.EmployeeID,
    t.ProjectID;
GO

--Transforma view-ul intr-un indexed view(rezultatul este stocat fizic).
CREATE UNIQUE CLUSTERED INDEX IX_vw_EmployeeProjectHours
ON dbo.vw_EmployeeProjectHours (EmployeeID, ProjectID);
GO

-- Totalul de ore lucrate de fiecare angajar pe fiecare proiect folosind indexed view.
SELECT *
FROM dbo.vw_EmployeeProjectHours;
GO

-- GROUP BY QUERY
-- Numarul total de ore lucrate pe fiecare proiect.
-- ==============================
SELECT
    p.ProjectName,
    SUM(t.HoursWorked) AS TotalHoursWorked
FROM Timesheets t
INNER JOIN Projects p ON t.ProjectID = p.ProjectID
GROUP BY p.ProjectName;
GO

-- LEFT JOIN QUERY
-- Toti angajatii si pontajele lor.
-- Pastreaza toate randurile din Employees.
-- ================================
SELECT
    e.EmployeeID,
    e.FullName,
    t.TimesheetID,
    t.WorkDate,
    t.HoursWorked
FROM Employees e
LEFT JOIN Timesheets t ON e.EmployeeID = t.EmployeeID
ORDER BY e.EmployeeID, t.WorkDate;
GO

-- ANALYTIC FUNCTION QUERY
-- Afiseaza fiecare pontaj si totalul orelor lucrate de angajatul respectiv.
-- ===============================
SELECT
    t.TimesheetID,
    t.EmployeeID,
    t.ProjectID,
    t.WorkDate,
    t.HoursWorked,
    SUM(t.HoursWorked) OVER (PARTITION BY t.EmployeeID) AS TotalHoursPerEmployee
FROM Timesheets t;
GO

