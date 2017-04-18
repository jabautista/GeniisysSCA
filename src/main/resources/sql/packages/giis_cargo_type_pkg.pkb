CREATE OR REPLACE PACKAGE BODY CPI.Giis_Cargo_Type_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS006 
  RECORD GROUP NAME: DSP_CARGO_TYPE 
***********************************************************************************/
    /*  Date		Author					Description
    **  ==========	====================    ===================
    **  xx.xx.xxxx	xxxxxxxx                created package 
	**	09.21.2011	mark jm					created get_cargo_type_list_tg
    */
  FUNCTION get_cargo_type_list(p_cargo_class_cd GIIS_CARGO_TYPE.cargo_class_cd%TYPE)
    RETURN cargo_type_list_tab PIPELINED IS
    
    v_cargo        cargo_type_list_type;
    
  BEGIN
    FOR i IN (
        SELECT cargo_type, cargo_type_desc, cargo_class_cd 
          FROM GIIS_CARGO_TYPE 
         WHERE cargo_class_cd = NVL(p_cargo_class_cd, cargo_class_cd)
         ORDER BY upper(cargo_type_desc))
    LOOP
      v_cargo.cargo_type      := i.cargo_type;
      v_cargo.cargo_type_desc := i.cargo_type_desc;
      v_cargo.cargo_class_cd  := i.cargo_class_cd;
      PIPE ROW(v_cargo);
    END LOOP;
  
    RETURN;
  END get_cargo_type_list;
  
    FUNCTION get_cargo_type_list_tg(
        p_cargo_class_cd IN giis_cargo_type.cargo_class_cd%TYPE,
        p_find_text IN VARCHAR2)
    RETURN cargo_type_list_tab PIPELINED
    IS
        v_cargo cargo_type_list_type;
    
    BEGIN
        FOR i IN (
            SELECT cargo_type, cargo_type_desc, cargo_class_cd 
              FROM giis_cargo_type 
             WHERE cargo_class_cd = NVL(p_cargo_class_cd, cargo_class_cd)
               AND UPPER(cargo_type_desc) LIKE NVL(UPPER(p_find_text), '%%')
             ORDER BY upper(cargo_type_desc))
        LOOP
          v_cargo.cargo_type      := i.cargo_type;
          v_cargo.cargo_type_desc := i.cargo_type_desc;
          v_cargo.cargo_class_cd  := i.cargo_class_cd;
          PIPE ROW(v_cargo);
        END LOOP;
      
        RETURN;
    END get_cargo_type_list_tg;
END Giis_Cargo_Type_Pkg;
/


