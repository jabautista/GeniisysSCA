CREATE OR REPLACE PACKAGE CPI.GIAC_MODULE_ENTRIES_PKG
AS

  FUNCTION get_sl_type_cd (p_module_id			 GIAC_MODULE_ENTRIES.module_id%TYPE,
  		   				   p_item_no			 GIAC_MODULE_ENTRIES.item_no%TYPE)
	RETURN GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;

  TYPE get_sl_type_parameters_type IS RECORD(
        variables_assd_no           giac_parameters.param_value_v%TYPE,
        variables_ri_cd             giac_parameters.param_value_v%TYPE,
        variables_line_cd           giac_parameters.param_value_v%TYPE,
        variables_module_id         giac_modules.module_id%TYPE,
        variables_gen_type          giac_modules.generation_type%TYPE,
        variables_item_no           giac_module_entries.item_no%TYPE,
        variables_item_no2          giac_module_entries.item_no%TYPE,
        variables_sl_type_cd1       VARCHAR2(32000),
        variables_sl_type_cd2       VARCHAR2(32000),
        variables_sl_type_cd3       VARCHAR2(32000),
        variables_sl_type_cd4       VARCHAR2(32000),
        variables_sl_type_cd5       VARCHAR2(32000),
        variables_sl_type_cd6       VARCHAR2(32000),
        variables_module_name       VARCHAR2(32000),
        v_msg_Alert                 VARCHAR2(32000),
        variables_evat_name         giac_taxes.tax_name%TYPE
        );
  TYPE get_sl_type_parameters_tab IS TABLE OF get_sl_type_parameters_type;
  
  FUNCTION get_sl_type_parameters(p_module_name     VARCHAR2) 
    RETURN get_sl_type_parameters_tab PIPELINED;     
          
END GIAC_MODULE_ENTRIES_PKG;
/


