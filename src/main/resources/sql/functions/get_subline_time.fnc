DROP FUNCTION CPI.GET_SUBLINE_TIME;

CREATE OR REPLACE FUNCTION CPI.get_subline_time(
    p_line_cd           giis_subline.line_cd%TYPE,
    p_subline_cd        giis_subline.subline_cd%TYPE
    ) RETURN VARCHAR2 IS
  v_subline_time        VARCHAR2(200);    
BEGIN  
    BEGIN
    SELECT TO_CHAR(TO_DATE(subline_time,'SSSSS'),'HH:MI AM')
      INTO v_subline_time
      FROM giis_subline
     WHERE line_cd = p_line_cd 
       AND subline_cd = p_subline_cd;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN  
        v_subline_time := NULL;    
    END; 
  RETURN v_subline_time;                       
END;
/


