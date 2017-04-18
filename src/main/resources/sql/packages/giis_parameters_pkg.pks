CREATE OR REPLACE PACKAGE CPI.GIIS_PARAMETERS_PKG AS

 TYPE giis_parameters_type IS RECORD(
 	param_type  	GIIS_PARAMETERS.param_type%TYPE,
    param_value_v   GIIS_PARAMETERS.param_value_v%TYPE,
    param_name    	GIIS_PARAMETERS.param_name%TYPE,
    param_value_n   GIIS_PARAMETERS.param_value_n%TYPE,    
    param_value_d   GIIS_PARAMETERS.param_value_d%TYPE,
    param_length    GIIS_PARAMETERS.param_length%TYPE);    /* added by cris 02/12/2010*/
            
  TYPE giis_parameters_tab IS TABLE OF giis_parameters_type;
  
  

 /* FUNCTION get_param_value 
    RETURN VARCHAR2;*/
  
  FUNCTION check_param_by_iss_cd(p_iss_cd    GIIS_PARAMETERS.param_name%TYPE)
    RETURN VARCHAR2;
    
  FUNCTION get_param_by_iss_cd(p_iss_cd    GIIS_PARAMETERS.param_name%TYPE)
    RETURN VARCHAR2;
/*the following functions were copied from the package GIISP*
||
|| Overview: Returns underwriting parameters value.
||
|| Major Modifications(when, who, what):
|| 10/12/2000 - RLU - Create package
||
*/

  -- for parameters with type varchar
  FUNCTION V (var_param_name GIIS_PARAMETERS.param_name%TYPE) RETURN VARCHAR2;

  -- for parameters with type number
  FUNCTION N (var_param_name GIIS_PARAMETERS.param_name%TYPE) RETURN NUMBER;

  -- for parameters with type date
  FUNCTION D (var_param_name GIIS_PARAMETERS.param_name%TYPE) RETURN DATE;  

  -- get complete parameter values
  FUNCTION GET_PARAMETER_VALUES (var_param_name GIIS_PARAMETERS.param_name%TYPE) RETURN giis_parameters_tab PIPELINED;

  TYPE giis_parameters_lines_type IS RECORD (
    ac GIIS_PARAMETERS.param_value_v%TYPE,
    av GIIS_PARAMETERS.param_value_v%TYPE,
    ca GIIS_PARAMETERS.param_value_v%TYPE,
    en GIIS_PARAMETERS.param_value_v%TYPE,
    fi GIIS_PARAMETERS.param_value_v%TYPE,
    mc GIIS_PARAMETERS.param_value_v%TYPE,
    mh GIIS_PARAMETERS.param_value_v%TYPE,
    mn GIIS_PARAMETERS.param_value_v%TYPE,
    su GIIS_PARAMETERS.param_value_v%TYPE,
    pk GIIS_PARAMETERS.param_value_v%TYPE,
    md GIIS_PARAMETERS.param_value_v%TYPE);
    
  TYPE giis_parameters_lines_tab IS TABLE OF giis_parameters_lines_type;
  
  FUNCTION get_giis_parameters_lines RETURN giis_parameters_lines_tab PIPELINED;
  
  TYPE context_parameters_type IS RECORD (
    password_expiry                 GIIS_PARAMETERS.param_value_n%TYPE,
    no_of_login_tries               GIIS_PARAMETERS.param_value_n%TYPE,
    client_banner                   GIIS_PARAMETERS.param_value_v%TYPE,
    default_color                   GIIS_PARAMETERS.param_value_v%TYPE,
    enable_mac_validation           GIIS_PARAMETERS.param_value_v%TYPE,
    enable_con_login_validation     GIIS_PARAMETERS.param_value_v%TYPE,
    no_of_app_per_user              GIIS_PARAMETERS.param_value_n%TYPE,
    enable_detailed_exception_msg   GIIS_PARAMETERS.param_value_v%TYPE,
    enable_browser_validation       GIIS_PARAMETERS.param_value_v%TYPE,
    default_language                GIIS_PARAMETERS.param_value_v%TYPE,
    enable_email_notification       GIIS_PARAMETERS.param_value_v%TYPE,
	endt_basic_info_sw       		GIIS_PARAMETERS.param_value_v%TYPE,
	item_tablegrid_sw       		GIIS_PARAMETERS.param_value_v%TYPE,
	ad_hoc_url						GIIS_PARAMETERS.param_value_v%TYPE,
    session_timeout                 GIIS_PARAMETERS.param_value_n%TYPE,
    new_password_validity           GIIS_PARAMETERS.param_value_n%TYPE,
    text_editor_font                GIIS_PARAMETERS.param_value_v%TYPE
  );
  
  TYPE context_parameters_tab IS TABLE OF context_parameters_type;
  
  FUNCTION get_context_parameters RETURN context_parameters_tab PIPELINED;
  
  PROCEDURE UPDATE_GIIS_PARAMETERS;
  
  PROCEDURE initialize_parameters(
        p_inc_special_sw     OUT giis_parameters.param_value_v%TYPE,
        p_def_is_pol_summ_sw OUT giis_parameters.param_value_v%TYPE,
        p_def_same_polno_sw  OUT giis_parameters.param_value_v%TYPE,
        p_other_branch_renewal OUT giis_parameters.param_value_v%TYPE);
        
  PROCEDURE initialize_date_formats(
    p_date_format         OUT giis_parameters.param_value_v%TYPE,
    p_lc_mn               OUT giis_parameters.param_value_v%TYPE,
    p_lc_pa               OUT giis_parameters.param_value_v%TYPE,
    p_slc_tr              OUT giis_parameters.param_value_v%TYPE,
    p_override            OUT giis_parameters.param_value_v%TYPE, 
    p_require_nr_reason   OUT giis_parameters.param_value_v%TYPE
  );
  
  PROCEDURE initialize_line_cd(
    p_msg       OUT VARCHAR2,
    p_line_ac   OUT giis_parameters.param_value_v%TYPE,
    p_line_av   OUT giis_parameters.param_value_v%TYPE,
    p_line_ca   OUT giis_parameters.param_value_v%TYPE,
    p_line_en   OUT giis_parameters.param_value_v%TYPE,
    p_line_fi   OUT giis_parameters.param_value_v%TYPE,
    p_line_mc   OUT giis_parameters.param_value_v%TYPE,
    p_line_mh   OUT giis_parameters.param_value_v%TYPE,
    p_line_mn   OUT giis_parameters.param_value_v%TYPE,
    p_line_su   OUT giis_parameters.param_value_v%TYPE,
    p_v_iss_ri  OUT giis_parameters.param_value_v%TYPE
  );
  
  PROCEDURE initialize_subline_cd(
    p_msg           OUT VARCHAR2,
    p_subline_car   OUT giis_parameters.param_value_v%TYPE,
    p_subline_ear   OUT giis_parameters.param_value_v%TYPE,
    p_subline_mbi   OUT giis_parameters.param_value_v%TYPE,
    p_subline_mlop  OUT giis_parameters.param_value_v%TYPE,
    p_subline_dos   OUT giis_parameters.param_value_v%TYPE,
    p_subline_bpv   OUT giis_parameters.param_value_v%TYPE,
    p_subline_eei   OUT giis_parameters.param_value_v%TYPE,
    p_subline_pcp   OUT giis_parameters.param_value_v%TYPE,
    p_subline_op    OUT giis_parameters.param_value_v%TYPE,
    p_subline_bbi   OUT giis_parameters.param_value_v%TYPE,
    p_subline_mop   OUT giis_parameters.param_value_v%TYPE,
    p_subline_mrn   OUT giis_parameters.param_value_v%TYPE,
    p_subline_oth   OUT giis_parameters.param_value_v%TYPE,
    p_subline_open  OUT giis_subline.subline_cd%TYPE,
    p_vessel_cd     OUT giis_parameters.param_value_v%TYPE
  );
  
  --added get_engg_subline_name by robert SR 4945 09.10.15
  FUNCTION get_engg_subline_name(
    p_subline_cd    giis_parameters.param_value_v%TYPE
  ) RETURN VARCHAR2;

END GIIS_PARAMETERS_PKG;
/


