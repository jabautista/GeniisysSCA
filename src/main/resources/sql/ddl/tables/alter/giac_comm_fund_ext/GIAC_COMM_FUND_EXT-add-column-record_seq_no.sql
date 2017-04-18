SET serveroutput ON

DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_COMM_FUND_EXT'
       AND UPPER(column_name) = 'RECORD_SEQ_NO';
       
    IF v_count = 0 THEN   
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_COMM_FUND_EXT ADD RECORD_SEQ_NO NUMBER(12)');
        
        DBMS_OUTPUT.PUT_LINE('Successfully added RECORD_SEQ_NO column to GIAC_COMM_FUND_EXT table.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('RECORD_SEQ_NO column already exist at GIAC_COMM_FUND_EXT table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;