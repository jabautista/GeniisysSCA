CREATE OR REPLACE PACKAGE BODY CPI.giis_loss_ctgry_pkg
AS

    FUNCTION get_loss_cat (p_line_cd giis_loss_ctgry.line_cd%TYPE)
    RETURN giis_loss_ctgry_tab PIPELINED IS
        v_cat   giis_loss_ctgry_type;
    BEGIN
        FOR i IN (SELECT loss_cat_cd code, loss_cat_des description,
                         total_tag
                    FROM giis_loss_ctgry
                   WHERE line_cd = p_line_cd
                ORDER BY loss_cat_cd ASC)
        LOOP
          v_cat.loss_cat_cd := i.code;
          v_cat.loss_cat_des := i.description;
          v_cat.total_tag := i.total_tag;
          PIPE ROW(v_cat); 
        END LOOP;
    RETURN;    
    END get_loss_cat;
   
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 09.14.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   : getting LOV for loss category 
   */  
    FUNCTION get_loss_cat(
        p_line_cd       giis_loss_ctgry.line_cd%TYPE,
        p_peril_cd      giis_loss_ctgry.peril_cd%TYPE
        )
    RETURN giis_loss_ctgry_tab PIPELINED IS
        v_cat   giis_loss_ctgry_type;
    BEGIN
        FOR i IN (SELECT loss_cat_cd code, loss_cat_des description
                    FROM giis_loss_ctgry
                   WHERE line_cd = p_line_cd
                     AND (peril_cd IS NULL OR peril_cd = p_peril_cd)
                   ORDER BY loss_cat_cd ASC)
        LOOP
          v_cat.loss_cat_cd := i.code;
          v_cat.loss_cat_des := i.description;
          PIPE ROW(v_cat); 
        END LOOP;
    RETURN;    
    END get_loss_cat;
    
    /*
   **  Created by    : Dwight See
   **  Date Created  : 05.22.2013
   **  Description   : getting LOV for loss category 
   */  
    FUNCTION get_loss_cat_cd (
        p_line_cd       giis_loss_ctgry.line_cd%TYPE
    )
    RETURN giis_loss_cd_tab PIPELINED
    IS
       ntt       giis_loss_cd_type;
       v_count   NUMBER(12);
    BEGIN
        FOR i IN(
            /*SELECT DISTINCT a.loss_cat_cd, a.loss_cat_des
              FROM giis_loss_ctgry a, gicl_item_peril b 
             WHERE a.line_cd = b.line_cd 
               AND a.line_cd = nvl(p_line_cd,b.line_cd) 
               AND a.loss_cat_cd = b.loss_cat_cd*/ -- updated by John Dolon 1-17-2014
               
               SELECT DISTINCT a.loss_cat_cd, a.loss_cat_des
              FROM giis_loss_ctgry a
             WHERE a.line_cd = nvl(p_line_cd,A.line_cd) 
        )
        
        LOOP
        
        ntt.loss_cat_des := i.loss_cat_des;
        ntt.loss_cat_cd  := i.loss_cat_cd;
        PIPE ROW(ntt);
        
        END LOOP;
        RETURN;
    END get_loss_cat_cd;
   
END giis_loss_ctgry_pkg;
/


