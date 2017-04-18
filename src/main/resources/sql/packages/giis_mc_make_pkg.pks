CREATE OR REPLACE PACKAGE CPI.Giis_Mc_Make_Pkg AS

  TYPE make_list_type IS RECORD
    (make_cd          GIIS_MC_MAKE.make_cd%TYPE,
     make                GIIS_MC_MAKE.make%TYPE,
     car_company_cd      GIIS_MC_MAKE.car_company_cd%TYPE);
     
    TYPE make_list_type1 IS RECORD (
        make_cd            GIIS_MC_MAKE.make_cd%TYPE,
        make            GIIS_MC_MAKE.make%TYPE,
        car_company_cd    GIIS_MC_MAKE.car_company_cd%TYPE,
        subline_cd        GIIS_MC_MAKE.subline_cd%TYPE);
  
  TYPE make_list_tab IS TABLE OF make_list_type;
  
    TYPE make_list_tab1 IS TABLE OF make_list_type1;
    
    TYPE make_list_type2 IS RECORD (
        car_company_cd    giis_mc_car_company.car_company_cd%TYPE,
        car_company        giis_mc_car_company.car_company%TYPE,
        make_cd            giis_mc_make.make_cd%TYPE,
        make            giis_mc_make.make%TYPE);
    
    TYPE make_list_tab2 IS TABLE OF make_list_type2;
        
  FUNCTION get_make_list  (p_company_cd     GIIS_MC_MAKE.car_company_cd%TYPE) 
    RETURN make_list_tab PIPELINED;
     
  FUNCTION get_make_list_by_subline (p_subline_cd GIIS_MC_MAKE.subline_cd%TYPE)
  RETURN make_list_tab PIPELINED;
  
    FUNCTION get_make_list_by_subline1 (p_subline_cd GIIS_MC_MAKE.subline_cd%TYPE)
    RETURN make_list_tab1 PIPELINED;
    
    FUNCTION get_make_list_by_subl_car_cd (
        p_subline_cd IN giis_mc_make.subline_cd%TYPE,
        p_car_company_cd IN giis_mc_make.car_company_cd%TYPE)
    RETURN make_list_tab2 PIPELINED;
    
    FUNCTION get_make_list_subl_car_cd_tg (
        p_subline_cd IN giis_mc_make.subline_cd%TYPE,
        p_car_company_cd IN giis_mc_make.car_company_cd%TYPE,
        p_find_text IN VARCHAR2)
    RETURN make_list_tab2 PIPELINED;
    
    FUNCTION get_make_list_by_cmpny_cd (p_car_company_cd   giis_mc_make.car_company_cd%TYPE)
    RETURN make_list_tab2 PIPELINED;
  
END Giis_Mc_Make_Pkg;
/


