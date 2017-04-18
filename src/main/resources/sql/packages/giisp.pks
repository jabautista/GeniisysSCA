CREATE OR REPLACE PACKAGE CPI.Giisp
/*
||
|| Overview: Returns underwriting parameters value.
||
|| Major Modifications(when, who, what):
|| 10/12/2000 - RLU - Create package
||
*/
AS
  -- for parameters with type varchar
  FUNCTION V (var_param_name GIIS_PARAMETERS.param_name%TYPE) RETURN VARCHAR2;

  -- for parameters with type number
  FUNCTION N (var_param_name GIIS_PARAMETERS.param_name%TYPE) RETURN NUMBER;

  -- for parameters with type date
  FUNCTION D (var_param_name GIIS_PARAMETERS.param_name%TYPE) RETURN DATE;
END Giisp;
/


