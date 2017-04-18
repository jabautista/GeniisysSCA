/* Created by   : Gzelle
 * Date Created : 11-04-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */
SET SERVEROUTPUT ON

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   SELECT 'Y'
     INTO v_exists
     FROM cpi.cg_ref_codes
    WHERE rv_domain = 'GIAC_ACCT_ENTRIES.ACCT_TRAN_TYPE'
      AND rv_low_value = 'K';

   IF v_exists = 'Y'
   THEN
      DELETE FROM cg_ref_codes
            WHERE rv_domain = 'GIAC_ACCT_ENTRIES.ACCT_TRAN_TYPE'
              AND rv_low_value = 'K';
      
      COMMIT;

      DBMS_OUTPUT.put_line
         ('Record with rv_domain = GIAC_ACCT_ENTRIES.ACCT_TRAN_TYPE and rv_low_value = K is successfully deleted.'
         );        
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line
         ('Record with rv_domain = GIAC_ACCT_ENTRIES.ACCT_TRAN_TYPE and rv_low_value = K is not existing in CG_REF_CODES.'
         );
END;