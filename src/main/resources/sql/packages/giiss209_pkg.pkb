CREATE OR REPLACE PACKAGE BODY CPI.giiss209_pkg
AS
   FUNCTION get_binder_status_list (
      p_bndr_stat_cd       giis_binder_status.bndr_stat_cd%TYPE,
      p_bndr_stat_desc     giis_binder_status.bndr_stat_desc%TYPE,
      p_bndr_tag_meaning   cg_ref_codes.rv_meaning%TYPE
   )
      RETURN binder_status_tab PIPELINED
   IS
      v_rec   binder_status_type;
   BEGIN
      FOR i IN
         (SELECT a.bndr_stat_cd, a.bndr_stat_desc, a.bndr_tag,
                 b.rv_meaning dsp_bndr_tag_meaning, a.remarks, a.user_id,
                 a.last_update
            FROM giis_binder_status a, cg_ref_codes b
           WHERE a.bndr_tag = b.rv_low_value
             AND b.rv_domain = 'GIIS_BINDER_STATUS.BNDR_TAG'
             AND UPPER (a.bndr_stat_cd) LIKE UPPER (NVL (p_bndr_stat_cd, '%'))
             AND UPPER (a.bndr_stat_desc) LIKE
                                           UPPER (NVL (p_bndr_stat_desc, '%'))
             AND UPPER (b.rv_meaning) LIKE
                                         UPPER (NVL (p_bndr_tag_meaning, '%')))
      LOOP
         v_rec.bndr_stat_cd := i.bndr_stat_cd;
         v_rec.bndr_stat_desc := i.bndr_stat_desc;
         v_rec.bndr_tag := i.bndr_tag;
         v_rec.dsp_bndr_tag_meaning := i.dsp_bndr_tag_meaning;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                          TO_CHAR (i.last_update, 'mm-dd-yyyy HH12:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_binder_status_list;

   PROCEDURE set_binder_status (p_rec giis_binder_status%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_binder_status
         USING DUAL
         ON (bndr_stat_cd = p_rec.bndr_stat_cd)
         WHEN NOT MATCHED THEN
            INSERT (bndr_stat_cd, bndr_stat_desc, bndr_tag, remarks, user_id,
                    last_update)
            VALUES (p_rec.bndr_stat_cd, p_rec.bndr_stat_desc, p_rec.bndr_tag,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET bndr_stat_desc = p_rec.bndr_stat_desc,
                   bndr_tag = p_rec.bndr_tag, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = p_rec.last_update
            ;
   END set_binder_status;

   PROCEDURE del_binder_status (
      p_bndr_stat_cd   giis_binder_status.bndr_stat_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_binder_status
            WHERE bndr_stat_cd = p_bndr_stat_cd;
   END del_binder_status;

   PROCEDURE val_add_rec (
      p_bndr_stat_cd     giis_binder_status.bndr_stat_cd%TYPE,
      p_bndr_stat_desc   giis_binder_status.bndr_stat_desc%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_binder_status a
                 WHERE UPPER (a.bndr_stat_cd) = UPPER (p_bndr_stat_cd))
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same bndr_stat_cd.'
            );
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giis_binder_status a
                 WHERE UPPER (a.bndr_stat_desc) = UPPER (p_bndr_stat_desc))
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same bndr_stat_desc.'
            );
      END LOOP;
   END;

   PROCEDURE val_del_rec (p_bndr_stat_cd giis_binder_status.bndr_stat_cd%TYPE)
   AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giri_binder a
                 WHERE UPPER (a.bndr_stat_cd) = UPPER (p_bndr_stat_cd))
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_BINDER_STATUS while dependent records in GIRI_BINDER exists.'
            );
      END LOOP;
   END;
END;
/


