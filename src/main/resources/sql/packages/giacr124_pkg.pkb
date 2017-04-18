CREATE OR REPLACE PACKAGE BODY CPI.giacr124_pkg
AS
   FUNCTION get_giacr124_dtls (
      p_from_date    DATE,
      p_to_date      DATE,
      p_iss_cd       giis_issource.iss_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_toggle       VARCHAR2,
      p_user         giis_users.user_id%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE
   )
      RETURN giacr124_dtls_tab PIPELINED
   AS
      v_list   giacr124_dtls_type;
   BEGIN
      v_list.report_title := 'DISTRIBUTION REGISTER PER LINE SUBLINE';
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

      BEGIN
         IF p_toggle = 'A'
         THEN
            v_list.cf_toggle := 'Policies and Endorsements';
         ELSIF p_toggle = 'P'
         THEN
            v_list.cf_toggle := 'Policies Only';
         ELSIF p_toggle = 'E'
         THEN
            v_list.cf_toggle := 'Endorsements Only';
         ELSE
            v_list.cf_toggle := 'Unknown toggle value';
         END IF;
      END;

      FOR i IN (SELECT   b.line_name "LINE_NAME", c.subline_cd "SUBLINE_CD",
                         COUNT (DISTINCT a.policy_no) "POLICIES",
                         SUM (DECODE (a.peril_type,
                                      'A', 0,
                                      NVL ((a.nr_dist_tsi * a.currency_rt), 0)
                                     )
                             ) "NET_RET_TSI",
                         SUM (NVL ((a.nr_dist_prem * a.currency_rt), 0)
                             ) "NET_RET_PREM",
                         SUM (DECODE (a.peril_type,
                                      'A', 0,
                                      NVL ((a.tr_dist_tsi * a.currency_rt), 0)
                                     )
                             ) "TREATY_TSI",
                         SUM (NVL ((a.tr_dist_prem * a.currency_rt), 0)
                             ) "TREATY_PREM",
                         SUM
                            (DECODE (a.peril_type,
                                     'A', 0,
                                     NVL ((a.fa_dist_tsi * a.currency_rt), 0)
                                    )
                            ) "FACULTATIVE_TSI",
                         SUM (NVL ((a.fa_dist_prem * a.currency_rt), 0)
                             ) "FACULTATIVE_PREM",
                           SUM (DECODE (a.peril_type,
                                        'A', 0,
                                        NVL ((a.nr_dist_tsi * a.currency_rt),
                                             0
                                            )
                                       )
                               )
                         + SUM (DECODE (a.peril_type,
                                        'A', 0,
                                        NVL ((a.tr_dist_tsi * a.currency_rt),
                                             0
                                            )
                                       )
                               )
                         + SUM (DECODE (a.peril_type,
                                        'A', 0,
                                        NVL ((a.fa_dist_tsi * a.currency_rt),
                                             0
                                            )
                                       )
                               ) "TOTAL_TSI",
                           SUM (NVL ((a.nr_dist_prem * a.currency_rt), 0)
                               )
                         + SUM (NVL ((a.tr_dist_prem * a.currency_rt), 0))
                         + SUM (NVL ((a.fa_dist_prem * a.currency_rt), 0))
                                                              "TOTAL_PREMIUM",
                         a.acct_ent_date, a.line_cd
                    FROM giac_prodrep_peril_ext a, giis_line b,
                         giis_subline c
                   WHERE a.line_cd = b.line_cd
                     AND a.subline_cd = c.subline_cd
                     AND a.line_cd = c.line_cd
                     AND a.user_id = p_user
                     AND a.iss_cd = NVL (UPPER (p_iss_cd), a.iss_cd)
                     AND a.line_cd = NVL (UPPER (p_line_cd), a.line_cd)
                     AND a.subline_cd =
                                      NVL (UPPER (p_subline_cd), a.subline_cd)
                     AND (   (p_toggle = 'A' AND a.endt_seq_no = a.endt_seq_no
                             )
                          OR (p_toggle = 'P' AND a.endt_seq_no = 0)
                          OR (p_toggle = 'E' AND a.endt_seq_no > 0)
                         )
                GROUP BY a.acct_ent_date, b.line_name, c.subline_cd,
                         a.line_cd
                ORDER BY b.line_name)
      LOOP
         v_list.acct_ent_date := i.acct_ent_date;
         v_list.line_name := i.line_name;
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
         PIPE ROW (v_list);
      END LOOP;

      PIPE ROW (v_list);
      RETURN;
   END get_giacr124_dtls;
END;
/


