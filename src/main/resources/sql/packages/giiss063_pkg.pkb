CREATE OR REPLACE PACKAGE BODY CPI.giiss063_pkg
AS
   FUNCTION get_rec_list (
      p_class_cd     giis_class.class_cd%TYPE,
      p_class_desc   giis_class.class_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.class_cd, a.class_desc, a.remarks, a.user_id,
                       a.last_update
                  FROM giis_class a
                 WHERE UPPER (a.class_cd) LIKE UPPER (NVL (p_class_cd, '%'))
                   AND UPPER (a.class_desc) LIKE UPPER (NVL (p_class_desc, '%'))
                 ORDER BY a.class_cd, a.class_desc
                   )                   
      LOOP
         v_rec.class_cd := i.class_cd;
         v_rec.class_desc := i.class_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_class%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_class
         USING DUAL
         ON (class_cd = p_rec.class_cd)
         WHEN NOT MATCHED THEN
            INSERT (class_cd, class_desc, remarks, user_id, last_update)
            VALUES (p_rec.class_cd, p_rec.class_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET class_desc = p_rec.class_desc,
                   remarks = p_rec.remarks, 
                   user_id = p_rec.user_id, 
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_class_cd giis_class.class_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_class
            WHERE class_cd = p_class_cd;
   END;

   PROCEDURE val_del_rec (p_class_cd giis_class.class_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM GIIS_PERIL_CLASS a
                 WHERE a.class_cd = p_class_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CLASS while dependent record(s) in GIIS_PERIL_CLASS exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (p_class_cd giis_class.class_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_class a
                 WHERE a.class_cd = p_class_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' 
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same class_cd.'
                                 );
      END IF;
   END;
   
   PROCEDURE val_add_rec2 (p_class_desc giis_class.class_desc%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_class a
                 WHERE a.class_desc = p_class_desc)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;
      
      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same class_desc.'
                                 );
      END IF;
   END;
END;
/


