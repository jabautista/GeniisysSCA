SET serveroutput ON

DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_WPOLBAS'
       AND UPPER(column_name) = 'BOND_AUTO_PREM';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column BOND_AUTO_PREM to table GIPI_WPOLBAS...');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_WPOLBAS add BOND_AUTO_PREM VARCHAR2(1)';
        dbms_output.put_line('Column added.');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WPOLBAS add CONSTRAINT WPOLBAS_BOND_AUTO_PREM_CHK CHECK(BOND_AUTO_PREM IN (''Y'',''N''))';
		dbms_output.put_line('Constraint added.');
		EXECUTE IMMEDIATE ('UPDATE CPI.GIPI_WPOLBAS SET BOND_AUTO_PREM = ''N'' '
                            || ' WHERE line_cd = ''SU'' OR line_cd IN (SELECT line_cd '
                            || ' FROM giis_line WHERE menu_line_cd = ''SU'')');
    ELSE
        DBMS_OUTPUT.PUT_LINE('BOND_AUTO_PREM column already exist at GIPI_WPOLBAS table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;
/