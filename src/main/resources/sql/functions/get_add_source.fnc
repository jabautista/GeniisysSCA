DROP FUNCTION CPI.GET_ADD_SOURCE;

CREATE OR REPLACE FUNCTION CPI.get_add_source(
        p_report_id giis_reports.report_id%TYPE
  )
  RETURN VARCHAR2
  IS
  v_add_source giis_reports.add_source%TYPE;
  BEGIN
    SELECT NVL(add_source, 'X')
      INTO v_add_source
      FROM giis_reports 
     WHERE report_id = p_report_id;
    RETURN v_add_source;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        v_add_source := 'X';
    
  RETURN v_add_source;
  END;
/


