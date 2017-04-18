CREATE OR REPLACE PACKAGE BODY CPI.giis_modules_pkg
AS
   FUNCTION get_giis_modules_list (p_keyword VARCHAR2)
      RETURN giis_modules_tab
      PIPELINED
   IS
      v_giis_module   giis_modules_type;
   BEGIN
      FOR i
         IN (SELECT a.module_id,
                    a.module_desc,
                    a.user_id,
                    a.last_update,
                    a.remarks,
                    a.module_grp,
                    a.module_type,
                    b.rv_meaning mod_access_tag
               FROM giis_modules a, cg_ref_codes b
              WHERE     TO_CHAR (NVL (a.mod_access_tag, 2)) = b.rv_low_value
                    AND b.rv_domain = 'GIIS_MODULES_USER.ACCESS_TAG'
                    AND (   UPPER (a.module_id) LIKE
                               '%' || UPPER (p_keyword) || '%'
                         OR UPPER (a.module_desc) LIKE
                               '%' || UPPER (p_keyword) || '%'
                         OR UPPER (a.remarks) LIKE
                               '%' || UPPER (p_keyword) || '%'
                         OR UPPER (b.rv_meaning) LIKE
                               '%' || UPPER (p_keyword) || '%'
                         OR UPPER (a.module_type) LIKE
                               '%' || UPPER (p_keyword) || '%'))
      LOOP
         v_giis_module.module_id := i.module_id;
         v_giis_module.module_desc := i.module_desc;
         v_giis_module.user_id := i.user_id;
         v_giis_module.last_update := i.last_update;
         v_giis_module.remarks := i.remarks;
         v_giis_module.module_grp := i.module_grp;
         v_giis_module.module_type := i.module_type;
         v_giis_module.mod_access_tag := i.mod_access_tag;
         PIPE ROW (v_giis_module);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_giis_module (p_module_id         VARCHAR2,
                              p_module_desc       VARCHAR2,
                              p_user_id           VARCHAR2,
                              p_remarks           VARCHAR2,
                              p_module_grp        VARCHAR2,
                              p_module_type       VARCHAR2,
                              p_mod_access_tag    NUMBER)
   IS
   BEGIN
      INSERT INTO giis_modules (module_id,
                                module_desc,
                                user_id,
                                last_update,
                                remarks,
                                module_grp,
                                module_type,
                                mod_access_tag)
           VALUES (p_module_id,
                   p_module_desc,
                   p_user_id,
                   SYSDATE,
                   p_remarks,
                   p_module_grp,
                   p_module_type,
                   p_mod_access_tag);

      COMMIT;
   END;

   FUNCTION get_giis_modules (p_module_id VARCHAR2)
      RETURN giis_modules_tab
      PIPELINED
   IS
      giis_module   giis_modules_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_modules
                 WHERE module_id = p_module_id)
      LOOP
         giis_module.module_id := i.module_id;
         giis_module.module_desc := i.module_desc;
         giis_module.user_id := i.user_id;
         giis_module.remarks := i.remarks;
         giis_module.module_type := i.module_type;
         giis_module.module_grp := i.module_grp;
         giis_module.mod_access_tag := i.mod_access_tag;
         PIPE ROW (giis_module);
         EXIT;
      END LOOP;

      RETURN;
   END;

   PROCEDURE update_giis_module (p_module_id         VARCHAR2,
                                 p_module_desc       VARCHAR2,
                                 p_user_id           VARCHAR2,
                                 p_remarks           VARCHAR2,
                                 p_module_grp        VARCHAR2,
                                 p_module_type       VARCHAR2,
                                 p_mod_access_tag    NUMBER)
   IS
   BEGIN
      UPDATE giis_modules
         SET module_desc = p_module_desc,
             user_id = p_user_id,
             remarks = p_remarks,
             module_grp = p_module_grp,
             module_type = p_module_type,
             mod_access_tag = p_mod_access_tag
       WHERE module_id = p_module_id;

      COMMIT;
   END;
END giis_modules_pkg;
/


