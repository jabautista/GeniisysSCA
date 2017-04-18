CREATE OR REPLACE PACKAGE BODY CPI.giacs183_pkg
AS
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 06.18.2013
   **  Reference By : GIACS183- Schedule of Due from Facultative RI
   **  Description  :
   */
   FUNCTION get_line_lov
      RETURN line_lov_tab PIPELINED
   IS
      v_rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                ORDER BY 1, 2)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_ri_lov
      RETURN ri_lov_tab PIPELINED
   IS
      v_rec   ri_lov_type;
   BEGIN
      FOR i IN (SELECT 99999 ri_cd, 'ALL REINSURERS' ri_name
                  FROM DUAL
                UNION
                SELECT   garsd.a180_ri_cd ri_cd, gr.ri_name ri_name
                    FROM giac_aging_ri_soa_details garsd, giis_reinsurer gr
                   WHERE garsd.a180_ri_cd = gr.ri_cd
                GROUP BY garsd.a180_ri_cd, gr.ri_name)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_date (p_user_id giis_users.user_id%TYPE)
      RETURN date_tab PIPELINED
   IS
      v_rec   date_type;
   BEGIN
      FOR c IN (SELECT DISTINCT from_date, TO_DATE, cut_off_date
                           FROM giac_dueto_asof_ext
                          WHERE user_id = p_user_id)
      LOOP
         v_rec.from_date := TO_CHAR (c.from_date, 'MM-DD-YYYY');
         v_rec.TO_DATE := TO_CHAR (c.TO_DATE, 'MM-DD-YYYY');
         v_rec.cut_off_date := TO_CHAR (c.cut_off_date, 'MM-DD-YYYY');
         PIPE ROW (v_rec);
         EXIT;
      END LOOP;
   END;

   FUNCTION validate_print (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_cut_off_date   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR a IN (SELECT DISTINCT from_date, TO_DATE, cut_off_date
                           FROM giac_due_from_ext
                          WHERE from_date =
                                          TO_DATE (p_from_date, 'MM-DD-YYYY')
                            AND TO_DATE = TO_DATE (p_to_date, 'MM-DD-YYYY')
                            AND cut_off_date =
                                        TO_DATE (p_cut_off_date, 'MM-DD-YYYY'))
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exist;
   END;

   PROCEDURE extract_to_table (
      p_from_date            VARCHAR2,
      p_to_date              VARCHAR2,
      p_cut_off_date         VARCHAR2,
      p_ri_cd                giis_reinsurer.ri_cd%TYPE,
      p_line_cd              giis_line.line_cd%TYPE,
      p_exist          OUT   VARCHAR2,
      p_fund_cd        OUT   giac_parameters.param_value_v%TYPE,
      p_branch_cd      OUT   giac_parameters.param_value_v%TYPE,
      p_usetran_date   OUT   giac_acctrans.tran_date%TYPE,
      p_colln_amt      OUT   giac_inwfacul_prem_collns.collection_amt%TYPE
   )
   IS
      ctr             NUMBER         := 0;
      v_net_premium   NUMBER (16, 2);
      v_tax           NUMBER (16, 2);
      v_from_date     DATE := TO_DATE(p_from_date,'MM-DD-YYYY');
      v_to_date       DATE := TO_DATE(p_to_date,'MM-DD-YYYY');
      v_cut_off_date  DATE := TO_DATE(p_cut_off_date,'MM-DD-YYYY');
      
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO p_fund_cd
           FROM giac_parameters
          WHERE param_name = 'FUND_CD';
      EXCEPTION                                 --jacq07072006,added exception
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#No parameter FUND_CD found in GIAC_PARAMETERS'
               );
      END;

      BEGIN
         SELECT param_value_v
           INTO p_branch_cd
           FROM giac_parameters
          WHERE param_name = 'BRANCH_CD';
      EXCEPTION                                 --jacq07072006,added exception
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#No parameter BRANCH_CD found in GIAC_PARAMETERS'
               );
      END;

      DELETE FROM giac_due_from_ext;

      FOR k IN (SELECT g.assd_no, h.assd_name, b.ri_cd, f.ri_sname,
                       (   a.line_cd
                        || '-'
                        || a.subline_cd
                        || '-'
                        || d.iss_cd
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
                       a.policy_id,
                       
                       --a.acct_ent_date booking_date, -- commented by grace 05/05/2008: replaced by the code below
                       NVL (d.acct_ent_date, a.acct_ent_date) booking_date,
                       
                       -- grace 05/05/2008: acct_ent_date will be retrieved from gipi_invoce
                       (NVL (a.tsi_amt, 0) * NVL (d.currency_rt, 0)
                       ) amt_insured,
                       
                       /* mark jm 11.16.09 for PCIC_PRF_ID_4081 use gipi_invoice instead of gipi_item*/

                       --(NVL(d.prem_amt,0)*NVL(d.currency_rt,0)) gross_prem_amt, /* mark jm 11.16.09 for PCIC_PRF_ID_4081 use gipi_invoice instead of gipi_item*/
                       (NVL (e.prem_amt, 0) * NVL (d.currency_rt, 0)
                       ) gross_prem_amt,
                       
                       -- judyann 02072011; prem per installment
                       --(NVL(d.ri_comm_amt,0)*NVL(d.currency_rt,0)) ri_comm_exp, /* mark jm 11.16.09 for PCIC_PRF_ID_4081 use gipi_invoice instead of gipi_item*/
                       ROUND (  (  NVL (e.prem_amt, 0)
                                 / DECODE (NVL (d.prem_amt, 0),
                                           0, 1,
                                           d.prem_amt
                                          )
                                )
                              * ((  NVL (d.ri_comm_amt, 0)
                                  * NVL (d.currency_rt, 0)
                                 )
                                ),
                              2
                             ) ri_comm_exp,
                       
                       -- judyann 02072011; comm per installment
                       /*DECODE(f.local_foreign_sw,'L',(NVL(d.ri_comm_amt,0)*NVL(f.input_vat_rate/100,0)*NVL(c.currency_rt,0)),
                       /*NVL(i.comm_vat,0) comm_vat, */
                       --NVL(d.ri_comm_vat,0) comm_vat,--modified by jacq07102006
                       ROUND (  (  NVL (e.prem_amt, 0)
                                 / DECODE (NVL (d.prem_amt, 0),
                                           0, 1,
                                           d.prem_amt
                                          )
                                )
                              * ((  NVL (d.ri_comm_vat, 0)
                                  * NVL (d.currency_rt, 0)
                                 )
                                ),
                              2
                             ) comm_vat,
                       
                       -- judyann 02072011; comm vat per installment
                       --((NVL(d.prem_amt,0)*NVL(c.currency_rt,0)) - (NVL(d.ri_comm_amt,0)*NVL(c.currency_rt,0))) net_premium,
                       d.iss_cd, d.prem_seq_no, e.inst_no,
                       e.due_date invoice_date
                  FROM gipi_polbasic a,
                       giri_inpolbas b,
                       /*GIPI_ITEM c, -- mark jm 11.16.09 for PCIC_PRF_ID_4081 to avoid duplicate of records */
                       gipi_invoice d,
                       gipi_installment e,
                       giis_reinsurer f,
                       gipi_parlist g,
                       giis_assured h,
                       giac_aging_ri_soa_details i
                 WHERE 1 = 1
                   AND a.policy_id = b.policy_id
                   /*AND a.policy_id = c.policy_id -- mark jm 11.16.09 for PCIC_PRF_ID_4081 to avoid duplicate of records */
                   AND a.policy_id = d.policy_id
                   /* mark jm 11.16.09 for PCIC_PRF_ID_4081 use gipi_polbasic instead of gipi_item */
                   AND d.iss_cd = e.iss_cd
                   AND d.prem_seq_no = e.prem_seq_no
                   AND b.ri_cd = f.ri_cd
                   AND a.par_id = g.par_id
                   AND g.assd_no = h.assd_no
                   AND e.iss_cd = giacp.v ('RI_ISS_CD')
                   AND e.prem_seq_no = i.prem_seq_no
                   AND e.inst_no = i.inst_no
                   AND b.ri_cd = NVL (p_ri_cd, b.ri_cd)
                   AND a.line_cd = NVL (p_line_cd, a.line_cd)
                   --AND (a.acct_ent_date BETWEEN :misc.from_date AND :misc.to_date)) -- commented by grace 05/05/2008: replaced by the code below
                   AND (NVL (d.acct_ent_date, a.acct_ent_date)
                           BETWEEN v_from_date
                               AND v_to_date
                       ))
      -- grace 05/05/2008: acct_ent_date will be retrieved from gipi_invoce
      LOOP
         FOR v IN (SELECT NVL (tax_amt, 0) tax_amt
                     FROM gipi_inv_tax
                    WHERE iss_cd = k.iss_cd
                      AND prem_seq_no = k.prem_seq_no
                      AND tax_cd = giacp.n ('EVAT'))
         LOOP
            v_tax := v.tax_amt;
            v_net_premium :=
                      (k.gross_prem_amt + v_tax)
                    - (k.ri_comm_exp + k.comm_vat);
         END LOOP;

         v_net_premium :=
                       (k.gross_prem_amt + v_tax)
                     - (k.ri_comm_exp + k.comm_vat);

         /*added by jacq07102006.assign zero as value of v_tax if it is null.*/
         IF v_tax IS NULL
         THEN
            v_tax := 0;
         END IF;

         /*check if the collection is valid within the period through giac_acctrans tran date*/
         FOR c IN (SELECT a.tran_date, NVL (b.collection_amt, 0) colln_amt
                     FROM giac_acctrans a, giac_inwfacul_prem_collns b
                    WHERE a.tran_id = b.gacc_tran_id
                      AND a.tran_date <= v_cut_off_date
                      AND a.tran_flag <> 'D'
                      AND NOT EXISTS (
                             SELECT 'X'
                               FROM giac_reversals gr, giac_acctrans ga
                              WHERE gr.reversing_tran_id = ga.tran_id
                                AND b.gacc_tran_id = ga.tran_id
                                AND ga.tran_flag <> 'D'))
         LOOP
            p_usetran_date := c.tran_date;
            p_colln_amt := c.colln_amt;
         END LOOP;

         IF p_colln_amt IS NULL
         THEN
            p_colln_amt := 0;
         END IF;

         INSERT INTO giac_due_from_ext
                     (fund_cd, branch_cd, ri_cd, ri_sname, assd_no,
                      assd_name, iss_cd, prem_seq_no, inst_no,
                      policy_id, policy_no, amt_insured,
                      gross_prem_amt, ri_comm_exp, from_date,
                      TO_DATE, cut_off_date, booking_date,
                      invoice_date, prem_vat, comm_vat
                     )
              VALUES (p_fund_cd, p_branch_cd, k.ri_cd, k.ri_sname, k.assd_no,
                      k.assd_name, k.iss_cd, k.prem_seq_no, k.inst_no,
                      k.policy_id, k.policy_no, k.amt_insured,
                      k.gross_prem_amt, k.ri_comm_exp, v_from_date,
                      v_to_date, v_cut_off_date, k.booking_date,
                      k.invoice_date, v_tax, k.comm_vat
                     );

         ctr := ctr + 1;
      END LOOP;

      p_exist := TO_CHAR (ctr);
   END;

   PROCEDURE main_loop (
      p_from_date            VARCHAR2,
      p_to_date              VARCHAR2,
      p_cut_off_date         VARCHAR2,
      p_fund_cd              giac_parameters.param_value_v%TYPE,
      p_branch_cd            giac_parameters.param_value_v%TYPE,
      p_usetran_date IN OUT  giac_acctrans.tran_date%TYPE,
      p_colln_amt    IN OUT  giac_inwfacul_prem_collns.collection_amt%TYPE
   )
   IS
      v_dist_cntr       NUMBER;
      v_fnl_binder      giri_frps_ri.fnl_binder_id%TYPE;
      v_subctr1         NUMBER;
      v_usefnl_binder   NUMBER;
      v_usedist_no      NUMBER;
      v_useneg_date     DATE;
      v_disb_amt        NUMBER;
      v_from_date       DATE := TO_DATE(p_from_date,'MM-DD-YYYY');
      v_to_date         DATE := TO_DATE(p_to_date,'MM-DD-YYYY');
      v_cut_off_date    DATE := TO_DATE(p_cut_off_date,'MM-DD-YYYY');
   BEGIN
      /* FOR THE MAIN LOOP FINDING THE NUMBER OF DIST_NO IN A BINDER*/
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
                     AND (e.acc_ent_date BETWEEN v_from_date AND v_to_date)
                     AND (   (    b.dist_flag NOT IN (4, 5)
                              AND c.reverse_sw <> 'Y'
                              AND NVL (e.replaced_flag, 'X') <> 'Y'
                             )
                          OR (    b.dist_flag IN (4, 5)
                              AND TRUNC (b.negate_date) > v_cut_off_date
                             )
                          OR (    c.reverse_sw = 'Y'
                              AND TRUNC (e.reverse_date) > v_cut_off_date
                             )
                         )
                     AND e.fnl_binder_id IN (SELECT   fnl_binder_id
                                                 FROM giri_frps_ri
                                               HAVING COUNT (fnl_binder_id) >
                                                                             1
                                             GROUP BY fnl_binder_id)
                GROUP BY e.fnl_binder_id)
      LOOP
         v_dist_cntr := c.main_ctr;
         v_fnl_binder := c.fnl_binder_id;

         /*IN THE MAIN LOOP, COUNTING THE NUMBER OF DIST_FLAGS(4,5)*/
         BEGIN
            SELECT   e.fnl_binder_id, COUNT (b.dist_flag) subctr1
                INTO v_fnl_binder, v_subctr1
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
                 AND (e.acc_ent_date BETWEEN v_from_date AND v_to_date)
                 AND (   (    b.dist_flag NOT IN (4, 5)
                          AND c.reverse_sw <> 'Y'
                          AND NVL (e.replaced_flag, 'X') <> 'Y'
                         )
                      OR (    b.dist_flag IN (4, 5)
                          AND TRUNC (b.negate_date) > v_cut_off_date
                         )
                      OR (    c.reverse_sw = 'Y'
                          AND TRUNC (e.reverse_date) > v_cut_off_date
                         )
                     )
                 AND b.dist_flag IN (4, 5)
                 AND e.fnl_binder_id = v_fnl_binder
            GROUP BY e.fnl_binder_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_subctr1 := 0;
               v_fnl_binder := c.fnl_binder_id;
         END;

         /*THIS WILL BRANCH OUT THE PREOCEDURE*/
         /*IF MAIN CTR = SUB CTR THEN ALL THE BINDERS ARE NEGATATED*/
         /*IF MAIN CTR <> SUB CTR THE BINDER HAS A VALID DIST_NO*/
         BEGIN
            IF v_dist_cntr = v_subctr1
            THEN
               giacs183_pkg.find_all_neg (v_usefnl_binder,
                                          v_usedist_no,
                                          v_useneg_date,
                                          v_from_date,
                                          v_to_date,
                                          v_cut_off_date,
                                          v_fnl_binder
                                         );
               giacs183_pkg.all_neg_insert (v_from_date,
                                            v_to_date,
                                            v_cut_off_date,
                                            p_fund_cd,
                                            p_branch_cd,
                                            p_usetran_date,
                                            v_disb_amt
                                           );
            ELSIF v_dist_cntr <> v_subctr1
            THEN
               giacs183_pkg.find_one_val (v_usefnl_binder,
                                          v_usedist_no,
                                          v_useneg_date,
                                          v_from_date,
                                          v_to_date,
                                          v_cut_off_date,
                                          v_fnl_binder
                                         );
               giacs183_pkg.one_val_insert (v_from_date,
                                            v_to_date,
                                            v_cut_off_date,
                                            p_fund_cd,
                                            p_branch_cd,
                                            v_usefnl_binder,
                                            p_usetran_date,
                                            v_disb_amt
                                           );
            END IF;
         END;
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   PROCEDURE find_all_neg (
      p_usefnl_binder   OUT   giri_binder.fnl_binder_id%TYPE,
      p_usedist_no      OUT   giuw_pol_dist.dist_no%TYPE,
      p_useneg_date     OUT   giuw_pol_dist.negate_date%TYPE,
      p_from_date             DATE,
      p_to_date               DATE,
      p_cut_off_date          DATE,
      p_fnl_binder            giri_frps_ri.fnl_binder_id%TYPE
   )
   IS
   BEGIN
      /*THIS PROCEDURE IS FOR ALL_NEGATED*/
      SELECT e.fnl_binder_id, b.dist_no, TRUNC (b.negate_date)
        INTO p_usefnl_binder, p_usedist_no, p_useneg_date
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
         AND e.fnl_binder_id = p_fnl_binder
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
                    AND e.fnl_binder_id = p_fnl_binder);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   PROCEDURE all_neg_insert (
      p_from_date            DATE,
      p_to_date              DATE,
      p_cut_off_date         DATE,
      p_fund_cd              giac_parameters.param_value_v%TYPE,
      p_branch_cd            giac_parameters.param_value_v%TYPE,
      p_usetran_date   OUT   DATE,
      p_disb_amt       OUT   NUMBER
   )
   IS
   BEGIN
      FOR c IN (SELECT j.assd_name, i.assd_no, e.ri_cd, h.ri_sname,
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
                       a.policy_id, /*a.ref_pol_no,*/ acc_ent_date
                                                                booking_date,
                       (NVL (e.ri_tsi_amt, 0) * NVL (d.currency_rt, 0)
                       ) amt_insured,
                       NVL (m.ri_comm_vat, 0) comm_vat,
                       
                       /*(nvl(e.ri_prem_amt,0)*nvl(d.currency_rt,0))ri_prem_amt,*/
                       (NVL (e.ri_comm_amt, 0) * NVL (d.currency_rt, 0)
                       ) ri_comm_exp,
                       
                       /*ri_comm_amt,*/
                       (  (NVL (e.ri_prem_amt, 0) * NVL (d.currency_rt, 0))
                        - (NVL (e.ri_comm_amt, 0) * NVL (d.currency_rt, 0))
                       ) premium,
                       a.iss_cd, a.prem_amt gross_prem_amt, l.inst_no,
                       l.prem_seq_no,
                       NVL (m.due_date, '22-APR-02') invoice_date
                  FROM gipi_polbasic a,
                       giuw_pol_dist b,
                       giri_frps_ri c,
                       giri_distfrps d,
                       giri_binder e,
                       giis_currency g,
                       giis_reinsurer h,
                       gipi_parlist i,
                       giis_assured j,
                       gipi_installment l,
                       gipi_invoice m                                   --LINA
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
                   AND a.iss_cd = l.iss_cd                              --LINA
                   AND l.prem_seq_no = m.prem_seq_no
                   AND b.policy_id = m.policy_id
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
                        --        AND E.FNL_BINDER_ID NOT IN (SELECT FNL_BINDER_ID
                        --                            FROM GIRI_FRPS_RI
                        --                            HAVING COUNT(FNL_BINDER_ID) > 1
                        --                    GROUP BY FNL_BINDER_ID)
              )
      LOOP
         /*check if the payment is valid within the period through giac_acctrans tran date*/
         BEGIN
            FOR a IN
               (SELECT a.tran_date, NVL (b.disbursement_amt, 0) disburse_amt
                  --into variables.usetran_date, variables.disb_amt
                FROM   giac_acctrans a, giac_outfacul_prem_payts b
                 WHERE a.tran_id = b.gacc_tran_id
                   --and d010_fnl_binder_id = k.fnl_binder_id
                   AND a.tran_date <= p_cut_off_date
                   AND a.tran_flag <> 'D'
                   AND NOT EXISTS (
                          SELECT 'X'
                            FROM giac_reversals gr, giac_acctrans ga
                           WHERE gr.reversing_tran_id = ga.tran_id
                             AND b.gacc_tran_id = ga.tran_id
                             AND ga.tran_flag <> 'D'))                     --;
            LOOP
               p_usetran_date := a.tran_date;
               p_disb_amt := a.disburse_amt;
            END LOOP;

            IF p_disb_amt IS NULL
            THEN
               p_disb_amt := 0;
            END IF;
         --exception
          --when no_data_found then
            -- variables.disb_amt := 0;
         END;

         /*INSERT INTO GIAC_DUETO_ASOF_EXT (ASSD_NO, ASSD_NAME, FUND_CD, BRANCH_CD, RI_CD, RI_NAME, POLICY_ID, POLICY_NO,REF_POL_NO,
                 FNL_BINDER_ID, LINE_CD, BINDER_YY, BINDER_SEQ_NO, BINDER_DATE,
                 BOOKING_DATE, AMT_INSURED, NET_PREMIUM, RI_PREM_AMT, RI_COMM_AMT, CUT_OFF_DATE, FROM_DATE,
                 TO_DATE, USER_ID)*/
         INSERT INTO giac_due_from_ext
                     (fund_cd, branch_cd, ri_cd, ri_sname, assd_no,
                      assd_name, iss_cd, prem_seq_no, inst_no,
                      policy_id, policy_no, amt_insured,
                      gross_prem_amt, ri_comm_exp, from_date,
                      TO_DATE, cut_off_date, booking_date,
                      invoice_date
                     )
               /*VALUES (K.ASSD_NO, K.ASSD_NAME, VARIABLES.V_FUND_CD, VARIABLES.V_BRANCH_CD, K.RI_CD, K.RI_NAME, K.POLICY_ID, K.POLICY_NO,K.REF_POL_NO, K.FNL_BINDER_ID,
              K.LINE_CD, K.BINDER_YY, K.BINDER_SEQ_NO, K.BINDER_DATE, K.BOOKING_DATE, K.AMT_INSURED,
              (K.PREMIUM-variables.disb_amt), K.RI_PREM_AMT, K.RI_COMM_AMT, :misc.CUT_OFF_DATE, :misc.FROM_DATE, :misc.to_DATE, USER);*/
         VALUES      (p_fund_cd, p_branch_cd, c.ri_cd, c.ri_sname, c.assd_no,
                      c.assd_name, c.iss_cd, c.prem_seq_no, c.inst_no,
                      c.policy_id, c.policy_no, c.amt_insured,
                      c.gross_prem_amt, c.ri_comm_exp, p_from_date,
                      p_to_date, p_cut_off_date, c.booking_date,
                      c.invoice_date
                     );
      END LOOP;
   END;

   PROCEDURE find_one_val (
      p_usefnl_binder   OUT   giri_binder.fnl_binder_id%TYPE,
      p_usedist_no      OUT   giuw_pol_dist.dist_no%TYPE,
      p_useneg_date     OUT   giuw_pol_dist.negate_date%TYPE,
      p_from_date             DATE,
      p_to_date               DATE,
      p_cut_off_date          DATE,
      p_fnl_binder            giri_frps_ri.fnl_binder_id%TYPE
   )
   IS
   BEGIN
      /*THIS PROCEDURE IS FOR ONE_VAL*/
      SELECT e.fnl_binder_id, b.dist_no, b.negate_date
        INTO p_usefnl_binder, p_usedist_no, p_useneg_date
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
         AND e.fnl_binder_id = p_fnl_binder
         AND b.dist_flag NOT IN (4, 5);
   END;

   PROCEDURE one_val_insert (
      p_from_date             DATE,
      p_to_date               DATE,
      p_cut_off_date          DATE,
      p_fund_cd               giac_parameters.param_value_v%TYPE,
      p_branch_cd             giac_parameters.param_value_v%TYPE,
      p_usefnl_binder         giri_binder.fnl_binder_id%TYPE,
      p_usetran_date    OUT   DATE,
      p_disb_amt        OUT   NUMBER
   )
   IS
   BEGIN
    --MESSAGE('ONE_VAL_INSERT',ACKNOWLEDGE);
      FOR c IN
         (SELECT j.assd_name, i.assd_no, e.ri_cd, /*DECODE((DECODE(B.DIST_FLAG,4,'K',5,'K',NULL)),'K','K',NULL,NULL), */ h.ri_name,
                 e.line_cd, e.binder_yy, e.binder_seq_no, e.binder_date,
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
        --MESSAGE('INSERT BINDER ID IS '||TO_CHAR(C.FNL_BINDER_ID),ACKNOWLEDGE);
        --MESSAGE('INSERT DIST_NO IS '||TO_CHAR(VARIABLES.USEDIST_NO),ACKNOWLEDGE);

         /*check if the payment is valid within the period through giac_acctrans tran date*/
         BEGIN
            SELECT a.tran_date, NVL (b.disbursement_amt, 0)
              INTO p_usetran_date, p_disb_amt
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
               p_disb_amt := 0;
         END;

         INSERT INTO giac_dueto_asof_ext
                     (assd_no, assd_name, fund_cd, branch_cd,
                      ri_cd, ri_name, policy_id, policy_no,
                      fnl_binder_id, line_cd, binder_yy,
                      binder_seq_no, binder_date, booking_date,
                      amt_insured, net_premium,
                      cut_off_date, from_date, TO_DATE
                     )
              VALUES (c.assd_no, c.assd_name, p_fund_cd, p_branch_cd,
                      c.ri_cd, c.ri_name, c.policy_id, c.policy_no,
                      c.fnl_binder_id, c.line_cd, c.binder_yy,
                      c.binder_seq_no, c.binder_date, c.booking_date,
                      c.amt_insured, (c.premium - p_disb_amt),
                      p_cut_off_date, p_from_date, p_to_date
                     );
      END LOOP;
   END;
END;
/


