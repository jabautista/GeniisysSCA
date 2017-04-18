SET serveroutput ON

DECLARE 
    v_count         NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIXX_BOND_BASIC'
       AND UPPER(column_name) = 'VAL_PERIOD'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIXX_BOND_BASIC ADD VAL_PERIOD NUMBER(4)');
        dbms_output.put_line('VAL_PERIOD successfully added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIXX_BOND_BASIC MODIFY VAL_PERIOD NUMBER(4)');
        dbms_output.put_line('VAL_PERIOD successfully set to NUMBER(4)');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;