SET serveroutput ON

DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_COMM_PAYTS'
       AND UPPER(column_name) = 'RECORD_SEQ_NO';
       
    IF v_count = 0 THEN   
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_COMM_PAYTS ADD RECORD_SEQ_NO NUMBER(12) DEFAULT 1'); --mikel 09.17.2015 FGIC 20286; set DEFAULT value
        EXECUTE IMMEDIATE ('UPDATE CPI.GIAC_COMM_PAYTS SET RECORD_SEQ_NO = 1');
        EXECUTE IMMEDIATE ('COMMIT');
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_COMM_PAYTS MODIFY RECORD_SEQ_NO NOT NULL');
        
        DBMS_OUTPUT.PUT_LINE('Successfully added RECORD_SEQ_NO column to GIAC_COMM_PAYTS table.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_COMM_PAYTS MODIFY RECORD_SEQ_NO DEFAULT 1'); --mikel 09.17.2015 FGIC 20286; set DEFAULT value
        DBMS_OUTPUT.PUT_LINE('Successfully added default value for RECORD_SEQ_NO column to GIAC_COMM_PAYTS table.'); --mikel 09.17.2015 FGIC 20286
        DBMS_OUTPUT.PUT_LINE('RECORD_SEQ_NO column already exist at GIAC_COMM_PAYTS table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;