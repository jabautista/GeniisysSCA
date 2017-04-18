DROP PROCEDURE CPI.GEN_CLMLOSSID_HISTSEQNO;

CREATE OR REPLACE PROCEDURE CPI.gen_clmlossid_histseqno (
   v_payee_class_cd   IN       VARCHAR2,
   v_payee_no         IN       NUMBER,
   v_clmlossid        OUT      NUMBER,
   v_histseqno        OUT      NUMBER,
   p_claim_id         IN       gicl_mc_evaluation.claim_id%TYPE,
   p_item_no          IN       gicl_mc_evaluation.item_no%TYPE,
   p_peril_cd         IN       gicl_mc_evaluation.peril_cd%TYPE
)
IS
BEGIN
   --generate clmLossId
   BEGIN
      SELECT NVL (MAX (clm_loss_id), 0) + 1
        INTO v_clmlossid
        FROM gicl_clm_loss_exp
       WHERE claim_id = p_claim_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error
             ('-20001',
                 'no clm_loss_id found in gicl_clm_loss_exp with claim_id = '
              || p_claim_id
             );
   END;

   BEGIN
      SELECT NVL (MAX (hist_seq_no), 0) + 1
        INTO v_histseqno
        FROM gicl_clm_loss_exp
       WHERE claim_id = p_claim_id
         AND item_no = p_item_no
         AND peril_cd = p_peril_cd
         AND payee_type = 'L'
         AND payee_class_cd = v_payee_class_cd
         AND payee_cd = v_payee_no;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error ('-20001',
                                  'No data found in gicl_clm_loss_exp'
                                 );
   END;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error ('-20001', SQLERRM);
END;
/


