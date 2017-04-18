SET serveroutput ON

DECLARE 
    v_count         NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIXX_INW_TRAN'
       AND UPPER(column_name) = 'RI_POLICY_NO'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIXX_INW_TRAN ADD RI_POLICY_NO VARCHAR2(27)');
        dbms_output.put_line('GIXX_INW_TRAN.RI_POLICY_NO successfully added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIXX_INW_TRAN MODIFY RI_POLICY_NO VARCHAR2(27)');
        dbms_output.put_line('RI_POLICY_NO successfully set to VARCHAR2(27)');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;