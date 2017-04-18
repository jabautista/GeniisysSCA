SET serveroutput ON

DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIEX_PACK_EXPIRY'
       AND UPPER(column_name) = 'PROCESSOR'
       AND UPPER(owner) = 'CPI';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column PROCESSOR to table GIEX_PACK_EXPIRY...');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIEX_PACK_EXPIRY add PROCESSOR VARCHAR2(8)';
        dbms_output.put_line('Column added.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('PROCESSOR column already exist at GIEX_PACK_EXPIRY table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;
/