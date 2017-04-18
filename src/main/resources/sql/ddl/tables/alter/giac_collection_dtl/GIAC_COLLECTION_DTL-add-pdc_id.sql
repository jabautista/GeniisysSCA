SET serveroutput ON

DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_COLLECTION_DTL'
       AND UPPER(column_name) = 'PDC_ID';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column PDC_ID to table GIAC_COLLECTION_DTL...');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_COLLECTION_DTL add PDC_ID NUMBER(12) REFERENCES GIAC_APDC_PAYT_DTL(PDC_ID)';
        dbms_output.put_line('Column added.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('PDC_ID column already exist at GIAC_COLLECTION_DTL table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;