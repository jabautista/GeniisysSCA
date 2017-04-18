SET serveroutput ON

DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_POLBASIC'
       AND UPPER(column_name) = 'BOND_AUTO_PREM';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column BOND_AUTO_PREM to table GIPI_POLBASIC...');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_POLBASIC add BOND_AUTO_PREM VARCHAR2(1)';
        dbms_output.put_line('Column added.');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_POLBASIC add CONSTRAINT POLBASIC_BOND_AUTO_PREM_CHK CHECK(BOND_AUTO_PREM IN (''Y'',''N''))';
		dbms_output.put_line('Constraint added.');
		EXECUTE IMMEDIATE ('UPDATE CPI.GIPI_POLBASIC SET BOND_AUTO_PREM = ''N'' '
                            || ' WHERE line_cd = ''SU'' OR line_cd IN (SELECT line_cd '
                            || ' FROM giis_line WHERE menu_line_cd = ''SU'')');
    ELSE
        DBMS_OUTPUT.PUT_LINE('BOND_AUTO_PREM column already exist at GIPI_POLBASIC table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;
/