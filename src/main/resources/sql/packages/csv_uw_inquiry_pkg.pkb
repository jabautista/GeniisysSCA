CREATE OR REPLACE PACKAGE BODY cpi.csv_uw_inquiry_pkg
AS
   FUNCTION get_giuwr130 (
      p_dist_flag   giuw_pol_dist.dist_no%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giuwr130_csv_tab PIPELINED
   IS
      v_rec       giuwr130_csv_type;
      v_status1   VARCHAR2 (50);
      v_status2   VARCHAR2 (50);
      v_status3   VARCHAR2 (50);
      v_exist     VARCHAR2 (1);
   BEGIN
      FOR i IN
         (SELECT   a.policy_id,
                      a.line_cd
                   || ' - '
                   || a.subline_cd
                   || ' - '
                   || a.iss_cd
                   || ' -'
                   || TO_CHAR (a.issue_yy, '09')
                   || ' -'
                   || TO_CHAR (a.pol_seq_no, '0999999')
                   || ' -'
                   || TO_CHAR (a.renew_no, '09') policy_no,
                   DECODE (a.endt_seq_no,
                           0, '',
                              a.endt_iss_cd
                           || ' -'
                           || TO_CHAR (a.endt_yy, '09')
                           || ' -'
                           || TO_CHAR (a.endt_seq_no, '0999999')
                          ) endt_no,
                   a.line_cd, a.subline_cd, a.iss_cd,
                   NVL (a.endt_expiry_date,
                        a.expiry_date_polbas
                       ) policy_expiry_date,
                   a.eff_date_polbas policy_eff_date,
                   a.eff_date distribution_eff_date,
                   a.expiry_date_poldist distribution_expiry_date,
                   a.dist_flag, b.share_cd, NVL (b.dist_tsi, 0) dist_tsi,
                   NVL (b.dist_prem, 0) dist_prem,
                   NVL (b.dist_spct, 0) dist_spct, b.dist_spct1 dist_spct1,
                   TO_CHAR (a.dist_no, '0999999') dist_no,
                   TO_CHAR (b.dist_seq_no, '0999999') dist_seq_no, c.tsi_amt,
                   c.prem_amt, d.trty_name, g.currency_desc,
                   e.currency_rt currency_rt
              FROM giuw_pol_dist_polbasic_v a LEFT JOIN giuw_wpolicyds_policyds_dtl_v b
                   ON a.dist_no = b.dist_no
                   LEFT JOIN giuw_wpolicyds_policyds_v c
                   ON a.dist_no = c.dist_no AND b.dist_seq_no = c.dist_seq_no
                   LEFT JOIN giis_dist_share d
                   ON a.line_cd = d.line_cd AND b.share_cd = d.share_cd
                   LEFT JOIN gipi_invoice e
                   ON a.policy_id = e.policy_id AND e.item_grp = c.item_grp
                   LEFT JOIN giis_currency g
                   ON e.currency_cd = g.main_currency_cd
             WHERE 1 = 1
               AND (a.line_cd, a.iss_cd) IN (
                      SELECT line_cd, branch_cd
                        FROM TABLE
                                 (security_access.get_branch_line ('UW',
                                                                   'GIPIS130',
                                                                   p_user_id
                                                                  )
                                 ))
               AND (   p_dist_flag = 1 AND a.dist_flag = '1'
                    OR (p_dist_flag = 2 AND a.dist_flag = '2')
                    OR (p_dist_flag = 3 AND a.dist_flag = '3')
                    OR (p_dist_flag = 4 AND a.dist_flag = '4')
                    OR (p_dist_flag = 5 AND a.dist_flag = '5')
                    OR (p_dist_flag = 6 AND a.dist_flag IN (1, 2))
                    OR (    p_dist_flag = 7
                        AND a.dist_flag = '3'
                        AND NOT EXISTS (
                               SELECT dist_no
                                 FROM giri_distfrps
                                WHERE dist_no = a.dist_no
                                  AND line_cd = a.line_cd)
                       )
                    OR (    p_dist_flag = 8
                        AND a.dist_flag = '3'
                        AND EXISTS (
                               SELECT dist_no
                                 FROM giri_distfrps
                                WHERE dist_no = a.dist_no
                                  AND line_cd = a.line_cd)
                       )
                    OR (p_dist_flag = 9 AND a.dist_flag = a.dist_flag)
                   )
          ORDER BY    a.line_cd
                   || ' - '
                   || RPAD (a.subline_cd, 4)
                   || ' - '
                   || a.iss_cd
                   || ' -'
                   || TO_CHAR (a.issue_yy, '09')
                   || ' -'
                   || TO_CHAR (a.pol_seq_no, '0999999')
                   || ' -'
                   || TO_CHAR (a.renew_no, '09'),
                   endt_no,
                   dist_no,
                   a.eff_date,
                   dist_seq_no,
                   b.share_cd)
      LOOP
         DECLARE
            v_switch   VARCHAR2 (1) := 'N';
         BEGIN
            IF i.dist_flag = '1'
            THEN
               v_rec.status := 'Undistributed w/o Facultative';
            ELSIF i.dist_flag = '2'
            THEN
               v_rec.status := 'Undistributed w/ Facultative';
            ELSIF i.dist_flag = '3'
            THEN
               FOR a IN (SELECT DISTINCT share_cd
                                    FROM giuw_policyds_dtl
                                   WHERE line_cd = i.line_cd
                                     AND dist_no = i.dist_no
                                ORDER BY share_cd ASC)
               LOOP
                  IF a.share_cd = 999
                  THEN
                     v_rec.status := 'D w/ Facultative';
                  ELSE
                     v_rec.status := 'D w/o Facultative';
                  END IF;

                  v_switch := 'Y';
               END LOOP;

               IF v_switch = 'N'
               THEN
                  FOR endt IN (SELECT endt_tax
                                 FROM gipi_endttext
                                WHERE policy_id = i.policy_id)
                  LOOP
                     IF endt.endt_tax = 'Y'
                     THEN
                        v_rec.status := 'U w/o Facultative';
                     END IF;
                  END LOOP;
               END IF;
            ELSIF i.dist_flag = '4'
            THEN
               v_rec.status := 'Negated';
            ELSE
               v_rec.status := 'Redistributed';
            END IF;
         END;

         v_rec.policy_no := i.policy_no;
         v_rec.endt_no := i.endt_no;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.policy_eff_date := TO_CHAR (i.policy_eff_date, 'MM/DD/YYYY');
         v_rec.distribution_eff_date :=
                                 TO_CHAR (i.distribution_eff_date, 'MM/DD/YYYY');
         v_rec.policy_expiry_date :=
                                    TO_CHAR (i.policy_expiry_date, 'MM/DD/YYYY');
         v_rec.distribution_expiry_date :=
                              TO_CHAR (i.distribution_expiry_date, 'MM/DD/YYYY');
         v_rec.dist_no := i.dist_no;
         v_rec.dist_seq_no := i.dist_seq_no;
         v_rec.sum_insured := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.currency := i.currency_desc;
         v_rec.currency_rate := i.currency_rt;
         v_rec.distribution_share := i.trty_name;
         v_rec.tsi_share_pct := i.dist_spct;
         v_rec.dist_tsi_amt := i.dist_tsi;
         v_rec.prem_share_pct := i.dist_spct1;
         v_rec.dist_prem_amt := i.dist_prem;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_giuwr130;
END;
/