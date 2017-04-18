CREATE OR REPLACE PACKAGE BODY CPI.giiss097_pkg
AS
   FUNCTION get_rec_list (
      p_occupancy_cd     giis_fire_occupancy.occupancy_cd%TYPE,
      p_occupancy_desc   giis_fire_occupancy.occupancy_desc%TYPE,
      p_active_tag       giis_fire_occupancy.active_tag%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.occupancy_cd, a.occupancy_desc, a.active_tag, a.remarks,
                   a.user_id, a.last_update
              FROM giis_fire_occupancy a
             WHERE UPPER (a.occupancy_cd) LIKE
                                            UPPER (NVL (p_occupancy_cd, '%'))
               AND UPPER (a.occupancy_desc) LIKE
                                           UPPER (NVL (p_occupancy_desc, '%'))
               AND UPPER (a.active_tag) LIKE UPPER (NVL (p_active_tag, '%'))
          ORDER BY a.occupancy_cd, a.occupancy_desc)
      LOOP
         v_rec.occupancy_cd := i.occupancy_cd;
         v_rec.occupancy_desc := i.occupancy_desc;
         v_rec.active_tag := i.active_tag;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_fire_occupancy%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_fire_occupancy
         USING DUAL
         ON (occupancy_cd = p_rec.occupancy_cd)
         WHEN NOT MATCHED THEN
            INSERT (occupancy_cd, occupancy_desc, active_tag, remarks,
                    user_id, last_update)
            VALUES (p_rec.occupancy_cd, p_rec.occupancy_desc,
                    p_rec.active_tag, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET occupancy_desc = p_rec.occupancy_desc,
                   active_tag = p_rec.active_tag, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_occupancy_cd giis_fire_occupancy.occupancy_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_fire_occupancy
            WHERE occupancy_cd = p_occupancy_cd;
   END;

   PROCEDURE val_del_rec (
      p_occupancy_cd   giis_fire_occupancy.occupancy_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_fireitem a
                 WHERE a.occupancy_cd = p_occupancy_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_FIRE_OCCUPANCY while dependent record(s) in GIPI_FIREITEM exists.'
            );
      ELSIF v_exists = 'N'
      THEN
         FOR i IN (SELECT '1'
                     FROM gipi_wfireitm a
                    WHERE a.occupancy_cd = p_occupancy_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_FIRE_OCCUPANCY while dependent record(s) in GIPI_WFIREITM exists.'
               );
         END IF;
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_occupancy_cd     giis_fire_occupancy.occupancy_cd%TYPE,
      p_occupancy_desc   giis_fire_occupancy.occupancy_desc%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_fire_occupancy a
                 WHERE a.occupancy_cd = p_occupancy_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same occupancy_cd.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM giis_fire_occupancy a
                 WHERE a.occupancy_desc = p_occupancy_desc)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same occupancy_desc.'
            );
         RETURN;
      END IF;
   END;
END;
/


