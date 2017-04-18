CREATE OR REPLACE PACKAGE BODY CPI.gipis200_pkg
AS
/*
**  Created by    : Ildefonso Ellarina
**  Date Created  : 10.07.2013
**  Reference By  : (GIPIS200 - Underwriting - Policy Inquiries - View Production)
**  Description   : Get Line LOV
*/
   FUNCTION get_line_lov (p_iss_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN get_line_lov_tab PIPELINED
   IS
      v_list   get_line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE check_user_per_line2 (line_cd,
                                               p_iss_cd,
                                               'GIPIS200',
                                               p_user_id
                                              ) = 1
                     AND check_user_per_iss_cd2 (line_cd,
                                                 p_iss_cd,
                                                 'GIPIS200',
                                                 p_user_id
                                                ) = 1
                ORDER BY line_cd)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_line_lov;

/*
**  Created by    : Ildefonso Ellarina
**  Date Created  : 10.07.2013
**  Reference By  : (GIPIS200 - Underwriting - Policy Inquiries - View Production)
**  Description   : Get Subline LOV
*/
   FUNCTION get_subline_lov (p_line_cd VARCHAR2)
      RETURN get_subline_lov_tab PIPELINED
   IS
      v_list   get_subline_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT subline_cd, subline_name
                           FROM giis_subline
                          WHERE line_cd = NVL (p_line_cd, line_cd)
                       ORDER BY subline_cd, subline_name)
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_subline_lov;

/*
**  Created by    : Ildefonso Ellarina
**  Date Created  : 10.07.2013
**  Reference By  : (GIPIS200 - Underwriting - Policy Inquiries - View Production)
**  Description   : Get Issue Code LOV
*/
   FUNCTION get_issue_lov (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN get_issue_lov_tab PIPELINED
   IS
      v_list   get_issue_lov_type;
   BEGIN
      FOR i IN (SELECT   iss_name, iss_cd
                    FROM giis_issource
                   WHERE iss_cd =
                            DECODE (check_user_per_iss_cd2 (p_line_cd,
                                                            iss_cd,
                                                            'GIPIS200',
                                                            p_user_id
                                                           ),
                                    1, iss_cd,
                                    NULL
                                   )
                ORDER BY iss_cd)
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_issue_lov;

/*
**  Created by    : Ildefonso Ellarina
**  Date Created  : 10.07.2013
**  Reference By  : (GIPIS200 - Underwriting - Policy Inquiries - View Production)
**  Description   : Get Issue Year LOV
*/
   FUNCTION get_issue_year_lov
      RETURN get_issue_year_lov_tab PIPELINED
   IS
      v_list   get_issue_year_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT TO_CHAR (TO_DATE (issue_yy, 'RR'),
                                         'RRRR'
                                        ) issue_yy
                           FROM gipi_polbasic
                       ORDER BY issue_yy DESC)
      LOOP
         v_list.issue_yy := i.issue_yy;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_issue_year_lov;

/*
**  Created by    : Ildefonso Ellarina
**  Date Created  : 10.07.2013
**  Reference By  : (GIPIS200 - Underwriting - Policy Inquiries - View Production)
**  Description   : Get Intermediary LOV
*/
   FUNCTION get_intermediary_lov (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN get_intermediary_lov_tab PIPELINED
   IS
      v_list   get_intermediary_lov_type;
   BEGIN
      FOR i IN (SELECT   intm_no, intm_name
                    FROM giis_intermediary
                   WHERE iss_cd =
                            DECODE (check_user_per_iss_cd2 (p_line_cd,
                                                            iss_cd,
                                                            'GIPIS200',
                                                            p_user_id
                                                           ),
                                    1, iss_cd,
                                    NULL
                                   )
                ORDER BY intm_no)
      LOOP
         v_list.intm_no := i.intm_no;
         v_list.intm_name := i.intm_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_intermediary_lov;

   PROCEDURE check_view_prod_dtls (
      p_user_id   IN       gicl_res_brdrx_extr.user_id%TYPE,
      p_message   OUT      VARCHAR2
   )
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_prod_ext
                 WHERE user_id = p_user_id)
      LOOP
         v_exist := 'Y';
      END LOOP;

      IF v_exist = 'N'
      THEN
         p_message := 'Please extract records first.';
      END IF;
   END check_view_prod_dtls;

   PROCEDURE extract_production (
      p_line_cd            IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd         IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd             IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           IN       gipi_polbasic.issue_yy%TYPE,
      p_intm_no            IN       giis_intermediary.intm_no%TYPE,
      p_cred_iss           IN       VARCHAR2,
      p_param_date         IN       NUMBER,
      p_from_date          IN       DATE,
      p_to_date            IN       DATE,
      p_month              IN       gipi_polbasic.booking_mth%TYPE,
      p_year               IN       gipi_polbasic.booking_year%TYPE,
      p_dist_flag          IN       VARCHAR2,
      p_reg_policy_sw      IN       VARCHAR2,
      p_user               IN       VARCHAR2,
      p_message            OUT      VARCHAR2,
      p_no_of_policies     OUT      NUMBER,
      p_total_tsi          OUT      NUMBER,
      p_total_prem         OUT      NUMBER,
      p_total_tax          OUT      NUMBER,
      p_total_commission   OUT      NUMBER
   )
   AS
      TYPE policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE total_tsi_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE total_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE spld_date_tab IS TABLE OF gipi_polbasic.spld_date%TYPE;

      TYPE pol_flag_tab IS TABLE OF gipi_polbasic.pol_flag%TYPE;

      vv_policy_id            policy_id_tab;
      vv_total_tsi            total_tsi_tab;
      vv_total_prem           total_prem_tab;
      vv_acct_ent_date        acct_ent_date_tab;
      vv_spld_acct_ent_date   spld_acct_ent_date_tab;
      vv_spld_date            spld_date_tab;
      vv_pol_flag             pol_flag_tab;
      v_multiplier            NUMBER                 := 1;
      v_count                 NUMBER;
--      added by gab 10.26.2016
      v_evat         giac_parameters.param_value_v%TYPE;
      v_5prem_tax    giac_parameters.param_value_v%TYPE;
      v_fst          giac_parameters.param_value_v%TYPE;
      v_lgt          giac_parameters.param_value_v%TYPE;
      v_doc_stamps   giac_parameters.param_value_v%TYPE;
      v_layout       NUMBER;
   BEGIN
      v_evat := giacp.n ('EVAT');
      v_5prem_tax := giacp.n ('5PREM_TAX');
      v_fst := giacp.n ('FST');
      v_lgt := giacp.n ('LGT');
      v_doc_stamps := giacp.n ('DOC_STAMPS');
      v_layout := giisp.n ('PROD_REPORT_EXTRACT');
--      end gab

      DELETE FROM gipi_prod_ext
            WHERE user_id = p_user;

      DELETE FROM gipi_prod_param
            WHERE user_id = p_user;

      INSERT INTO gipi_prod_param
                  (line_cd, subline_cd, iss_cd, issue_yy, intm_no,
                   cred_iss, param_date, from_date, TO_DATE,
                   MONTH, YEAR, dist_flag, reg_policy_sw, user_id,
                   last_extract
                  )
           VALUES (p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_intm_no,
                   p_cred_iss, p_param_date, p_from_date, p_to_date,
                   p_month, p_year, p_dist_flag, p_reg_policy_sw, p_user,
                   SYSDATE
                  );

      COMMIT;
      gipis200_pkg.extract_pol_from_prod (p_line_cd,
                                          p_subline_cd,
                                          p_iss_cd,
                                          p_issue_yy,
                                          p_intm_no,
                                          p_cred_iss,
                                          p_param_date,
                                          p_from_date,
                                          p_to_date,
                                          p_month,
                                          p_year,
                                          p_dist_flag,
                                          p_reg_policy_sw,
                                          p_user
                                         );

      SELECT COUNT (policy_id)
        INTO v_count
        FROM gipi_prod_ext
       WHERE user_id = p_user;
        
      IF v_count > 0
      THEN
         DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS'));

         FOR x IN (SELECT a.policy_id, b.item_grp, b.takeup_seq_no
                     FROM gipi_prod_ext a, gipi_invoice b, gipi_polbasic c
                    WHERE a.policy_id = b.policy_id
                      AND c.policy_id = a.policy_id
                      AND (   c.pol_flag != '5'
                           OR DECODE (p_param_date, 4, 1, 0) = 1
                          )
                      AND (   TRUNC (c.issue_date) BETWEEN p_from_date
                                                       AND p_to_date
                           OR DECODE (p_param_date, 1, 0, 1) = 1
                          )
                      AND (   TRUNC (c.eff_date) BETWEEN p_from_date AND p_to_date
                           OR DECODE (p_param_date, 2, 0, 1) = 1
                          )
                      AND (   TRUNC (c.acct_ent_date) BETWEEN p_from_date
                                                          AND p_to_date
                           OR DECODE (p_param_date, 4, 0, 1) = 1
                          )
                      AND (   (       b.multi_booking_mm
                                   || '-'
                                   || b.multi_booking_yy =
                                                      p_month || '-' || p_year
                               AND b.multi_booking_mm IS NOT NULL
                               AND b.multi_booking_yy IS NOT NULL
                              )
                           OR DECODE (p_param_date, 3, 0, 1) = 1
                          )
                      AND a.user_id = p_user)
         LOOP
            
--            modified by gab 10.26.2016
--            gipis200_pkg.pol_taxes2 (x.item_grp,
--                                     x.takeup_seq_no,
--                                     x.policy_id,
--                                     p_param_date,
--                                     p_from_date,
--                                     p_to_date,
--                                     p_user,
--                                     p_month,
--                                     p_year
--                                    );
            gipis200_pkg.pol_taxes3 (x.item_grp,
                                     x.takeup_seq_no,
                                     x.policy_id,
                                     p_param_date,
                                     p_from_date,
                                     p_to_date,
                                     p_user,
                                     p_month,
                                     p_year,
                                     v_evat,
                                     v_5prem_tax,
                                     v_fst,
                                     v_lgt,
                                     v_doc_stamps,
                                     v_layout
                                    );
--            end gab
         END LOOP;
      END IF;

      IF v_count <> 0 AND p_param_date = 4
      THEN
         SELECT policy_id, total_tsi, total_prem, acct_ent_date,
                spld_acct_ent_date, spld_date, pol_flag
         BULK COLLECT INTO vv_policy_id, vv_total_tsi, vv_total_prem, vv_acct_ent_date,
                vv_spld_acct_ent_date, vv_spld_date, vv_pol_flag
           FROM gipi_prod_ext
          WHERE user_id = p_user;

         DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START 3');

         FOR idx IN vv_policy_id.FIRST .. vv_policy_id.LAST
         LOOP
            IF     (vv_acct_ent_date (idx) BETWEEN p_from_date AND p_to_date
                   )
               AND (vv_spld_acct_ent_date (idx) BETWEEN p_from_date AND p_to_date
                   )
            THEN
               vv_total_tsi (idx) := 0;
               vv_total_prem (idx) := 0;
            ELSIF     vv_spld_date (idx) BETWEEN p_from_date AND p_to_date
                  AND vv_pol_flag (idx) = '5'
            THEN
               vv_total_tsi (idx) := vv_total_tsi (idx);
               vv_total_prem (idx) := vv_total_prem (idx);
            END IF;

            vv_spld_date (idx) := NULL;
         END LOOP;

         DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START 4');
         FORALL upd IN vv_policy_id.FIRST .. vv_policy_id.LAST
            UPDATE gipi_prod_ext
               SET total_tsi = vv_total_tsi (upd),
                   total_prem = vv_total_prem (upd),
                   spld_date = vv_spld_date (upd)
             WHERE policy_id = vv_policy_id (upd) AND user_id = p_user;
         COMMIT;
      END IF;
        
      BEGIN
         SELECT DISTINCT COUNT (policy_id)
                    INTO p_no_of_policies
                    FROM gipi_prod_ext
                   WHERE user_id = p_user;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_no_of_policies := 0;
      END;

      IF p_no_of_policies > 0
      THEN
         p_message :=
            'Extraction finished. ' || p_no_of_policies
            || ' records extracted';

--            modified by gab 10.26.2016
--         BEGIN
--            SELECT SUM (total_tsi)
--              INTO p_total_tsi
--              FROM gipi_prod_ext
--             WHERE user_id = p_user;
--         EXCEPTION
--            WHEN NO_DATA_FOUND
--            THEN
--               p_total_tsi := 0;
--         END;

--         BEGIN
--            SELECT SUM (total_prem)
--              INTO p_total_prem
--              FROM gipi_prod_ext
--             WHERE user_id = p_user;
--         EXCEPTION
--            WHEN NO_DATA_FOUND
--            THEN
--               p_total_prem := 0;
--         END;

--         BEGIN
--            SELECT SUM (comm_amt)
--              INTO p_total_commission
--              FROM gipi_prod_ext
--             WHERE user_id = p_user;
--         EXCEPTION
--            WHEN NO_DATA_FOUND
--            THEN
--               p_total_prem := 0;
--         END;

--         BEGIN
--            SELECT SUM (evatprem) + SUM (fst) + SUM (lgt) + SUM (doc_stamps)
--              INTO p_total_tax
--              FROM gipi_prod_ext
--             WHERE user_id = p_user;
--         EXCEPTION
--            WHEN NO_DATA_FOUND
--            THEN
--               p_total_tax := 0;
--         END;

         BEGIN
            SELECT SUM (total_tsi), SUM (total_prem), SUM (comm_amt), SUM (evatprem) + SUM (fst) + SUM (lgt) + SUM (doc_stamps)
              INTO p_total_tsi, p_total_prem, p_total_commission, p_total_tax
              FROM gipi_prod_ext
             WHERE user_id = p_user;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_total_tsi := 0;
               p_total_prem := 0;
               p_total_commission := 0;
               p_total_tax := 0;
         END;
--         end gab
      ELSE
         p_message := 'Extraction finished. No records extracted';
         p_no_of_policies := 0;
         p_total_tsi := 0;
         p_total_prem := 0;
         p_total_commission := 0;
         p_total_tax := 0;
      END IF;
   END;

   PROCEDURE extract_pol_from_prod (
      p_line_cd         IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd      IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        IN   gipi_polbasic.issue_yy%TYPE,
      p_intm_no         IN   giis_intermediary.intm_no%TYPE,
      p_cred_iss        IN   VARCHAR2,
      p_param_date      IN   NUMBER,
      p_from_date       IN   DATE,
      p_to_date         IN   DATE,
      p_month           IN   gipi_polbasic.booking_mth%TYPE,
      p_year            IN   gipi_polbasic.booking_year%TYPE,
      p_dist_flag       IN   VARCHAR2,
      p_reg_policy_sw   IN   VARCHAR2,
      p_user            IN   VARCHAR2
   )
   AS
      TYPE v_assd_no_tab IS TABLE OF gipi_polbasic.assd_no%TYPE;

      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_issue_date_tab IS TABLE OF VARCHAR2 (50);

      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;

      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (50);

      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (50);

      TYPE v_total_tsi_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_total_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_par_id_tab IS TABLE OF gipi_polbasic.par_id%TYPE;

      TYPE v_eff_date_tab IS TABLE OF gipi_polbasic.eff_date%TYPE;

      TYPE v_assd_name_tab IS TABLE OF giis_assured.assd_name%TYPE;

      TYPE v_policy_no_tab IS TABLE OF VARCHAR2 (100);

      TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;

      TYPE v_pol_flag_tab IS TABLE OF gipi_polbasic.pol_flag%TYPE;

      TYPE v_spld_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_dist_flag_tab IS TABLE OF gipi_polbasic.dist_flag%TYPE;

      TYPE v_spld_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);

      v_assd_no              v_assd_no_tab;
      v_policy_id            v_policy_id_tab;
      v_issue_date           v_issue_date_tab;
      v_line_cd              v_line_cd_tab;
      v_subline_cd           v_subline_cd_tab;
      v_iss_cd               v_iss_cd_tab;
      v_issue_yy             v_issue_yy_tab;
      v_pol_seq_no           v_pol_seq_no_tab;
      v_renew_no             v_renew_no_tab;
      v_endt_iss_cd          v_endt_iss_cd_tab;
      v_endt_yy              v_endt_yy_tab;
      v_endt_seq_no          v_endt_seq_no_tab;
      v_incept_date          v_incept_date_tab;
      v_expiry_date          v_expiry_date_tab;
      v_total_tsi            v_total_tsi_tab;
      v_total_prem           v_total_prem_tab;
      v_par_id               v_par_id_tab;
      v_eff_date             v_eff_date_tab;
      v_assd_name            v_assd_name_tab;
      v_policy_no            v_policy_no_tab;
      v_cred_branch          v_cred_branch_tab;
      v_pol_flag             v_pol_flag_tab;
      v_spld_date            v_spld_date_tab;
      v_dist_flag            v_dist_flag_tab;
      v_spld_acct_ent_date   v_spld_acct_ent_date_tab;
      v_acct_ent_date        v_acct_ent_date_tab;
      v_x                    NUMBER;
   BEGIN
      SELECT   /*+INDEX (GP POLBASIC_U1) */
               a.assd_no, gp.policy_id gp_policy_id,
               gp.issue_date gp_issue_date, gp.line_cd gp_line_cd,
               gp.subline_cd gp_subline_cd, gp.iss_cd gp_iss_cd,
               gp.issue_yy gp_issue_yy, gp.pol_seq_no gp_pol_seq_no,
               gp.renew_no gp_renew_no, gp.endt_iss_cd gp_endt_iss_cd,
               gp.endt_yy gp_endt_yy, gp.endt_seq_no gp_endt_seq_no,
               gp.incept_date gp_incept_date, gp.expiry_date gp_expiry_date,
               gp.tsi_amt gp_tsi_amt, gp.prem_amt gp_prem_amt,
               gp.spld_acct_ent_date gp_spld_acct_ent_date,
               gp.dist_flag dist_flag, gp.spld_date gp_spld_date,
               gp.pol_flag gp_pol_flag, gp.cred_branch gp_cred_branch,
               gp.par_id, gp.eff_date, ga.assd_name,
                  LTRIM (gp.line_cd)
               || '-'
               || LTRIM (gp.subline_cd)
               || '-'
               || LTRIM (gp.iss_cd)
               || '-'
               || LTRIM (TO_CHAR (gp.issue_yy, '99'))
               || '-'
               || LPAD (LTRIM (TO_CHAR (gp.pol_seq_no, '9999999')), 7, '0')
               || '-'
               || LPAD (LTRIM (TO_CHAR (gp.renew_no, '99')), 2, '0')
               || '-'
               || LTRIM (gp.endt_iss_cd)
               || '-'
               || LPAD (LTRIM (TO_CHAR (gp.endt_yy, '99')), 2, '0')
               || '-'
               || LPAD (LTRIM (TO_CHAR (gp.endt_seq_no, '999999')), 3, '0')
                                                                    policy_no
      BULK COLLECT INTO v_assd_no, v_policy_id,
               v_issue_date, v_line_cd,
               v_subline_cd, v_iss_cd,
               v_issue_yy, v_pol_seq_no,
               v_renew_no, v_endt_iss_cd,
               v_endt_yy, v_endt_seq_no,
               v_incept_date, v_expiry_date,
               v_total_tsi, v_total_prem,
               v_spld_acct_ent_date,
               v_dist_flag, v_spld_date,
               v_pol_flag, v_cred_branch,
               v_par_id, v_eff_date, v_assd_name,
               v_policy_no
          FROM gipi_parlist a,
               gipi_polbasic gp,
               gipi_invoice gi,
               giuw_pol_dist gpd,
               giis_assured ga,
               gipi_comm_invoice gpi
         WHERE a.par_id = gp.par_id
           AND gipis200_pkg.check_date_prod_policy (p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_month,
                                                    p_year,
                                                    gp.issue_date,
                                                    gp.eff_date,
                                                    gi.acct_ent_date,
                                                    gi.spoiled_acct_ent_date,
                                                    gi.multi_booking_mm,
                                                    gi.multi_booking_yy
                                                   ) = 1
           AND gi.policy_id = gp.policy_id
           AND gp.reg_policy_sw =
                             DECODE (p_reg_policy_sw,
                                     'Y', reg_policy_sw,
                                     'Y'
                                    )
           AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
--           modified by gab 10.26.2016
           AND EXISTS (SELECT 'X'
                         FROM TABLE (security_access.get_branch_line ('UW', 'GIPIS200', p_user))
                        WHERE branch_cd = DECODE (p_cred_iss,
                                                             'C', gp.cred_branch,
                                                             gp.iss_cd
                                                            )
                              and line_cd =  gp.line_cd )
--           AND gp.line_cd =
--                  NVL (p_line_cd,
--                       DECODE (check_user_per_line2 (gp.line_cd,
--                                                     DECODE (p_cred_iss,
--                                                             'C', gp.cred_branch,
--                                                             gp.iss_cd
--                                                            ),
--                                                     'GIPIS200',
--                                                     p_user
--                                                    ),
--                               1, gp.line_cd
--                              )
--                      )
           AND DECODE (p_cred_iss, 'C', gp.cred_branch, gp.iss_cd) =
                  NVL (p_iss_cd,
                       DECODE (p_cred_iss, 'C', gp.cred_branch, gp.iss_cd)
                      )
--           AND DECODE (p_cred_iss, 'C', gp.cred_branch, gp.iss_cd) =
--                  NVL
--                     (p_iss_cd,
--                      DECODE
--                            (check_user_per_iss_cd2 (gp.line_cd,
--                                                     DECODE (p_cred_iss,
--                                                             'C', gp.cred_branch,
--                                                             gp.iss_cd
--                                                            ),
--                                                     'GIPIS200',
--                                                     p_user
--                                                    ),
--                             1, DECODE (p_cred_iss,
--                                        'C', gp.cred_branch,
--                                        gp.iss_cd
--                                       )
--                            )
--                     )
--            end gab
           AND gp.policy_id = gpd.policy_id
           AND NVL (gi.takeup_seq_no, 1) = NVL (gpd.takeup_seq_no, 1)
           AND NVL (gi.item_grp, 1) = NVL (gpd.item_grp, 1)
           AND gpd.dist_flag <> DECODE (gp.pol_flag, '5', 5, 4)
           AND gpd.dist_flag <> 5
           AND 1 =
                  DECODE (p_param_date,
                          '4', DECODE (gi.acct_ent_date, NULL, 0, 1),
                          1
                         )
           AND 1 =
                  DECODE (p_param_date,
                          4, DECODE (NVL (gpd.acct_ent_date, gi.acct_ent_date),
                                     NULL, 0,
                                     1
                                    ),
                          1
                         )
           AND a.assd_no = ga.assd_no
           AND gi.iss_cd = gpi.iss_cd
           AND gi.prem_seq_no = gpi.prem_seq_no
           AND TO_CHAR (TO_DATE (gp.issue_yy, 'RR'), 'RRRR') =
                  NVL (p_issue_yy,
                       TO_CHAR (TO_DATE (gp.issue_yy, 'RR'), 'RRRR')
                      )
           AND gpi.intrmdry_intm_no = NVL (p_intm_no, gpi.intrmdry_intm_no)
           AND (   (p_dist_flag = 'D' AND gp.dist_flag = '3')
                OR (p_dist_flag = 'U' AND gp.dist_flag IN ('1', '2'))
                OR (p_dist_flag = 'B' AND gp.dist_flag IN ('1', '2', '3'))
               )
      GROUP BY a.assd_no,
               gp.policy_id,
               gp.issue_date,
               gp.line_cd,
               gp.subline_cd,
               gp.iss_cd,
               gp.issue_yy,
               gp.pol_seq_no,
               gp.renew_no,
               gp.endt_iss_cd,
               gp.endt_yy,
               gp.endt_seq_no,
               gp.incept_date,
               gp.expiry_date,
               gp.tsi_amt,
               gp.prem_amt,
               gp.spld_acct_ent_date,
               gp.dist_flag,
               gp.spld_date,
               gp.pol_flag,
               gp.cred_branch,
               gp.par_id,
               gp.eff_date,
               ga.assd_name;

      IF SQL%FOUND
      THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_prod_ext
                        (assd_no, policy_id,
                         issue_date, line_cd,
                         subline_cd, iss_cd,
                         issue_yy, pol_seq_no,
                         renew_no, endt_iss_cd,
                         endt_yy, endt_seq_no,
                         incept_date, expiry_date,
                         total_tsi, total_prem, user_id,
                         spld_acct_ent_date, dist_flag,
                         spld_date, pol_flag, param_date,
                         evatprem, fst, lgt, doc_stamps, other_taxes,
                         other_charges, cred_branch, cred_iss_param,
                         reg_policy_sw_param, par_id, eff_date,
                         assd_name, policy_no
                        )
                 VALUES (v_assd_no (cnt), v_policy_id (cnt),
                         v_issue_date (cnt), v_line_cd (cnt),
                         v_subline_cd (cnt), v_iss_cd (cnt),
                         v_issue_yy (cnt), v_pol_seq_no (cnt),
                         v_renew_no (cnt), v_endt_iss_cd (cnt),
                         v_endt_yy (cnt), v_endt_seq_no (cnt),
                         v_incept_date (cnt), v_expiry_date (cnt),
                         v_total_tsi (cnt), v_total_prem (cnt), p_user,
                         v_spld_acct_ent_date (cnt), v_dist_flag (cnt),
                         v_spld_date (cnt), v_pol_flag (cnt), p_param_date,
                         0, 0, 0, 0, 0,
                         0, v_cred_branch (cnt), p_cred_iss,
                         p_reg_policy_sw, v_par_id (cnt), v_eff_date (cnt),
                         v_assd_name (cnt), v_policy_no (cnt)
                        );
         COMMIT;
      END IF;

      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'MAIN');
   END;

   FUNCTION check_date_prod_policy (
      p_param_date      NUMBER,
      p_from_date       DATE,
      p_to_date         DATE,
      p_month           gipi_polbasic.booking_mth%TYPE,
      p_year            gipi_polbasic.booking_year%TYPE,
      p_issue_date      DATE,
      p_eff_date        DATE,
      p_acct_ent_date   DATE,
      p_spld_acct       DATE,
      p_booking_mth     gipi_polbasic.booking_mth%TYPE,
      p_booking_year    gipi_polbasic.booking_year%TYPE
   )
      RETURN NUMBER
   IS
      v_check_date   NUMBER (1) := 0;
   BEGIN
      IF p_param_date = 1
      THEN                                             ---based on issue_date
         IF TRUNC (p_issue_date) BETWEEN p_from_date AND p_to_date
         THEN
            v_check_date := 1;
         END IF;
      ELSIF p_param_date = 2
      THEN                                         --based on effectivity_date
         IF TRUNC (p_eff_date) BETWEEN p_from_date AND p_to_date
         THEN
            v_check_date := 1;
         END IF;
      ELSIF p_param_date = 3
      THEN                                           --based on booking mth/yr
         DBMS_OUTPUT.put_line ('x ' || p_booking_mth);

         IF p_booking_mth IS NOT NULL AND p_booking_year IS NOT NULL
         THEN
            IF p_booking_mth || '-' || p_booking_year =
                                                     p_month || '-' || p_year
            THEN
               v_check_date := 1;
            END IF;
         END IF;
      ELSIF p_param_date = 4 AND p_acct_ent_date IS NOT NULL
      THEN
         IF TRUNC (p_acct_ent_date) BETWEEN p_from_date AND p_to_date
         THEN
            IF     TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date
               AND p_spld_acct IS NOT NULL
            THEN
               v_check_date := 0;
            ELSE
               v_check_date := 1;
            END IF;
         ELSIF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date
         THEN
            v_check_date := 0;
         END IF;
      END IF;

      RETURN (v_check_date);
   END;                                       --end function check_date_policy

   PROCEDURE pol_taxes2 (
      p_item_grp             gipi_invoice.item_grp%TYPE,
      p_takeup_seq_no        gipi_invoice.takeup_seq_no%TYPE,
      p_policy_id            gipi_invoice.policy_id%TYPE,
      p_param_date      IN   NUMBER,
      p_from_date       IN   DATE,
      p_to_date         IN   DATE,
      p_user            IN   VARCHAR2,
      p_month                gipi_polbasic.booking_mth%TYPE,
      p_year                 gipi_polbasic.booking_year%TYPE
   )
   IS
      v_evat         giac_parameters.param_value_v%TYPE;
      v_5prem_tax    giac_parameters.param_value_v%TYPE;
      v_fst          giac_parameters.param_value_v%TYPE;
      v_lgt          giac_parameters.param_value_v%TYPE;
      v_doc_stamps   giac_parameters.param_value_v%TYPE;
      v_layout       NUMBER;                               --jason 07/31/2008
   BEGIN
      v_evat := giacp.n ('EVAT');
      v_5prem_tax := giacp.n ('5PREM_TAX');
      v_fst := giacp.n ('FST');
      v_lgt := giacp.n ('LGT');
      v_doc_stamps := giacp.n ('DOC_STAMPS');
      v_layout := giisp.n ('PROD_REPORT_EXTRACT');          --jason 7/31/2008
      -- for evat
      MERGE INTO gipi_prod_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)) evat,
                         giv.policy_id policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ) comm_amt
                                                             --added by jason
                         ,
                         gpp.user_id                       --jason 10/17/2008
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_prod_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = p_user
                     AND git.tax_cd IN (v_5prem_tax, v_evat)
                     AND NVL (giv.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1)
                                                                      -- aaron
                     --AND giv.takeup_seq_no  = p_takeup_seq_no
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
                GROUP BY giv.policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ),
                         gpp.user_id) evat
         ON (evat.policy_id = gpp.policy_id AND evat.user_id = gpp.user_id)
         --jason 10/17/2008
      WHEN MATCHED THEN
            UPDATE
               SET gpp.evatprem = evat.evat + NVL (gpp.evatprem, 0),
                   gpp.comm_amt = evat.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (evatprem, policy_id, comm_amt)
            VALUES (evat.evat, evat.policy_id, evat.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'EVAT01');
      -- for fst
      MERGE INTO gipi_prod_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)) fst,
                         giv.policy_id policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ) comm_amt --added by jason
                                                             ,
                         gpp.user_id                        --jason 10/17/2008
                    FROM gipi_inv_tax git, gipi_invoice giv,
                         gipi_prod_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = p_user
                     AND git.tax_cd = v_fst
                     AND NVL (giv.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1)
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
                GROUP BY giv.policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ),
                         gpp.user_id) fst
         ON (fst.policy_id = gpp.policy_id AND fst.user_id = gpp.user_id)
         --jason 10/17/2008
      WHEN MATCHED THEN
            UPDATE
               SET gpp.fst = fst.fst + NVL (gpp.fst, 0),
                   gpp.comm_amt = fst.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (fst, policy_id, comm_amt)
            VALUES (fst.fst, fst.policy_id, fst.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'FST');
      --for lgt
      MERGE INTO gipi_prod_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)) lgt,
                         giv.policy_id policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ) comm_amt --added by jason
                                                             ,
                         gpp.user_id                        --jason 10/17/2008
                    FROM gipi_inv_tax git, gipi_invoice giv,
                         gipi_prod_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = p_user
                     AND git.tax_cd = v_lgt
                     AND NVL (giv.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1)
                     --aaron
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
                GROUP BY giv.policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ),
                         gpp.user_id) lgt
         ON (lgt.policy_id = gpp.policy_id AND lgt.user_id = gpp.user_id)
         --jason 10/17/2008
      WHEN MATCHED THEN
            UPDATE
               SET gpp.lgt = lgt.lgt + NVL (gpp.lgt, 0),
                   gpp.comm_amt = lgt.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (lgt, policy_id, comm_amt)
            VALUES (lgt.lgt, lgt.policy_id, lgt.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'LGT');
      -- other charges
      MERGE INTO gipi_prod_ext gpp
         USING (SELECT   SUM (NVL (giv.other_charges * giv.currency_rt, 0)
                             ) other_charges,
                         giv.policy_id policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ) comm_amt --added by jason
                                                             ,
                         gpp.user_id                        --jason 10/17/2008
                    FROM gipi_invoice giv, gipi_prod_ext gpp
                   WHERE 1 = 1
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = p_user
                     AND NVL (giv.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1)
                     -- aaron
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
                GROUP BY giv.policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ),
                         gpp.user_id) goc
         ON (goc.policy_id = gpp.policy_id AND goc.user_id = gpp.user_id)
         --jason 10/17/2008
      WHEN MATCHED THEN
            UPDATE
               SET gpp.other_charges =
                                goc.other_charges + NVL (gpp.other_charges, 0),
                   gpp.comm_amt = goc.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (other_charges, policy_id, comm_amt)
            VALUES (goc.other_charges, goc.policy_id, goc.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'OT');
      -- other taxes
      MERGE INTO gipi_prod_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)
                             ) other_taxes,
                         giv.policy_id policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ) comm_amt --added by jason
                                                             ,
                         gpp.user_id                        --jason 10/17/2008
                    FROM gipi_inv_tax git, gipi_invoice giv,
                         gipi_prod_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = p_user
                     AND git.tax_cd NOT IN
                            (v_evat, v_doc_stamps, v_fst, v_lgt, v_5prem_tax)
                     AND NVL (giv.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1)
                     -- aaron
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
                GROUP BY giv.policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ),
                         gpp.user_id) got
         ON (got.policy_id = gpp.policy_id AND got.user_id = gpp.user_id)
         --jason 10/17/2008
      WHEN MATCHED THEN
            UPDATE
               SET gpp.other_taxes =
                                    got.other_taxes + NVL (gpp.other_taxes, 0),
                   gpp.comm_amt = got.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (other_taxes, policy_id, comm_amt)
            VALUES (got.other_taxes, got.policy_id, got.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'OC');
      -- doc stamps
      MERGE INTO gipi_prod_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt, 0) * NVL (giv.currency_rt, 0)
                             ) doc_stamps,
                         giv.policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ) comm_amt --added by jason
                                                             ,
                         gpp.user_id                        --jason 10/17/2008
                    FROM gipi_inv_tax git, gipi_invoice giv,
                         gipi_prod_ext gpp
                   WHERE giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.item_grp = git.item_grp
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = p_user
                     AND git.tax_cd = v_doc_stamps
                     AND NVL (giv.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1)
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
                GROUP BY giv.policy_id,
                         gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ),
                         gpp.user_id) doc
         ON (doc.policy_id = gpp.policy_id AND doc.user_id = gpp.user_id)
         --jason 10/17/2008
      WHEN MATCHED THEN
            UPDATE
               SET gpp.doc_stamps = doc.doc_stamps + NVL (gpp.doc_stamps, 0),
                   gpp.comm_amt = doc.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (doc_stamps, policy_id, comm_amt)
            VALUES (doc.doc_stamps, doc.policy_id, doc.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'DOC');

      --**jason 07/31/2008 start**--
      IF v_layout = 2
      THEN
         FOR j IN (SELECT a.tax_cd
                     FROM gipi_inv_tax a, gipi_invoice b
                    WHERE a.prem_seq_no = b.prem_seq_no
                      AND a.iss_cd = b.iss_cd                --lems 06.19.2009
                      AND b.policy_id = p_policy_id
                      AND b.item_grp = p_item_grp
                      AND NVL (b.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1))
         -- aaron added nvl
         LOOP
            DBMS_OUTPUT.put_line (   j.tax_cd
                                  || '/'
                                  || p_takeup_seq_no
                                  || '/'
                                  || p_item_grp
                                  || '/'
                                  || p_policy_id
                                 );
            do_ddl
               (   'MERGE INTO GIPI_PROD_EXT gpp USING'
                || '   (SELECT SUM(NVL(git.tax_amt,0) * NVL(giv.currency_rt,0)) tax_amt,'
                || '           giv.policy_id, GIPIS200_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '
                || p_param_date
                || ', '''
                || p_from_date
                || ''', '''
                || p_to_date
                || ''', '
                || p_policy_id
                || ') comm_amt'
                || '          ,gpp.user_id'
                || '      FROM GIPI_INV_TAX git,'
                || '           GIPI_INVOICE giv,'
                || '           GIPI_PROD_EXT gpp'
                || '     WHERE giv.iss_cd       = git.iss_cd'
                || '       AND giv.prem_seq_no  = git.prem_seq_no'
                || '       AND git.tax_cd       >= 0'
                || '       AND giv.item_grp     = git.item_grp'
                || '       AND giv.policy_id    = gpp.policy_id'
                || '       AND gpp.user_id      = p_user'
                || '       AND git.tax_cd       = '
                || j.tax_cd
                || '       AND NVL(giv.takeup_seq_no,1)  = '
                || NVL (p_takeup_seq_no, 1)
                || '       AND giv.item_grp    = '
                || p_item_grp
                || '       AND giv.policy_id = '
                || p_policy_id
                || '     GROUP BY giv.policy_id, GIPIS200_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '
                || p_param_date
                || ', '''
                || p_from_date
                || ''', '''
                || p_to_date
                || ''', '
                || p_policy_id
                || '),gpp.user_id) subq'
                || '        ON (subq.policy_id = gpp.policy_id '
                || '            AND subq.user_id = gpp.user_id )'
                || '      WHEN MATCHED THEN UPDATE'
                || '        SET gpp.tax'
                || j.tax_cd
                || ' = subq.tax_amt + NVL(gpp.tax'
                || j.tax_cd
                || ',0)'
                || '           ,gpp.comm_amt = subq.comm_amt'
                || '      WHEN NOT MATCHED THEN'
                || '        INSERT (tax'
                || j.tax_cd
                || ',policy_id, comm_amt)'
                || '        VALUES (subq.tax_amt,subq.policy_id, subq.comm_amt)'
               );
            COMMIT;
         END LOOP;

         -- other charges
         MERGE INTO gipi_prod_ext gpp
            USING (SELECT   SUM (NVL (giv.other_charges * giv.currency_rt, 0)
                                ) other_charges,
                            giv.policy_id policy_id,
                            gipis200_pkg.get_comm_amt
                                                   (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id,
                                                    p_month,
                                                    p_year
                                                   ) comm_amt,
                            gpp.user_id                     --jason 10/17/2008
                       FROM gipi_invoice giv, gipi_prod_ext gpp
                      WHERE 1 = 1
                        AND giv.policy_id = gpp.policy_id
                        AND gpp.user_id = p_user
                        AND NVL (giv.takeup_seq_no, 1) =
                                                      NVL (p_takeup_seq_no, 1)
                        AND giv.item_grp = p_item_grp
                        AND giv.policy_id = p_policy_id
                   GROUP BY giv.policy_id,
                            gipis200_pkg.get_comm_amt (giv.prem_seq_no,
                                                       giv.iss_cd,
                                                       p_param_date,
                                                       p_from_date,
                                                       p_to_date,
                                                       p_policy_id,
                                                       p_month,
                                                       p_year
                                                      ),
                            gpp.user_id) goc
            ON (goc.policy_id = gpp.policy_id AND goc.user_id = gpp.user_id)
            WHEN MATCHED THEN
               UPDATE
                  SET gpp.other_charges =
                                goc.other_charges + NVL (gpp.other_charges, 0),
                      gpp.comm_amt = goc.comm_amt
            WHEN NOT MATCHED THEN
               INSERT (other_charges, policy_id, comm_amt)
               VALUES (goc.other_charges, goc.policy_id, goc.comm_amt);
         COMMIT;
      --**jason 07/31/2008 end**--
      END IF;
   END;                                             --end procedure pol_taxes2

   FUNCTION get_comm_amt (
      p_prem_seq_no   NUMBER,
      p_iss_cd        VARCHAR2,
      p_param_date    NUMBER,
      p_from_date     DATE,
      p_to_date       DATE,
      p_policy_id     NUMBER,
      p_month         gipi_polbasic.booking_mth%TYPE,
      p_year          gipi_polbasic.booking_year%TYPE
   )
      RETURN NUMBER
   IS
      v_commission        NUMBER (20, 2);
      v_commission_amt    NUMBER (20, 2);
      v_commission_amt1   NUMBER (20, 2) := 0;    -- added by jeremy 11302010
      v_comm_amt          NUMBER (20, 2);
      v_comm_tot          NUMBER (20, 2) := 0;
      found_flag          NUMBER (1)     := 0;    -- added by jeremy 11302010
   BEGIN
      DBMS_OUTPUT.put_line ('1 ' || v_comm_tot);

      FOR rc IN
         (SELECT         -- b.intrmdry_intm_no,  commented by jeremy 11302010
                   b.iss_cd, b.prem_seq_no, SUM (c.ri_comm_amt) ri_comm_amt,
                   c.currency_rt, SUM (b.commission_amt) commission_amt,
                   
                   --SUM(DECODE(c.ri_comm_amt * c.currency_rt,0,NVL(b.commission_amt * c.currency_rt,0),c.ri_comm_amt * c.currency_rt)) comm_amt
                   a.issue_date, a.eff_date, c.acct_ent_date,
                   a.spld_acct_ent_date, c.multi_booking_mm,
                   c.multi_booking_yy, a.cancel_date,
                   a.endt_seq_no                -- added adrel09032009 pnbgen
              FROM gipi_comm_invoice b, gipi_invoice c, gipi_polbasic a
             WHERE b.iss_cd = c.iss_cd
               AND a.policy_id = b.policy_id
               AND a.policy_id = p_policy_id
               AND b.prem_seq_no = c.prem_seq_no
               AND gipis200_pkg.check_date_prod_policy (p_param_date,
                                                        p_from_date,
                                                        p_to_date,
                                                        p_month,
                                                        p_year,
                                                        a.issue_date,
                                                        a.eff_date,
                                                        --gpd.acct_ent_date, --aaron 010609
                                                        c.acct_ent_date,
                                                        --glyza
                                                        a.spld_acct_ent_date,
                                                        --gp.booking_mth,
                                                        --gp.booking_year,
                                                        c.multi_booking_mm,
                                                        --glyza
                                                        c.multi_booking_yy
                                                       ) = 1
          -- to consider if policies only or endts only
          GROUP BY b.iss_cd,
                   b.prem_seq_no,
                   c.currency_rt,
                   a.issue_date,
                   a.eff_date,
                   c.acct_ent_date,
                   a.spld_acct_ent_date,
                   c.multi_booking_mm,
                   c.multi_booking_yy,
                   a.cancel_date,
                   a.endt_seq_no)
      LOOP
         v_commission := 0;

         IF (rc.ri_comm_amt * rc.currency_rt) = 0
         THEN
            DBMS_OUTPUT.put_line ('x');
            v_commission_amt := rc.commission_amt;

            IF gipis200_pkg.check_date_prod_policy (p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_month,
                                                    p_year,
                                                    rc.issue_date,
                                                    rc.eff_date,
                                                    rc.acct_ent_date,
                                                    rc.spld_acct_ent_date,
                                                    rc.multi_booking_mm,
                                                    rc.multi_booking_yy
                                                   ) = 1
            THEN                             -- ADREL 09032009 ADDED CONDITION
               FOR c1 IN
                  (SELECT commission_amt
                     FROM giac_prev_comm_inv
                    WHERE      /*fund_cd = v_fund_cd
                          AND branch_cd = v_branch_cd --jason 11/9/2007: comment out as instructed by Ms Juday
                          AND*/ comm_rec_id =
                             (SELECT MIN (comm_rec_id)
-- modified to retrieve amt in prev comm (included giac_new_comm_inv loop in where clause here)  adrel090309
                              FROM   giac_new_comm_inv n, gipi_invoice i
                               WHERE n.iss_cd = i.iss_cd
                                 AND n.prem_seq_no = i.prem_seq_no
                                 AND n.iss_cd = rc.iss_cd
                                 AND n.prem_seq_no = rc.prem_seq_no
                                 AND n.tran_flag = 'P'
                                 AND NVL (n.delete_sw, 'N') = 'N'
                                 --AND n.intm_no = rc.intrmdry_intm_no commented by jeremy 11302010 for records wherein intm was changed thru modify comm
                                 AND n.acct_ent_date >= i.acct_ent_date)
                      -- judyann 10082009; modification is done after take-up of policy
                               --  AND intm_no = rc.intrmdry_intm_no commented by jeremy 11302010
                      AND acct_ent_date BETWEEN p_from_date AND p_to_date)
               -- judyann 10082009; policy is booked within the given period
               LOOP
                  /* commented by jeremy 11302010
                  v_commission_amt := c1.commission_amt;
                  EXIT;
                  */
                  -- replaced by statements below
                  -- start
                  found_flag := 1;
                  v_commission_amt1 := v_commission_amt1 + c1.commission_amt;
               -- end jeremy 11302010
               END LOOP;
            END IF;

            -- END CHECKING IF P_Uwreports.Check_Date_Policy = 1  -- ADREL 09032009

            -- v_comm_amt := NVL(v_commission_amt * rc.currency_rt,0); commented by jeremy 11302010
            -- replaced by statements below
            -- start jeremy 11302010
            IF found_flag = 1
            THEN
               /* found_flag 1 means bill has been modified and taken up comm amount will be extracted and not the new commission */
               v_comm_amt := NVL (v_commission_amt1 * rc.currency_rt, 0);
            ELSE
               /* meaning commission amount in gipi_comm_invoice will be extracted */
               v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
            END IF;
         -- end jeremy 11302010
         ELSE
            v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
         END IF;

         v_commission := NVL (v_commission, 0) + v_comm_amt;
         v_comm_tot := v_comm_tot + v_commission;
      END LOOP;

      RETURN (v_comm_tot);
   --commision amount is zero if the for loop statement is not executed
   --RETURN 0;
   END get_comm_amt;
   
-- added by gab 11.03.2016
   PROCEDURE pol_taxes3 (
      p_item_grp             gipi_invoice.item_grp%TYPE,
      p_takeup_seq_no        gipi_invoice.takeup_seq_no%TYPE,
      p_policy_id            gipi_invoice.policy_id%TYPE,
      p_param_date      IN   NUMBER,
      p_from_date       IN   DATE,
      p_to_date         IN   DATE,
      p_user            IN   VARCHAR2,
      p_month                gipi_polbasic.booking_mth%TYPE,
      p_year                 gipi_polbasic.booking_year%TYPE,
      p_evat                 giac_parameters.param_value_v%TYPE,
      p_prem_tax             giac_parameters.param_value_v%TYPE,
      p_fst                  giac_parameters.param_value_v%TYPE,
      p_lgt                  giac_parameters.param_value_v%TYPE,
      p_doc_stamps           giac_parameters.param_value_v%TYPE,
      p_layout               NUMBER
   )
   IS
      
      v_evat            NUMBER(12,2) := 0;
      v_fst             NUMBER(12,2) := 0;
      v_lgt             NUMBER(12,2) := 0;
      v_doc_stamps      NUMBER(12,2) := 0;
      v_other_charges   NUMBER(12,2) := 0;
      v_other_taxes     NUMBER(12,2) := 0;
      v_prem_seq_no     gipi_invoice.prem_seq_no%TYPE;
      v_iss_cd          gipi_invoice.iss_cd%TYPE;
      v_policy_id       gipi_polbasic.policy_id%TYPE;
      v_exist           VARCHAR2(1) := 0;
      
   BEGIN
        FOR i IN (SELECT  giv.policy_id, 
                DECODE(git.tax_cd,p_prem_tax,NVL (git.tax_amt * giv.currency_rt, 0),p_evat,NVL (git.tax_amt * giv.currency_rt, 0),0) evat,
                DECODE(git.tax_cd,p_fst,NVL (git.tax_amt * giv.currency_rt, 0),0) fst, 
                DECODE(git.tax_cd,p_lgt,NVL (git.tax_amt * giv.currency_rt, 0),0) lgt,
                DECODE(git.tax_cd,p_doc_stamps,NVL (git.tax_amt * giv.currency_rt, 0),0) doc_stamps,
                DECODE(git.tax_cd,p_prem_tax,0,p_evat,0,p_fst,0,p_lgt,0,p_doc_stamps,0,NVL (git.tax_amt * giv.currency_rt, 0)) other_charges,
                NVL (giv.other_charges * giv.currency_rt, 0)other_taxes,
                        git.tax_cd, giv.prem_seq_no, giv.iss_cd
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_prod_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND NVL (giv.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1)
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = p_user
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
                GROUP BY giv.policy_id, git.tax_amt, giv.currency_rt,git.tax_cd,giv.other_charges, giv.prem_seq_no, giv.iss_cd)
                
        LOOP
            v_evat := i.evat + v_evat;
            v_fst := i.fst + v_fst;
            v_lgt := i.lgt + v_lgt;
            v_doc_stamps := i.doc_stamps + v_doc_stamps;
            v_other_charges := i.other_charges + v_other_charges;
            v_other_taxes  := i.other_taxes + v_other_taxes;
            v_prem_seq_no := i.prem_seq_no;
            v_iss_cd := i.iss_cd;
            v_policy_id := i.policy_id;
        
        END LOOP;
     
        UPDATE gipi_prod_ext
           SET evatprem = v_evat,
               comm_amt = gipis200_pkg.get_comm_amt (v_prem_seq_no,v_iss_cd,p_param_date,p_from_date,p_to_date,p_policy_id,p_month, p_year),
               fst = v_fst,
               lgt = v_lgt,
               doc_stamps = v_doc_stamps,
               other_charges = v_other_charges,
               other_taxes = v_other_taxes
         WHERE policy_id = p_policy_id;
                     
      
   
   
      IF p_layout = 2
      THEN
         FOR j IN (SELECT a.tax_cd
                     FROM gipi_inv_tax a, gipi_invoice b
                    WHERE a.prem_seq_no = b.prem_seq_no
                      AND a.iss_cd = b.iss_cd
                      AND b.policy_id = p_policy_id
                      AND b.item_grp = p_item_grp
                      AND NVL (b.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1))
         LOOP
            DBMS_OUTPUT.put_line (   j.tax_cd
                                  || '/'
                                  || p_takeup_seq_no
                                  || '/'
                                  || p_item_grp
                                  || '/'
                                  || p_policy_id
                                 );
            do_ddl
               (   'MERGE INTO GIPI_PROD_EXT gpp USING'
                || '   (SELECT SUM(NVL(git.tax_amt,0) * NVL(giv.currency_rt,0)) tax_amt,'
                || '           giv.policy_id, giv.prem_seq_no, giv.iss_cd '
                || '          ,gpp.user_id'
                || '      FROM GIPI_INV_TAX git,'
                || '           GIPI_INVOICE giv,'
                || '           GIPI_PROD_EXT gpp'
                || '     WHERE giv.iss_cd       = git.iss_cd'
                || '       AND giv.prem_seq_no  = git.prem_seq_no'
                || '       AND git.tax_cd       >= 0'
                || '       AND giv.item_grp     = git.item_grp'
                || '       AND giv.policy_id    = gpp.policy_id'
                || '       AND gpp.user_id      = p_user'
                || '       AND git.tax_cd       = '
                || j.tax_cd
                || '       AND NVL(giv.takeup_seq_no,1)  = '
                || NVL (p_takeup_seq_no, 1)
                || '       AND giv.item_grp    = '
                || p_item_grp
                || '       AND giv.policy_id = '
                || p_policy_id
                || '     GROUP BY giv.policy_id, giv.prem_seq_no, giv.iss_cd '
                || ',gpp.user_id) subq'
                || '        ON (subq.policy_id = gpp.policy_id '
                || '            AND subq.user_id = gpp.user_id )'
                || '      WHEN MATCHED THEN UPDATE'
                || '        SET gpp.tax'
                || j.tax_cd
                || ' = subq.tax_amt + NVL(gpp.tax'
                || j.tax_cd
                || ',0)'
                || '           ,gpp.comm_amt = GIPIS200_PKG.get_comm_amt(subq.prem_seq_no, subq.iss_cd, '
                || p_param_date
                || ', '''
                || p_from_date
                || ''', '''
                || p_to_date
                || ''', '
                || p_policy_id
                || ')'
                || '      WHEN NOT MATCHED THEN'
                || '        INSERT (tax'
                || j.tax_cd
                || ',policy_id, comm_amt)'
                || '        VALUES (subq.tax_amt,subq.policy_id, GIPIS200_PKG.get_comm_amt(subq.prem_seq_no, subq.iss_cd, '
                || p_param_date
                || ', '''
                || p_from_date
                || ''', '''
                || p_to_date
                || ''', '
                || p_policy_id
                || '))'
               );
         END LOOP;
         COMMIT;
      END IF;
   END;
END gipis200_pkg;
/


