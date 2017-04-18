DROP PROCEDURE CPI.GEN_PAYEE_DTLS;

CREATE OR REPLACE PROCEDURE CPI.gen_payee_dtls (
   v_payee_class   IN       VARCHAR2,
   v_payee_no      IN       NUMBER,
   v_apply2        IN       VARCHAR2,
   v_clmlossid     IN       NUMBER,
   p_clmnt_no      OUT      NUMBER,
   p_tax_cd        OUT      NUMBER,
   p_baseamt       OUT      NUMBER,
   p_taxamt        OUT      NUMBER,
   p_vatrt         OUT      NUMBER,
   p_taxid         OUT      NUMBER,
   p_sltypecd      OUT      VARCHAR2,
   p_eval_id                gicl_mc_evaluation.eval_id%TYPE,
   p_claim_id      IN       gicl_mc_evaluation.claim_id%TYPE,
   v_item_no       IN       NUMBER, -- Added by Jerome Bautista 08.17.2015 SR 19998
   v_peril_cd      IN       NUMBER -- Added by Jerome Bautista 08.17.2015 SR 19998
)
IS
   v_taxcd   giis_loss_taxes.loss_tax_id%TYPE;
BEGIN
   /*generate deductlible details
   BEGIN
       SELECT ded_cd
   END;*/

   /*generate claimant number*/
--   FOR get_clmnt_no IN (SELECT clm_clmnt_no -- Commented out by Jerome Bautista 08.17.2015 SR 19998. Replaced by codes below.
--                          FROM gicl_clm_claimant
--                         WHERE claim_id = p_claim_id
--                           AND payee_class_cd = v_payee_class
--                           AND clmnt_no = v_payee_no)

   FOR get_clmnt_no IN (SELECT clm_clmnt_no-- Added by Jerome Bautista 08.17.2015 SR 19998.
                          FROM gicl_loss_exp_payees
                         WHERE 1 = 1
                           AND claim_id = p_claim_id
                           AND payee_type = 'L'
                           AND payee_class_cd = v_payee_class
                           AND payee_cd=  v_payee_no
                           AND item_no = v_item_no
                           AND ROWNUM = 1)
   LOOP
      p_clmnt_no := get_clmnt_no.clm_clmnt_no;
   END LOOP;

   IF p_clmnt_no IS NULL
   THEN
      FOR get_max_clmnt_no IN (SELECT NVL (MAX (clm_clmnt_no),
                                           0) clm_clmnt_no
                                 FROM gicl_clm_claimant
                                WHERE claim_id = p_claim_id)
      LOOP
         p_clmnt_no := get_max_clmnt_no.clm_clmnt_no;
      END LOOP;

      p_clmnt_no := p_clmnt_no + 1;
   END IF;

   /*clmnt_no := 0;
     BEGIN
       SELECT clm_clmnt_no
       INTO clmnt_no
       FROM gicl_clm_claimant
      WHERE claim_id = :gicl_mc_evaluation.claim_id
        AND payee_class_cd = v_payee_class
        AND clmnt_no = v_payee_no;

     IF clmnt_no <> 0 THEN
          BEGIN
              SELECT max(clm_clmnt_no) + 1
                INTO clmnt_no
                FROM gicl_clm_claimant
               WHERE claim_id = :gicl_mc_evaluation.claim_id;
          EXCEPTION
               WHEN no_data_found THEN
                msg_alert('no maximum clm_clm_no found','E',TRUE);
           END;
     ELSE
         clmnt_no := 1;
     END IF;

   EXCEPTION
       WHEN no_data_found THEN
        NULL;
        --msg_alert('no clmnt no found','E',TRUE);
       WHEN too_many_rows THEN
        NULL;
        --msg_alert('too manyr clmn no found','E',TRUE);
   END;*/--da071106te

   /*tax cd*/
   BEGIN
      SELECT clm_vat_cd
        INTO p_tax_cd
        FROM giis_payee_class
       WHERE payee_class_cd = v_payee_class;
   --AND cpi_branch_cd = :master_blk.clm_iss_cd;
   EXCEPTION
      WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
      THEN
         NULL;
   --msg_alert('error in retrieving clm_vat_cd','E',FALSE);
   END;

   /*base amt, tax_amt, and vat_rate*/
   BEGIN
      SELECT base_amt, vat_amt, vat_rate
        INTO p_baseamt, p_taxamt, p_vatrt
        FROM gicl_eval_vat
       WHERE payee_type_cd = v_payee_class
         AND payee_cd = v_payee_no
         AND eval_id = p_eval_id
         AND apply_to = v_apply2
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
      THEN
         NULL;
   END;

   /*sl_type_cd*/
   BEGIN
      SELECT sl_type_cd
        INTO p_sltypecd
        FROM giis_loss_taxes
       WHERE loss_tax_id = p_tax_cd;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         --msg_alert('no_data','I',FALSE); --==
         NULL;
      WHEN TOO_MANY_ROWS
      THEN
         NULL;
   --msg_alert('nakopow','I',FALSE); --==
   END;

   /*tax_id*/
   BEGIN
      SELECT NVL (MAX (tax_id), 0) + 1
        INTO p_taxid
        FROM gicl_loss_exp_tax
       WHERE claim_id = p_claim_id AND clm_loss_id = v_clmlossid;
   --p_tax:=  nvl(:c009.tax_id,0) + 1;
   EXCEPTION
      WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
      THEN
         NULL;
   END;
--msg_alert('taxId '||p_taxId||chr(10)||
--          'TAX_CD '||p_tax_cd,'I',FALSe);--==
END;
/


