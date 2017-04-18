CREATE OR REPLACE PACKAGE BODY CPI.Giacp
/*
|| Overview: Returns Accounting parameters
||
|| Major Modifications(when, who, what):
|| 10/12/2000 - RLU - Create package body
||
*/
AS

FUNCTION v (var_param_name GIAC_PARAMETERS.param_name%TYPE)
RETURN VARCHAR2
IS
  CURSOR get_v (var_param_name GIAC_PARAMETERS.param_name%TYPE)
  IS
     SELECT param_value_v
       FROM GIAC_PARAMETERS
      WHERE param_name = var_param_name;
     var_return  GIAC_PARAMETERS.param_value_v%TYPE:= NULL;
BEGIN
  FOR rec IN get_v(var_param_name)
  LOOP
     var_return := rec.param_value_v;
  END LOOP;
  RETURN(var_return);
END v;

FUNCTION d (var_param_name GIAC_PARAMETERS.param_name%TYPE)
RETURN DATE
IS
  CURSOR get_d (var_param_name GIAC_PARAMETERS.param_name%TYPE)
  IS
     SELECT param_value_d
       FROM GIAC_PARAMETERS
      WHERE param_name = var_param_name;
     var_return  GIAC_PARAMETERS.param_value_d%TYPE:= NULL;
BEGIN
  FOR rec IN get_d(var_param_name)
  LOOP
     var_return := rec.param_value_d;
  END LOOP;
  RETURN(var_return);
END d;

FUNCTION n (var_param_name GIAC_PARAMETERS.param_name%TYPE)
RETURN NUMBER
IS
  CURSOR get_n (var_param_name GIAC_PARAMETERS.param_name%TYPE)
  IS
     SELECT param_value_n
       FROM GIAC_PARAMETERS
      WHERE param_name = var_param_name;
     var_return  GIAC_PARAMETERS.param_value_n%TYPE := NULL;
BEGIN
  FOR rec IN get_n(var_param_name)
  LOOP
     var_return := rec.param_value_n;
  END LOOP;
  RETURN(var_return);
END n;

END Giacp;
/


