CREATE OR REPLACE PACKAGE BODY CPI.giis_issource_pkg
AS
   /********************************** FUNCTION 1 ************************************/
   FUNCTION get_issue_source_list (p_iss_cd giis_issource.iss_cd%TYPE)
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE iss_cd = p_iss_cd)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;

      RETURN;
   END get_issue_source_list;

   /********************************** FUNCTION 2 ************************************
     MODULE: GIPIS002
     RECORD GROUP NAME: ISS_SOURCE
   ***********************************************************************************/
   FUNCTION get_issue_source_all_list
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name FROM giis_issource)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;

      RETURN;
   END get_issue_source_all_list;

   /********************************** FUNCTION 3 ************************************
     MODULE: GIPIS050
     RECORD GROUP NAME: CGFK$B240_ISS_CD
   ***********************************************************************************/

   FUNCTION get_checked_issue_source_list (
      p_line_cd      giis_line.line_cd%TYPE,
      p_user_id      VARCHAR2,
      p_module_id    giis_user_grp_modules.module_id%TYPE)
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
      FOR i IN (  SELECT iss_cd, iss_name
                    FROM giis_issource
                   WHERE     check_user_per_iss_cd2 (p_line_cd,
                                                     iss_cd,
                                                     p_module_id,
                                                     p_user_id) = 1
                         AND iss_cd != 'RI'
                         AND NVL (claim_tag, 'N') != 'Y'
                ORDER BY iss_cd)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;

      RETURN;
   END get_checked_issue_source_list;

   FUNCTION get_iss_name (p_iss_cd IN giis_issource.iss_cd%TYPE)
      RETURN VARCHAR2
   IS
      p_iss_name   giis_issource.iss_name%TYPE;
   BEGIN
      FOR i IN (SELECT iss_name
                  FROM giis_issource
                 WHERE iss_cd = p_iss_cd)
      LOOP
         p_iss_name := i.iss_name;
         EXIT;
      END LOOP;

      RETURN p_iss_name;
   END get_iss_name;

   FUNCTION get_iss_code (p_iss_name IN giis_issource.iss_name%TYPE)
      RETURN VARCHAR2
   IS
      v_iss_cd   giis_issource.iss_cd%TYPE;
   BEGIN
      FOR i IN (SELECT iss_cd
                  FROM giis_issource
                 WHERE iss_name = p_iss_name)
      LOOP
         v_iss_cd := i.iss_cd;
         EXIT;
      END LOOP;

      RETURN v_iss_cd;
   END get_iss_code;

   FUNCTION get_iss_code (parameter_ri_switch    VARCHAR2,
                          cg$ctrl_cgu$user       VARCHAR2)
      RETURN VARCHAR2
   IS
      ho_cd         VARCHAR2 (2);
      v_iss_cd      giis_issource.iss_cd%TYPE;
      b240_iss_cd   VARCHAR2 (2) := '';
   BEGIN
      FOR iss IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'ISS_CD_RI')
      LOOP
         v_iss_cd := iss.param_value_v;
      END LOOP;

      SELECT param_value_v
        INTO ho_cd
        FROM giis_parameters
       WHERE param_name = 'ISS_CD_HO';

      BEGIN
         IF parameter_ri_switch = 'Y'
         THEN
            /*SELECT b.grp_iss_cd
              INTO b240_iss_cd
              FROM giis_user_grp_hdr b, giis_users a
             WHERE b.user_grp = a.user_grp
               AND a.user_id = NVL (cg$ctrl_cgu$user, USER)
               AND b.grp_iss_cd = ho_cd;*/
            b240_iss_cd := v_iss_cd;
         ELSE
            SELECT b.grp_iss_cd
              INTO b240_iss_cd
              FROM giis_user_grp_hdr b, giis_users a
             WHERE     b.user_grp = a.user_grp
                   AND a.user_id = NVL (cg$ctrl_cgu$user, USER)
                   AND b.grp_iss_cd = ho_cd;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               FOR a
                  IN (SELECT b.grp_iss_cd grp_iss_cd
                        FROM giis_user_grp_hdr b, giis_users a
                       WHERE     b.user_grp = a.user_grp
                             AND a.user_id = NVL (cg$ctrl_cgu$user, USER))
               LOOP
                  b240_iss_cd := a.grp_iss_cd;
               END LOOP;
            END;
      END;

      RETURN b240_iss_cd;
   END get_iss_code;

   /********************************** FUNCTION ************************************
  MODULE: GIACS007
  RECORD GROUP NAME: GDPC_ISS_CD1
***********************************************************************************/

   FUNCTION get_iss_code_per_acctg_module (modulename    VARCHAR2,
                                           p_user_id     VARCHAR2) --added another parameter p_user_id: alfie 04/18/2011
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
      FOR i IN (SELECT a.iss_cd, a.iss_name
                  FROM giis_issource a
                 WHERE     EXISTS
                              (SELECT 'X'
                                 FROM giac_aging_soa_details b
                                WHERE b.iss_cd = a.iss_cd)
                       -- AND a.iss_cd = DECODE (GIIS_USER_ISS_CD_PKG.CHECK_USER_PER_ISS_CD_ACCTG2 (
                       AND a.iss_cd = DECODE (CHECK_USER_PER_ISS_CD_ACCTG2 ( --robert 10.03.2014
                                                 NULL,
                                                 a.iss_cd,
                                                 modulename,
                                                 p_user_id --added by alfie 04/18/2011
                                                          ),
                                              1, a.iss_cd,
                                              NULL))
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;

      RETURN;
   END get_iss_code_per_acctg_module;

   /********************************** FUNCTION ************************************
  MODULE: GIACS020
  RECORD GROUP NAME: ISS_CD_GROUP
***********************************************************************************/
   FUNCTION get_iss_cd_for_comm_invoice (p_module_name    VARCHAR2,
                                         p_user_id        VARCHAR2)
      RETURN issue_source_acctg_list_tab
      PIPELINED
   IS
      v_iss_source   issue_source_acctg_list_type;
   BEGIN
      FOR i IN (SELECT a.iss_cd, a.iss_name
                  FROM giis_issource a
                 WHERE     EXISTS
                              (SELECT 'X'
                                 FROM gipi_comm_invoice
                                WHERE iss_cd = a.iss_cd)
                       AND a.iss_cd = DECODE (CHECK_USER_PER_ISS_CD_ACCTG2 ( -- changed from GIIS_USER_ISS_CD_PKG.CHECK_USER_PER_ISS_CD_ACCTG2 ( : shan 10.15.2014
                                                 NULL,
                                                 a.iss_cd,
                                                 p_module_name,
                                                 p_user_id),
                                              1, a.iss_cd,
                                              NULL))
      LOOP
         v_iss_source.iss_cd := i.iss_cd;
         v_iss_source.iss_name := i.iss_name;

         SELECT CHECK_USER_PER_ISS_CD_ACCTG2 ( -- changed from GIIS_USER_ISS_CD_PKG.CHECK_USER_PER_ISS_CD_ACCTG2 ( : shan 10.14.2014
                   NULL,
                   i.iss_cd,
                   p_module_name,
                   p_user_id)
           INTO v_iss_source.user_iss_cd_access
           FROM DUAL;

         PIPE ROW (v_iss_source);
      END LOOP;
   END get_iss_cd_for_comm_invoice;

   /********************************** FUNCTION ************************************
  MODULE: GIACS018
  RECORD GROUP NAME: ISS_RG
***********************************************************************************/
   FUNCTION get_gicl_advice_iss_cd_listing (
      p_tran_type      GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
      p_iss_cd         GIIS_ISSOURCE.iss_cd%TYPE,
      p_module_name    GIAC_MODULES.module_name%TYPE,
      p_user_id        giis_users.user_id%TYPE)
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss_source   issue_source_list_type;
   BEGIN
      IF p_tran_type = 1
      THEN
         FOR i IN (SELECT DISTINCT a.iss_cd, b.iss_name
                     FROM gicl_advice a, giis_issource b
                    WHERE     b.iss_cd = a.iss_cd
                          AND a.advice_flag = 'Y'
                          AND a.iss_cd = p_iss_cd
                          AND CHECK_USER_PER_ISS_CD_ACCTG2 (NULL,
                                                            a.iss_cd,
                                                            p_module_name,
                                                            p_user_id) = 1)
         LOOP
            v_iss_source.iss_cd := i.iss_cd;
            v_iss_source.iss_name := i.iss_name;

            PIPE ROW (v_iss_source);
         END LOOP;
      ELSE
         FOR i IN (SELECT DISTINCT a.iss_cd, c.iss_name
                     FROM gicl_advice a, gicl_clm_loss_exp b, giis_issource c
                    WHERE     a.claim_id = b.claim_id
                          AND a.advice_id = b.advice_id
                          AND a.iss_cd = c.iss_cd
                          AND b.tran_id IS NOT NULL
                          AND a.iss_cd = p_iss_cd
                          AND CHECK_USER_PER_ISS_CD_ACCTG2 (NULL,
                                                            a.iss_cd,
                                                            p_module_name,
                                                            p_user_id) = 1)
         LOOP
            v_iss_source.iss_cd := i.iss_cd;
            v_iss_source.iss_name := i.iss_name;

            PIPE ROW (v_iss_source);
         END LOOP;
      END IF;
   END get_gicl_advice_iss_cd_listing;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  11-15-2010
   **  Reference By : (GIACS002 - Basic Information)
   **  Description  :  ACCT_ISS_CD_RG record group
   */
   FUNCTION get_acct_iss_cd_list
      RETURN acct_iss_cd_list_tab
      PIPELINED
   IS
      v_iss   acct_iss_cd_list_type;
   BEGIN
      FOR i IN (  SELECT iss_cd, iss_name, acct_iss_cd
                    FROM giis_issource
                ORDER BY acct_iss_cd)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         v_iss.acct_iss_cd := i.acct_iss_cd;
         PIPE ROW (v_iss);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by      : Veronica V. Raymundo
   **  Date Created  : January 15, 2011
   **  Reference By  : (GIPIS050A- Package Par Creation), (GIPIS056A- Package Par Creation - Endt)
   **  Description   : Function returns valid issue_source listing for package par
   */

   FUNCTION get_pack_par_issue_source_list (
      p_line_cd      GIIS_LINE.line_cd%TYPE,
      p_module_id    GIIS_USER_GRP_MODULES.module_id%TYPE,
      p_user_id      GIIS_USERS.user_id%TYPE,
      p_ri_switch    VARCHAR2)
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
      v_ri    GIIS_ISSOURCE.iss_cd%TYPE;
   BEGIN
      FOR iss IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'ISS_CD_RI')
      LOOP
         v_ri := iss.param_value_v;
      END LOOP;

      FOR i
         IN (  SELECT iss_cd iss_cd, iss_name iss_name
                 FROM giis_issource
                WHERE     iss_cd =
                             ANY (SELECT iss_cd
                                    FROM giis_user_grp_dtl
                                   WHERE     DECODE (p_ri_switch,
                                                     'Y', '1',
                                                     iss_cd) !=
                                                DECODE (p_ri_switch,
                                                        'Y', '2',
                                                        v_ri)
                                         AND user_grp =
                                                (SELECT DISTINCT user_grp
                                                   FROM giis_users
                                                  WHERE user_id = p_user_id))
                      AND NVL (claim_tag, 'N') != 'Y'
                      AND iss_cd =
                             DECODE (check_user_per_iss_cd1 (p_line_cd,
                                                             iss_cd,
                                                             p_user_id,
                                                             p_module_id),
                                     1, iss_cd,
                                     NULL)
             ORDER BY iss_cd)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;

      RETURN;
   END get_pack_par_issue_source_list;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 03.25.2011
   **  Reference By     : (GIPIS095 - Package Policy Items)
   **  Description     : Get the region_cd based on the given iss_cd
   */
   FUNCTION get_region_cd (p_iss_cd IN giis_issource.iss_cd%TYPE)
      RETURN giis_issource.region_cd%TYPE
   IS
      v_region_cd   giis_issource.region_cd%TYPE := NULL;
   BEGIN
      FOR i IN (SELECT region_cd
                  FROM giis_issource
                 WHERE iss_cd = p_iss_cd)
      LOOP
         v_region_cd := i.region_cd;
         EXIT;
      END LOOP;

      RETURN v_region_cd;
   END get_region_cd;

   FUNCTION get_issue_source_ri_list
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
      v_ri    giis_issource.iss_cd%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_ri
        FROM giis_parameters
       WHERE param_name = 'ISS_CD_RI';

      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE iss_cd = v_ri)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;

      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END get_issue_source_ri_list;

   /*
   **  Created by     : Veronica V. Raymundo
   **  Date Created  : September 7, 2011
   **  Reference By : (GIPIS002A- Package Par Basic Information
   **  Description : Function returns list of issue_source with the given cred_br_tag
   */

   FUNCTION get_iss_source_by_cred_br_tag (
      p_cred_br_tag GIIS_ISSOURCE.cred_br_tag%TYPE)
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
      FOR i IN (  SELECT iss_cd, iss_name
                    FROM GIIS_ISSOURCE
                   WHERE cred_br_tag = p_cred_br_tag
                     AND active_tag = 'Y'  -- added by Kris 07.03.2013 for UW-SPECS-2013-091
                ORDER BY iss_cd)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;

      RETURN;
   END get_iss_source_by_cred_br_tag;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : September 09, 2011
   **  Reference By  : (GIEXS001- Extract Expiring Policies)
   */
   FUNCTION get_iss_cd_name (p_user_id      GIIS_USERS.user_id%TYPE,
                             p_line_cd      GIIS_LINE.line_cd%TYPE,
                             p_module_id    GIIS_MODULES.module_id%TYPE)
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
      --edited by gab 12.07.2015 start
      IF p_module_id = 'GIUTS007' OR p_module_id = 'GIUTS008'
      THEN
          FOR i IN (SELECT iss_cd, iss_name
                      FROM giis_issource
                     WHERE check_user_per_iss_cd2(p_line_cd, iss_cd, p_module_id, p_user_id) = 1 
                     AND check_user_per_iss_cd2(p_line_cd, iss_cd, 'GIPIS001', p_user_id) = 1)
          LOOP
             v_iss.iss_cd := i.iss_cd;
             v_iss.iss_name := i.iss_name;
             PIPE ROW (v_iss);
          END LOOP;
      ELSE
          FOR i IN (SELECT iss_cd, iss_name
                      FROM giis_issource
                     WHERE check_user_per_iss_cd2(p_line_cd, iss_cd, p_module_id, p_user_id) = 1)
          LOOP
             v_iss.iss_cd := i.iss_cd;
             v_iss.iss_name := i.iss_name;
             PIPE ROW (v_iss);
          END LOOP;
      END IF;
--       FOR i IN (SELECT iss_cd, iss_name
--                      FROM giis_issource
--                     WHERE check_user_per_iss_cd2(p_line_cd, iss_cd, p_module_id, p_user_id) = 1 
--                     AND check_user_per_iss_cd2(p_line_cd, iss_cd, 'GIPIS001', p_user_id) = 1)  -- added by gab 09.11.2015
--                  WHERE iss_cd = DECODE (check_user_per_iss_cd1 (p_line_cd,
--                                                                   iss_cd,
--                                                                   p_user_id,
--                                                                   p_module_id),
--                                            1, iss_cd,
--                                       NULL))
--          LOOP
--             v_iss.iss_cd := i.iss_cd;
--             v_iss.iss_name := i.iss_name;
--             PIPE ROW (v_iss);
--          END LOOP;
    --end

      RETURN;
   END get_iss_cd_name;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : September 12, 2011
   **  Reference By  : (GIEXS001- Extract Expiring Policies)
   */
   PROCEDURE validate_pol_iss_cd (
      p_pol_line_cd   IN     giis_line.line_cd%TYPE,
      p_pol_iss_cd    IN     giis_user_grp_line.iss_cd%TYPE,
      p_iss_ri        IN     giis_parameters.param_value_v%TYPE,
      p_user_id       IN     giis_users.user_id%TYPE,
      p_module_id     IN     giis_user_grp_modules.module_id%TYPE,
      p_msg              OUT VARCHAR2)
   IS
      v_exist    VARCHAR2 (1) := 'N';
      v_iss_cd   giis_issource.iss_cd%TYPE;
   BEGIN
      IF p_pol_iss_cd = p_iss_ri
      THEN
         p_msg := '1';
         RETURN;
      END IF;

      FOR iss IN (SELECT iss_cd
                    FROM giis_issource
                   WHERE iss_cd = p_pol_iss_cd)
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      IF v_exist = 'N'
      THEN
         p_msg := '2';
         RETURN;
      END IF;

      BEGIN
         SELECT iss_cd
           INTO v_iss_cd
           FROM giis_issource
          WHERE     iss_cd = p_pol_iss_cd
                AND check_user_per_iss_cd1 (p_pol_line_cd,
                                            p_pol_iss_cd,
                                            p_user_id,
                                            p_module_id) = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg := '3';
         WHEN TOO_MANY_ROWS
         THEN
            p_msg := '4';
      END;
   END validate_pol_iss_cd;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : December 14, 2011
   **  Reference By  : (GICLS026- No Claim)
   **  Description   : ISS_CD_LOV
   */
   FUNCTION get_polbasic_iss_list (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_user_id       giis_users.user_id%TYPE)
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
      FOR i
         IN (SELECT a.iss_cd, a.iss_name
               FROM giis_issource a
              WHERE EXISTS
                       (SELECT 'X'
                          FROM gipi_polbasic b
                         WHERE     b.iss_cd = a.iss_cd
                               AND b.subline_cd = p_subline_cd
                               AND b.line_cd = p_line_cd)
                AND CHECK_USER_PER_ISS_CD2(p_line_cd,a.iss_cd,'GICLS026', p_user_id) = 1) --added by christian 01232013
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;

      RETURN;
   END get_polbasic_iss_list;

   PROCEDURE validate_purge_iss_cd (
      p_iss_cd      IN     GIIS_ISSOURCE.iss_cd%TYPE,
      p_iss_name       OUT GIIS_ISSOURCE.iss_name%TYPE,
      p_line_cd     IN     GIIS_LINE.line_cd%TYPE,
      p_module_id   IN     GIIS_MODULES.module_id%TYPE,
      p_iss_ri         OUT VARCHAR2)
   IS
      v_iss_ri     VARCHAR2 (20);
      v_iss_name   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_iss_ri
           FROM giis_parameters
          WHERE param_name = 'ISS_CD_RI';

         IF v_iss_ri = p_iss_cd
         THEN
            v_iss_ri := 'N';
         ELSE
            v_iss_ri := 'Y';
         END IF;
      END;

      SELECT iss_name
        INTO v_iss_name
        FROM GIIS_ISSOURCE
       WHERE     iss_cd = p_iss_cd
             AND iss_cd =
                    DECODE (
                       check_user_per_iss_cd (p_line_cd, iss_cd, p_module_id),
                       1, iss_cd,
                       NULL);

      IF v_iss_name IS NULL
      THEN
         p_iss_name := NULL;
      ELSE
         p_iss_name := v_iss_name;
      END IF;

      p_iss_ri := v_iss_ri;
   END;

   --bonok :: 04.10.2012 :: issue source LOV for GIEXS006
   FUNCTION get_exp_rep_issource_lov (
      p_line_cd      GIIS_LINE.line_cd%TYPE,
      p_module_id    GIIS_USER_GRP_MODULES.module_id%TYPE,
	  p_user_id      GIIS_USERS.USER_ID%TYPE)--PHILFIRE-SR-15082 incomplete listing for user JC
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_issource   issue_source_list_type;
   BEGIN
      FOR i
         IN (SELECT iss_cd, iss_name
               FROM giis_issource
              WHERE check_user_per_iss_cd2 (p_line_cd, iss_cd, p_module_id, p_user_id) = 1
              ORDER BY iss_name)
      LOOP
         v_issource.iss_cd := i.iss_cd;
         v_issource.iss_name := i.iss_name;
         PIPE ROW (v_issource);
      END LOOP;
   END get_exp_rep_issource_lov;

   --bonok :: 04.17.2012 :: validate issue source for GIEXS006
   FUNCTION validate_iss_cd_giexs006 (
      p_iss_cd       giis_issource.iss_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_module_id    giis_user_grp_modules.module_id%TYPE)
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
      FOR i
         IN (SELECT iss_cd, iss_name
               FROM giis_issource
              WHERE     iss_cd = p_iss_cd
                    AND check_user_per_iss_cd (p_line_cd,
                                               iss_cd,
                                               p_module_id) = 1)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;
   END validate_iss_cd_giexs006;

/*
   **  Created by    : Robert John Virrey
   **  Date Created  : 5.29.2012
   **  Reference By  : (GIRIS005A- PACK INITIAL ACCECPTANCE)
   **  Description   : CGFK$GIRI_WINPOLBAS_ISSOURCE
   */
   FUNCTION get_giri_winpolbas_issource (p_find_text VARCHAR2)
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE UPPER (iss_name) LIKE NVL (UPPER (p_find_text), '%%')
                 ORDER BY iss_cd, iss_name)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;
   END;
   
   /*
   **  Created by    : Emsy Bola?os
   **  Date Created  : 09.04.2012
   **  Reference By  : (GIIMM001 - CREATE QUOTATION)
   **  Description   : CGFK$B240_ISS_CD
   */
   FUNCTION get_create_quotation_iss_cd(
     p_line_cd      giis_line.line_cd%TYPE,
     p_module_id    giis_user_grp_modules.module_id%TYPE,
     p_user_id      giis_users.user_id%TYPE)
       RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
    FOR i IN(SELECT iss_cd iss_cd,iss_name iss_name 
        FROM giis_issource 
     --WHERE iss_cd = any(SELECT iss_cd //removed by robert 10.13.14
     --                    FROM giis_user_grp_dtl 
     --                   WHERE user_grp = (SELECT DISTINCT user_grp 
     --                                       FROM giis_users 
     --                                      WHERE user_id = p_user_id) 
     --                                        AND iss_cd != 'RI') 
	  WHERE iss_cd != 'RI' --added by robert 10.13.14
                          AND iss_cd = DECODE(check_user_per_iss_cd2(p_line_cd,iss_cd,p_module_id,p_user_id),1,iss_cd,NULL)
    AND nvl(claim_tag,'N') != 'Y'
    order by iss_cd)
    LOOP
         v_iss.iss_cd     := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;
    END;
    
    FUNCTION validate_iss_cd (p_user_id      VARCHAR2,--GIIS_USERS.user_id%TYPE,
                              p_line_cd      VARCHAR2,--GIIS_LINE.line_cd%TYPE,
                              p_module_id    VARCHAR2,--GIIS_MODULES.module_id%TYPE,
                              p_iss_cd         VARCHAR2)
      RETURN VARCHAR2
    IS
       v_iss_cd  VARCHAR2(1) := 'N';
    BEGIN
       FOR x IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE iss_cd = DECODE (check_user_per_iss_cd1 (p_line_cd,
                                                                iss_cd,
                                                                p_user_id,
                                                                p_module_id),
                                        1, iss_cd,
                                        NULL)
                  AND iss_cd = p_iss_cd)
      LOOP
         v_iss_cd := 'Y';
      END LOOP;

      RETURN v_iss_cd;
   END validate_iss_cd;
   
   /*
   **  Created by     : Christian Santos
   **  Date Created  : March 3, 2013
   **  Reference By : (GIPIS017, GIPIS165)
   **  Description : Function returns list of issue_source with the given cred_br_tag excluding RI
   */
   FUNCTION get_iss_cd_by_cred_tag_exc_ri (
      p_cred_br_tag GIIS_ISSOURCE.cred_br_tag%TYPE)
      RETURN issue_source_list_tab
      PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
      FOR i IN (  SELECT iss_cd, iss_name
                    FROM GIIS_ISSOURCE
                   WHERE cred_br_tag = p_cred_br_tag
                     AND iss_cd <> 'RI'
                     AND active_tag = 'Y'  -- added by Kris 07.03.2013 for UW-SPECS-2013-091 
                   ORDER BY iss_cd)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;

      RETURN;
   END get_iss_cd_by_cred_tag_exc_ri;
   
   
   --shan 03.14.2013 - issue source LOV for GICLS201
    FUNCTION get_iss_gicls201_LOV(p_module_id     GIIS_USER_GRP_MODULES.MODULE_ID%TYPE)
        RETURN issue_source_list_tab PIPELINED
    IS
        v_tab   issue_source_list_type;
    BEGIN
        FOR i IN (select iss_cd, iss_name 
                    from giis_issource 
                    where iss_cd in decode(check_user_per_iss_cd(null,iss_cd,p_module_id),1,iss_cd,0,'')  
                    order by iss_cd, iss_name)
        LOOP
            v_tab.iss_cd    := i.iss_cd;
            v_tab.iss_name  := i.iss_name;
            
            PIPE ROW(v_tab);
        END LOOP;
    END get_iss_gicls201_LOV;
   
   -- shan 03.15.2013
    PROCEDURE get_issue_name_gicls201(
        p_module_id     IN  GIIS_MODULES.MODULE_ID%TYPE,
        p_iss_cd        IN  GIIS_ISSOURCE.ISS_CD%TYPE,
        p_user          IN  GIIS_USERS.USER_ID%type,
        p_iss_name      OUT GIIS_ISSOURCE.ISS_NAME%TYPE,
        p_found         OUT VARCHAR2
    )
    IS
        v_iss_name     GIIS_ISSOURCE.ISS_NAME%TYPE;
    BEGIN
        SELECT iss_name
          INTO v_iss_name
          FROM giis_issource
         WHERE iss_cd = p_iss_cd
           AND iss_cd in (decode(check_user_per_iss_cd2(NULL,iss_cd,p_module_id, p_user),1,iss_cd,0,''));
          
         p_iss_name := v_iss_name;
         
         IF v_iss_name IS NULL THEN
            p_found := 'N';
         ELSE
            p_found := 'Y';
         END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_found := 'N';
            
    END get_issue_name_gicls201;
        
    /*
    **  Created by    : Marie Kris Felipe
    **  Date Created  : 05.03.2013
    **  Reference By  : GIACS180 - Statement of Account
    **  Description   : Branch_LOV 
    */
    FUNCTION get_giacs180_iss_lov (
        p_user_id       giis_users.user_id%TYPE,
        p_module_id     giis_modules.module_id%TYPE
    ) RETURN issue_source_list_tab PIPELINED
    IS
        v_iss_list      issue_source_list_type;
    BEGIN
        FOR i IN (SELECT iss_cd, INITCAP (iss_name) iss_name
                    FROM giis_issource
                   WHERE iss_cd != 'RI'
                     AND check_user_per_iss_cd_acctg2 (NULL, iss_cd, p_module_id, p_user_id) = 1)
        LOOP
            v_iss_list.iss_cd := i.iss_cd;
            v_iss_list.iss_name := i.iss_name;
            
            PIPE ROW(v_iss_list);
        END LOOP;
    END get_giacs180_iss_lov;
    
    /** Created By:     kenneth Labrador
     ** Date Created:   04.24.2013
     ** Referenced By:  GIUTS022 - Change in Payment Term
     **Description:     Iss LOV
     **/
    FUNCTION get_iss_lov_giuts022 (
        p_search    VARCHAR2,
        p_user_id   giis_users.user_id%TYPE
    )
       RETURN issue_source_list_tab PIPELINED
    IS
       v_giis_issource   issue_source_list_type;
    BEGIN
       FOR i IN (SELECT iss_cd, iss_name
                   FROM giis_issource
                  WHERE UPPER (iss_cd) LIKE UPPER (NVL (p_search, '%'))
                    AND check_user_per_iss_cd_acctg2 (NULL, iss_cd, 'GIUTS022', p_user_id) = 1)
                        
       LOOP
          v_giis_issource.iss_cd := i.iss_cd;
          v_giis_issource.iss_name := i.iss_name;
          PIPE ROW (v_giis_issource);
       END LOOP;

       RETURN;
    END get_iss_lov_giuts022;
    
    /** Created By:     kenneth Labrador
     ** Date Created:   04.24.2013
     ** Referenced By:  GIUTS022 - Change in Payment Term
     **Description:     Endt Iss LOV
     **/
    FUNCTION get_endt_iss_lov_giuts022 (
        p_search    VARCHAR2,
        p_user_id   giis_users.user_id%TYPE
    )
       RETURN issue_source_list_tab PIPELINED
    IS
       v_giis_issource   issue_source_list_type;
    BEGIN
       FOR i IN (SELECT iss_cd, iss_name
                   FROM giis_issource
                  WHERE UPPER (iss_cd) LIKE UPPER (NVL (p_search, '%'))
                        )
       LOOP
          v_giis_issource.iss_cd := i.iss_cd;
          v_giis_issource.iss_name := i.iss_name;
          PIPE ROW (v_giis_issource);
       END LOOP;

       RETURN;
    END get_endt_iss_lov_giuts022;

    --added by : Kenneth L. 07.16.2013 :for giacs286
    FUNCTION get_giacs286_iss_lov (p_user_id giis_users.user_id%TYPE)
       RETURN issue_source_list_tab PIPELINED
    IS
       v_branch   issue_source_list_type;
    BEGIN
       FOR i IN
          (SELECT   iss_cd, iss_name
               FROM giis_issource
              WHERE iss_cd IN (
                       SELECT iss_cd
                         FROM giis_issource
                        WHERE iss_cd =
                                 DECODE
                                      (check_user_per_iss_cd_acctg2 (NULL,
                                                                     iss_cd,
                                                                     'GIACS286',
                                                                     p_user_id
                                                                    ),
                                       1, iss_cd,
                                       NULL
                                      ))
           ORDER BY iss_cd)
       LOOP
          v_branch.iss_cd := i.iss_cd;
          v_branch.iss_name := i.iss_name;
          PIPE ROW (v_branch);
       END LOOP;
    END get_giacs286_iss_lov;
    
    FUNCTION get_basic_issource_lov(
       p_user_id        VARCHAR2,
       p_module_id      VARCHAR2
    )
       RETURN issue_source_list_tab PIPELINED
    IS
       v_list issue_source_list_type;
    BEGIN
       FOR i IN(SELECT DISTINCT iss_cd, iss_name
                  FROM giis_issource
                 WHERE check_user_per_iss_cd_acctg2 (NULL, iss_cd, p_module_id, p_user_id) = 1
              ORDER BY 1)
       LOOP
          v_list.iss_cd := i.iss_cd;
          v_list.iss_name := i.iss_name;
          
          PIPE ROW(v_list);
       END LOOP; 
    END get_basic_issource_lov;   

   FUNCTION get_all_issource_lov(
      p_iss_cd          giis_issource.iss_cd%TYPE
   ) RETURN issue_source_list_tab PIPELINED AS
      v_iss                  issue_source_list_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name 
                  FROM giis_issource
                 WHERE iss_cd = NVL(p_iss_cd, iss_cd)
                 ORDER BY iss_name)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;
   END;
   
   FUNCTION get_gicls254_iss_lov(
      p_line_cd      VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN issue_source_list_tab PIPELINED
   IS
      v_list issue_source_list_type;
   BEGIN
      FOR i IN(SELECT iss_cd, iss_name 
                 FROM giis_issource 
                WHERE iss_cd = DECODE(check_user_per_iss_cd2(p_line_cd, iss_cd, 'GICLS254', p_user_id),1,iss_cd,NULL)
                  AND iss_cd = NVL(p_iss_cd, iss_cd))
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
      
         PIPE ROW(v_list);
      END LOOP;
   END get_gicls254_iss_lov;   

   FUNCTION get_giacs299_branch_lov(
      p_module_id          giis_modules.module_id%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_keyword            VARCHAR2
   ) RETURN issue_source_list_tab PIPELINED AS
      v_iss                  issue_source_list_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name 
                  FROM giis_issource
                 WHERE check_user_per_iss_cd_acctg2(NULL, iss_cd, p_module_id, p_user_id) = 1
                   AND (UPPER(iss_cd) LIKE UPPER(NVL(p_keyword, '%'))
                        OR UPPER(iss_name) LIKE UPPER(NVL(p_keyword, '%')))
                 ORDER BY iss_name)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;
   END;
   
   /*
   **  Created by   : benjo brito
   **  Date Created : 11.12.2015
   **  Remarks      : UW-SPECS-2015-087 - GIEXS001 - Crediting Branch LOV
   */
   FUNCTION get_giexs001_cred_branch_lov (
      p_user_id     giis_users.user_id%TYPE,
      p_line_cd     giis_line.line_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE
   )
      RETURN issue_source_list_tab PIPELINED
   IS
      v_list   issue_source_list_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE cred_br_tag = 'Y'
                   AND (iss_cd, NVL(p_line_cd, '%')) IN (
                          SELECT branch_cd, DECODE(p_line_cd, NULL, '%', line_cd)
                            FROM TABLE (security_access.get_branch_line ('UW', p_module_id, p_user_id))))
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         PIPE ROW (v_list);
      END LOOP;
   END get_giexs001_cred_branch_lov;
END GIIS_ISSOURCE_PKG;
/
