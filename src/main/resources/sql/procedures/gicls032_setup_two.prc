DROP PROCEDURE CPI.GICLS032_SETUP_TWO;

CREATE OR REPLACE PROCEDURE CPI.gicls032_setup_two (
   p_claim_id         gicl_advice.claim_id%TYPE,
   p_advice_id        gicl_advice.advice_id%TYPE,
   p_line_cd          gicl_claims.line_cd%TYPE,
   p_payee_class_cd   gicl_clm_loss_exp.payee_class_cd%TYPE,
   p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE,
   p_variables        gicl_advice_pkg.gicls032_variables
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - setup_two
   */
   
   /*
   **  For Unpaid Losses
   **  populate GICL_ACCT_ENTRIES
   */

   /*
   ** fetch amount of disbursement -- entry for LOSSES and EXPENSES PAID
   ** payee_type = 'L' for 'LOSSES'; 'E' for 'EXPENSES'
   */
   CURSOR dlp
   IS
      (SELECT   SUM (a.net_amt) * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd                                          --, a.clm_loss_id
           FROM gicl_clm_loss_exp a, gicl_advice b
          WHERE b.claim_id = a.claim_id
            AND b.advice_id = a.advice_id
            AND b.iss_cd <> p_variables.v_ri_iss_cd
            AND a.claim_id = p_claim_id
            AND a.advice_id = p_advice_id
            AND a.payee_class_cd = p_payee_class_cd
            AND a.payee_cd = p_payee_cd
       GROUP BY NVL (b.orig_curr_rate, b.convert_rate), a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd, a.currency_cd);

   --, a.clm_loss_id);
   CURSOR rlp
   IS
      (SELECT   SUM (a.net_amt) * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd                                           --, a.clm_loss_id
           FROM gicl_clm_loss_exp a, gicl_advice b
          WHERE b.claim_id = a.claim_id
            AND b.advice_id = a.advice_id
            AND b.iss_cd = p_variables.v_ri_iss_cd
            AND a.claim_id = p_claim_id
            AND a.advice_id = p_advice_id
            AND a.payee_class_cd = p_payee_class_cd
            AND a.payee_cd = p_payee_cd
       GROUP BY NVL (b.orig_curr_rate, b.convert_rate), a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd, a.currency_cd);

   --, a.clm_loss_id);
   CURSOR dnlp
   IS
      (SELECT     SUM (c.shr_le_net_amt)
                * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd                                           --, a.clm_loss_id
           FROM gicl_clm_loss_exp a, gicl_advice b, gicl_loss_exp_ds c
          WHERE a.claim_id = c.claim_id
            AND a.clm_loss_id = c.clm_loss_id
            AND b.claim_id = a.claim_id
            AND b.advice_id = a.advice_id
            AND c.negate_tag IS NULL
            AND c.share_type = '1'
            AND b.iss_cd <> p_variables.v_ri_iss_cd
            AND a.claim_id = p_claim_id
            AND a.advice_id = p_advice_id
            AND a.payee_class_cd = p_payee_class_cd
            AND a.payee_cd = p_payee_cd
       GROUP BY NVL (b.orig_curr_rate, b.convert_rate), a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd, a.currency_cd);

   --, a.clm_loss_id);
   CURSOR rnlp
   IS
      (SELECT     SUM (c.shr_le_net_amt)
                * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd                                           --, a.clm_loss_id
           FROM gicl_clm_loss_exp a, gicl_advice b, gicl_loss_exp_ds c
          WHERE a.claim_id = c.claim_id
            AND a.clm_loss_id = c.clm_loss_id
            AND b.claim_id = a.claim_id
            AND b.advice_id = a.advice_id
            AND c.negate_tag IS NULL
            AND c.share_type = '1'
            AND b.iss_cd = p_variables.v_ri_iss_cd
            AND a.claim_id = p_claim_id
            AND a.advice_id = p_advice_id
            AND a.payee_class_cd = p_payee_class_cd
            AND a.payee_cd = p_payee_cd
       GROUP BY NVL (b.orig_curr_rate, b.convert_rate), a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd, a.currency_cd);

   --, a.clm_loss_id);

   /*
   **RI SHARE ON UNPAID LOSSES (break on reinsurer)
   ** share_type = '2' for 'TREATY'; '3' for 'FACULTATIVE'
   */
   CURSOR risri
   IS
      (SELECT     SUM (d.shr_le_ri_net_amt)
                * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                d.acct_trty_type, d.line_cd, d.grp_seq_no, d.ri_cd, c.share_type, a.payee_class_cd, a.payee_cd   --, a.clm_loss_id
           FROM gicl_loss_exp_ds c, gicl_loss_exp_rids d, gicl_clm_loss_exp a, gicl_advice b
          WHERE c.grp_seq_no = d.grp_seq_no
            AND c.clm_dist_no = d.clm_dist_no
            AND c.clm_loss_id = d.clm_loss_id
            AND c.claim_id = d.claim_id
            AND c.negate_tag IS NULL
            AND a.clm_loss_id = c.clm_loss_id
            AND a.claim_id = c.claim_id
            AND b.advice_id = a.advice_id
            AND b.claim_id = a.claim_id
            AND a.advice_id = p_advice_id
            AND a.claim_id = p_claim_id
            AND a.payee_class_cd = p_payee_class_cd
            AND a.payee_cd = p_payee_cd
       GROUP BY NVL (b.orig_curr_rate, b.convert_rate),
                d.line_cd,
                d.grp_seq_no,
                d.acct_trty_type,
                d.ri_cd,
                c.share_type,
                a.payee_class_cd,
                a.payee_cd,
                a.currency_cd);                                                                                --, a.clm_loss_id);

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
   FOR dlp_rec IN dlp
   LOOP
      v_item_no := 9;                                                                          /* for CLAIMS AND LOSSES PAYABLE*/
      gicls032_aeg_create_acct_ent (p_claim_id,
                                    p_advice_id,
                                    p_variables,
                                    dlp_rec.peril_cd,
                                    p_variables.os_module_id,
                                    v_item_no,
                                    p_line_cd,
                                    NULL,
                                    dlp_rec.disbmt_amt,
                                    --dlp_rec.clm_loss_id   ,
                                    dlp_rec.payee_class_cd,
                                    dlp_rec.payee_cd,
                                    p_variables.v_gen_type,
                                    NULL
                                   );
   END LOOP;

--
   FOR rlp_rec IN rlp
   LOOP
      v_item_no := 9;                                                               /* for LOSSES AND CLAIMS PAYABLE TO FAC RI */
      gicls032_aeg_create_acct_ent (p_claim_id,
                                    p_advice_id,
                                    p_variables,
                                    rlp_rec.peril_cd,
                                    p_variables.os_module_id,
                                    v_item_no,
                                    p_line_cd,
                                    NULL,
                                    rlp_rec.disbmt_amt,
                                    --rlp_rec.clm_loss_id   ,
                                    rlp_rec.payee_class_cd,
                                    rlp_rec.payee_cd,
                                    p_variables.v_gen_type,
                                    NULL
                                   );
   END LOOP;

   FOR dnlp_rec IN dnlp
   LOOP
      v_item_no := 13;                                        /* for DECREASE IN RESERVE FOR CLAIMS AND LOSSES PAYABLE - DIRECT*/
      gicls032_aeg_create_acct_ent (p_claim_id,
                                    p_advice_id,
                                    p_variables,
                                    dnlp_rec.peril_cd,
                                    p_variables.os_module_id,
                                    v_item_no,
                                    p_line_cd,
                                    NULL,
                                    dnlp_rec.disbmt_amt,
                                    --dnlp_rec.clm_loss_id   ,
                                    dnlp_rec.payee_class_cd,
                                    dnlp_rec.payee_cd,
                                    p_variables.v_gen_type,
                                    NULL
                                   );
   END LOOP;

--
   FOR rnlp_rec IN rnlp
   LOOP
      v_item_no := 13;                                            /* for DECREASE IN RESERVE FOR CLAIMS AND LOSSES PAYABLE - RI*/
      gicls032_aeg_create_acct_ent (p_claim_id,
                                    p_advice_id,
                                    p_variables,
                                    rnlp_rec.peril_cd,
                                    p_variables.os_module_id,
                                    v_item_no,
                                    p_line_cd,
                                    NULL,
                                    rnlp_rec.disbmt_amt,
                                    --rnlp_rec.clm_loss_id   ,
                                    rnlp_rec.payee_class_cd,
                                    rnlp_rec.payee_cd,
                                    p_variables.v_gen_type,
                                    NULL
                                   );
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
                                       --risri_rec.clm_loss_id   ,
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
                                       --risri_rec.clm_loss_id   ,
                                       risri_rec.payee_class_cd,
                                       risri_rec.payee_cd,
                                       p_variables.v_gen_type,
                                       NULL
                                      );
      END IF;
   END LOOP;
END;
/


