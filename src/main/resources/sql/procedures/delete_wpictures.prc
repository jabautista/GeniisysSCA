DROP PROCEDURE CPI.DELETE_WPICTURES;

CREATE OR REPLACE PROCEDURE CPI.DELETE_WPICTURES(
	   	  		  p_par_id      gipi_parlist.par_id%TYPE			
				  )			
	    IS
/*
** This procedure will delete all data for a given par_id.
** Done by rolandmm 0101604
*/

BEGIN
  /*
  **  Created by   : Jerome Orio  
  **  Date Created : April 05, 2010  
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : DELETE_WPICTURES program unit 
  */
  
  /*IF :gauge.process = 'Y' THEN
     :gauge.file := 'Deleting WPictures information...';
  ELSE
     :gauge.file := 'passing delete policy for DEL-WPICTURES';
  END IF;
  vbx_counter;*/
  DELETE FROM gipi_wpictures
        WHERE par_id = p_par_id;
END;
/


