DROP PROCEDURE CPI.VALIDATE_LINE_CD;

CREATE OR REPLACE PROCEDURE CPI.validate_line_cd(
    p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
    p_subline_cd    IN OUT  GIIS_SUBLINE.subline_cd%TYPE,
    p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
    p_line_name     OUT     GIIS_LINE.line_name%TYPE,
    p_module_id     IN      GIIS_MODULES.module_id%TYPE,
    p_found         OUT     VARCHAR2
)
IS
    v_line_cd               VARCHAR2(20);
    v_line_name             VARCHAR2(100);
BEGIN
    SELECT line_name
      INTO v_line_name
      FROM GIIS_LINE
     WHERE line_cd = p_line_cd
       AND line_cd = DECODE(check_user_per_line(line_cd,p_iss_cd,p_module_id),1,line_cd,NULL);
       
    IF p_subline_cd IS NOT NULL THEN
        FOR i IN(SELECT line_cd
                   FROM GIIS_SUBLINE
                  WHERE subline_cd = p_subline_cd
                    AND line_cd = p_line_cd
                    AND line_cd = DECODE(check_user_per_line(line_cd,p_iss_cd,p_module_id),1,line_cd,NULL))
        LOOP
            v_line_cd := i.line_cd;
        END LOOP;
        
        IF v_line_cd IS NULL THEN
            p_subline_cd := NULL;
        END IF;
    END IF;
   
    IF v_line_name IS NULL THEN
        p_found := 'N';
    ELSE
        p_found := 'Y';
    END IF;
END;
/


