DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIEX_EXPIRY'
       AND UPPER(column_name) = 'CRED_BRANCH'
       AND UPPER(owner) = 'CPI';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column CRED_BRANCH to table GIEX_EXPIRY...');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIEX_EXPIRY add CRED_BRANCH VARCHAR2(2)';
        dbms_output.put_line('Column added.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('CRED_BRANCH column already exist at GIEX_EXPIRY table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;
/