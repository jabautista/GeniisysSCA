CREATE OR REPLACE PACKAGE BODY CPI.giacr106_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 06.08.2013
   **  Reference By : GIACR106- Schedule of Due to RI Facultative report
   **  Description  :
   */
   FUNCTION get_giacr106_records_old ( --mikel 11.23.2015; UCPBGEN 20878; backup old function
      p_ri_cd       giri_binder.ri_cd%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_date_type   VARCHAR2,
      p_date_from   DATE,
      p_date_to     DATE,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr106_records_tab PIPELINED
   IS
      v_rec         giacr106_records_type;
      v_not_exist   BOOLEAN               := TRUE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_rec.cf_company
           FROM giis_parameters
          WHERE UPPER (param_name) = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_rec.cf_company_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_company_address := NULL;
      END;

      IF p_date_type = '1'
      THEN
         v_rec.cf_basis := 'Based on Effectivity Date';
      ELSIF p_date_type = '2'
      THEN
         v_rec.cf_basis := 'Based on Binder Date';
      ELSIF p_date_type = '3'
      THEN
         v_rec.cf_basis := 'Based on Accounting Entry Date';
      ELSIF p_date_type = '4'
      THEN
         v_rec.cf_basis := 'Based on Booking Date';
      END IF;

      v_rec.cf_from_date := TO_CHAR (p_date_from, 'FMMonth DD, YYYY');
      v_rec.cf_to_date := TO_CHAR (p_date_to, 'FMMonth DD, YYYY');

      FOR i IN
         (
-- JHING 06/02/2011 select statements for positive records
--Note dummy2 is a field that is used by the report to distinguish between reversal and non-reversal records when the result set of this query is joined with the result set of the Q_2 query for the computation of balances
--frps_seq_no and frps_yy are also retrieved as field list, this allows the report to display reused binders in multiple frps/distribution group
          SELECT b.ri_name, c.line_name, a.eff_date eff_date,
                    a.line_cd
                 || '-'
                 || a.binder_yy
                 || '-'
                 || TO_CHAR (a.binder_seq_no, 'FM09999') binder,
                 
                 --added to_char for leading zero

                 /* commented out by reymon 06182012
                  ** used get policy function for leading zeros
                 DECODE (
                    d.endt_seq_no,
                    0, (   d.line_cd || '-'  || d.subline_cd  || '-' || d.iss_cd || '-'  || d.issue_yy   || '-'  || d.pol_seq_no || '-' || d.renew_no),
                        (   d.line_cd|| '-'  || d.subline_cd  || '-' || d.iss_cd || '-'  || d.issue_yy   || '-'  || d.pol_seq_no || '-'  || d.renew_no   || '-'  || d.endt_iss_cd || '-'  || d.endt_yy  || '-'  || d.endt_seq_no)) policy_no,
                      */
                 get_policy_no (d.policy_id) policy_no, d.policy_id,
                 e.assd_name assured,
                 NVL (a.ri_tsi_amt, 0) * NVL (g.currency_rt, 0) amt_insured,
                 NVL (a.ri_prem_amt, 0) * NVL (g.currency_rt, 0) prem,
                 NVL (a.ri_comm_amt, 0) * NVL (g.currency_rt, 0) comm,
                   (  (NVL (a.ri_prem_amt, 0) + NVL (a.ri_prem_vat, 0))
                    - (NVL (a.ri_comm_amt, 0) + NVL (a.ri_comm_vat, 0))
                   )
                 * NVL (g.currency_rt, 0) net_prem,
                 a.fnl_binder_id binder_id, a.replaced_flag,
                 NVL (a.ri_prem_vat, 0) * NVL (g.currency_rt, 0) ri_prem_vat,
                 NVL (a.ri_comm_vat, 0) * NVL (g.currency_rt, 0) ri_comm_vat,
                   NVL (a.ri_wholding_vat, 0)
                 * NVL (g.currency_rt, 0) ri_wholding_vat,
                 1 dummy2, f.frps_yy, f.frps_seq_no,
                 --TRUNC (a.binder_date) + NVL (f.prem_warr_days, 0) ppw, --Commented out by Dren 03192015
                 TRUNC (a.eff_date) + NVL (f.prem_warr_days, 0) ppw --Added by Dren 03192015
            -- added by Jayson 11.14.2011
          FROM   giri_binder a,
                 giis_reinsurer b,
                 giis_line c,
                 gipi_polbasic d,
                 giis_assured e,
                 giri_frps_ri f,
                 giri_distfrps g,
                 giuw_policyds h,
                 giuw_pol_dist i,
                 gipi_parlist j
           WHERE a.ri_cd = NVL (p_ri_cd, a.ri_cd)
             AND a.line_cd = NVL (p_line_cd, a.line_cd)
             AND DECODE (p_date_type,
                         '1', TRUNC (a.eff_date),
                         '2', TRUNC (a.binder_date),
                         '3', TRUNC (a.acc_ent_date),
                         '4', LAST_DAY (TO_DATE (   d.booking_mth
                                                 || ','
                                                 || TO_CHAR (d.booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to
             AND a.ri_cd = b.ri_cd
             AND a.line_cd = c.line_cd
             AND a.fnl_binder_id = f.fnl_binder_id
             AND f.frps_yy = g.frps_yy
             AND f.frps_seq_no = g.frps_seq_no
             AND f.line_cd = g.line_cd
             AND g.dist_no = h.dist_no
             AND g.dist_seq_no = h.dist_seq_no
             AND h.dist_no = i.dist_no
             AND i.par_id = j.par_id
             AND j.assd_no = e.assd_no
             AND i.policy_id = d.policy_id
             AND d.pol_flag <> '5'
             AND check_user_per_iss_cd_acctg2 (NULL,
                                               d.iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1    -- Udel 03192013 @SEICI
             AND (   (    p_date_type = '3'
                      AND (   TRUNC (i.acct_ent_date) BETWEEN p_date_from
                                                          AND p_date_to
                           OR NVL (TRUNC (i.acct_neg_date), p_date_to + 1)
                                 BETWEEN p_date_from
                                     AND p_date_to
                          )
                     )
                  OR p_date_type <> '3'
                 )
             AND DECODE
                    (i.dist_flag,
                     '4', DECODE
                        (UPPER (NVL (f.reverse_sw, 'N')),
                         'N', DECODE
                            (UPPER (NVL (a.replaced_flag, 'N')),
                             'Y', 1,
                             (CASE
                                 WHEN NVL (TRUNC (a.acc_rev_date),
                                           p_date_to + 1
                                          ) BETWEEN p_date_from AND p_date_to
                                    THEN 1
                                 ELSE 0
                              END
                             )
                            ),
                         1
                        ),
                     '5', DECODE
                        (UPPER (NVL (f.reverse_sw, 'N')),
                         'N', DECODE
                            (UPPER (NVL (a.replaced_flag, 'N')),
                             'Y', 1,
                             (CASE
                                 WHEN NVL (TRUNC (a.acc_rev_date),
                                           p_date_to + 1
                                          ) BETWEEN p_date_from AND p_date_to
                                    THEN 1
                                 ELSE 0
                              END
                             )
                            ),
                         1
                        ),
                     1
                    ) = 1
          UNION
          --Jhing (Jennifer) 06/02/2011 reversal for negated distribution
          SELECT b.ri_name, c.line_name, a.eff_date eff_date,
                    a.line_cd
                 || '-'
                 || a.binder_yy
                 || '-'
                 || TO_CHAR (a.binder_seq_no, 'FM09999') binder,
                 
                 --added to_char for leading zero

                 /* commented out by reymon 06182012
                  ** used get policy function for leading zeros
                 DECODE (
                    d.endt_seq_no,
                    0, (   d.line_cd || '-'  || d.subline_cd  || '-' || d.iss_cd || '-'  || d.issue_yy   || '-'  || d.pol_seq_no || '-' || d.renew_no),
                        (   d.line_cd|| '-'  || d.subline_cd  || '-' || d.iss_cd || '-'  || d.issue_yy   || '-'  || d.pol_seq_no || '-'  || d.renew_no   || '-'  || d.endt_iss_cd || '-'  || d.endt_yy  || '-'  || d.endt_seq_no)) policy_no,
                      */
                 get_policy_no (d.policy_id) policy_no, d.policy_id,
                 e.assd_name assured,
                   NVL (a.ri_tsi_amt, 0)
                 * NVL (g.currency_rt, 0)
                 * -1 amt_insured,
                 NVL (a.ri_prem_amt, 0) * NVL (g.currency_rt, 0) * -1 prem,
                 NVL (a.ri_comm_amt, 0) * NVL (g.currency_rt, 0) * -1 comm,
                   (  (NVL (a.ri_prem_amt, 0) + NVL (a.ri_prem_vat, 0))
                    - (NVL (a.ri_comm_amt, 0) + NVL (a.ri_comm_vat, 0))
                   )
                 * NVL (g.currency_rt, 0)
                 * -1 net_prem,
                 a.fnl_binder_id binder_id, a.replaced_flag,
                   NVL (a.ri_prem_vat, 0)
                 * NVL (g.currency_rt, 0)
                 * -1 ri_prem_vat,
                   NVL (a.ri_comm_vat, 0)
                 * NVL (g.currency_rt, 0)
                 * -1 ri_comm_vat,
                   NVL (a.ri_wholding_vat, 0)
                 * NVL (g.currency_rt, 0)
                 * -1 ri_wholding_vat,
                 2 dummy2, f.frps_yy, f.frps_seq_no,
                 --TRUNC (a.binder_date) + NVL (f.prem_warr_days, 0) ppw, --Commented out by Dren 03192015
                 TRUNC (a.eff_date) + NVL (f.prem_warr_days, 0) ppw --Added by Dren 03192015
            -- added by Jayson 11.14.2011
          FROM   giri_binder a,
                 giis_reinsurer b,
                 giis_line c,
                 gipi_polbasic d,
                 giis_assured e,
                 giri_frps_ri f,
                 giri_distfrps g,
                 giuw_policyds h,
                 giuw_pol_dist i,
                 gipi_parlist j
           WHERE a.ri_cd = NVL (p_ri_cd, a.ri_cd)
             AND a.line_cd = NVL (p_line_cd, a.line_cd)
             AND a.ri_cd = b.ri_cd
             AND a.line_cd = c.line_cd
             AND a.fnl_binder_id = f.fnl_binder_id
             AND f.frps_yy = g.frps_yy
             AND f.frps_seq_no = g.frps_seq_no
             AND f.line_cd = g.line_cd
             AND g.dist_no = h.dist_no
             AND g.dist_seq_no = h.dist_seq_no
             AND h.dist_no = i.dist_no
             AND i.par_id = j.par_id
             AND j.assd_no = e.assd_no
             AND i.policy_id = d.policy_id
             AND d.pol_flag <> '5'
             AND i.dist_flag IN ('4', '5')
             AND check_user_per_iss_cd_acctg2 (NULL,
                                               d.iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1    -- Udel 03192013 @SEICI
             AND NVL (TRUNC (i.acct_neg_date), p_date_to + 1)
                    BETWEEN p_date_from
                        AND p_date_to
             AND (   TRUNC (a.acc_rev_date) BETWEEN p_date_from AND p_date_to
                  OR NVL (UPPER (a.replaced_flag), 'X') = 'Y'
                 )
          UNION
          -- jhing 06/02/2011 reversal for non-negated distribution
          SELECT b.ri_name, c.line_name, a.eff_date eff_date,
                    a.line_cd
                 || '-'
                 || a.binder_yy
                 || '-'
                 || TO_CHAR (a.binder_seq_no, 'FM09999') binder,
                 
                 --added to_char for leading zero

                 /* commented out by reymon 06182012
                  ** used get policy function for leading zeros
                 DECODE (
                    d.endt_seq_no,
                    0, (   d.line_cd || '-'  || d.subline_cd  || '-' || d.iss_cd || '-'  || d.issue_yy   || '-'  || d.pol_seq_no || '-' || d.renew_no),
                        (   d.line_cd|| '-'  || d.subline_cd  || '-' || d.iss_cd || '-'  || d.issue_yy   || '-'  || d.pol_seq_no || '-'  || d.renew_no   || '-'  || d.endt_iss_cd || '-'  || d.endt_yy  || '-'  || d.endt_seq_no)) policy_no,
                      */
                 get_policy_no (d.policy_id) policy_no, d.policy_id,
                 e.assd_name assured,
                   NVL (a.ri_tsi_amt, 0)
                 * NVL (g.currency_rt, 0)
                 * -1 amt_insured,
                 NVL (a.ri_prem_amt, 0) * NVL (g.currency_rt, 0) * -1 prem,
                 NVL (a.ri_comm_amt, 0) * NVL (g.currency_rt, 0) * -1 comm,
                   (  (NVL (a.ri_prem_amt, 0) + NVL (a.ri_prem_vat, 0))
                    - (NVL (a.ri_comm_amt, 0) + NVL (a.ri_comm_vat, 0))
                   )
                 * NVL (g.currency_rt, 0)
                 * -1 net_prem,
                 a.fnl_binder_id binder_id, a.replaced_flag,
                   NVL (a.ri_prem_vat, 0)
                 * NVL (g.currency_rt, 0)
                 * -1 ri_prem_vat,
                   NVL (a.ri_comm_vat, 0)
                 * NVL (g.currency_rt, 0)
                 * -1 ri_comm_vat,
                   NVL (a.ri_wholding_vat, 0)
                 * NVL (g.currency_rt, 0)
                 * -1 ri_wholding_vat,
                 3 dummy2, f.frps_yy, f.frps_seq_no,
                 --TRUNC (a.binder_date) + NVL (f.prem_warr_days, 0) ppw, --Commented out by Dren 03192015
                 TRUNC (a.eff_date) + NVL (f.prem_warr_days, 0) ppw --Added by Dren 03192015
            -- added by Jayson 11.14.2011
          FROM   giri_binder a,
                 giis_reinsurer b,
                 giis_line c,
                 gipi_polbasic d,
                 giis_assured e,
                 giri_frps_ri f,
                 giri_distfrps g,
                 giuw_policyds h,
                 giuw_pol_dist i,
                 gipi_parlist j
           WHERE a.ri_cd = NVL (p_ri_cd, a.ri_cd)
             AND a.line_cd = NVL (p_line_cd, a.line_cd)
             AND a.ri_cd = b.ri_cd
             AND a.line_cd = c.line_cd
             AND a.fnl_binder_id = f.fnl_binder_id
             AND f.frps_yy = g.frps_yy
             AND f.frps_seq_no = g.frps_seq_no
             AND f.line_cd = g.line_cd
             AND g.dist_no = h.dist_no
             AND g.dist_seq_no = h.dist_seq_no
             AND h.dist_no = i.dist_no
             AND i.par_id = j.par_id
             AND j.assd_no = e.assd_no
             AND i.policy_id = d.policy_id
             AND d.pol_flag <> '5'
             AND i.dist_flag NOT IN ('4', '5')
             AND NVL (UPPER (f.reverse_sw), 'X') = 'Y'
             AND check_user_per_iss_cd_acctg2 (NULL,
                                               d.iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1    -- Udel 03192013 @SEICI
             AND DECODE (p_date_type,
                         '1', TRUNC (a.eff_date),
                         '2', TRUNC (a.binder_date),
                         '3', TRUNC (a.acc_ent_date),
                         '4', LAST_DAY (TO_DATE (   d.booking_mth
                                                 || ','
                                                 || TO_CHAR (d.booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to
             AND (   (    p_date_type = '3'
                      AND TRUNC (i.acct_ent_date) BETWEEN p_date_from
                                                      AND p_date_to
                     )
                  OR p_date_type <> '3'
                 ))
      LOOP
         v_not_exist := FALSE;
         v_rec.ri_name := i.ri_name;
         v_rec.line_name := i.line_name;
         v_rec.eff_date := i.eff_date;
         v_rec.binder := i.binder;
         v_rec.policy_no := i.policy_no;
         v_rec.policy_id := i.policy_id;
         v_rec.assured := i.assured;
         v_rec.amt_insured := i.amt_insured;
         v_rec.prem := i.prem;
         v_rec.comm := i.comm;
         v_rec.net_prem := i.net_prem;
         v_rec.binder_id := i.binder_id;
         v_rec.replaced_flag := i.replaced_flag;
         v_rec.ri_prem_vat := i.ri_prem_vat;
         v_rec.ri_comm_vat := i.ri_comm_vat;
         v_rec.ri_wholding_vat := i.ri_wholding_vat;
         v_rec.dummy2 := i.dummy2;
         v_rec.frps_yy := i.frps_yy;
         v_rec.frps_seq_no := i.frps_seq_no;
         v_rec.ppw := i.ppw;

         FOR c1 IN (SELECT intrmdry_intm_no
                      FROM gipi_comm_invoice b
                     WHERE b.policy_id = i.policy_id)
         LOOP
            v_rec.intrmdry_intm_no := c1.intrmdry_intm_no;
         END LOOP;

         v_rec.cf_net_prem :=
              (NVL (i.prem, 0) + NVL (i.ri_prem_vat, 0))
            - ((  NVL (i.comm, 0)
                + NVL (i.ri_comm_vat, 0)
                + NVL (i.ri_wholding_vat, 0)
               )
              );
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         PIPE ROW (v_rec);
      END IF;
   END;
   
   --mikel 11.23.2015; UCPBGEN 20878; replaced old function
   FUNCTION get_giacr106_records_old_v2 (                    -- jhing 02.01.2016 backup of old function GENQA 5270
      p_ri_cd       giri_binder.ri_cd%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_date_type   VARCHAR2,
      p_date_from   DATE,
      p_date_to     DATE,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr106_records_tab PIPELINED
   IS
      v_rec         giacr106_records_type;
      v_not_exist   BOOLEAN               := TRUE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_rec.cf_company
           FROM giis_parameters
          WHERE UPPER (param_name) = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_rec.cf_company_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_company_address := NULL;
      END;

      IF p_date_type = '1'
      THEN
         v_rec.cf_basis := 'Based on Effectivity Date';
      ELSIF p_date_type = '2'
      THEN
         v_rec.cf_basis := 'Based on Binder Date';
      ELSIF p_date_type = '3'
      THEN
         v_rec.cf_basis := 'Based on Accounting Entry Date';
      ELSIF p_date_type = '4'
      THEN
         v_rec.cf_basis := 'Based on Booking Date';
      END IF;

      v_rec.cf_from_date := TO_CHAR (p_date_from, 'FMMonth DD, YYYY');
      v_rec.cf_to_date := TO_CHAR (p_date_to, 'FMMonth DD, YYYY');

      FOR i IN
      --mikel 11.23.2015; UCPBGEN 20878, replaced old query
         (SELECT k.ri_name,
               i.line_name,
               c.eff_date,
               get_binder_no (b.fnl_binder_id) binder,
               get_policy_no (g.policy_id) policy_no,
               g.policy_id,
               m.assd_name assured,
               NVL (c.ri_tsi_amt, 0) * NVL (d.currency_rt, 0) amt_insured,
               NVL (c.ri_prem_amt, 0) * NVL (d.currency_rt, 0) prem,
               NVL (c.ri_comm_amt, 0) * NVL (d.currency_rt, 0) comm,
                 (  (NVL (c.ri_prem_amt, 0) + NVL (c.ri_prem_vat, 0))
                  - (NVL (c.ri_comm_amt, 0) + NVL (c.ri_comm_vat, 0)))
               * NVL (d.currency_rt, 0)
                  net_prem,
               c.fnl_binder_id binder_id,
               c.replaced_flag,
               NVL (c.ri_prem_vat, 0) * NVL (d.currency_rt, 0) ri_prem_vat,
               NVL (c.ri_comm_vat, 0) * NVL (d.currency_rt, 0) ri_comm_vat,
               NVL (c.ri_wholding_vat, 0) * NVL (d.currency_rt, 0) ri_wholding_vat,
               1 dummy2,
               b.frps_yy,
               b.frps_seq_no,
               TRUNC (c.eff_date) + NVL (b.prem_warr_days, 0) ppw
          FROM giri_frps_ri b,
               giri_binder c,
               giri_distfrps d,
               giuw_policyds e,
               giuw_pol_dist f,
               gipi_polbasic g,
               giis_line i,
               giis_subline j,
               giis_reinsurer k,
               gipi_parlist l,
               giis_assured m
         WHERE     1 = 1
               AND c.ri_cd = NVL (p_ri_cd, c.ri_cd)         -- marco - 12.18.2015 
               AND c.line_cd = NVL(p_line_cd, c.line_cd)    -- GENQA 5208
               AND c.ri_cd = k.ri_cd
               AND b.fnl_binder_id = c.fnl_binder_id
               AND b.line_cd = d.line_cd
               AND b.frps_yy = d.frps_yy
               AND b.frps_seq_no = d.frps_seq_no
               AND d.dist_no = e.dist_no
               AND d.dist_seq_no = e.dist_seq_no
               AND e.dist_no = f.dist_no
               AND f.policy_id = g.policy_id
               AND f.par_id = l.par_id
               AND l.assd_no = m.assd_no
               AND ((p_date_type = '3'
                   AND g.acct_ent_date IS NOT NULL
                   AND LAST_DAY (g.acct_ent_date) <= LAST_DAY (p_date_to)
                   AND LAST_DAY (TRUNC (f.acct_ent_date)) <= LAST_DAY (p_date_to))
                   OR p_date_type != '3'
                   )
               AND DECODE (p_date_type,
                         '1', TRUNC (c.eff_date),
                         '2', TRUNC (c.binder_date),
                         '3', TRUNC (c.acc_ent_date),
                         '4', LAST_DAY (TO_DATE (   g.booking_mth
                                                 || ','
                                                 || TO_CHAR (g.booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to
               AND EXISTS (SELECT 'X'
                             FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                            WHERE branch_cd = g.iss_cd)                                        
               AND g.line_cd = i.line_cd
               AND g.line_cd = j.line_cd
               AND g.subline_cd = j.subline_cd
               AND g.reg_policy_sw = 'Y'
        UNION
        SELECT k.ri_name,
               i.line_name,
               c.eff_date,
               get_binder_no (b.fnl_binder_id) binder,
               get_policy_no (g.policy_id) policy_no,
               g.policy_id,
               m.assd_name assured,
               NVL (c.ri_tsi_amt, 0) * NVL (d.currency_rt, 0) * -1 amt_insured,
               NVL (c.ri_prem_amt, 0) * NVL (d.currency_rt, 0) * -1 prem,
               NVL (c.ri_comm_amt, 0) * NVL (d.currency_rt, 0) * -1 comm,
                 (  (NVL (c.ri_prem_amt, 0) + NVL (c.ri_prem_vat, 0))
                  - (NVL (c.ri_comm_amt, 0) + NVL (c.ri_comm_vat, 0)))
               * NVL (d.currency_rt, 0)
               * -1
                  net_prem,
               c.fnl_binder_id binder_id,
               c.replaced_flag,
               NVL (c.ri_prem_vat, 0) * NVL (d.currency_rt, 0) * -1 ri_prem_vat,
               NVL (c.ri_comm_vat, 0) * NVL (d.currency_rt, 0) * -1 ri_comm_vat,
               NVL (c.ri_wholding_vat, 0) * NVL (d.currency_rt, 0) * -1
                  ri_wholding_vat,
               1 dummy2,
               b.frps_yy,
               b.frps_seq_no,
               TRUNC (c.eff_date) + NVL (b.prem_warr_days, 0) ppw
          FROM giri_frps_ri b,
               giri_binder c,
               giri_distfrps d,
               giuw_policyds e,
               giuw_pol_dist f,
               gipi_polbasic g,
               giis_line i,
               giis_subline j,
               giis_reinsurer k,
               gipi_parlist l,
               giis_assured m
         WHERE     1 = 1
               AND c.ri_cd = NVL (p_ri_cd, c.ri_cd)         -- marco - 12.18.2015
               AND c.line_cd = NVL(p_line_cd, c.line_cd)    -- GENQA 5208
               AND c.ri_cd = k.ri_cd
               AND b.fnl_binder_id = c.fnl_binder_id
               AND b.line_cd = d.line_cd
               AND b.frps_yy = d.frps_yy
               AND b.frps_seq_no = d.frps_seq_no
               AND d.dist_no = e.dist_no
               AND d.dist_seq_no = e.dist_seq_no
               AND e.dist_no = f.dist_no
               AND f.policy_id = g.policy_id
               AND f.par_id = l.par_id
               AND l.assd_no = m.assd_no
               AND ((p_date_type = '3'
               AND g.acct_ent_date IS NOT NULL
               AND LAST_DAY (g.acct_ent_date) <= LAST_DAY (p_date_to)
               AND (   (    f.dist_flag = '4'
                        AND LAST_DAY (TRUNC (f.acct_neg_date)) <=
                               LAST_DAY (p_date_to))           --negated distribution
                    OR (b.reverse_sw = 'Y')                          --reversed binder
                    OR f.dist_flag = '5'                               --redistributed
                                        ))
                    OR p_date_type != '3'
                   )
               AND DECODE (p_date_type,
                         '1', TRUNC (c.eff_date),
                         '2', TRUNC (c.binder_date),
                         '3', TRUNC (c.acc_rev_date),
                         '4', LAST_DAY (TO_DATE (   g.booking_mth
                                                 || ','
                                                 || TO_CHAR (g.booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to 
               AND EXISTS (SELECT 'X'
                             FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                            WHERE branch_cd = g.iss_cd)                                           
               AND g.line_cd = i.line_cd
               AND g.line_cd = j.line_cd
               AND g.subline_cd = j.subline_cd
               AND g.reg_policy_sw = 'Y')
      LOOP
         v_not_exist := FALSE;
         v_rec.ri_name := i.ri_name;
         v_rec.line_name := i.line_name;
         v_rec.eff_date := i.eff_date;
         v_rec.binder := i.binder;
         v_rec.policy_no := i.policy_no;
         v_rec.policy_id := i.policy_id;
         v_rec.assured := i.assured;
         v_rec.amt_insured := i.amt_insured;
         v_rec.prem := i.prem;
         v_rec.comm := i.comm;
         v_rec.net_prem := i.net_prem;
         v_rec.binder_id := i.binder_id;
         v_rec.replaced_flag := i.replaced_flag;
         v_rec.ri_prem_vat := i.ri_prem_vat;
         v_rec.ri_comm_vat := i.ri_comm_vat;
         v_rec.ri_wholding_vat := i.ri_wholding_vat;
         v_rec.dummy2 := i.dummy2;
         v_rec.frps_yy := i.frps_yy;
         v_rec.frps_seq_no := i.frps_seq_no;
         v_rec.ppw := i.ppw;

         FOR c1 IN (SELECT intrmdry_intm_no
                      FROM gipi_comm_invoice b
                     WHERE b.policy_id = i.policy_id)
         LOOP
            v_rec.intrmdry_intm_no := c1.intrmdry_intm_no;
         END LOOP;

         v_rec.cf_net_prem :=
              (NVL (i.prem, 0) + NVL (i.ri_prem_vat, 0))
            - ((  NVL (i.comm, 0)
                + NVL (i.ri_comm_vat, 0)
                + NVL (i.ri_wholding_vat, 0)
               )
              );
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         PIPE ROW (v_rec);
      END IF;
   END;
   
   
   
   --jhing GENQA 5270 - new function 
   FUNCTION get_giacr106_records (p_ri_cd        giri_binder.ri_cd%TYPE,
                                   p_line_cd      giri_binder.line_cd%TYPE,
                                   p_date_type    VARCHAR2,
                                   p_date_from    DATE,
                                   p_date_to      DATE,
                                   p_module_id    VARCHAR2,
                                   p_user_id      VARCHAR2)
       RETURN giacr106_records_tab
       PIPELINED
    IS
       v_rec           giacr106_records_type;
       v_not_exist     BOOLEAN := TRUE;
       v_total_payt    NUMBER (20, 2);
       v_balance_due   NUMBER (20, 2);
       v_payt_exists   BOOLEAN;
       v_cnt_payt      NUMBER;
    BEGIN
       BEGIN
          SELECT param_value_v
            INTO v_rec.cf_company
            FROM giis_parameters
           WHERE UPPER (param_name) = 'COMPANY_NAME';
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_rec.cf_company := NULL;
       END;

       BEGIN
          SELECT param_value_v
            INTO v_rec.cf_company_address
            FROM giis_parameters
           WHERE param_name = 'COMPANY_ADDRESS';
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_rec.cf_company_address := NULL;
       END;

       IF p_date_type = '1'
       THEN
          v_rec.cf_basis := 'Based on Effectivity Date';
       ELSIF p_date_type = '2'
       THEN
          v_rec.cf_basis := 'Based on Binder Date';
       ELSIF p_date_type = '3'
       THEN
          v_rec.cf_basis := 'Based on Accounting Entry Date';
       ELSIF p_date_type = '4'
       THEN
          v_rec.cf_basis := 'Based on Booking Date';
       END IF;

       v_rec.cf_from_date := TO_CHAR (p_date_from, 'FMMonth DD, YYYY');
       v_rec.cf_to_date := TO_CHAR (p_date_to, 'FMMonth DD, YYYY');

       FOR i
          IN (  SELECT *
                  FROM (SELECT k.ri_cd,k.ri_name,
                               i.line_cd,i.line_name,
                               c.eff_date,
                               get_binder_no (b.fnl_binder_id) binder,
                               get_policy_no (g.policy_id) policy_no,
                               g.policy_id,
                               m.assd_name assured,
                               ROUND(NVL (c.ri_tsi_amt, 0) * NVL (d.currency_rt, 0),2)
                                  amt_insured,
                               ROUND(NVL (c.ri_prem_amt, 0) * NVL (d.currency_rt, 0),2)  prem,
                               ROUND(NVL (c.ri_comm_amt, 0) * NVL (d.currency_rt, 0),2) comm,
                                 (  (  NVL (c.ri_prem_amt, 0)
                                     + NVL (c.ri_prem_vat, 0))
                                  - (  NVL (c.ri_comm_amt, 0)
                                     + NVL (c.ri_comm_vat, 0)))
                               * NVL (d.currency_rt, 0)
                                  net_prem,
                               c.fnl_binder_id binder_id,
                               c.replaced_flag,
                               ROUND(NVL (c.ri_prem_vat, 0) * NVL (d.currency_rt, 0),2)
                                  ri_prem_vat,
                               ROUND(NVL (c.ri_comm_vat, 0) * NVL (d.currency_rt, 0),2)
                                  ri_comm_vat,
                               ROUND(NVL (c.ri_wholding_vat, 0) * NVL (d.currency_rt, 0),2)
                                  ri_wholding_vat,
                               1 constant,
                               b.frps_yy,
                               b.frps_seq_no,
                               TRUNC (c.eff_date) + NVL (b.prem_warr_days, 0) ppw
                          FROM giri_frps_ri b,
                               giri_binder c,
                               giri_distfrps d,
                               giuw_policyds e,
                               giuw_pol_dist f,
                               gipi_polbasic g,
                               giis_line i,
                               giis_subline j,
                               giis_reinsurer k,
                               gipi_parlist l,
                               giis_assured m
                         WHERE     1 = 1
                               AND c.ri_cd = NVL (p_ri_cd, c.ri_cd) -- added by robert 01.05.2016
                               AND c.line_cd = NVL (p_line_cd, c.line_cd) -- added by robert 01.05.2016
                               AND c.ri_cd = k.ri_cd
                               AND b.fnl_binder_id = c.fnl_binder_id
                               AND b.line_cd = d.line_cd
                               AND b.frps_yy = d.frps_yy
                               AND b.frps_seq_no = d.frps_seq_no
                               AND d.dist_no = e.dist_no
                               AND d.dist_seq_no = e.dist_seq_no
                               AND e.dist_no = f.dist_no
                               AND f.policy_id = g.policy_id
                               AND f.par_id = l.par_id
                               AND l.assd_no = m.assd_no
                               AND (   (    p_date_type = '3'
                                        AND g.acct_ent_date IS NOT NULL
                                        AND LAST_DAY (g.acct_ent_date) <=
                                               LAST_DAY (p_date_to)
                                        AND LAST_DAY (TRUNC (f.acct_ent_date)) <=
                                               LAST_DAY (p_date_to))
                                    OR p_date_type != '3')
                               AND DECODE (
                                      p_date_type,
                                      '1', TRUNC (c.eff_date),
                                      '2', TRUNC (c.binder_date),
                                      '3', TRUNC (c.acc_ent_date),
                                      '4', LAST_DAY (
                                              TO_DATE (
                                                    g.booking_mth
                                                 || ','
                                                 || TO_CHAR (g.booking_year),
                                                 'FMMONTH,YYYY'))) BETWEEN p_date_from
                                                                       AND p_date_to
                               AND EXISTS
                                      (SELECT 'X'
                                         FROM TABLE (
                                                 security_access.get_branch_line (
                                                    'AC',
                                                    p_module_id,
                                                    p_user_id))
                                        WHERE branch_cd = g.iss_cd)
                               AND g.line_cd = i.line_cd
                               AND g.line_cd = j.line_cd
                               AND g.subline_cd = j.subline_cd
                               AND g.reg_policy_sw = 'Y'
                               -- jhing 01.08.2016  include condition to retrieve valid binders only ( if parameter is not accounting entry date to prevent duplicate display of reused binder)
                               AND (   DECODE (p_date_type, 3, 1, 0) = 1
                                    OR f.dist_flag = '3')
                               AND (   DECODE (p_date_type, 3, 1, 0) = 1
                                    OR (    NVL (b.reverse_sw, 'N') = 'N'
                                        AND c.reverse_date IS NULL
                                        AND d.ri_flag = '2'))
                               -- jhing 01.08.2016 added condition to prevent duplicate display of reused binders
                               AND (   p_date_type != '3'
                                    OR (NVL (
                                           (  SELECT COUNT (1)
                                                FROM giri_frps_ri tg
                                               WHERE tg.fnl_binder_id =
                                                        c.fnl_binder_id
                                            GROUP BY tg.fnl_binder_id),
                                           0) < 2)
                                    OR (    (TRUNC (
                                                NVL (c.acc_ent_date,
                                                     p_date_to + 60)) BETWEEN p_date_from
                                                                          AND p_date_to)
                                        AND f.dist_no IN
                                               (SELECT MIN (tc.dist_no)
                                                  FROM giri_distfrps tc,
                                                       giri_frps_ri td,
                                                       giuw_pol_dist tf
                                                 WHERE     tc.line_cd = td.line_cd
                                                       AND tc.frps_yy = td.frps_yy
                                                       AND tc.frps_seq_no =
                                                              td.frps_seq_no
                                                       AND td.fnl_binder_id =
                                                              c.fnl_binder_id
                                                       AND tc.dist_no = tf.dist_no
                                                       AND LAST_DAY (
                                                              TRUNC (
                                                                 tf.acct_ent_date)) <=
                                                              LAST_DAY (p_date_to))
                                        AND (NVL (
                                                (  SELECT COUNT (1)
                                                     FROM giri_frps_ri tg
                                                    WHERE tg.fnl_binder_id =
                                                             c.fnl_binder_id
                                                 GROUP BY tg.fnl_binder_id),
                                                0) > 1)))
                        UNION
                        SELECT k.ri_cd, k.ri_name,
                               i.line_cd,i.line_name,
                               c.eff_date,
                               get_binder_no (b.fnl_binder_id) binder,
                               get_policy_no (g.policy_id) policy_no,
                               g.policy_id,
                               m.assd_name assured,
                               ROUND(NVL (c.ri_tsi_amt, 0) * NVL (d.currency_rt, 0),2)  * -1
                                  amt_insured,
                               ROUND(NVL (c.ri_prem_amt, 0) * NVL (d.currency_rt, 0) ,2) * -1
                                  prem,
                               ROUND(NVL (c.ri_comm_amt, 0) * NVL (d.currency_rt, 0) ,2 ) * -1
                                  comm,
                                 (  (  NVL (c.ri_prem_amt, 0)
                                     + NVL (c.ri_prem_vat, 0))
                                  - (  NVL (c.ri_comm_amt, 0)
                                     + NVL (c.ri_comm_vat, 0)))
                               * NVL (d.currency_rt, 0)
                               * -1
                                  net_prem,
                               c.fnl_binder_id binder_id,
                               c.replaced_flag,
                               ROUND(NVL (c.ri_prem_vat, 0) * NVL (d.currency_rt, 0),2) * -1
                                  ri_prem_vat,
                               ROUND(NVL (c.ri_comm_vat, 0) * NVL (d.currency_rt, 0) ,2 ) * -1
                                  ri_comm_vat,
                               ROUND(  NVL (c.ri_wholding_vat, 0)
                               * NVL (d.currency_rt, 0) ,2)
                               * -1
                                  ri_wholding_vat,
                               2 constant,
                               b.frps_yy,
                               b.frps_seq_no,
                               TRUNC (c.eff_date) + NVL (b.prem_warr_days, 0) ppw
                          FROM giri_frps_ri b,
                               giri_binder c,
                               giri_distfrps d,
                               giuw_policyds e,
                               giuw_pol_dist f,
                               gipi_polbasic g,
                               giis_line i,
                               giis_subline j,
                               giis_reinsurer k,
                               gipi_parlist l,
                               giis_assured m
                         WHERE     1 = 1
                               AND c.ri_cd = NVL (p_ri_cd, c.ri_cd) -- added by robert 01.05.2016
                               AND c.line_cd = NVL (p_line_cd, c.line_cd) -- added by robert 01.05.2016
                               AND c.ri_cd = k.ri_cd
                               AND b.fnl_binder_id = c.fnl_binder_id
                               AND b.line_cd = d.line_cd
                               AND b.frps_yy = d.frps_yy
                               AND b.frps_seq_no = d.frps_seq_no
                               AND d.dist_no = e.dist_no
                               AND d.dist_seq_no = e.dist_seq_no
                               AND e.dist_no = f.dist_no
                               AND f.policy_id = g.policy_id
                               AND f.par_id = l.par_id
                               AND l.assd_no = m.assd_no
                               AND p_date_type = '3' -- jhing 11.08.2015 added condition to prevent retrieval of records in this query if the parameter is not based on accounting entry date
                               AND (   (    p_date_type = '3'
                                        AND g.acct_ent_date IS NOT NULL
                                        AND LAST_DAY (g.acct_ent_date) <=
                                               LAST_DAY (p_date_to)
                                        AND (   (    f.dist_flag = '4'
                                                 AND LAST_DAY (
                                                        TRUNC (f.acct_neg_date)) <=
                                                        LAST_DAY (p_date_to))
                                             OR (b.reverse_sw = 'Y')
                                             OR f.dist_flag = '5'))
                                    OR p_date_type != '3')
                               AND DECODE (
                                      p_date_type,
                                      '1', TRUNC (c.eff_date),
                                      '2', TRUNC (c.binder_date),
                                      '3', TRUNC (c.acc_rev_date),
                                      '4', LAST_DAY (
                                              TO_DATE (
                                                    g.booking_mth
                                                 || ','
                                                 || TO_CHAR (g.booking_year),
                                                 'FMMONTH,YYYY'))) BETWEEN p_date_from
                                                                       AND p_date_to
                               AND EXISTS
                                      (SELECT 'X'
                                         FROM TABLE (
                                                 security_access.get_branch_line (
                                                    'AC',
                                                    p_module_id,
                                                    p_user_id))
                                        WHERE branch_cd = g.iss_cd)
                               AND g.line_cd = i.line_cd
                               AND g.line_cd = j.line_cd
                               AND g.subline_cd = j.subline_cd
                               AND g.reg_policy_sw = 'Y'
                               -- jhing 01.08.2016 added condition to prevent duplicate display of reused binders
                               AND (   p_date_type != '3'
                                    OR (NVL (
                                           (  SELECT COUNT (1)
                                                FROM giri_frps_ri tg
                                               WHERE tg.fnl_binder_id =
                                                        c.fnl_binder_id
                                            GROUP BY tg.fnl_binder_id),
                                           0) < 2)
                                    OR (    (TRUNC (
                                                NVL (c.acc_rev_date,
                                                     p_date_to + 60)) BETWEEN p_date_from
                                                                          AND p_date_to)
                                        AND f.dist_no IN
                                               (SELECT MAX (tc.dist_no)
                                                  FROM giri_distfrps tc,
                                                       giri_frps_ri td,
                                                       giuw_pol_dist tf
                                                 WHERE     tc.line_cd = td.line_cd
                                                       AND tc.frps_yy = td.frps_yy
                                                       AND tc.frps_seq_no =
                                                              td.frps_seq_no
                                                       AND td.fnl_binder_id =
                                                              c.fnl_binder_id
                                                       AND tc.dist_no = tf.dist_no
                                                       AND LAST_DAY (
                                                              TRUNC (
                                                                 tf.acct_ent_date)) <=
                                                              LAST_DAY (p_date_to))
                                        AND (NVL (
                                                (  SELECT COUNT (1)
                                                     FROM giri_frps_ri tg
                                                    WHERE tg.fnl_binder_id =
                                                             c.fnl_binder_id
                                                 GROUP BY tg.fnl_binder_id),
                                                0) > 1)))) ta001
              ORDER BY ta001.ri_name,ta001.ri_cd, ta001.line_name,ta001.line_cd,ta001.binder_id,ta001.constant)
       LOOP
          v_not_exist := FALSE;
          v_rec.ri_name := i.ri_name;
          v_rec.ri_cd := i.ri_cd;
          v_rec.line_cd := i.line_cd;
          v_rec.line_name := i.line_name;
          v_rec.eff_date := i.eff_date;
          v_rec.binder := i.binder;
          v_rec.policy_no := i.policy_no;
          v_rec.policy_id := i.policy_id;
          v_rec.assured := i.assured;
          v_rec.amt_insured := i.amt_insured;
          v_rec.prem := i.prem;
          v_rec.comm := i.comm;
          v_rec.net_prem := i.net_prem;
          v_rec.binder_id := i.binder_id;
          v_rec.replaced_flag := i.replaced_flag;
          v_rec.ri_prem_vat := i.ri_prem_vat;
          v_rec.ri_comm_vat := i.ri_comm_vat;
          v_rec.ri_wholding_vat := i.ri_wholding_vat;
          v_rec.dummy2 := i.constant;
          v_rec.frps_yy := i.frps_yy;
          v_rec.frps_seq_no := i.frps_seq_no;
          v_rec.ppw := i.ppw;

          v_rec.cf_net_prem :=
               (NVL (i.prem, 0) + NVL (i.ri_prem_vat, 0))
             - ( (  NVL (i.comm, 0)
                  + NVL (i.ri_comm_vat, 0)
                  + NVL (i.ri_wholding_vat, 0)));

          v_rec.intrmdry_intm_no := NULL;

          FOR c1 IN (SELECT intrmdry_intm_no
                       FROM gipi_comm_invoice b
                      WHERE b.policy_id = i.policy_id)
          LOOP
             v_rec.intrmdry_intm_no := c1.intrmdry_intm_no;
          END LOOP;


          v_total_payt := 0;
          v_balance_due := NVL (v_rec.cf_net_prem, 0);
          v_rec.balance_amt := v_balance_due;



          v_rec.ref_date := NULL;
          v_rec.ref_no := NULL;
          v_rec.g_tran_id := NULL;
          v_rec.disb_amt := 0;
          v_rec.tran_class := NULL;
          v_rec.for_tot_amt_insured := i.amt_insured;
          v_rec.for_tot_prem := i.prem;
          v_rec.for_tot_comm := i.comm;
          v_rec.for_tot_net_prem := i.net_prem;
          v_rec.for_tot_ri_prem_vat := i.ri_prem_vat;
          v_rec.for_tot_ri_comm_vat := i.ri_comm_vat;
          v_rec.for_tot_ri_wholding_vat := i.ri_wholding_vat;
          v_rec.for_tot_cf_net_prem := v_rec.cf_net_prem;
          v_rec.for_tot_balance_amt := v_balance_due;

-- PIPE ROW (v_rec);

          IF i.constant = 1
          THEN        -- if the transaction being displayed is the taken up binder
             v_total_payt := 0;
             FOR c1
                IN (SELECT SUM (NVL (a.disbursement_amt, 0)) total_payt
                      FROM giac_outfacul_prem_payts a, giac_acctrans d
                     WHERE     d.tran_flag <> 'D'
                           AND a.gacc_tran_id = d.tran_id
                           AND a.d010_fnl_binder_id = i.binder_id
                           AND NOT EXISTS
                                      (SELECT x.gacc_tran_id
                                         FROM giac_reversals x, giac_acctrans y
                                        WHERE     x.reversing_tran_id = y.tran_id
                                              AND y.tran_flag <> 'D'
                                              AND x.gacc_tran_id = d.tran_id))
             LOOP
                v_total_payt := c1.total_payt;
             END LOOP;

             v_balance_due := NVL(v_balance_due,0) - NVL(v_total_payt,0);
             v_rec.balance_amt := v_balance_due;


                -- get collection payment details
              v_cnt_payt := 0;

                FOR c2
                   IN (SELECT d.tran_id, NVL (a.disbursement_amt, 0) disb_amt
                         FROM giac_outfacul_prem_payts a, giac_acctrans d
                        WHERE     d.tran_flag <> 'D'
                              AND a.gacc_tran_id = d.tran_id
                              AND a.d010_fnl_binder_id = i.binder_id
                              AND NOT EXISTS
                                         (SELECT x.gacc_tran_id
                                            FROM giac_reversals x,
                                                 giac_acctrans y
                                           WHERE     x.reversing_tran_id =
                                                        y.tran_id
                                                 AND y.tran_flag <> 'D'
                                                 AND x.gacc_tran_id = d.tran_id)
                              ORDER BY  d.tran_date, d.tran_id                  )
                LOOP
                   IF v_cnt_payt = 0
                   THEN
                      v_rec.for_tot_amt_insured := NVL(i.amt_insured,0);
                      v_rec.for_tot_prem := i.prem;
                      v_rec.for_tot_comm := i.comm;
                      v_rec.for_tot_net_prem := i.net_prem;
                      v_rec.for_tot_ri_prem_vat := i.ri_prem_vat;
                      v_rec.for_tot_ri_comm_vat := i.ri_comm_vat;
                      v_rec.for_tot_ri_wholding_vat := i.ri_wholding_vat;
                      v_rec.for_tot_cf_net_prem := v_rec.cf_net_prem;
                      v_rec.for_tot_balance_amt := v_balance_due;
                   ELSE
                      v_rec.for_tot_amt_insured := 0;
                      v_rec.for_tot_prem := 0;
                      v_rec.for_tot_comm := 0;
                      v_rec.for_tot_net_prem := 0;
                      v_rec.for_tot_ri_prem_vat := 0;
                      v_rec.for_tot_ri_comm_vat := 0;
                      v_rec.for_tot_ri_wholding_vat := 0;
                      v_rec.for_tot_cf_net_prem := 0;
                      v_rec.for_tot_balance_amt := 0;
                   END IF;

                   v_cnt_payt := v_cnt_payt + 1;
                   v_rec.ref_no := get_ref_no (c2.tran_id);
                   v_rec.ref_date := get_ref_date (c2.tran_id);
                   v_rec.g_tran_id := c2.tran_id;
                   v_rec.disb_amt := c2.disb_amt;

                   PIPE ROW (v_rec);
                END LOOP;
             
             IF  v_cnt_payt = 0 THEN -- if the binder has no payment
                PIPE ROW (v_rec);
                
             END IF;
          ELSE -- if the transaction being displayed is for the reversal/negation of binder
             PIPE ROW (v_rec);
          END IF;
       END LOOP;

--       IF v_not_exist
--       THEN
--          PIPE ROW (v_rec);
--       END IF;
  END;


   FUNCTION get_binder_dtl (
      p_ri_cd           giri_binder.ri_cd%TYPE,
      p_line_cd         giri_binder.line_cd%TYPE,
      p_date_type       VARCHAR2,
      p_date_from       DATE,
      p_date_to         DATE,
      p_binder_id       giri_binder.fnl_binder_id%TYPE,
      p_dummy2          VARCHAR2,
      p_replaced_flag   VARCHAR2,
      p_cf_net_prem     NUMBER
   )
      RETURN binder_dtl_tab PIPELINED
   IS
      v_rec   binder_dtl_type;
   BEGIN
      v_rec.cs_disb_amt := 0;
      FOR binder IN
         (SELECT *
            FROM (SELECT ref_date, ref_no, g_tran_id,
                                                     -- decode(ref_no, 'XXXX', 0, disb_amt) disb_amt,  --  original code commented out by Jhing 05/25/2011, this code makes the balances of the report for records with ref_no = "XXX" and null or "N" replaced flag to be 0
                                                     disb_amt,
                                                              -- jhing 05/25/2011 modified code
                                                              t_class,
                         binder_id, dummy
                    FROM (SELECT b.or_date ref_date,
                                 b.or_pref_suf || ' '
                                 || TO_CHAR (or_no) ref_no,
                                 a.gacc_tran_id g_tran_id,
                                 NVL (a.disbursement_amt, 0) disb_amt,
                                 d.tran_class t_class,
                                 a.d010_fnl_binder_id binder_id, '1' dummy
                            FROM giac_outfacul_prem_payts a,
                                 giac_order_of_payts b,
                                 giac_acctrans d
                           WHERE d.tran_flag <> 'D'
                             AND a.gacc_tran_id = b.gacc_tran_id
                             AND a.gacc_tran_id = d.tran_id
                             AND d.tran_class = 'COL'
                             AND NOT EXISTS (
                                    SELECT x.gacc_tran_id
                                      FROM giac_reversals x, giac_acctrans y
                                     WHERE x.reversing_tran_id = y.tran_id
                                       AND y.tran_flag <> 'D'
                                       AND x.gacc_tran_id = d.tran_id)
                          UNION
                          SELECT c.dv_date ref_date,
                                 c.dv_pref || ' ' || TO_CHAR (c.dv_no) ref_no,
                                 a.gacc_tran_id g_tran_id,
                                 NVL (a.disbursement_amt, 0) disb_amt,
                                 d.tran_class t_class,
                                 a.d010_fnl_binder_id binder_id, '2' dummy
                            FROM giac_outfacul_prem_payts a,
                                 giac_disb_vouchers c,
                                 giac_acctrans d
                           WHERE d.tran_flag <> 'D'
                             AND a.gacc_tran_id = c.gacc_tran_id
                             AND a.gacc_tran_id = d.tran_id
                             AND d.tran_class = 'DV'
                             AND NOT EXISTS (
                                    SELECT x.gacc_tran_id
                                      FROM giac_reversals x, giac_acctrans y
                                     WHERE x.reversing_tran_id = y.tran_id
                                       AND y.tran_flag <> 'D'
                                       AND x.gacc_tran_id = d.tran_id)
                          UNION
                          SELECT d.tran_date ref_date,
                                 
                                 --d.tran_class || ' ' || TO_CHAR (d.tran_class_no) ref_no, --Comment out by Marvin 11.25.10
                                 DECODE (d.tran_class,
                                         'JV', d.tran_class
                                          || ' '
                                          || TO_CHAR (d.tran_class_no),
                                         
                                         -- Added by Marvin 11.25.10
                                         'CM', d.tran_class
                                          || ' '
                                          || TO_CHAR (b.memo_year)
                                          || ' '
                                          || TO_CHAR (b.memo_seq_no),
                                         'DM', d.tran_class
                                          || ' '
                                          || TO_CHAR (b.memo_year)
                                          || ' '
                                          || TO_CHAR (b.memo_seq_no)
                                        ) ref_no,
                                 a.gacc_tran_id g_tran_id,
                                 NVL (a.disbursement_amt, 0) disb_amt,
                                 d.tran_class t_class,
                                 a.d010_fnl_binder_id binder_id, '3' dummy
                            FROM giac_outfacul_prem_payts a,
                                 giac_acctrans d,
                                 giac_cm_dm b
                           --Added by Marvin 11.25.10 Added giac_cm_dm table
                          WHERE  d.tran_flag <> 'D'
                             AND a.gacc_tran_id = d.tran_id
                             AND d.tran_id = b.gacc_tran_id(+)
                             --Added by Marvin 11.25.10
                             AND d.tran_class IN ('JV', 'CM', 'DM')
                             --Added by Marvin 11.25.10 Include CM/DM
                             AND NOT EXISTS (
                                    SELECT x.gacc_tran_id
                                      FROM giac_reversals x, giac_acctrans y
                                     WHERE x.reversing_tran_id = y.tran_id
                                       AND y.tran_flag <> 'D'
                                       AND x.gacc_tran_id = d.tran_id)
                          UNION
                          SELECT SYSDATE ref_date, ' ' ref_no, 0 g_tran_id,
                                 0 disb_amt, ' ' t_class, 0 binder_id,
                                 '4' dummy
                            FROM DUAL
                          UNION
                          SELECT e.request_date ref_date,
                                 e.document_cd || '-' || e.doc_seq_no ref_no,
                                 a.gacc_tran_id g_tran_id,
                                 NVL (a.disbursement_amt, 0) disb_amt,
                                 d.tran_class t_class,
                                 a.d010_fnl_binder_id binder_id, '5' dummy
                            FROM giac_outfacul_prem_payts a,
                                 giac_payt_requests e,
                                 giac_payt_requests_dtl s,
                                 giac_acctrans d
                           WHERE d.tran_flag <> 'D'
                             AND e.ref_id = s.gprq_ref_id
                             AND e.with_dv = 'N'
                             AND a.gacc_tran_id = d.tran_id
                             AND d.tran_class = 'DV'
                             AND d.tran_id = s.tran_id
                             AND NOT EXISTS (
                                    SELECT x.gacc_tran_id
                                      FROM giac_reversals x, giac_acctrans y
                                     WHERE x.reversing_tran_id = y.tran_id
                                       AND y.tran_flag <> 'D'
                                       AND x.gacc_tran_id = d.tran_id)
                          UNION
--this part is used to select the balance due for binders with still no payments made
--without this part, balances cannot be displayed for records with no payments
--ref_no = XXXX is used to distinguish the records from this select to the records above
--terrence 11/07/2002
                          SELECT TO_DATE ('01-JAN-01', 'DD-MON-YY'), 'XXXX', 9999, --added format mask by albert 10.09.2015 (SR 20594)
                                   ((  (  NVL (a.ri_prem_amt, 0)
                                        + NVL (a.ri_prem_vat, 0)
                                       )
                                     - (  NVL (a.ri_comm_amt, 0)
                                        + NVL (a.ri_comm_vat, 0)
                                        + NVL (a.ri_wholding_vat, 0)
                                       )
                                    )
                                   )
                                 * g.currency_rt,
                                 
                                 --modified by ging011006 (changed the formula for net prem)
                                 NULL, a.fnl_binder_id binder_id, '6' dummy
                            FROM giri_binder a,
                                 giri_frps_ri f,
                                 giri_distfrps g
                           WHERE a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                             AND a.line_cd = NVL (p_line_cd, a.line_cd)
                             AND DECODE (p_date_type,
                                         '1', TRUNC (a.eff_date),
                                         '2', TRUNC (a.binder_date),
                                         '3', TRUNC (a.acc_ent_date)
                                        ) BETWEEN p_date_from AND p_date_to
                             AND a.fnl_binder_id = f.fnl_binder_id
                             AND f.frps_yy = g.frps_yy
                             AND f.frps_seq_no = g.frps_seq_no
                             AND f.line_cd = g.line_cd
                             AND NOT EXISTS (
                                    SELECT e.d010_fnl_binder_id binder_id
                                      FROM giac_outfacul_prem_payts e,
                                           giac_acctrans d
                                     WHERE d.tran_flag <> 'D'
                                       AND a.fnl_binder_id =
                                                          e.d010_fnl_binder_id
                                       AND e.gacc_tran_id = d.tran_id
                                       AND NOT EXISTS (
                                              SELECT x.gacc_tran_id
                                                FROM giac_reversals x,
                                                     giac_acctrans y
                                               WHERE x.reversing_tran_id =
                                                                     y.tran_id
                                                 AND y.tran_flag <> 'D'
                                                 AND x.gacc_tran_id =
                                                                     d.tran_id))))
           WHERE binder_id = p_binder_id)
      LOOP
         v_rec.ref_date := binder.ref_date;
         v_rec.ref_no := binder.ref_no;
         v_rec.g_tran_id := binder.g_tran_id;
         v_rec.disb_amt := binder.disb_amt;
         v_rec.tran_class := binder.t_class;
         v_rec.dummy := binder.dummy;

         IF binder.ref_no = 'XXXX'
         THEN
            v_rec.cf_disb_pyt := 0;
         ELSE
            v_rec.cf_disb_pyt := NVL (binder.disb_amt, 0);
         END IF;

         IF p_dummy2 = 1
         THEN
            v_rec.cf_disb_amt2 := binder.disb_amt;
         ELSE
            v_rec.cf_disb_amt2 := binder.disb_amt * -1;
         END IF;
         
         v_rec.cs_disb_amt := v_rec.cs_disb_amt + v_rec.cf_disb_amt2;
         
         IF binder.ref_no = 'XXXX' AND p_replaced_flag = 'Y'
         THEN
            v_rec.cf_ref_bal := NVL (p_cf_net_prem, 0);
         ELSIF binder.ref_no = 'XXXX' AND p_replaced_flag IS NULL
         THEN
            v_rec.cf_ref_bal := NVL (v_rec.cs_disb_amt, 0);
         ELSIF binder.ref_no = 'XXXX' AND p_replaced_flag = 'N'
         THEN
            v_rec.cf_ref_bal := NVL (v_rec.cs_disb_amt, 0);
         ELSIF binder.ref_no != 'XXXX'
         THEN
            v_rec.cf_ref_bal := NVL (p_cf_net_prem, 0) - NVL (v_rec.cs_disb_amt, 0);
         END IF;

         PIPE ROW (v_rec);
      END LOOP;
   END;
END; 
/