DROP FUNCTION CPI.CHECK_PRINT_ALLOWED;

CREATE OR REPLACE FUNCTION CPI.check_print_allowed(p_user_id VARCHAR2)
    RETURN VARCHAR2 AS
    
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 04.03.2012
**  Reference By  : GICLS030 - Loss/Expense History
**  Description   : Check if user is allowed to print LOA  
**                  or CSL with unpaid premium
*/ 
     
v_select VARCHAR2(1) := 'N';

BEGIN
    FOR rec IN (SELECT 'Y' one
                  FROM GIAC_USER_FUNCTIONS a, 
                       GIAC_MODULES b , 
                       GIAC_FUNCTIONS c
                 WHERE a.module_id = b.module_id 
                   AND a.module_id = c.module_id
                   AND a.function_code = c.function_code
                   AND module_name = 'GICLS070'
                   AND valid_tag = 'Y'
                   AND c.function_code = 'LO'
                   AND a.user_id = p_user_id
                   AND validity_dt < SYSDATE
                   AND NVL(termination_dt, SYSDATE) >= SYSDATE
                   AND ROWNUM = 1)
    LOOP
        v_select := rec.one;
    END LOOP;
     
    RETURN v_select;
    
END;
/


