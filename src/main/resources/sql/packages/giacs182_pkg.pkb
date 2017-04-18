CREATE OR REPLACE PACKAGE BODY CPI.giacs182_pkg
AS
   /*
   **  Created by   : Joms Diago
   **  Date Created : 06.28.2013
   **  Reference By : GIACS182- Schedule of Premiums Ceded to Facultative RI (as of)
   **  Description  :
   */
   FUNCTION validate_date_params (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_cut_off_date   VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      SELECT DISTINCT 'Y'
                 INTO v_exist
                 FROM giac_dueto_asof_ext
                WHERE user_id = p_user_id
                  AND from_date = TO_DATE (p_from_date, 'MM-DD-YYYY')
                  AND TO_DATE = TO_DATE (p_to_date, 'MM-DD-YYYY')
                  AND cut_off_date = TO_DATE (p_cut_off_date, 'MM-DD-YYYY');

      RETURN v_exist;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'E';
   END;

   PROCEDURE extract_giacs182 (
      p_from_date            DATE,
      p_to_date              DATE,
      p_cut_off_date         DATE,
      p_ri_cd                NUMBER,
      p_line_cd              VARCHAR2,
      p_user_id              giis_users.user_id%TYPE,
      p_exist          OUT   VARCHAR2
   )
   IS
      ctr            NUMBER                                           := 0;
      v_fund_cd      giac_branches.gfun_fund_cd%TYPE;
      v_branch_cd    giac_branches.branch_cd%TYPE;
      usetran_date   giac_acctrans.tran_date%TYPE;
      disb_amt       giac_outfacul_prem_payts.disbursement_amt%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_fund_cd
        FROM giac_parameters
       WHERE param_name = 'FUND_CD';

      SELECT param_value_v
        INTO v_branch_cd
        FROM giac_parameters
       WHERE param_name = 'BRANCH_CD';

      DELETE FROM giac_dueto_asof_ext
            WHERE user_id = p_user_id;

      FOR k IN (SELECT j.assd_name, i.assd_no, e.ri_cd, h.ri_name, e.line_cd,
                       e.binder_yy, e.binder_seq_no, e.binder_date,
                       e.fnl_binder_id,
                       (   a.line_cd
                        || '-'
                        || a.subline_cd
                        || '-'
                        || a.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (a.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                        || TO_CHAR (a.renew_no, '09')
                        || DECODE (NVL (a.endt_seq_no, 0),
                                   0, NULL,
                                      '-'
                                   || a.endt_iss_cd
                                   || '-'
                                   || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                   || '-'
                                   || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                                   || a.endt_type
                                  )
                       ) policy_no,
                       a.policy_id, a.ref_pol_no, acc_ent_date booking_date,
                       (NVL (e.ri_tsi_amt, 0) * NVL (d.currency_rt, 0)
                       ) amt_insured,
                       (NVL (e.ri_prem_amt, 0) * NVL (d.currency_rt, 0)
                       ) ri_prem_amt,
                       (NVL (e.ri_prem_vat, 0) * NVL (d.currency_rt, 0)
                       ) prem_vat,
                       (NVL (e.ri_comm_amt, 0) * NVL (d.currency_rt, 0)
                       ) ri_comm_amt,
                       (NVL (e.ri_comm_vat, 0) * NVL (d.currency_rt, 0)
                       ) comm_vat,
                       (NVL (e.ri_wholding_vat, 0) * NVL (d.currency_rt, 0)
                       ) wholding_vat,
                       (  (NVL (e.ri_prem_amt, 0) * NVL (d.currency_rt, 0))
                        - (NVL (e.ri_comm_amt, 0) * NVL (d.currency_rt, 0))
                       ) premium
                  FROM gipi_polbasic a,
                       giuw_pol_dist b,
                       giri_frps_ri c,
                       giri_distfrps d,
                       giri_binder e,
                       giis_currency g,
                       giis_reinsurer h,
                       gipi_parlist i,
                       giis_assured j
                 WHERE c.line_cd = d.line_cd
                   AND e.ri_cd = h.ri_cd
                   AND c.frps_yy = d.frps_yy
                   AND c.frps_seq_no = d.frps_seq_no
                   AND d.dist_no = b.dist_no
                   AND a.policy_id = b.policy_id
                   AND c.fnl_binder_id = e.fnl_binder_id
                   AND d.currency_cd = g.main_currency_cd
                   AND i.assd_no = j.assd_no
                   AND a.par_id = i.par_id
                   AND e.ri_cd = NVL (p_ri_cd, e.ri_cd)
                   AND e.line_cd = NVL (p_line_cd, e.line_cd)
                   AND (e.acc_ent_date BETWEEN p_from_date AND p_to_date)
                   AND (   (    b.dist_flag NOT IN (4, 5)
                            AND c.reverse_sw <> 'Y'
                            AND NVL (e.replaced_flag, 'X') <> 'Y'
                           )
                        OR (    b.dist_flag IN (4, 5)
                            AND TRUNC (b.negate_date) > p_cut_off_date
                           )
                        OR (    c.reverse_sw = 'Y'
                            AND TRUNC (e.reverse_date) > p_cut_off_date
                           )
                       )
                   AND check_user_per_iss_cd_acctg (NULL, a.iss_cd,
                                                    'GIACS182') = 1)
      LOOP
         FOR d IN (SELECT a.tran_date, NVL (b.disbursement_amt, 0) disb_amt
                     FROM giac_acctrans a, giac_outfacul_prem_payts b
                    WHERE a.tran_id = b.gacc_tran_id
                      AND d010_fnl_binder_id = k.fnl_binder_id
                      AND a.tran_date <= p_cut_off_date
                      AND a.tran_flag <> 'D'
                      AND NOT EXISTS (
                             SELECT 'X'
                               FROM giac_reversals gr, giac_acctrans ga
                              WHERE gr.reversing_tran_id = ga.tran_id
                                AND b.gacc_tran_id = ga.tran_id
                                AND ga.tran_flag <> 'D'))
         LOOP
            usetran_date := d.tran_date;
            disb_amt := d.disb_amt;

            INSERT INTO giac_dueto_asof_ext
                        (assd_no, assd_name, fund_cd, branch_cd,
                         ri_cd, ri_name, policy_id, policy_no,
                         ref_pol_no, fnl_binder_id, line_cd,
                         binder_yy, binder_seq_no, binder_date,
                         booking_date, amt_insured,
                         net_premium, ri_prem_amt,
                         ri_comm_amt, cut_off_date, from_date,
                         TO_DATE, user_id, prem_vat, comm_vat,
                         wholding_vat
                        )
                 VALUES (k.assd_no, k.assd_name, v_fund_cd, v_branch_cd,
                         k.ri_cd, k.ri_name, k.policy_id, k.policy_no,
                         k.ref_pol_no, k.fnl_binder_id, k.line_cd,
                         k.binder_yy, k.binder_seq_no, k.binder_date,
                         k.booking_date, k.amt_insured,
                         (k.premium - disb_amt
                         ), k.ri_prem_amt,
                         k.ri_comm_amt, p_cut_off_date, p_from_date,
                         p_to_date, p_user_id, k.prem_vat, k.comm_vat,
                         k.wholding_vat
                        );

            ctr := ctr + 1;
         END LOOP;
      END LOOP;

      giacs182_pkg.main_loop (p_from_date, p_to_date, p_cut_off_date);
      p_exist := TO_CHAR (ctr);
   END;

   PROCEDURE main_loop (p_from_date DATE, p_to_date DATE, p_cut_off_date DATE)
   IS
      dist_cntr    NUMBER;
      fnl_binder   giri_binder.fnl_binder_id%TYPE;
      subctr1      NUMBER;
   BEGIN
      FOR c IN (SELECT   e.fnl_binder_id, COUNT (b.dist_flag) main_ctr
                    FROM gipi_polbasic a,
                         giuw_pol_dist b,
                         giri_frps_ri c,
                         giri_distfrps d,
                         giri_binder e,
                         giis_currency g,
                         giis_reinsurer h,
                         gipi_parlist i,
                         giis_assured j
                   WHERE c.line_cd = d.line_cd
                     AND e.ri_cd = h.ri_cd
                     AND c.frps_yy = d.frps_yy
                     AND c.frps_seq_no = d.frps_seq_no
                     AND d.dist_no = b.dist_no
                     AND a.policy_id = b.policy_id
                     AND c.fnl_binder_id = e.fnl_binder_id
                     AND d.currency_cd = g.main_currency_cd
                     AND i.assd_no = j.assd_no
                     AND a.par_id = i.par_id
                     AND (e.acc_ent_date BETWEEN p_from_date AND p_to_date)
                     AND check_user_per_iss_cd_acctg (NULL,
                                                      a.iss_cd,
                                                      'GIACS182'
                                                     ) = 1
                     AND (   (    b.dist_flag NOT IN (4, 5)
                              AND c.reverse_sw <> 'Y'
                              AND NVL (e.replaced_flag, 'X') <> 'Y'
                             )
                          OR (    b.dist_flag IN (4, 5)
                              AND TRUNC (b.negate_date) > p_cut_off_date
                             )
                          OR (    c.reverse_sw = 'Y'
                              AND TRUNC (e.reverse_date) > p_cut_off_date
                             )
                         )
                     AND e.fnl_binder_id IN (SELECT   fnl_binder_id
                                                 FROM giri_frps_ri
                                               HAVING COUNT (fnl_binder_id) >
                                                                             1
                                             GROUP BY fnl_binder_id)
                GROUP BY e.fnl_binder_id)
      LOOP
         dist_cntr := c.main_ctr;
         fnl_binder := c.fnl_binder_id;

         BEGIN
            SELECT   e.fnl_binder_id, COUNT (b.dist_flag) subctr1
                INTO fnl_binder, subctr1
                FROM gipi_polbasic a,
                     giuw_pol_dist b,
                     giri_frps_ri c,
                     giri_distfrps d,
                     giri_binder e,
                     giis_currency g,
                     giis_reinsurer h,
                     gipi_parlist i,
                     giis_assured j
               WHERE c.line_cd = d.line_cd
                 AND e.ri_cd = h.ri_cd
                 AND c.frps_yy = d.frps_yy
                 AND c.frps_seq_no = d.frps_seq_no
                 AND d.dist_no = b.dist_no
                 AND a.policy_id = b.policy_id
                 AND c.fnl_binder_id = e.fnl_binder_id
                 AND d.currency_cd = g.main_currency_cd
                 AND i.assd_no = j.assd_no
                 AND a.par_id = i.par_id
                 AND (e.acc_ent_date BETWEEN p_from_date AND p_to_date)
                 AND check_user_per_iss_cd_acctg (NULL, a.iss_cd, 'GIACS182') =
                                                                             1
                 AND (   (    b.dist_flag NOT IN (4, 5)
                          AND c.reverse_sw <> 'Y'
                          AND NVL (e.replaced_flag, 'X') <> 'Y'
                         )
                      OR (    b.dist_flag IN (4, 5)
                          AND TRUNC (b.negate_date) > p_cut_off_date
                         )
                      OR (    c.reverse_sw = 'Y'
                          AND TRUNC (e.reverse_date) > p_cut_off_date
                         )
                     )
                 AND b.dist_flag IN (4, 5)
                 AND e.fnl_binder_id = fnl_binder
            GROUP BY e.fnl_binder_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               subctr1 := 0;
               fnl_binder := c.fnl_binder_id;
         END;

         BEGIN
            IF dist_cntr = subctr1
            THEN
               giacs182_pkg.find_all_neg (p_from_date,
                                          p_to_date,
                                          p_cut_off_date,
                                          fnl_binder
                                         );
            ELSIF dist_cntr <> subctr1
            THEN
               giacs182_pkg.find_one_val (p_from_date,
                                          p_to_date,
                                          p_cut_off_date,
                                          fnl_binder
                                         );
            END IF;
         END;
      END LOOP;
   END;

   PROCEDURE find_all_neg (
      p_from_date       DATE,
      p_to_date         DATE,
      p_cut_off_date    DATE,
      p_fnl_binder_id   giri_binder.fnl_binder_id%TYPE
   )
   IS
      usefnl_binder   giri_binder.fnl_binder_id%TYPE;
      usedist_no      giuw_pol_dist.dist_no%TYPE;
      useneg_date     giuw_pol_dist.negate_date%TYPE;
   BEGIN
      SELECT e.fnl_binder_id, b.dist_no, TRUNC (b.negate_date)
        INTO usefnl_binder, usedist_no, useneg_date
        FROM gipi_polbasic a,
             giuw_pol_dist b,
             giri_frps_ri c,
             giri_distfrps d,
             giri_binder e,
             giis_currency g,
             giis_reinsurer h,
             gipi_parlist i,
             giis_assured j
       WHERE c.line_cd = d.line_cd
         AND e.ri_cd = h.ri_cd
         AND c.frps_yy = d.frps_yy
         AND c.frps_seq_no = d.frps_seq_no
         AND d.dist_no = b.dist_no
         AND a.policy_id = b.policy_id
         AND c.fnl_binder_id = e.fnl_binder_id
         AND d.currency_cd = g.main_currency_cd
         AND i.assd_no = j.assd_no
         AND a.par_id = i.par_id
         AND (e.acc_ent_date BETWEEN p_from_date AND p_to_date)
         AND check_user_per_iss_cd_acctg (NULL, a.iss_cd, 'GIACS182') = 1
         AND (   (    b.dist_flag NOT IN (4, 5)
                  AND c.reverse_sw <> 'Y'
                  AND NVL (e.replaced_flag, 'X') <> 'Y'
                 )
              OR (    b.dist_flag IN (4, 5)
                  AND TRUNC (b.negate_date) > p_cut_off_date
                 )
              OR (c.reverse_sw = 'Y'
                  AND TRUNC (e.reverse_date) > p_cut_off_date
                 )
             )
         AND e.fnl_binder_id IN (SELECT   fnl_binder_id
                                     FROM giri_frps_ri
                                   HAVING COUNT (fnl_binder_id) > 1
                                 GROUP BY fnl_binder_id)
         AND e.fnl_binder_id = p_fnl_binder_id
         AND TRUNC (b.negate_date) =
                (SELECT TRUNC (MAX (b.negate_date))
                   FROM gipi_polbasic a,
                        giuw_pol_dist b,
                        giri_frps_ri c,
                        giri_distfrps d,
                        giri_binder e,
                        giis_currency g,
                        giis_reinsurer h,
                        gipi_parlist i,
                        giis_assured j
                  WHERE c.line_cd = d.line_cd
                    AND e.ri_cd = h.ri_cd
                    AND c.frps_yy = d.frps_yy
                    AND c.frps_seq_no = d.frps_seq_no
                    AND d.dist_no = b.dist_no
                    AND a.policy_id = b.policy_id
                    AND c.fnl_binder_id = e.fnl_binder_id
                    AND d.currency_cd = g.main_currency_cd
                    AND i.assd_no = j.assd_no
                    AND a.par_id = i.par_id
                    AND (e.acc_ent_date BETWEEN p_from_date AND p_to_date)
                    AND (   (b.dist_flag NOT IN (4, 5) AND c.reverse_sw <> 'Y'
                            )
                         OR (    b.dist_flag IN (4, 5)
                             AND TRUNC (b.negate_date) > p_cut_off_date
                            )
                         OR (    c.reverse_sw = 'Y'
                             AND TRUNC (e.reverse_date) > p_cut_off_date
                            )
                        )
                    AND e.fnl_binder_id IN (SELECT   fnl_binder_id
                                                FROM giri_frps_ri
                                              HAVING COUNT (fnl_binder_id) > 1
                                            GROUP BY fnl_binder_id)
                    AND e.fnl_binder_id = p_fnl_binder_id);

      giacs182_pkg.all_neg_insert (p_from_date,
                                   p_to_date,
                                   p_cut_off_date,
                                   usefnl_binder,
                                   usedist_no,
                                   useneg_date
                                  );
   END;

   PROCEDURE all_neg_insert (
      p_from_date       DATE,
      p_to_date         DATE,
      p_cut_off_date    DATE,
      p_usefnl_binder   giri_binder.fnl_binder_id%TYPE,
      p_usedist_no      giuw_pol_dist.dist_no%TYPE,
      p_useneg_date     giuw_pol_dist.negate_date%TYPE
   )
   IS
      v_fund_cd      giac_branches.gfun_fund_cd%TYPE;
      v_branch_cd    giac_branches.branch_cd%TYPE;
      usetran_date   giac_acctrans.tran_date%TYPE;
      disb_amt       giac_outfacul_prem_payts.disbursement_amt%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_fund_cd
        FROM giac_parameters
       WHERE param_name = 'FUND_CD';

      SELECT param_value_v
        INTO v_branch_cd
        FROM giac_parameters
       WHERE param_name = 'BRANCH_CD';

      FOR c IN (SELECT j.assd_name, i.assd_no, e.ri_cd, e.line_cd, h.ri_name,
                       e.binder_yy, e.binder_seq_no, e.binder_date,
                       e.fnl_binder_id,
                       (   a.line_cd
                        || '-'
                        || a.subline_cd
                        || '-'
                        || a.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (a.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                        || DECODE (NVL (a.endt_seq_no, 0),
                                   0, NULL,
                                      '-'
                                   || a.endt_iss_cd
                                   || '-'
                                   || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                   || '-'
                                   || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                                   || a.endt_type
                                  )
                       ) policy_no,
                       a.policy_id, acc_ent_date booking_date,
                       (NVL (e.ri_tsi_amt, 0) * NVL (d.currency_rt, 0)
                       ) amt_insured,
                       (  (NVL (e.ri_prem_amt, 0) * NVL (d.currency_rt, 0))
                        - (NVL (e.ri_comm_amt, 0) * NVL (d.currency_rt, 0))
                       ) premium
                  FROM gipi_polbasic a,
                       giuw_pol_dist b,
                       giri_frps_ri c,
                       giri_distfrps d,
                       giri_binder e,
                       giis_currency g,
                       giis_reinsurer h,
                       gipi_parlist i,
                       giis_assured j
                 WHERE c.line_cd = d.line_cd
                   AND e.ri_cd = h.ri_cd
                   AND c.frps_yy = d.frps_yy
                   AND c.frps_seq_no = d.frps_seq_no
                   AND d.dist_no = b.dist_no
                   AND a.policy_id = b.policy_id
                   AND c.fnl_binder_id = e.fnl_binder_id
                   AND d.currency_cd = g.main_currency_cd
                   AND i.assd_no = j.assd_no
                   AND a.par_id = i.par_id
                   AND (e.acc_ent_date BETWEEN p_from_date AND p_to_date)
                   AND check_user_per_iss_cd_acctg (NULL, a.iss_cd,
                                                    'GIACS182') = 1
                   AND (   (    b.dist_flag NOT IN (4, 5)
                            AND c.reverse_sw <> 'Y'
                            AND NVL (e.replaced_flag, 'X') <> 'Y'
                           )
                        OR (    b.dist_flag IN (4, 5)
                            AND TRUNC (b.negate_date) > p_cut_off_date
                           )
                        OR (    c.reverse_sw = 'Y'
                            AND TRUNC (e.reverse_date) > p_cut_off_date
                           )
                       )
                   AND e.fnl_binder_id = p_usefnl_binder
                   AND b.dist_no = p_usedist_no
                   AND TRUNC (b.negate_date) = p_useneg_date
                   AND e.fnl_binder_id IN (SELECT   fnl_binder_id
                                               FROM giri_frps_ri
                                             HAVING COUNT (fnl_binder_id) > 1
                                           GROUP BY fnl_binder_id))
      LOOP
         BEGIN
            SELECT a.tran_date, NVL (b.disbursement_amt, 0)
              INTO usetran_date, disb_amt
              FROM giac_acctrans a, giac_outfacul_prem_payts b
             WHERE a.tran_id = b.gacc_tran_id
               AND d010_fnl_binder_id = p_usefnl_binder
               AND a.tran_date <= p_cut_off_date
               AND NOT EXISTS (
                      SELECT 'X'
                        FROM giac_reversals gr, giac_acctrans ga
                       WHERE gr.reversing_tran_id = ga.tran_id
                         AND b.gacc_tran_id = ga.tran_id
                         AND ga.tran_flag = 'D');
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               disb_amt := 0;
         END;

         INSERT INTO giac_dueto_asof_ext
                     (assd_no, assd_name, fund_cd, branch_cd,
                      ri_cd, ri_name, policy_id, policy_no,
                      fnl_binder_id, line_cd, binder_yy,
                      binder_seq_no, binder_date, booking_date,
                      amt_insured, net_premium, cut_off_date,
                      from_date, TO_DATE
                     )
              VALUES (c.assd_no, c.assd_name, v_fund_cd, v_branch_cd,
                      c.ri_cd, c.ri_name, c.policy_id, c.policy_no,
                      c.fnl_binder_id, c.line_cd, c.binder_yy,
                      c.binder_seq_no, c.binder_date, c.booking_date,
                      c.amt_insured, (c.premium - disb_amt), p_cut_off_date,
                      p_from_date, p_to_date
                     );
      END LOOP;
   END;

   PROCEDURE find_one_val (
      p_from_date       DATE,
      p_to_date         DATE,
      p_cut_off_date    DATE,
      p_fnl_binder_id   giri_binder.fnl_binder_id%TYPE
   )
   IS
      usefnl_binder   giri_binder.fnl_binder_id%TYPE;
      usedist_no      giuw_pol_dist.dist_no%TYPE;
      useneg_date     giuw_pol_dist.negate_date%TYPE;
   BEGIN
      SELECT e.fnl_binder_id, b.dist_no, b.negate_date
        INTO usefnl_binder, usedist_no, useneg_date
        FROM gipi_polbasic a,
             giuw_pol_dist b,
             giri_frps_ri c,
             giri_distfrps d,
             giri_binder e,
             giis_currency g,
             giis_reinsurer h,
             gipi_parlist i,
             giis_assured j
       WHERE c.line_cd = d.line_cd
         AND e.ri_cd = h.ri_cd
         AND c.frps_yy = d.frps_yy
         AND c.frps_seq_no = d.frps_seq_no
         AND d.dist_no = b.dist_no
         AND a.policy_id = b.policy_id
         AND c.fnl_binder_id = e.fnl_binder_id
         AND d.currency_cd = g.main_currency_cd
         AND i.assd_no = j.assd_no
         AND a.par_id = i.par_id
         AND (e.acc_ent_date BETWEEN p_from_date AND p_to_date)
         AND check_user_per_iss_cd_acctg (NULL, a.iss_cd, 'GIACS182') = 1
         AND (   (    b.dist_flag NOT IN (4, 5)
                  AND c.reverse_sw <> 'Y'
                  AND NVL (e.replaced_flag, 'X') <> 'Y'
                 )
              OR (    b.dist_flag IN (4, 5)
                  AND TRUNC (b.negate_date) > p_cut_off_date
                 )
              OR (c.reverse_sw = 'Y'
                  AND TRUNC (e.reverse_date) > p_cut_off_date
                 )
             )
         AND e.fnl_binder_id IN (SELECT   fnl_binder_id
                                     FROM giri_frps_ri
                                   HAVING COUNT (fnl_binder_id) > 1
                                 GROUP BY fnl_binder_id)
         AND e.fnl_binder_id = p_fnl_binder_id
         AND b.dist_flag NOT IN (4, 5);

      giacs182_pkg.one_val_insert (p_from_date,
                                   p_to_date,
                                   p_cut_off_date,
                                   usefnl_binder,
                                   usedist_no,
                                   useneg_date
                                  );
   END;

   PROCEDURE one_val_insert (
      p_from_date       DATE,
      p_to_date         DATE,
      p_cut_off_date    DATE,
      p_usefnl_binder   giri_binder.fnl_binder_id%TYPE,
      p_usedist_no      giuw_pol_dist.dist_no%TYPE,
      p_useneg_date     giuw_pol_dist.negate_date%TYPE
   )
   IS
      p_ctr          NUMBER;
      v_fund_cd      giac_branches.gfun_fund_cd%TYPE;
      v_branch_cd    giac_branches.branch_cd%TYPE;
      usetran_date   giac_acctrans.tran_date%TYPE;
      disb_amt       giac_outfacul_prem_payts.disbursement_amt%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_fund_cd
        FROM giac_parameters
       WHERE param_name = 'FUND_CD';

      SELECT param_value_v
        INTO v_branch_cd
        FROM giac_parameters
       WHERE param_name = 'BRANCH_CD';

      FOR c IN (SELECT j.assd_name, i.assd_no, e.ri_cd, h.ri_name, e.line_cd,
                       e.binder_yy, e.binder_seq_no, e.binder_date,
                       e.fnl_binder_id,
                       (   a.line_cd
                        || '-'
                        || a.subline_cd
                        || '-'
                        || a.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (a.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                        || DECODE (NVL (a.endt_seq_no, 0),
                                   0, NULL,
                                      '-'
                                   || a.endt_iss_cd
                                   || '-'
                                   || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                   || '-'
                                   || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                                   || a.endt_type
                                  )
                       ) policy_no,
                       a.policy_id, acc_ent_date booking_date,
                       (NVL (e.ri_tsi_amt, 0) * NVL (d.currency_rt, 0)
                       ) amt_insured,
                       (  (NVL (e.ri_prem_amt, 0) * NVL (d.currency_rt, 0))
                        - (NVL (e.ri_comm_amt, 0) * NVL (d.currency_rt, 0))
                       ) premium
                  FROM gipi_polbasic a,
                       giuw_pol_dist b,
                       giri_frps_ri c,
                       giri_distfrps d,
                       giri_binder e,
                       giis_currency g,
                       giis_reinsurer h,
                       gipi_parlist i,
                       giis_assured j
                 WHERE c.line_cd = d.line_cd
                   AND e.ri_cd = h.ri_cd
                   AND c.frps_yy = d.frps_yy
                   AND c.frps_seq_no = d.frps_seq_no
                   AND d.dist_no = b.dist_no
                   AND a.policy_id = b.policy_id
                   AND c.fnl_binder_id = e.fnl_binder_id
                   AND d.currency_cd = g.main_currency_cd
                   AND i.assd_no = j.assd_no
                   AND a.par_id = i.par_id
                   AND (e.acc_ent_date BETWEEN p_from_date AND p_to_date)
                   AND check_user_per_iss_cd_acctg (NULL, a.iss_cd,
                                                    'GIACS182') = 1
                   AND (   (    b.dist_flag NOT IN (4, 5)
                            AND c.reverse_sw <> 'Y'
                            AND NVL (e.replaced_flag, 'X') <> 'Y'
                           )
                        OR (    b.dist_flag IN (4, 5)
                            AND TRUNC (b.negate_date) > p_cut_off_date
                           )
                        OR (    c.reverse_sw = 'Y'
                            AND TRUNC (e.reverse_date) > p_cut_off_date
                           )
                       )
                   AND e.fnl_binder_id = p_usefnl_binder
                   AND b.dist_flag NOT IN (4, 5)
                   AND e.fnl_binder_id IN (SELECT   fnl_binder_id
                                               FROM giri_frps_ri
                                             HAVING COUNT (fnl_binder_id) > 1
                                           GROUP BY fnl_binder_id))
      LOOP
         FOR x IN (SELECT a.tran_date, NVL (b.disbursement_amt, 0) disb_amt
                     FROM giac_acctrans a, giac_outfacul_prem_payts b
                    WHERE a.tran_id = b.gacc_tran_id
                      AND d010_fnl_binder_id = p_usefnl_binder
                      AND a.tran_date <= p_cut_off_date
                      AND NOT EXISTS (
                             SELECT 'X'
                               FROM giac_reversals gr, giac_acctrans ga
                              WHERE gr.reversing_tran_id = ga.tran_id
                                AND b.gacc_tran_id = ga.tran_id
                                AND ga.tran_flag = 'D'))
         LOOP
            usetran_date := x.tran_date;
            disb_amt := x.disb_amt;
            p_ctr := NVL (p_ctr, 0) + 1;

            INSERT INTO giac_dueto_asof_ext
                        (assd_no, assd_name, fund_cd, branch_cd,
                         ri_cd, ri_name, policy_id, policy_no,
                         fnl_binder_id, line_cd, binder_yy,
                         binder_seq_no, binder_date, booking_date,
                         amt_insured, net_premium,
                         cut_off_date, from_date, TO_DATE
                        )
                 VALUES (c.assd_no, c.assd_name, v_fund_cd, v_branch_cd,
                         c.ri_cd, c.ri_name, c.policy_id, c.policy_no,
                         c.fnl_binder_id, c.line_cd, c.binder_yy,
                         c.binder_seq_no, c.binder_date, c.booking_date,
                         c.amt_insured, (c.premium - disb_amt),
                         p_cut_off_date, p_from_date, p_to_date
                        );
         END LOOP;

         IF p_ctr IS NULL
         THEN
            disb_amt := 0;

            INSERT INTO giac_dueto_asof_ext
                        (assd_no, assd_name, fund_cd, branch_cd,
                         ri_cd, ri_name, policy_id, policy_no,
                         fnl_binder_id, line_cd, binder_yy,
                         binder_seq_no, binder_date, booking_date,
                         amt_insured, net_premium,
                         cut_off_date, from_date, TO_DATE
                        )
                 VALUES (c.assd_no, c.assd_name, v_fund_cd, v_branch_cd,
                         c.ri_cd, c.ri_name, c.policy_id, c.policy_no,
                         c.fnl_binder_id, c.line_cd, c.binder_yy,
                         c.binder_seq_no, c.binder_date, c.booking_date,
                         c.amt_insured, (c.premium - disb_amt),
                         p_cut_off_date, p_from_date, p_to_date
                        );
         END IF;
      END LOOP;
   END;

   FUNCTION get_ri_lov (p_keyword VARCHAR2)
      RETURN ri_lov_tab PIPELINED
   IS
      v_list   ri_lov_type;
   BEGIN
      FOR i IN (SELECT   ri_cd, ri_name
                    FROM giis_reinsurer
                   WHERE (   UPPER (ri_cd) LIKE
                                   '%' || UPPER (NVL (p_keyword, ri_cd))
                                   || '%'
                          OR UPPER (ri_name) LIKE
                                 '%' || UPPER (NVL (p_keyword, ri_name))
                                 || '%'
                         )
                ORDER BY 1, 2)
      LOOP
         v_list.ri_cd := i.ri_cd;
         v_list.ri_name := i.ri_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_line_lov (p_keyword VARCHAR2)
      RETURN line_lov_tab PIPELINED
   IS
      v_list   line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE (   UPPER (line_cd) LIKE
                                   '%' || UPPER (NVL (p_keyword, line_cd))
                                   || '%'
                          OR UPPER (line_name) LIKE
                                 '%' || UPPER (NVL (p_keyword, line_name))
                                 || '%'
                         )
                ORDER BY 1, 2)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION get_giacs182_variables(
      p_user_id            GIAC_DUETO_ASOF_EXT.user_id%TYPE
   )
     RETURN giacs182_variables_tab PIPELINED
   IS
      v_row                giacs182_variables_type;
   BEGIN
      FOR i IN(SELECT cut_off_date, from_date, to_date
                 FROM GIAC_DUETO_ASOF_EXT
                WHERE user_id = p_user_id
                  AND ROWNUM = 1)
      LOOP
         v_row.cut_off_date := TO_CHAR(i.cut_off_date, 'mm-dd-yyyy');
         v_row.from_date := TO_CHAR(i.from_date, 'mm-dd-yyyy');
         v_row.to_date := TO_CHAR(i.to_date, 'mm-dd-yyyy');
         PIPE ROW(v_row);
      END LOOP;
   END;
END;
/


