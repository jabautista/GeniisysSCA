DROP PROCEDURE CPI.UPDATE_PAR_STATUS_A_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Update_Par_Status_A_Gipis002
   (b240_par_id IN NUMBER,
    p_count OUT NUMBER) IS                                
BEGIN
  SELECT     COUNT(*)
    INTO     p_count
    FROM     GIPI_WITEM
   WHERE     par_id   = b240_par_id;
END;
/


