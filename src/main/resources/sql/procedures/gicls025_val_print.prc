DROP PROCEDURE CPI.GICLS025_VAL_PRINT;

CREATE OR REPLACE PROCEDURE CPI.GICLS025_VAL_PRINT(
  p_report1 VARCHAR2,
  p_report2 VARCHAR2,
  p_report3 VARCHAR2,
  p_report4 VARCHAR2
) IS
   v_report     VARCHAR2(10);
BEGIN
     IF p_report1 = 'Y'
      THEN
         BEGIN
            SELECT report_id
              INTO v_report
              FROM giis_reports
             WHERE report_id = 'GICLR025';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error(-20001, 'Geniisys Exception#E#GICLR025 does not exist in GIIS_REPORTS');
         END;
      END IF;

      IF p_report2 = 'Y'
      THEN
         BEGIN
            SELECT report_id
              INTO v_report
              FROM giis_reports
             WHERE report_id = 'GICLR025_B';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error(-20001, 'Geniisys Exception#E#GICLR025_B does not exist in GIIS_REPORTS');
         END;      
      END IF;

      IF p_report3 = 'Y'
      THEN
         BEGIN
            SELECT report_id
              INTO v_report
              FROM giis_reports
             WHERE report_id = 'GICLR025_C';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error(-20001, 'Geniisys Exception#E#GICLR025_C does not exist in GIIS_REPORTS');
         END;      
      END IF;

      IF p_report4 = 'Y'
      THEN
         BEGIN
            SELECT report_id
              INTO v_report
              FROM giis_reports
             WHERE report_id = 'GICLR025_D';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error(-20001, 'Geniisys Exception#E#GICLR025_D does not exist in GIIS_REPORTS');
         END;
      END IF;
END;
/


