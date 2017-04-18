DROP FUNCTION CPI.GIAC_VALIDATE_USER;

CREATE OR REPLACE FUNCTION CPI.GIAC_VALIDATE_USER (
   p_user_id       IN   giac_users.user_id%TYPE,
   p_function_cd   IN   giac_functions.function_code%TYPE,
   p_module_name   IN   giac_modules.module_name%TYPE
)
   RETURN VARCHAR2
IS
   v_user_function_id   giac_user_functions.user_function_id%TYPE;
BEGIN
/* Transered by: Whofeih
** Date: 06.10.2010
** for GIPIS050A 
*/

/* Modified by  : BoYeT
** date         : 02/11/2003
** modifications: simplified select statements into one statement.
**                parameter function_name was changed to function_cd
*/
   SELECT c.user_function_id
     INTO v_user_function_id
     FROM giac_modules a, giac_functions b, giac_user_functions c
    WHERE 1 = 1
      AND a.module_name = p_module_name
      AND b.module_id = a.module_id
      AND b.function_code = p_function_cd
      AND c.user_id = p_user_id
      AND c.function_code = b.function_code
      AND c.module_id = b.module_id
      AND c.valid_tag = 'Y'
      AND TRUNC (c.validity_dt) <= TRUNC (SYSDATE)
      AND (TRUNC (c.termination_dt) > SYSDATE
           OR TRUNC (c.termination_dt) IS NULL
          );

   RETURN ('TRUE');
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN ('FALSE');
END GIAC_VALIDATE_USER;
/


