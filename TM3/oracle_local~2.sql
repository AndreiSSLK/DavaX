SELECT * FROM fact_pontaj;

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