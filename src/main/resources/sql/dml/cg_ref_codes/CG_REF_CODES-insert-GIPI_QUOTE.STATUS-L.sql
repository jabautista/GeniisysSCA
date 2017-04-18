/* Added by dren 09.22.2015
** For SR 0020388 
** INSERT TO TABLE CG_REF_CODES 
*/   

SET SERVEROUTPUT ON
DECLARE
   v_exist   NUMBER :=0;
   
BEGIN
   SELECT 1
     INTO v_exist
     FROM CPI.CG_REF_CODES
    WHERE RV_DOMAIN = 'GIPI_QUOTE.STATUS'
      AND RV_LOW_VALUE = 'L';
    
   IF v_exist = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Record with rv_domain = GIPI_QUOTE.STATUS and RV_LOW_VALUE = L already existing in CG_REF_CODES.');    
   END IF;
   
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         INSERT INTO CG_REF_CODES
              (RV_LOW_VALUE, RV_DOMAIN, RV_MEANING)
         VALUES 
              ('L', 'GIPI_QUOTE.STATUS', 'Deleted');
         COMMIT ;

        DBMS_OUTPUT.PUT_LINE('Successfully inserted rv_domain = GIPI_QUOTE.STATUS and RV_LOW_VALUE = L already existing in CG_REF_CODES.');
END;