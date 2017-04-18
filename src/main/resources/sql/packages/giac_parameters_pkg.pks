CREATE OR REPLACE PACKAGE CPI.GIAC_PARAMETERS_PKG
AS
  TYPE giac_parameters_type IS RECORD
    (param_type  GIAC_PARAMETERS.param_type%TYPE,
	param_value_v   GIAC_PARAMETERS.param_value_v%TYPE,
	param_name		GIAC_PARAMETERS.param_name%TYPE,
	param_value_n	GIAC_PARAMETERS.param_value_n%TYPE,	
	param_value_d   GIAC_PARAMETERS.param_value_d%TYPE);
			
  TYPE giac_parameters_tab IS TABLE OF giac_parameters_type;
  
  FUNCTION get_pol_doc_param_value_v(p_param_name IN GIAC_PARAMETERS.param_name%TYPE)
  RETURN VARCHAR2;
	
	-- for parameters with type varchar
  FUNCTION V (var_param_name GIAC_PARAMETERS.param_name%TYPE) RETURN VARCHAR2;

  -- for parameters with type number
  FUNCTION N (var_param_name GIAC_PARAMETERS.param_name%TYPE) RETURN NUMBER;

  -- for parameters with type date
  FUNCTION D (var_param_name GIAC_PARAMETERS.param_name%TYPE) RETURN DATE;  

  -- get complete parameter values
  FUNCTION GET_PARAMETER_VALUES (var_param_name GIAC_PARAMETERS.param_name%TYPE) RETURN GIAC_parameters_tab PIPELINED;
  
  FUNCTION get_branch_cd_by_user_id(p_user_id varchar2) return varchar2;
  
  PROCEDURE toggle_or_flag_sw(p_switch NUMBER);
  
END GIAC_PARAMETERS_PKG;
/


