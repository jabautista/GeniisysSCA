CREATE OR REPLACE PACKAGE BODY CPI.giiss081_pkg
AS
   FUNCTION get_rec_list (
      p_module_id     giis_modules.module_id%TYPE,
      p_module_desc   giis_modules.module_desc%TYPE,
      p_module_type   giis_modules.module_type%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   *
              FROM giis_modules a
             WHERE UPPER (a.module_id) LIKE UPPER (NVL (p_module_id, '%'))
               AND UPPER (a.module_desc) LIKE UPPER (NVL (p_module_desc, '%'))
               AND UPPER (NVL (a.module_type, '%')) LIKE
                                              UPPER (NVL (p_module_type, '%'))
          ORDER BY a.module_id)
      LOOP
         v_rec.module_id := i.module_id;
         v_rec.module_desc := i.module_desc;
         v_rec.module_type := i.module_type;
         v_rec.module_grp := i.module_grp;
         v_rec.mod_access_tag := i.mod_access_tag;
         v_rec.web_enabled := i.web_enabled;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');

         BEGIN
            FOR rv IN (SELECT rv_meaning
                         FROM cg_ref_codes
                        WHERE rv_domain = 'GIIS_MODULES.MODULE_TYPE'
                          AND rv_low_value = i.module_type)
            LOOP
               v_rec.dsp_module_type_desc := rv.rv_meaning;
            END LOOP;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE val_del_rec (p_module_id giis_modules.module_id%TYPE)
   AS
   BEGIN
      FOR i IN (SELECT 1
                  FROM giis_modules_tran
                 WHERE module_id = p_module_id)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_MODULES while dependent record(s) in GIIS_MODULES_TRAN exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT 1
                  FROM giis_modules_user
                 WHERE module_id = p_module_id)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_MODULES while dependent record(s) in GIIS_MODULES_USER exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT 1
                  FROM giis_override_users
                 WHERE module_id = p_module_id)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_MODULES while dependent record(s) in GIIS_OVERRIDE_USERS exists.'
            );
         EXIT;
      END LOOP;
   END;

   PROCEDURE val_add_rec (
      p_module_id     giis_modules.module_id%TYPE,
      p_module_desc   giis_modules.module_desc%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT 1
                  FROM giis_modules
                 WHERE module_id = p_module_id)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same module_id.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT 1
                  FROM giis_modules
                 WHERE module_desc = p_module_desc)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same module_desc.'
            );
         EXIT;
      END LOOP;
   END;

   FUNCTION get_moduletype_lov (p_keyword VARCHAR2)
      RETURN module_type_lov_tab PIPELINED
   IS
      v_list   module_type_lov_type;
   BEGIN
      FOR i IN (SELECT   rv_low_value, rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIIS_MODULES.MODULE_TYPE'
                     AND (   UPPER (rv_low_value) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                          OR UPPER (rv_meaning) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                         )
                ORDER BY 2)
      LOOP
         v_list.module_type := i.rv_low_value;
         v_list.module_type_desc := i.rv_meaning;
         PIPE ROW (v_list);
      END LOOP;
   END;

   PROCEDURE set_rec (p_rec giis_modules%ROWTYPE)
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_modules
                 WHERE module_id = p_rec.module_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_modules
            SET module_desc = p_rec.module_desc,
                module_type = p_rec.module_type,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE module_id = p_rec.module_id;
      ELSE
         INSERT INTO giis_modules
                     (module_id, module_desc, module_type,
                      remarks, user_id, last_update
                     )
              VALUES (p_rec.module_id, p_rec.module_desc, p_rec.module_type,
                      p_rec.remarks, p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (p_module_id giis_modules.module_id%TYPE)
   AS
   BEGIN
      DELETE FROM giis_modules
            WHERE module_id = p_module_id;
   END;

   FUNCTION get_tranrec_list (
      p_module_id   giis_modules_tran.module_id%TYPE,
      p_tran_cd     giis_modules_tran.tran_cd%TYPE,
      p_tran_desc   giis_transaction.tran_desc%TYPE
   )
      RETURN tran_rec_tab PIPELINED
   IS
      v_rec   tran_rec_type;
   BEGIN
      FOR i IN (SELECT   a.*, b.tran_desc
                    FROM giis_modules_tran a, giis_transaction b
                   WHERE a.module_id = p_module_id
                     AND a.tran_cd = b.tran_cd
                     AND a.tran_cd = NVL (p_tran_cd, a.tran_cd)
                     AND UPPER (b.tran_desc) LIKE
                                                UPPER (NVL (p_tran_desc, '%'))
                ORDER BY a.tran_cd)
      LOOP
         v_rec.module_id := i.module_id;
         v_rec.tran_cd := i.tran_cd;
         v_rec.tran_desc := i.tran_desc;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_tran_lov (p_keyword VARCHAR2)
      RETURN tran_lov_tab PIPELINED
   IS
      v_list   tran_lov_type;
   BEGIN
      FOR i IN (SELECT   tran_cd, tran_desc
                    FROM giis_transaction
                   WHERE (   TO_CHAR (tran_cd) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                          OR UPPER (tran_desc) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                         )
                ORDER BY tran_cd)
      LOOP
         v_list.tran_cd := i.tran_cd;
         v_list.tran_desc := i.tran_desc;
         PIPE ROW (v_list);
      END LOOP;
   END;

   PROCEDURE val_deltran_rec (
      p_module_id   giis_modules_tran.module_id%TYPE,
      p_tran_cd     giis_modules_tran.tran_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT 1
                  FROM giis_user_modules
                 WHERE tran_cd = p_tran_cd AND module_id = p_module_id)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_TRANSACTION while dependent record(s) in GIIS_USER_MODULES exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT 1
                  FROM giis_user_grp_modules
                 WHERE tran_cd = p_tran_cd AND module_id = p_module_id)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_TRANSACTION while dependent record(s) in GIIS_USER_GRP_MODULES exists.'
            );
         EXIT;
      END LOOP;
   END;

   PROCEDURE val_addtran_rec (
      p_module_id   giis_modules_tran.module_id%TYPE,
      p_tran_cd     giis_modules_tran.tran_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT 1
                  FROM giis_modules_tran
                 WHERE module_id = p_module_id AND tran_cd = p_tran_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same tran_cd.'
            );
         EXIT;
      END LOOP;
   END;

   PROCEDURE set_tran_rec (p_rec giis_modules_tran%ROWTYPE)
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_modules_tran
                 WHERE module_id = p_rec.module_id
                       AND tran_cd = p_rec.tran_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_modules_tran
            SET user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE module_id = p_rec.module_id AND tran_cd = p_rec.tran_cd;
      ELSE
         INSERT INTO giis_modules_tran
                     (module_id, tran_cd, user_id, last_update
                     )
              VALUES (p_rec.module_id, p_rec.tran_cd, p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_tran_rec (
      p_module_id   giis_modules_tran.module_id%TYPE,
      p_tran_cd     giis_modules_tran.tran_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_modules_tran
            WHERE module_id = p_module_id AND tran_cd = p_tran_cd;
   END;

   FUNCTION get_usermodules_list (
      p_module_id    giis_user_modules.module_id%TYPE,
      p_userid       giis_user_modules.userid%TYPE,
      p_user_name    giis_users.user_name%TYPE,
      p_access_tag   giis_user_modules.access_tag%TYPE
   )
      RETURN user_modules_tab PIPELINED
   IS
      v_rec   user_modules_type;
   BEGIN
      FOR i IN (SELECT   a.*, b.user_name
                    FROM giis_user_modules a, giis_users b
                   WHERE a.module_id = p_module_id
                     AND a.userid = b.user_id
                     AND UPPER (a.userid) LIKE UPPER (NVL (p_userid, '%'))
                     AND UPPER (a.access_tag) LIKE
                                               UPPER (NVL (p_access_tag, '%'))
                     AND UPPER (b.user_name) LIKE
                                                UPPER (NVL (p_user_name, '%'))
                ORDER BY a.tran_cd)
      LOOP
         v_rec.userid := i.userid;
         v_rec.user_name := i.user_name;
         v_rec.access_tag := i.access_tag;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_usergrpmodules_list (
      p_module_id       giis_user_grp_modules.module_id%TYPE,
      p_user_grp        giis_user_grp_modules.user_grp%TYPE,
      p_user_grp_desc   giis_user_grp_hdr.user_grp_desc%TYPE,
      p_access_tag      giis_user_grp_modules.access_tag%TYPE,
      p_tran_cd         giis_user_grp_modules.tran_cd%TYPE
   )
      RETURN user_grp_modules_tab PIPELINED
   IS
      v_rec   user_grp_modules_type;
   BEGIN
      FOR i IN
         (SELECT   a.*, b.user_grp_desc
              FROM giis_user_grp_modules a, giis_user_grp_hdr b
             WHERE a.module_id = p_module_id
               AND a.user_grp = b.user_grp
               AND a.user_grp = NVL (p_user_grp, a.user_grp)
               AND UPPER (b.user_grp_desc) LIKE
                                            UPPER (NVL (p_user_grp_desc, '%'))
               AND a.tran_cd = NVL (p_tran_cd, a.tran_cd)
               AND UPPER (a.access_tag) LIKE UPPER (NVL (p_access_tag, '%'))
          ORDER BY a.user_grp)
      LOOP
         v_rec.user_grp := i.user_grp;
         v_rec.access_tag := i.access_tag;
         v_rec.tran_cd := i.tran_cd;
         v_rec.user_grp_desc := i.user_grp_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_users_list (
      p_user_grp    giis_users.user_grp%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_user_name   giis_users.user_name%TYPE
   )
      RETURN giis_users_tab PIPELINED
   IS
      v_rec   giis_users_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_users a
                   WHERE a.user_grp = p_user_grp
                     AND UPPER (a.user_id) LIKE UPPER (NVL (p_user_id, '%'))
                     AND UPPER (a.user_name) LIKE
                                                UPPER (NVL (p_user_name, '%'))
                ORDER BY a.user_grp)
      LOOP
         v_rec.user_id := i.user_id;
         v_rec.user_name := i.user_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
END;
/


