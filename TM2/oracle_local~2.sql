-- =========================================
-- PROCEDURE: ADJUST_SALARIES_BY_COMMISSION
-- =========================================

CREATE OR REPLACE PROCEDURE adjust_salaries_by_commission IS

    CURSOR emp_cursor IS
        SELECT employee_id, salary, commission_pct
        FROM employees;

    v_new_salary employees.salary%TYPE;

BEGIN
    debug_utils.log_msg('adjust_salaries_by_commission', 1, 'Procedure started');

    FOR rec IN emp_cursor LOOP
        debug_utils.log_msg(
            'adjust_salaries_by_commission',
            2,
            'Processing employee_id = ' || rec.employee_id
        );

        debug_utils.log_variable(
            'adjust_salaries_by_commission',
            3,
            'current_salary',
            TO_CHAR(rec.salary)
        );

        debug_utils.log_variable(
            'adjust_salaries_by_commission',
            4,
            'commission_pct',
            NVL(TO_CHAR(rec.commission_pct), 'NULL')
        );

        IF rec.commission_pct IS NOT NULL THEN
            v_new_salary := rec.salary + (rec.salary * rec.commission_pct);

            debug_utils.log_msg(
                'adjust_salaries_by_commission',
                5,
                'Commission found. Salary adjusted using commission_pct'
            );
        ELSE
            v_new_salary := rec.salary + (rec.salary * 0.02);

            debug_utils.log_msg(
                'adjust_salaries_by_commission',
                6,
                'Commission is NULL. Salary adjusted using default 2%'
            );
        END IF;

        debug_utils.log_variable(
            'adjust_salaries_by_commission',
            7,
            'new_salary',
            TO_CHAR(v_new_salary)
        );

        UPDATE employees
        SET salary = v_new_salary
        WHERE employee_id = rec.employee_id;

        debug_utils.log_msg(
            'adjust_salaries_by_commission',
            8,
            'Salary updated for employee_id = ' || rec.employee_id
        );
    END LOOP;

    COMMIT;

    debug_utils.log_msg(
        'adjust_salaries_by_commission',
        9,
        'Procedure finished successfully'
    );

EXCEPTION
    WHEN OTHERS THEN
        debug_utils.log_error(
            'adjust_salaries_by_commission',
            10,
            SQLERRM
        );
        ROLLBACK;
        RAISE;
END adjust_salaries_by_commission;
/