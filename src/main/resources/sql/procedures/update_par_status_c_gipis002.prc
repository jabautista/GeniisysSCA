DROP PROCEDURE CPI.UPDATE_PAR_STATUS_C_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Update_Par_Status_C_Gipis002
   (b240_par_id IN NUMBER,
    cg$ctrl_par_status IN OUT NUMBER) IS                                
BEGIN
  FOR B IN (
    SELECT  par_id,par_status
      FROM  GIPI_PARLIST
     WHERE  par_id  =  b240_par_id
      FOR UPDATE OF par_id,par_status) LOOP
      IF cg$ctrl_par_status IS NOT NULL AND
         cg$ctrl_par_status != B.par_status THEN
        UPDATE  GIPI_PARLIST
           SET  par_status  =  cg$ctrl_par_status
         WHERE  par_id      =  b240_par_id;
        EXIT;
      END IF;
  END LOOP;
END;
/


