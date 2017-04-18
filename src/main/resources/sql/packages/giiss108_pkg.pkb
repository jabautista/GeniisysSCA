CREATE OR REPLACE PACKAGE BODY CPI.giiss108_pkg
AS

   FUNCTION get_rec_list (
      p_control_type_cd       giis_control_type.control_type_cd%TYPE,
      p_control_type_desc     giis_control_type.control_type_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec                   rec_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_control_type
                WHERE control_type_cd = NVL(p_control_type_cd, control_type_cd)
                  AND UPPER(control_type_desc) LIKE UPPER(NVL(p_control_type_desc, control_type_desc))
                ORDER BY control_type_cd)
      LOOP
         v_rec.control_type_cd := i.control_type_cd;
         v_rec.control_type_desc := i.control_type_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec(
      p_rec                   giis_control_type%ROWTYPE
   )
   IS
      v_control_type_cd       giis_control_type.control_type_cd%TYPE;
      v_exists                VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_control_type
                WHERE control_type_cd = p_rec.control_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;
      
      IF v_exists = 'Y' THEN
         UPDATE giis_control_type
            SET control_type_desc = p_rec.control_type_desc,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE control_type_cd = p_rec.control_type_cd;
      ELSE
         SELECT control_type_code_s.nextval
           INTO v_control_type_cd
           FROM dual;
         
         INSERT
           INTO giis_control_type
                (control_type_cd, control_type_desc, remarks, user_id, last_update)
         VALUES (v_control_type_cd, p_rec.control_type_desc, p_rec.remarks, p_rec.user_id, SYSDATE);
      END IF;
   END;

   PROCEDURE del_rec(
      p_control_type_cd       giis_control_type.control_type_cd%TYPE
   )
   AS
   BEGIN
      DELETE
        FROM giis_control_type
       WHERE control_type_cd = p_control_type_cd;
   END;

   PROCEDURE val_add_rec(
      p_old_value             giis_control_type.control_type_desc%TYPE,
      p_control_type_desc     giis_control_type.control_type_desc%TYPE
   )
   AS
      v_exists   VARCHAR2(1);
   BEGIN
      IF p_old_value IS NULL THEN
         FOR i IN(SELECT 1
                    FROM giis_control_type a
                   WHERE a.control_type_desc = p_control_type_desc)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;
      ELSE
         FOR i IN(SELECT 1
                    FROM giis_control_type a
                   WHERE a.control_type_desc = p_control_type_desc
                     AND a.control_type_desc <> p_old_value)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;
      END IF;

      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same control_type_desc.');
      END IF;
   END;
   
   PROCEDURE val_del_rec(
      p_control_type_cd       giis_control_type.control_type_cd%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
                 FROM GIIS_COSIGNOR_RES
                WHERE control_type_cd = p_control_type_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_CONTROL_TYPE while dependent record(s) in GIIS_COSIGNOR_RES exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIIS_PRINCIPAL_RES
                WHERE control_type_cd = p_control_type_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_CONTROL_TYPE while dependent record(s) in GIIS_PRINCIPAL_RES exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIIS_PRIN_SIGNTRY
                WHERE control_type_cd = p_control_type_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_CONTROL_TYPE while dependent record(s) in GIIS_PRIN_SIGNTRY exists.');
      END LOOP;
   END;
   
END;
/


