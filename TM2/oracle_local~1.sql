-- =========================================
-- PACKAGE BODY: DEBUG_UTILS
-- =========================================

CREATE OR REPLACE PACKAGE BODY debug_utils AS

    PROCEDURE enable_debug IS
    BEGIN
        g_debug_mode := TRUE;
    END enable_debug;

    PROCEDURE disable_debug IS
    BEGIN
        g_debug_mode := FALSE;
    END disable_debug;

    PROCEDURE log_msg(
        p_module_name VARCHAR2,
        p_line NUMBER,
        p_message VARCHAR2
    ) IS
    BEGIN
        IF g_debug_mode THEN
            INSERT INTO debug_log (module_name, line_no, log_message)
            VALUES (p_module_name, p_line, p_message);
        END IF;
    END log_msg;

    PROCEDURE log_variable(
        p_module_name VARCHAR2,
        p_line NUMBER,
        p_name VARCHAR2,
        p_value VARCHAR2
    ) IS
    BEGIN
        IF g_debug_mode THEN
            INSERT INTO debug_log (module_name, line_no, log_message)
            VALUES (
                p_module_name,
                p_line,
                'Variable ' || p_name || ' = ' || p_value
            );
        END IF;
    END log_variable;

    PROCEDURE log_error(
        p_module_name VARCHAR2,
        p_line NUMBER,
        p_err VARCHAR2
    ) IS
    BEGIN
        IF g_debug_mode THEN
            INSERT INTO debug_log (module_name, line_no, log_message)
            VALUES (
                p_module_name,
                p_line,
                'ERROR: ' || p_err
            );
        END IF;
    END log_error;

END debug_utils;
/

BEGIN
    debug_utils.enable_debug;
    debug_utils.log_msg('TEST_MODULE', 1, 'Debug framework initialized');
    debug_utils.log_variable('TEST_MODULE', 2, 'v_test', '123');
    debug_utils.log_error('TEST_MODULE', 3, 'Sample error message');
END;
/

SELECT *
FROM debug_log
ORDER BY log_id;