DECLARE 
  v_count NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIUW_POL_DIST'
       AND UPPER(column_name) = 'TAKEUP_SEQ_NO'
       AND UPPER(owner) = 'CPI';
       
    IF v_count = 0 THEN          
        DBMS_OUTPUT.PUT_LINE('TAKEUP_SEQ_NO column of GIUW_POL_DIST does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIUW_POL_DIST MODIFY TAKEUP_SEQ_NO DEFAULT 1');
        DBMS_OUTPUT.PUT_LINE('Successfully added default value for TAKEUP_SEQ_NO column of GIUW_POL_DIST table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;