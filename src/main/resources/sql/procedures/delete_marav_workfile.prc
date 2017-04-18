DROP PROCEDURE CPI.DELETE_MARAV_WORKFILE;

CREATE OR REPLACE PROCEDURE CPI.delete_marav_workfile(
	   	  		   p_par_id      gipi_parlist.par_id%TYPE
				   )
		 IS
BEGIN
  /*
  **  Created by   : Jerome Orio  
  **  Date Created : April 05, 2010  
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : delete_marav_workfile program unit 
  */
  
  --:gauge.file := 'passing delete policy WVES_AIR';
  --vbx_counter;
  DELETE FROM gipi_wcargo_carrier
       WHERE  par_id = p_par_id;

  DELETE FROM gipi_wves_air
        WHERE par_id = p_par_id;
  --:gauge.file := 'passing delete policy WCARGO';
  --vbx_counter;
  DELETE FROM gipi_wcargo
        WHERE par_id = p_par_id;
  --:gauge.file := 'passing delete policy WOPEN PERIL';
  --vbx_counter;
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


