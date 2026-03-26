BEGIN
    debug_utils.enable_debug;
END;
/

BEGIN
    adjust_salaries_by_commission;
END;
/

SELECT *
FROM employees;

SELECT *
FROM debug_log
ORDER BY log_id;

DELETE FROM debug_log;
COMMIT;

