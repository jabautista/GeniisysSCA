SET SERVEROUTPUT ON
DECLARE
   v_exist   NUMBER :=0;
   
BEGIN
   SELECT 1
     INTO v_exist
     FROM CPI.CG_REF_CODES
    WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
      AND rv_low_value = '4';
    
   IF v_exist = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Record with rv_domain = GIIS_DIST_SHARE.SHARE_TYPE and rv_low_value = 4 already existing in CG_REF_CODES.');    
   END IF;
   
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         INSERT INTO cg_ref_codes
              (rv_low_value, rv_domain, rv_meaning)
         VALUES 
              ('4', 'GIIS_DIST_SHARE.SHARE_TYPE', 'Excess of Loss');
         COMMIT ;

        DBMS_OUTPUT.PUT_LINE('Successfully inserted rv_domain = GIIS_DIST_SHARE.SHARE_TYPE and rv_low_value = 4 in CG_REF_CODES.');

END;