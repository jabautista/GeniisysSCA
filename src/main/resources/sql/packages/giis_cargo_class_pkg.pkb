CREATE OR REPLACE PACKAGE BODY CPI.Giis_Cargo_Class_Pkg 
AS
    /*    Date			Author					Description
    **    ==========    ====================    ===================    
	**    xx.xx.xxxx    xxxxxxxx                created get_cargo_class_list
    **    09.20.2011    mark jm                 created get_cargo_class_list_tg
    */  

	FUNCTION get_cargo_class_list
    RETURN cargo_class_list_tab PIPELINED 
	IS    
		v_cargo cargo_class_list_type;    
    BEGIN
        FOR i IN (
            SELECT cargo_class_cd, cargo_class_desc 
              FROM GIIS_CARGO_CLASS
             ORDER BY upper(cargo_class_desc))
        LOOP
            v_cargo.cargo_class_cd        := i.cargo_class_cd;
            v_cargo.cargo_class_desc    := i.cargo_class_desc;
          PIPE ROW(v_cargo);
        END LOOP;  
        RETURN;
    END get_cargo_class_list;
  
    FUNCTION get_cargo_class_list_tg(p_find_text IN VARCHAR2)
    RETURN cargo_class_list_tab PIPELINED
    IS
        v_cargo cargo_class_list_type;    
    BEGIN
        FOR i IN (
            SELECT cargo_class_cd, cargo_class_desc 
              FROM giis_cargo_class
             WHERE UPPER(cargo_class_desc) LIKE UPPER(NVL(p_find_text, cargo_class_desc))
                OR TO_CHAR(cargo_class_cd) LIKE NVL(p_find_text, TO_CHAR(cargo_class_cd))
                OR TO_CHAR(cargo_class_cd) LIKE NVL(p_find_text, '%%')
             ORDER BY upper(cargo_class_desc))
        LOOP
            v_cargo.cargo_class_cd        := i.cargo_class_cd;
            v_cargo.cargo_class_desc    := i.cargo_class_desc;
          PIPE ROW(v_cargo);
        END LOOP;

        RETURN;
    END get_cargo_class_list_tg;
END Giis_Cargo_Class_Pkg;
/


