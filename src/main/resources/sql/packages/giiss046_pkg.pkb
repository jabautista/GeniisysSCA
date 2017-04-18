CREATE OR REPLACE PACKAGE BODY CPI.GIISS046_PKG
AS
   FUNCTION get_rec_list (
      p_hull_type_cd   giis_hull_type.hull_type_cd%TYPE,
      p_hull_desc      giis_hull_type.hull_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
      
   BEGIN
      FOR i IN (SELECT a.hull_type_cd, a.hull_desc, a.remarks, a.user_id,
                       a.last_update
                  FROM giis_hull_type a
--                 WHERE a.hull_type_cd = NVL (p_hull_type_cd, null)
--                   AND UPPER (a.hull_desc) LIKE UPPER (NVL (p_hull_desc, '%'))
                 ORDER BY a.hull_type_cd
                   )                   
      LOOP
         v_rec.hull_type_cd := i.hull_type_cd;
         v_rec.hull_desc := i.hull_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_hull_type%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_hull_type
         USING DUAL
         ON (hull_type_cd = p_rec.hull_type_cd)
         WHEN NOT MATCHED THEN
            INSERT (hull_type_cd, hull_desc, remarks, user_id, last_update)
            VALUES (p_rec.hull_type_cd, p_rec.hull_desc, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET hull_desc = p_rec.hull_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_hull_type_cd giis_hull_type.hull_type_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_hull_type
            WHERE hull_type_cd = p_hull_type_cd;
   END;

    PROCEDURE val_del_rec (p_hull_type_cd giis_hull_type.hull_type_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
   
  
     FOR i IN ( SELECT  '1'
        FROM    GIIS_VESSEL a
        WHERE   a.HULL_TYPE_CD = p_hull_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Cannot delete record from GIIS_HULL_TYPE while dependent record(s) in GIIS_VESSEL exists.'
                                 );
      END IF;
   END;

   PROCEDURE val_add_rec (p_hull_type_cd giis_hull_type.hull_type_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_hull_type a
                 WHERE a.hull_type_cd = p_hull_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Row exists already with same hull_type_cd.'
                                 );
      END IF;
   END;
END GIISS046_PKG;
/


