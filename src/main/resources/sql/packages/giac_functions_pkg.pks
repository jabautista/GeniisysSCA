CREATE OR REPLACE PACKAGE CPI.giac_functions_pkg AS
  
  FUNCTION get_function_name(
    p_module_id giac_modules.module_name%TYPE,
    p_function_code giac_functions.function_code%TYPE)
    RETURN giac_functions.function_name%TYPE;                         

END giac_functions_pkg;
/


