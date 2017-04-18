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
          AND rv_low_value = 'S';

   IF v_exists = 'Y'
   THEN
      DBMS_OUTPUT.put_line
         ('Record with rv_domain = GIAC_ACCT_ENTRIES.ACCT_TRAN_TYPE and rv_low_value = S is already existing in CG_REF_CODES.'
         );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      BEGIN
         INSERT INTO cg_ref_codes
                     (rv_low_value, rv_domain,
                      rv_meaning
                     )
              VALUES ('S', 'GIAC_ACCT_ENTRIES.ACCT_TRAN_TYPE',
                      'Set-up GL account'
                     );

         COMMIT;
         DBMS_OUTPUT.put_line
            ('Successfully inserted rv_domain = GIAC_ACCT_ENTRIES.ACCT_TRAN_TYPE and rv_low_value = S in CG_REF_CODES.'
            );
      END;
END;