DROP PROCEDURE CPI.UPDATE_PAR_STATUS_B_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Update_Par_Status_B_Gipis002
   (b240_par_id IN NUMBER,
    v_exist OUT NUMBER) IS                                
BEGIN
  FOR A1 IN (SELECT DISTINCT 1
               FROM GIPI_WPOLBAS
              WHERE par_id = b240_par_id) LOOP
    v_exist  := 1;
    EXIT;
  END LOOP;
END;
/


