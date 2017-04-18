CREATE OR REPLACE PACKAGE BODY CPI.giacr246_pkg
AS
   FUNCTION get_giacr246_dtls (
      p_from_date    DATE,
      p_to_date      DATE,
      p_iss_cd       giis_issource.iss_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_user         giis_users.user_id%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE
   )
      RETURN giacr246_dtls_tab PIPELINED
   AS
      v_list   giacr246_dtls_type;
   BEGIN
      v_list.report_title :=
                     'DISTRIBUTION REGISTER OF ALL POLICIES PER LINE SUBLINE';
      v_list.report_date_title :=
            'From '
         || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
         || ' To '
         || TO_CHAR (p_to_date, 'fmMonth DD, YYYY');
      v_list.cf_co_address := giisp.v ('COMPANY_ADDRESS');

      BEGIN
         SELECT DISTINCT param_value_v
                    INTO v_list.cf_co_name
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME';
      END;

      FOR i IN (SELECT   b.line_name "LINE_NAME",
                         c.subline_name "SUBLINE_NAME", a.iss_cd, a.line_cd,
                         a.subline_cd, COUNT (DISTINCT a.policy_no)
                                                                   "POLICIES",
                         SUM (DECODE (a.share_type,
                                      '1', NVL (a.nr_dist_tsi, 0)
                                       * a.currency_rt,
                                      0
                                     )
                             ) "NET_RET_TSI",
                         SUM (NVL (a.nr_dist_prem, 0) * a.currency_rt
                             ) "NET_RET_PREM",
                         SUM (DECODE (a.share_type,
                                      '2', NVL (a.tr_dist_tsi, 0)
                                       * a.currency_rt,
                                      0
                                     )
                             ) "TREATY_TSI",
                         SUM (NVL (a.tr_dist_prem, 0) * a.currency_rt
                             ) "TREATY_PREM",
                         SUM (DECODE (a.share_type,
                                      '3', NVL (a.fa_dist_tsi, 0)
                                       * a.currency_rt,
                                      0
                                     )
                             ) "FACULTATIVE_TSI",
                         SUM (NVL (a.fa_dist_prem, 0) * a.currency_rt
                             ) "FACULTATIVE_PREM",
                           SUM (DECODE (a.share_type,
                                        '1', NVL (a.nr_dist_tsi, 0)
                                         * a.currency_rt,
                                        0
                                       )
                               )
                         + SUM (DECODE (a.share_type,
                                        '2', NVL (a.tr_dist_tsi, 0)
                                         * a.currency_rt,
                                        0
                                       )
                               )
                         + SUM (DECODE (a.share_type,
                                        '3', NVL (a.fa_dist_tsi, 0)
                                         * a.currency_rt,
                                        0
                                       )
                               ) "TOTAL_TSI",
                           SUM (NVL (a.nr_dist_prem, 0) * a.currency_rt
                               )
                         + SUM (NVL (a.tr_dist_prem, 0) * a.currency_rt)
                         + SUM (NVL (a.fa_dist_prem, 0) * a.currency_rt)
                                                              "TOTAL_PREMIUM"
                    FROM giac_prodrep_dist_ext a, giis_line b, giis_subline c
                   WHERE a.line_cd = b.line_cd
                     AND a.subline_cd = c.subline_cd
                     AND a.line_cd = c.line_cd
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.user_id = p_user
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                GROUP BY b.line_name,
                         c.subline_name,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd
                UNION ALL
                SELECT   b.line_name "LINE_NAME",
                         c.subline_name "SUBLINE_NAME", a.cred_branch iss_cd,
                         a.line_cd, a.subline_cd,
                         COUNT (DISTINCT a.policy_no) "POLICIES",
                         SUM (DECODE (a.share_type,
                                      '1', NVL (a.nr_dist_tsi, 0)
                                       * a.currency_rt,
                                      0
                                     )
                             ) "NET_RET_TSI",
                         SUM (NVL (a.nr_dist_prem, 0) * a.currency_rt
                             ) "NET_RET_PREM",
                         SUM (DECODE (a.share_type,
                                      '2', NVL (a.tr_dist_tsi, 0)
                                       * a.currency_rt,
                                      0
                                     )
                             ) "TREATY_TSI",
                         SUM (NVL (a.tr_dist_prem, 0) * a.currency_rt
                             ) "TREATY_PREM",
                         SUM (DECODE (a.share_type,
                                      '3', NVL (a.fa_dist_tsi, 0)
                                       * a.currency_rt,
                                      0
                                     )
                             ) "FACULTATIVE_TSI",
                         SUM (NVL (a.fa_dist_prem, 0) * a.currency_rt
                             ) "FACULTATIVE_PREM",
                           SUM (DECODE (a.share_type,
                                        '1', NVL (a.nr_dist_tsi, 0)
                                         * a.currency_rt,
                                        0
                                       )
                               )
                         + SUM (DECODE (a.share_type,
                                        '2', NVL (a.tr_dist_tsi, 0)
                                         * a.currency_rt,
                                        0
                                       )
                               )
                         + SUM (DECODE (a.share_type,
                                        '3', NVL (a.fa_dist_tsi, 0)
                                         * a.currency_rt,
                                        0
                                       )
                               ) "TOTAL_TSI",
                           SUM (NVL (a.nr_dist_prem, 0) * a.currency_rt
                               )
                         + SUM (NVL (a.tr_dist_prem, 0) * a.currency_rt)
                         + SUM (NVL (a.fa_dist_prem, 0) * a.currency_rt)
                                                              "TOTAL_PREMIUM"
                    FROM giac_prodrep_dist_ext a, giis_line b, giis_subline c
                   WHERE a.line_cd = b.line_cd
                     AND a.subline_cd = c.subline_cd
                     AND a.line_cd = c.line_cd
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.cred_branch = NVL (p_iss_cd, a.cred_branch)
                     AND a.user_id = p_user
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                GROUP BY b.line_name,
                         c.subline_name,
                         a.cred_branch,
                         a.line_cd,
                         a.subline_cd)
      LOOP
         v_list.line_name := i.line_name;
         v_list.subline_name := i.subline_name;
         v_list.subline_cd := i.subline_cd;
         v_list.policies := i.policies;
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
         PIPE ROW (v_list);
      END LOOP;

      PIPE ROW (v_list);
      RETURN;
   END get_giacr246_dtls;
END;
/


