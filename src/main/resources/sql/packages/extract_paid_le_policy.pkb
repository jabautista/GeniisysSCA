CREATE OR REPLACE PACKAGE BODY CPI.EXTRACT_PAID_LE_POLICY 
AS
   PROCEDURE extract_all (
      p_session_id       IN   gicl_res_brdrx_extr.session_id%TYPE,
      p_brdrx_rep_type   IN   gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
      p_pd_date_opt      IN   gicl_res_brdrx_extr.pd_date_opt%TYPE,
      p_from_date        IN   gicl_res_brdrx_extr.from_date%TYPE,
      p_to_date          IN   gicl_res_brdrx_extr.TO_DATE%TYPE,
      p_line_cd          IN   gicl_claims.line_cd%TYPE,
      p_subline_cd       IN   gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd       IN   gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy         IN   gicl_claims.issue_yy%TYPE,
      p_pol_seq_no       IN   gicl_claims.pol_seq_no%TYPE,
      p_renew_no         IN   gicl_claims.renew_no%TYPE
   )
   IS
      CURSOR claim_paid
      IS
         SELECT   b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                  (b.ann_tsi_amt * NVL (a.convert_rate, 1)) ann_tsi_amt,
                  DECODE (p_brdrx_rep_type,
                          1, SUM (a.losses_paid) * NVL (a.convert_rate, 1),
                          2, SUM (a.expenses_paid) * NVL (a.convert_rate, 1),
                          NULL
                         ) claims_paid,
                  SUM (a.losses_paid) * NVL (a.convert_rate, 1) losspaid,
                  SUM (a.expenses_paid) * NVL (a.convert_rate, 1)
                                                                 expensepaid,
                  a.clm_loss_id, a.dist_no, f.line_cd, f.subline_cd,
                  f.iss_cd, f.issue_yy, f.pol_seq_no, f.renew_no,
                  TO_NUMBER (TO_CHAR (f.loss_date, 'YYYY')) loss_year,
                  f.assd_no,
                  (   f.line_cd
                   || '-'
                   || f.subline_cd
                   || '-'
                   || f.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (f.clm_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (f.clm_seq_no, '0999999'))
                  ) claim_no,
                  (   f.line_cd
                   || '-'
                   || f.subline_cd
                   || '-'
                   || f.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (f.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (f.renew_no, '09'))
                  ) policy_no,
                  f.dsp_loss_date, f.loss_date, f.clm_file_date,
                  f.pol_eff_date, f.expiry_date, f.pol_iss_cd
             FROM gicl_item_peril b,
                  gicl_clm_res_hist a,
                  giac_acctrans d,
                  gicl_claims f
            WHERE a.peril_cd = b.peril_cd
              AND a.item_no = b.item_no
              AND a.claim_id = b.claim_id
              AND a.tran_id = d.tran_id
              AND b.claim_id = f.claim_id
              AND a.tran_id IS NOT NULL
              AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1 --Edison 05.18.2012
              AND DECODE (a.cancel_tag,
                          'Y', TRUNC (a.cancel_date),
                          p_to_date + 1
                         ) > p_to_date
              AND DECODE (p_pd_date_opt,
                          1, TRUNC (a.date_paid),
                          2, TRUNC (d.posting_date)
                         ) BETWEEN p_from_date AND p_to_date
              AND d.tran_flag != 'D'
              AND f.line_cd = NVL (p_line_cd, f.line_cd)
              AND f.subline_cd = NVL (p_subline_cd, f.subline_cd)
              AND f.pol_iss_cd = NVL (p_pol_iss_cd, f.pol_iss_cd)
              AND f.issue_yy = NVL (p_issue_yy, f.issue_yy)
              AND f.pol_seq_no = NVL (p_pol_seq_no, f.pol_seq_no)
              AND f.renew_no = NVL (p_renew_no, f.renew_no)
              AND clm_stat_cd NOT IN ('WD', 'DN', 'CC')
              AND DECODE (p_brdrx_rep_type,
                          1, NVL (a.losses_paid, 0),
                          2, NVL (a.expenses_paid, 0),
                          1
                         ) > 0
              AND (TRUNC(a.cancel_date) NOT BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                   OR a.cancel_date IS NULL) --Edison 06.05.2012
         GROUP BY b.claim_id,
                  b.item_no,
                  b.peril_cd,
                  b.loss_cat_cd,
                  b.ann_tsi_amt,
                  a.clm_loss_id,
                  a.dist_no,
                  NVL (a.convert_rate, 1),
                  f.claim_id,
                  f.line_cd,
                  f.subline_cd,
                  f.iss_cd,
                  f.issue_yy,
                  f.pol_seq_no,
                  f.renew_no,
                  f.loss_date,
                  f.assd_no,
                  f.clm_yy,
                  f.clm_seq_no,
                  f.pol_iss_cd,
                  f.dsp_loss_date,
                  f.loss_date,
                  f.clm_file_date,
                  f.pol_eff_date,
                  f.expiry_date
         UNION
         SELECT   b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                  (b.ann_tsi_amt * NVL (a.convert_rate, 1)) ann_tsi_amt,
                  DECODE (p_brdrx_rep_type,
                          1, - (SUM (a.losses_paid) * NVL (a.convert_rate, 1)),
                          2, - (SUM (a.expenses_paid)
                                * NVL (a.convert_rate, 1)
                               ),
                          NULL
                         ) claims_paid,
                  -SUM (a.losses_paid) * NVL (a.convert_rate, 1) losspaid,
                  -SUM (a.expenses_paid)
                  * NVL (a.convert_rate, 1) expensepaid, a.clm_loss_id,
                  a.dist_no, f.line_cd, f.subline_cd, f.iss_cd, f.issue_yy,
                  f.pol_seq_no, f.renew_no,
                  TO_NUMBER (TO_CHAR (f.loss_date, 'YYYY')) loss_year,
                  f.assd_no,
                  (   f.line_cd
                   || '-'
                   || f.subline_cd
                   || '-'
                   || f.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (f.clm_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (f.clm_seq_no, '0999999'))
                  ) claim_no,
                  (   f.line_cd
                   || '-'
                   || f.subline_cd
                   || '-'
                   || f.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (f.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (f.renew_no, '09'))
                  ) policy_no,
                  f.dsp_loss_date, f.loss_date, f.clm_file_date,
                  f.pol_eff_date, f.expiry_date, f.pol_iss_cd
             FROM gicl_item_peril b,
                  gicl_clm_res_hist a,
                  giac_acctrans d,
                  giac_reversals e,
                  gicl_claims f
            WHERE a.peril_cd = b.peril_cd
              AND a.item_no = b.item_no
              AND a.claim_id = b.claim_id
              AND a.tran_id = e.gacc_tran_id
              AND d.tran_id = e.reversing_tran_id
              AND b.claim_id = f.claim_id
              AND a.tran_id IS NOT NULL
              AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1 --Edison 05.18.2012
              AND TRUNC (a.date_paid) < p_from_date
              /*Removed by: Jen.20121017
              **should check first the date option used to determine 
              **whether posting date or cancel date (tran date) will be
              **checked if within date parameters.*/
              --AND TRUNC (d.posting_date) BETWEEN p_from_date AND p_to_date 
              AND f.line_cd = NVL (p_line_cd, f.line_cd)
              AND f.subline_cd = NVL (p_subline_cd, f.subline_cd)
              AND f.pol_iss_cd = NVL (p_pol_iss_cd, f.pol_iss_cd)
              AND f.issue_yy = NVL (p_issue_yy, f.issue_yy)
              AND f.pol_seq_no = NVL (p_pol_seq_no, f.pol_seq_no)
              AND f.renew_no = NVL (p_renew_no, f.renew_no)
            --AND clm_stat_cd NOT IN ('WD', 'DN', 'CC')		--commented out by MJ 03/08/2013. Confirmed with Ms Jen.
            --AND (TRUNC(a.cancel_date) NOT BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                 --OR a.cancel_date IS NULL) --Edison 06.05.2012  --comment out jcDY 10.04.2012 to query cancelled transactions
              /*Added by: jen.20121017
              **(1) should consider date option first before extracting
              **cancelled payments
              **(2) include checking of cancel_tag since this will query cancelled payments
              **for the month*/
              AND DECODE (p_pd_date_opt,
                          1,  TRUNC(a.cancel_date),
                          2, TRUNC (d.posting_date))
                          BETWEEN p_from_date AND p_to_date
              and (cancel_tag <> 'N' and cancel_tag is not null)
         GROUP BY b.claim_id,
                  b.item_no,
                  b.peril_cd,
                  b.loss_cat_cd,
                  b.ann_tsi_amt,
                  a.clm_loss_id,
                  a.dist_no,
                  NVL (a.convert_rate, 1),
                  f.claim_id,
                  f.line_cd,
                  f.subline_cd,
                  f.iss_cd,
                  f.issue_yy,
                  f.pol_seq_no,
                  f.renew_no,
                  f.loss_date,
                  f.assd_no,
                  f.clm_yy,
                  f.clm_seq_no,
                  f.pol_iss_cd,
                  f.dsp_loss_date,
                  f.loss_date,
                  f.clm_file_date,
                  f.pol_eff_date,
                  f.expiry_date
         ORDER BY 1;
   BEGIN
      FOR paid_rec IN claim_paid ()
      LOOP
         BEGIN
            v_brdrx_record_id := v_brdrx_record_id + 1;

            IF p_brdrx_rep_type = 1 AND ABS(paid_rec.losspaid) > 0  /*added by: jcDY 10/17/2012
                                                                   **Added ABS function in paid_rec.losspaid
                                                                   **to insert cancelled amounts(negative) in
                                                                   **the extraction table(gicl_res_brdrx_extr)*/  
            THEN                                -- Modified by Marlo 02162010
               INSERT INTO gicl_res_brdrx_extr
                           (session_id, brdrx_record_id,
                            claim_id, iss_cd,
                            line_cd, subline_cd,
                            loss_year, assd_no,
                            claim_no, policy_no,
                            loss_date, clm_file_date,
                            item_no, peril_cd,
                            loss_cat_cd, incept_date,
                            expiry_date, tsi_amt,
                            clm_loss_id, losses_paid,
                            dist_no, user_id, last_update, extr_type,
                            brdrx_type, brdrx_rep_type, pd_date_opt,
                            from_date, TO_DATE, pol_iss_cd,
                            issue_yy, pol_seq_no,
                            renew_no, policy_tag
                           )
                    VALUES (p_session_id, v_brdrx_record_id,
                            paid_rec.claim_id, paid_rec.iss_cd,
                            paid_rec.line_cd, paid_rec.subline_cd,
                            paid_rec.loss_year, paid_rec.assd_no,
                            paid_rec.claim_no, paid_rec.policy_no,
                            paid_rec.dsp_loss_date, paid_rec.clm_file_date,
                            paid_rec.item_no, paid_rec.peril_cd,
                            paid_rec.loss_cat_cd, paid_rec.pol_eff_date,
                            paid_rec.expiry_date, paid_rec.ann_tsi_amt,
                            paid_rec.clm_loss_id, paid_rec.claims_paid,
                            paid_rec.dist_no, USER, SYSDATE, 1,
                            2, p_brdrx_rep_type, p_pd_date_opt,
                            p_from_date, p_to_date, paid_rec.pol_iss_cd,
                            paid_rec.issue_yy, paid_rec.pol_seq_no,
                            paid_rec.renew_no, 1
                           );
            ELSIF p_brdrx_rep_type = 2 AND ABS(paid_rec.expensepaid) > 0  /*added by: jcDY 10/17/2012
                                                                   **Added ABS function in paid_rec.losspaid
                                                                   **to insert cancelled amounts(negative) in
                                                                   **the extraction table(gicl_res_brdrx_extr)*/  
            THEN                                 -- Modified by Marlo 02162010
               INSERT INTO gicl_res_brdrx_extr
                           (session_id, brdrx_record_id,
                            claim_id, iss_cd,
                            line_cd, subline_cd,
                            loss_year, assd_no,
                            claim_no, policy_no,
                            loss_date, clm_file_date,
                            item_no, peril_cd,
                            loss_cat_cd, incept_date,
                            expiry_date, tsi_amt,
                            clm_loss_id, expenses_paid,
                            dist_no, user_id, last_update, extr_type,
                            brdrx_type, brdrx_rep_type, pd_date_opt,
                            from_date, TO_DATE, pol_iss_cd,
                            issue_yy, pol_seq_no,
                            renew_no, policy_tag
                           )
                    VALUES (p_session_id, v_brdrx_record_id,
                            paid_rec.claim_id, paid_rec.iss_cd,
                            paid_rec.line_cd, paid_rec.subline_cd,
                            paid_rec.loss_year, paid_rec.assd_no,
                            paid_rec.claim_no, paid_rec.policy_no,
                            paid_rec.dsp_loss_date, paid_rec.clm_file_date,
                            paid_rec.item_no, paid_rec.peril_cd,
                            paid_rec.loss_cat_cd, paid_rec.pol_eff_date,
                            paid_rec.expiry_date, paid_rec.ann_tsi_amt,
                            paid_rec.clm_loss_id, paid_rec.claims_paid,
                            paid_rec.dist_no, USER, SYSDATE, 1,
                            2, p_brdrx_rep_type, p_pd_date_opt,
                            p_from_date, p_to_date, paid_rec.pol_iss_cd,
                            paid_rec.issue_yy, paid_rec.pol_seq_no,
                            paid_rec.renew_no, 1
                           );
            ELSIF p_brdrx_rep_type = 3
            THEN
               INSERT INTO gicl_res_brdrx_extr
                           (session_id, brdrx_record_id,
                            claim_id, iss_cd,
                            line_cd, subline_cd,
                            loss_year, assd_no,
                            claim_no, policy_no,
                            loss_date, clm_file_date,
                            item_no, peril_cd,
                            loss_cat_cd, incept_date,
                            expiry_date, tsi_amt,
                            clm_loss_id, losses_paid,
                            expenses_paid, dist_no, user_id,
                            last_update, extr_type, brdrx_type,
                            brdrx_rep_type, pd_date_opt, from_date,
                            TO_DATE, pol_iss_cd,
                            issue_yy, pol_seq_no,
                            renew_no, policy_tag
                           )
                    VALUES (p_session_id, v_brdrx_record_id,
                            paid_rec.claim_id, paid_rec.iss_cd,
                            paid_rec.line_cd, paid_rec.subline_cd,
                            paid_rec.loss_year, paid_rec.assd_no,
                            paid_rec.claim_no, paid_rec.policy_no,
                            paid_rec.dsp_loss_date, paid_rec.clm_file_date,
                            paid_rec.item_no, paid_rec.peril_cd,
                            paid_rec.loss_cat_cd, paid_rec.pol_eff_date,
                            paid_rec.expiry_date, paid_rec.ann_tsi_amt,
                            paid_rec.clm_loss_id, paid_rec.losspaid,
                            paid_rec.expensepaid, paid_rec.dist_no, USER,
                            SYSDATE, 1, 2,
                            p_brdrx_rep_type, p_pd_date_opt, p_from_date,
                            p_to_date, paid_rec.pol_iss_cd,
                            paid_rec.issue_yy, paid_rec.pol_seq_no,
                            paid_rec.renew_no, 1
                           );
            END IF;
         END;
      END LOOP;

      COMMIT;
   END extract_all;

   
   PROCEDURE extract_distribution (
   /*added date parameters by Edison 06.05.2012, to be used in condition of cancel_date.
   **Cancel date must not be between the date parameters*/
      p_session_id       IN   gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_brdrx_rep_type   IN   gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
      p_from_date        IN   gicl_res_brdrx_extr.from_date%TYPE,
      p_to_date          IN   gicl_res_brdrx_extr.TO_DATE%TYPE
   --end of added code 06.05.2012
   )
   IS
      CURSOR brdrx_extr_paid_ds(brdrx_extr_session_id IN 
                                gicl_res_brdrx_ds_extr.session_id%TYPE) IS
SELECT   a.claim_id, a.item_no, a.peril_cd, a.clm_loss_id, a.grp_seq_no,
         a.shr_loss_exp_pct,         
         /*modified by Edison 04.13.2012, changed payee_type to get_payee_type(b.claim_id, 
         **b.clm_loss_id changed also b.currency_rate to b.convert_rate*/
         DECODE
            (get_payee_type (b.claim_id, b.clm_loss_id),
             'L', DECODE (p_brdrx_rep_type,
                          1, SUM (  a.shr_le_net_amt
                                  * NVL (b.convert_rate /*b.currency_rate*/,
                                         1)
                                 ),
                          3, SUM (  a.shr_le_net_amt
                                  * NVL (b.convert_rate /*b.currency_rate*/,
                                         1)
                                 ),
                          NULL
                         ),
             0
            ) losses_paid,
         DECODE
            (get_payee_type (b.claim_id, b.clm_loss_id),
             'E', DECODE (p_brdrx_rep_type,
                          2, SUM (  a.shr_le_net_amt
                                  * NVL (b.convert_rate /*b.currency_rate*/,
                                         1)
                                 ),
                          3, SUM (  a.shr_le_net_amt
                                  * NVL (b.convert_rate /*b.currency_rate*/,
                                         1)
                                 ),
                          NULL
                         ),
             0
            ) expenses_paid,         
--end of modification 04.13.2012
         a.clm_dist_no, c.brdrx_record_id, c.iss_cd, c.buss_source, c.line_cd,
         c.subline_cd, c.loss_year, c.loss_cat_cd,
         c.losses_paid brdrx_extr_losses_paid,
         c.expenses_paid brdrx_extr_expenses_paid
    FROM gicl_loss_exp_ds a, gicl_clm_res_hist b,
         --gicl_clm_loss_exp b, --changed by Edison 04.13.2012 to gicl_clm_res_hist
         gicl_res_brdrx_extr c
   WHERE c.session_id = brdrx_extr_session_id
     AND a.claim_id = c.claim_id
     AND a.item_no = c.item_no
     AND a.peril_cd = c.peril_cd
     AND a.clm_dist_no = c.dist_no
     AND a.clm_loss_id = c.clm_loss_id
     AND a.claim_id = b.claim_id
     AND a.clm_loss_id = b.clm_loss_id
     AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1 --Edison 05.18.2012
     /*added by: jcDY 10/19/2012
    **exclude cancelled distributions*/
	/* Commented out by MJ 03/08/2013. Confirmed with Ms Jen.
     AND DECODE (b.cancel_tag,
                         'Y', TRUNC (b.cancel_date),
                        p_to_date + 1
                       ) > p_to_date
     AND (TRUNC(b.cancel_date) NOT BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                   OR b.cancel_date IS NULL)
    */
GROUP BY a.claim_id,
         a.item_no,
         a.peril_cd,
         a.clm_loss_id,
         a.grp_seq_no,
         a.shr_loss_exp_pct,
         a.clm_dist_no,
         get_payee_type (b.claim_id, b.clm_loss_id),--modified by Edison04.13.2012 from payee_type
         c.brdrx_record_id,
         c.iss_cd,
         c.buss_source,
         c.line_cd,
         c.subline_cd,
         c.loss_year,
         c.loss_cat_cd,
         c.losses_paid,
         c.expenses_paid;

      CURSOR paid_rids (
         paid_rids_claim_id        IN   gicl_loss_exp_rids.claim_id%TYPE,
         paid_rids_item_no         IN   gicl_loss_exp_rids.item_no%TYPE,
         paid_rids_peril_cd        IN   gicl_loss_exp_rids.peril_cd%TYPE,
         paid_rids_clm_loss_id     IN   gicl_loss_exp_rids.clm_loss_id%TYPE,
         paid_rids_clm_dist_no     IN   gicl_loss_exp_rids.clm_dist_no%TYPE,
         paid_rids_grp_seq_no      IN   gicl_loss_exp_rids.grp_seq_no%TYPE,
         paid_rids_shr_pct_ds      IN   gicl_loss_exp_rids.shr_loss_exp_ri_pct%TYPE,
         paid_rids_losses_paid     IN   gicl_res_brdrx_rids_extr.losses_paid%TYPE,
         paid_rids_expenses_paid   IN   gicl_res_brdrx_rids_extr.expenses_paid%TYPE
      )
      IS
SELECT   a.claim_id, a.ri_cd, a.prnt_ri_cd,
         a.shr_loss_exp_ri_pct shr_ri_pct_real,         
         --modified by Edison04.13.2012, change b.currency_rate to b.convert_rate
         DECODE (p_brdrx_rep_type,
                 1, SUM (  a.shr_le_ri_net_amt
                         * NVL (b.convert_rate /*b.currency_rate*/, 1)
                        ),
                 3, SUM (  a.shr_le_ri_net_amt
                         * NVL (b.convert_rate /*b.currency_rate*/, 1)
                        ),
                 NULL
                ) losses_paid,
         DECODE (p_brdrx_rep_type,
                 2, SUM (  a.shr_le_ri_net_amt
                         * NVL (b.convert_rate /*b.currency_rate*/, 1)
                        ),
                 3, SUM (  a.shr_le_ri_net_amt
                         * NVL (b.convert_rate /*b.currency_rate*/, 1)
                        ),
                 NULL
                ) expenses_paid
    --end of modification
FROM     gicl_loss_exp_rids a,
         gicl_clm_res_hist b,--gicl_clm_loss_exp b --changed by Edison 04.13.2012 to gicl_clm_res_hist
         gicl_claims c --Edison 05.18.2012
   WHERE a.claim_id = paid_rids_claim_id
     AND a.item_no = paid_rids_item_no
     AND a.peril_cd = paid_rids_peril_cd
     AND a.clm_loss_id = paid_rids_clm_loss_id
     AND a.clm_dist_no = paid_rids_clm_dist_no
     AND a.grp_seq_no = paid_rids_grp_seq_no
     AND a.claim_id = b.claim_id
     AND a.clm_loss_id = b.clm_loss_id
     AND a.claim_id = c.claim_id --Edison 05.18.2012
     AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1 --Edison 05.18.2012
     /*added by: jcDY 10/19/2012
    **exclude cancelled distributions*/
	/* Commented out by MJ 03/08/2013. Confirmed with Ms Jen.
     AND DECODE (b.cancel_tag,
                         'Y', TRUNC (b.cancel_date),
                        p_to_date + 1
                       ) > p_to_date
     AND (TRUNC(b.cancel_date) NOT BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                   OR b.cancel_date IS NULL)
	*/
GROUP BY a.claim_id, a.ri_cd, a.prnt_ri_cd, a.shr_loss_exp_ri_pct;


   BEGIN
      FOR paid_ds_rec IN brdrx_extr_paid_ds (p_session_id)
      LOOP
         BEGIN
            IF     SIGN (NVL (paid_ds_rec.brdrx_extr_losses_paid, 0)) <> 1
               AND SIGN (NVL (paid_ds_rec.losses_paid, 0)) = 1
            THEN
               paid_ds_rec.losses_paid := -paid_ds_rec.losses_paid;
            END IF;

            IF     SIGN (NVL (paid_ds_rec.brdrx_extr_expenses_paid, 0)) <> 1
               AND SIGN (NVL (paid_ds_rec.expenses_paid, 0)) = 1
            THEN
               paid_ds_rec.expenses_paid := -paid_ds_rec.expenses_paid;
            END IF;

            v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;

            INSERT INTO gicl_res_brdrx_ds_extr
                        (session_id, brdrx_record_id,
                         brdrx_ds_record_id, claim_id,
                         iss_cd, buss_source,
                         line_cd, subline_cd,
                         loss_year, item_no,
                         peril_cd, loss_cat_cd,
                         grp_seq_no,
                         shr_pct,
                         losses_paid, expenses_paid,
                         user_id, last_update
                        )
                 VALUES (p_session_id, paid_ds_rec.brdrx_record_id,
                         v_brdrx_ds_record_id, paid_ds_rec.claim_id,
                         paid_ds_rec.iss_cd, paid_ds_rec.buss_source,
                         paid_ds_rec.line_cd, paid_ds_rec.subline_cd,
                         paid_ds_rec.loss_year, paid_ds_rec.item_no,
                         paid_ds_rec.peril_cd, paid_ds_rec.loss_cat_cd,
                         paid_ds_rec.grp_seq_no,
                         paid_ds_rec.shr_loss_exp_pct,
                         paid_ds_rec.losses_paid, paid_ds_rec.expenses_paid,
                         USER, SYSDATE
                        );
         END;

         FOR paid_rids_rec IN paid_rids (paid_ds_rec.claim_id,
                                         paid_ds_rec.item_no,
                                         paid_ds_rec.peril_cd,
                                         paid_ds_rec.clm_loss_id,
                                         paid_ds_rec.clm_dist_no,
                                         paid_ds_rec.grp_seq_no,
                                         paid_ds_rec.shr_loss_exp_pct,
                                         paid_ds_rec.losses_paid,
                                         paid_ds_rec.expenses_paid
                                        )
         LOOP
            BEGIN
               IF     SIGN (NVL (paid_ds_rec.losses_paid, 0)) <> 1
                  AND SIGN (NVL (paid_rids_rec.losses_paid, 0)) = 1
               THEN
                  paid_rids_rec.losses_paid := -paid_rids_rec.losses_paid;
               END IF;

               IF     SIGN (NVL (paid_ds_rec.expenses_paid, 0)) <> 1
                  AND SIGN (NVL (paid_rids_rec.expenses_paid, 0)) = 1
               THEN
                  paid_rids_rec.expenses_paid := -paid_rids_rec.expenses_paid;
               END IF;

               v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;

               INSERT INTO gicl_res_brdrx_rids_extr
                           (session_id, brdrx_ds_record_id,
                            brdrx_rids_record_id, claim_id,
                            iss_cd, buss_source,
                            line_cd, subline_cd,
                            loss_year, item_no,
                            peril_cd, loss_cat_cd,
                            grp_seq_no, ri_cd,
                            prnt_ri_cd,
                            shr_ri_pct,
                            losses_paid,
                            expenses_paid, user_id, last_update
                           )
                    VALUES (p_session_id, v_brdrx_ds_record_id,
                            v_brdrx_rids_record_id, paid_ds_rec.claim_id,
                            paid_ds_rec.iss_cd, paid_ds_rec.buss_source,
                            paid_ds_rec.line_cd, paid_ds_rec.subline_cd,
                            paid_ds_rec.loss_year, paid_ds_rec.item_no,
                            paid_ds_rec.peril_cd, paid_ds_rec.loss_cat_cd,
                            paid_ds_rec.grp_seq_no, paid_rids_rec.ri_cd,
                            paid_rids_rec.prnt_ri_cd,
                            paid_rids_rec.shr_ri_pct_real,
                            paid_rids_rec.losses_paid,
                            paid_rids_rec.expenses_paid, USER, SYSDATE
                           );
            END;
         END LOOP;
      END LOOP;

      COMMIT;
   END extract_distribution;

   PROCEDURE reset_record_id
   IS
   BEGIN
      v_brdrx_record_id := 0;
      v_brdrx_ds_record_id := 0;
      v_brdrx_rids_record_id := 0;
   END reset_record_id;
END extract_paid_le_policy;
/


