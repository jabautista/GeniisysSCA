SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   BEGIN
      SELECT 1
        INTO v_exist
        FROM cpi.giis_reports
       WHERE report_id = 'BONDS_ENDT';

      IF v_exist = 1 THEN
         DBMS_OUTPUT.put_line ('BONDS_ENDT already exists.');
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         INSERT INTO giis_reports
               (report_id, report_title, line_cd, destype, desname, desformat, paramform,
                copies, report_mode, orientation, add_source)
         VALUES('BONDS_ENDT', 'Surety Bond Endorsement Report', 'SU', 'PRINTER', 'C:\bonds_endt.txt', 'bonds_endt', 'NO',
                0, 'BITMAP', 'Default', 'P');
                
         COMMIT;
         DBMS_OUTPUT.put_line ('BONDS_ENDT inserted.');
   END;
END;