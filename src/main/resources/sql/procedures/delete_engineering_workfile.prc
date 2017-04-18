DROP PROCEDURE CPI.DELETE_ENGINEERING_WORKFILE;

CREATE OR REPLACE PROCEDURE CPI.delete_engineering_workfile(
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
    :gauge.file := 'Deleting Principal...';
  ELSE
    :gauge.file := 'passing delete policy DELETE ENGINEERING WPRINCIPAL';
  END IF;
  vbx_counter;*/
  DELETE FROM gipi_wprincipal
        WHERE par_id = p_par_id;
  /*IF :gauge.process = 'Y' THEN
    :gauge.file := 'Deleting Engineering basic info...';
  ELSE
    :gauge.file := 'passing delete policy DELETE ENGINEERING BASIC';
  END IF;
  vbx_counter;*/
  DELETE FROM gipi_wengg_basic
        WHERE par_id = p_par_id;
END;
/


