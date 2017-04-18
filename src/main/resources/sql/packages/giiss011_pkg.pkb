CREATE OR REPLACE PACKAGE BODY CPI.giiss011_pkg
AS
   FUNCTION get_rec_list (
      p_eq_zone    giis_eqzone.eq_zone%TYPE,
      p_eq_desc    giis_eqzone.eq_desc%TYPE,
      p_zone_grp   giis_eqzone.zone_grp%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   a.eq_zone, a.eq_desc, a.zone_grp, a.remarks,
                         a.user_id, a.last_update
                    FROM giis_eqzone a
                   WHERE UPPER (a.eq_zone) LIKE UPPER (NVL (p_eq_zone, '%'))
                     AND UPPER (a.eq_desc) LIKE UPPER (NVL (p_eq_desc, '%'))
                     AND UPPER (NVL (a.zone_grp, '%')) LIKE
                                                 UPPER (NVL (p_zone_grp, '%'))
                ORDER BY a.eq_zone)
      LOOP
         v_rec.eq_zone := i.eq_zone;
         v_rec.eq_desc := i.eq_desc;
         v_rec.zone_grp := i.zone_grp;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_eqzone%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_eqzone
         USING DUAL
         ON (eq_zone = p_rec.eq_zone)
         WHEN NOT MATCHED THEN
            INSERT (eq_zone, eq_desc, zone_grp, remarks, user_id,
                    last_update)
            VALUES (p_rec.eq_zone, p_rec.eq_desc, p_rec.zone_grp,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET eq_desc = p_rec.eq_desc, zone_grp = p_rec.zone_grp,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_eq_zone giis_eqzone.eq_zone%TYPE)
   AS
   BEGIN
      DELETE FROM giis_eqzone
            WHERE eq_zone = p_eq_zone;
   END;

   PROCEDURE val_del_rec (p_eq_zone giis_eqzone.eq_zone%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_wfireitm a
                 WHERE a.eq_zone = p_eq_zone)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_EQZONE while dependent record(s) in GIPI_WFIREITM exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_fireitem a
                 WHERE a.eq_zone = p_eq_zone)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_EQZONE while dependent record(s) in GIPI_FIREITEM exists.'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_eq_zone   giis_eqzone.eq_zone%TYPE,
      p_eq_desc   giis_eqzone.eq_desc%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_eqzone a
                 WHERE UPPER (a.eq_zone) = UPPER (p_eq_zone))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same eq_zone.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM giis_eqzone a
                 WHERE UPPER (a.eq_desc) = UPPER (p_eq_desc))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same eq_desc.'
            );
         RETURN;
      END IF;
   END;
END;
/


