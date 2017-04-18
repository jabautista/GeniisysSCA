DROP FUNCTION CPI.GICLS032_CHECK_REQUEST;

CREATE OR REPLACE FUNCTION CPI.gicls032_check_request (
   p_claim_id            gicl_claims.claim_id%TYPE,
   p_advice_id           gicl_advice.advice_id%TYPE,
   p_function_cd         VARCHAR2
)
   RETURN VARCHAR2
IS
/**
  * Created by: Andrew Robes
  * Date created: 03.28.2012
  * Referenced by : (GICLS032 - Generate Advice)
  * Description : Converted function from gicls032 - check_request
  */
  
   v_reqapp   VARCHAR2 (1) := 'N';
   v_ctr      NUMBER       := 0;
   v_ctr2     NUMBER       := 0;
BEGIN   
   BEGIN
      SELECT COUNT (*)
        INTO v_ctr
        FROM (SELECT 1
                FROM gicl_function_override_dtl a
               WHERE function_col_val = p_claim_id
                 AND EXISTS (
                        SELECT 1
                          FROM gicl_function_override
                         WHERE override_id = a.override_id
                           AND function_cd = p_function_cd
                           AND override_user IS NOT NULL
                           AND override_date IS NOT NULL)
              UNION
              SELECT 2
                FROM gicl_function_override_dtl a
               WHERE function_col_val = p_advice_id
                 AND EXISTS (
                        SELECT 1
                          FROM gicl_function_override
                         WHERE override_id = a.override_id
                           AND function_cd = p_function_cd
                           AND override_user IS NOT NULL
                           AND override_date IS NOT NULL));

      IF v_ctr = 0
      THEN
         v_reqapp := 'N';
      END IF;
   END;

   BEGIN
      SELECT COUNT (*)
        INTO v_ctr2
        FROM giac_function_columns a
       WHERE function_cd = p_function_cd                                                                         --RAJI 06/05/2010
             AND EXISTS (SELECT 1
                           FROM giac_modules
                          WHERE module_id = a.module_id AND module_name = 'GICLS032');

      IF v_ctr2 = 0
      THEN      
         raise_application_error(-20001, 'Geniisys Exception#I#There is no Function Column set-up for '
            || 'GICLS032 '
            || 'with function code '
            || p_function_cd
            || ' in accounting function maintenance');         
      ELSIF v_ctr2 > v_ctr
      THEN
         v_reqapp := 'N';
      ELSIF v_ctr2 <= v_ctr
      THEN
         v_reqapp := 'Y';
      END IF;
   END;

   RETURN (v_reqapp);
END;
/


