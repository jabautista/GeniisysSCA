CREATE OR REPLACE PROCEDURE CPI.gicls032_aeg_parameters (
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
   **  Description  : Converted procedure from GICLS032 - aeg_parameters
   */
   
   /*
   **  For Direct Claim Payments...
   **  populate GICL_ACCT_ENTRIES
   */

   /*
   ** fetch amount of disbursement -- entry for LOSSES and EXPENSES PAID
   ** payee_type = 'L' for 'LOSSES'; 'E' for 'EXPENSES'
   */

   /*If separate_booking_of_taxable_loss = 'N', use these cursors
   **same process as before*/
   CURSOR dlp
   IS
      (SELECT   SUM (a.net_amt) * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd                                          --, a.clm_loss_id
           FROM gicl_clm_loss_exp a, gicl_advice b
          WHERE b.claim_id = a.claim_id
            AND b.advice_id = a.advice_id
            AND a.claim_id = p_claim_id
            AND a.advice_id = p_advice_id
            AND a.payee_class_cd = p_payee_class_cd
            AND a.payee_cd = p_payee_cd
       GROUP BY NVL (b.orig_curr_rate, b.convert_rate), a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd, a.currency_cd);

   --, a.clm_loss_id);
   CURSOR dlpf
   IS
      (SELECT     SUM (c.shr_le_net_amt)
                * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd                                           --, a.clm_loss_id
           FROM gicl_clm_loss_exp a, gicl_loss_exp_ds c, gicl_advice b
          WHERE c.negate_tag IS NULL
            AND c.share_type = '1'
            AND a.claim_id = c.claim_id
            AND a.clm_loss_id = c.clm_loss_id
            AND b.claim_id = a.claim_id
            AND b.advice_id = a.advice_id
            AND a.claim_id = p_claim_id
            AND a.advice_id = p_advice_id
            AND a.payee_class_cd = p_payee_class_cd
            AND a.payee_cd = p_payee_cd
       GROUP BY NVL (b.orig_curr_rate, b.convert_rate), a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd, a.currency_cd);

   --, a.clm_loss_id);

   /*Elsif separate_booking_of_taxable_loss = 'Y', use these cursors
   **separate computation for taxable and non taxable*/

   --W/ TAX--
   --inclusive--
   CURSOR dlp_ywi
   IS
      (SELECT   SUM (disbmt_amt) disbmt_amt, peril_cd, payee_type, payee_class_cd, payee_cd
           FROM (SELECT DISTINCT   (d.base_amt - d.tax_amt)
                                 * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                                 a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd, d.loss_exp_cd
                            FROM gicl_clm_loss_exp a, gicl_advice b, gicl_loss_exp_dtl c, gicl_loss_exp_tax d
                           WHERE b.claim_id = a.claim_id
                             AND b.advice_id = a.advice_id
                             AND a.claim_id = p_claim_id
                             AND a.advice_id = p_advice_id
                             AND a.payee_class_cd = p_payee_class_cd
                             AND a.payee_cd = p_payee_cd
                             AND (d.loss_exp_cd = c.loss_exp_cd OR d.loss_exp_cd <> '0'
                                  OR SUBSTR (d.loss_exp_cd, 3) = c.loss_exp_cd
                                 )
                             AND a.claim_id = d.claim_id
                             AND a.claim_id = c.claim_id
                             AND a.clm_loss_id = d.clm_loss_id
                             AND a.clm_loss_id = c.clm_loss_id
                             AND NVL (c.w_tax, 'N') = 'Y'
                             AND d.tax_type = 'I')
       GROUP BY peril_cd, payee_type, payee_class_cd, payee_cd);

   --exclusive--
   CURSOR dlp_ywe
   IS
      (SELECT   SUM (disbmt_amt) disbmt_amt, peril_cd, payee_type, payee_class_cd, payee_cd
           FROM (SELECT DISTINCT   d.base_amt
                                 * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                                 a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd, d.loss_exp_cd
                            FROM gicl_clm_loss_exp a, gicl_advice b, gicl_loss_exp_dtl c, gicl_loss_exp_tax d
                           WHERE b.claim_id = a.claim_id
                             AND b.advice_id = a.advice_id
                             AND a.claim_id = p_claim_id
                             AND a.advice_id = p_advice_id
                             AND a.payee_class_cd = p_payee_class_cd
                             AND a.payee_cd = p_payee_cd
                             AND (d.loss_exp_cd = c.loss_exp_cd OR d.loss_exp_cd = '0' OR SUBSTR (d.loss_exp_cd, 3) =
                                                                                                                     c.loss_exp_cd
                                 )
                             AND a.claim_id = d.claim_id
                             AND a.claim_id = c.claim_id
                             AND a.clm_loss_id = d.clm_loss_id
                             AND a.clm_loss_id = c.clm_loss_id
                             AND NVL (c.w_tax, 'N') <> 'Y')
       GROUP BY peril_cd, payee_type, payee_class_cd, payee_cd);

   --W/O TAX--
   CURSOR dlp_ywo
   IS
      (SELECT   SUM (c.dtl_amt) * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                
                --w/o tax
                a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd
           FROM gicl_clm_loss_exp a, gicl_advice b, gicl_loss_exp_dtl c
          WHERE b.claim_id = a.claim_id
            AND b.advice_id = a.advice_id
            AND a.claim_id = p_claim_id
            AND a.advice_id = p_advice_id
            AND a.payee_class_cd = p_payee_class_cd
            AND a.payee_cd = p_payee_cd
            AND a.claim_id = c.claim_id
            AND a.clm_loss_id = c.clm_loss_id
            AND NOT EXISTS (
                   SELECT 'Y'
                     FROM gicl_loss_exp_tax d
                    WHERE c.claim_id = d.claim_id
                      AND c.clm_loss_id = d.clm_loss_id
                      AND (d.loss_exp_cd = c.loss_exp_cd OR d.loss_exp_cd = '0' OR SUBSTR (d.loss_exp_cd, 3) = c.loss_exp_cd))
       GROUP BY NVL (b.orig_curr_rate, b.convert_rate), a.peril_cd, a.payee_type, a.payee_class_cd, a.payee_cd, a.currency_cd);

   /*
   ** RI SHARE ON PAID LOSSES (break on peril)
   ** payee_type = 'L' for 'LOSSES'; 'E' for 'EXPENSES'
   ** share_type = '2' for 'TREATY'; '3' for 'FACULTATIVE'
   */
   CURSOR risp
   IS
      (SELECT     SUM (d.shr_le_ri_net_amt)
                * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                a.peril_cd, d.line_cd, d.grp_seq_no, d.acct_trty_type, c.share_type, a.payee_type, a.payee_class_cd,
                a.payee_cd                                                                                       --, a.clm_loss_id
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
                a.peril_cd,
                d.line_cd,
                d.grp_seq_no,
                d.acct_trty_type,
                c.share_type,
                a.payee_type,
                a.payee_class_cd,
                a.payee_cd,
                a.currency_cd);                                                                                --, a.clm_loss_id);

   /*
   ** RI SHARE ON PAID LOSSES (break on reinsurer)
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

   /*
   ** RI SHARE ON PAID LOSSES (break on reinsurer)
   ** share_type = '2' for 'TREATY'; '3' for 'FACULTATIVE'
   ** payee_type = 'L' for 'LOSSES'; 'E' for 'EXPENSES'
   */
   CURSOR risri2
   IS
      (SELECT     SUM (d.shr_le_ri_net_amt)
                * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) disbmt_amt,
                d.acct_trty_type, d.line_cd, d.grp_seq_no, d.ri_cd, c.share_type, a.payee_class_cd, a.payee_cd, a.payee_type
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
                a.payee_type,
                a.currency_cd);

   dismt                    giac_direct_claim_payts.disbursement_amt%TYPE;
   sum_deb                  gicl_acct_entries.debit_amt%TYPE;
   ws_misc_entries          giac_direct_claim_payts.disbursement_amt%TYPE;
   v_sl_type_cd             giac_module_entries.sl_type_cd%TYPE;                                        -- Added by Marlo 07222010
   v_item_no                NUMBER;
   v_max_misc_entry         NUMBER (20,9);  --kenneth 03.31.2016 SR 5478
BEGIN
   /*
   ** Call the accounting entry generation procedure.
   */
   IF p_variables.v_cur_name = 'N'
   THEN
      IF p_variables.v_separate_booking = 'N'
      THEN
         FOR dlp_rec IN dlp
         LOOP         
            IF dlp_rec.payee_type = p_variables.v_loss_payee_type
            THEN            
               v_item_no := 1;                                                                       /* for DIRECT LOSSES PAID */
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             dlp_rec.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             p_line_cd,
                                             NULL,
                                             dlp_rec.disbmt_amt,
                                             dlp_rec.payee_class_cd,
                                             dlp_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            ELSIF dlp_rec.payee_type = p_variables.v_exp_payee_type
            THEN            
               v_item_no := 4;                                                                  /* for LOSS ADJUSTMENT EXPENSE */
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             dlp_rec.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             p_line_cd,
                                             NULL,
                                             dlp_rec.disbmt_amt,
                                             dlp_rec.payee_class_cd,
                                             dlp_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         END LOOP;
      ELSIF p_variables.v_separate_booking = 'Y'
      THEN
         FOR i IN dlp_ywi
         LOOP                                                                                               --TAXABLE inclusive--
            IF i.payee_type = p_variables.v_loss_payee_type
            THEN
               v_item_no := 1;                                                               /* for DIRECT LOSSES PAID TAXABLE */
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             i.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             p_line_cd,
                                             NULL,
                                             i.disbmt_amt,
                                             i.payee_class_cd,
                                             i.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            ELSIF i.payee_type = p_variables.v_exp_payee_type
            THEN
               v_item_no := 4;                                                          /* for LOSS ADJUSTMENT EXPENSE TAXABLE */
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             i.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             p_line_cd,
                                             NULL,
                                             i.disbmt_amt,
                                             i.payee_class_cd,
                                             i.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         END LOOP;

         FOR x IN dlp_ywe
         LOOP                                                                                                --TAXABLE exclusive--
            IF x.payee_type = p_variables.v_loss_payee_type
            THEN
               v_item_no := 1;                                                               /* for DIRECT LOSSES PAID TAXABLE */
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             x.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             p_line_cd,
                                             NULL,
                                             x.disbmt_amt,
                                             x.payee_class_cd,
                                             x.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            ELSIF x.payee_type = p_variables.v_exp_payee_type
            THEN
               v_item_no := 4;                                                          /* for LOSS ADJUSTMENT EXPENSE TAXABLE */
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             x.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             p_line_cd,
                                             NULL,
                                             x.disbmt_amt,
                                             x.payee_class_cd,
                                             x.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         END LOOP;

         FOR j IN dlp_ywo
         LOOP                                                                                                      --NON TAXABLE--
            IF j.payee_type = p_variables.v_loss_payee_type
            THEN
               v_item_no := 14;                                                          /* for DIRECT LOSSES PAID NON TAXABLE */
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             j.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             p_line_cd,
                                             NULL,
                                             j.disbmt_amt,
                                             j.payee_class_cd,
                                             j.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            ELSIF j.payee_type = p_variables.v_exp_payee_type
            THEN
               v_item_no := 15;                                                     /* for LOSS ADJUSTMENT EXPENSE NON TAXABLE */
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             j.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             p_line_cd,
                                             NULL,
                                             j.disbmt_amt,
                                             j.payee_class_cd,
                                             j.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         END LOOP;
      END IF;                                                                                                    -- cur_name = 'Y'
   ELSE
      FOR dlpf_rec IN dlpf
      LOOP
         IF dlpf_rec.payee_type = p_variables.v_loss_payee_type
         THEN
            v_item_no := 1;                                                                          /* for DIRECT LOSSES PAID */
            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          dlpf_rec.peril_cd,
                                          p_variables.v_module_id,
                                          v_item_no,
                                          p_line_cd,
                                          NULL,
                                          dlpf_rec.disbmt_amt,
                                          dlpf_rec.payee_class_cd,
                                          dlpf_rec.payee_cd,
                                          p_variables.v_gen_type,
                                          NULL
                                         );
         ELSIF dlpf_rec.payee_type = p_variables.v_exp_payee_type
         THEN
            v_item_no := 4;                                                                     /* for LOSS ADJUSTMENT EXPENSE */
            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          dlpf_rec.peril_cd,
                                          p_variables.v_module_id,
                                          v_item_no,
                                          p_line_cd,
                                          NULL,
                                          dlpf_rec.disbmt_amt,                                          
                                          dlpf_rec.payee_class_cd,
                                          dlpf_rec.payee_cd,
                                          p_variables.v_gen_type,
                                          NULL
                                         );
         END IF;
      END LOOP;
   END IF;

   /* Modified by Marlo
   ** 07222010
   ** retrieve the sl_type_cd in giac_module_entries
   ** and checked if the sl_type_cd is for peril or for RI
   ** if the sl_type_cd is not for RI it will create acctg entries for this cursor*/
   FOR risp_rec IN risp
   LOOP
      IF risp_rec.share_type IN (p_variables.v_trty_shr_type, p_variables.v_xol_shr_type)
      THEN
         IF risp_rec.payee_type = p_variables.v_loss_payee_type
         THEN
            IF risp_rec.share_type = p_variables.v_xol_shr_type AND NVL (p_variables.v_separate_xol_entries, 'N') = 'Y'
            THEN
               v_item_no := 17;                                          /* for LOSS RECOVERIES ON RI CEDED(PAID LOSSES) - XOL */
            ELSE
               v_item_no := 2;                                        /* for LOSS RECOVERIES ON RI CEDED(PAID LOSSES) - TREATY */
            END IF;

            -- msg_alert('5a','I',false); --jcf.dummy
            BEGIN
               SELECT sl_type_cd
                 INTO v_sl_type_cd
                 FROM giac_module_entries
                WHERE module_id = p_variables.v_module_id AND item_no = v_item_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  gicl_advice_pkg.revert_advice (p_claim_id);
                  raise_application_error (-20001, 'Geniisys Exception#E#No data giac_wholding_taxes.');
            END;

            IF v_sl_type_cd <> p_variables.v_ri_sl_type OR v_sl_type_cd IS NULL
            THEN
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risp_rec.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risp_rec.line_cd,
                                             risp_rec.acct_trty_type,
                                             risp_rec.disbmt_amt,
                                             --risp_rec.clm_loss_id   ,
                                             risp_rec.payee_class_cd,
                                             risp_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         ELSIF risp_rec.payee_type = p_variables.v_exp_payee_type
         THEN
            IF risp_rec.share_type = p_variables.v_xol_shr_type AND NVL (p_variables.v_separate_xol_entries, 'N') = 'Y'
            THEN
               v_item_no := 18;                                       /* for LOSS RECOVERIES ON RI CEDED(LOSS ADJ. EXP.) - XOL */
            ELSE
               v_item_no := 5;                                     /* for LOSS RECOVERIES ON RI CEDED(LOSS ADJ. EXP.) - TREATY */
            END IF;

            --msg_alert('5b','I',false); --jcf.dummy
            BEGIN
               SELECT sl_type_cd
                 INTO v_sl_type_cd
                 FROM giac_module_entries
                WHERE module_id = p_variables.v_module_id AND item_no = v_item_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  gicl_advice_pkg.revert_advice (p_claim_id);
                  raise_application_error (-20001, 'Geniisys Exception#E#No data giac_wholding_taxes.');
            END;

            IF v_sl_type_cd <> p_variables.v_ri_sl_type OR v_sl_type_cd IS NULL
            THEN
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risp_rec.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risp_rec.line_cd,
                                             risp_rec.acct_trty_type,
                                             risp_rec.disbmt_amt,
                                             risp_rec.payee_class_cd,
                                             risp_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         END IF;
      ELSIF risp_rec.share_type = p_variables.v_facul_shr_type
      THEN
         IF risp_rec.payee_type = p_variables.v_loss_payee_type
         THEN
            v_item_no := 3;                                            /* for LOSS RECOVERIES ON RI CEDED(PAID LOSSES) - FACUL */

            --msg_alert('6a','I',false); --jcf.dummy
            BEGIN
               SELECT sl_type_cd
                 INTO v_sl_type_cd
                 FROM giac_module_entries
                WHERE module_id = p_variables.v_module_id AND item_no = v_item_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  gicl_advice_pkg.revert_advice (p_claim_id);
                  raise_application_error (-20001, 'Geniisys Exception#E#No data giac_wholding_taxes.');
            END;

            IF v_sl_type_cd <> p_variables.v_ri_sl_type OR v_sl_type_cd IS NULL
            THEN
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risp_rec.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risp_rec.line_cd,
                                             NULL,
                                             risp_rec.disbmt_amt,
                                             --risp_rec.clm_loss_id   ,
                                             risp_rec.payee_class_cd,
                                             risp_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         ELSIF risp_rec.payee_type = p_variables.v_exp_payee_type
         THEN
            v_item_no := 6;                                         /* for LOSS RECOVERIES ON RI CEDED(LOSS ADJ. EXP.) - FACUL */

            -- msg_alert('6b','I',false); --jcf.dummy
            BEGIN
               SELECT sl_type_cd
                 INTO v_sl_type_cd
                 FROM giac_module_entries
                WHERE module_id = p_variables.v_module_id AND item_no = v_item_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  gicl_advice_pkg.revert_advice (p_claim_id);
                  raise_application_error (-20001, 'Geniisys Exception#E#No data giac_wholding_taxes.');
            END;

            IF v_sl_type_cd <> p_variables.v_ri_sl_type OR v_sl_type_cd IS NULL
            THEN
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risp_rec.peril_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risp_rec.line_cd,
                                             NULL,
                                             risp_rec.disbmt_amt,
                                             risp_rec.payee_class_cd,
                                             risp_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         END IF;
      END IF;
   END LOOP;

   -- end of modifications of marlo 07222010

   /* Added by Marlo
   ** 07222010
   ** retrieve the sl_type_cd in giac_module_entries
   ** and checked if the sl_type_cd is for peril or for RI
   ** if the sl_type_cd is for RI it will create acctg entries for this cursor*/
   FOR risp_rec IN risri2
   LOOP
      IF risp_rec.share_type IN (p_variables.v_trty_shr_type, p_variables.v_xol_shr_type)
      THEN
         IF risp_rec.payee_type = p_variables.v_loss_payee_type
         THEN
            IF risp_rec.share_type = p_variables.v_xol_shr_type AND NVL (p_variables.v_separate_xol_entries, 'N') = 'Y'
            THEN
               v_item_no := 17;                                          /* for LOSS RECOVERIES ON RI CEDED(PAID LOSSES) - XOL */
            ELSE
               v_item_no := 2;                                        /* for LOSS RECOVERIES ON RI CEDED(PAID LOSSES) - TREATY */
            END IF;

            -- msg_alert('5a','I',false); --jcf.dummy
            BEGIN
               SELECT sl_type_cd
                 INTO v_sl_type_cd
                 FROM giac_module_entries
                WHERE module_id = p_variables.v_module_id AND item_no = v_item_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  gicl_advice_pkg.revert_advice (p_claim_id);
                  raise_application_error (-20001, 'Geniisys Exception#E#No data giac_wholding_taxes.');
            END;

            IF v_sl_type_cd = p_variables.v_ri_sl_type
            THEN
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risp_rec.ri_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risp_rec.line_cd,
                                             risp_rec.acct_trty_type,
                                             risp_rec.disbmt_amt,
                                             risp_rec.payee_class_cd,
                                             risp_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         ELSIF risp_rec.payee_type = p_variables.v_exp_payee_type
         THEN
            IF risp_rec.share_type = p_variables.v_xol_shr_type AND NVL (p_variables.v_separate_xol_entries, 'N') = 'Y'
            THEN
               v_item_no := 18;                                       /* for LOSS RECOVERIES ON RI CEDED(LOSS ADJ. EXP.) - XOL */
            ELSE
               v_item_no := 5;                                     /* for LOSS RECOVERIES ON RI CEDED(LOSS ADJ. EXP.) - TREATY */
            END IF;

            BEGIN
               SELECT sl_type_cd
                 INTO v_sl_type_cd
                 FROM giac_module_entries
                WHERE module_id = p_variables.v_module_id AND item_no = v_item_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  gicl_advice_pkg.revert_advice (p_claim_id);
                  raise_application_error (-20001, 'Geniisys Exception#E#No data giac_wholding_taxes.');
            END;

            IF v_sl_type_cd = p_variables.v_ri_sl_type
            THEN
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risp_rec.ri_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risp_rec.line_cd,
                                             risp_rec.acct_trty_type,
                                             risp_rec.disbmt_amt,
                                             risp_rec.payee_class_cd,
                                             risp_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         END IF;
      ELSIF risp_rec.share_type = p_variables.v_facul_shr_type
      THEN
         IF risp_rec.payee_type = p_variables.v_loss_payee_type
         THEN
            v_item_no := 3;                                            /* for LOSS RECOVERIES ON RI CEDED(PAID LOSSES) - FACUL */

            BEGIN
               SELECT sl_type_cd
                 INTO v_sl_type_cd
                 FROM giac_module_entries
                WHERE module_id = p_variables.v_module_id AND item_no = v_item_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  gicl_advice_pkg.revert_advice (p_claim_id);
                  raise_application_error (-20001, 'Geniisys Exception#E#No data giac_wholding_taxes.');
            END;

            IF v_sl_type_cd = p_variables.v_ri_sl_type
            THEN
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risp_rec.ri_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risp_rec.line_cd,
                                             NULL,
                                             risp_rec.disbmt_amt,
                                             risp_rec.payee_class_cd,
                                             risp_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         ELSIF risp_rec.payee_type = p_variables.v_exp_payee_type
         THEN
            v_item_no := 6;                                         /* for LOSS RECOVERIES ON RI CEDED(LOSS ADJ. EXP.) - FACUL */

            BEGIN
               SELECT sl_type_cd
                 INTO v_sl_type_cd
                 FROM giac_module_entries
                WHERE module_id = p_variables.v_module_id AND item_no = v_item_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  gicl_advice_pkg.revert_advice (p_claim_id);
                  raise_application_error (-20001, 'Geniisys Exception#E#No data giac_wholding_taxes.');
            END;

            IF v_sl_type_cd = p_variables.v_ri_sl_type
            THEN
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risp_rec.ri_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risp_rec.line_cd,
                                             NULL,
                                             risp_rec.disbmt_amt,
                                             risp_rec.payee_class_cd,
                                             risp_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         END IF;
      END IF;
   END LOOP;

   IF p_variables.v_ri_recov = 'N'
   THEN
      FOR risri_rec IN risri
      LOOP
         IF risri_rec.share_type IN (p_variables.v_trty_shr_type, p_variables.v_xol_shr_type)
         THEN
            IF risri_rec.share_type = p_variables.v_xol_shr_type AND NVL (p_variables.v_separate_xol_entries, 'N') = 'Y'
            THEN
               v_item_no := 13;
            ELSE
               v_item_no := 7;
            END IF;

            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          risri_rec.ri_cd,
                                          p_variables.v_module_id,
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
            v_item_no := 8;
            gicls032_aeg_create_acct_ent (p_claim_id,
                                          p_advice_id,
                                          p_variables,
                                          risri_rec.ri_cd,
                                          p_variables.v_module_id,
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
   ELSIF p_variables.v_ri_recov = 'Y'
   THEN
      FOR risri2_rec IN risri2
      LOOP
         IF risri2_rec.payee_type = 'L'
         THEN
            IF risri2_rec.share_type IN (p_variables.v_trty_shr_type, p_variables.v_xol_shr_type)
            THEN
               IF risri2_rec.share_type = p_variables.v_xol_shr_type AND NVL (p_variables.v_separate_xol_entries, 'N') = 'Y'
               THEN
                  v_item_no := 13;
               ELSE
                  v_item_no := 7;
               END IF;

               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risri2_rec.ri_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risri2_rec.line_cd,
                                             risri2_rec.acct_trty_type,
                                             risri2_rec.disbmt_amt,
                                             risri2_rec.payee_class_cd,
                                             risri2_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            ELSIF risri2_rec.share_type = p_variables.v_facul_shr_type
            THEN
               v_item_no := 8;                                       /* for LOSSES RECOVERABLE FROM FACULTATIVE ON PAID LOSSES */
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risri2_rec.ri_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risri2_rec.line_cd,
                                             NULL,
                                             risri2_rec.disbmt_amt,
                                             risri2_rec.payee_class_cd,
                                             risri2_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         ELSIF risri2_rec.payee_type = 'E'
         THEN
            IF risri2_rec.share_type IN (p_variables.v_trty_shr_type, p_variables.v_xol_shr_type)
            THEN
               IF risri2_rec.share_type = p_variables.v_xol_shr_type AND NVL (p_variables.v_separate_xol_entries, 'N') = 'Y'
               THEN
                  v_item_no := 16;                                      /* for LOSSES RECOVERABLE FROM TREATY ON PAID EXPENSES */
               ELSE
                  v_item_no := 9;                                       /* for LOSSES RECOVERABLE FROM TREATY ON PAID EXPENSES */
               END IF;

               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risri2_rec.ri_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risri2_rec.line_cd,
                                             risri2_rec.acct_trty_type,
                                             risri2_rec.disbmt_amt,
                                             risri2_rec.payee_class_cd,
                                             risri2_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            ELSIF risri2_rec.share_type = p_variables.v_facul_shr_type
            THEN
               v_item_no := 10;                                    /* for LOSSES RECOVERABLE FROM FACULTATIVE ON PAID EXPENSES */
               gicls032_aeg_create_acct_ent (p_claim_id,
                                             p_advice_id,
                                             p_variables,
                                             risri2_rec.ri_cd,
                                             p_variables.v_module_id,
                                             v_item_no,
                                             risri2_rec.line_cd,
                                             NULL,
                                             risri2_rec.disbmt_amt,
                                             risri2_rec.payee_class_cd,
                                             risri2_rec.payee_cd,
                                             p_variables.v_gen_type,
                                             NULL
                                            );
            END IF;
         END IF;
      END LOOP;
   END IF;

   DECLARE
      tax_module_id   giac_modules.module_id%TYPE;
      tax_gen_type    giac_modules.generation_type%TYPE;

      CURSOR taxes
      IS
         (SELECT     SUM (NVL (a.tax_amt, 0))
                   * DECODE (c.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) tax,
                   a.tax_cd, a.tax_type,                                                                         --a.clm_loss_id,
                                        c.payee_class_cd, c.payee_cd
              FROM gicl_loss_exp_tax a, gicl_clm_loss_exp c, gicl_advice b
             WHERE c.clm_loss_id = a.clm_loss_id
               AND c.claim_id = a.claim_id
               AND b.claim_id = c.claim_id
               AND b.advice_id = c.advice_id
               AND b.claim_id = p_claim_id
               AND b.advice_id = p_advice_id
               AND c.payee_class_cd = p_payee_class_cd
               AND c.payee_cd = p_payee_cd
               AND a.tax_type = 'I'
          GROUP BY NVL (b.orig_curr_rate, b.convert_rate), a.tax_cd, a.tax_type,
                                                                                --a.clm_loss_id,
                                                                                c.payee_class_cd, c.payee_cd, c.currency_cd);

      CURSOR w_taxes
      IS
         (SELECT     SUM (NVL (a.tax_amt, 0))
                   * DECODE (c.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) w_tax,
                   a.tax_cd, a.tax_type,                                                                          --a.clm_loss_id,
                                        a.net_tag, c.payee_class_cd, c.payee_cd
              FROM gicl_loss_exp_tax a, gicl_clm_loss_exp c, gicl_advice b
             WHERE c.clm_loss_id = a.clm_loss_id
               AND c.claim_id = a.claim_id
               AND b.claim_id = c.claim_id
               AND b.advice_id = c.advice_id
               AND b.claim_id = p_claim_id
               AND b.advice_id = p_advice_id
               AND c.payee_class_cd = p_payee_class_cd
               AND c.payee_cd = p_payee_cd
               AND a.tax_type = 'W'
          GROUP BY NVL (b.orig_curr_rate, b.convert_rate),
                   a.tax_cd,
                   a.tax_type,                                                                                    --a.clm_loss_id,
                   a.net_tag,
                   c.payee_class_cd,
                   c.payee_cd,
                   c.currency_cd);
   BEGIN
      FOR t IN taxes
      LOOP
         BEGIN
            SELECT module_id, generation_type
              INTO tax_module_id, tax_gen_type
              FROM giac_modules
             WHERE module_name = 'GIACS039';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (-20001, 'Geniisys Exception#I#No data found in GIAC MODULES.');
         END;

         gicls032_aeg_create_acct_ent (p_claim_id,
                                       p_advice_id,
                                       p_variables,
                                       NULL,
                                       tax_module_id,
                                       t.tax_cd,
                                       p_line_cd,
                                       NULL,
                                       t.tax,
                                       t.payee_class_cd,
                                       t.payee_cd,
                                       tax_gen_type,
                                       NULL
                                      );
      END LOOP;

      FOR w IN w_taxes
      LOOP
--         v_wheld_module_id := tax_module_id;

         --         IF w.net_tag = 'Y'
--         THEN
--            v_wheld_net_tag := 'Y';
--         ELSIF w.net_tag = 'N' OR w.net_tag IS NULL
--         THEN
--            v_wheld_net_tag := 'N';
--         END IF;
         gicls032_aeg_create_acct_ent (p_claim_id,
                                       p_advice_id,
                                       p_variables,
                                       NULL,
                                       NULL,
                                       w.tax_cd,
                                       p_line_cd,
                                       NULL,
                                       w.w_tax,
                                       w.payee_class_cd,
                                       w.payee_cd,
                                       tax_gen_type,
                                       'W'
                                      );
      END LOOP;
   END;

   FOR i IN (SELECT DISTINCT claim_id, advice_id,                                                                   --clm_loss_id,
                                                 payee_class_cd, payee_cd
                        FROM gicl_acct_entries
                       WHERE advice_id = p_advice_id
                         AND claim_id = p_claim_id
                         AND payee_class_cd = p_payee_class_cd
                         AND payee_cd = p_payee_cd)
   LOOP
      SELECT SUM (a.debit_amt) - SUM (a.credit_amt)
        INTO sum_deb
        FROM gicl_acct_entries a
       WHERE a.advice_id = p_advice_id
         AND a.claim_id = p_claim_id
         AND a.payee_class_cd = i.payee_class_cd
         AND a.payee_cd = i.payee_cd;

      SELECT   SUM (a.paid_amt) * DECODE (a.currency_cd, p_variables.v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) dibsmt
          INTO dismt
          FROM gicl_advice b, gicl_clm_loss_exp a
         WHERE a.claim_id = b.claim_id
           AND a.advice_id = b.advice_id
           AND b.advice_id = p_advice_id
           AND b.claim_id = p_claim_id
           AND a.payee_class_cd = i.payee_class_cd
           AND a.payee_cd = i.payee_cd
      GROUP BY NVL (b.orig_curr_rate, b.convert_rate), a.currency_cd;

      ws_misc_entries := ABS(sum_deb - dismt);
      v_max_misc_entry := giacp.n('MAX_MISC_ENTRY');    --kenneth 03.31.2016 SR 5478
      
      IF ws_misc_entries != 0
      THEN
          --start kenneth 03.31.2016 SR 5478
          --gicls032_misc_uw_entries (p_claim_id, p_advice_id, p_variables, ws_misc_entries, i.payee_class_cd, i.payee_cd);
          IF v_max_misc_entry = -1 OR v_max_misc_entry IS NULL
          THEN
            gicls032_misc_uw_entries (p_claim_id, p_advice_id, p_variables, ws_misc_entries, i.payee_class_cd, i.payee_cd);
          ELSIF v_max_misc_entry < ws_misc_entries then
            raise_application_error (-20001, 'Geniisys Exception#E#Miscellaneous entry exceeded the maximum allowable amount. Please check chart of accounts set-up or contact MIS.');
          ELSE
            gicls032_misc_uw_entries (p_claim_id, p_advice_id, p_variables, ws_misc_entries, i.payee_class_cd, i.payee_cd);
          END IF;
          --end kenneth 03.31.2016 SR 5478
      END IF;
   END LOOP;
END;
/


