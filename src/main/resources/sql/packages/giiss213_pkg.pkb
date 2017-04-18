CREATE OR REPLACE PACKAGE BODY CPI.GIISS213_PKG
AS
   FUNCTION get_rec_list (p_line_cd giis_peril_group.line_cd%TYPE)
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.peril_grp_cd, a.peril_grp_desc,
                         a.user_id, a.remarks, a.last_update
                    FROM giis_peril_group a
                   WHERE line_cd = p_line_cd
                ORDER BY a.peril_grp_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.peril_grp_cd := i.peril_grp_cd;
         v_rec.peril_grp_desc := i.peril_grp_desc;
         v_rec.user_id := i.user_id;
         v_rec.remarks := i.remarks;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_peril_group%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_peril_group
         USING DUAL
         ON (peril_grp_cd = p_rec.peril_grp_cd AND line_cd = p_rec.line_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, peril_grp_cd, peril_grp_desc, user_id, remarks,
                    last_update)
            VALUES (p_rec.line_cd, p_rec.peril_grp_cd, p_rec.peril_grp_desc,
                    p_rec.user_id, p_rec.remarks, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET peril_grp_desc = p_rec.peril_grp_desc,
                   user_id = p_rec.user_id, remarks = p_rec.remarks,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (
      p_line_cd        giis_peril_group.line_cd%TYPE,
      p_peril_grp_cd   giis_peril_group.peril_grp_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_peril_group
            WHERE line_cd = p_line_cd AND peril_grp_cd = p_peril_grp_cd;
   END;

   PROCEDURE val_del_rec (
      p_line_cd        giis_peril_group.line_cd%TYPE,
      p_peril_grp_cd   giis_peril_group.peril_grp_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_peril_group_dtl a
                 WHERE line_cd = p_line_cd AND peril_grp_cd = p_peril_grp_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_PERIL_GROUP while dependent record(s) in GIIS_PERIL_GROUP_DTL exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_line_cd        giis_peril_group.line_cd%TYPE,
      p_peril_grp_cd   giis_peril_group.peril_grp_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_peril_group a
                 WHERE line_cd = p_line_cd AND peril_grp_cd = p_peril_grp_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Row exists already with same peril_grp_cd.'
            );
      END IF;
   END;

   FUNCTION get_line_rec_list (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_rec_tab PIPELINED
   IS
      v_line_rec   line_rec_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE check_user_per_line2 (line_cd,
                                               NULL,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
                     AND pack_pol_flag = 'N'
                ORDER BY line_cd)
      LOOP
         v_line_rec.line_cd := i.line_cd;
         v_line_rec.line_name := i.line_name;
         PIPE ROW (v_line_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_peril_rec_list (p_line_cd giis_peril_group.line_cd%TYPE)
      RETURN peril_rec_tab PIPELINED
   IS
      v_peril_rec   peril_rec_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT peril_cd, peril_name
                     FROM giis_peril a
                    WHERE line_cd = p_line_cd
                      AND peril_cd NOT IN (
                             SELECT peril_cd
                               FROM giis_peril_group_dtl
                              WHERE line_cd = p_line_cd
                                AND peril_grp_cd IN (
                                                     SELECT peril_grp_cd
                                                       FROM giis_peril_group
                                                      WHERE line_cd =
                                                                     p_line_cd))
                 ORDER BY 1)
      LOOP
         v_peril_rec.peril_cd := i.peril_cd;
         v_peril_rec.peril_name := i.peril_name;
         PIPE ROW (v_peril_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_attached_peril_rec_list (
      p_line_cd        giis_peril_group.line_cd%TYPE,
      p_peril_grp_cd   giis_peril_group.peril_grp_cd%TYPE
   )
      RETURN attach_peril_rec_tab PIPELINED
   IS
      v_peril_rec   attach_peril_rec_type;
   BEGIN
      FOR i IN (SELECT   line_cd, peril_grp_cd, peril_cd, user_id, remarks,
                         last_update
                    FROM giis_peril_group_dtl
                   WHERE line_cd = p_line_cd
                         AND peril_grp_cd = p_peril_grp_cd
                ORDER BY 1)
      LOOP
         v_peril_rec.line_cd := i.line_cd;
         v_peril_rec.peril_grp_cd := i.peril_grp_cd;
         v_peril_rec.peril_cd := i.peril_cd;
         v_peril_rec.remarks := i.remarks;
         v_peril_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_peril_rec.user_id := i.user_id;

         BEGIN
            SELECT peril_name
              INTO v_peril_rec.peril_name
              FROM giis_peril
             WHERE line_cd = p_line_cd AND peril_cd = i.peril_cd;
         END;

         BEGIN
            SELECT peril_grp_desc
              INTO v_peril_rec.peril_grp_desc
              FROM giis_peril_group
             WHERE line_cd = p_line_cd AND peril_grp_cd = i.peril_grp_cd;
         END;

         PIPE ROW (v_peril_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_peril_rec (p_rec giis_peril_group_dtl%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_peril_group_dtl
         USING DUAL
         ON (    peril_grp_cd = p_rec.peril_grp_cd
             AND line_cd = p_rec.line_cd
             AND peril_cd = p_rec.peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, peril_grp_cd, peril_cd, user_id, remarks,
                    last_update)
            VALUES (p_rec.line_cd, p_rec.peril_grp_cd, p_rec.peril_cd,
                    p_rec.user_id, p_rec.remarks, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET user_id = p_rec.user_id, remarks = p_rec.remarks,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_peril_rec (
      p_line_cd        giis_peril_group.line_cd%TYPE,
      p_peril_grp_cd   giis_peril_group.peril_grp_cd%TYPE,
      p_peril_cd       giis_peril_group_dtl.peril_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_peril_group_dtl
            WHERE line_cd = p_line_cd
              AND peril_grp_cd = p_peril_grp_cd
              AND peril_cd = p_peril_cd;
   END;
END GIISS213_PKG;
/


