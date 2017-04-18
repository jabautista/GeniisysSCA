CREATE OR REPLACE PACKAGE BODY CPI.claim_status
AS
/*
** Created by   : MAC
** Date Created : 10/09/2013
** Descriptions : Allow denial, withdrawal, cancellation of claim if total losses paid is equal to zero. Applied to transactions with DV but issued a cancellation JV.
                  Separate update of close_flag and close_flag2 to allow update of Expense Status if Loss Status is not equal to AP.
                  Disallow closing of claim if no Losses Paid amount.
                  Allow denial, withdrawal, or cancellation of claim with Expenses Paid but no Losses Paid.
                  This is a package of all function/procedures used in updating claim status in GICLS040 and GICLS039.
                  Here are the list of references used in creating this package.
                  /******************From GICLS040:
                      CHK_CAT_XOL_PAYT
                      CHK_CAT_XOL_RES
                      CHK_XOL_PAYT
                      CHK_XOL_RES
                      DENY_STATUS
                      WITHDRAW_STATUS
                      CANCEL_STATUS
                      OPEN_STATUS
                      CLOSE_STATUS
                      UPDATE_XOL_RES
                      UPDATE_XOL_PAYT
                      CHK_CANCELLED_XOL_RES
                      CHK_CANCELLED_XOL_PAYT
                      CHK_PAID_XOL_PAYT
*/    
   FUNCTION with_xol_in_reserve_cat (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
   --return 1 if there's an XOL in reserve distribution under a particular Catastrophy (same Catastrophic Code as selected claim).
      RETURN NUMBER
   IS
      with_xol NUMBER;
   BEGIN
        SELECT 1
          INTO with_xol
          FROM gicl_claims a
         WHERE a.claim_id = p_claim_id
           AND a.catastrophic_cd IS NOT NULL
           AND ROWNUM = 1
           AND EXISTS (
                  SELECT 1
                    FROM gicl_reserve_ds b, gicl_claims c
                   WHERE NVL (b.negate_tag, 'N') = 'N'
                     AND b.claim_id = c.claim_id
                     AND c.catastrophic_cd = a.catastrophic_cd
                     AND c.clm_stat_cd NOT IN ('CC', 'WD', 'DN')
                     AND b.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE'));
         RETURN (with_xol);

   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0); 
   END with_xol_in_reserve_cat;
   
   FUNCTION with_xol_in_reserve (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
   --return 1 if there's an XOL in reserve distribution.
      RETURN NUMBER
   IS
      with_xol NUMBER;
   BEGIN
        SELECT 1
          INTO with_xol
          FROM gicl_reserve_ds a, gicl_claims b
         WHERE b.claim_id = p_claim_id
           AND NVL (a.negate_tag, 'N') = 'N'
           AND a.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
           AND a.claim_id = b.claim_id
           AND b.clm_stat_cd NOT IN ('CC', 'WD', 'DN')
           AND ROWNUM = 1;
         RETURN (with_xol);

   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0); 
   END with_xol_in_reserve;

   FUNCTION with_xol_in_payment_cat (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
   --return 1 if there's an XOL in settlement distribution under a particular Catastrophy (same Catastrophic Code as selected claim).
      RETURN NUMBER
   IS
      with_xol NUMBER;
   BEGIN
        SELECT 1
          INTO with_xol
          FROM gicl_claims a
         WHERE a.claim_id = p_claim_id
           AND a.catastrophic_cd IS NOT NULL
           AND ROWNUM = 1
           AND EXISTS (
                  SELECT 1
                    FROM gicl_loss_exp_ds b, gicl_claims c
                   WHERE NVL (b.negate_tag, 'N') = 'N'
                     AND b.claim_id = c.claim_id
                     AND c.catastrophic_cd = a.catastrophic_cd
                     AND b.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE'));
         RETURN (with_xol);
         
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0); 
   END with_xol_in_payment_cat;
   
   FUNCTION with_xol_in_payment (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
   --return 1 if there's an XOL in settlement distribution.
      RETURN NUMBER
   IS
      with_xol NUMBER;
   BEGIN
        SELECT 1
          INTO with_xol
          FROM gicl_loss_exp_ds a
         WHERE a.claim_id = p_claim_id
           AND NVL (a.negate_tag, 'N') = 'N'
           AND a.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
           AND ROWNUM = 1;
         RETURN (with_xol);
         
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0); 
   END with_xol_in_payment;
   
   FUNCTION with_unpaid_settlement (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
   --return 1 if there's a valid settlement with no payment yet
      RETURN NUMBER
   IS
      with_settlement NUMBER;
   BEGIN
        SELECT 1
          INTO with_settlement
          FROM gicl_clm_loss_exp a
         WHERE a.claim_id = p_claim_id
           AND NVL(a.dist_sw, 'N') = 'Y'
           AND a.tran_id IS NULL
           AND ROWNUM = 1;
         RETURN (with_settlement);
         
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0); 
   END with_unpaid_settlement;
   
   FUNCTION with_advice (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
   --return 1 if there is at least one valid advice.  
      RETURN NUMBER
   IS
      with_advice   NUMBER;
   BEGIN
      SELECT 1
        INTO with_advice
        FROM gicl_advice
       WHERE NVL(advice_flag, 'N') = 'Y'
         AND claim_id = p_claim_id
         AND ROWNUM = 1;
      
      RETURN (with_advice);   
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);      
   END with_advice; 
   
   FUNCTION with_advice_with_no_payt (p_claim_id gicl_clm_res_hist.claim_id%TYPE)  
   --return 1 if there is at least one valid advice without claim payment.
      RETURN NUMBER
   IS
      with_advice   NUMBER;
   BEGIN
      SELECT 1
        INTO with_advice
        FROM gicl_advice a, gicl_clm_loss_exp b
       WHERE a.claim_id = p_claim_id
         AND NVL (a.advice_flag, 'N') = 'Y'
         AND a.claim_id = b.claim_id
         AND a.advice_id = b.advice_id
         AND b.tran_id IS NULL
         AND b.tran_date IS NULL
         AND ROWNUM = 1;
         
      RETURN (with_advice);   
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);           
   END with_advice_with_no_payt;
   
   FUNCTION with_reserve_hist (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
   --return 1 if there is at least one peril (loss or expense) with reserve been updated using GICLS040 or GICLS039.
      RETURN NUMBER
   IS 
        with_peril  NUMBER;
   BEGIN
        SELECT 1
          INTO with_peril
          FROM gicl_clm_res_hist a, gicl_item_peril b
         WHERE b.claim_id = p_claim_id
           AND a.claim_id = b.claim_id
           AND a.item_no = b.item_no
           AND a.peril_cd = b.peril_cd
           AND a.grouped_item_no = b.grouped_item_no
           AND ROWNUM = 1
           AND (b.close_flag IN ('DC', 'CC') OR 
                b.close_flag2 IN ('DC', 'CC'));
                
         RETURN (with_peril);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0); 
   END with_reserve_hist;
   
   FUNCTION with_spoiled_endt (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
   --return 1 if at least one endorsement is spoiled
      RETURN NUMBER
   IS
        v_pol_flag VARCHAR2 (1);
   BEGIN
        SELECT 1
          INTO v_pol_flag
          FROM gipi_polbasic a, gicl_claims b
         WHERE b.claim_id = p_claim_id
           AND a.line_cd = b.line_cd
           AND a.subline_cd = b.subline_cd
           AND a.iss_cd = b.pol_iss_cd
           AND a.issue_yy = b.issue_yy
           AND a.pol_seq_no = b.pol_seq_no
           AND a.renew_no = b.renew_no
           AND NVL(a.endt_seq_no,0) > 0
           AND a.pol_flag = '5' --convert number 5 to string literal 5 to prevent ORA-01722 during re-opening of claim by MAC 01/02.2014.
           AND TRUNC(a.eff_date) <= TRUNC(b.loss_date)
           AND ROWNUM = 1;
           
         RETURN (1);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0); 
   END with_spoiled_endt;
   
   FUNCTION with_valid_peril_no_payt (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
   --return 1 if at least one valid peril has no claim payment
      RETURN NUMBER
   IS
      with_peril  NUMBER;
   BEGIN
      SELECT 1
        INTO with_peril
        FROM gicl_item_peril a
       WHERE a.claim_id = p_claim_id    
         AND ROWNUM = 1   
         AND (NVL(a.close_flag, 'AP') IN ('AP','CP','CC')
              OR NVL(close_flag2, 'AP') IN ('AP','CP','CC')) 
         AND NVL(claim_status.get_paid_amt ('L', a.claim_id, a.item_no, a.peril_cd), 0) = 0
         AND NVL(claim_status.get_paid_amt ('E', a.claim_id, a.item_no, a.peril_cd), 0) = 0;
         
         RETURN (with_peril);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0); 
   END with_valid_peril_no_payt;
   
   FUNCTION get_paid_amt (p_loss_exp VARCHAR2,
                          p_claim_id gicl_clm_res_hist.claim_id%TYPE,
                          p_item_no gicl_clm_res_hist.item_no%TYPE,
                          p_peril_cd gicl_clm_res_hist.peril_cd%TYPE)
   --return total paid amount (loss or expense) of the selected claim per item peril. 
   --return total paid amount (loss or expense) of the selected claim if no item and peril specified.
   --return NULL if no claim payment history
      RETURN NUMBER
   IS
      v_amt   NUMBER;
   BEGIN
        SELECT SUM (DECODE(p_loss_exp, 'L', losses_paid, 'E', expenses_paid) * NVL (convert_rate, 1))
          INTO v_amt
          FROM gicl_clm_res_hist
         WHERE claim_id = p_claim_id
           AND date_paid IS NOT NULL
           AND tran_id IS NOT NULL
           AND NVL (cancel_tag, 'N') = 'N'
           AND ((expenses_paid IS NOT NULL AND p_loss_exp = 'E') OR 
               (losses_paid IS NOT NULL AND p_loss_exp = 'L'))
           AND item_no = NVL(p_item_no, item_no)
           AND peril_cd = NVL(p_peril_cd, peril_cd)
         GROUP BY claim_id;

      RETURN (v_amt);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (v_amt);
   END get_paid_amt;
   
   FUNCTION get_confirmation_message (p_claim_id gicl_clm_res_hist.claim_id%TYPE,
                                      p_claim_status VARCHAR2) 
   --return confirmation message before updating claim status.
      RETURN VARCHAR2
   IS
        v_message   VARCHAR2 (4000);
        v_stat      VARCHAR2 (20);
        v_stat2     VARCHAR2 (20);
   BEGIN
    IF p_claim_status IN ('DN', 'WD', 'CC') THEN
        SELECT DECODE (p_claim_status, 'DN', 'deny', 'WD', 'withdraw', 'CC', 'cancel', ''),
               DECODE (p_claim_status, 'DN', 'denying', 'WD', 'withdrawing', 'CC', 'cancelling', '')
          INTO v_stat,
               v_stat2
          FROM dual;
          
        --if claim is under catastrophic event and reserve or payment has XOL in distribution
        IF claim_status.v_with_xol_in_reserve_cat = 1 OR
           claim_status.v_with_xol_in_payt_cat = 1 THEN
           v_message := 'Claim''s catastrophic event is distributed for Excess of Loss, '
                      || v_stat2
                      || ' this will mean redistributing all claim under the event. Are you sure you want to '
                      || v_stat
                      || ' this claim'
                      || CHR (13)
                      || '('
                      || claim_status.v_claim_number
                      || ')?';
        ELSE --non catastrophic 
           v_message := 'Are you sure you want to ' || v_stat ||
                        ' this claim' || chr(13) || '(' || claim_status.v_claim_number || ')?';
        END IF;
    ELSIF p_claim_status = 'OP' THEN
        IF claim_status.v_refresh_sw = 'Y' THEN
            IF (claim_status.v_with_reserve_hist = 1) THEN
                v_message := 'Changes in the policy had been made, re-opening the claim will '||
                             'update claim''s policy information. Some reserve records will '||
                             'be automatically redistributed. '||
                             'Are you sure you want to re-open this claim?';
            ELSE
                v_message := 'Changes in the policy had been made, re-opening the claim will '||
                             'mean updating claim''s policy information. Are you sure you want to re-open this claim?';
            END IF;        
        ELSE
            IF (claim_status.v_with_reserve_hist = 1) THEN
                v_message := 'Re-opening this claim will mean automatic redistribution of reserve. '||
                             'Are you sure you want to re-open this claim' || chr(13) ||
                             '(' || claim_status.v_claim_number || ')?';
            ELSE
                v_message := 'Are you sure you want to re-open this claim' || chr(13) ||
                             '(' || claim_status.v_claim_number || ')?';
            END IF;
        END IF;
    ELSIF p_claim_status = 'CD' THEN
        --if claim is under catastrophic event and reserve or payment has XOL in distribution and at least one valid peril has no payment
        IF (claim_status.v_with_xol_in_reserve_cat = 1 OR claim_status.v_with_xol_in_payt_cat = 1) AND
            claim_status.v_with_valid_peril_no_payt = 1 THEN
           v_message := 'Claim''s catastrophic event is XOL distributed '||
                        'and some records under the claim will be cancelled, '||
                        'closing this will redistribute all claims under the event. '||        
                        'Are you sure you want to close this?';
        
        --if claim has peril with no payment yet
        ELSIF claim_status.v_with_valid_peril_no_payt = 1 THEN
            --if claim has XOL distribution in reserve or settlement and not catastrophic
            IF claim_status.v_with_xol_in_reserve = 1 OR claim_status.v_with_xol_in_payt = 1 THEN
                v_message := 'Claim is XOL distributed and some Item-perils have no payments. ' ||
                             'Closing the claim will cancel the item-perils and will void the distribution of some records. '||
                             'Are you sure you want to close this?';
            
            --if no XOL distribution
            ELSE
                v_message := 'Item-peril without payments still exists, '||
                             'closing this claim will cause this item-peril to be cancelled. '||
                             'Are you sure you still want to close this claim' || chr(13) ||
                             '(' || claim_status.v_claim_number || ')?';
            END IF;
        
        --if all peril(s) has/have payments    
        ELSE
            --if at least one settlement has no payment and with XOL in settlement of the selected claim.
            IF claim_status.v_with_unpaid_settlement = 1 AND claim_status.v_with_xol_in_payt = 1 THEN
                v_message := 'Claim is distributed for XOL, '||
                             'closing this will mean cancellation of loss expense history without payment '||
                             'and may cause existing distribution to be invalid. '||                     
                             'Are you sure you want to close this?';
            ELSE
                v_message := 'Are you sure you want to close this claim' || chr(13) ||
                              '(' || claim_status.v_claim_number || ')?';
            END IF;
        END IF;
    END IF;
        
        RETURN (v_message);
   END get_confirmation_message;  
   
   FUNCTION get_final_message (p_claim_id gicl_clm_res_hist.claim_id%TYPE,
                               p_claim_status VARCHAR2) 
   --return final message after claim is updated.
      RETURN VARCHAR2
   IS
        v_message   VARCHAR2 (4000);
        v_stat      VARCHAR2 (20);
   BEGIN
        SELECT DECODE (p_claim_status, 'DN', 'denied.', 'WD', 'withdrawn.', 'CC', 'cancelled.', 'OP', 're-opened.', 'CD', 'closed.', '')
          INTO v_stat
          FROM dual;
        
        IF p_claim_status = 'CD' THEN --for closing only
            --if at least one claim is under catastrophic event, reserve or payment has XOL in distribution, and a peril has no payment exist
            IF (claim_status.v_with_xol_in_reserve_cat = 1 OR claim_status.v_with_xol_in_payt_cat = 1) AND
                claim_status.v_with_valid_peril_no_payt = 1 THEN
               v_message := 'Claim(s) has(have) just been ' || v_stat || 
                            ' Please redistribute all records under catastrophic event ' ||
                            claim_status.v_catastrophic_desc ||'.';
            ELSE
               v_message := 'Claim(s) has(have) just been ' || v_stat;
            END IF;
            
        ELSIF p_claim_status = 'OP' THEN --for reopening only
            v_message := 'Claim(s) has(have) just been ' || v_stat;
            
        ELSE --for denial, withdrawal, and cancellation only
            --if at least one claim is under catastrophic event and reserve or payment has XOL in distribution
            IF claim_status.v_with_xol_in_reserve_cat = 1 OR
               claim_status.v_with_xol_in_payt_cat = 1 THEN
               v_message := 'Claim(s) has(have) just been ' || v_stat || 
                            ' Please redistribute all records under catastrophic event ' ||
                            claim_status.v_catastrophic_desc ||'.';
            ELSE --non catastrophic 
               v_message := 'Claim(s) has(have) just been ' || v_stat;
            END IF;
        END IF;
        
        claim_status.reset_variables; --reset all global variables after prompting final message
        RETURN (v_message);
   END get_final_message;   
   
   FUNCTION get_catastrophic_desc (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
   --return catastrophic code and description per claim
      RETURN VARCHAR2
   IS
      v_cat     VARCHAR2 (4000);
   BEGIN
      SELECT TO_CHAR (a.catastrophic_cd) || '-' || a.catastrophic_desc
        INTO v_cat
        FROM gicl_cat_dtl a, gicl_claims b
       WHERE a.catastrophic_cd = b.catastrophic_cd
         AND NVL (a.line_cd, b.line_cd) = b.line_cd
         AND b.claim_id = p_claim_id;
         
      RETURN (v_cat);
   EXCEPTION
        WHEN NO_DATA_FOUND THEN
         RETURN ('');
   END get_catastrophic_desc;
   
   FUNCTION get_pol_flag (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
   --return pol_flag of original policy per claim
      RETURN VARCHAR2
   IS
        v_pol_flag  VARCHAR2 (1);
   BEGIN
        SELECT a.pol_flag
          INTO v_pol_flag
          FROM gipi_polbasic a, gicl_claims b
         WHERE b.claim_id = p_claim_id
           AND a.line_cd = b.line_cd
           AND a.subline_cd = b.subline_cd
           AND a.iss_cd = b.pol_iss_cd
           AND a.issue_yy = b.issue_yy
           AND a.pol_seq_no = b.pol_seq_no
           AND a.renew_no = b.renew_no
           AND NVL(a.endt_seq_no,0) = 0;
           
        RETURN (v_pol_flag);
   END get_pol_flag;
   
   FUNCTION get_ann_tsi_amt (p_claim_id gicl_clm_res_hist.claim_id%TYPE,
                             p_item_no gicl_clm_res_hist.item_no%TYPE,
                             p_peril_cd gicl_clm_res_hist.peril_cd%TYPE)
   --return annual TSI amount of claim per item peril
      RETURN NUMBER
   IS
        v_ann_tsi_amt NUMBER := 0;
   BEGIN
         SELECT SUM(tsi_amt) ann_tsi_amt
           INTO v_ann_tsi_amt 
           FROM giri_basic_info_item_sum_v a, gicl_claims b
          WHERE trunc(a.eff_date) <= trunc(b.loss_date)
              AND trunc(a.expiry_date) >= trunc(b.loss_date)
              AND a.item_no = p_item_no
              AND a.peril_cd = p_peril_cd
              AND a.line_cd = b.line_cd
              AND a.subline_cd = b.subline_cd
              AND a.iss_cd = b.pol_iss_cd
              AND a.issue_yy = b.issue_yy
              AND a.pol_seq_no = b.pol_seq_no
              AND a.renew_no = b.renew_no
            AND b.claim_id = p_claim_id;

        RETURN (v_ann_tsi_amt);
   EXCEPTION
        WHEN NO_DATA_FOUND THEN
         RETURN (v_ann_tsi_amt);
   END get_ann_tsi_amt;
   
   PROCEDURE reset_variables --reset all declared variables upon module entry and after final message.
   IS
   BEGIN
        claim_status.v_with_xol_in_reserve_cat := NULL;
        claim_status.v_with_xol_in_payt_cat := NULL;
        claim_status.v_with_xol_in_reserve := NULL;
        claim_status.v_with_xol_in_payt := NULL;
        claim_status.v_catastrophic_desc := NULL;
        claim_status.v_claim_number := NULL;
        claim_status.v_with_spoiled_endt := NULL;
        claim_status.v_with_reserve_hist := NULL;
        claim_status.v_refresh_sw := NULL;
        claim_status.v_with_valid_peril_no_payt := NULL;
        claim_status.v_with_unpaid_settlement := NULL;
   END reset_variables;
   
   FUNCTION validate_claim (p_claim_id gicl_clm_res_hist.claim_id%TYPE,
                            p_claim_status VARCHAR2) 
   --return NULL if claim is valid to be reopened, denied, withdrawn, cancelled, or closed otherwise return Error message     
      RETURN VARCHAR2
   IS
      v_err_message     VARCHAR2 (4000);
      v_stat            VARCHAR2 (10);
      v_stat2           VARCHAR2 (10);
   BEGIN
      claim_status.reset_variables; --reset all global variables every claim validation
      claim_status.v_claim_number := get_claim_number(p_claim_id);
      IF p_claim_status IN ('DN', 'WD', 'CC') THEN --for denied, withdrawn, and cancelled
        SELECT DECODE (p_claim_status, 'DN', 'deny', 'WD', 'withdraw', 'CC', 'cancel', ''),
               DECODE (p_claim_status, 'DN', 'denied', 'WD', 'withdrawn', 'CC', 'cancelled', '')
          INTO v_stat,
               v_stat2
          FROM dual;  
      
        --disallow denial, withdrawal, or cancellation of claim if losses paid has already been made.
        IF (claim_status.get_paid_amt('L', p_claim_id, NULL, NULL) > 0) THEN
            v_err_message := 'Claim cannot be ' || v_stat2 || '. Loss/Expense payment(s) has(have) already been made.';
        
        --disallow denial, withdrawal, or cancellation of claim if it has advice(s) and no payment history
        ELSIF (claim_status.get_paid_amt('L', p_claim_id, NULL, NULL) IS NULL AND 
               claim_status.get_paid_amt('E', p_claim_id, NULL, NULL) IS NULL AND 
               claim_status.with_advice(p_claim_id) = 1) THEN
            v_err_message := 'Unable to ' || v_stat || ' claim. Advice has already been generated.';
        END IF;
        
        IF v_err_message IS NULL THEN --execute codes, if valid to be denied, withdrawn, or cancelled
             IF NVL(claim_status.v_with_xol_in_reserve_cat, 0) != 1 THEN
                claim_status.v_with_xol_in_reserve_cat := claim_status.with_xol_in_reserve_cat (p_claim_id);
             END IF;
             
             IF NVL(claim_status.v_with_xol_in_payt_cat, 0) != 1 THEN
                claim_status.v_with_xol_in_payt_cat := claim_status.with_xol_in_payment_cat (p_claim_id);
             END IF;
             
             IF claim_status.with_xol_in_reserve_cat (p_claim_id) = 1 OR
                claim_status.with_xol_in_payment_cat (p_claim_id) = 1 THEN
                SELECT DECODE (claim_status.v_catastrophic_desc,
                               NULL, claim_status.get_catastrophic_desc (p_claim_id),
                               DECODE (INSTR (claim_status.v_catastrophic_desc, claim_status.get_catastrophic_desc (p_claim_id)),
                                       0, claim_status.v_catastrophic_desc || ', ' || claim_status.get_catastrophic_desc (p_claim_id))
                              )
                  INTO claim_status.v_catastrophic_desc
                  FROM DUAL; 
             END IF;
        END IF;
      
      ELSIF p_claim_status = 'OP' THEN --for re-opened
       
        --disallow reopening of claim if policy is spoiled.
        IF (claim_status.get_pol_flag(p_claim_id) = '5') THEN
            v_err_message := 'Claim cannot be re-opened. Policy has been spoiled.';
        
        --disallow reopening of claim if policy is cancelled.    
        ELSIF (claim_status.get_pol_flag(p_claim_id) = '4') THEN
            v_err_message := 'Claim cannot be re-opened. Policy has been cancelled.';
        END IF;
        
        IF v_err_message IS NULL THEN --execute codes, if valid to be re-opened
            SELECT NVL(refresh_sw, 'N') refresh_sw
              INTO claim_status.v_refresh_sw
              FROM gicl_claims
             WHERE claim_id = p_claim_id;
             
            claim_status.v_with_spoiled_endt := claim_status.with_spoiled_endt(p_claim_id);           
            claim_status.v_with_reserve_hist := claim_status.with_reserve_hist(p_claim_id);
            
        END IF;
      
      ELSIF p_claim_status = 'CD' THEN --for closed
        --disallow closing of claim if no losses paid amount
        IF ((NVL(claim_status.get_paid_amt('L', p_claim_id, NULL, NULL), 0) = 0) AND (NVL(claim_status.get_paid_amt('E', p_claim_id, NULL, NULL), 0) = 0)) THEN --added condition for Expense Kenneth 19935 08242015
            v_err_message := 'Claim cannot be closed. Loss/Expense payment(s) has(have) not yet been made.';
        
        --disallow closing of claim if at least one advice has no payment
        ELSIF (claim_status.with_advice_with_no_payt(p_claim_id) = 1) THEN
            v_err_message := 'Unable to close claim. Advice without payment exists.';
        END IF;
        
        IF v_err_message IS NULL THEN --execute codes, if valid to be closed
             IF NVL(claim_status.v_with_xol_in_reserve_cat, 0) != 1 THEN
                claim_status.v_with_xol_in_reserve_cat := claim_status.with_xol_in_reserve_cat (p_claim_id);
             END IF;
             
             IF NVL(claim_status.v_with_xol_in_payt_cat, 0) != 1 THEN
                claim_status.v_with_xol_in_payt_cat := claim_status.with_xol_in_payment_cat (p_claim_id);
             END IF;
             
             IF NVL(claim_status.v_with_xol_in_reserve, 0) != 1 THEN
                claim_status.v_with_xol_in_reserve := claim_status.with_xol_in_reserve (p_claim_id);
             END IF;
             
             IF NVL(claim_status.v_with_xol_in_payt, 0) != 1 THEN
                claim_status.v_with_xol_in_payt := claim_status.with_xol_in_payment (p_claim_id);
             END IF;
             
             IF NVL(claim_status.v_with_valid_peril_no_payt, 0) != 1 THEN
                claim_status.v_with_valid_peril_no_payt := claim_status.with_valid_peril_no_payt(p_claim_id);
             END IF;
             
             IF NVL(claim_status.v_with_unpaid_settlement, 0) != 1 THEN
                claim_status.v_with_unpaid_settlement := claim_status.with_unpaid_settlement(p_claim_id);
             END IF;
             
             IF claim_status.with_xol_in_reserve_cat (p_claim_id) = 1 OR
                claim_status.with_xol_in_payment_cat (p_claim_id) = 1 THEN
                SELECT DECODE (claim_status.v_catastrophic_desc,
                               NULL, claim_status.get_catastrophic_desc (p_claim_id),
                               DECODE (INSTR (claim_status.v_catastrophic_desc, claim_status.get_catastrophic_desc (p_claim_id)),
                                       0, claim_status.v_catastrophic_desc || ', ' || claim_status.get_catastrophic_desc (p_claim_id))
                              )
                  INTO claim_status.v_catastrophic_desc
                  FROM DUAL; 
             END IF;
        END IF;
      END IF;
      
      RETURN (v_err_message);
   END validate_claim;
   
    PROCEDURE update_status ( --update status of claim(s)
       p_claim_id       IN   gicl_clm_res_hist.claim_id%TYPE,
       p_claim_status        VARCHAR2
    )                                                  
    IS
        v_claim_status VARCHAR2 (2);
        v_peril_status VARCHAR2 (2);
        v_loss_res_amt NUMBER;
        v_exp_res_amt  NUMBER;
        v_remarks      VARCHAR2 (4000);
    BEGIN
       SELECT DECODE(p_claim_status, 'DN', giacp.v('DENIED'), 'WD', giacp.v('WITHDRAWN'), 'CC', giacp.v('CANCELLED'), 'OP', 'OP', 'CD', giacp.v('CLOSED CLAIM')),
              DECODE(p_claim_status, 'OP', 'AP', 'CD', 'CC', 'DC') --DC peril status is for cancelled, withdrawn, and denied
         INTO v_claim_status, v_peril_status
         FROM dual;
       
       claim_status.v_claim_number := get_claim_number(p_claim_id);
    
       IF p_claim_status IN ('DN', 'WD', 'CC') THEN --for denied, withdrawn, and cancelled
          --set Distribution switch of Settlement to N (Undistributed status)
          UPDATE gicl_clm_loss_exp
             SET dist_sw = 'N'
           WHERE claim_id = p_claim_id AND tran_id IS NULL AND dist_sw = 'Y';

          --set Negation tag of Settlement distribution to N (Negated status)
          UPDATE gicl_loss_exp_ds a
             SET negate_tag = 'Y'
           WHERE claim_id = p_claim_id
             AND NVL (negate_tag, 'N') = 'N'
             AND NOT EXISTS (
                    SELECT 1
                      FROM gicl_clm_loss_exp
                     WHERE claim_id = a.claim_id
                       AND clm_loss_id = a.clm_loss_id
                       AND tran_id IS NOT NULL);

          /*separate update of close_flag and close_flag2 to allow update of Expense Status if Loss Status is not equal to AP.*/
          --deny, cancel, or withdraw Loss Status if no Losses Paid and current status is AP.
          UPDATE gicl_item_peril
             SET close_flag = v_peril_status,
                 close_date = SYSDATE
           WHERE claim_id = p_claim_id 
             AND NVL (close_flag, 'AP') = 'AP'
             AND NVL(claim_status.get_paid_amt('L', claim_id, item_no, peril_cd), 0) = 0;
          
          --deny, cancel, or withdraw Expense Status if no Expenses Paid and current status is AP.
          UPDATE gicl_item_peril
             SET close_flag2 = v_peril_status,
                 close_date2 = SYSDATE
           WHERE claim_id = p_claim_id 
             AND NVL (close_flag2, 'AP') = 'AP'
             AND NVL(claim_status.get_paid_amt('E', claim_id, item_no, peril_cd), 0) = 0;
           
          --update status of claim
          UPDATE gicl_claims
             SET old_stat_cd = clm_stat_cd,
                 close_date = SYSDATE,
                 clm_stat_cd = v_claim_status,
                 user_id = NVL (giis_users_pkg.app_user, USER),
                 last_update = SYSDATE
           WHERE claim_id = p_claim_id;
           
           
           IF claim_status.with_xol_in_reserve_cat (p_claim_id) = 1 THEN
              claim_status.update_xol_res; --update Reserve amount in XOL maintenance
           END IF;
           
           IF claim_status.with_xol_in_payment_cat (p_claim_id) = 1 THEN
              claim_status.update_xol_payt; --update Paid amount in XOL maintenance
           END IF;
       
       ELSIF p_claim_status = 'OP' THEN --for re-opened
       
            --get old claim status as replacement to current status once claim is reopened.
            SELECT NVL(old_stat_cd, 'NW')
              INTO v_claim_status
              FROM gicl_claims
             WHERE claim_id = p_claim_id;
       
               UPDATE gicl_item_peril
               SET close_flag = v_peril_status,
                   close_date = NULL
             WHERE claim_id = p_claim_id
               AND close_flag IN ('CC', 'DC');
                         
            UPDATE gicl_item_peril
               SET close_flag2 = v_peril_status,
                   close_date2 = NULL
             WHERE claim_id = p_claim_id
               AND close_flag2 IN ('CC', 'DC'); 
               
            FOR sum_res IN (SELECT SUM(loss_reserve) loss_reserve,
                                   SUM(expense_reserve) exp_reserve
                              FROM gicl_clm_reserve a, gicl_item_peril b
                             WHERE a.claim_id = b.claim_id
                               AND a.item_no  = b.item_no
                               AND a.peril_cd = b.peril_cd
                               AND a.claim_id = p_claim_id
                               AND (NVL(b.close_flag, 'AP') IN ('AP','CC','CP') OR 
                                    NVL(b.close_flag2, 'AP') IN ('AP','CC','CP')))
            LOOP
               v_loss_res_amt  := sum_res.loss_reserve;
               v_exp_res_amt   := sum_res.exp_reserve;
            END LOOP;
            
          UPDATE gicl_claims
             SET old_stat_cd = clm_stat_cd,
                 close_date = NULL,
                 clm_stat_cd = v_claim_status,
                 clm_setl_date = NULL,
                 loss_res_amt = v_loss_res_amt,
                 exp_res_amt = v_exp_res_amt,
                 user_id = NVL (giis_users_pkg.app_user, USER),
                 last_update = SYSDATE
           WHERE claim_id = p_claim_id;
       
       ELSIF p_claim_status = 'CD' THEN --for closed
          --set Loss status to invalid if no Losses Paid and current status is AP.
          UPDATE gicl_item_peril
             SET close_flag = 'DC',
                 close_date = SYSDATE
           WHERE claim_id = p_claim_id 
             AND NVL (close_flag, 'AP') = 'AP'
             AND NVL(claim_status.get_paid_amt('L', claim_id, item_no, peril_cd), 0) = 0;
          
          --set Expense Status to invalid if no Expenses Paid and current status is AP.
          UPDATE gicl_item_peril
             SET close_flag2 = 'DC',
                 close_date2 = SYSDATE
           WHERE claim_id = p_claim_id 
             AND NVL (close_flag2, 'AP') = 'AP'
             AND NVL(claim_status.get_paid_amt('E', claim_id, item_no, peril_cd), 0) = 0;
          
          
          --update Loss status to Closed Claim if there's Losses Paid and current status is AP.
          UPDATE gicl_item_peril
             SET close_flag = v_peril_status,
                 close_date = SYSDATE
           WHERE claim_id = p_claim_id
             AND NVL(close_flag,'AP') = 'AP'
             AND NVL(claim_status.get_paid_amt('L', claim_id, item_no, peril_cd), 0) > 0;
                
           --update Expense status to Closed Claim if there's Expenses Paid and current status is AP.
           UPDATE gicl_item_peril
              SET close_flag2 = v_peril_status,
                  close_date2 = SYSDATE
            WHERE claim_id = p_claim_id
              AND NVL(close_flag2,'AP') = 'AP'
              AND NVL(claim_status.get_paid_amt('E', claim_id, item_no, peril_cd), 0) > 0;
           
           --set Distribution switch of Settlement to N (Undistributed status) for those records with no payment
          UPDATE gicl_clm_loss_exp
             SET dist_sw = 'N'
           WHERE claim_id = p_claim_id AND tran_id IS NULL AND dist_sw = 'Y';

          --set Negation tag of Settlement distribution to N (Negated status) for those records with no payment
          UPDATE gicl_loss_exp_ds a
             SET negate_tag = 'Y'
           WHERE claim_id = p_claim_id
             AND NVL (negate_tag, 'N') = 'N'
             AND NOT EXISTS (
                    SELECT 1
                      FROM gicl_clm_loss_exp
                     WHERE claim_id = a.claim_id
                       AND clm_loss_id = a.clm_loss_id
                       AND tran_id IS NOT NULL);
          
           IF claim_status.with_xol_in_reserve_cat (p_claim_id) = 1 THEN
              claim_status.update_xol_res; --update Reserve amount in XOL maintenance
           END IF;
           
           IF claim_status.with_xol_in_payment_cat (p_claim_id) = 1 THEN
              claim_status.update_xol_payt; --update Paid amount in XOL maintenance
           END IF;
           
           --get loss and expense reserve
           FOR sum_res IN (SELECT SUM(loss_reserve) loss_reserve,
                                   SUM(expense_reserve) exp_reserve
                              FROM gicl_clm_reserve a, gicl_item_peril b
                             WHERE a.claim_id = b.claim_id
                               AND a.item_no  = b.item_no
                               AND a.peril_cd = b.peril_cd
                               AND a.claim_id = p_claim_id
                               AND (NVL(b.close_flag, 'AP') IN ('AP','CC','CP') OR 
                                    NVL(b.close_flag2, 'AP') IN ('AP','CC','CP')))
           LOOP
              v_loss_res_amt  := sum_res.loss_reserve;
              v_exp_res_amt   := sum_res.exp_reserve;
           END LOOP;
           
           --get remarks
           FOR i IN (SELECT DECODE (e.remarks,
                                   NULL, DECODE (a.lawyer_cd,
                                                 NULL, 'Claims with pending recovery record ' --for claim with no Lawyer
                                                  || cpi.get_recovery_no(a.recovery_id)
                                                  || ' with '
                                                  || NVL (c.rec_stat_desc, 'ACTIVE')
                                                  || ' status.',
                                                    'Claims with pending recovery record ' --for claim with Lawyer
                                                 || cpi.get_recovery_no(a.recovery_id)
                                                 || ' with '
                                                 || NVL (c.rec_stat_desc, 'ACTIVE')
                                                 || ' status assigned to '
                                                 || d.payee_first_name
                                                 || ' '
                                                 || d.payee_middle_name
                                                 || ' '
                                                 || d.payee_last_name
                                                )
                                  ) remarks
                      FROM gicl_clm_recovery a,
                           gicl_rec_hist b,
                           giis_recovery_status c,
                           giis_payees d,
                           gicl_claims e
                     WHERE a.recovery_id =
                              (SELECT MAX (a1.recovery_id)
                                 FROM gicl_clm_recovery a1
                                WHERE a1.claim_id = e.claim_id
                                  AND NVL (a1.cancel_tag, 'N') NOT IN ('C', 'Y'))
                       AND a.recovery_id = b.recovery_id
                       AND b.rec_stat_cd = c.rec_stat_cd
                       AND b.rec_hist_no IN (SELECT MAX (b1.rec_hist_no)
                                               FROM gicl_rec_hist b1
                                              WHERE b1.recovery_id = a.recovery_id)
                       AND a.lawyer_cd = d.payee_no(+)
                       AND a.lawyer_class_cd = d.payee_class_cd(+)
                       AND a.claim_id = e.claim_id
                       AND e.remarks IS NULL
                       AND e.claim_id = p_claim_id)
          LOOP
            v_remarks := i.remarks;
          END LOOP;
           
           --update status of claim
          UPDATE gicl_claims
             SET old_stat_cd = clm_stat_cd,
                 close_date = SYSDATE,
                 clm_setl_date = SYSDATE,
                 clm_stat_cd = v_claim_status,
                 loss_res_amt = v_loss_res_amt,
                 exp_res_amt = v_exp_res_amt,
                 remarks = NVL(v_remarks, remarks),
                 user_id = NVL (giis_users_pkg.app_user, USER),
                 last_update = SYSDATE
           WHERE claim_id = p_claim_id;
       END IF;
  
       --COMMIT; remove this line if running on web. commit happens only on dao implement.
    END update_status;
    
    PROCEDURE update_xol_res --update Reserve amount in XOL maintenance
    IS
    BEGIN
       FOR update_xol_res IN
          (SELECT   SUM (  (DECODE(c.close_flag, 'DC', 0, 'DN', 0, 'WD', 0, NVL (a.shr_loss_res_amt, 0) * b.convert_rate))
                         + (DECODE(c.close_flag2, 'DC', 0, 'DN', 0, 'WD', 0, NVL (a.shr_exp_res_amt, 0) * b.convert_rate))
                        ) ret_amt,
                    a.grp_seq_no
               FROM gicl_reserve_ds a, gicl_clm_res_hist b, gicl_item_peril c
              WHERE NVL (a.negate_tag, 'N') = 'N'
                AND a.claim_id = b.claim_id
                AND a.clm_res_hist_id = b.clm_res_hist_id
                AND a.claim_id = c.claim_id
                AND a.item_no = c.item_no
                AND a.peril_cd = c.peril_cd
                AND a.grouped_item_no = c.grouped_item_no
                AND (NVL (c.close_flag, 'AP') IN ('AP', 'CC', 'CP') OR
                     NVL (c.close_flag2, 'AP') IN ('AP', 'CC', 'CP'))
                AND a.line_cd = SUBSTR (claim_status.v_claim_number, 1, 2)
                AND a.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
           GROUP BY a.grp_seq_no)
       LOOP
          UPDATE giis_dist_share
             SET xol_reserve_amount = update_xol_res.ret_amt
           WHERE share_cd = update_xol_res.grp_seq_no 
             AND line_cd = SUBSTR (claim_status.v_claim_number, 1, 2);
       END LOOP;
    END update_xol_res;
    
    PROCEDURE update_xol_payt --update Paid amount in XOL maintenance
    IS
    BEGIN
       FOR update_xol_paid IN
          (SELECT   SUM ((NVL (a.shr_le_adv_amt, 0) * NVL (b.currency_rate, 0))
                        ) ret_amt,
                    grp_seq_no
               FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
              WHERE a.claim_id = b.claim_id
                AND a.clm_loss_id = b.clm_loss_id
                AND NVL (b.cancel_sw, 'N') = 'N'
                AND NVL (a.negate_tag, 'N') = 'N'
                AND a.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                AND a.line_cd = SUBSTR (claim_status.v_claim_number, 1, 2)
           GROUP BY a.grp_seq_no)
       LOOP
          UPDATE giis_dist_share
             SET xol_allocated_amount = update_xol_paid.ret_amt
           WHERE share_cd = update_xol_paid.grp_seq_no
             AND line_cd = SUBSTR (claim_status.v_claim_number, 1, 2);
       END LOOP;
    END update_xol_payt;
                         
END claim_status;
/


