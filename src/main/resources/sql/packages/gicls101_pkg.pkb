CREATE OR REPLACE PACKAGE BODY CPI.gicls101_pkg
AS
   FUNCTION get_rec_list (
      p_rec_type_cd     giis_recovery_type.rec_type_cd%TYPE,
      p_rec_type_desc   giis_recovery_type.rec_type_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.rec_type_cd, a.rec_type_desc, a.remarks, a.user_id,
                   a.last_update
              FROM giis_recovery_type a
             WHERE UPPER (a.rec_type_cd) LIKE
                                             UPPER (NVL (p_rec_type_cd, '%'))
               AND UPPER (a.rec_type_desc) LIKE
                                            UPPER (NVL (p_rec_type_desc, '%'))
          ORDER BY a.rec_type_cd)
      LOOP
         v_rec.rec_type_cd := i.rec_type_cd;
         v_rec.rec_type_desc := i.rec_type_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_recovery_type%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_recovery_type
         USING DUAL
         ON (rec_type_cd = p_rec.rec_type_cd)
         WHEN NOT MATCHED THEN
            INSERT (rec_type_cd, rec_type_desc, remarks, user_id,
                    last_update)
            VALUES (p_rec.rec_type_cd, p_rec.rec_type_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET rec_type_desc = p_rec.rec_type_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_rec_type_cd giis_recovery_type.rec_type_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_recovery_type
            WHERE rec_type_cd = p_rec_type_cd;
   END;

   PROCEDURE val_del_rec (p_rec_type_cd giis_recovery_type.rec_type_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR rec IN (SELECT '1'
                    FROM gicl_clm_recovery
                   WHERE rec_type_cd = p_rec_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_RECOVERY_TYPE while dependent record(s) in GICL_CLM_RECOVERY exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (p_rec_type_cd giis_recovery_type.rec_type_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_recovery_type a
                 WHERE a.rec_type_cd = p_rec_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same rec_type_cd.'
            );
      END IF;
   END;
END;
/


