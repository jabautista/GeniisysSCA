CREATE OR REPLACE PACKAGE BODY CPI.GICLS044_PKG
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 05.21.2013
    **  Reference By : GICLS044 - REASSIGN CLAIM RECORD
    */
   FUNCTION get_claim_details (
      p_line_cd       gicl_claims.line_cd%TYPE,
      p_all_user_sw   giis_users.all_user_sw%TYPE,
      p_user_id       giis_users.user_id%TYPE
   )
      RETURN claim_details_tab PIPELINED
   IS
      v_clm   claim_details_type;
   BEGIN
      FOR clm IN (SELECT   *
                      FROM gicl_claims
                     WHERE clm_stat_cd IN (SELECT clm_stat_cd
                                             FROM giis_clm_stat
                                            WHERE clm_stat_type = 'N')
                       AND in_hou_adj = DECODE (p_all_user_sw, 'Y', in_hou_adj, p_user_id)
                       --AND check_user_per_iss_cd (line_cd, iss_cd, 'GICLS044') = 1
                       --joanne 03.03.2014, replace code above to consider user_id
                       AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS044', p_user_id) = 1
                       AND line_cd = p_line_cd
                  ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
      LOOP
         v_clm.claim_id     := clm.claim_id;
         v_clm.line_cd      := clm.line_cd;
         v_clm.subline_cd   := clm.subline_cd;
         v_clm.iss_cd       := clm.iss_cd;
         v_clm.issue_yy     := clm.issue_yy;
         v_clm.pol_seq_no   := clm.pol_seq_no;
         v_clm.renew_no     := clm.renew_no;
         v_clm.pol_iss_cd   := clm.pol_iss_cd;
         v_clm.clm_stat_cd  := clm.clm_stat_cd;
         v_clm.in_hou_adj   := clm.in_hou_adj;
         v_clm.remarks      := clm.remarks;
         v_clm.plate_no     := clm.plate_no;
         v_clm.assd_no      := clm.assd_no;
         v_clm.user_id      := clm.user_id;
         v_clm.assured_name := clm.assured_name;
         v_clm.assd_name2   := clm.assd_name2;

         FOR assd IN (SELECT assured_name || ' ' || assd_name2 NAME
                        FROM gicl_claims
                       WHERE claim_id = v_clm.claim_id)
         LOOP
            v_clm.assd_name := assd.NAME;
            EXIT;
         END LOOP;

         FOR clm IN (SELECT clm_stat_desc stat_desc
                       FROM giis_clm_stat
                      WHERE clm_stat_cd = v_clm.clm_stat_cd)
         LOOP
            v_clm.claim_status := clm.stat_desc;
            EXIT;
         END LOOP;

         v_clm.policy_no :=
               clm.line_cd
            || '-'
            || clm.subline_cd
            || '-'
            || clm.pol_iss_cd
            || '-'
            || LTRIM (TO_CHAR (clm.issue_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (clm.pol_seq_no, '0999999'))
            || '-'
            || LTRIM (TO_CHAR (clm.renew_no, '09'));
         v_clm.claim_no :=
               clm.line_cd
            || '-'
            || clm.subline_cd
            || '-'
            || clm.iss_cd
            || '-'
            || LTRIM (TO_CHAR (clm.clm_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (clm.clm_seq_no, '0999999'));
         PIPE ROW (v_clm);
      END LOOP;

      RETURN;
   END get_claim_details;

   FUNCTION get_user_info
      RETURN user_info_tab PIPELINED
   IS
      v_user   user_info_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_users
                   WHERE user_id IN (
                            (SELECT DISTINCT (a.user_id)
                                        FROM giis_users a,
                                             giis_user_grp_modules b
                                       WHERE NVL (a.active_flag, 'N') = 'Y'
                                         AND b.module_id = 'GICLS002'
                                         AND a.user_grp = b.user_grp)
                            UNION
                            (SELECT DISTINCT (a.user_id)
                                        FROM giis_users a,
                                             giis_user_modules b
                                       WHERE b.module_id = 'GICLS002'
                                         AND a.user_id = b.userid
                                         AND NVL (a.active_flag, 'N') = 'Y'))
                     AND user_id IN (SELECT DISTINCT in_hou_adj
                                                FROM gicl_claims)
                ORDER BY user_id)
      LOOP
         v_user.user_id   := i.user_id;
         v_user.user_name := i.user_name;
         PIPE ROW (v_user);
      END LOOP;

      RETURN;
   END get_user_info;

   PROCEDURE update_claim_record (p_update_claim gicl_claims%ROWTYPE)
   IS
   BEGIN
      UPDATE gicl_claims
         SET in_hou_adj = p_update_claim.in_hou_adj,
             user_id = p_update_claim.user_id,
             last_update = SYSDATE
       WHERE claim_id   = p_update_claim.claim_id;
   END update_claim_record;

   FUNCTION get_user_lov (
      p_line_cd   gicl_claims.line_cd%TYPE,
      p_iss_cd    gicl_claims.iss_cd%TYPE
   )
      RETURN user_info_tab PIPELINED
   IS
      v_user   user_info_type;
   BEGIN
      FOR i IN (SELECT DISTINCT user_id, user_name
                           FROM giis_users
                          WHERE NVL (active_flag, 'N') = 'Y'
                            AND check_user_per_iss_cd2 (p_line_cd, p_iss_cd, 'GICLS002', user_id) = 1
                       ORDER BY user_id)
      LOOP
         v_user.user_id   := i.user_id;
         v_user.user_name := i.user_name;
         PIPE ROW (v_user);
      END LOOP;

      RETURN;
   END get_user_lov;

   FUNCTION reassign_processor_validation (p_user_id giis_users.user_id%TYPE)
      RETURN VARCHAR2
   IS
      v_mod_id       giac_modules.module_id%TYPE;
      v_func_exist   VARCHAR2 (1)                  := 'N';
      v_usr_exist    VARCHAR2 (1)                  := 'N';
      v_message      VARCHAR2 (2000);
   BEGIN
-- check if GICLS044 exists in giac_modules
      FOR module IN (SELECT module_id ID
                       FROM giac_modules
                      WHERE module_name = 'GICLS044')
      LOOP
         v_mod_id := module.ID;
         EXIT;
      END LOOP;

      IF v_mod_id IS NULL
      THEN
         v_message := 'Cannot continue with re-assigning claim to other processor. Module does not exist in giac_modules table. Please inform your MIS.';
      ELSE
-- if module exists, check if a function edxists for the module in giac_functions
         FOR fnctn IN (SELECT '1'
                         FROM giac_functions
                        WHERE module_id = v_mod_id AND function_code = 'RP')
         LOOP
            v_func_exist := 'Y';
            EXIT;
         END LOOP;

         IF v_func_exist = 'N'
         THEN
            v_message := 'Cannot continue with re-assigning claim to other processor. Function (Re-Assign Processor) does not exist in giac_functions table. Please inform your MIS.';
         ELSE
-- if function exists, check if user is declared in giac_user_functions
            FOR func_usr IN (SELECT '1'
                               FROM giac_user_functions
                              WHERE module_id = v_mod_id
                                AND function_code = 'RP'
                                AND user_id = p_user_id)
            LOOP
               v_usr_exist := 'Y';
               EXIT;
            END LOOP;

-- if all_user_sw = Y, user may re-assign is user is found in giac_user_functions
-- otherwise, user may only re-assign claim records which he processed.
            IF v_usr_exist = 'N'
            
            THEN
               v_message := 'Cannot re-assign claim to other processor. User must be authorized to do so. Please inform your MIS.';
            ELSE
               v_message := 'Y';
            END IF;
         END IF;
      END IF;

      RETURN v_message;
   END;
END GICLS044_PKG;
/


