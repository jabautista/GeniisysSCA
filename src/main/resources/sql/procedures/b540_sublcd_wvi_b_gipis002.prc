DROP PROCEDURE CPI.B540_SUBLCD_WVI_B_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.B540_Sublcd_Wvi_B_Gipis002
  (b240_line_cd IN VARCHAR2,
   b540_subline_cd IN VARCHAR2,
   variables_end_of_day OUT VARCHAR2) IS
BEGIN
  FOR T IN (SELECT NVL(time_sw,'N') time_sw
              FROM GIIS_SUBLINE
             WHERE line_cd = b240_line_cd
               AND subline_cd = b540_subline_cd) LOOP
      variables_end_of_day := T.time_sw;
      EXIT;
  END LOOP; 
END;
/


