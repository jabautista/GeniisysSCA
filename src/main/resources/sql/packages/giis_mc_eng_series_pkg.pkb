CREATE OR REPLACE PACKAGE BODY CPI.Giis_Mc_Eng_Series_Pkg AS
    /*    Date        Author                    Description
    **    ==========    ====================    ===================
    **    08.19.2010    mark jm                 created get_eng_series_by_subline
    **    03.04.2011    mark jm                 created get_eng_series_list1
    **    03.04.2011    mark jm                 created get_engine_series
    **    09.01.2011    mark jm                 created get_eng_series_list_tg
    */
    
  FUNCTION get_eng_series_list  (p_make_cd          GIIS_MC_MAKE.make_cd%TYPE,
                               --p_subline_cd       GIIS_MC_MAKE.subline_cd%TYPE,
                                 p_car_company_cd   GIIS_MC_MAKE.car_company_cd%TYPE
                                 ) 
    RETURN eng_series_list_tab PIPELINED  IS
    
    v_eng_series         eng_series_list_type;
    
  BEGIN  
  
    FOR i IN (
      SELECT a.series_cd, a.engine_series, b.make, b.make_cd
        FROM GIIS_MC_ENG_SERIES a, GIIS_MC_MAKE b
          WHERE a.make_cd      = b.make_cd
         AND b.make_cd      = NVL(p_make_cd, b.make_cd)
         AND b.car_company_cd = NVL(p_car_company_cd, b.car_company_cd)
        -- AND b.subline_cd = NVL(p_subline_cd, b.car_company_cd)
       ORDER BY a.engine_series )
    LOOP
      v_eng_series.series_cd      := i.series_cd;
      v_eng_series.engine_series  := i.engine_series;    
      v_eng_series.make_cd        := i.make_cd;           
      PIPE ROW (v_eng_series);
    END LOOP;
    
    RETURN;  
  END get_eng_series_list;
  
   FUNCTION get_all_eng_series_list
     RETURN eng_series_list_tab2 PIPELINED  IS
     
     v_eng_series         eng_series_list_type2;
    
  BEGIN  
  
    FOR i IN (
      SELECT a.series_cd, a.engine_series, a.make_cd,a.car_company_cd
        FROM GIIS_MC_ENG_SERIES a
 
       ORDER BY a.engine_series )
    LOOP
      v_eng_series.series_cd      := i.series_cd;
      v_eng_series.engine_series  := i.engine_series;    
      v_eng_series.make_cd        := i.make_cd;  
      v_eng_series.car_company_cd     := i.car_company_cd;       
      PIPE ROW (v_eng_series);
    END LOOP;
    
    RETURN;  
     
  END get_all_eng_series_list;  
    
    FUNCTION get_eng_series_by_subline (p_subline_cd IN GIIS_MC_MAKE.subline_cd%TYPE)
    RETURN eng_series_list_tab2 PIPELINED
    IS
        v_eng_series eng_series_list_type2;
    BEGIN
        FOR i IN (
            SELECT a.series_cd, a.engine_series, a.make_cd, a.car_company_cd
              FROM GIIS_MC_ENG_SERIES a, GIIS_MC_MAKE b
             WHERE a.car_company_cd = b.car_company_cd(+)
               AND a.make_cd = b.make_cd(+)
               AND (b.subline_cd = p_subline_cd OR b.subline_cd IS NULL)
          ORDER BY a.engine_series)
        LOOP
            v_eng_series.series_cd := i.series_cd;
            v_eng_series.engine_series := i.engine_series;
            v_eng_series.make_cd := i.make_cd;
            v_eng_series.car_company_cd := i.car_company_cd;
            
            PIPE ROW(v_eng_series);
        END LOOP;
        
        RETURN;
    END Get_Eng_Series_By_Subline;    
    
    FUNCTION get_eng_series_list1 (
        p_subline_cd IN giis_mc_make.subline_cd%TYPE,
        p_car_company_cd IN giis_mc_make.car_company_cd%TYPE,
        p_make_cd IN giis_mc_make.make_cd%TYPE) 
    RETURN eng_series_list_tab1 PIPELINED
    IS
        v_eng_series eng_series_list_type1;
    BEGIN
        FOR i IN (
            SELECT a.engine_series, a.series_cd, b.make_cd, b.make, c.car_company_cd, c.car_company
              FROM giis_mc_eng_series a, giis_mc_make b, giis_mc_car_company c
             WHERE (b.car_company_cd  = NVL(p_car_company_cd, b.car_company_cd) OR b.car_company_cd IS NULL)
               AND (b.make_cd = NVL(p_make_cd, b.make_cd) OR b.make_cd IS NULL)
               AND a.ENGINE_SERIES IS NOT NULL
               AND a.car_company_cd = b.car_company_cd
               AND b.car_company_cd = c.car_company_cd  
               AND b.make_cd = a.make_cd(+)
               AND NVL(b.subline_cd, p_subline_cd) = p_subline_cd
            ORDER BY engine_series)
        LOOP
            v_eng_series.car_company_cd    := i.car_company_cd;
            v_eng_series.car_company    := i.car_company;
            v_eng_series.make_cd        := i.make_cd;
            v_eng_series.make            := i.make;
            v_eng_series.series_cd        := i.series_cd;
            v_eng_series.engine_series     := i.engine_series;
            
            PIPE ROW(v_eng_series);
        END LOOP;
        
        RETURN;
    END get_eng_series_list1;    
    
    FUNCTION get_engine_series (        
        p_car_company_cd IN giis_mc_eng_series.car_company_cd%TYPE,
        p_make_cd IN giis_mc_eng_series.make_cd%TYPE,
        p_series_cd IN giis_mc_eng_series.series_cd%TYPE)
    RETURN giis_mc_eng_series.engine_series%TYPE
    IS    
        v_engine_series giis_mc_eng_series.engine_series%TYPE := NULL;
    BEGIN
        FOR i IN (
            SELECT a.engine_series
              FROM giis_mc_eng_series a
             WHERE a.car_company_cd = p_car_company_cd
               AND a.make_cd = p_make_cd
               AND a.series_cd = p_series_cd)
        LOOP
            v_engine_series := i.engine_series;
            EXIT;
        END LOOP;
        
        RETURN v_engine_series;
    END get_engine_series;
    
    FUNCTION get_eng_series_list_tg (
        p_subline_cd IN giis_mc_make.subline_cd%TYPE,
        p_car_company_cd IN giis_mc_make.car_company_cd%TYPE,
        p_make_cd IN giis_mc_make.make_cd%TYPE,
        p_find_text IN VARCHAR2) 
    RETURN eng_series_list_tab1 PIPELINED
    IS
        v_eng_series eng_series_list_type1;
    BEGIN
        FOR i IN (
            SELECT a.engine_series, a.series_cd, b.make_cd, b.make, c.car_company_cd, c.car_company
              FROM giis_mc_eng_series a, giis_mc_make b, giis_mc_car_company c
             WHERE (b.car_company_cd  = NVL(p_car_company_cd, b.car_company_cd) OR b.car_company_cd IS NULL)
               AND (b.make_cd = NVL(p_make_cd, b.make_cd) OR b.make_cd IS NULL)
               AND a.ENGINE_SERIES IS NOT NULL
               AND a.car_company_cd = b.car_company_cd
               AND b.car_company_cd = c.car_company_cd  
               AND b.make_cd = a.make_cd(+)
               AND NVL(b.subline_cd, p_subline_cd) = p_subline_cd
               AND UPPER(a.engine_series) LIKE NVL(UPPER(p_find_text), '%%')
            ORDER BY engine_series)
        LOOP
            v_eng_series.car_company_cd    := i.car_company_cd;
            v_eng_series.car_company    := i.car_company;
            v_eng_series.make_cd        := i.make_cd;
            v_eng_series.make            := i.make;
            v_eng_series.series_cd        := i.series_cd;
            v_eng_series.engine_series     := i.engine_series;
            
            PIPE ROW(v_eng_series);
        END LOOP;
        
        RETURN;
    END get_eng_series_list_tg;

    /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  05.03.2012
   **  Reference By : (GICLS014- Claims Motorcar Item Information)
   **  Description  : Lov for engine series in adverse third party infomation
   */
   

    function get_eng_series_adverse_lov(
        p_car_company_cd IN giis_mc_make.car_company_cd%TYPE,
        p_make_cd IN giis_mc_make.make_cd%TYPE,
        p_find_text IN VARCHAR2) return eng_series_list_tab1 PIPELINEd
        
        is
            v_eng_series eng_series_list_type1;
    begin
        
        for i in(
        SELECT series_cd, engine_series
              FROM giis_mc_eng_series
             WHERE make_cd =p_make_cd
               AND car_company_cd = p_car_company_cd
               AND (UPPER(engine_series) LIKE NVL(UPPER(p_find_text), '%%') OR UPPER(series_cd) LIKE NVL(UPPER(p_find_text), '%%'))
        )loop
        v_eng_series.series_cd := i.series_cd;
        v_eng_series.engine_series := i.engine_series;
        PIPE ROW(v_eng_series);
    end loop;
    end;
    
    FUNCTION get_eng_series_list2 (
       p_car_company_cd   IN   giis_mc_make.car_company_cd%TYPE,
       p_make_cd          IN   giis_mc_make.make_cd%TYPE
    )
       RETURN eng_series_list_tab1 PIPELINED
    IS
       v_eng_series   eng_series_list_type1;
    BEGIN
       FOR i IN (SELECT a.engine_series, a.series_cd, b.make_cd, b.make,
                        c.car_company_cd, c.car_company
                   FROM giis_mc_eng_series a,
                        giis_mc_make b,
                        giis_mc_car_company c
                  WHERE a.car_company_cd = NVL(p_car_company_cd, a.car_company_cd)
                    AND b.make_cd = NVL(p_make_cd, b.make_cd)
                    AND a.car_company_cd = b.car_company_cd
                    AND b.car_company_cd = c.car_company_cd
                    AND a.make_cd = b.make_cd(+))
       LOOP
          v_eng_series.car_company_cd := i.car_company_cd;
          v_eng_series.car_company := i.car_company;
          v_eng_series.make_cd := i.make_cd;
          v_eng_series.make := i.make;
          v_eng_series.series_cd := i.series_cd;
          v_eng_series.engine_series := i.engine_series;
          PIPE ROW (v_eng_series);
       END LOOP;

       RETURN;
    END get_eng_series_list2; 
    
END Giis_Mc_Eng_Series_Pkg;
/


