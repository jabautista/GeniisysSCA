CREATE OR REPLACE PACKAGE BODY cpi.giac_branches_pkg
AS
   FUNCTION get_branch_details
      RETURN branch_details_tab PIPELINED
   IS
      v_branch   branch_details_type;
   BEGIN
      FOR i IN (SELECT gibr.gfun_fund_cd gibr_gfun_fund_cd,
                       gibr.branch_cd gibr_branch_cd,
                       gibr.branch_name gibr_branch_name,
                       gfun1.fund_desc gibr_fund_desc,
                       gibr.acct_branch_cd gibr_acct_branch_cd,
                       gibr.user_id gibr_user_id,
                       gibr.last_update gibr_last_update,
                       gibr.remarks gibr_remarks,
                       gibr.cpi_rec_no gibr_cpi_rec_no,
                       gibr.cpi_branch_cd gibr_cpi_branch_cd,
                       gibr.prnt_branch_cd gibr_prnt_branch_cd,
                       gibr.bank_cd gibr_bank_cd,
                       gibr.bank_acct_cd gibr_bank_acct_cd,
                       gibr.comp_cd gibr_comp_cd
                  FROM giac_branches gibr, giis_funds gfun1
                 WHERE gibr.branch_cd = 'HO'
                   AND gfun1.fund_cd = gibr.gfun_fund_cd)
      LOOP
         v_branch.gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_branch.branch_cd := i.gibr_branch_cd;
         v_branch.branch_name := i.gibr_branch_name;
         v_branch.fund_desc := i.gibr_fund_desc;
         v_branch.acct_branch_cd := i.gibr_acct_branch_cd;
         v_branch.user_id := i.gibr_user_id;
         v_branch.last_update := i.gibr_last_update;
         v_branch.remarks := i.gibr_remarks;
         v_branch.cpi_rec_no := NVL (i.gibr_cpi_rec_no, 0);
         v_branch.cpi_branch_cd := i.gibr_cpi_branch_cd;
         v_branch.prnt_branch_cd := i.gibr_prnt_branch_cd;
         v_branch.bank_cd := i.gibr_bank_cd;
         v_branch.bank_acct_cd := i.gibr_bank_acct_cd;
         v_branch.comp_cd := i.gibr_comp_cd;
         PIPE ROW (v_branch);
      END LOOP;

      RETURN;
   END get_branch_details;

   /*
   ** Created By:       D.Alcantara
   ** Date Created:     01/24/2011
   ** Reference By:     GIACS156, Other Branch OR
   ** Description:
   */
   FUNCTION get_other_branch_or (
      p_module_id   VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN branch_details_tab PIPELINED
   IS
      v_branch         branch_details_type;
      v_branch_cd_ho   giac_branches.branch_cd%TYPE;
      v_user_group     giis_users.user_grp%TYPE;
   BEGIN
      v_branch_cd_ho := get_branch_cd_ho (p_user_id);
      v_user_group := NULL;

      FOR h IN (SELECT user_grp
                  FROM giis_users
                 WHERE user_id = NVL (p_user_id, USER))
      LOOP
         v_user_group := h.user_grp;
      END LOOP;

      FOR i IN
         (SELECT *
            FROM giac_branches
           WHERE (gfun_fund_cd <> (SELECT giacp.v ('MAIN_FUND_CD')
                                    FROM DUAL)
              OR     branch_cd <> v_branch_cd_ho)	--Gzelle  08112014 as per Maam Grace for multiple Fund Cd
                 AND branch_cd IN (
                        SELECT iss_cd
                          FROM giis_issource
                         WHERE iss_cd =
                                  DECODE
                                     (check_user_per_iss_cd_acctg2
                                                              (NULL,
                                                               iss_cd,
                                                               p_module_id,
                                                               NVL (p_user_id,
                                                                    USER
                                                                   )
                                                              ),
                                      1, iss_cd,
                                      NULL
                                     ))
                                       /*    AND branch_cd IN (SELECT a.iss_cd
                                                                FROM GIIS_USER_GRP_DTL a,
                                                                     GIIS_ISSOURCE b
                                                               WHERE a.iss_cd    = b.iss_cd
                                                                 AND a.user_grp  = v_user_group)   */  --commented by d.alcantara, 12-27-2011
         )
      LOOP
         v_branch.gfun_fund_cd := i.gfun_fund_cd;
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         v_branch.acct_branch_cd := i.acct_branch_cd;
         v_branch.user_id := i.user_id;
         v_branch.last_update := i.last_update;
         v_branch.remarks := i.remarks;
         v_branch.cpi_rec_no := i.cpi_rec_no;
         v_branch.cpi_branch_cd := i.cpi_branch_cd;
         v_branch.prnt_branch_cd := i.prnt_branch_cd;
         v_branch.bank_cd := i.bank_cd;
         v_branch.bank_acct_cd := i.bank_acct_cd;
         v_branch.comp_cd := i.comp_cd;
         PIPE ROW (v_branch);
      END LOOP;

     /* v_branch_cd_ho := get_branch_cd_ho (p_user_id);
      v_user_group := NULL;

      FOR h IN (SELECT user_grp
                  FROM giis_users
                 WHERE user_id = NVL (p_user_id, USER))
      LOOP
         v_user_group := h.user_grp;
      END LOOP;

      FOR i IN
         (SELECT *
            FROM giac_branches
           WHERE (gfun_fund_cd <> (SELECT giacp.v ('MAIN_FUND_CD')
                                    FROM DUAL)
               OR branch_cd <> v_branch_cd_ho)*/	--Gzelle  08112014 as per Maam Grace for multiple Fund Cd
               /*commented by pol cruz
                 10.16.2013
                 for modification of GIACS156*/
             /*AND branch_cd IN (
                    SELECT iss_cd
                      FROM giis_issource
                     WHERE iss_cd =
                              DECODE
                                 (check_user_per_iss_cd_acctg2
                                                              (NULL,
                                                               iss_cd,
                                                               p_module_id,
                                                               NVL (p_user_id,
                                                                    USER
                                                                   )
                                                              ),
                                  1, iss_cd,
                                  NULL
                                 ))*/
                                   /*    AND branch_cd IN (SELECT a.iss_cd
                                                            FROM GIIS_USER_GRP_DTL a,
                                                                 GIIS_ISSOURCE b
                                                           WHERE a.iss_cd    = b.iss_cd
                                                             AND a.user_grp  = v_user_group)   */  --commented by d.alcantara, 12-27-2011
         /*)
      LOOP
         v_branch.gfun_fund_cd := i.gfun_fund_cd;
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         v_branch.acct_branch_cd := i.acct_branch_cd;
         v_branch.user_id := i.user_id;
         v_branch.last_update := i.last_update;
         v_branch.remarks := i.remarks;
         v_branch.cpi_rec_no := i.cpi_rec_no;
         v_branch.cpi_branch_cd := i.cpi_branch_cd;
         v_branch.prnt_branch_cd := i.prnt_branch_cd;
         v_branch.bank_cd := i.bank_cd;
         v_branch.bank_acct_cd := i.bank_acct_cd;
         v_branch.comp_cd := i.comp_cd;
         PIPE ROW (v_branch);
      END LOOP;*/
   END get_other_branch_or;

   PROCEDURE get_dflt_bank_acct (
      p_branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_user_id              giis_users.user_id%TYPE,
      p_bank_cd        OUT   giac_dcb_users.bank_cd%TYPE,
      p_bank_acct_cd   OUT   giac_dcb_users.bank_acct_cd%TYPE,
      p_bank_name      OUT   giac_banks.bank_name%TYPE,
      p_bank_acct_no   OUT   giac_bank_accounts.bank_acct_no%TYPE,
      p_message        OUT   VARCHAR2
   )
   IS
   BEGIN
      FOR a IN (SELECT bank_cd, bank_acct_cd
                  FROM giac_dcb_users
                 WHERE gibr_fund_cd = p_fund_cd
                   AND gibr_branch_cd = p_branch_cd
                   AND dcb_user_id = NVL (p_user_id, USER))
      LOOP
         p_bank_cd := a.bank_cd;
         p_bank_acct_cd := a.bank_acct_cd;

         IF a.bank_cd IS NULL
         THEN
            FOR b IN (SELECT bank_cd, bank_acct_cd
                        FROM giac_branches
                       WHERE gfun_fund_cd = p_fund_cd
                         AND branch_cd = p_branch_cd)
            LOOP
               p_bank_cd := b.bank_cd;
               p_bank_acct_cd := b.bank_acct_cd;
            END LOOP;
         END IF;
      END LOOP;

      IF p_bank_cd IS NOT NULL
      THEN
         FOR rec1 IN (SELECT bank_name
                        FROM giac_banks
                       WHERE bank_cd = p_bank_cd)
         LOOP
            p_bank_name := rec1.bank_name;
         END LOOP;

         FOR rec2 IN (SELECT bank_acct_no
                        FROM giac_bank_accounts
                       WHERE bank_cd = p_bank_cd
                         AND bank_acct_cd = p_bank_acct_cd)
         LOOP
            p_bank_acct_no := rec2.bank_acct_no;
         END LOOP;
      END IF;

      IF (p_bank_name IS NULL OR p_bank_acct_no IS NULL)
      THEN
         p_message :=
            'Invalid value for bank account. Please check default value in giac_branches/giac_dcb_users.';
      END IF;
   END get_dflt_bank_acct;

   /*
   **  Created by   :  Emman
   **  Date Created :  03.30.2011
   **  Reference By : (GIACS035 - Close DCB)
   **  Description  : Gets the records of BRANCH_CD LOV
   */
   FUNCTION get_branch_cd_lov (
      p_gfun_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_control_module   VARCHAR2,
      p_keyword          VARCHAR2,
      p_user             VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_branch   branch_cd_lov_type;
   BEGIN
      FOR i IN
         (SELECT   branch_cd, branch_name
              FROM giac_branches
             WHERE gfun_fund_cd = p_gfun_fund_cd
               AND branch_cd =
                      DECODE (check_user_per_iss_cd_acctg (NULL,
                                                           branch_cd,
                                                           p_control_module
                                                          ),
                              1, branch_cd,
                              NULL
                             )
               AND EXISTS (
                      SELECT '1'
                        FROM giac_dcb_users
                       WHERE gibr_branch_cd = branch_cd
                         AND gibr_fund_cd = p_gfun_fund_cd
                         AND dcb_user_id = p_user
                         AND valid_tag = 'Y'
                         AND effectivity_dt <= SYSDATE
                         AND (expiry_dt > SYSDATE OR expiry_dt IS NULL))
               AND (   UPPER (branch_cd) LIKE
                               '%' || UPPER (NVL (p_keyword, branch_cd))
                               || '%'
                    OR UPPER (branch_name) LIKE
                             '%' || UPPER (NVL (p_keyword, branch_name))
                             || '%'
                   )
          ORDER BY 2)
      LOOP
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         PIPE ROW (v_branch);
      END LOOP;
   END get_branch_cd_lov;

   /*
   **  Created by   :  D.Alcantara
   **  Date Created :  04.07.2011
   **  Reference By : (GIACS333 - DCB No. Maintenance)
   */
   FUNCTION get_giac_branches (p_user giis_users.user_id%TYPE)
      RETURN branch_details_tab PIPELINED
   IS
      v_branch   branch_details_type;
   BEGIN
      FOR i IN (SELECT   gb.gfun_fund_cd, gb.branch_cd, gb.branch_name,
                         gb.acct_branch_cd, gb.user_id, gb.remarks,
                         gf.fund_desc
                    FROM giac_branches gb, giis_funds gf
                   WHERE /*gb.user_id = nvl(p_user, USER)
                         AND*/ gb.gfun_fund_cd = gf.fund_cd
                     AND ((SELECT access_tag
                              FROM giis_user_modules
                             WHERE userid = NVL (p_user, USER)   
                               AND module_id = 'GIACS333'
                               AND tran_cd IN (
                                      SELECT b.tran_cd         
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = NVL (p_user, USER)
                                         AND b.iss_cd = gb.branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS333')) = 1
                     OR (SELECT access_tag
                              FROM giis_user_grp_modules
                             WHERE module_id = 'GIACS333'
                               AND (user_grp, tran_cd) IN (
                                      SELECT a.user_grp, b.tran_cd
                                        FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                       WHERE a.user_grp = b.user_grp
                                         AND a.user_id = NVL (p_user, USER)
                                         AND b.iss_cd = gb.branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS333')) = 1
                   )
                ORDER BY gb.acct_branch_cd)
      LOOP
         v_branch.gfun_fund_cd := i.gfun_fund_cd;
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         v_branch.acct_branch_cd := i.acct_branch_cd;
         v_branch.user_id := i.user_id;
         v_branch.remarks := i.remarks;
         v_branch.fund_desc := i.fund_desc;
         PIPE ROW (v_branch);
      END LOOP;
   END get_giac_branches;

   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  04.08.2011
   **  Reference By : (GIACS037 - Endter Spoiled OR)
   **  Description  : Gets the records of BRANCH_CD LOV
   */
   FUNCTION get_branch_lov (
      p_gfun_fund_cd   giac_branches.gfun_fund_cd%TYPE,
      p_module_id      giis_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_keyword        VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_branch   branch_cd_lov_type;
   BEGIN
      FOR i IN
         (SELECT   branch_cd, branch_name
              FROM giac_branches
             WHERE gfun_fund_cd = p_gfun_fund_cd
               AND branch_cd =
                      DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                            branch_cd,
                                                            p_module_id,
                                                            p_user_id
                                                           ),
                              1, branch_cd,
                              NULL
                             )
               AND (   UPPER (branch_cd) LIKE
                                            UPPER (NVL (p_keyword, branch_cd))
                    OR UPPER (branch_name) LIKE
                                          UPPER (NVL (p_keyword, branch_name))
                   )
          ORDER BY 2)
      LOOP
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         PIPE ROW (v_branch);
      END LOOP;
   END get_branch_lov;

   /*
   ** Created By:       D.Alcantara
   ** Date Created:     06/02/2011
   ** Reference By:     GIACS001
   ** Description:
   */
   FUNCTION get_branch_details2 (p_branch_cd giac_branches.branch_cd%TYPE)
      RETURN branch_details_tab PIPELINED
   IS
      v_branch   branch_details_type;
   BEGIN
      FOR i IN (SELECT gibr.gfun_fund_cd gibr_gfun_fund_cd,
                       gibr.branch_cd gibr_branch_cd,
                       gibr.branch_name gibr_branch_name,
                       gfun1.fund_desc gibr_fund_desc,
                       gibr.acct_branch_cd gibr_acct_branch_cd,
                       gibr.user_id gibr_user_id,
                       gibr.last_update gibr_last_update,
                       gibr.remarks gibr_remarks,
                       gibr.cpi_rec_no gibr_cpi_rec_no,
                       gibr.cpi_branch_cd gibr_cpi_branch_cd,
                       gibr.prnt_branch_cd gibr_prnt_branch_cd,
                       gibr.bank_cd gibr_bank_cd,
                       gibr.bank_acct_cd gibr_bank_acct_cd,
                       gibr.comp_cd gibr_comp_cd
                  FROM giac_branches gibr, giis_funds gfun1
                 WHERE UPPER (gibr.branch_cd) LIKE UPPER (p_branch_cd)
                   AND gfun1.fund_cd = gibr.gfun_fund_cd)
      LOOP
         v_branch.gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_branch.branch_cd := i.gibr_branch_cd;
         v_branch.branch_name := i.gibr_branch_name;
         v_branch.fund_desc := i.gibr_fund_desc;
         v_branch.acct_branch_cd := i.gibr_acct_branch_cd;
         v_branch.user_id := i.gibr_user_id;
         v_branch.last_update := i.gibr_last_update;
         v_branch.remarks := i.gibr_remarks;
         v_branch.cpi_rec_no := NVL (i.gibr_cpi_rec_no, 0);
         v_branch.cpi_branch_cd := i.gibr_cpi_branch_cd;
         v_branch.prnt_branch_cd := i.gibr_prnt_branch_cd;
         v_branch.bank_cd := i.gibr_bank_cd;
         v_branch.bank_acct_cd := i.gibr_bank_acct_cd;
         v_branch.comp_cd := i.gibr_comp_cd;
         PIPE ROW (v_branch);
      END LOOP;

      RETURN;
   END get_branch_details2;

   /*
   ** Created By:       Udel Dela Cruz Jr.
   ** Date Created:     04/25/2012
   ** Reference By:     GIACS055
   ** Description:
   ** Modified: Added parameter from_claim when module is called from claims - irwin 7.4.2012
   */
   FUNCTION get_other_branch_listing (
      p_module_id    VARCHAR2,
      p_user_id      giis_users.user_id%TYPE,
      p_from_claim   VARCHAR2
   )
      RETURN get_other_branch_listing_tab PIPELINED
   IS
      v_list           get_other_branch_listing_type;
      v_main_fund_cd   giis_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_main_fund_cd
           FROM giac_parameters
          WHERE param_name = 'MAIN_FUND_CD';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
                      (-20001,
                       'Parameter MAIN_FUND_CD not found in giac_parameters.'
                      );
      END;

      IF NVL (p_from_claim, 'N') = 'Y'
      THEN
         FOR rec IN
            (SELECT   gfun_fund_cd, branch_cd, branch_name
                 FROM giac_branches
                WHERE branch_cd IN (
                         SELECT iss_cd
                           FROM giis_issource
                          WHERE iss_cd =
                                   DECODE
                                      (check_user_per_iss_cd_acctg2
                                                              (NULL,
                                                               iss_cd,
                                                               'GIACS086', --replaced by kenneth to 05272015 SR 4206
                                                               NVL (p_user_id,
                                                                    USER
                                                                   )
                                                              ),
                                       1, iss_cd,
                                       NULL
                                      ))
             ORDER BY gfun_fund_cd, branch_cd)
         LOOP
            v_list.gfun_fund_cd := rec.gfun_fund_cd;
            v_list.branch_cd := rec.branch_cd;
            v_list.branch_name := rec.branch_name;
            PIPE ROW (v_list);
         END LOOP;
      ELSE
         FOR rec IN
            (SELECT   gfun_fund_cd, branch_cd, branch_name
                 FROM giac_branches
                WHERE (gfun_fund_cd <> v_main_fund_cd
                   OR  -->>  Kris 08.29.2013: replaced OR with AND		--Gzelle  08112014 as per Maam Grace for multiple Fund Cd
                      branch_cd <> get_branch_cd_ho (p_user_id))
                  AND branch_cd IN (
                         SELECT iss_cd
                           FROM giis_issource
                          WHERE iss_cd =
                                   DECODE
                                      (check_user_per_iss_cd_acctg2
                                                              (NULL,
                                                               iss_cd,
                                                               p_module_id,
                                                               NVL (p_user_id,
                                                                    USER
                                                                   )
                                                              ),
                                       1, iss_cd,
                                       NULL
                                      ))
             ORDER BY gfun_fund_cd, branch_cd)
         LOOP
            v_list.gfun_fund_cd := rec.gfun_fund_cd;
            v_list.branch_cd := rec.branch_cd;
            v_list.branch_name := rec.branch_name;
            PIPE ROW (v_list);
         END LOOP;
      END IF;
   END get_other_branch_listing;

   /*
   ** Created By:       niknok
   ** Date Created:     06/04/2012
   ** Reference By:     GIACS016
   ** Description:
   ** modified:
   ** added cHECK_USER_PER_ISS_CD_ACCTG2 - irwin
   */
   FUNCTION get_branch_cd_lov2 (
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_branch   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT branch_cd branch_cd, branch_name branch_name
                  FROM giac_branches
                 WHERE gfun_fund_cd = p_fund_cd
                   AND check_user_per_iss_cd_acctg2 (NULL,
                                                     branch_cd,
                                                     'GIACS016',
                                                     'CPI'
                                                    ) = 1)
      LOOP
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         PIPE ROW (v_branch);
      END LOOP;
   END;

     /*
   **  Created by   :  Justhel Bactung
   **  Date Created :  01.31.2013
   **  Reference By : (GIACS231 - Transaction Status)
   **  Description  : Gets the records of BRANCH_CD LOV
   */
   FUNCTION get_branch_lov_list (
      p_module_id      giis_modules.module_id%TYPE,
      p_branch         giac_branches.branch_name%TYPE,
      p_gfun_fund_cd   giac_acctrans.gfun_fund_cd%TYPE,
      p_user_id        giis_users.user_id%TYPE
   )
      RETURN get_branch_lov_tab PIPELINED
   IS
      v_list   get_branch_lov_type;
   BEGIN
      FOR i IN
         (SELECT gibr.branch_cd branch_cd, gibr.gfun_fund_cd fund_cd,
                 gibr.branch_name branch_name, gfun.fund_desc fund_desc
            FROM giac_branches gibr, giis_funds gfun
           WHERE gfun.fund_cd = gibr.gfun_fund_cd
             AND gfun.fund_cd LIKE NVL (p_gfun_fund_cd, '%')
             AND (   UPPER (gibr.branch_name) LIKE UPPER (NVL (p_branch, '%'))
                  OR UPPER (gibr.branch_cd) LIKE UPPER (NVL (p_branch, '%'))
                  OR UPPER (gibr.branch_cd || ' - ' || gibr.branch_name) LIKE
                                                   UPPER (NVL (p_branch, '%'))
                 )
             AND gibr.branch_cd IN (
                    SELECT iss_cd
                      FROM giis_issource
                     WHERE iss_cd =
                              DECODE
                                 (check_user_per_iss_cd_acctg2
                                                              (NULL,
                                                               iss_cd,
                                                               p_module_id,
                                                               NVL (p_user_id,
                                                                    USER
                                                                   )
                                                              ),
                                  1, iss_cd,
                                  NULL
                                 )))
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.branch_name := i.branch_name;
         v_list.fund_cd := i.fund_cd;
         v_list.fund_desc := i.fund_desc;
         PIPE ROW (v_list);
      END LOOP;
   END get_branch_lov_list;

   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 03.25.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : LOV for Branch Code
   */
   FUNCTION get_branch_cd_lov3 (
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   VARCHAR2
   )
      RETURN get_branch_lov_tab PIPELINED
   IS
      v_list   get_branch_lov_type;
   BEGIN
      FOR i IN
         (SELECT gibr.branch_cd gibr_branch_cd,
                 gibr.gfun_fund_cd dsp_gfun_fund_cd,
                 gfun.fund_desc dsp_fund_desc,
                 gfun.grac_rac_cd dsp_grac_rac_cd,
                 gibr.branch_name dsp_branch_name
            FROM giac_branches gibr, giis_funds gfun
           WHERE gfun.fund_cd = gibr.gfun_fund_cd
             AND gfun.fund_cd LIKE NVL (p_fund_cd, '%')
             AND gibr.branch_cd IN (
                    SELECT iss_cd
                      FROM giis_issource
                     WHERE iss_cd =
                              DECODE
                                 (check_user_per_iss_cd_acctg2
                                                              (NULL,
                                                               iss_cd,
                                                               p_module_id,
                                                               NVL (p_user_id,
                                                                    USER
                                                                   )
                                                              ),
                                  1, iss_cd,
                                  NULL
                                 )))
      LOOP
         v_list.branch_cd := i.gibr_branch_cd;
         v_list.branch_name := i.dsp_branch_name;
         v_list.fund_cd := i.dsp_gfun_fund_cd;
         v_list.fund_desc := i.dsp_fund_desc;
         PIPE ROW (v_list);
      END LOOP;
   END;

    /*
   ** Created By:       Marie Kris Felipe
   ** Date Created:     04.16.2013
   ** Reference By:     GIACS002
   ** Description:      Branch Code LOV used in GIACS002
   */
   FUNCTION get_branch_cd_lov4 (
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE
   )
      RETURN branch_details_tab PIPELINED
   IS
      v_branch   branch_details_type;
   BEGIN
      FOR i IN (SELECT branch_cd branch_cd, branch_name branch_name,
                       gfun_fund_cd gfun_fund_cd
                  FROM giac_branches
                 WHERE gfun_fund_cd = p_fund_cd AND branch_cd = p_branch_cd)
      LOOP
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         v_branch.gfun_fund_cd := i.gfun_fund_cd;
         PIPE ROW (v_branch);
      END LOOP;
   END get_branch_cd_lov4;

   /** Created By:     Shan Bati
    ** Date Created:   04.22.2013
    ** Referenced By:  GIACS230 - GL Account Transaction
    **Description:     branch LOV
    **/
   FUNCTION get_branch_lov2 (
      p_gfun_fund_cd   giac_branches.gfun_fund_cd%TYPE,
      p_module_id      giis_modules.module_id%TYPE,
      p_search         giac_branches.branch_name%TYPE,
      p_user           giis_users.user_id%TYPE
   )
      RETURN branch_details_tab PIPELINED
   AS
      rep   branch_details_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT branch_cd, branch_name, gfun_fund_cd
                     FROM giac_branches
                    WHERE gfun_fund_cd = p_gfun_fund_cd
                      AND (   UPPER (branch_cd) =
                                             UPPER (NVL (p_search, branch_cd))
                           OR UPPER (branch_name) =
                                           UPPER (NVL (p_search, branch_name))
                          )
                      AND branch_cd IN (
                             SELECT iss_cd
                               FROM giis_issource
                              WHERE iss_cd =
                                       DECODE
                                          (check_user_per_iss_cd_acctg2
                                                                 (NULL,
                                                                  iss_cd,
                                                                  p_module_id,
                                                                  p_user
                                                                 ),
                                           1, iss_cd,
                                           NULL
                                          )))
      LOOP
         rep.branch_cd := i.branch_cd;
         rep.branch_name := i.branch_name;
         rep.gfun_fund_cd := i.gfun_fund_cd;
         PIPE ROW (rep);
      END LOOP;
   END get_branch_lov2;

   FUNCTION fetch_branch_list (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED
   AS
      lov   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT branch_cd, branch_name
                           FROM giac_branches
                          WHERE 1 = 1
                            AND check_user_per_iss_cd2 (NULL,
                                                        NVL (NULL, branch_cd),
                                                        p_module_id,
                                                        p_user_id
                                                       ) = 1
                            AND check_user_per_line2 (NULL,
                                                      NVL (NULL, branch_cd),
                                                      p_module_id,
                                                      p_user_id
                                                     ) = 1
                       ORDER BY 1)
      LOOP
         lov.branch_cd := i.branch_cd;
         lov.branch_name := i.branch_name;
         PIPE ROW (lov);
      END LOOP;
   END fetch_branch_list;

   /** Created By:     Pol Cruz
    ** Date Created:   06.14.2013
    ** Referenced By:  GIACS072- Credit/Debit Memo Report
    **Description:     branch LOV
    **/
   FUNCTION get_branch_cd_lov5 (p_user_id VARCHAR2, p_module_id VARCHAR2)
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_list   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT branch_cd, branch_name
                  FROM giac_branches
                 WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                     branch_cd,
                                                     p_module_id,
                                                     p_user_id
                                                    ) = 1)
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.branch_name := i.branch_name;
         PIPE ROW (v_list);
      END LOOP;
   END get_branch_cd_lov5;

   FUNCTION validate_branch_cd (
      p_user_id     VARCHAR2,
      p_module_id   VARCHAR2,
      p_branch_cd   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_temp   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT branch_name
           INTO v_temp
           FROM giac_branches
          WHERE UPPER (branch_cd) LIKE UPPER (p_branch_cd)
            AND check_user_per_iss_cd_acctg2 (NULL,
                                              branch_cd,
                                              p_module_id,
                                              p_user_id
                                             ) = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_temp := 'ERROR';
      END;

      RETURN v_temp;
   END validate_branch_cd;

   --added by Shan 06.13.2013 for GIACS117 [Cash Receipt Register]
   FUNCTION get_branch_lov3 (
      --p_gibr_branch_cd    GIAC_ORDER_OF_PAYTS.GIBR_BRANCH_CD%type,
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED
   AS
      lov   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT   branch_name, gibr_branch_cd
                    FROM giac_order_of_payts a, giac_branches b
                   WHERE a.gibr_gfun_fund_cd = b.gfun_fund_cd
                     AND a.gibr_branch_cd = b.branch_cd
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       branch_cd,
                                                       p_module_id,
                                                       p_user
                                                      ) = 1
                GROUP BY gibr_branch_cd, branch_name
                ORDER BY gibr_branch_cd     -- shan 05.07.2014
                                                    /*UNION
                                                    SELECT   'ALL BRANCHES', NULL
                                                        FROM DUAL
                                                    ORDER BY 1*/
              )
      LOOP
         lov.branch_cd := i.gibr_branch_cd;
         lov.branch_name := i.branch_name;
         PIPE ROW (lov);
      END LOOP;
   END get_branch_lov3;

   FUNCTION validate_giacs117_branch_cd (
      p_gibr_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE,
      p_module_id        giis_modules.module_id%TYPE,
      p_user             giis_users.user_id%TYPE
   )
      RETURN VARCHAR2
   AS
      v_branch_name   giac_branches.branch_name%TYPE;
   BEGIN
      SELECT DISTINCT branch_name
                 INTO v_branch_name
                 FROM giac_order_of_payts a, giac_branches b
                WHERE a.gibr_gfun_fund_cd = b.gfun_fund_cd
                  AND a.gibr_branch_cd = b.branch_cd
                  AND check_user_per_iss_cd_acctg2 (NULL,
                                                    branch_cd,
                                                    p_module_id,
                                                    p_user
                                                   ) = 1
                  AND UPPER (gibr_branch_cd) = UPPER (p_gibr_branch_cd);

      RETURN (v_branch_name);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_branch_name := NULL;
         RETURN (v_branch_name);
   END validate_giacs117_branch_cd;
    
    -- Kris 06.27.2013 for GIACS118
    FUNCTION get_branch_cd_lov6 (
       p_user_id    VARCHAR2,
       p_module_id  VARCHAR2
    )
       RETURN branch_cd_lov_tab PIPELINED
    IS
       v_list branch_cd_lov_type;
    BEGIN
       FOR i IN(SELECT branch_name, branch_cd
                  FROM giac_branches
                 WHERE check_user_per_iss_cd_acctg2 (NULL, branch_cd, p_module_id, p_user_id) = 1
                 GROUP BY branch_cd, branch_name
--                 UNION SELECT 'ALL BRANCHES', NULL
--                  FROM dual
                 ORDER BY branch_cd)
       LOOP
          v_list.branch_cd := i.branch_cd;
          v_list.branch_name := i.branch_name;
          PIPE ROW(v_list);
       END LOOP;          
    END get_branch_cd_lov6;
    
    -- Kris 07.09.2013 for GIACS184
    FUNCTION get_branch_cd_lov7 (
       p_user_id    VARCHAR2,
       p_module_id  VARCHAR2
    )
       RETURN branch_cd_lov_tab PIPELINED
    IS
       v_list branch_cd_lov_type;
    BEGIN
       FOR i IN(SELECT branch_name, branch_cd
                  FROM giac_branches
                 WHERE branch_cd = DECODE(check_user_per_iss_cd_acctg2 (NULL, branch_cd, p_module_id, p_user_id),
                                          1, branch_cd,
                                          NULL)
                 /*UNION SELECT 'ALL BRANCHES', NULL
                  FROM dual*/ -- SR-2842 : shan 07.14.2015
                 ORDER BY 1)
       LOOP
          v_list.branch_cd := i.branch_cd;
          v_list.branch_name := i.branch_name;
          PIPE ROW(v_list);
       END LOOP;          
    END get_branch_cd_lov7;
    
    FUNCTION get_giacs178_branch_lov (
       p_user_id        VARCHAR2,
       p_module_id      VARCHAR2
    )
       RETURN branch_details_tab PIPELINED
    IS
       v_list branch_details_type;
    BEGIN
       FOR i IN (SELECT branch_name ,gibr_branch_cd
                   FROM giac_order_of_payts a, giac_branches b
                  WHERE a.gibr_gfun_fund_cd = b.gfun_fund_cd
                    AND a.gibr_branch_cd = b.branch_cd 
                    AND check_user_per_iss_cd_acctg2 (NULL, b.branch_cd , p_module_id, p_user_id) = 1
               GROUP BY gibr_branch_cd, branch_name
                  UNION 
                 SELECT 'ALL BRANCHES', NULL 
                   FROM DUAL
               ORDER BY 1)
       LOOP
          v_list.branch_cd := i.gibr_branch_cd;
          v_list.branch_name := i.branch_name;
          PIPE ROW(v_list);
       END LOOP;
    END get_giacs178_branch_lov;
    
    FUNCTION validate_giacs178_branch_cd (
       p_user_id        VARCHAR2,
       p_module_id      VARCHAR2,
       p_branch_cd      VARCHAR2
    ) 
       RETURN VARCHAR2
    IS
       v_check VARCHAR2 (50);
    BEGIN
    
       BEGIN
         SELECT DISTINCT branch_name
                    INTO v_check
                    FROM giac_order_of_payts a, giac_branches b
                   WHERE a.gibr_gfun_fund_cd = b.gfun_fund_cd
                     AND a.gibr_branch_cd = b.branch_cd
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       b.branch_cd,
                                                       p_module_id,
                                                       p_user_id
                                                      ) = 1
                     AND UPPER (gibr_branch_cd) = UPPER (p_branch_cd);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_check := 'ERROR';
      END;

      RETURN v_check;
   END validate_giacs178_branch_cd;

   --added by Shan 06.19.2013 for GIACS170
   FUNCTION get_branch_lov4 (
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED
   AS
      lov   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT branch_cd, branch_name
                  FROM giac_branches
                 WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                     branch_cd,
                                                     p_module_id,
                                                     p_user
                                                    ) = 1)
      LOOP
         lov.branch_cd := i.branch_cd;
         lov.branch_name := i.branch_name;
         PIPE ROW (lov);
      END LOOP;
   END get_branch_lov4;

   FUNCTION validate_giacs170_branch_cd (
      p_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN VARCHAR2
   AS
      v_branch_name   giac_branches.branch_name%TYPE;
   BEGIN
      SELECT branch_name
        INTO v_branch_name
        FROM giac_branches
       WHERE check_user_per_iss_cd_acctg2 (NULL,
                                           branch_cd,
                                           p_module_id,
                                           p_user
                                          ) = 1
         AND UPPER (branch_cd) = UPPER (p_branch_cd);

      RETURN (v_branch_name);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_branch_name := NULL;
         RETURN (v_branch_name);
   END validate_giacs170_branch_cd;

   --added by Shan 06.25.2013 for GIACS078
   FUNCTION get_branch_lov5 (
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED
   AS
      lov   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT   branch_name, gibr_branch_cd
                    FROM giac_order_of_payts a, giac_branches b
                   WHERE a.gibr_gfun_fund_cd = b.gfun_fund_cd
                     AND a.gibr_branch_cd = b.branch_cd
                     AND a.gacc_tran_id > 0
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       b.branch_cd,
                                                       p_module_id,
                                                       p_user
                                                      ) = 1
                GROUP BY branch_name, gibr_branch_cd
                ORDER BY 1)
      LOOP
         lov.branch_cd := i.gibr_branch_cd;
         lov.branch_name := i.branch_name;
         PIPE ROW (lov);
      END LOOP;
   END get_branch_lov5;

   FUNCTION validate_giacs078_branch_cd (
      p_gibr_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE,
      p_module_id        giis_modules.module_id%TYPE,
      p_user             giis_users.user_id%TYPE
   )
      RETURN VARCHAR2
   AS
      v_branch_name   giac_branches.branch_name%TYPE;
   BEGIN
      SELECT DISTINCT branch_name
                 INTO v_branch_name
                 FROM giac_order_of_payts a, giac_branches b
                WHERE a.gibr_gfun_fund_cd = b.gfun_fund_cd
                  AND a.gibr_branch_cd = b.branch_cd
                  AND a.gacc_tran_id > 0
                  AND check_user_per_iss_cd_acctg2 (NULL,
                                                    b.branch_cd,
                                                    p_module_id,
                                                    p_user
                                                   ) = 1
                  AND UPPER (gibr_branch_cd) = UPPER (p_gibr_branch_cd);

      RETURN (v_branch_name);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_branch_name := NULL;
         RETURN (v_branch_name);
   END validate_giacs078_branch_cd;

   --added by shan 06.28.2013
   FUNCTION get_giacs273_branch_lov (
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED
   AS
      lov   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT a.branch_cd, a.branch_name
                  FROM giac_branches a
                 WHERE gfun_fund_cd = p_fund_cd
                   AND check_user_per_iss_cd_acctg2 (NULL,
                                                     a.branch_cd,
                                                     p_module_id,
                                                     p_user
                                                    ) = 1
                   AND EXISTS (
                          SELECT 'X'
                            FROM giac_acctrans b
                           WHERE b.gfun_fund_cd = a.gfun_fund_cd
                             AND b.gibr_branch_cd = a.branch_cd))
      LOOP
         lov.branch_cd := i.branch_cd;
         lov.branch_name := i.branch_name;
         PIPE ROW (lov);
      END LOOP;
   END get_giacs273_branch_lov;

   FUNCTION validate_giacs273_branch_cd (
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN VARCHAR2
   AS
      v_branch_name   giac_branches.branch_name%TYPE;
   BEGIN
      SELECT a.branch_name
        INTO v_branch_name
        FROM giac_branches a
       WHERE gfun_fund_cd = p_fund_cd
         AND check_user_per_iss_cd_acctg2 (NULL,
                                           a.branch_cd,
                                           p_module_id,
                                           p_user
                                          ) = 1
         AND EXISTS (
                SELECT 'X'
                  FROM giac_acctrans b
                 WHERE b.gfun_fund_cd = a.gfun_fund_cd
                   AND b.gibr_branch_cd = a.branch_cd)
         AND a.branch_cd = p_branch_cd;

      RETURN (v_branch_name);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END validate_giacs273_branch_cd;

   FUNCTION get_branch_per_fund_lov (
      p_fund_cd     VARCHAR2,
      p_user_id     VARCHAR2,
      p_module_id   VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_list   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT   branch_cd, branch_name
                    FROM giac_branches
                   WHERE UPPER (gfun_fund_cd) =
                                        UPPER (NVL (p_fund_cd, gfun_fund_cd))
                     AND branch_cd =
                            DECODE
                                  (check_user_per_iss_cd_acctg2 (NULL,
                                                                 branch_cd,
                                                                 p_module_id,
                                                                 p_user_id
                                                                ),
                                   1, branch_cd,
                                   NULL
                                  )
                ORDER BY 1)
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.branch_name := i.branch_name;
         PIPE ROW (v_list);
      END LOOP;
   END get_branch_per_fund_lov;

   FUNCTION get_branch_lov_in_acctrans (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_list   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT   f.branch_cd, f.branch_name
                    FROM giac_branches f
                   WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                       f.branch_cd,
                                                       p_module_id,
                                                       p_user_id
                                                      ) = 1
                     AND EXISTS (
                            SELECT 1
                              FROM giac_acctrans e
                             WHERE e.gfun_fund_cd = f.gfun_fund_cd
                               AND e.gibr_branch_cd = f.branch_cd)
                GROUP BY f.branch_cd, f.branch_name
                ORDER BY f.branch_cd)
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.branch_name := i.branch_name;
         PIPE ROW (v_list);
      END LOOP;
   END get_branch_lov_in_acctrans;

   FUNCTION val_branch_cd_in_acctrans (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_branch_cd   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_temp   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT branch_name
           INTO v_temp
           FROM giac_branches
          WHERE branch_cd = p_branch_cd
            AND check_user_per_iss_cd_acctg2 (NULL,
                                              branch_cd,
                                              p_module_id,
                                              p_user_id
                                             ) = 1
            AND EXISTS (
                   SELECT 1
                     FROM giac_acctrans e
                    WHERE e.gfun_fund_cd = gfun_fund_cd
                      AND e.gibr_branch_cd = branch_cd);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_temp := 'ERROR';
      END;

      RETURN v_temp;
   END val_branch_cd_in_acctrans;

   FUNCTION get_giacs127_branch_lov (p_user_id VARCHAR2, p_module_id VARCHAR2)
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_list   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT   branch_name, branch_cd
                    FROM giac_branches
                   WHERE branch_cd =
                            DECODE
                                  (check_user_per_iss_cd_acctg2 (NULL,
                                                                 branch_cd,
                                                                 'GIACS127',
                                                                 p_user_id
                                                                ),
                                   1, branch_cd,
                                   NULL
                                  )
                ORDER BY 1)
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.branch_name := i.branch_name;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacs127_branch_lov;

   FUNCTION get_branch_giacs240_lov (
      p_gfun_fund_cd   giac_branches.gfun_fund_cd%TYPE,
      p_module_id      giis_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED
   AS
      v_branch   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT   branch_cd, branch_name
                    FROM giac_branches
                   WHERE gfun_fund_cd = p_gfun_fund_cd
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       branch_cd,
                                                       p_module_id,
                                                       p_user_id
                                                      ) = 1
                ORDER BY 2)
      LOOP
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         PIPE ROW (v_branch);
      END LOOP;
   END get_branch_giacs240_lov;

   FUNCTION get_branch_lovgiacs414 (p_user_id giis_users.user_id%TYPE)
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_rec   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT iss_cd, iss_name
                           FROM giis_issource
                          WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                              iss_cd,
                                                              'GIACS414',
                                                              p_user_id
                                                             ) = 1
                            AND iss_cd IN (SELECT iss_cd
                                             FROM gipi_polbasic))
      LOOP
         v_rec.branch_cd := i.iss_cd;
         v_rec.branch_name := i.iss_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_dynamic_branch_lov (
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   giis_modules.module_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_rec   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT iss_cd, iss_name
                           FROM giis_issource
                          WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                              iss_cd,
                                                              p_module_id,
                                                              p_user_id
                                                             ) = 1
                            AND iss_cd IN (SELECT iss_cd
                                             FROM gipi_polbasic))
      LOOP
         v_rec.branch_cd := i.iss_cd;
         v_rec.branch_name := i.iss_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giacs053_branch_lov (
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_row   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT a.branch_cd, a.branch_name
                  FROM giac_branches a
                 WHERE gfun_fund_cd = p_fund_cd
                   AND (   UPPER (branch_cd) LIKE
                                          UPPER (NVL (p_find_text, branch_cd))
                        OR UPPER (branch_name) LIKE
                                        UPPER (NVL (p_find_text, branch_name))
                       )
                   AND check_user_per_iss_cd_acctg2 (NULL,
                                                     a.branch_cd,
                                                     p_module_id,
                                                     p_user_id
                                                    ) = 1
                   AND EXISTS (
                          SELECT 'X'
                            FROM giac_order_of_payts b
                           WHERE b.gibr_gfun_fund_cd = a.gfun_fund_cd
                             AND b.gibr_branch_cd = a.branch_cd)
                   AND EXISTS (
                          SELECT 'X'
                            FROM giac_dcb_users
                           WHERE gibr_branch_cd = a.branch_cd
                             AND dcb_user_id = p_user_id))
      LOOP
         v_row.branch_cd := i.branch_cd;
         v_row.branch_name := i.branch_name;
         PIPE ROW (v_row);
      END LOOP;
   END;

   --kenneth L. 10.14.2013
   FUNCTION get_giarpr001_branch_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_month     NUMBER,
      p_year      NUMBER
   )
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_rec   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT gibr_branch_cd, branch_name
                           FROM giac_acctrans a, giac_branches b
                          WHERE a.tran_class IN
                                           ('PRD', 'UW', 'INF', 'OF', 'PPR')
                            AND TO_NUMBER (TO_CHAR (a.tran_date, 'MM')) =
                                                                       p_month
                            AND TO_NUMBER (TO_CHAR (a.tran_date, 'YYYY')) =
                                                                        p_year
                            AND a.tran_flag IN ('C', 'P')
                            AND a.tran_id > 0
                            AND a.gfun_fund_cd = b.gfun_fund_cd
                            AND a.gibr_branch_cd = b.branch_cd
                            AND check_user_per_iss_cd_acctg2 (NULL,
                                                              gibr_branch_cd,
                                                              'GIARPR001',
                                                              p_user_id
                                                             ) = 1)
      LOOP
         v_rec.branch_cd := i.gibr_branch_cd;
         v_rec.branch_name := i.branch_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_giarpr001_branch_lov;

   FUNCTION get_generalbranch_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_branch   branch_cd_lov_type;
   BEGIN
      FOR i IN
         (SELECT   branch_cd, branch_name
              FROM giac_branches
             WHERE 1 = 1
               AND branch_cd =
                      DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                            branch_cd,
                                                            p_module_id,
                                                            p_user_id
                                                           ),
                              1, branch_cd,
                              NULL
                             )
               AND UPPER (branch_cd) LIKE
                               '%' || UPPER (NVL (p_keyword, branch_cd))
                               || '%'
          ORDER BY 2)
      LOOP
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         PIPE ROW (v_branch);
      END LOOP;
   END get_generalbranch_lov;

   FUNCTION get_giacs104branch_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_branch   branch_cd_lov_type;
   BEGIN
      FOR i IN
         (SELECT   a.branch_cd, a.branch_name
              FROM giac_branches a
             WHERE EXISTS (
                      SELECT 'X'
                        FROM giac_acctrans b
                       WHERE b.gfun_fund_cd = a.gfun_fund_cd
                         AND b.gibr_branch_cd = a.branch_cd)
               AND a.branch_cd IN (
                      SELECT iss_cd
                        FROM giis_issource
                       WHERE iss_cd =
                                DECODE
                                     (check_user_per_iss_cd_acctg2 (NULL,
                                                                   iss_cd,
                                                                   'GIACS104',
                                                                   p_user_id
                                                                  ),
                                      1, iss_cd,
                                      NULL
                                     ))
               AND (UPPER(branch_cd) LIKE '%' || UPPER(NVL(p_keyword, branch_cd)) || '%'
			    OR UPPER(branch_name) LIKE '%' || UPPER(NVL(p_keyword, branch_name)) || '%')
          ORDER BY 2)
      LOOP
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         PIPE ROW (v_branch);
      END LOOP;
   END get_giacs104branch_lov;
END giac_branches_pkg;
/