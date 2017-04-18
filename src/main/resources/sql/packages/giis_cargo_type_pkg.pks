CREATE OR REPLACE PACKAGE CPI.Giis_Cargo_Type_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS006 
  RECORD GROUP NAME: DSP_CARGO_TYPE 
***********************************************************************************/

	TYPE cargo_type_list_type IS RECORD (
		cargo_type			giis_cargo_type.cargo_type%TYPE,
		cargo_type_desc		giis_cargo_type.cargo_type_desc%TYPE,
		cargo_class_cd		giis_cargo_type.cargo_class_cd%TYPE);

  TYPE cargo_type_list_tab IS TABLE OF cargo_type_list_type;
     
	FUNCTION get_cargo_type_list(p_cargo_class_cd giis_cargo_type.cargo_class_cd%TYPE)
    RETURN cargo_type_list_tab PIPELINED;
	
	FUNCTION get_cargo_type_list_tg(
		p_cargo_class_cd IN giis_cargo_type.cargo_class_cd%TYPE,
		p_find_text IN VARCHAR2)
    RETURN cargo_type_list_tab PIPELINED;

END Giis_Cargo_Type_Pkg;
/


