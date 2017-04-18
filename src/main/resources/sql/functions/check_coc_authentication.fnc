CREATE OR REPLACE FUNCTION CPI.check_coc_authentication
  (
    p_par_id IN GIPI_PARLIST.par_id%TYPE,
    p_user_id IN giis_cocaf_users.user_id%TYPE
  )
RETURN VARCHAR2 
AS
   v_allowed        VARCHAR2(1) := 'N';
   v_with_cocaf_user VARCHAR2(1) := 'N';
   v_line_cd        GIPI_WPOLBAS.line_cd%TYPE;
   v_mc_line        GIIS_LINE.line_cd%TYPE := GIISP.V('LINE_CODE_MC');
   v_menu_line_cd   GIIS_LINE.menu_line_cd%TYPE;
   v_reg_policy_sw  GIPI_WPOLBAS.reg_policy_sw%TYPE;
BEGIN    
    FOR a IN (  
                SELECT 1 
                  FROM giis_cocaf_users
                WHERE user_id = p_user_id                  
             )
    LOOP
        v_with_cocaf_user := 'Y';
        EXIT;
    END LOOP;    
    
    IF v_with_cocaf_user = 'Y'
    THEN
        BEGIN
            SELECT line_cd, reg_policy_sw,
                   GIIS_LINE_PKG.get_menu_line_cd(line_cd) menu_line_cd
              INTO v_line_cd, v_reg_policy_sw,
                   v_menu_line_cd
              FROM GIPI_WPOLBAS
            WHERE par_id = p_par_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            v_line_cd := NULL;
            v_menu_line_cd := NULL; 
            v_reg_policy_sw := NULL;
        END;
        
        IF v_reg_policy_sw = 'Y' AND 
          ((v_line_cd = v_mc_line) OR 
          (v_menu_line_cd = v_mc_line))THEN
            
            FOR i IN (  SELECT 'Y' 
                          FROM GIPI_WITEM a,
                               GIPI_WITMPERL b
                        WHERE a.par_id = p_par_id
                          AND a.par_id = b.par_id
                          AND a.item_no = b.item_no
                          AND NVL(b.rec_flag, 'A') = 'A'
                          AND b.line_cd = v_line_cd
                          AND b.peril_cd = GIISP.n('CTPL'))
            LOOP
                v_allowed := 'Y';
            END LOOP;
        ELSE
            v_allowed := 'N';
        END IF;
    ELSE
      v_allowed := 'N';
    END IF;
    
    RETURN v_allowed;
END; 
/

