SET serveroutput ON

--marco - 06.01.2015 - GENQA SR 4469
DECLARE 
    v_count         NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_DIRECT_PREM_COLLNS'
       AND UPPER(column_name) = 'CONVERT_RATE'
       AND UPPER(nullable) = 'N';
       
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_DIRECT_PREM_COLLNS MODIFY (CONVERT_RATE NOT NULL)');
        dbms_output.put_line('CONVERT_RATE successfully set to NOT NULLABLE.');
    ELSE
        dbms_output.put_line('CONVERT_RATE is already set to NOT NULLABLE.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;