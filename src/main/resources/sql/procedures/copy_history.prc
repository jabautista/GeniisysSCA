DROP PROCEDURE CPI.COPY_HISTORY;

CREATE OR REPLACE PROCEDURE CPI.copy_history 
(p_hist_seq_no      IN    GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,
 p_claim_id         IN    GICL_CLAIMS.claim_id%TYPE,
 p_line_cd          IN    GICL_CLAIMS.line_cd%TYPE,
 p_item_no          IN    GICL_ITEM_PERIL.item_no%TYPE,
 p_peril_cd         IN    GICL_ITEM_PERIL.peril_cd%TYPE,
 p_grouped_item_no  IN    GICL_ITEM_PERIL.grouped_item_no%TYPE,
 p_clm_clmnt_no     IN    GICL_CLM_LOSS_EXP.clm_clmnt_no%TYPE,
 p_payee_type       IN    GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
 p_payee_class_cd   IN    GICL_LOSS_EXP_PAYEES.payee_class_cd%TYPE,
 p_payee_cd         IN    GICL_LOSS_EXP_PAYEES.payee_cd%TYPE,
 p_user_id          IN    GICL_LOSS_EXP_PAYEES.user_id%TYPE,
 p_msg_alert        OUT   VARCHAR2) IS
 
 
 /*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 03.12.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes COPY_HISTORY Program unit in GICLS030
 **                  
 */
  
  v_hist_no           GICL_CLM_LOSS_EXP.hist_seq_no%TYPE;
  v_clm_loss_id       GICL_CLM_LOSS_EXP.clm_loss_id%TYPE;
  v_paid_amt          GICL_CLM_LOSS_EXP.paid_amt%TYPE;
  v_net_amt           GICL_CLM_LOSS_EXP.net_amt%TYPE;
  v_advise_amt        GICL_CLM_LOSS_EXP.advise_amt%TYPE;
  v_prev_loss_id      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE;
  v_stat_cd           GICL_CLM_LOSS_EXP.item_stat_cd%TYPE;
  v_ex_gratia         GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE;
  v_final_tag         GICL_CLM_LOSS_EXP.final_tag%TYPE; --koks 2.18.14 to copy final tag
  v_dtl_amt           GICL_LOSS_EXP_DTL.dtl_amt%TYPE;
  v_ded_cd            GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE;

  CURSOR loss_exp_dtl(p_prev_loss_id    GICL_CLM_LOSS_EXP.clm_loss_id%TYPE) IS
    SELECT loss_exp_cd, dtl_amt, no_of_units,
           ded_rate, ded_base_amt, loss_exp_class,
           ded_loss_exp_cd, original_sw
      FROM GICL_LOSS_EXP_DTL
     WHERE claim_id = p_claim_id
       AND clm_loss_id = v_prev_loss_id;

  CURSOR LOSS_EXP_TAX(p_prev_loss_id    GICL_CLM_LOSS_EXP.clm_loss_id%TYPE) IS
    SELECT tax_cd, tax_type, loss_exp_cd, base_amt, 
           tax_amt, tax_pct, adv_tag, net_tag, w_tax
      FROM GICL_LOSS_EXP_TAX
     WHERE claim_id = p_claim_id
       AND clm_loss_id = v_prev_loss_id;

BEGIN
  BEGIN
    SELECT MAX(hist_seq_no) + 1
      INTO v_hist_no
      FROM GICL_CLM_LOSS_EXP a
     WHERE a.claim_id       = p_claim_id
       AND a.item_no        = p_item_no
       AND NVL(grouped_item_no,0) = NVL(p_grouped_item_no,0)
       AND a.peril_cd       = p_peril_cd
       AND a.payee_type     = p_payee_type
       AND a.payee_class_cd = p_payee_class_cd
       AND a.payee_cd       = p_payee_cd;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_hist_no := 1;
  END;

  BEGIN
    SELECT MAX(clm_loss_id) + 1
      INTO v_clm_loss_id
      FROM GICL_CLM_LOSS_EXP a
     WHERE a.claim_id    = p_claim_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_clm_loss_id := 1;
  END;

  BEGIN
    SELECT clm_loss_id, item_stat_cd, ex_gratia_sw, final_tag --koks 2.18.14 to copy final tag
      INTO v_prev_loss_id, v_stat_cd, v_ex_gratia, v_final_tag
      FROM GICL_CLM_LOSS_EXP a
     WHERE a.claim_id    = p_claim_id
       AND NVL(a.grouped_item_no,0) = NVL(p_grouped_item_no,0)
       AND a.item_no = p_item_no
       AND a.peril_cd = p_peril_cd
       AND a.payee_type = p_payee_type
       AND a.payee_class_cd = p_payee_class_cd
       AND a.payee_cd = p_payee_cd
       AND a.hist_seq_no = p_hist_seq_no;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;
   
  BEGIN
    SELECT SUM(dtl_amt)
      INTO v_dtl_amt
      FROM GICL_LOSS_EXP_DTL
     WHERE claim_id = p_claim_id
       AND clm_loss_id = v_prev_loss_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;
  
  INSERT INTO GICL_CLM_LOSS_EXP
  (claim_id,     clm_loss_id,   hist_seq_no,    item_no,            peril_cd,
   item_stat_cd, payee_type,    payee_cd,       payee_class_cd,     ex_gratia_sw, final_tag, --koks 2.18.14 to copy final tag
   paid_amt,     net_amt,       advise_amt,     clm_clmnt_no,       grouped_item_no)
  VALUES 
  (p_claim_id,  v_clm_loss_id,  v_hist_no,      p_item_no,          p_peril_cd,
   v_stat_cd,   p_payee_type,   p_payee_cd,     p_payee_class_cd,   v_ex_gratia, v_final_tag, --koks 2.18.14 to copy final tag
   v_dtl_amt,   v_dtl_amt,      v_dtl_amt,      p_clm_clmnt_no,     p_grouped_item_no);
  
  
  FOR c1 IN loss_exp_dtl (v_prev_loss_id) LOOP
    
    INSERT INTO GICL_LOSS_EXP_DTL
    (claim_id,          clm_loss_id,        line_cd,        loss_exp_cd, 
     dtl_amt,           loss_exp_type,      original_sw,    ded_rate,
     ded_base_amt,      loss_exp_class,     no_of_units,    ded_loss_exp_cd)
    VALUES 
    (p_claim_id,        v_clm_loss_id,      p_line_cd,      c1.loss_exp_cd,
     c1.dtl_amt,        p_payee_type,       c1.original_sw, c1.ded_rate,
     c1.ded_base_amt,   c1.loss_exp_class,  c1.no_of_units, c1.ded_loss_exp_cd);
    
  END LOOP;

  
  FOR ded IN
       (SELECT line_cd, subline_cd, loss_exp_type,
               loss_exp_cd, loss_amt, ded_cd,
               ded_amt, ded_rate,
               aggregate_sw, ceiling_sw, min_amt, max_amt, range_sw
          FROM GICL_LOSS_EXP_DED_DTL
         WHERE claim_id    = p_claim_id
           AND clm_loss_id = v_prev_loss_id)
  LOOP
        INSERT INTO GICL_LOSS_EXP_DED_DTL
        (claim_id,          clm_loss_id,        line_cd,        subline_cd,
         loss_exp_type,     loss_exp_cd,        loss_amt,       ded_cd,
         ded_amt,           ded_rate,           user_id,        last_update,
         aggregate_sw,      ceiling_sw,         min_amt,        max_amt,    range_sw)--2.0
        VALUES 
        (p_claim_id,        v_clm_loss_id,      ded.line_cd,    ded.subline_cd,
         ded.loss_exp_type, ded.loss_exp_cd,    ded.loss_amt,   ded.ded_cd,
         ded.ded_amt,       ded.ded_rate,       p_user_id,      SYSDATE,
         ded.aggregate_sw,  ded.ceiling_sw,     ded.min_amt,    ded.max_amt, ded.range_sw);--2.0
  END LOOP;
  
  p_msg_alert := 'History No. '||TO_CHAR(p_hist_seq_no)||' has been copied to History No. ' ||TO_CHAR(v_hist_no);

END;
/


