CREATE OR REPLACE PACKAGE CPI.Giis_Mc_Color_Pkg AS

  TYPE basic_color_list_type IS RECORD
    (basic_color_cd        GIIS_MC_COLOR.basic_color_cd%TYPE,
     basic_color           GIIS_MC_COLOR.basic_color%TYPE);
  
  TYPE basic_color_list_tab IS TABLE OF basic_color_list_type; 
        
  FUNCTION get_basic_color_list RETURN basic_color_list_tab PIPELINED;

  FUNCTION get_basic_color_list1(p_find_text VARCHAR2) 
    RETURN basic_color_list_tab PIPELINED;

  TYPE color_list_type IS RECORD
    (color_cd        GIIS_MC_COLOR.color_cd%TYPE,
     color           GIIS_MC_COLOR.color%TYPE,
     basic_color_cd  GIIS_MC_COLOR.basic_color_cd%TYPE,
     basic_color     GIIS_MC_COLOR.basic_color%TYPE);
  
  TYPE color_list_tab IS TABLE OF color_list_type; 
        
  FUNCTION get_color_list (p_basic_color     GIIS_MC_COLOR.basic_color%TYPE) 
    RETURN color_list_tab PIPELINED;
  
  FUNCTION get_color_list1 (p_basic_color_cd     GIIS_MC_COLOR.basic_color_cd%TYPE,
                            p_find_text VARCHAR2) 
    RETURN color_list_tab PIPELINED;

  FUNCTION get_color_list_lov(p_basic_color_cd     GIIS_MC_COLOR.basic_color_cd%TYPE,
                              p_color              GIIS_MC_COLOR.color%TYPE) 
    RETURN color_list_tab PIPELINED;

  FUNCTION get_basic_color_list_lov(p_basic_color     GIIS_MC_COLOR.basic_color%TYPE) 
    RETURN color_list_tab PIPELINED;
      
  FUNCTION get_all_color_list
    RETURN color_list_tab PIPELINED;
    
  FUNCTION get_basic_color(p_basic_color_cd GIIS_MC_COLOR.basic_color_cd%TYPE)
    RETURN GIIS_MC_COLOR.basic_color%TYPE;
  
  FUNCTION get_color (p_basic_color_cd  giis_mc_color.basic_color_cd%TYPE,
                      p_color_cd        giis_mc_color.color_cd%TYPE)
   RETURN giis_mc_color.color%TYPE;  
  
END Giis_Mc_Color_Pkg;
/


