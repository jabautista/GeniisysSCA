CREATE OR REPLACE PROCEDURE CPI.validate_pack_coc_authenticate
    (p_pack_par_id  IN GIPI_PACK_PARLIST.pack_par_id%TYPE,
     p_use_default_tin IN VARCHAR2,
     p_msg_alert    OUT VARCHAR2)

AS

   v_mc_line        GIIS_LINE.line_cd%TYPE := GIISP.V('LINE_CODE_MC');
   v_msg_alert      VARCHAR2(1000);
   
BEGIN
    FOR i IN(SELECT a.par_id, a.line_cd
               FROM GIPI_PARLIST a
              WHERE a.pack_par_id = p_pack_par_id
                AND (a.line_cd = v_mc_line  
                 OR GIIS_LINE_PKG.get_menu_line_cd(a.line_cd) = v_mc_line)
                AND a.par_status NOT IN (98, 99))
    LOOP
        validate_coc_authentication(i.par_id, p_use_default_tin, v_msg_alert);
        
        IF(v_msg_alert IS NOT NULL) THEN
            p_msg_alert := v_msg_alert;
            RETURN;
        END IF;
        
    END LOOP;
    
END; 
/

