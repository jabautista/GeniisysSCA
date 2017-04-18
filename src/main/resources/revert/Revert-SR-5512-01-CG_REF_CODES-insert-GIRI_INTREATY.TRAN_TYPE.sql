SET SERVEROUTPUT ON;
/*
**  Created by   : Benjo Brito
**  Date Created : 08.03.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/

DECLARE
   v_count   NUMBER := 0;
BEGIN
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'QTR' AND rv_domain = 'GIRI_INTREATY.TRAN_TYPE';

   IF v_count > 0
   THEN
      DELETE FROM cpi.cg_ref_codes
            WHERE rv_domain = 'GIRI_INTREATY.TRAN_TYPE'
              AND rv_low_value = 'QTR';

      COMMIT;
      DBMS_OUTPUT.put_line
         ('Successfully deleted QTR rv_low_value with GIRI_INTREATY.TRAN_TYPE rv_domain from CG_REF_CODES.'
         );
   ELSE
      DBMS_OUTPUT.put_line
         ('QTR rv_low_value with GIRI_INTREATY.TRAN_TYPE rv_domain record does not exists at CG_REF_CODES.'
         );
   END IF;

   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'MTH' AND rv_domain = 'GIRI_INTREATY.TRAN_TYPE';

   IF v_count > 0
   THEN
      DELETE FROM cpi.cg_ref_codes
            WHERE rv_domain = 'GIRI_INTREATY.TRAN_TYPE'
              AND rv_low_value = 'MTH';

      COMMIT;
      DBMS_OUTPUT.put_line
         ('Successfully deleted MTH rv_low_value with GIRI_INTREATY.TRAN_TYPE rv_domain from CG_REF_CODES.'
         );
   ELSE
      DBMS_OUTPUT.put_line
         ('MTH rv_low_value with GIRI_INTREATY.TRAN_TYPE rv_domain record does not exists at CG_REF_CODES.'
         );
   END IF;
END;