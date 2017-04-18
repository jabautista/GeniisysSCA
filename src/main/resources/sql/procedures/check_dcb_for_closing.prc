CREATE OR REPLACE PROCEDURE CPI.CHECK_DCB_FOR_CLOSING (
    p_tran_id       IN GIAC_ACCTRANS.tran_id%TYPE,
    p_dcb_no        IN GIAC_COLLN_BATCH.dcb_no%TYPE,
    p_dcb_year      IN GIAC_COLLN_BATCH.dcb_year%TYPE,
    p_fund_cd       IN GIAC_COLLN_BATCH.fund_cd%TYPE,
    p_branch_cd     IN GIAC_COLLN_BATCH.branch_cd%TYPE,
    p_gicd_sum_amt  IN NUMBER,
    p_gdbd_sum_amt  IN NUMBER,
    p_dcb_date      IN VARCHAR2,
    p_mesg          OUT VARCHAR2,
    p_bank_in_or    OUT VARCHAR2,
    p_pdc_exists    OUT VARCHAR2
)IS
    v_valid       VARCHAR2(50);
    v_dcb_flag    GIAC_COLLN_BATCH.dcb_flag%TYPE;
    v_rv_meaning  cg_ref_codes.rv_meaning%TYPE;
    v_tran_flag   GIAC_ACCTRANS.tran_flag%TYPE;
    v_exist       VARCHAR2(1);
    v_cancelled   VARCHAR2(1);
    v_dcb_date    DATE;
BEGIN
   /*
   **    Created By: D.Alcantara
   **    Date Created:   05/16/2011
   **    Used in:        GIACS035
   **    Description:    checks if dcb is valid for closing
   */
   
    BEGIN
        v_dcb_date := TO_DATE(p_dcb_date, 'MM-DD-RRRR');
    EXCEPTION
        WHEN OTHERS THEN
            v_dcb_date := NULL;
    END;
   
    --marco - 03.10.2015 - added to check if there are cancelled ORs
    BEGIN
        SELECT '1'
          INTO v_cancelled
          FROM GIIS_CURRENCY a430,
               GIAC_COLLECTION_DTL gicd,
               GIAC_ORDER_OF_PAYTS giop
         WHERE gicd.gacc_tran_id = giop.gacc_tran_id
           AND ((giop.dcb_no = p_dcb_no AND NVL(with_pdc,'N') <> 'Y') 
            OR (gicd.due_dcb_no = p_dcb_no AND with_pdc = 'Y'))            
           AND ((TO_CHAR(giop.or_date,'MM-DD-RRRR') = TO_CHAR(v_dcb_date,'MM-DD-RRRR') AND NVL(with_pdc,'N') <> 'Y')
            OR (TO_CHAR(gicd.due_dcb_date,'MM-DD-RRRR') = TO_CHAR(v_dcb_date,'MM-DD-RRRR') AND with_pdc = 'Y'))            
           AND giop.gibr_branch_cd = p_branch_cd
           AND giop.gibr_gfun_fund_cd = p_fund_cd 
           AND gicd.currency_cd = a430.main_currency_cd
           AND giop.or_flag = 'C'
           AND gicd.pay_mode NOT IN ('CMI','CW','PDC', 'RCM')
           AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_cancelled := NULL;
    END;
    
    IF NVL(p_gicd_sum_amt, 0) != NVL(p_gdbd_sum_amt, 0) THEN
        IF v_cancelled IS NOT NULL THEN
            p_mesg := 'withCancelled';
        ELSE
            p_mesg := 'Total bank deposit should not be greater than total collection amount.';
        END IF;
        RETURN;
    END IF;
   
    v_valid := 'Y';
    FOR a IN (SELECT dcb_flag
          FROM giac_colln_batch
          WHERE dcb_no = p_dcb_no
          AND dcb_year = p_dcb_year
          AND branch_cd = p_branch_cd
          AND fund_cd = p_fund_cd) 
    LOOP
    v_dcb_flag := a.dcb_flag;
                
    END LOOP; 
           
    IF v_dcb_flag = 'C' THEN
        v_valid := 'This DCB No. is already closed.';
    ELSIF v_dcb_flag IN ('O', 'X') THEN
        v_valid := 'Invalid status for DCB No. It should be T';
    END IF;
    
    IF v_valid = 'Y' THEN
        FOR b IN (SELECT GACC.tran_flag tran_flag, SUBSTR(CGRC.rv_meaning, 1, 7) rv_meaning
                  FROM giac_acctrans GACC, cg_ref_codes CGRC
                  WHERE GACC.tran_id = p_tran_id
                  AND CGRC.rv_low_value = GACC.tran_flag
                  AND CGRC.rv_domain = 'GIAC_ACCTRANS.TRAN_FLAG') 
        LOOP
            v_tran_flag := b.tran_flag;
            v_rv_meaning := b.rv_meaning;
        EXIT;
        END LOOP;
              
        IF v_tran_flag <> 'O' THEN
            v_valid := 'This transaction has been ' || LOWER(v_rv_meaning) || '.';
        END IF; 
    END IF;
    
    p_mesg := v_valid;
    -- checks if bank is in O.R.
    BEGIN
    SELECT DISTINCT '1'
      INTO v_exist
      FROM giac_collection_dtl a, giac_order_of_payts b
     WHERE a.gacc_tran_id = b.gacc_tran_id
       AND b.gibr_gfun_fund_cd = p_fund_cd
       AND b.gibr_branch_cd = p_branch_cd 
       AND TO_CHAR(b.or_date,'YYYY') = TO_CHAR(p_dcb_year)
       AND b.dcb_no = p_dcb_no
       AND a.dcb_bank_cd IS NOT NULL
       AND a.dcb_bank_acct_cd IS NOT NULL;
   
    EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	    v_exist := NULL;
	END; 
    
    IF v_exist IS NOT NULL THEN
  	    p_bank_in_or := 'Y';
    ELSE
        p_bank_in_or := 'N';
    END IF;
    
    -- checks if pdc exists
    p_pdc_exists := 'N';
    
    FOR j IN (SELECT '1' exist
                 FROM giac_dcb_bank_dep
                WHERE gacc_tran_id = p_tran_id
                  AND pay_mode = 'PDC')
    LOOP
        p_pdc_exists := 'Y';
    END LOOP;
    
    
END CHECK_DCB_FOR_CLOSING;
/


DROP PUBLIC SYNONYM CHECK_DCB_FOR_CLOSING;

CREATE PUBLIC SYNONYM CHECK_DCB_FOR_CLOSING FOR CPI.CHECK_DCB_FOR_CLOSING;


