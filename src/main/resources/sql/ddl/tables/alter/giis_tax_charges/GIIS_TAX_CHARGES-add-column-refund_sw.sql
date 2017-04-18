SET serveroutput ON

DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_TAX_CHARGES'
       AND UPPER(column_name) = 'REFUND_SW';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column REFUND_SW to table GIIS_TAX_CHARGES...');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIIS_TAX_CHARGES add REFUND_SW VARCHAR2(1)';
        dbms_output.put_line('Column added.');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIIS_TAX_CHARGES add CONSTRAINT check_refund_sw CHECK(REFUND_SW IN (''Y'',''N''))';
		dbms_output.put_line('Constraint added.');
		EXECUTE IMMEDIATE ('UPDATE CPI.GIIS_TAX_CHARGES SET REFUND_SW = ''N''');
        EXECUTE IMMEDIATE ('COMMIT');
		dbms_output.put_line('Column updated.');
		EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_TAX_CHARGES MODIFY REFUND_SW NOT NULL');
		dbms_output.put_line('REFUND_SW successfully set to NOT NULLABLE.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('REFUND_SW column already exist at GIIS_TAX_CHARGES table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;
/