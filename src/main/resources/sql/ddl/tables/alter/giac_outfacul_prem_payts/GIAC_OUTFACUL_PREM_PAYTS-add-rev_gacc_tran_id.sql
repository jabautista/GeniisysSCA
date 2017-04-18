SET serveroutput ON

DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_OUTFACUL_PREM_PAYTS'
       AND UPPER(column_name) = 'REV_GACC_TRAN_ID';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column REV_GACC_TRAN_ID to table GIAC_OUTFACUL_PREM_PAYTS...');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_OUTFACUL_PREM_PAYTS add REV_GACC_TRAN_ID NUMBER(12)';
        dbms_output.put_line('Column added.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('REV_GACC_TRAN_ID column already exist at GIAC_OUTFACUL_PREM_PAYTS table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;