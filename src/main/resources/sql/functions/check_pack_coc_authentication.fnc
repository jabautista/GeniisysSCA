CREATE OR REPLACE FUNCTION CPI.check_pack_coc_authentication
    (
     p_pack_par_id IN GIPI_PACK_PARLIST.pack_par_id%TYPE,
     p_user_id     IN giis_users.user_id%TYPE
     )
RETURN VARCHAR2 AS

   v_allowed        VARCHAR2(1) := 'N';
   v_mc_line        GIIS_LINE.line_cd%TYPE := GIISP.V('LINE_CODE_MC');
   
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 10.29.2012
**  Reference By  : GIPIS055A - Post Package PAR
**  Description   : Function validates if COC authentication is allowed to be process
**                  by checking if the Package PAR has a motor car subpolicy. If a motor car subpolicy  
**                  is existing, that subpolicy must be a regular policy with one or more items
**                  having CTPL peril. For endt items with CTPL perils, GIPI_WITEM.rec_flag must be equal to 'A'
**                  indicating that items are additional items only.
*/
   
BEGIN
    FOR i IN(SELECT a.par_id, a.line_cd
               FROM GIPI_PARLIST a
              WHERE a.pack_par_id = p_pack_par_id
                AND (a.line_cd = v_mc_line  
                 OR GIIS_LINE_PKG.get_menu_line_cd(a.line_cd) = v_mc_line)
                AND a.par_status NOT IN (98, 99))
    LOOP
        BEGIN
            SELECT check_coc_authentication(i.par_id, p_user_id) coc_auth 
              INTO v_allowed
            FROM dual;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_allowed := 'N'; 
        END;
        
        IF v_allowed = 'Y' THEN
            RETURN v_allowed;
        END IF;
          
    END LOOP;
    
    RETURN v_allowed;    

END; 
/

