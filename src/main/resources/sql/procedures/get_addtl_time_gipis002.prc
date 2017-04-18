DROP PROCEDURE CPI.GET_ADDTL_TIME_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Get_Addtl_Time_Gipis002
 (b540_line_cd IN VARCHAR2,
  b540_subline_cd IN VARCHAR2,
  variables_v_add_time IN OUT NUMBER) IS
  TIME        VARCHAR2(10);
BEGIN
  FOR a1 IN(SELECT a210.subline_time TIME
              FROM GIIS_SUBLINE a210
             WHERE line_cd = b540_line_cd
               AND subline_cd = b540_subline_cd) LOOP
      TIME := a1.TIME;
      EXIT;
  END LOOP;
  variables_v_add_time := TO_NUMBER(TIME);
END;
/


