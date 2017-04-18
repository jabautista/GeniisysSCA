DROP PROCEDURE CPI.DELETE_CASUALTY_WORKFILE;

CREATE OR REPLACE PROCEDURE CPI.delete_casualty_workfile(
		  			p_par_id      gipi_parlist.par_id%TYPE	
					)
		   IS
BEGIN
  /*
  **  Created by   : Jerome Orio  
  **  Date Created : April 05, 2010  
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : delete_casualty_workfile program unit 
  */
  
  /*IF :gauge.process = 'Y' THEN
     :gauge.file := 'Deleting Casualty Item...';
  ELSE
     :gauge.file := 'passing delete policy DEL_WCASUALTY_ITEM';
  END IF;
  vbx_counter;*/
  DELETE FROM gipi_wcasualty_item
        WHERE par_id = p_par_id;
  /*IF :gauge.process = 'Y' THEN
     :gauge.file := 'Deleting Casualty Personnel...';
  ELSE
     :gauge.file := 'passing delete policy DEL_WCASUALTY_PERSONNEL';
  END IF;*/
  DELETE FROM GIPI_WCASUALTY_PERSONNEL 
        WHERE par_id = p_par_id;
END;
/


