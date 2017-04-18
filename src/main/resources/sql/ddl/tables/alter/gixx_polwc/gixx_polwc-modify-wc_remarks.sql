SET serveroutput ON

DECLARE 
    v_count         NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIXX_POLWC'
       AND UPPER(column_name) = 'WC_REMARKS'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIXX_POLWC ADD WC_REMARKS VARCHAR2(2000)');
        dbms_output.put_line('WC_REMARKS successfully added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIXX_POLWC MODIFY WC_REMARKS VARCHAR2(2000)');
        dbms_output.put_line('WC_REMARKS successfully set to VARCHAR(2000)');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;