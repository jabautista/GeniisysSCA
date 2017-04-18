DROP PROCEDURE CPI.PRE_COMMIT_G_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Pre_Commit_G_Gipis002
   (b540_booking_year IN NUMBER,
    b540_booking_mth IN VARCHAR2,
    b240_par_id IN NUMBER) IS    
BEGIN
  UPDATE GIPI_WINVOICE
  SET multi_booking_yy = b540_booking_year, 
   multi_booking_mm = b540_booking_mth
   WHERE par_id = b240_par_id
  AND takeup_seq_no = 1;
END;
/


