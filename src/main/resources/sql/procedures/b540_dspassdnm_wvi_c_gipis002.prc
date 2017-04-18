DROP PROCEDURE CPI.B540_DSPASSDNM_WVI_C_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.B540_Dspassdnm_Wvi_C_Gipis002
  (b240_par_id IN NUMBER,
   b240_line_cd IN VARCHAR2,
   b240_iss_cd IN VARCHAR2) IS
BEGIN
  Create_Winvoice(0,0,0,b240_par_id,b240_line_cd,b240_iss_cd); -- modified by aivhie 120301
  UPDATE GIPI_PARLIST
     SET par_status = 5
   WHERE par_id = b240_par_id;   
END;
/


