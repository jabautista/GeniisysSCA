SET SERVEROUTPUT ON
DECLARE
   v_exist   NUMBER :=0;
   
BEGIN
   SELECT 1
     INTO v_exist
     FROM CPI.CG_REF_CODES
    WHERE rv_domain = 'GIAC_ACCTRANS.TRAN_CLASS'
      AND rv_low_value = 'CPR';
    
   IF v_exist = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Record with rv_domain = GIAC_ACCTRANS.TRAN_CLASS and rv_low_value = CPR already existing in CG_REF_CODES.');    
   END IF;
   
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         INSERT INTO cg_ref_codes
              (rv_low_value, rv_domain, rv_meaning)
         VALUES 
              ('CPR', 'GIAC_ACCTRANS.TRAN_CLASS', 'Reversal of Cancelled Policies');
         COMMIT ;

        DBMS_OUTPUT.PUT_LINE('Successfully inserted rv_domain = GIAC_ACCTRANS.TRAN_CLASS and rv_low_value = CPR in CG_REF_CODES.');

END;