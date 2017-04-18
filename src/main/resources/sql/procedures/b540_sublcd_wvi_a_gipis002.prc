DROP PROCEDURE CPI.B540_SUBLCD_WVI_A_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.B540_Sublcd_Wvi_A_Gipis002
  (b540_line_cd IN VARCHAR2,
   parameter_subline_cd IN VARCHAR2,
   variables_subline_MOP IN VARCHAR2,
   b240_par_id IN NUMBER,
   v_exist1 IN OUT VARCHAR2,
   v_exist IN OUT VARCHAR2) IS
BEGIN
   FOR c IN (SELECT '1'
                  FROM GIIS_SUBLINE
                 WHERE line_cd    = b540_line_cd
                   AND subline_cd = parameter_subline_cd
                   AND subline_cd <> variables_subline_MOP
                   AND op_flag = 'Y' )
     LOOP
       FOR b IN (SELECT '1'
                   FROM GIPI_WOPEN_LIAB
                  WHERE par_id = b240_par_id)
       LOOP
         v_exist1 := 'Y';
       END LOOP;
     END LOOP;
     FOR c1 IN (SELECT 'a'
                  FROM GIPI_WITEM
                 WHERE par_id = b240_par_id)
     LOOP
       v_exist := 'Y';
       EXIT;
     END LOOP;
END;
/


