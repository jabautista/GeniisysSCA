CREATE OR REPLACE PACKAGE BODY CPI.giac_functions_pkg AS
  

   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  04.02.2012
   **  Reference By : (GICLS0031 - Generate Advice)
   **  Description  : Function to retrieve the function name of the given module_id and function_code
   **
   */
  FUNCTION get_function_name(
    p_module_id giac_modules.module_name%TYPE,
    p_function_code giac_functions.function_code%TYPE)
    RETURN giac_functions.function_name%TYPE IS
    
    v_function_name giac_functions.function_name%TYPE;
  BEGIN
    SELECT function_name
      INTO v_function_name     
	    FROM giac_functions
	   WHERE module_id = (SELECT module_id
	                        FROM giac_modules
	                       WHERE module_name = p_module_id)
	        AND function_code = p_function_code;
          
    RETURN v_function_name;
  END get_function_name;

END giac_functions_pkg;
/


