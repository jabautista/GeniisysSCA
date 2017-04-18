CREATE OR REPLACE PACKAGE BODY CPI.giiss098_pkg
AS
   FUNCTION get_rec_list (
      p_construction_cd     giis_fire_construction.construction_cd%TYPE,
      p_construction_desc   giis_fire_construction.construction_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   *
              FROM giis_fire_construction
             WHERE UPPER (construction_cd) LIKE
                                         UPPER (NVL (p_construction_cd, '%'))
               AND UPPER (construction_desc) LIKE
                                        UPPER (NVL (p_construction_desc, '%'))
          ORDER BY construction_cd, construction_desc)
      LOOP
         v_rec.construction_cd := i.construction_cd;
         v_rec.construction_desc := i.construction_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_fire_construction%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_fire_construction
         USING DUAL
         ON (construction_cd = p_rec.construction_cd)
         WHEN NOT MATCHED THEN
            INSERT (construction_cd, construction_desc, remarks, user_id,
                    last_update)
            VALUES (p_rec.construction_cd, p_rec.construction_desc,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET construction_desc = p_rec.construction_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (
      p_construction_cd   giis_fire_construction.construction_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_fire_construction
            WHERE construction_cd = p_construction_cd;
   END;

   PROCEDURE val_del_rec (
      p_construction_cd   giis_fire_construction.construction_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR rec IN (SELECT '1'
                    FROM gipi_fireitem
                   WHERE construction_cd = p_construction_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_FIRE_CONSTRUCTION while dependent record(s) in GIPI_FIREITEM exists.'
            );
      END IF;

      FOR rec IN (SELECT '1'
                    FROM gipi_wfireitm
                   WHERE construction_cd = p_construction_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_FIRE_CONSTRUCTION while dependent record(s) in GIPI_WFIREITM exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_construction_cd   giis_fire_construction.construction_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_fire_construction
                 WHERE construction_cd = p_construction_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same construction_cd.'
            );
      END IF;
   END;
END;
/


