CREATE OR REPLACE PACKAGE BODY CPI.giacr262_pkg
AS
   FUNCTION get_giacr262_dtls (
      p_from_date    DATE,
      p_to_date      DATE,
      p_iss_cd       giis_issource.iss_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_user         giis_users.user_id%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE
   )
      RETURN giacr262_dtls_tab PIPELINED
   AS
      v_list   giacr262_dtls_type;
   BEGIN
      v_list.report_title :=
                       'DISTRIBUTION REGISTER OF NEGATED POLICIES (DETAILED)';
      v_list.report_date_title :=
            'From '
         || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
         || ' To '
         || TO_CHAR (p_to_date, 'fmMonth DD, YYYY');

      BEGIN
         SELECT DISTINCT param_value_v
                    INTO v_list.cf_co_name
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME';
      END;

      v_list.cf_co_address := giisp.v ('COMPANY_ADDRESS');

      FOR i IN (SELECT   d.line_name, c.subline_name, a.iss_cd, a.line_cd,
                         a.subline_cd, get_policy_no (a.policy_id) policy_no,
                         SUM (NVL (a.nr_dist_tsi, 0) * a.currency_rt
                             ) "NET_RET_TSI",
                         SUM (NVL (a.nr_dist_prem, 0) * a.currency_rt
                             ) "NET_RET_PREM",
                         SUM (NVL (a.tr_dist_tsi, 0) * a.currency_rt
                             ) "TREATY_TSI",
                         SUM (NVL (a.tr_dist_prem, 0) * a.currency_rt
                             ) "TREATY_PREM",
                         SUM (NVL (a.fa_dist_tsi, 0) * a.currency_rt
                             ) "FACULTATIVE_TSI",
                         SUM (NVL (a.fa_dist_prem, 0) * a.currency_rt
                             ) "FACULTATIVE_PREM",
                           SUM (NVL (a.nr_dist_tsi, 0) * a.currency_rt
                               )
                         + SUM (NVL (a.tr_dist_tsi, 0) * a.currency_rt)
                         + SUM (NVL (a.fa_dist_tsi, 0) * a.currency_rt)
                                                                  "TOTAL_TSI",
                           SUM ((NVL (a.nr_dist_prem, 0) * a.currency_rt)
                               )
                         + SUM ((NVL (a.tr_dist_prem, 0) * a.currency_rt))
                         + SUM ((NVL (a.fa_dist_prem, 0) * a.currency_rt))
                                                              "TOTAL_PREMIUM"
                    FROM gipi_polbasic b,
                         giac_prodrep_dist_ext a,
                         giis_subline c,
                         giis_line d
                   WHERE a.policy_id = b.policy_id
                     AND a.acct_neg_date BETWEEN p_from_date AND p_to_date
                     AND a.line_cd = d.line_cd
                     AND a.line_cd = c.line_cd
                     AND a.subline_cd = c.subline_cd
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.user_id = p_user
                GROUP BY d.line_name,
                         c.subline_name,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         get_policy_no (a.policy_id)
                UNION ALL
                SELECT   d.line_name, c.subline_name, a.cred_branch iss_cd,
                         a.line_cd, a.subline_cd,
                         get_policy_no (a.policy_id) policy_no,
                         SUM (NVL (a.nr_dist_tsi, 0) * a.currency_rt
                             ) "NET_RET_TSI",
                         SUM (NVL (a.nr_dist_prem, 0) * a.currency_rt
                             ) "NET_RET_PREM",
                         SUM (NVL (a.tr_dist_tsi, 0) * a.currency_rt
                             ) "TREATY_TSI",
                         SUM (NVL (a.tr_dist_prem, 0) * a.currency_rt
                             ) "TREATY_PREM",
                         SUM (NVL (a.fa_dist_tsi, 0) * a.currency_rt
                             ) "FACULTATIVE_TSI",
                         SUM (NVL (a.fa_dist_prem, 0) * a.currency_rt
                             ) "FACULTATIVE_PREM",
                           SUM (NVL (a.nr_dist_tsi, 0) * a.currency_rt
                               )
                         + SUM (NVL (a.tr_dist_tsi, 0) * a.currency_rt)
                         + SUM (NVL (a.fa_dist_tsi, 0) * a.currency_rt)
                                                                  "TOTAL_TSI",
                           SUM ((NVL (a.nr_dist_prem, 0) * a.currency_rt)
                               )
                         + SUM ((NVL (a.tr_dist_prem, 0) * a.currency_rt))
                         + SUM ((NVL (a.fa_dist_prem, 0) * a.currency_rt))
                                                              "TOTAL_PREMIUM"
                    FROM gipi_polbasic b,
                         giac_prodrep_dist_ext a,
                         giis_subline c,
                         giis_line d
                   WHERE a.policy_id = b.policy_id
                     AND a.acct_neg_date BETWEEN p_from_date AND p_to_date
                     AND a.pol_spld_acct_ent_date IS NULL
                     AND a.line_cd = d.line_cd
                     AND a.line_cd = c.line_cd
                     AND a.subline_cd = c.subline_cd
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.cred_branch = NVL (p_iss_cd, a.cred_branch)
                     AND a.user_id = p_user
                GROUP BY d.line_name,
                         c.subline_name,
                         a.cred_branch,
                         a.line_cd,
                         a.subline_cd,
                         get_policy_no (a.policy_id))
      LOOP
         v_list.line_name := i.line_name;
         v_list.subline_name := i.subline_name;
         v_list.subline_cd := i.subline_cd;
         v_list.policy_no := i.policy_no;
         v_list.net_ret_tsi := i.net_ret_tsi;
         v_list.net_ret_prem := i.net_ret_prem;
         v_list.treaty_tsi := i.treaty_tsi;
         v_list.treaty_prem := i.treaty_prem;
         v_list.facultative_tsi := i.facultative_tsi;
         v_list.facultative_prem := i.facultative_prem;
         v_list.total_tsi := i.total_tsi;
         v_list.total_prem := i.total_premium;
         v_list.line_cd := i.line_cd;
         v_list.iss_cd := i.iss_cd;
      END LOOP;

      PIPE ROW (v_list);
      RETURN;
   END get_giacr262_dtls;
END;
/


