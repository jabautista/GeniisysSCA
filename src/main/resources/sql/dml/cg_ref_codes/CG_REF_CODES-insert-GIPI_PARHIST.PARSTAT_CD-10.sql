SET SERVEROUTPUT ON
DECLARE
   v_exist   NUMBER :=0;
   
BEGIN
   SELECT 1
     INTO v_exist
     FROM CPI.CG_REF_CODES
    WHERE rv_domain = 'GIPI_PARHIST.PARSTAT_CD'
      AND rv_low_value = '10';
    
   IF v_exist = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Record with rv_domain = GIPI_PARHIST.PARSTAT_CD and rv_low_value = 10 already existing in CG_REF_CODES.');    
   END IF;
   
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         INSERT INTO cg_ref_codes
              (rv_low_value, rv_domain, rv_meaning)
         VALUES 
              ('10', 'GIPI_PARHIST.PARSTAT_CD', 'Posted');
         COMMIT ;

        DBMS_OUTPUT.PUT_LINE('Successfully inserted rv_domain = GIPI_PARHIST.PARSTAT_CD and rv_low_value = 10 in CG_REF_CODES.');

END;