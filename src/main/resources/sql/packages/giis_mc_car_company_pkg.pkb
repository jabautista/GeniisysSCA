CREATE OR REPLACE PACKAGE BODY CPI.Giis_Mc_Car_Company_Pkg AS
    /*    Date        Author                    Description
    **    ==========    ====================    ===================
    **    03.04.2011    mark jm                    created get_car_company
    **    09.01.2011    mark jm                    created get_car_company_list_tg
    */


  FUNCTION get_car_company_list RETURN car_company_list_tab PIPELINED  IS
    
    v_car_company         car_company_list_type;
    
  BEGIN  
  
    FOR i IN (
      SELECT car_company_cd, car_company
        FROM GIIS_MC_CAR_COMPANY 
         ORDER BY UPPER(car_company))
    LOOP
      v_car_company.car_company_cd  := i.car_company_cd;
      v_car_company.car_company     := i.car_company;                 
      PIPE ROW (v_car_company);
    END LOOP;
    
    RETURN;  
  END get_car_company_list;  
    
    FUNCTION get_car_company (p_car_company_cd IN giis_mc_car_company.car_company_cd%TYPE)
    RETURN giis_mc_car_company.car_company%TYPE
    IS
        v_car_company giis_mc_car_company.car_company%TYPE := NULL;
    BEGIN
        FOR i IN (
            SELECT car_company
              FROM giis_mc_car_company
             WHERE car_company_cd = p_car_company_cd)
        LOOP
            v_car_company := i.car_company;
            EXIT;
        END LOOP;
        
        RETURN v_car_company;
    END get_car_company;
    
    FUNCTION get_car_company_list_tg (p_find_text IN VARCHAR2)
    RETURN car_company_list_tab PIPELINED
    IS
        v_car_company car_company_list_type;    
    BEGIN
        FOR i IN (
            SELECT car_company_cd, car_company
              FROM giis_mc_car_company 
             WHERE 1 = 1
               AND (UPPER(car_company) LIKE NVL(UPPER(p_find_text), '%%') OR UPPER(car_company_cd) LIKE NVL(UPPER(p_find_text), '%%'))
             ORDER BY UPPER(car_company))
        LOOP
            v_car_company.car_company_cd  := i.car_company_cd;
            v_car_company.car_company     := i.car_company;                 
            PIPE ROW (v_car_company);
        END LOOP;
        
        RETURN;  
    END get_car_company_list_tg;
END Giis_Mc_Car_Company_Pkg;
/


