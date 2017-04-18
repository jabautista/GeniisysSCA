DROP PROCEDURE CPI.DELETE_FIRE_WORKFILE;

CREATE OR REPLACE PROCEDURE CPI.delete_fire_workfile(
	   	  		   p_par_id      gipi_parlist.par_id%TYPE
				   )
		 IS
BEGIN
  /*
  **  Created by   : Jerome Orio  
  **  Date Created : April 05, 2010  
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : delete_fire_workfile program unit 
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.file := 'Deleting Fire Item information...';
  ELSE
    :gauge.file := 'passing delete policy DEL-WFIREITM';
  END IF;
  vbx_counter;*/
  DELETE FROM gipi_wfireitm
        WHERE par_id = p_par_id;
END;
/


