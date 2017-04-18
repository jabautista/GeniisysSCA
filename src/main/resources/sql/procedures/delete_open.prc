DROP PROCEDURE CPI.DELETE_OPEN;

CREATE OR REPLACE PROCEDURE CPI.delete_open(
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
  
  DELETE FROM gipi_wopen_peril
        WHERE par_id = p_par_id;
  --:gauge.file := 'passing delete policy WOPEN CARGO';
  --vbx_counter;
  DELETE FROM gipi_wopen_cargo
        WHERE par_id = p_par_id;
  --:gauge.file := 'passing delete policy WOPEN LIAB';
  --vbx_counter;
  DELETE FROM gipi_wopen_liab
        WHERE par_id = p_par_id;

END;
/


