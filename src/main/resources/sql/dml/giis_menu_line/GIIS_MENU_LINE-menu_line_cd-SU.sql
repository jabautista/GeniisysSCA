/*Gzelle 05272015 SR4562*/

SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_menu_line
    WHERE menu_line_cd = 'SU';

   IF v_exist = 1 THEN
      DBMS_OUTPUT.put_line ('SU-SURETY already existing in GIIS_MENU_LINE.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      INSERT INTO cpi.giis_menu_line
                  (menu_line_cd, menu_line_desc, user_id, last_update)
           VALUES ('SU', 'SURETY', USER, SYSDATE);

      COMMIT;
      DBMS_OUTPUT.put_line ('SU-SURETY inserted.');
END;