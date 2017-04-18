CREATE OR REPLACE PACKAGE BODY CPI.giiss040_pkg
AS
   PROCEDURE when_new_form_instance (
      p_restrict_gen2file_by_user OUT giis_parameters.param_value_v%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'RESTRICT_GEN2FILE_BY_USER')
      LOOP
         p_restrict_gen2file_by_user := i.param_value_v;
      END LOOP;
   END;

   FUNCTION get_rec_list (
      p_user_id             giis_users.user_id%TYPE,
      p_user_name           giis_users.user_name%TYPE,
      p_active_flag         giis_users.active_flag%TYPE,
      p_comm_update_tag     giis_users.comm_update_tag%TYPE,
      p_all_user_sw         giis_users.all_user_sw%TYPE,
      p_mgr_sw              giis_users.mgr_sw%TYPE,
      p_mktng_sw            giis_users.mktng_sw%TYPE,
      p_mis_sw              giis_users.mis_sw%TYPE,
      p_workflow_tag        giis_users.workflow_tag%TYPE,
      p_temp_access_tag     giis_users.temp_access_tag%TYPE,
      p_allow_gen_file_sw   giis_users.allow_gen_file_sw%TYPE,
      p_user_grp            giis_users.user_grp%TYPE,
      p_user_grp_desc       giis_user_grp_hdr.user_grp_desc%TYPE,
      p_iss_cd              giis_user_grp_hdr.grp_iss_cd%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.user_id, a.user_name, a.active_flag, a.comm_update_tag,
                   a.all_user_sw, a.mgr_sw, a.mktng_sw, a.mis_sw,
                   a.workflow_tag, a.temp_access_tag, a.allow_gen_file_sw,
                   a.user_grp, b.user_grp_desc, b.grp_iss_cd, a.remarks,
                   a.last_user_id, a.last_update, a.email_address, a.password
              FROM giis_users a, giis_user_grp_hdr b
             WHERE UPPER (a.user_id) LIKE UPPER (NVL (p_user_id, '%'))
               AND UPPER (a.user_name) LIKE UPPER (NVL (p_user_name, '%'))
               AND UPPER (NVL (a.active_flag, 'N')) LIKE
                                              UPPER (NVL (p_active_flag, '%'))
               AND UPPER (NVL (a.comm_update_tag, 'N')) LIKE
                                          UPPER (NVL (p_comm_update_tag, '%'))
               AND UPPER (NVL (a.all_user_sw, 'N')) LIKE
                                              UPPER (NVL (p_all_user_sw, '%'))
               AND UPPER (NVL (a.mgr_sw, 'N')) LIKE
                                                   UPPER (NVL (p_mgr_sw, '%'))
               AND UPPER (NVL (a.mktng_sw, 'N')) LIKE
                                                 UPPER (NVL (p_mktng_sw, '%'))
               AND UPPER (NVL (a.mis_sw, 'N')) LIKE
                                                   UPPER (NVL (p_mis_sw, '%'))
               AND UPPER (NVL (a.workflow_tag, 'N')) LIKE
                                             UPPER (NVL (p_workflow_tag, '%'))
               AND UPPER (NVL (a.temp_access_tag, 'N')) LIKE
                                          UPPER (NVL (p_temp_access_tag, '%'))
               AND UPPER (NVL (a.allow_gen_file_sw, 'N')) LIKE
                                        UPPER (NVL (p_allow_gen_file_sw, '%'))
               AND a.user_grp = NVL (p_user_grp, a.user_grp)
               AND UPPER (b.user_grp_desc) LIKE
                                            UPPER (NVL (p_user_grp_desc, '%'))
               AND UPPER (b.grp_iss_cd) LIKE UPPER (NVL (p_iss_cd, '%'))
               AND a.user_grp = b.user_grp
          ORDER BY a.user_id, a.user_name)
      LOOP
         v_rec.user_id := i.user_id;
         v_rec.user_name := i.user_name;
         v_rec.active_flag := NVL(i.active_flag,'N');
         v_rec.comm_update_tag := NVL(i.comm_update_tag,'N');
         v_rec.all_user_sw := NVL(i.all_user_sw,'N');
         v_rec.mgr_sw := NVL(i.mgr_sw,'N');
         v_rec.mktng_sw := NVL(i.mktng_sw,'N');
         v_rec.mis_sw := NVL(i.mis_sw,'N');
         v_rec.workflow_tag := NVL(i.workflow_tag,'N');
         v_rec.temp_access_tag := NVL(i.temp_access_tag,'N');
         v_rec.allow_gen_file_sw := NVL(i.allow_gen_file_sw,'N');
         v_rec.user_grp := i.user_grp;
         v_rec.dsp_user_grp_desc := i.user_grp_desc;
         v_rec.dsp_grp_iss_cd := i.grp_iss_cd;
         v_rec.remarks := i.remarks;
         v_rec.last_user_id := i.last_user_id;
         v_rec.email_address := i.email_address;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.password := i.password; -- apollo cruz 03.01.2016
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_users%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_users
         USING DUAL
         ON (user_id = p_rec.user_id)
         WHEN NOT MATCHED THEN
            INSERT (user_id, user_name, active_flag, comm_update_tag,
                    all_user_sw, mgr_sw, mktng_sw, mis_sw, workflow_tag,
                    temp_access_tag, allow_gen_file_sw, user_grp, remarks,
                    last_user_id, last_update, user_level, email_address)
            VALUES (p_rec.user_id, p_rec.user_name, p_rec.active_flag,
                    p_rec.comm_update_tag, p_rec.all_user_sw, p_rec.mgr_sw,
                    p_rec.mktng_sw, p_rec.mis_sw, p_rec.workflow_tag,
                    p_rec.temp_access_tag, p_rec.allow_gen_file_sw,
                    p_rec.user_grp, p_rec.remarks, p_rec.last_user_id,
                    SYSDATE, p_rec.user_level, p_rec.email_address)
         WHEN MATCHED THEN
            UPDATE
               SET user_name = p_rec.user_name,
                   active_flag = p_rec.active_flag,
                   comm_update_tag = p_rec.comm_update_tag,
                   all_user_sw = p_rec.all_user_sw, mgr_sw = p_rec.mgr_sw,
                   mktng_sw = p_rec.mktng_sw, mis_sw = p_rec.mis_sw,
                   workflow_tag = p_rec.workflow_tag,
                   temp_access_tag = p_rec.temp_access_tag,
                   allow_gen_file_sw = p_rec.allow_gen_file_sw,
                   user_grp = p_rec.user_grp, remarks = p_rec.remarks,
                   last_user_id = p_rec.last_user_id, last_update = SYSDATE,
                   email_address = p_rec.email_address
            ;
   END;

   PROCEDURE del_rec (p_user_id giis_users.user_id%TYPE)
   AS
   BEGIN
      DELETE FROM giis_users
            WHERE user_id = p_user_id;
   END;

   PROCEDURE val_del_rec (p_user_id giis_users.user_id%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giis_peril_class a
                 WHERE a.user_id = p_user_id)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_USERS while dependent record(s) in GIIS_PERIL_CLASS exists.'
            );
      END LOOP;
      
      FOR i IN (SELECT 1
                  FROM giis_modules_user a
                 WHERE a.user_id = p_user_id)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_USERS while dependent record(s) in GIIS_MODULES_USER exists.'
            );
      END LOOP;
      
      FOR i IN (SELECT 1
                  FROM giis_override_users a
                 WHERE a.userid = p_user_id)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_USERS while dependent record(s) in GIIS_OVERRIDE_USERS exists.'
            );
      END LOOP;
      
      FOR i IN (SELECT 1
                  FROM gipi_parlist a
                 WHERE a.underwriter = p_user_id)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_USERS while dependent record(s) in GIPI_PARLIST exists.'
            );
      END LOOP;
      
      FOR i IN (SELECT 1
                  FROM gipi_reinstate_hist a
                 WHERE a.user_id = p_user_id)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_USERS while dependent record(s) in GIPI_REINSTATE_HIST exists.'
            );
      END LOOP;

--      IF v_exists = 'Y'
--      THEN
--         raise_application_error
--            (-20001,
--             'Geniisys Exception#E#Cannot delete record from GIIS_USERS while dependent record(s) in GIIS_PERIL_CLASS exists.'
--            );
--      END IF;
   END;

   PROCEDURE val_add_rec (p_user_id giis_users.user_id%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_users a
                 WHERE a.user_id = p_user_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same user_id.'
            );
      END IF;
   END;

   FUNCTION get_user_grp_lov (p_find_text VARCHAR2)
      RETURN user_grp_lov_tab PIPELINED
   IS
      v_user_grp   user_grp_lov_type;
   BEGIN
      FOR a IN
         (SELECT   a.user_grp, a.user_grp_desc, a.grp_iss_cd
              FROM giis_user_grp_hdr a
             WHERE (   a.user_grp LIKE NVL (p_find_text, a.user_grp)
                    OR UPPER (a.user_grp_desc) LIKE
                                                NVL (UPPER (p_find_text), '%')
                    OR UPPER (a.grp_iss_cd) LIKE
                                                NVL (UPPER (p_find_text), '%')
                   )
          ORDER BY a.user_grp)
      LOOP
         v_user_grp.user_grp := a.user_grp;
         v_user_grp.user_grp_desc := a.user_grp_desc;
         v_user_grp.grp_iss_cd := a.grp_iss_cd;
         PIPE ROW (v_user_grp);
      END LOOP;

      RETURN;
   END get_user_grp_lov;

   FUNCTION get_user_grp_trans (
      p_user_grp    giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd     giis_transaction.tran_cd%TYPE,
      p_tran_desc   giis_transaction.tran_desc%TYPE
   )
      RETURN user_grp_trans_tab PIPELINED
   IS
      v_rec   user_grp_trans_type;
   BEGIN
      FOR i IN (SELECT   a.tran_cd, b.tran_desc
                    FROM giis_user_grp_tran a, giis_transaction b
                   WHERE UPPER (a.tran_cd) LIKE NVL (UPPER (p_tran_cd), '%')
                     AND UPPER (b.tran_desc) LIKE NVL (UPPER (p_tran_desc), '%')
                     AND a.tran_cd = b.tran_cd
                     AND a.user_grp = p_user_grp
                ORDER BY b.tran_desc)
      LOOP
         v_rec.tran_cd := i.tran_cd;
         v_rec.tran_desc := i.tran_desc;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_user_grp_trans;

   FUNCTION get_user_grp_dtl (
      p_user_grp   giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd    giis_transaction.tran_cd%TYPE,
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_iss_name   giis_issource.iss_name%TYPE
   )
      RETURN user_grp_dtl_tab PIPELINED
   IS
      v_rec   user_grp_dtl_type;
   BEGIN
      FOR i IN (SELECT   a.iss_cd, b.iss_name
                    FROM giis_user_grp_dtl a, giis_issource b
                   WHERE UPPER (a.iss_cd) LIKE NVL (UPPER (p_iss_cd), '%')
                     AND UPPER (b.iss_name) LIKE NVL (UPPER (p_iss_name), '%')
                     AND a.iss_cd = b.iss_cd
                     AND a.tran_cd = p_tran_cd
                     AND a.user_grp = p_user_grp
                ORDER BY b.iss_cd)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.iss_name := i.iss_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_user_grp_dtl;

   FUNCTION get_user_grp_line (
      p_user_grp    giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd     giis_transaction.tran_cd%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_line_cd     giis_line.line_cd%TYPE,
      p_line_name   giis_line.line_name%TYPE
   )
      RETURN user_grp_line_tab PIPELINED
   IS
      v_rec   user_grp_line_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, b.line_name
                    FROM giis_user_grp_line a, giis_line b
                   WHERE UPPER (a.line_cd) LIKE NVL (UPPER (p_line_cd), '%')
                     AND UPPER (b.line_name) LIKE
                                                NVL (UPPER (p_line_name), '%')
                     AND a.line_cd = b.line_cd
                     AND a.iss_cd = p_iss_cd
                     AND a.tran_cd = p_tran_cd
                     AND a.user_grp = p_user_grp
                ORDER BY b.line_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_user_grp_line;

   FUNCTION get_modules_tran (
      p_tran_cd               giis_modules_tran.tran_cd%TYPE,
      p_user_grp              giis_user_grp_tran.user_grp%TYPE,
      p_module_id             giis_modules.module_id%TYPE,
      p_module_desc           giis_modules.module_desc%TYPE,
      p_dsp_access_tag_desc   VARCHAR2
   )
      RETURN modules_tran_tab PIPELINED
   IS
      v_rec   modules_tran_type;
   BEGIN
      FOR i IN (SELECT   a.module_id, a.tran_cd, a.user_id, a.last_update,
                         b.module_desc, c.access_tag,
                         d.rv_meaning dsp_access_tag_desc,
                         DECODE (c.access_tag, NULL, 'N', 'Y') inc_tag
                    FROM giis_modules_tran a,
                         giis_modules b,
                         giis_user_grp_modules c,
                         cg_ref_codes d
                   WHERE UPPER (a.module_id) LIKE NVL (UPPER (p_module_id), '%')
                     AND d.rv_domain(+) = 'GIIS_MODULES_USER.ACCESS_TAG'
                     AND d.rv_low_value(+) = c.access_tag
                     AND a.module_id = b.module_id
                     AND c.user_grp(+) = p_user_grp
                     AND c.module_id(+) = b.module_id
                     AND c.tran_cd(+) = p_tran_cd
                     AND a.tran_cd = p_tran_cd
                ORDER BY a.module_id)
      LOOP
         v_rec.module_id := i.module_id;
         v_rec.tran_cd := i.tran_cd;
         v_rec.user_id := i.user_id;
         v_rec.module_desc := i.module_desc;
         v_rec.dsp_access_tag := i.access_tag;
         v_rec.dsp_access_tag_desc := i.dsp_access_tag_desc;
         v_rec.inc_tag := i.inc_tag;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_modules_tran;

   FUNCTION get_user_tran (
      p_userid        giis_user_tran.userid%TYPE,
      p_tran_cd       giis_transaction.tran_cd%TYPE,
      p_tran_desc     giis_transaction.tran_desc%TYPE,
      p_inc_all_tag   VARCHAR2
   )
      RETURN user_tran_tab PIPELINED
   IS
      v_rec      user_tran_type;
      v_not_in   VARCHAR2 (1000);
   BEGIN
      FOR i IN (SELECT a.tran_cd
                  FROM giis_user_tran a
                 WHERE a.userid = p_userid)
      LOOP
         IF v_not_in IS NOT NULL
         THEN
            v_not_in := v_not_in || ',';
         END IF;

         v_not_in := v_not_in || i.tran_cd;
      END LOOP;

      FOR i IN
         (SELECT   a.tran_cd, b.tran_desc
              FROM giis_user_tran a, giis_transaction b
             WHERE UPPER (a.tran_cd) LIKE NVL (UPPER (p_tran_cd), '%')
               AND UPPER (b.tran_desc) LIKE NVL (UPPER (p_tran_desc), '%')
               --AND UPPER (NVL (a.access_tag, 'N')) LIKE NVL (UPPER (p_inc_all_tag), '%')
               AND a.tran_cd = b.tran_cd
               AND a.userid = p_userid
          ORDER BY b.tran_desc)
      LOOP
         v_rec.inc_all_tag := 'Y';
         v_rec.tran_cd := i.tran_cd;
         v_rec.tran_desc := i.tran_desc;
         v_rec.not_in := v_not_in;

         FOR b IN (SELECT DISTINCT a.module_id
                              FROM giis_modules a, giis_modules_tran b
                             WHERE a.module_id = b.module_id
                               AND b.tran_cd = i.tran_cd
                               AND NOT EXISTS (
                                      SELECT module_id
                                        FROM giis_user_modules
                                       WHERE userid = p_userid
                                         AND tran_cd = i.tran_cd
                                         AND module_id IN (a.module_id)))
         LOOP
            v_rec.inc_all_tag := 'N';
         END LOOP;

         v_rec.inc_all_tag := NVL (v_rec.inc_all_tag, 'Y');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_user_tran;

   FUNCTION get_tran_lov (p_find_text VARCHAR2)
      RETURN user_tran_tab PIPELINED
   IS
      v_rec   user_tran_type;
   BEGIN
      FOR i IN (SELECT   tran_cd, tran_desc
                    FROM giis_transaction
                   WHERE UPPER (tran_cd) LIKE UPPER (NVL (p_find_text, '%'))
                      OR UPPER (tran_desc) LIKE UPPER (NVL (p_find_text, '%'))
                ORDER BY tran_desc)
      LOOP
         v_rec.tran_cd := i.tran_cd;
         v_rec.tran_desc := i.tran_desc;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_tran_lov;

   FUNCTION get_user_iss_cd (
      p_userid     giis_user_tran.userid%TYPE,
      p_tran_cd    giis_transaction.tran_cd%TYPE,
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_iss_name   giis_issource.iss_name%TYPE
   )
      RETURN user_iss_cd_tab PIPELINED
   IS
      v_rec      user_iss_cd_type;
      v_not_in   VARCHAR2 (1000);
   BEGIN
      FOR i IN (SELECT REGEXP_REPLACE (a.iss_cd, '''', '''''') iss_cd
                  FROM giis_user_iss_cd a
                 WHERE a.userid = p_userid AND a.tran_cd = p_tran_cd)
      LOOP
         IF v_not_in IS NOT NULL
         THEN
            v_not_in := v_not_in || ',';
         END IF;

         v_not_in := v_not_in || '''' || i.iss_cd || '''';
      END LOOP;

      FOR i IN (SELECT   a.iss_cd, b.iss_name, a.tran_cd
                    FROM giis_user_iss_cd a, giis_issource b
                   WHERE UPPER (a.iss_cd) LIKE NVL (UPPER (p_iss_cd), '%')
                     AND UPPER (b.iss_name) LIKE NVL (UPPER (p_iss_name), '%')
                     AND a.iss_cd = b.iss_cd
                     AND a.tran_cd = p_tran_cd
                     AND a.userid = p_userid
                ORDER BY b.iss_cd)
      LOOP
         v_rec.tran_cd := i.tran_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.iss_name := i.iss_name;
         v_rec.not_in := v_not_in;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_user_iss_cd;

   FUNCTION get_iss_lov (p_find_text VARCHAR2)
      RETURN user_iss_cd_tab PIPELINED
   IS
      v_rec   user_iss_cd_type;
   BEGIN
      FOR i IN (SELECT   iss_cd, iss_name
                    FROM giis_issource
                   WHERE UPPER (iss_cd) LIKE UPPER (NVL (p_find_text, '%'))
                      OR UPPER (iss_name) LIKE UPPER (NVL (p_find_text, '%'))
                ORDER BY iss_cd)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.iss_name := i.iss_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_iss_lov;

   FUNCTION get_user_line (
      p_userid      giis_user_tran.userid%TYPE,
      p_tran_cd     giis_transaction.tran_cd%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_line_cd     giis_line.line_cd%TYPE,
      p_line_name   giis_line.line_name%TYPE
   )
      RETURN user_line_tab PIPELINED
   IS
      v_rec      user_line_type;
      v_not_in   VARCHAR2 (1000);
   BEGIN
      FOR i IN (SELECT REGEXP_REPLACE (a.line_cd, '''', '''''') line_cd
                  FROM giis_user_line a
                 WHERE a.userid = p_userid
                   AND a.tran_cd = p_tran_cd
                   AND a.iss_cd = p_iss_cd)
      LOOP
         IF v_not_in IS NOT NULL
         THEN
            v_not_in := v_not_in || ',';
         END IF;

         v_not_in := v_not_in || '''' || i.line_cd || '''';
      END LOOP;

      FOR i IN (SELECT   a.line_cd, b.line_name, a.tran_cd, a.iss_cd
                    FROM giis_user_line a, giis_line b
                   WHERE UPPER (a.line_cd) LIKE NVL (UPPER (p_line_cd), '%')
                     AND UPPER (b.line_name) LIKE
                                                NVL (UPPER (p_line_name), '%')
                     AND a.line_cd = b.line_cd
                     AND a.iss_cd = p_iss_cd
                     AND a.tran_cd = p_tran_cd
                     AND a.userid = p_userid
                ORDER BY b.line_cd)
      LOOP
         v_rec.tran_cd := i.tran_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         v_rec.not_in := v_not_in;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_user_line;

   FUNCTION get_line_lov (p_find_text VARCHAR2)
      RETURN user_line_tab PIPELINED
   IS
      v_rec   user_line_type;
   BEGIN
      FOR i IN (SELECT   a150.line_cd, a150.line_name
                    FROM giis_line a150
                   WHERE UPPER (a150.line_cd) LIKE
                                               UPPER (NVL (p_find_text, '%'))
                      OR UPPER (a150.line_name) LIKE
                                                UPPER (NVL (p_find_text, '%'))
                ORDER BY a150.line_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_line_lov;

   FUNCTION get_user_modules (
      p_tran_cd               giis_modules_tran.tran_cd%TYPE,
      p_userid                giis_user_modules.userid%TYPE,
      p_module_id             giis_modules.module_id%TYPE,
      p_module_desc           giis_modules.module_desc%TYPE,
      p_dsp_access_tag_desc   VARCHAR2
   )
      RETURN user_modules_tab PIPELINED
   IS
      v_rec   user_modules_type;
   BEGIN
      FOR i IN
         (SELECT   a.module_id, a.tran_cd, c.user_id, c.last_update,
                   b.module_desc, c.access_tag,
                   d.rv_meaning dsp_access_tag_desc, c.remarks,
                   DECODE (c.access_tag, NULL, 'N', 'Y') inc_tag
              FROM giis_modules_tran a,
                   giis_modules b,
                   giis_user_modules c,
                   cg_ref_codes d
             WHERE UPPER (a.module_id) LIKE NVL (UPPER (p_module_id), '%')
               AND UPPER (b.module_desc) LIKE NVL (UPPER (p_module_desc), '%')
               AND UPPER (NVL(d.rv_meaning, '%')) LIKE NVL (UPPER (p_dsp_access_tag_desc), '%')
               AND d.rv_domain(+) = 'GIIS_MODULES_USER.ACCESS_TAG'
               AND d.rv_low_value(+) = c.access_tag
               AND a.module_id = b.module_id
               AND c.userid(+) = p_userid
               AND c.module_id(+) = b.module_id
               AND c.tran_cd(+) = p_tran_cd
               AND a.tran_cd = p_tran_cd
          ORDER BY a.module_id)
      LOOP
         v_rec.module_id := i.module_id;
         v_rec.tran_cd := i.tran_cd;
         v_rec.user_id := i.user_id;
         v_rec.module_desc := i.module_desc;
         v_rec.dsp_access_tag := i.access_tag;
         v_rec.dsp_access_tag_desc := i.dsp_access_tag_desc;
         v_rec.inc_tag := i.inc_tag;
         v_rec.remarks := i.remarks;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_user_modules;

   PROCEDURE set_user_module (
      p_app_user               giis_users.user_id%TYPE,
      p_tran_cd                giis_modules_tran.tran_cd%TYPE,
      p_user_id                giis_users.user_id%TYPE,
      p_module_id              giis_modules_tran.module_id%TYPE,
      p_inc_tag                VARCHAR2,
      p_dsp_access_tag         giis_user_modules.access_tag%TYPE,
      p_remarks                giis_user_modules.remarks%TYPE,
      p_inc_all_tag      OUT   VARCHAR2
   )
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      giis_users_pkg.app_user := p_app_user;

      FOR a IN (SELECT 1
                  FROM giis_user_modules
                 WHERE userid = p_user_id
                   AND module_id = p_module_id
                   AND tran_cd = p_tran_cd)
      LOOP
         v_exists := 'Y';
      END LOOP;
      
      IF v_exists = 'N'
      THEN
         IF p_inc_tag = 'Y'
         THEN
            INSERT INTO giis_user_modules
                        (userid, module_id, access_tag,
                         tran_cd, remarks
                        )
                 VALUES (p_user_id, p_module_id, p_dsp_access_tag,
                         p_tran_cd, p_remarks
                        );
         END IF;
      ELSE
         IF p_inc_tag = 'N'
         THEN
            DELETE FROM giis_user_modules
                  WHERE userid = p_user_id
                    AND module_id = p_module_id
                    AND tran_cd = p_tran_cd;
         ELSIF p_inc_tag = 'Y'
         THEN
            UPDATE giis_user_modules
               SET remarks = p_remarks,
                   access_tag = p_dsp_access_tag
             WHERE userid = p_user_id
               AND module_id = p_module_id
               AND tran_cd = p_tran_cd;
         END IF;
      END IF;

      v_exists := 'N';
      p_inc_all_tag := 'Y';

      FOR b IN (SELECT DISTINCT a.module_id
                           FROM giis_modules a, giis_modules_tran b
                          WHERE a.module_id = b.module_id
                            AND b.tran_cd = p_tran_cd
                            AND NOT EXISTS (
                                   SELECT module_id
                                     FROM giis_user_modules
                                    WHERE userid = p_user_id
                                      AND tran_cd = p_tran_cd
                                      AND module_id IN (a.module_id)))
      LOOP
         p_inc_all_tag := 'N';
      END LOOP;
   END;

   PROCEDURE check_all (
      p_tran_cd             giis_modules_tran.tran_cd%TYPE,
      p_userid              giis_user_modules.userid%TYPE,
      p_inc_all_tag   OUT   VARCHAR2
   )
   IS
      v_exists       VARCHAR2 (1) := 'N';
      v_access_tag   VARCHAR2 (1) := NULL;
   BEGIN
      FOR i IN (SELECT   a.module_id, a.tran_cd, a.user_id
                    FROM giis_modules_tran a
                   WHERE a.tran_cd = p_tran_cd
                ORDER BY a.module_id)
      LOOP
         v_access_tag := '1';

         FOR a IN (SELECT 1
                     FROM giis_user_modules
                    WHERE userid = p_userid
                      AND module_id = i.module_id
                      AND tran_cd = i.tran_cd)
         LOOP
            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N'
         THEN
            INSERT INTO giis_user_modules
                        (userid, module_id, tran_cd, access_tag
                        )
                 VALUES (p_userid, i.module_id, i.tran_cd, v_access_tag
                        );
         ELSE
            UPDATE giis_user_modules
               SET access_tag = v_access_tag
             WHERE userid = p_userid
               AND module_id = i.module_id
               AND tran_cd = i.tran_cd;
         END IF;

         v_exists := 'N';
      END LOOP;

      p_inc_all_tag := 'Y';
   END;

   PROCEDURE uncheck_all (
      p_tran_cd             giis_modules_tran.tran_cd%TYPE,
      p_userid              giis_user_modules.userid%TYPE,
      p_inc_all_tag   OUT   VARCHAR2
   )
   IS
      v_exists       VARCHAR2 (1) := 'N';
      v_access_tag   VARCHAR2 (1) := NULL;
   BEGIN
      DELETE FROM giis_user_modules
            WHERE userid = p_userid AND tran_cd = p_tran_cd;

      p_inc_all_tag := 'Y';
   END;

   PROCEDURE del_user_tran (
      p_tran_cd   giis_modules_tran.tran_cd%TYPE,
      p_userid    giis_user_modules.userid%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_user_line
            WHERE userid = p_userid AND tran_cd = p_tran_cd;

      DELETE FROM giis_user_iss_cd
            WHERE userid = p_userid AND tran_cd = p_tran_cd;

      DELETE FROM giis_user_modules
            WHERE userid = p_userid AND tran_cd = p_tran_cd;

      DELETE FROM giis_user_tran
            WHERE userid = p_userid AND tran_cd = p_tran_cd;
   END;

   PROCEDURE set_user_tran (
      p_userid       giis_user_modules.userid%TYPE,
      p_tran_cd      giis_modules_tran.tran_cd%TYPE,
      p_access_tag   giis_user_tran.access_tag%TYPE
   )
   IS
      v_inc_all_tag   VARCHAR2 (1) := NULL;
   BEGIN
      INSERT INTO giis_user_tran
                  (userid, tran_cd, access_tag,
                   create_user, create_date
                  )
           VALUES (p_userid, p_tran_cd, p_access_tag,
                   giis_users_pkg.app_user, SYSDATE
                  );

      IF p_access_tag = 'Y'
      THEN
         check_all (p_tran_cd, p_userid, v_inc_all_tag);
      END IF;
   END;

   PROCEDURE del_user_iss (
      p_userid    giis_user_iss_cd.userid%TYPE,
      p_tran_cd   giis_user_iss_cd.tran_cd%TYPE,
      p_iss_cd    giis_user_iss_cd.iss_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_user_line
            WHERE userid = p_userid
              AND tran_cd = p_tran_cd
              AND iss_cd = p_iss_cd;

      DELETE FROM giis_user_iss_cd
            WHERE userid = p_userid
              AND tran_cd = p_tran_cd
              AND iss_cd = p_iss_cd;
   END;

   PROCEDURE set_user_iss (
      p_userid    giis_user_iss_cd.userid%TYPE,
      p_tran_cd   giis_user_iss_cd.tran_cd%TYPE,
      p_iss_cd    giis_user_iss_cd.iss_cd%TYPE
   )
   IS
      v_inc_all_tag   VARCHAR2 (1) := NULL;
      v_exists        VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT 1
                  FROM giis_user_iss_cd
                 WHERE userid = p_userid
                   AND tran_cd = p_tran_cd
                   AND iss_cd = p_iss_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'N'
      THEN
         INSERT INTO giis_user_iss_cd
                     (userid, tran_cd, iss_cd,
                      create_user, create_date
                     )
              VALUES (p_userid, p_tran_cd, p_iss_cd,
                      giis_users_pkg.app_user, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_user_line (
      p_userid    giis_user_line.userid%TYPE,
      p_tran_cd   giis_user_line.tran_cd%TYPE,
      p_iss_cd    giis_user_line.iss_cd%TYPE,
      p_line_cd   giis_user_line.line_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_user_line
            WHERE userid = p_userid
              AND tran_cd = p_tran_cd
              AND iss_cd = p_iss_cd
              AND line_cd = p_line_cd;
   END;

   PROCEDURE set_user_line (
      p_userid    giis_user_line.userid%TYPE,
      p_tran_cd   giis_user_line.tran_cd%TYPE,
      p_iss_cd    giis_user_line.iss_cd%TYPE,
      p_line_cd   giis_user_line.line_cd%TYPE
   )
   IS
      v_inc_all_tag   VARCHAR2 (1) := NULL;
      v_exists        VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT 1
                  FROM giis_user_line
                 WHERE userid = p_userid
                   AND tran_cd = p_tran_cd
                   AND iss_cd = p_iss_cd
                   AND line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'N'
      THEN
         INSERT INTO giis_user_line
                     (userid, tran_cd, iss_cd, line_cd,
                      create_user, create_date
                     )
              VALUES (p_userid, p_tran_cd, p_iss_cd, p_line_cd,
                      giis_users_pkg.app_user, SYSDATE
                     );
      END IF;
   END;

   FUNCTION include_all_iss_codes
      RETURN user_iss_cd_tab PIPELINED
   IS
      v_rec   user_iss_cd_type;
   BEGIN
      FOR i IN (SELECT   iss_cd, iss_name
                    FROM giis_issource
                ORDER BY iss_cd)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.iss_name := i.iss_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION include_all_line_codes
      RETURN user_line_tab PIPELINED
   IS
      v_rec   user_line_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                ORDER BY line_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;
   
   PROCEDURE val_del_tran_1 (
      p_iss_cd   giis_issource.iss_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_parlist a
                 WHERE UPPER(a.iss_cd) = UPPER(p_iss_cd))
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_USER_ISS_CD while dependent record(s) in GIPI_PARLIST exists.'
            );
         EXIT;
      END LOOP;
   END;
   
   PROCEDURE val_del_tran_1_line (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_parlist a
                 WHERE UPPER(a.iss_cd) = UPPER(p_iss_cd)
                   AND UPPER(a.line_cd) = UPPER(p_line_cd))
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_USER_LINE while dependent record(s) in GIPI_PARLIST exists.'
            );
         EXIT;
      END LOOP;
   END;
END;
/


