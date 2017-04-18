CREATE OR REPLACE PACKAGE BODY CPI.giis_users_pkg
AS
   FUNCTION get_user_password (
      p_user_id         giis_users.user_id%TYPE,
      p_email_address   giis_users.email_address%TYPE
   )
      RETURN VARCHAR2
   IS
      v_password   giis_users.PASSWORD%TYPE;
   BEGIN
      FOR a IN (SELECT PASSWORD
                  FROM giis_users
                 WHERE user_id = p_user_id
                       AND email_address = p_email_address)
      LOOP
         v_password := a.PASSWORD;
         EXIT;
      END LOOP;

      RETURN (v_password);
   END get_user_password;

   FUNCTION get_giis_user (p_user_id giis_users.user_id%TYPE)
      RETURN giis_user_tab PIPELINED
   IS
      v_user   giis_user_type;
   BEGIN
      FOR a IN (SELECT a.user_id, a.user_grp, b.user_grp_desc, b.grp_iss_cd,
                       a.user_name, a.user_level, a.acctg_sw, a.claim_sw,
                       a.dist_sw, a.exp_sw, a.inq_sw, a.mis_sw, a.pol_sw,
                       a.rmd_sw, a.ri_sw, a.comm_update_tag, a.mgr_sw,
                       a.mktng_sw, a.all_user_sw, a.remarks, a.last_user_id,
                       a.last_update, a.active_flag, a.change_pass_sw,
                       a.workflow_tag, a.email_address, a.PASSWORD,
                       c.iss_name
                  FROM giis_users a, giis_user_grp_hdr b, giis_issource c
                 WHERE a.user_id = NVL (p_user_id, a.user_id)
                   AND a.user_grp = b.user_grp
                   AND b.grp_iss_cd = c.iss_cd)
      LOOP
         v_user.user_id := a.user_id;
         v_user.user_grp := a.user_grp;
         v_user.user_name := a.user_name;
         v_user.user_level := a.user_level;
         v_user.acctg_sw := a.acctg_sw;
         v_user.claim_sw := a.claim_sw;
         v_user.dist_sw := a.dist_sw;
         v_user.exp_sw := a.exp_sw;
         v_user.inq_sw := a.inq_sw;
         v_user.mis_sw := a.mis_sw;
         v_user.pol_sw := a.pol_sw;
         v_user.rmd_sw := a.rmd_sw;
         v_user.ri_sw := a.ri_sw;
         v_user.comm_update_tag := a.comm_update_tag;
         v_user.mgr_sw := a.mgr_sw;
         v_user.mktng_sw := a.mktng_sw;
         v_user.all_user_sw := a.all_user_sw;
         v_user.remarks := a.remarks;
         v_user.last_user_id := a.last_user_id;
         v_user.last_update := a.last_update;
         v_user.active_flag := a.active_flag;
         v_user.change_pass_sw := a.change_pass_sw;
         v_user.workflow_tag := a.workflow_tag;
         v_user.email_address := a.email_address;
         v_user.pass := a.PASSWORD;
         v_user.iss_cd := a.grp_iss_cd;
         v_user.iss_name := a.iss_name;
         v_user.user_grp_desc := a.user_grp_desc;
         PIPE ROW (v_user);
      END LOOP;

      RETURN;
   END get_giis_user;

   FUNCTION get_giis_users (
      p_param             giis_users.user_id%TYPE,
      p_active_flag       VARCHAR2,
      p_comm_update_tag   VARCHAR2,
      p_all_user_sw       VARCHAR2,
      p_mgr_sw            VARCHAR2,
      p_mktng_sw          VARCHAR2,
      p_mis_sw            VARCHAR2,
      p_workflow_tag      VARCHAR2
   )
      RETURN giis_user_tab PIPELINED
   IS
      v_user   giis_user_type;
   BEGIN
      FOR a IN (SELECT   a.user_id, a.user_grp, b.user_grp_desc,
                         b.grp_iss_cd, a.user_name, a.user_level, a.acctg_sw,
                         a.claim_sw, a.dist_sw, a.exp_sw, a.inq_sw, a.mis_sw,
                         a.pol_sw, a.rmd_sw, a.ri_sw, a.comm_update_tag,
                         a.mgr_sw, a.mktng_sw, a.all_user_sw, a.remarks,
                         a.last_user_id, a.last_update, a.active_flag,
                         a.change_pass_sw, a.workflow_tag, a.email_address,
                         a.PASSWORD, c.iss_name
                    FROM giis_users a, giis_user_grp_hdr b, giis_issource c
                   WHERE a.user_grp = b.user_grp
                     AND b.grp_iss_cd = c.iss_cd
                     AND (   a.user_id LIKE '%' || UPPER (p_param) || '%'
                          OR a.user_name LIKE '%' || UPPER (p_param) || '%'
                          OR b.user_grp_desc LIKE '%' || UPPER (p_param)
                                                  || '%'
                          OR c.iss_name LIKE '%' || UPPER (p_param) || '%'
                         )
                     AND DECODE (a.active_flag, 'Y', 'Y', 'N') =
                            NVL (p_active_flag,
                                 DECODE (a.active_flag, 'Y', 'Y', 'N')
                                )
                     AND DECODE (a.comm_update_tag, 'Y', 'Y', 'N') =
                            NVL (p_comm_update_tag,
                                 DECODE (a.comm_update_tag, 'Y', 'Y', 'N')
                                )
                     AND DECODE (a.all_user_sw, 'Y', 'Y', 'N') =
                            NVL (p_all_user_sw,
                                 DECODE (a.all_user_sw, 'Y', 'Y', 'N')
                                )
                     AND DECODE (a.mgr_sw, 'Y', 'Y', 'N') =
                              NVL (p_mgr_sw, DECODE (a.mgr_sw, 'Y', 'Y', 'N'))
                     AND DECODE (a.mktng_sw, 'Y', 'Y', 'N') =
                            NVL (p_mktng_sw,
                                 DECODE (a.mktng_sw, 'Y', 'Y', 'N')
                                )
                     AND DECODE (a.mis_sw, 'Y', 'Y', 'N') =
                              NVL (p_mis_sw, DECODE (a.mis_sw, 'Y', 'Y', 'N'))
                     AND DECODE (a.workflow_tag, 'Y', 'Y', 'N') =
                            NVL (p_workflow_tag,
                                 DECODE (a.workflow_tag, 'Y', 'Y', 'N')
                                )
                ORDER BY a.user_id, b.user_grp_desc)
      LOOP
         v_user.user_id := a.user_id;
         v_user.user_grp := a.user_grp;
         v_user.user_name := a.user_name;
         v_user.user_level := a.user_level;
         v_user.acctg_sw := a.acctg_sw;
         v_user.claim_sw := a.claim_sw;
         v_user.dist_sw := a.dist_sw;
         v_user.exp_sw := a.exp_sw;
         v_user.inq_sw := a.inq_sw;
         v_user.mis_sw := a.mis_sw;
         v_user.pol_sw := a.pol_sw;
         v_user.rmd_sw := a.rmd_sw;
         v_user.ri_sw := a.ri_sw;
         v_user.comm_update_tag := a.comm_update_tag;
         v_user.mgr_sw := a.mgr_sw;
         v_user.mktng_sw := a.mktng_sw;
         v_user.all_user_sw := a.all_user_sw;
         v_user.remarks := a.remarks;
         v_user.last_user_id := a.last_user_id;
         v_user.last_update := a.last_update;
         v_user.active_flag := a.active_flag;
         v_user.change_pass_sw := a.change_pass_sw;
         v_user.workflow_tag := a.workflow_tag;
         v_user.email_address := a.email_address;
         v_user.pass := a.PASSWORD;
         v_user.iss_cd := a.grp_iss_cd;
         v_user.iss_name := a.iss_name;
         v_user.user_grp_desc := a.user_grp_desc;
         PIPE ROW (v_user);
      END LOOP;

      RETURN;
   END get_giis_users;

   PROCEDURE set_giis_users (
      v_user_id               IN   giis_users.user_id%TYPE,
      v_user_grp              IN   giis_users.user_grp%TYPE,
      v_user_name             IN   giis_users.user_name%TYPE,
      v_user_level            IN   giis_users.user_level%TYPE,
      v_acctg_sw              IN   giis_users.acctg_sw%TYPE,
      v_claim_sw              IN   giis_users.claim_sw%TYPE,
      v_dist_sw               IN   giis_users.dist_sw%TYPE,
      v_exp_sw                IN   giis_users.exp_sw%TYPE,
      v_inq_sw                IN   giis_users.inq_sw%TYPE,
      v_mis_sw                IN   giis_users.mis_sw%TYPE,
      v_pol_sw                IN   giis_users.pol_sw%TYPE,
      v_rmd_sw                IN   giis_users.rmd_sw%TYPE,
      v_ri_sw                 IN   giis_users.ri_sw%TYPE,
      v_comm_update_tag       IN   giis_users.comm_update_tag%TYPE,
      v_mgr_sw                IN   giis_users.mgr_sw%TYPE,
      v_mktng_sw              IN   giis_users.mktng_sw%TYPE,
      v_all_user_sw           IN   giis_users.all_user_sw%TYPE,
      v_remarks               IN   giis_users.remarks%TYPE,
      v_last_user_id          IN   giis_users.last_user_id%TYPE,
      v_last_update           IN   giis_users.last_update%TYPE,
      v_active_flag           IN   giis_users.active_flag%TYPE,
      v_change_pass_sw        IN   giis_users.change_pass_sw%TYPE,
      v_workflow_tag          IN   giis_users.workflow_tag%TYPE,
      v_email_address         IN   giis_users.email_address%TYPE,
      v_password              IN   giis_users.PASSWORD%TYPE,
      v_last_password_reset   IN   giis_users.last_password_reset%TYPE,
      v_last_login            IN   giis_users.last_login%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_users
         USING DUAL
         ON (user_id = v_user_id)
         WHEN NOT MATCHED THEN
            INSERT (user_id, user_grp, user_name, user_level, acctg_sw,
                    claim_sw, dist_sw, exp_sw, inq_sw, mis_sw, pol_sw,
                    rmd_sw, ri_sw, comm_update_tag, mgr_sw, mktng_sw,
                    all_user_sw, remarks, last_user_id, last_update,
                    active_flag, change_pass_sw, workflow_tag, email_address,
                    PASSWORD
        --,last_password_reset,   last_login --commented by andrew 02.23.2011
                            )
            VALUES (v_user_id, v_user_grp, v_user_name, 1, v_acctg_sw,
                    v_claim_sw, v_dist_sw, v_exp_sw, v_inq_sw, v_mis_sw,
                    v_pol_sw, v_rmd_sw, v_ri_sw, v_comm_update_tag, v_mgr_sw,
                    v_mktng_sw, v_all_user_sw, v_remarks, v_last_user_id,
                    SYSDATE, v_active_flag, v_change_pass_sw, v_workflow_tag,
                    v_email_address,
                    v_password
    --,v_last_password_reset,   v_last_login --commented by andrew 02.23.2011
                              )
         WHEN MATCHED THEN
            UPDATE
               SET user_grp = v_user_grp, user_name = v_user_name,
                   user_level = 1, acctg_sw = v_acctg_sw,
                   claim_sw = v_claim_sw, dist_sw = v_dist_sw,
                   exp_sw = v_exp_sw, inq_sw = v_inq_sw, mis_sw = v_mis_sw,
                   pol_sw = v_pol_sw, rmd_sw = v_rmd_sw, ri_sw = v_ri_sw,
                   comm_update_tag = v_comm_update_tag, mgr_sw = v_mgr_sw,
                   mktng_sw = v_mktng_sw, all_user_sw = v_all_user_sw,
                   remarks = v_remarks, last_user_id = v_last_user_id,
                   last_update = SYSDATE, active_flag = v_active_flag,
                   change_pass_sw = v_change_pass_sw,
                   workflow_tag = v_workflow_tag,
                   email_address =
                      v_email_address
                                /*, --commented by andrew - 02.23.2011
                                ,PASSWORD             = v_password,
                                last_password_reset  = v_last_password_reset,
                                last_login           = v_last_login*/
            ;
      COMMIT;
   END set_giis_users;

   -- whofeih 02/12/2010
   FUNCTION get_giis_user_all_list
      RETURN giis_user_tab PIPELINED
   IS
      v_user   giis_user_type;
   BEGIN
      FOR i IN (SELECT   user_id, user_name, user_grp
                    FROM giis_users
                ORDER BY UPPER (user_id))
      LOOP
         v_user.user_id := i.user_id;
         v_user.user_name := i.user_name;
         v_user.user_grp := i.user_grp;
         PIPE ROW (v_user);
      END LOOP;

      RETURN;
   END get_giis_user_all_list;

   FUNCTION get_grp_iss_cd (p_user_id giis_users.user_id%TYPE)
      RETURN VARCHAR2
   IS
      grp_iss_cd   giis_user_grp_hdr.grp_iss_cd%TYPE;
   BEGIN
      BEGIN
         SELECT b.grp_iss_cd
           INTO grp_iss_cd
           FROM giis_users a, giis_user_grp_hdr b
          WHERE a.user_grp = b.user_grp AND a.user_id = NVL (p_user_id, USER);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN grp_iss_cd;
   END get_grp_iss_cd;

   /*
   * Created By:   Andrew Robes
   * Date:         February 04, 2011
   * Module:       (GIISS040 - Security - Users)
   * Description:  Procedure to reset the password
   */
   PROCEDURE reset_password (
      p_user_id        giis_users.user_id%TYPE,
      p_password       giis_users.PASSWORD%TYPE,
      p_last_user_id   giis_users.last_user_id%TYPE,
      p_salt           giis_users.salt%TYPE
   )
   IS
   BEGIN
      UPDATE giis_users
         SET PASSWORD = p_password,
             last_password_reset = SYSDATE,
             last_user_id = p_last_user_id,
             last_login = NULL,
             salt = p_salt,
             unchanged_pw = 'Y'
       WHERE UPPER(user_id) = UPPER(p_user_id);
   END reset_password;

   FUNCTION get_underwriters (p_user_id IN giis_users.user_id%TYPE)
      RETURN giis_user_tab PIPELINED
   IS
      v_user   giis_user_type;
   BEGIN
      FOR i IN (SELECT   user_id, user_name, user_grp
                    FROM giis_users
                   WHERE UPPER (user_id) LIKE NVL (p_user_id, user_id)
                ORDER BY UPPER (user_id))
      LOOP
         v_user.user_id := i.user_id;
         v_user.user_name := i.user_name;
         v_user.user_grp := i.user_grp;
         PIPE ROW (v_user);
      END LOOP;

      RETURN;
   END get_underwriters;

   /*
   * Created By:   Andrew Robes
   * Date:         July 25, 2011
   * Module:       (WOFLOW01- Workflow)
   * Description:  Function to retrieve the user list for workflow events
   */
   FUNCTION get_workflow_user_list (
      p_event_cd     gipi_user_events.event_cd%TYPE,
      p_event_type   giis_events.event_type%TYPE,
      p_app_user     giis_users.user_id%TYPE,
      p_tran_id      gipi_user_events.tran_id%TYPE,
      p_event_mod_cd gipi_user_events.event_mod_cd%TYPE,
      p_event_col_cd gipi_user_events.event_col_cd%TYPE,      
      p_create       VARCHAR2
   )
      RETURN workflow_user_tab PIPELINED
   IS
      TYPE v_cursor_ref IS REF CURSOR;
      c1 v_cursor_ref;
      v_rec_tab        workflow_user_type;      
      
      v_user           workflow_user_type;
      v_event_mod_cd   NUMBER;
      v_filter_where   VARCHAR2(3000);
      v_where          VARCHAR2(3000);
      v_query          VARCHAR2(32767);
   BEGIN
      IF p_create = 'Y' THEN
        v_event_mod_cd := giis_event_modules_pkg.get_event_mod_cd (p_event_cd, p_event_type);
      ELSE
        v_event_mod_cd := NVL(p_event_mod_cd,giis_event_modules_pkg.get_event_mod_cd (p_event_cd, p_event_type));
        v_filter_where := ' AND NOT EXISTS (SELECT 1 
	                                          FROM gipi_user_events z 
	                                         WHERE z.event_col_cd = :p_event_col_cd
									           AND z.tran_id = :p_tran_id
								               AND z.userid = a.user_id)';
      END IF;
      
      v_where := ' WHERE EXISTS (SELECT 1
	                 FROM giis_event_mod_users z
	                WHERE z.passing_userid = USER
                      AND z.event_mod_cd = NVL(NVL(TO_CHAR(:v_event_mod_cd),NULL),z.event_mod_cd)
                      AND a.active_flag = ''Y''
                      AND z.userid = a.user_id)';
                      
      v_query := 'SELECT a.user_id, a.user_name, a.user_grp, a.active_flag, a.email_address 
                    FROM giis_users a';
                        
      IF p_create = 'Y' THEN
        v_query := v_query || v_where;
        OPEN c1 FOR v_query USING v_event_mod_cd;
      ELSE
        v_query := v_query || v_where || v_filter_where;
        OPEN c1 FOR v_query USING v_event_mod_cd, p_event_col_cd, p_tran_id;        
      END IF;        
      
      LOOP
         FETCH c1 INTO v_rec_tab;
         EXIT WHEN c1%NOTFOUND;
         v_user.user_id         := v_rec_tab.user_id;
         v_user.user_name       := v_rec_tab.user_name;
         v_user.user_grp        := v_rec_tab.user_grp;
         v_user.email_address   := v_rec_tab.email_address;
         PIPE ROW (v_user);
      END LOOP;
      
      CLOSE c1;
            
      
--      FOR i IN (SELECT a.user_id, a.user_name, a.user_grp, a.active_flag,
--                       a.email_address
--                  FROM giis_users a
--                 WHERE EXISTS (
--                          SELECT 1
--                            FROM giis_event_mod_users z
--                           WHERE z.passing_userid = NVL (p_app_user, USER)
--                             AND z.event_mod_cd =
--                                    NVL (NVL (TO_CHAR (v_event_mod_cd), NULL),
--                                         z.event_mod_cd
--                                        )
--                             AND a.active_flag = 'Y'
--                             AND z.userid = a.user_id))
--      LOOP
--         v_user.user_id := i.user_id;
--         v_user.user_name := i.user_name;
--         v_user.user_grp := i.user_grp;
--         v_user.email_address := i.email_address;
--         PIPE ROW (v_user);
--      END LOOP;

      RETURN;
   END get_workflow_user_list;

   FUNCTION get_user_level (p_user_id giis_users.user_id%TYPE)
      RETURN NUMBER
   IS
      v_user_level   NUMBER;
   BEGIN
      SELECT user_level
        INTO v_user_level
        FROM giis_users
       WHERE user_id = p_user_id;

      RETURN v_user_level;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

/*
   * Created By:   Anthony Santos
   * Date:         Aug 10, 2011
   * Module:       (GICLS010- CLAIMS BASIC INFO)
   * Description:  Retrieves Claims Processor
   */
   FUNCTION get_user_by_iss_cd (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE,
      p_module_id    giis_modules.module_id%TYPE
   )
      RETURN giis_user_tab PIPELINED
   IS
   v_user giis_user_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.user_id, a.user_name
                           FROM giis_users a
                          WHERE NVL (a.active_flag, 'N') = 'Y'
                            AND check_user_per_iss_cd2 (p_line_cd,
                                                        p_pol_iss_cd,
                                                        p_module_id,
                                                        a.user_id
                                                       ) = 1)
      LOOP
         v_user.user_id := i.user_id;
         v_user.user_name := i.user_name;
         PIPE ROW(v_user);
      END LOOP;
   END;
   
   /*
   * Created By:   Robert Virrey
   * Date:         Sept 13, 2011
   * Module:       (GIEXS001- Extract Expiring Policies)
   * Description:  To validate if the user is allowed to extract the policies 
   *               based on the user's user group
   */
    PROCEDURE validate_user(
        p_user      IN  giis_users.user_id%TYPE,
        p_line_cd   IN  giis_user_grp_line.line_cd%TYPE,
        p_iss_cd    IN  giis_user_grp_line.iss_cd%TYPE,
        p_msg       OUT VARCHAR2
    )
    IS
      v_user_grp     giis_user_grp_hdr.user_grp%TYPE;
      v_allowed      VARCHAR2(1) := 'N';
    BEGIN
      FOR usr_grp IN (SELECT user_grp
                        FROM giis_users
                       WHERE user_id = p_user)
      LOOP
          v_user_grp := usr_grp.user_grp;
          EXIT;
      END LOOP;
      
      FOR grp IN (SELECT '1'
                    FROM giis_user_grp_line
                   WHERE user_grp = v_user_grp 
                     AND line_cd  = nvl(p_line_cd, line_cd)
                     AND iss_cd   = nvl(p_iss_cd, iss_cd))
      LOOP
        v_allowed := 'Y';
        EXIT;
      END LOOP;
      
      IF v_allowed = 'N' THEN
           p_msg := 'User is not allowed to extract expiring policies based from the parameter.';
      END IF;
    END validate_user;
    
    
   
   /*
   * Created By:   Andrew Robes
   * Date:         9.19.2011
   * Module:       (LOGIN)
   * Description:  Function to validate if the user is active or not
   */    
    FUNCTION validate_if_active_user(p_user_id GIIS_USERS.user_id%TYPE)
      RETURN VARCHAR2
    IS
    
      v_days_left NUMBER;
    BEGIN
      SELECT ROUND(sysdate-LAST_LOGIN)
        INTO v_days_left
        FROM giis_users
       WHERE user_id = p_user_id;
       
      IF v_days_left >= 30 -- grace period is currently fixed to 30 days
      THEN
        RETURN 'FALSE';
      ELSE 
        RETURN 'TRUE';
      END IF;    
    END validate_if_active_user;
    
    /*
   * Created By:   Kris Felipe
   * Date:         07.26.2013
   * Module:       GICLS051
   * Description:  Function get user stat
   */    
    PROCEDURE check_user_stat(
        p_function_cd       IN  giac_user_functions.function_code%TYPE,
        p_module_id         IN  giac_user_functions.module_id%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_all_user_sw       OUT giis_users.all_user_sw%TYPE,
        p_valid_tag         OUT giac_user_functions.valid_tag%TYPE
    ) IS
    
    BEGIN
        -- check all_user_sw of user
        FOR sw IN (SELECT all_user_sw aus
                     FROM giis_users
                    WHERE user_id = p_user_id)
        LOOP
            p_all_user_sw := sw.aus;
            EXIT;
        END LOOP;        
        
        -- check valid_tag of user
        FOR sw IN (SELECT valid_tag tag
                     FROM giac_user_functions
                    WHERE function_code = p_function_cd
                      AND module_id = p_module_id
                      AND user_id = p_user_id)
        LOOP
            p_valid_tag := sw.tag;
            EXIT;
        END LOOP;
        
    END check_user_stat;
    
    FUNCTION get_user_details(
      p_user_id giis_users.user_id%TYPE
    ) RETURN giis_user_tab PIPELINED
    AS
      v_user giis_user_type;
    BEGIN
      FOR a IN (SELECT a.user_id, a.user_grp,
                       a.user_name, a.user_level, a.acctg_sw, a.claim_sw,
                       a.dist_sw, a.exp_sw, a.inq_sw, a.mis_sw, a.pol_sw,
                       a.rmd_sw, a.ri_sw, a.comm_update_tag, a.mgr_sw,
                       a.mktng_sw, a.all_user_sw, a.remarks, a.last_user_id,
                       a.last_update, a.active_flag, a.change_pass_sw,
                       a.workflow_tag, a.email_address
                  FROM giis_users a
                 WHERE UPPER(a.user_id) = UPPER(p_user_id))
      LOOP
         v_user.user_id := a.user_id;
         v_user.user_grp := a.user_grp;
         v_user.user_name := a.user_name;
         v_user.user_level := a.user_level;
         v_user.acctg_sw := a.acctg_sw;
         v_user.claim_sw := a.claim_sw;
         v_user.dist_sw := a.dist_sw;
         v_user.exp_sw := a.exp_sw;
         v_user.inq_sw := a.inq_sw;
         v_user.mis_sw := a.mis_sw;
         v_user.pol_sw := a.pol_sw;
         v_user.rmd_sw := a.rmd_sw;
         v_user.ri_sw := a.ri_sw;
         v_user.comm_update_tag := a.comm_update_tag;
         v_user.mgr_sw := a.mgr_sw;
         v_user.mktng_sw := a.mktng_sw;
         v_user.all_user_sw := a.all_user_sw;
         v_user.remarks := a.remarks;
         v_user.last_user_id := a.last_user_id;
         v_user.last_update := a.last_update;
         v_user.active_flag := a.active_flag;
         v_user.change_pass_sw := a.change_pass_sw;
         v_user.workflow_tag := a.workflow_tag;
         v_user.email_address := a.email_address;
         
         PIPE ROW (v_user);
      END LOOP;

      RETURN;
    END;
    
    /* benjo 02.01.2016 GENQA-SR-4941 */
    FUNCTION validate_username (p_user_id giis_users.user_id%TYPE)
       RETURN VARCHAR2
    IS
       v_user_name       giis_users.user_name%TYPE       := NULL;
       v_email_address   giis_users.email_address%TYPE   := NULL;
       v_active_flag     giis_users.active_flag%TYPE   := NULL;
    BEGIN
       FOR i IN (SELECT user_name, email_address, active_flag
                   FROM giis_users
                  WHERE UPPER(user_id) = UPPER (p_user_id))
       LOOP
          v_user_name := i.user_name;
          v_email_address := i.email_address;
          v_active_flag := i.active_flag;
       END LOOP;

       IF v_user_name IS NULL
       THEN
          RETURN 'Username does not exist.';
       ELSIF v_email_address IS NULL
       THEN
          RETURN 'User has no maintained email address.';
       ELSIF v_active_flag = 'L'
       THEN
          RETURN 'User account is locked. Please contact your administrator for assistance.';
       ELSE
          RETURN 'SUCCESS';
       END IF;
    END validate_username;
    
    PROCEDURE save_pw_hist (
        p_user_id     giis_users_pw_hist.user_id%TYPE,
        p_salt        giis_users_pw_hist.salt%TYPE,
        p_password    giis_users_pw_hist.password%TYPE
    )
    IS
        v_no_of_prev_pw_to_store NUMBER := giisp.n('NO_OF_PREV_PW_TO_STORE');
        v_hist_id NUMBER;
    BEGIN
        
        BEGIN
            SELECT MAX(hist_id)
              INTO v_hist_id
              FROM giis_users_pw_hist;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_hist_id := 0;      
        END;
        
        v_hist_id := NVL(v_hist_id, 0) + 1;
        
        INSERT INTO giis_users_pw_hist
               (hist_id, user_id, password, salt, date_pw_used)
        VALUES (v_hist_id, UPPER(p_user_id), p_password, p_salt, SYSDATE);
        
        IF v_no_of_prev_pw_to_store <> 0 THEN
            BEGIN
                DELETE FROM giis_users_pw_hist
                 WHERE UPPER(user_id) = UPPER(p_user_id)
                   AND hist_id NOT IN (SELECT hist_id FROM (SELECT hist_id 
                                                              FROM giis_users_pw_hist
                                                             WHERE UPPER(user_id) = UPPER(p_user_id)                                          
                                                          ORDER BY date_pw_used DESC)
                                        WHERE ROWNUM <= v_no_of_prev_pw_to_store);
            END;
        END IF;
        
    END save_pw_hist;
    
    FUNCTION get_pw_hist (p_user_id VARCHAR2)
        RETURN pw_hist_tab PIPELINED
    IS
        v pw_hist_type;
    BEGIN
        FOR i IN (SELECT password, salt
                    FROM giis_users_pw_hist
                   WHERE UPPER(user_id) = UPPER(p_user_id))
        LOOP
            v.password := i.password;
            v.salt := i.salt;
            PIPE ROW(v);
        END LOOP;
    END get_pw_hist;
    
END giis_users_pkg;
/


