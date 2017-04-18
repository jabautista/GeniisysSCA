DROP PROCEDURE CPI.INSERT_INTO_GICP;

CREATE OR REPLACE PROCEDURE CPI.INSERT_INTO_GICP
(p_advice_id  IN   GIAC_DIRECT_CLAIM_PAYTS.advice_id%TYPE,
 p_tran_id    IN   GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
 p_user_id    IN   GIIS_USERS.user_id%TYPE,
 p_msg_alert  OUT VARCHAR2) 
 
IS

   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.21.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Executes INSERT_INTO_GICP program unit in GICLS043
   **                 
   */

  v_foreign_curr_amt     GIAC_DIRECT_CLAIM_PAYTS.foreign_curr_amt%TYPE;
  switch                 VARCHAR2(1);
  tax_amt                NUMBER(16,2) DEFAULT 0;
  v_whold_tax            NUMBER(16,2) DEFAULT 0;
  v_input_vat            NUMBER(16,2) DEFAULT 0;
  v_other_tax            NUMBER(16,2) DEFAULT 0;

BEGIN
  
  FOR d IN  (SELECT a.advice_id, a.claim_id, b.clm_loss_id, 
                    b.payee_class_cd, b.payee_cd, b.payee_type,
                    b.net_amt, b.paid_amt, a.convert_rate, a.currency_cd ,
                    DECODE(b.currency_cd, giacp.n('CURRENCY_CD'), 1, NVL(a.orig_curr_rate, a.convert_rate)) conv_rt_b,--roset, 7/9/09, added nvl part
                    DECODE(a.currency_cd, giacp.n('CURRENCY_CD'), 1, NVL(a.orig_curr_rate, a.convert_rate)) conv_rt_a --roset, 7/9/09, added nvl part
               FROM GICL_ADVICE a, GICL_CLM_LOSS_EXP b
              WHERE b.claim_id  = a.claim_id
                AND b.advice_id = a.advice_id
                AND a.advice_id = p_advice_id) 
  LOOP

  -- get tax of type 'W'
    BEGIN
      SELECT SUM(tax_amt * d.conv_rt_b)
        INTO v_whold_tax
        FROM GICL_LOSS_EXP_TAX
       WHERE claim_id    = d.claim_id
         AND clm_loss_id = d.clm_loss_id
         AND tax_type = 'W';  
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          NULL;  
    END;

  -- get tax of type 'O'
    BEGIN
      SELECT SUM(tax_amt * d.conv_rt_b)
        INTO v_other_tax
        FROM GICL_LOSS_EXP_TAX
       WHERE claim_id    = d.claim_id
         AND clm_loss_id = d.clm_loss_id
         AND tax_type = 'O';  
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          NULL; 
    END;


  -- get tax of type 'I'
    BEGIN
      SELECT SUM(tax_amt * d.conv_rt_b)
        INTO v_input_vat
        FROM GICL_LOSS_EXP_TAX
       WHERE claim_id    = d.claim_id
         AND clm_loss_id = d.clm_loss_id
         AND tax_type = 'I';
    EXCEPTION
           WHEN NO_DATA_FOUND THEN
             NULL;
    END;
  
    INSERT INTO GIAC_INW_CLAIM_PAYTS
                (gacc_tran_id, transaction_type,
                 claim_id, clm_loss_id, advice_id,
                 payee_cd, payee_class_cd, payee_type,
                 disbursement_amt, currency_cd, convert_rate, 
                 foreign_curr_amt, last_update, user_id, 
                 input_vat_amt, wholding_tax_amt, net_disb_amt)
         VALUES (p_tran_id, 1, 
                 d.claim_id, d.clm_loss_id, d.advice_id,
                 d.payee_cd, d.payee_class_cd, d.payee_type, 
                 (d.net_amt * d.conv_rt_b), d.currency_cd, d.conv_rt_a, --d.convert_rate, 
                 ((d.net_amt * d.conv_rt_b) / d.conv_rt_a), SYSDATE, p_user_id, 
                  v_input_vat, v_whold_tax, (d.paid_amt * d.conv_rt_b));

    IF SQL%NOTFOUND THEN               
       p_msg_alert := 'Cannot insert into GIAC_INW_CLAIM_PAYTS table.' ||
                      'Please contact your system administrator.';
    END IF;
  END LOOP;
END;
/


