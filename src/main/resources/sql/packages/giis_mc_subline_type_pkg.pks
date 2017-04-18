CREATE OR REPLACE PACKAGE CPI.Giis_Mc_Subline_Type_Pkg AS

  TYPE sublinetype_list_type IS RECORD
    (subline_type_cd        GIIS_MC_SUBLINE_TYPE.subline_type_cd%TYPE,
     subline_type_desc      GIIS_MC_SUBLINE_TYPE.subline_type_desc%TYPE,
     subline_cd             GIIS_MC_SUBLINE_TYPE.subline_cd%TYPE);
  
  TYPE sublinetype_list_tab IS TABLE OF sublinetype_list_type; 
        
  FUNCTION get_sublinetype_list (p_subline    GIIS_SUBLINE.subline_cd%TYPE) 
    RETURN sublinetype_list_tab PIPELINED;
  
  FUNCTION get_all_sublinetype_list 
    RETURN sublinetype_list_tab PIPELINED;

  
END Giis_Mc_Subline_Type_Pkg;
/


