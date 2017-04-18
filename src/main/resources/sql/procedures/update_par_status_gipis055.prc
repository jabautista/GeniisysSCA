DROP PROCEDURE CPI.UPDATE_PAR_STATUS_GIPIS055;

CREATE OR REPLACE PROCEDURE CPI.Update_Par_Status_gipis055(
	   	  		  p_par_id				IN  GIPI_PARLIST.par_id%TYPE
	   	  		  )
	    IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : Update_Par_Status program unit
  */
  
  -- added for updating par_status - 01131996 -
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Updating PAR status...';
  ELSE
    :gauge.FILE := 'passing updating PAR_STATUS';
  END IF;
  vbx_counter;*/
  FOR A IN (
     SELECT par_id ,par_status
       FROM GIPI_PARLIST
      WHERE par_id = p_par_id
     FOR UPDATE OF par_id, par_status) LOOP
     UPDATE GIPI_PARLIST
        SET par_status = 10
      WHERE par_id = p_par_id;
     EXIT;
  END LOOP;
END;
/


