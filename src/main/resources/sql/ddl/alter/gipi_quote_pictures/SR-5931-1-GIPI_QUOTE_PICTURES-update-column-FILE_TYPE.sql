SET SERVEROUTPUT ON;

DECLARE
    v_exists NUMBER(1) := 0;
BEGIN
    SELECT 1
      INTO v_exists
      FROM all_tab_cols
     WHERE owner = 'CPI'
       AND table_name = 'GIPI_QUOTE_PICTURES'
       AND column_name = 'FILE_TYPE';

    IF v_exists = 1
    THEN
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_QUOTE_PICTURES MODIFY FILE_TYPE VARCHAR2(1 BYTE) NULL';
        
        DBMS_OUTPUT.PUT_LINE('Successfully updated GIPI_QUOTE_PICTURES set FILE_TYPE to allow NULL.');
    END IF;
EXCEPTION
    WHEN others THEN
        DBMS_OUTPUT.PUT_LINE('Failed to update GIPI_QUOTE_PICTURES.');
END;