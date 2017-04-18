DROP PROCEDURE CPI.DELETE_WINPOLBAS;

CREATE OR REPLACE PROCEDURE CPI.delete_winpolbas(
	   	  		   p_par_id      gipi_parlist.par_id%TYPE
				   )
		 IS
BEGIN
  /*
  **  Created by   : Jerome Orio  
  **  Date Created : April 05, 2010  
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : delete_winpolbas program unit 
  */
  
  /*IF :gauge.process = 'Y' THEN
     :gauge.file := 'Deleting Reinsurance information...';
  ELSE
     :gauge.file := 'passing delete policy DEL-WINPOLBAS';
  END IF;
  vbx_counter;*/
  DELETE FROM giri_winpolbas
        WHERE par_id = p_par_id;
END;
/


