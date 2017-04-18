CREATE OR REPLACE PACKAGE BODY CPI.Giisp
/*
||
|| Overview: Returns underwriting parameters value.
||
|| Major Modifications(when, who, what):
|| 10/12/2000 - RLU - Create package
|| 08312012 - Udel - Modified query for n and v to select correct param_type.
||
*/
AS
FUNCTION v (var_param_name GIIS_PARAMETERS.param_name%TYPE)
RETURN VARCHAR2
IS
  CURSOR get_v (var_param_name GIIS_PARAMETERS.param_name%TYPE)
  IS
     SELECT param_value_v
       FROM GIIS_PARAMETERS
      WHERE param_name  = var_param_name
        AND param_type = 'V';
  var_return GIIS_PARAMETERS.param_value_v%TYPE := NULL;
BEGIN
  OPEN get_v(var_param_name);
     FETCH get_v INTO var_return;
  CLOSE get_v;
  RETURN(VAR_RETURN);
END v;
FUNCTION d (var_param_name GIIS_PARAMETERS.param_name%TYPE)
RETURN DATE
IS
  CURSOR get_d (var_param_name GIIS_PARAMETERS.param_name%TYPE)
  IS
     SELECT param_value_d
       FROM GIIS_PARAMETERS
      WHERE param_name = var_param_name;
  var_return GIIS_PARAMETERS.param_value_d%TYPE := NULL;
BEGIN
  OPEN get_d(var_param_name);
     FETCH get_d INTO var_return;
  CLOSE get_d;
  RETURN(var_return);
END d;
FUNCTION n (var_param_name GIIS_PARAMETERS.param_name%TYPE)
RETURN NUMBER
IS
  CURSOR get_n (var_param_name GIIS_PARAMETERS.param_name%TYPE)
  IS
     SELECT param_value_n
       FROM GIIS_PARAMETERS
      WHERE param_name = var_param_name
        AND param_type = 'N';
  var_return  GIIS_PARAMETERS.param_value_n%TYPE := NULL;
BEGIN
  OPEN get_n(var_param_name);
     FETCH get_n INTO var_return;
  CLOSE get_n;
  RETURN(var_return);
END n;
END Giisp;
/


