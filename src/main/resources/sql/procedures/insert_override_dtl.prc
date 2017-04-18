DROP PROCEDURE CPI.INSERT_OVERRIDE_DTL;

CREATE OR REPLACE PROCEDURE CPI.insert_override_dtl 
(p_override_id   IN  GICL_FUNCTION_OVERRIDE_DTL.override_id%TYPE,
 p_func_col_cd   IN  GICL_FUNCTION_OVERRIDE_DTL.function_col_cd%TYPE,
 p_func_col_val  IN  GICL_FUNCTION_OVERRIDE_DTL.function_col_val%TYPE,
 p_user_id       IN  GIIS_USERS.user_id%TYPE) IS
 
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 04.04.2012
**  Reference By  : GICLS030 - Loss/Expense History
**  Description   : Insert override details in gicl_function_override_dtl                  
*/ 
                               
BEGIN

  INSERT INTO GICL_FUNCTION_OVERRIDE_DTL
  VALUES (p_override_id, p_func_col_cd, p_func_col_val, p_user_id, SYSDATE);

END;
/


