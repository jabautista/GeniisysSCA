CREATE OR REPLACE PACKAGE CPI.Giacp
AS
  -- for parameters where param_type is varchar
  FUNCTION v (var_param_name GIAC_PARAMETERS.param_name%TYPE) RETURN VARCHAR2;

  -- for parameters where param_type is number
  FUNCTION n (var_param_name GIAC_PARAMETERS.param_name%TYPE) RETURN NUMBER;

  -- for parameters where param_type is date
  FUNCTION d (var_param_name GIAC_PARAMETERS.param_name%TYPE) RETURN DATE;
END Giacp;
/


