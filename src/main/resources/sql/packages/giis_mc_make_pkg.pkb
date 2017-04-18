CREATE OR REPLACE PACKAGE BODY CPI.Giis_Mc_Make_Pkg AS
    /*    Date        Author                  Description
    **    ==========    ====================    ===================
    **    08.17.2010  mark jm                 modified get_make_list to handle null parameters
    **    08.19.2010  mark jm                 created get_make_list_by_subline1
    **    03.03.2011    mark jm                    created get_make_list_by_subl_car_cd
    **    09.01.2011    mark jm                    created get_make_list_subl_car_cd_tg
    */

    FUNCTION get_make_list  (p_company_cd     GIIS_MC_MAKE.car_company_cd%TYPE) 
    RETURN make_list_tab PIPELINED
    IS        
        v_make         make_list_type;    
    BEGIN
        IF p_company_cd IS NULL THEN
            FOR i IN (
                SELECT make_cd, make, car_company_cd
                  FROM GIIS_MC_MAKE                
              ORDER BY make )         
            LOOP
                v_make.make_cd          := i.make_cd;
                v_make.make             := i.make;
                v_make.car_company_cd := i.car_company_cd;                           
                PIPE ROW (v_make);
            END LOOP;
        ELSE
            FOR i IN (
                SELECT make_cd, make, car_company_cd
                  FROM GIIS_MC_MAKE
                 WHERE car_company_cd = p_company_cd
              ORDER BY make )         
            LOOP
                v_make.make_cd          := i.make_cd;
                v_make.make             := i.make;
                v_make.car_company_cd := i.car_company_cd;                           
                PIPE ROW (v_make);
            END LOOP;
        END IF;        

        RETURN;  
    END get_make_list;  

  FUNCTION get_make_list_by_subline  (p_subline_cd     GIIS_MC_MAKE.subline_cd%TYPE) 
    RETURN make_list_tab PIPELINED  IS
    
    v_make         make_list_type;
    
  BEGIN  
  
    FOR i IN (
      SELECT make_cd, make, car_company_cd
        FROM GIIS_MC_MAKE
        WHERE subline_cd = p_subline_cd
       ORDER BY make )
    
     
    LOOP
      v_make.make_cd          := i.make_cd;
      v_make.make             := i.make;
      v_make.car_company_cd := i.car_company_cd;                           
      PIPE ROW (v_make);
    END LOOP;
    
    RETURN;  
  END get_make_list_by_subline;  
    
    FUNCTION get_make_list_by_subline1 (p_subline_cd GIIS_MC_MAKE.subline_cd%TYPE)
    RETURN make_list_tab1 PIPELINED
    IS
        v_make make_list_type1;
    BEGIN
        FOR i IN (
            SELECT a.make_cd, a.make, a.car_company_cd, a.subline_cd
              FROM GIIS_MC_MAKE a, GIIS_MC_CAR_COMPANY b
             WHERE a.car_company_cd = b.car_company_cd
               AND (a.subline_cd = p_subline_cd OR a.subline_cd IS NULL)
          ORDER BY a.make)
        LOOP
            v_make.make_cd             := i.make_cd;
            v_make.make             := i.make;
            v_make.car_company_cd     := i.car_company_cd;
            v_make.subline_cd         := i.subline_cd;
            
            PIPE ROW(v_make);
        END LOOP;
        
        RETURN;
    END get_make_list_by_subline1;    
    
    FUNCTION get_make_list_by_subl_car_cd (
        p_subline_cd IN giis_mc_make.subline_cd%TYPE,
        p_car_company_cd IN giis_mc_make.car_company_cd%TYPE)
    RETURN make_list_tab2 PIPELINED
    IS
        v_make make_list_type2;
    BEGIN
        FOR i IN (
            SELECT DISTINCT a.make, a.make_cd, b.car_company_cd, b.car_company
              FROM giis_mc_make a, giis_mc_car_company b
             WHERE (b.car_company_cd  = NVL(p_car_company_cd, b.car_company_cd)  OR b.car_company_cd IS NULL) 
               AND a.MAKE_CD IS NOT NULL
               AND b.car_company_cd = a.car_company_cd
               AND NVL(a.subline_cd, p_subline_cd) = p_subline_cd
          ORDER BY a.make)
        LOOP
            v_make.car_company_cd    := i.car_company_cd;
            v_make.car_company        := i.car_company;
            v_make.make                := i.make;
            v_make.make_cd            := i.make_cd;            
            
            PIPE ROW(v_make);
        END LOOP;
        
        RETURN;
    END get_make_list_by_subl_car_cd;
    
    FUNCTION get_make_list_subl_car_cd_tg (
        p_subline_cd IN giis_mc_make.subline_cd%TYPE,
        p_car_company_cd IN giis_mc_make.car_company_cd%TYPE,
        p_find_text IN VARCHAR2)
    RETURN make_list_tab2 PIPELINED
    IS
        v_make make_list_type2;
    BEGIN
        FOR i IN (
            SELECT DISTINCT a.make, a.make_cd, b.car_company_cd, b.car_company
              FROM giis_mc_make a, giis_mc_car_company b
             WHERE (b.car_company_cd  = NVL(p_car_company_cd, b.car_company_cd)  OR b.car_company_cd IS NULL) 
               AND a.MAKE_CD IS NOT NULL
               AND b.car_company_cd = a.car_company_cd
               AND NVL(a.subline_cd, p_subline_cd) = p_subline_cd
               AND (UPPER(a.make) LIKE NVL(UPPER(p_find_text), '%%') OR UPPER(a.make_cd) LIKE NVL(UPPER(p_find_text), '%%'))
          ORDER BY a.make)
        LOOP
            v_make.car_company_cd    := i.car_company_cd;
            v_make.car_company        := i.car_company;
            v_make.make                := i.make;
            v_make.make_cd            := i.make_cd;            
            
            PIPE ROW(v_make);
        END LOOP;
        
        RETURN;
    END get_make_list_subl_car_cd_tg;
    
    FUNCTION get_make_list_by_cmpny_cd (p_car_company_cd   giis_mc_make.car_company_cd%TYPE)
    RETURN make_list_tab2 PIPELINED
    IS
       v_make   make_list_type2;
    BEGIN
       FOR i IN (SELECT a.make, a.make_cd, b.car_company_cd, b.car_company
                   FROM giis_mc_make a, giis_mc_car_company b
                  WHERE a.car_company_cd = NVL (p_car_company_cd, a.car_company_cd)
                    AND a.car_company_cd = b.car_company_cd)
       LOOP
          v_make.car_company_cd := i.car_company_cd;
          v_make.car_company := i.car_company;
          v_make.make := i.make;
          v_make.make_cd := i.make_cd;
          PIPE ROW (v_make);
       END LOOP;

       RETURN;
    END get_make_list_by_cmpny_cd;
    
END Giis_Mc_Make_Pkg;
/


