CREATE OR REPLACE PACKAGE CPI.Giis_Cargo_Class_Pkg 
AS
	TYPE cargo_class_list_type IS RECORD (
		cargo_class_cd		giis_cargo_class.cargo_class_cd%TYPE,
		cargo_class_desc	giis_cargo_class.cargo_class_desc%TYPE);

	TYPE cargo_class_list_tab IS TABLE OF cargo_class_list_type;
     
	FUNCTION get_cargo_class_list
    RETURN cargo_class_list_tab PIPELINED;

    FUNCTION get_cargo_class_list_tg(p_find_text IN VARCHAR2)
    RETURN cargo_class_list_tab PIPELINED;

END Giis_Cargo_Class_Pkg;
/


