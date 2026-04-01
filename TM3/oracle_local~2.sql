SELECT * FROM fact_pontaj;
SELECT * FROM dim_time

--TABELA COMPLETA
SELECT 
    e.nume,
    e.prenume,
    p.project_name,
    t.full_date,
    ev.event_name,
    f.hours_worked
FROM fact_pontaj f
JOIN dim_employee e ON f.employee_id = e.id
JOIN dim_project p ON f.project_id = p.id
JOIN dim_time t ON f.time_id = t.id
JOIN dim_event ev ON f.event_id = ev.id;


-- TOTAL ORE LUCRATE Q1
SELECT 
    SUM(f.hours_worked) AS total_hours_q1,
    COUNT(f.id) AS Employees_work_days
FROM fact_pontaj f
join dim_time t ON f.time_id = t.id
WHERE t.quarter = 1
    AND EXTRACT(YEAR FROM t.full_date) = 2026


--TOTAL VACANTE 2026
SELECT
    COUNT(f.event_id) AS Vacantion_days
FROM fact_pontaj f
JOIN dim_event e ON f.event_id = e.id
join dim_time t ON f.time_id = t.id
WHERE e.event_name = 'Vacation'
        AND EXTRACT(YEAR FROM t.full_date) = 2026


--CREARE VIEW 
CREATE OR REPLACE VIEW vw_pontaj_angajat AS
SELECT 
    e.id,
    e.nume,
    e.prenume,
    SUM(f.hours_worked) AS total_ore,
    COUNT(DISTINCT t.full_date) AS zile_lucrate
FROM fact_pontaj f
JOIN dim_employee e ON f.employee_id = e.id
JOIN dim_time t ON f.time_id = t.id
WHERE f.hours_worked > 0
GROUP BY e.id, e.nume, e.prenume;


SELECT * FROM vw_pontaj_angajat;
