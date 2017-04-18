CREATE OR REPLACE PACKAGE BODY CPI.Giis_Mc_Color_Pkg AS

  FUNCTION get_basic_color_list RETURN basic_color_list_tab PIPELINED  IS
    
    v_basic_color         basic_color_list_type;
    
  BEGIN  
    FOR i IN (
      SELECT DISTINCT basic_color_cd, basic_color
        FROM GIIS_MC_COLOR
         ORDER BY basic_color)
    LOOP
      v_basic_color.basic_color_cd  := i.basic_color_cd;
      v_basic_color.basic_color     := i.basic_color;                 
      PIPE ROW (v_basic_color);
    END LOOP;
    
    RETURN;  
  END get_basic_color_list;

/*
**  Created by        : Andrew
**  Date Modified     : 05.18.2011
**  Reference By     : 
**  Description     : Procedure to retrieve mc basic color list of values
**                  
*/
  FUNCTION get_basic_color_list1(p_find_text VARCHAR2) 
    RETURN basic_color_list_tab PIPELINED IS
    
    v_basic_color         basic_color_list_type;
    
  BEGIN  
    FOR i IN (
      SELECT DISTINCT basic_color_cd, basic_color
        FROM GIIS_MC_COLOR
       WHERE UPPER(basic_color) LIKE UPPER(NVL(p_find_text, '%%')) 
         ORDER BY basic_color)
    LOOP
      v_basic_color.basic_color_cd  := i.basic_color_cd;
      v_basic_color.basic_color     := i.basic_color;                 
      PIPE ROW (v_basic_color);
    END LOOP;
    
    RETURN;  
  END get_basic_color_list1;

    
    FUNCTION get_color_list (p_basic_color     GIIS_MC_COLOR.basic_color%TYPE) 
    RETURN color_list_tab PIPELINED
    IS
        /*
        **  Modified by        : Mark JM
        **  Date Modified     : 08.17.2010
        **  Reference By     : -
        **  Description     : Modified to handle null parameters
        **                    : Using NVL on WHERE clause affects performance
        */
        v_color         color_list_type;
    
    BEGIN
        IF p_basic_color IS NULL THEN
            FOR i IN (
                SELECT color_cd, color, basic_color_cd, basic_color
                  FROM GIIS_MC_COLOR                 
              ORDER BY color)
            LOOP
                v_color.color_cd        := i.color_cd;
                v_color.color           := i.color;
                v_color.basic_color_cd  := i.basic_color_cd;
                v_color.basic_color     := i.basic_color;                 
                PIPE ROW (v_color);
            END LOOP;
        ELSE
            FOR i IN (
                SELECT color_cd, color, basic_color_cd, basic_color
                  FROM GIIS_MC_COLOR
                 WHERE basic_color = NVL(p_basic_color, basic_color)
              ORDER BY color)
            LOOP
                v_color.color_cd        := i.color_cd;
                v_color.color           := i.color;
                v_color.basic_color_cd  := i.basic_color_cd;
                v_color.basic_color     := i.basic_color;                 
                PIPE ROW (v_color);
            END LOOP;
        END IF;    

        RETURN;  
    END get_color_list;

/*
**  Created by        : Andrew
**  Date Modified     : 05.18.2011
**  Reference By     : 
**  Description     : Procedure to retrieve mc color list of values
**                   (edited by d.alcantara, 01-12-2011, changed 1st parameter from p_basic_color to p_basic_color_cd)
**                  
*/
    FUNCTION get_color_list1 (p_basic_color_cd     GIIS_MC_COLOR.basic_color_cd%TYPE,
                              p_find_text   VARCHAR2) 
    RETURN color_list_tab PIPELINED
    IS

        v_color         color_list_type;
    
    BEGIN
        FOR i IN (
            SELECT color_cd, color, basic_color_cd, basic_color
              FROM GIIS_MC_COLOR
             WHERE basic_color_cd = NVL(p_basic_color_cd, basic_color_cd)
               AND (UPPER(color) LIKE UPPER(NVL(p_find_text, '%%')) OR UPPER(color_cd) LIKE UPPER(NVL(p_find_text, '%%'))) 
          ORDER BY color)
        LOOP
            v_color.color_cd        := i.color_cd;
            v_color.color           := i.color;
            v_color.basic_color_cd  := i.basic_color_cd;
            v_color.basic_color     := i.basic_color;                 
            PIPE ROW (v_color);
        END LOOP;

        RETURN;  
    END get_color_list1;

/*
**  Created by        : Gzelle
**  Date Modified     : 02.15.2013
**  Description       : Procedure to retrieve mc color list of values for LOV search field
**                  
*/
    FUNCTION get_color_list_lov(p_basic_color_cd     GIIS_MC_COLOR.basic_color_cd%TYPE,
                                p_color              GIIS_MC_COLOR.color%TYPE) 
    RETURN color_list_tab PIPELINED
    IS
        v_color         color_list_type;
    
    BEGIN
        FOR i IN (
            SELECT color_cd, color, basic_color_cd, basic_color
              FROM GIIS_MC_COLOR
             WHERE basic_color_cd = NVL(p_basic_color_cd, basic_color_cd)
               AND UPPER(TRIM(color)) LIKE UPPER(NVL(p_color, '%')) 
          ORDER BY color)
        LOOP
        
            v_color.color_cd        := i.color_cd;
            v_color.color           := i.color;
            v_color.basic_color_cd  := i.basic_color_cd;
            v_color.basic_color     := i.basic_color;                 
            PIPE ROW (v_color);
        END LOOP;

        RETURN;  
        
    END get_color_list_lov;

/*
**  Created by        : Gzelle
**  Date Modified     : 02.15.2013
**  Description       : Procedure to retrieve mc basic color list of values for LOV search field
**                  
*/
  FUNCTION get_basic_color_list_lov(p_basic_color GIIS_MC_COLOR.basic_color%TYPE) 
    RETURN color_list_tab PIPELINED IS
    
    v_basic_color         color_list_type;
    
  BEGIN  
    FOR i IN (
      SELECT DISTINCT basic_color_cd, basic_color
        FROM GIIS_MC_COLOR
       WHERE UPPER(TRIM(basic_color)) LIKE UPPER(NVL(p_basic_color, '%')) 
    ORDER BY basic_color)
    
    LOOP

        v_basic_color.basic_color_cd  := i.basic_color_cd;
        v_basic_color.basic_color     := i.basic_color;
        
        FOR j IN (SELECT color_cd, color
                    FROM GIIS_MC_COLOR
                   WHERE basic_color_cd = i.basic_color_cd) 
        LOOP
            v_basic_color.color_cd        := j.color_cd;
            v_basic_color.color           := j.color;
        END LOOP;
        
        PIPE ROW (v_basic_color);
        
    END LOOP;
    
    RETURN;  
    
  END get_basic_color_list_lov;
  
FUNCTION get_all_color_list
  RETURN color_list_tab PIPELINED  IS
  v_color         color_list_type;
    
  BEGIN  
    FOR i IN (
      SELECT color_cd, color, basic_color_cd, basic_color
        FROM GIIS_MC_COLOR
       ORDER BY color)
    LOOP
      v_color.color_cd        := i.color_cd;
      v_color.color           := i.color;
        v_color.basic_color_cd  := i.basic_color_cd;
         v_color.basic_color     := i.basic_color;                 
      PIPE ROW (v_color);
    END LOOP;
    
    RETURN;
    
  END get_all_color_list;   


/*
**  Created by        : Andrew
**  Date Modified     : 05.18.2011
**  Reference By     : 
**  Description     : Procedure to retrieve the basic color with the specified code
** 
*/

    FUNCTION get_basic_color (p_basic_color_cd giis_mc_color.basic_color_cd%TYPE)
       RETURN giis_mc_color.basic_color%TYPE
    IS
      v_basic_color giis_mc_color.basic_color%TYPE;
    BEGIN
       FOR i IN (SELECT basic_color
                   FROM giis_mc_color
                  WHERE basic_color_cd = p_basic_color_cd)
       LOOP
          v_basic_color := i.basic_color;
          EXIT;
       END LOOP;

       RETURN v_basic_color;
    END get_basic_color;

/*
**  Created by        : Andrew
**  Date Modified     : 05.18.2011
**  Reference By     : 
**  Description     : Procedure to retrieve the color with the specified code
** 
*/

    FUNCTION get_color (p_basic_color_cd  giis_mc_color.basic_color_cd%TYPE,
                        p_color_cd        giis_mc_color.color_cd%TYPE)
       RETURN giis_mc_color.color%TYPE
    IS
      v_color giis_mc_color.color%TYPE;
    BEGIN
       FOR i IN (SELECT color
                   FROM giis_mc_color
                  WHERE basic_color_cd = p_basic_color_cd
                    AND color_cd = p_color_cd)
                  
                  
       LOOP
          v_color := i.color;
          EXIT;
       END LOOP;

       RETURN v_color;
    END get_color;
        
END Giis_Mc_Color_Pkg;
/


