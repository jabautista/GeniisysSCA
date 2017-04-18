CREATE OR REPLACE PACKAGE BODY CPI.gicls100_pkg
AS
   FUNCTION get_rec_list (
      p_rec_stat_cd     giis_recovery_status.rec_stat_cd%TYPE,
      p_rec_stat_desc   giis_recovery_status.rec_stat_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT *
            FROM giis_recovery_status
           WHERE UPPER (rec_stat_cd) LIKE UPPER (NVL (p_rec_stat_cd, '%'))
             AND UPPER (rec_stat_desc) LIKE UPPER (NVL (p_rec_stat_desc, '%'))
             AND rec_stat_cd NOT IN (
                    SELECT param_value_v
                      FROM giis_parameters
                     WHERE param_name IN
                              ('CLOSE_REC_STAT', 'IN_PROGRESS_REC_STAT',
                               'CANCEL_REC_STAT', 'WRITE_OFF_REC_STAT')))
      LOOP
         v_rec.rec_stat_cd := i.rec_stat_cd;
         v_rec.rec_stat_desc := i.rec_stat_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_recovery_status%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_recovery_status
         USING DUAL
         ON (rec_stat_cd = p_rec.rec_stat_cd)
         WHEN NOT MATCHED THEN
            INSERT (rec_stat_cd, rec_stat_desc, rec_stat_type, remarks,
                    user_id, last_update)
            VALUES (p_rec.rec_stat_cd, p_rec.rec_stat_desc, 'N',
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET rec_stat_desc = p_rec.rec_stat_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_rec_stat_cd giis_recovery_status.rec_stat_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_recovery_status
            WHERE rec_stat_cd = p_rec_stat_cd;
   END;

   PROCEDURE val_del_rec (p_rec_stat_cd giis_recovery_status.rec_stat_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR rec IN (SELECT '1'
                    FROM gicl_rec_hist
                   WHERE rec_stat_cd = p_rec_stat_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_RECOVERY_STATUS while dependent record(s) in GICL_REC_HIST exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_rec_stat_cd     giis_recovery_status.rec_stat_cd%TYPE,
      p_rec_stat_desc   giis_recovery_status.rec_stat_desc%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_parameters
                 WHERE param_value_v = p_rec_stat_cd
                   AND param_name IN
                          ('CLOSE_REC_STAT', 'CANCEL_REC_STAT',
                           'WRITE_OFF_REC_STAT'))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         FOR stat IN (SELECT rec_stat_desc des
                        FROM giis_recovery_status
                       WHERE rec_stat_cd = p_rec_stat_cd)
         LOOP
            raise_application_error
               (-20001,
                   'Geniisys Exception#I#The recovery status '
                || p_rec_stat_cd
                || ' ('
                || stat.des
                || ') need not be entered. Code is already generated by the system.'
               );
            EXIT;
         END LOOP;
      END IF;

      FOR i IN (SELECT '1'
                  FROM giis_recovery_status a
                 WHERE a.rec_stat_cd = p_rec_stat_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same rec_stat_cd.'
            );
      END IF;

      FOR i IN (SELECT '1'
                  FROM giis_recovery_status a
                 WHERE a.rec_stat_desc = p_rec_stat_desc)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same rec_stat_desc.'
            );
      END IF;
   END;
END;
/


