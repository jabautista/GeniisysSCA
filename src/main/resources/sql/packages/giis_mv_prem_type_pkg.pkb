CREATE OR REPLACE PACKAGE BODY CPI.GIIS_MV_PREM_TYPE_PKG AS

   /*
   **  Created by   : Veronica V. Raymundo
   **  Date Created : October 30, 2012
   **  Reference By : Motor Car Item Information
   **  Description  : Gets list of MV Premium Type based on the 
   **                 mv_type_cd parameter.
   */
    
    FUNCTION get_giis_mv_prem_type_list(p_mv_type_cd IN GIIS_MV_PREM_TYPE.mv_type_cd%TYPE,
                                     p_find_text  IN VARCHAR2)
        RETURN giis_mv_prem_type_tab PIPELINED AS
        
        v_list          giis_mv_prem_type_type;
        
    BEGIN
        FOR i IN (SELECT mv_type_cd, mv_prem_type_cd,
                         mv_prem_type_desc, remarks,
                         user_id, last_update
                    FROM GIIS_MV_PREM_TYPE
                   WHERE mv_type_cd = p_mv_type_cd)
        LOOP
            v_list.mv_type_cd         := i.mv_type_cd;
            v_list.mv_prem_type_cd    := i.mv_prem_type_cd;
            v_list.mv_prem_type_desc  := i.mv_prem_type_desc;
            v_list.remarks            := i.remarks;
            v_list.user_id            := i.user_id;
            v_list.last_update        := i.last_update;
            PIPE ROW(v_list);
            
        END LOOP;
    END;
    
   /*
   **  Created by   : Veronica V. Raymundo
   **  Date Created : October 30, 2012
   **  Reference By : Motor Car Item Information
   **  Description  : Gets description of MV Premium Type based on the 
   **                 mv_type_cd and mv_prem_type_cd parameter.
   */
    
    FUNCTION get_mv_prem_type_desc(p_mv_type_cd      IN GIIS_MV_PREM_TYPE.mv_type_cd%TYPE,
                                   p_mv_prem_type_cd IN GIIS_MV_PREM_TYPE.mv_prem_type_cd%TYPE
                                   )
        RETURN VARCHAR2 AS
        
        mv_prem_type_desc          giis_mv_prem_type.mv_prem_type_desc%TYPE;
        
    BEGIN
       FOR i IN (SELECT mv_prem_type_desc
                   FROM GIIS_MV_PREM_TYPE
                  WHERE mv_type_cd = p_mv_type_cd
                    AND mv_prem_type_cd = p_mv_prem_type_cd)
       LOOP
            mv_prem_type_desc := i.mv_prem_type_desc;
            RETURN mv_prem_type_desc;
       END LOOP;
       
       RETURN mv_prem_type_desc;
       
    END;

END GIIS_MV_PREM_TYPE_PKG; 
/

