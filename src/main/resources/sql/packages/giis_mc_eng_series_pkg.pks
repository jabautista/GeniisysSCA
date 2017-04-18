CREATE OR REPLACE PACKAGE CPI.Giis_Mc_Eng_Series_Pkg AS

  TYPE eng_series_list_type IS RECORD
    (series_cd          GIIS_MC_ENG_SERIES.series_cd%TYPE,
     engine_series      GIIS_MC_ENG_SERIES.engine_series%TYPE,
     make_cd GIIS_MC_ENG_SERIES.make_cd%TYPE);
  
  TYPE eng_series_list_tab IS TABLE OF eng_series_list_type; 
        
  FUNCTION get_eng_series_list (p_make_cd          GIIS_MC_MAKE.make_cd%TYPE,                                
                              --p_subline_cd       GIIS_MC_MAKE.subline_cd%TYPE,
                               p_car_company_cd   GIIS_MC_MAKE.car_company_cd%TYPE
                               ) 
    RETURN eng_series_list_tab PIPELINED;
        
    TYPE eng_series_list_type1 IS RECORD (
        car_company_cd    giis_mc_car_company.car_company_cd%TYPE,
        car_company        giis_mc_car_company.car_company%TYPE,
        make_cd            giis_mc_make.make_cd%TYPE,
        make            giis_mc_make.make%TYPE,
        series_cd        giis_mc_eng_series.series_cd%TYPE,
        engine_series    giis_mc_eng_series.engine_series%TYPE);
        
    TYPE eng_series_list_tab1 IS TABLE OF eng_series_list_type1;
    
    FUNCTION get_eng_series_list1 (
        p_subline_cd IN giis_mc_make.subline_cd%TYPE,
        p_car_company_cd IN giis_mc_make.car_company_cd%TYPE,
        p_make_cd IN giis_mc_make.make_cd%TYPE) 
    RETURN eng_series_list_tab1 PIPELINED;

   TYPE eng_series_list_type2 IS RECORD
    (series_cd          GIIS_MC_ENG_SERIES.series_cd%TYPE,
     engine_series      GIIS_MC_ENG_SERIES.engine_series%TYPE,
     make_cd GIIS_MC_ENG_SERIES.make_cd%TYPE,
     car_company_cd   GIIS_MC_ENG_SERIES.car_company_cd%TYPE
     );
  
  TYPE eng_series_list_tab2 IS TABLE OF eng_series_list_type2;
  
  FUNCTION get_all_eng_series_list
    RETURN eng_series_list_tab2 PIPELINED;
    
    FUNCTION get_eng_series_by_subline (p_subline_cd IN GIIS_MC_MAKE.subline_cd%TYPE)
    RETURN eng_series_list_tab2 PIPELINED;
    
    FUNCTION get_engine_series (        
        p_car_company_cd IN giis_mc_eng_series.car_company_cd%TYPE,
        p_make_cd IN giis_mc_eng_series.make_cd%TYPE,
        p_series_cd IN giis_mc_eng_series.series_cd%TYPE)
    RETURN giis_mc_eng_series.engine_series%TYPE;
    
    FUNCTION get_eng_series_list_tg (
        p_subline_cd IN giis_mc_make.subline_cd%TYPE,
        p_car_company_cd IN giis_mc_make.car_company_cd%TYPE,
        p_make_cd IN giis_mc_make.make_cd%TYPE,
        p_find_text IN VARCHAR2) 
    RETURN eng_series_list_tab1 PIPELINED;
    
	function get_eng_series_adverse_lov(
        p_car_company_cd IN giis_mc_make.car_company_cd%TYPE,
        p_make_cd IN giis_mc_make.make_cd%TYPE,
        p_find_text IN VARCHAR2) return eng_series_list_tab1 PIPELINED; 
        
   FUNCTION get_eng_series_list2 (
       p_car_company_cd   IN   giis_mc_make.car_company_cd%TYPE,
       p_make_cd          IN   giis_mc_make.make_cd%TYPE
    )
   RETURN eng_series_list_tab1 PIPELINED;
   
END Giis_Mc_Eng_Series_Pkg;
/


