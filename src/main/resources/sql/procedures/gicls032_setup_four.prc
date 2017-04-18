DROP PROCEDURE CPI.GICLS032_SETUP_FOUR;

CREATE OR REPLACE PROCEDURE CPI.gicls032_setup_four (
   p_claim_id         gicl_advice.claim_id%TYPE,
   p_advice_id        gicl_advice.advice_id%TYPE,
   p_line_cd     gicl_claims.line_cd%TYPE,
   p_payee_class_cd   gicl_clm_loss_exp.payee_class_cd%TYPE,
   p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE,
   p_variables        gicl_advice_pkg.gicls032_variables
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - setup_four
   */   

   /*
   **  For Unpaid Losses
   **  populate GICL_ACCT_ENTRIES
   */
   CURSOR mbc
   IS
      (SELECT a.payee_type
         FROM gicl_clm_loss_exp a
        WHERE claim_id = p_claim_id AND advice_id = p_advice_id);

   /*
   ** fetch amount of disbursement -- entry for LOSSES and EXPENSES PAID
   */
   CURSOR dlpl
   IS
      (SELECT   MAX (a.take_up_hist) hist,
                a.os_loss * DECODE (b.currency_cd, p_variables.v_local_currency, 1, NVL (c.orig_curr_rate, c.convert_rate)) disbmt_amt,
                a.peril_cd, b.payee_class_cd, b.payee_cd                                                        --, b.clm_loss_id
           FROM gicl_take_up_hist a, gicl_clm_loss_exp b, gicl_advice c
          WHERE a.claim_id = b.claim_id
            AND a.item_no = b.item_no
            AND a.peril_cd = b.peril_cd
            AND b.claim_id = c.claim_id
            AND b.advice_id = c.advice_id
            AND a.take_up_type = 'N'
            AND c.iss_cd <> p_variables.v_ri_iss_cd
            AND c.claim_id = p_claim_id
            AND c.advice_id = p_advice_id
            AND b.payee_class_cd = p_payee_class_cd
            AND b.payee_cd = p_payee_cd
       GROUP BY a.os_loss,
                a.peril_cd,
                b.payee_class_cd,
                b.payee_cd,
                b.currency_cd,
                NVL (c.orig_curr_rate, NVL (c.orig_curr_rate, c.convert_rate)));                               --, b.clm_loss_id);

   CURSOR rlpl
   IS
      (SELECT   MAX (a.take_up_hist) hist,
                a.os_loss * DECODE (b.currency_cd, p_variables.v_local_currency, 1, NVL (c.orig_curr_rate, c.convert_rate)) disbmt_amt,
                a.peril_cd, b.payee_class_cd, b.payee_cd                                                         --, b.clm_loss_id
           FROM gicl_take_up_hist a, gicl_clm_loss_exp b, gicl_advice c
          WHERE a.claim_id = b.claim_id
            AND a.item_no = b.item_no
            AND a.peril_cd = b.peril_cd
            AND b.claim_id = c.claim_id
            AND b.advice_id = c.advice_id
            AND a.take_up_type = 'N'
            AND c.iss_cd = p_variables.v_ri_iss_cd
            AND c.claim_id = p_claim_id
            AND c.advice_id = p_advice_id
            AND b.payee_class_cd = p_payee_class_cd
            AND b.payee_cd = p_payee_cd
       GROUP BY a.os_loss, a.peril_cd, b.payee_class_cd, b.payee_cd, b.currency_cd, NVL (c.orig_curr_rate, c.convert_rate));

   --, b.clm_loss_id);
   CURSOR dlpe
   IS
      (SELECT   MAX (a.take_up_hist) hist,
                a.os_expense * DECODE (b.currency_cd, p_variables.v_local_currency, 1, NVL (c.orig_curr_rate, c.convert_rate)) disbmt_amt,
                a.peril_cd, b.payee_class_cd, b.payee_cd                                                         --, b.clm_loss_id
           FROM gicl_take_up_hist a, gicl_clm_loss_exp b, gicl_advice c
          WHERE a.claim_id = b.claim_id
            AND a.item_no = b.item_no
            AND a.peril_cd = b.peril_cd
            AND b.claim_id = c.claim_id
            AND b.advice_id = c.advice_id
            AND a.take_up_type = 'N'
            AND c.iss_cd <> p_variables.v_ri_iss_cd
            AND c.claim_id = p_claim_id
            AND c.advice_id = p_advice_id
            AND b.payee_class_cd = p_payee_class_cd
            AND b.payee_cd = p_payee_cd
       GROUP BY a.os_expense, a.peril_cd, b.payee_class_cd, b.payee_cd, b.currency_cd, NVL (c.orig_curr_rate, c.convert_rate));

   --, b.clm_loss_id);
   CURSOR rlpe
   IS
      (SELECT   MAX (a.take_up_hist) hist,
                a.os_expense * DECODE (b.currency_cd, p_variables.v_local_currency, 1, NVL (c.orig_curr_rate, c.convert_rate)) disbmt_amt,
                a.peril_cd, b.payee_class_cd, b.payee_cd                                                         --, b.clm_loss_id
           FROM gicl_take_up_hist a, gicl_clm_loss_exp b, gicl_advice c
          WHERE a.claim_id = b.claim_id
            AND a.item_no = b.item_no
            AND a.peril_cd = b.peril_cd
            AND b.claim_id = c.claim_id
            AND b.advice_id = c.advice_id
            AND a.take_up_type = 'N'
            AND c.iss_cd = p_variables.v_ri_iss_cd
            AND c.claim_id = p_claim_id
            AND c.advice_id = p_advice_id
            AND b.payee_class_cd = p_payee_class_cd
            AND b.payee_cd = p_payee_cd
       GROUP BY a.os_expense, a.peril_cd, b.payee_class_cd, b.payee_cd, b.currency_cd, NVL (c.orig_curr_rate, c.convert_rate));

   --, b.clm_loss_id);
   CURSOR dnlpl
   IS
      (SELECT   MAX (a.take_up_hist) hist,
                  d.shr_loss_res_amt
                * DECODE (b.currency_cd, p_variables.v_local_currency, 1, NVL (c.orig_curr_rate, c.convert_rate)) disbmt_amt,
                a.peril_cd, b.payee_class_cd, b.payee_cd                                                         --, b.clm_loss_id
           FROM gicl_take_up_hist a, gicl_clm_res_hist e, gicl_reserve_ds d, gicl_clm_loss_exp b, gicl_advice c
          WHERE a.claim_id = e.claim_id
            AND a.clm_res_hist_id = e.clm_res_hist_id
            AND e.claim_id = d.claim_id
            AND e.clm_res_hist_id = d.clm_res_hist_id
            AND e.claim_id = b.claim_id
            AND e.item_no = b.item_no
            AND e.peril_cd = b.peril_cd
            AND b.claim_id = c.claim_id
            AND b.advice_id = c.advice_id
            AND NVL (d.negate_tag, 'N') = 'N'
            AND a.take_up_type = 'N'
            AND d.share_type = 1
            AND c.iss_cd <> p_variables.v_ri_iss_cd
            AND c.claim_id = p_claim_id
            AND c.advice_id = p_advice_id
            AND b.payee_class_cd = p_payee_class_cd
            AND b.payee_cd = p_payee_cd
       GROUP BY d.shr_loss_res_amt,
                a.peril_cd,
                b.payee_class_cd,
                b.payee_cd,
                b.currency_cd,
                NVL (c.orig_curr_rate, c.convert_rate));                                                       --, b.clm_loss_id);

   CURSOR rnlpl
   IS
      (SELECT   MAX (a.take_up_hist) hist,
                  d.shr_loss_res_amt
                * DECODE (b.currency_cd, p_variables.v_local_currency, 1, NVL (c.orig_curr_rate, c.convert_rate)) disbmt_amt,
                a.peril_cd, b.payee_class_cd, b.payee_cd                                                         --, b.clm_loss_id
           FROM gicl_take_up_hist a, gicl_clm_res_hist e, gicl_reserve_ds d, gicl_clm_loss_exp b, gicl_advice c
          WHERE a.claim_id = e.claim_id
            AND a.clm_res_hist_id = e.clm_res_hist_id
            AND e.claim_id = d.claim_id
            AND e.clm_res_hist_id = d.clm_res_hist_id
            AND e.claim_id = b.claim_id
            AND e.item_no = b.item_no
            AND e.peril_cd = b.peril_cd
            AND b.claim_id = c.claim_id
            AND b.advice_id = c.advice_id
            AND NVL (d.negate_tag, 'N') = 'N'
            AND a.take_up_type = 'N'
            AND d.share_type = 1
            AND c.iss_cd = p_variables.v_ri_iss_cd
            AND c.claim_id = p_claim_id
            AND c.advice_id = p_advice_id
            AND b.payee_class_cd = p_payee_class_cd
            AND b.payee_cd = p_payee_cd
       GROUP BY d.shr_loss_res_amt,
                a.peril_cd,
                b.payee_class_cd,
                b.payee_cd,
                b.currency_cd,
                NVL (c.orig_curr_rate, c.convert_rate));                                                       --, b.clm_loss_id);

   CURSOR dnlpe
   IS
      (SELECT   MAX (a.take_up_hist) hist,
                d.shr_exp_res_amt
                * DECODE (b.currency_cd, p_variables.v_local_currency, 1, NVL (c.orig_curr_rate, c.convert_rate)) disbmt_amt, a.peril_cd,
                b.payee_class_cd, b.payee_cd                                                                     --, b.clm_loss_id
           FROM gicl_take_up_hist a, gicl_clm_res_hist e, gicl_reserve_ds d, gicl_clm_loss_exp b, gicl_advice c
          WHERE a.claim_id = e.claim_id
            AND a.clm_res_hist_id = e.clm_res_hist_id
            AND e.claim_id = d.claim_id
            AND e.clm_res_hist_id = d.clm_res_hist_id
            AND e.claim_id = b.claim_id
            AND e.item_no = b.item_no
            AND e.peril_cd = b.peril_cd
            AND b.claim_id = c.claim_id
            AND b.advice_id = c.advice_id
            AND NVL (d.negate_tag, 'N') = 'N'
            AND a.take_up_type = 'N'
            AND d.share_type = 1
            AND c.iss_cd <> p_variables.v_ri_iss_cd
            AND c.claim_id = p_claim_id
            AND c.advice_id = p_advice_id
            AND b.payee_class_cd = p_payee_class_cd
            AND b.payee_cd = p_payee_cd
       GROUP BY d.shr_exp_res_amt, a.peril_cd, b.payee_class_cd, b.payee_cd, b.currency_cd,
                NVL (c.orig_curr_rate, c.convert_rate));                                                       --, b.clm_loss_id);

   CURSOR rnlpe
   IS
      (SELECT   MAX (a.take_up_hist) hist,
                d.shr_exp_res_amt
                * DECODE (b.currency_cd, p_variables.v_local_currency, 1, NVL (c.orig_curr_rate, c.convert_rate)) disbmt_amt, a.peril_cd,
                b.payee_class_cd, b.payee_cd                                                                     --, b.clm_loss_id
           FROM gicl_take_up_hist a, gicl_clm_res_hist e, gicl_reserve_ds d, gicl_clm_loss_exp b, gicl_advice c
          WHERE a.claim_id = e.claim_id
            AND a.clm_res_hist_id = e.clm_res_hist_id
            AND e.claim_id = d.claim_id
            AND e.clm_res_hist_id = d.clm_res_hist_id
            AND e.claim_id = b.claim_id
            AND e.item_no = b.item_no
            AND e.peril_cd = b.peril_cd
            AND b.claim_id = c.claim_id
            AND b.advice_id = c.advice_id
            AND NVL (d.negate_tag, 'N') = 'N'
            AND a.take_up_type = 'N'
            AND d.share_type = 1
            AND c.iss_cd = p_variables.v_ri_iss_cd
            AND c.claim_id = p_claim_id
            AND c.advice_id = p_advice_id
            AND b.payee_class_cd = p_payee_class_cd
            AND b.payee_cd = p_payee_cd
       GROUP BY d.shr_exp_res_amt, a.peril_cd, b.payee_class_cd, b.payee_cd, b.currency_cd,
                NVL (c.orig_curr_rate, c.convert_rate));                                                       --, b.clm_loss_id);

   /*
   **RI SHARE ON UNPAID LOSSES (break on reinsurer)
   ** share_type = '2' for 'TREATY'; '3' for 'FACULTATIVE'
   */
   CURSOR risri
   IS
      (SELECT   MAX (a.take_up_hist) hist,
                  (d.shr_loss_ri_res_amt + d.shr_exp_ri_res_amt)
                * DECODE (b.currency_cd, p_variables.v_local_currency, 1, NVL (c.orig_curr_rate, c.convert_rate)) disbmt_amt,
                
                --b.clm_loss_id,
                d.acct_trty_type, d.line_cd, d.grp_seq_no, d.ri_cd, d.share_type, b.payee_class_cd, b.payee_cd
           FROM gicl_take_up_hist a,
                gicl_clm_res_hist e,
                gicl_reserve_ds f,
                gicl_reserve_rids d,
                gicl_clm_loss_exp b,
                gicl_advice c
          WHERE a.claim_id = e.claim_id
            AND a.clm_res_hist_id = e.clm_res_hist_id
            AND e.claim_id = f.claim_id
            AND e.clm_res_hist_id = f.clm_res_hist_id
            AND f.claim_id = d.claim_id
            AND f.clm_res_hist_id = d.clm_res_hist_id
            AND f.clm_dist_no = d.clm_dist_no
            AND f.grp_seq_no = d.grp_seq_no
            AND e.claim_id = b.claim_id
            AND e.item_no = b.item_no
            AND e.peril_cd = b.peril_cd
            AND b.claim_id = c.claim_id
            AND b.advice_id = c.advice_id
            AND NVL (f.negate_tag, 'N') = 'N'
            AND a.take_up_type = 'N'
            AND c.claim_id = p_claim_id
            AND c.advice_id = p_advice_id
            AND b.payee_class_cd = p_payee_class_cd
            AND b.payee_cd = p_payee_cd
       GROUP BY (d.shr_loss_ri_res_amt + d.shr_exp_ri_res_amt),
                a.peril_cd,
                --b.clm_loss_id,
                d.acct_trty_type,
                d.line_cd,
                d.grp_seq_no,
                d.ri_cd,
                d.share_type,
                b.payee_class_cd,
                b.payee_cd,
                b.currency_cd,
                NVL (c.orig_curr_rate, c.convert_rate));

   dismt                    giac_direct_claim_payts.disbursement_amt%TYPE;
   sum_deb                  gicl_acct_entries.debit_amt%TYPE;
   ws_misc_entries          giac_direct_claim_payts.disbursement_amt%TYPE;
   v_item_no                NUMBER;
BEGIN
   /*
   ** Call the deletion of accounting entry procedure.
   */
   --
   -- AEG_Delete_Acct_Entries;
   --

   /*
   ** Call the accounting entry generation procedure.
    */
   FOR mbc_rec IN mbc
   LOOP
      IF mbc_rec.payee_type = 'L'
      THEN
         FOR dlpl_rec IN dlpl
         LOOP
            v_item_no := 9;                                                                    /* for CLAIMS AND LOSSES PAYABLE*/
            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          dlpl_rec.peril_cd,
                                          p_variables.os_module_id,
                                          v_item_no,
                                          p_line_cd,
                                          NULL,
                                          dlpl_rec.disbmt_amt,
                                          --dlpl_rec.clm_loss_id   ,
                                          dlpl_rec.payee_class_cd,
                                          dlpl_rec.payee_cd,
                                          p_variables.v_gen_type,
                                          NULL
                                         );
         END LOOP;

         FOR rlpl_rec IN rlpl
         LOOP
            v_item_no := 9;                                                         /* for LOSSES AND CLAIMS PAYABLE TO FAC RI */
            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          rlpl_rec.peril_cd,
                                          p_variables.os_module_id,
                                          v_item_no,
                                          p_line_cd,
                                          NULL,
                                          rlpl_rec.disbmt_amt,
                                          --rlpl_rec.clm_loss_id   ,
                                          rlpl_rec.payee_class_cd,
                                          rlpl_rec.payee_cd,
                                          p_variables.v_gen_type,
                                          NULL
                                         );
         END LOOP;

         FOR dnlpl_rec IN dnlpl
         LOOP
            v_item_no := 13;                                  /* for DECREASE IN RESERVE FOR CLAIMS AND LOSSES PAYABLE - DIRECT*/
            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          dnlpl_rec.peril_cd,
                                          p_variables.os_module_id,
                                          v_item_no,
                                          p_line_cd,
                                          NULL,
                                          dnlpl_rec.disbmt_amt,
                                          --dnlpl_rec.clm_loss_id   ,
                                          dnlpl_rec.payee_class_cd,
                                          dnlpl_rec.payee_cd,
                                          p_variables.v_gen_type,
                                          NULL
                                         );
         END LOOP;

         FOR rnlpl_rec IN rnlpl
         LOOP
            v_item_no := 13;                                      /* for DECREASE IN RESERVE FOR CLAIMS AND LOSSES PAYABLE - RI*/
            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          rnlpl_rec.peril_cd,
                                          p_variables.os_module_id,
                                          v_item_no,
                                          p_line_cd,
                                          NULL,
                                          rnlpl_rec.disbmt_amt,
                                          --rnlpl_rec.clm_loss_id  ,
                                          rnlpl_rec.payee_class_cd,
                                          rnlpl_rec.payee_cd,
                                          p_variables.v_gen_type,
                                          NULL
                                         );
         END LOOP;
      ELSIF mbc_rec.payee_type = 'E'
      THEN
         FOR dlpe_rec IN dlpe
         LOOP
            v_item_no := 10;                                                                /* for LOSS/EXP AND CLAIMS PAYABLE */
            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          dlpe_rec.peril_cd,
                                          p_variables.os_module_id,
                                          v_item_no,
                                          p_line_cd,
                                          NULL,
                                          dlpe_rec.disbmt_amt,
                                          --dlpe_rec.clm_loss_id   ,
                                          dlpe_rec.payee_class_cd,
                                          dlpe_rec.payee_cd,
                                          p_variables.v_gen_type,
                                          NULL
                                         );
         END LOOP;

         FOR rlpe_rec IN rlpe
         LOOP
            v_item_no := 10;                                                      /* for LOSS/EXP AND CLAIMS PAYABLE TO FAC RI */
            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          rlpe_rec.peril_cd,
                                          p_variables.os_module_id,
                                          v_item_no,
                                          p_line_cd,
                                          NULL,
                                          rlpe_rec.disbmt_amt,
                                          rlpe_rec.payee_class_cd,
                                          rlpe_rec.payee_cd,
                                          p_variables.v_gen_type,
                                          NULL
                                         );
         END LOOP;

         FOR dnlpe_rec IN dnlpe
         LOOP
            v_item_no := 14;                                      /* for DECREASE IN RESERVE FOR LOSS EXPENSE PAYABLE - DIRECT */
            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          dnlpe_rec.peril_cd,
                                          p_variables.os_module_id,
                                          v_item_no,
                                          p_line_cd,
                                          NULL,
                                          dnlpe_rec.disbmt_amt,
                                          dnlpe_rec.payee_class_cd,
                                          dnlpe_rec.payee_cd,
                                          p_variables.v_gen_type,
                                          NULL
                                         );
         END LOOP;

         FOR rnlpe_rec IN rnlpe
         LOOP
            v_item_no := 14;                                          /* for DECREASE IN RESERVE FOR LOSS EXPENSE PAYABLE - RI */
            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          rnlpe_rec.peril_cd,
                                          p_variables.os_module_id,
                                          v_item_no,
                                          p_line_cd,
                                          NULL,
                                          rnlpe_rec.disbmt_amt,
                                          rnlpe_rec.payee_class_cd,
                                          rnlpe_rec.payee_cd,
                                          p_variables.v_gen_type,
                                          NULL
                                         );
         END LOOP;
      END IF;
   END LOOP;

--
   FOR risri_rec IN risri
   LOOP
      IF risri_rec.share_type IN (p_variables.v_trty_shr_type, p_variables.v_xol_shr_type)
      THEN
         --v_item_no := 5; /* for RECOVERABLE FROM TREATY RI ON UNPAID LOSSES */ --commented by A.R.C. 02.10.2005
         --added by A.R.C. 02.10.2005
         IF risri_rec.share_type = p_variables.v_xol_shr_type AND NVL (p_variables.v_separate_xol_entries, 'N') = 'Y'
         THEN
            v_item_no := 16;
         ELSE
            v_item_no := 5;
         END IF;

         gicls032_aeg_create_acct_ent (p_claim_id,
                                       p_advice_id,
                                       p_variables,
                                       risri_rec.ri_cd,
                                       p_variables.os_module_id,
                                       v_item_no,
                                       risri_rec.line_cd,
                                       risri_rec.acct_trty_type,
                                       risri_rec.disbmt_amt,
                                       risri_rec.payee_class_cd,
                                       risri_rec.payee_cd,
                                       p_variables.v_gen_type,
                                       NULL
                                      );
      ELSIF risri_rec.share_type = p_variables.v_facul_shr_type
      THEN
         v_item_no := 6;                                                       /* for RECOVERABLE FROM FAC RI ON UNPAID LOSSES */
         gicls032_aeg_create_acct_ent (p_claim_id,
                                       p_advice_id,
                                       p_variables,
                                       risri_rec.ri_cd,
                                       p_variables.os_module_id,
                                       v_item_no,
                                       risri_rec.line_cd,
                                       NULL,
                                       risri_rec.disbmt_amt,
                                       risri_rec.payee_class_cd,
                                       risri_rec.payee_cd,
                                       p_variables.v_gen_type,
                                       NULL
                                      );
      END IF;
   END LOOP;
END;
/


