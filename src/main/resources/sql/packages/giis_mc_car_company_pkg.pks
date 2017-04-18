CREATE OR REPLACE PACKAGE CPI.Giis_Mc_Car_Company_Pkg AS

    TYPE car_company_list_type IS RECORD(
        car_company_cd    GIIS_MC_CAR_COMPANY.car_company_cd%TYPE,
        car_company        GIIS_MC_CAR_COMPANY.car_company%TYPE);
  
    TYPE car_company_list_tab IS TABLE OF car_company_list_type; 
        
    FUNCTION get_car_company_list RETURN car_company_list_tab PIPELINED;

    FUNCTION get_car_company (p_car_company_cd IN giis_mc_car_company.car_company_cd%TYPE)
    RETURN giis_mc_car_company.car_company%TYPE;
    
    FUNCTION get_car_company_list_tg (p_find_text IN VARCHAR2)
    RETURN car_company_list_tab PIPELINED;
    
END Giis_Mc_Car_Company_Pkg;
/


