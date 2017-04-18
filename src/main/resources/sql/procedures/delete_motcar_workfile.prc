DROP PROCEDURE CPI.DELETE_MOTCAR_WORKFILE;

CREATE OR REPLACE PROCEDURE CPI.delete_motcar_workfile(
	   	  		   p_par_id      gipi_parlist.par_id%TYPE
				   )
		 IS
BEGIN
  /*
  **  Created by   : Jerome Orio  
  **  Date Created : April 05, 2010  
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : delete_motcar_workfile program unit 
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.file  := 'Deleting Vehicle Info...';
  ELSE
    :gauge.file := 'passing delete policy DEL-WVEHICLE';
  END IF;
  vbx_counter;  */
  DELETE FROM gipi_wvehicle
        WHERE par_id = p_par_id;
  /*IF :gauge.process = 'Y' THEN
    :gauge.file := 'Deleting Motor Car Accessories..';
  ELSE
    :gauge.file := 'passing delete policy DEL-WMCACC';
  END IF;
  vbx_counter;*/
  DELETE FROM gipi_wmcacc
        WHERE par_id = p_par_id;
END;
/


