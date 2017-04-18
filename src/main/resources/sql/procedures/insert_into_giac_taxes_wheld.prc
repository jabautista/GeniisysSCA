DROP PROCEDURE CPI.INSERT_INTO_GIAC_TAXES_WHELD;

CREATE OR REPLACE PROCEDURE CPI.insert_into_giac_taxes_wheld     
       (p_batch_csr_id    IN     GICL_BATCH_CSR.batch_csr_id%TYPE,
        p_tran_id         IN     GIAC_TAXES_WHELD.gacc_tran_id%TYPE,
        p_claim_id        IN     GIAC_TAXES_WHELD.claim_id%TYPE,
        p_advice_id       IN     GIAC_TAXES_WHELD.advice_id%TYPE,
        p_payee_class_cd  IN     GIAC_TAXES_WHELD.payee_class_cd%TYPE,
        p_payee_cd        IN     GIAC_TAXES_WHELD.payee_cd%TYPE,
        p_user_id         IN     GIIS_USERS.user_id%TYPE,
        p_item_no         IN     NUMBER,
        p_new_item_no     OUT    NUMBER,
        p_msg_alert       OUT    VARCHAR2) IS
        
   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.21.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Executes insert_into_giac_taxes_wheld program unit in GICLS043
   **                 
   */

BEGIN
  DECLARE
    gen_type    GIAC_MODULES.generation_type%TYPE;
    mod_name    GIAC_MODULES.module_name%TYPE;
    v_item_no   NUMBER;

  CURSOR cur_whtax IS
        SELECT  c.claim_id, c.advice_id, c.iss_cd, a. clm_loss_id, 
                a.payee_cd, a.payee_class_cd,
                b.tax_cd, NVL(SUM(b.base_amt),0) base_amt, 
                SUM(NVL(b.tax_amt,0)) tax_amount, --b.base_amt, b.tax_amt,jen.051106
                DECODE(a.currency_cd, giacp.n('CURRENCY_CD'),1, NVL(c.orig_curr_rate, c.convert_rate)) conv_rt --roset, 7/9/09, added nvl part
          FROM  GICL_CLM_LOSS_EXP a, 
                GICL_LOSS_EXP_TAX b,
                GICL_ADVICE c
          WHERE b.tax_type     = 'W'
           AND  a.clm_loss_id  = b.clm_loss_id
           AND  a.claim_id     = b.claim_id
           AND  c.advice_id    = a.advice_id
           AND  c.advice_flag  = 'Y'
           AND  c.apprvd_tag   = 'Y'
           AND  c.claim_id     = p_claim_id
           AND  c.advice_id    = p_advice_id
           AND  c.batch_csr_id = p_batch_csr_id
     GROUP BY c.claim_id, c.advice_id, c.iss_cd, a. clm_loss_id, 
              a.payee_cd, a.payee_class_cd,
              b.tax_cd, DECODE(a.currency_cd, giacp.n('CURRENCY_CD'),1, NVL(c.orig_curr_rate, c.convert_rate)); --roset, 7/9/09, added nvl part

  BEGIN
    BEGIN
      SELECT generation_type
        INTO gen_type
        FROM GIAC_MODULES
       WHERE module_name = 'GIACS017'; 
    EXCEPTION
         WHEN NO_DATA_FOUND THEN               
              p_msg_alert := 'Generation type for GIACS017 does not exist in GIAC_MODULES table.';
    END;
    
    v_item_no := p_item_no;
    
    FOR whtax IN cur_whtax LOOP
      IF whtax.iss_cd != 'RI' THEN 
          mod_name := 'GIACS017';
      ELSE
          mod_name := 'GIACS018';
      END IF;
      
      BEGIN
        SELECT generation_type
          INTO gen_type
          FROM GIAC_MODULES
         WHERE module_name = mod_name; 
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                 p_msg_alert := 'Generation type for '||mod_name||' does not exist in GIAC_MODULES table.';
      END;
 
      INSERT INTO GIAC_TAXES_WHELD(gacc_tran_id, claim_id, advice_id,
                  gen_type, payee_class_cd, item_no, 
                  payee_cd, gwtx_whtax_id, income_amt, 
                  wholding_tax_amt, user_id, last_update)
           VALUES (p_tran_id, whtax.claim_id, whtax.advice_id,
                  gen_type, whtax.payee_class_cd, v_item_no, 
                  whtax.payee_cd, whtax.tax_cd, whtax.base_amt * whtax.conv_rt, 
                  whtax.tax_amount * whtax.conv_rt , p_user_id, SYSDATE);
      IF SQL%NOTFOUND THEN
         p_msg_alert := 'Error inserting in GIAC_TAXES_WHELD table.' ||
                        'Please contact your system administrator.';
      END IF; 
      v_item_no := v_item_no + 1;
    END LOOP;
    
      p_new_item_no := v_item_no;
      -- the total withholding tax amount should be the summation 
      -- of the amounts in any withholding tax code per payee.
  END;
   
END insert_into_giac_taxes_wheld;
/


