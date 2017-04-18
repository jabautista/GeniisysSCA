CREATE OR REPLACE PACKAGE BODY CPI.Giis_Mortgagee_Pkg AS

  FUNCTION get_mortgagee_list (p_iss_cd          GIIS_MORTGAGEE.iss_cd%TYPE)  
    RETURN mortgagee_list_tab PIPELINED  IS
    
    v_mortgagee         mortgagee_list_type;
    
  BEGIN  
  
    FOR i IN (
        SELECT mortg_cd, mortg_name 
          FROM GIIS_MORTGAGEE
         WHERE iss_cd = p_iss_cd 
         ORDER BY UPPER(mortg_name))
    LOOP
      v_mortgagee.mortg_cd    := i.mortg_cd;
      v_mortgagee.mortg_name  := i.mortg_name;                 
      PIPE ROW (v_mortgagee);
    END LOOP;
    
    RETURN;  
  END get_mortgagee_list;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.15.2011
    **  Reference By     : (GIPIS002 - Basic Information)
    **  Description     : Returns the mortgagee list (policy level) based on the given parameters
    */
	--added delete_sw kenneth SR 5483 05.26.2016
    FUNCTION get_policy_mortgagee_list (
        p_par_id IN gipi_wmortgagee.par_id%TYPE,
        p_iss_cd IN giis_mortgagee.iss_cd%TYPE)
    RETURN mortgagee_list_tab1 PIPELINED
    IS
        v_mortgagee mortgagee_list_type1;
    BEGIN
        FOR i IN (
            SELECT mortg_cd, mortg_name, delete_sw 
              FROM GIIS_MORTGAGEE
             WHERE iss_cd = p_iss_cd
               AND mortg_cd NOT IN (SELECT mortg_cd
                                      FROM gipi_wmortgagee
                                     WHERE par_id = p_par_id
                                       AND item_no = 0) 
             ORDER BY UPPER(mortg_name))
        LOOP
            v_mortgagee.mortg_cd     := i.mortg_cd;
            v_mortgagee.mortg_name    := i.mortg_name;
            v_mortgagee.delete_sw   := i.delete_sw;
            PIPE ROW(v_mortgagee);
        END LOOP;
        
        RETURN;
    END get_policy_mortgagee_list;
    
    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.15.2011
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Returns the mortgagee list (item level) based on the given parameters
    */
    --added delete_sw kenneth SR 5483 05.26.2016
    FUNCTION get_item_mortgagee_list (
        p_par_id IN gipi_wmortgagee.par_id%TYPE,
        p_iss_cd IN giis_mortgagee.iss_cd%TYPE)
    RETURN mortgagee_list_tab1 PIPELINED
    IS
        v_mortgagee mortgagee_list_type1;
    BEGIN
        FOR i IN (
            SELECT mortg_cd, mortg_name, delete_sw 
              FROM GIIS_MORTGAGEE
             WHERE iss_cd = p_iss_cd
               AND mortg_cd NOT IN (SELECT mortg_cd
                                      FROM gipi_wmortgagee
                                     WHERE par_id = p_par_id
                                       AND item_no > 0) 
             ORDER BY UPPER(mortg_name))
        LOOP
            v_mortgagee.mortg_cd     := i.mortg_cd;
            v_mortgagee.mortg_name    := i.mortg_name;
            v_mortgagee.delete_sw   := i.delete_sw;
            PIPE ROW(v_mortgagee);
        END LOOP;
        
        RETURN;
    END get_item_mortgagee_list;
    
    /*
    **  Created by        : Mark JM
    **  Date Created    : 07.21.2011
    **  Reference By    : (GIPIS010 - Item Information)
    **  Description     : Returns the mortgagee list based on the given parameters
    */
    --added delete_sw kenneth SR 5483 05.26.2016
    FUNCTION get_mortgagee_list1 (
        p_par_id IN gipi_witem.par_id%TYPE,
        p_item_no IN gipi_witem.item_no%TYPE,
        p_iss_cd IN giis_mortgagee.iss_cd%TYPE,
        p_find_text IN VARCHAR2)
    RETURN mortgagee_list_tab1 PIPELINED
    IS
        v_mortgagee mortgagee_list_type1;
    BEGIN
        FOR i IN (
            SELECT mortg_cd, mortg_name, delete_sw
              FROM GIIS_MORTGAGEE
             WHERE iss_cd = p_iss_cd
               AND mortg_cd NOT IN (SELECT mortg_cd
                                      FROM gipi_wmortgagee
                                     WHERE par_id = p_par_id
                                       AND item_no = p_item_no) 
               --AND UPPER(mortg_name) LIKE UPPER(NVL(p_find_text, '%%')) commented and changed by reymon 02222013
               AND (UPPER(mortg_name) LIKE UPPER(NVL(p_find_text, '%%'))
                    OR UPPER(mortg_cd) LIKE UPPER(NVL(p_find_text, '%%')))
             ORDER BY UPPER(mortg_name))
        LOOP
            v_mortgagee.mortg_cd     := i.mortg_cd;
            v_mortgagee.mortg_name    := i.mortg_name;
            v_mortgagee.delete_sw    := i.delete_sw;
            PIPE ROW(v_mortgagee);
        END LOOP;
    END get_mortgagee_list1;
    
    FUNCTION get_mortgagee_gipis165 (
        p_iss_cd     giis_mortgagee.iss_cd%TYPE,
        p_mortg_name giis_mortgagee.mortg_name%TYPE,
        p_keyword     VARCHAR2
    )
        RETURN mortgagee_list_tab PIPELINED 
    IS
        v_mortg        mortgagee_list_type;
    BEGIN
        FOR i IN(SELECT mortg_cd, mortg_name 
                     FROM giis_mortgagee
                   WHERE iss_cd = p_iss_cd
                    AND (UPPER(mortg_cd) LIKE UPPER(NVL(p_keyword,'%')) OR
                         UPPER(mortg_name) LIKE UPPER(NVL(p_keyword,'%')))
                    AND UPPER(mortg_name) LIKE NVL('%'||UPPER(p_mortg_name)||'%','%')
                  ORDER BY mortg_name)
        LOOP
            v_mortg.mortg_cd   := i.mortg_cd;
            v_mortg.mortg_name := i.mortg_name;
            PIPE ROW(v_mortg);
        END LOOP;
    END get_mortgagee_gipis165;    
    
END Giis_Mortgagee_Pkg;
/


