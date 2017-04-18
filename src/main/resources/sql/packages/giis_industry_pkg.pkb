CREATE OR REPLACE PACKAGE BODY CPI.Giis_Industry_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS002 
  RECORD GROUP NAME: INDUSTRY   
***********************************************************************************/  

  FUNCTION get_industry_list 
    RETURN industry_list_tab PIPELINED IS
    
    v_industry        industry_list_type;
    
  BEGIN
    FOR i IN (
        SELECT industry_nm, industry_cd
          FROM GIIS_INDUSTRY
         ORDER BY industry_nm)
    LOOP
        v_industry.industry_nm     := i.industry_nm;
        v_industry.industry_cd     := i.industry_cd;
      PIPE ROW(v_industry);    
    END LOOP;
    
    RETURN;
  END get_industry_list;

  
/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS017 
  RECORD GROUP NAME: INDUSTRY   
***********************************************************************************/
  
  FUNCTION get_industry_filtered_list(p_industry_nm GIIS_INDUSTRY.industry_nm%TYPE)
    RETURN industry_list_tab PIPELINED IS
    
    v_industry    industry_list_type;
    
  BEGIN
    FOR i IN (
        SELECT industry_cd, industry_nm
          FROM GIIS_INDUSTRY
         WHERE industry_nm LIKE p_industry_nm || '%'
         ORDER BY industry_nm)
    LOOP
        v_industry.industry_nm     := i.industry_nm;
        v_industry.industry_cd     := i.industry_cd;
        PIPE ROW(v_industry);
    END LOOP;
    
    RETURN;
  END get_industry_filtered_list;
  
    /* Date            Author            Description
    ** ==========    ===============    ============================
    ** 01.25.2012    mark jm            returns the industry_cd of the given assd_no
    */
    FUNCTION get_industry_cd(p_assd_no IN giis_assured.assd_no%TYPE)
    RETURN NUMBER
    IS
        v_industry_cd giis_industry.industry_cd%TYPE;
    BEGIN
        FOR j IN (
            SELECT industry_nm, industry_cd
              FROM giis_industry
             WHERE industry_cd = (SELECT industry_cd 
                                    FROM giis_assured 
                                   WHERE assd_no = p_assd_no))
        LOOP         
            v_industry_cd := j.industry_cd;
            EXIT;
        END LOOP;
        
        RETURN v_industry_cd;
    END get_industry_cd;
  
END Giis_Industry_Pkg;
/


