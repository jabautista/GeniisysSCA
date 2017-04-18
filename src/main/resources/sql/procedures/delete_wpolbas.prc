DROP PROCEDURE CPI.DELETE_WPOLBAS;

CREATE OR REPLACE PROCEDURE CPI.delete_wpolbas(
	   	  		   p_par_id      gipi_parlist.par_id%TYPE
				   )
		 IS
BEGIN
  /*
  **  Created by   : Jerome Orio  
  **  Date Created : April 05, 2010  
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : delete_wpolbas program unit 
  */
  
  /*IF :gauge.process='Y' THEN
    :gauge.file := 'Deleting Endorsement Text....';
  ELSE
    :gauge.file := 'passing delete policy DEL-WENDTTEXT';
  END IF;
  vbx_counter;*/
  DELETE FROM gipi_wendttext
        WHERE par_id = p_par_id;
  /*IF :gauge.process = 'Y' THEN
    :gauge.file := 'Deleting General Information..';
  ELSE
    :gauge.file := 'passing delete policy DEL-WPOLGENIN';
  END IF;
  vbx_counter;*/
  DELETE FROM gipi_wpolgenin
        WHERE par_id = p_par_id;
  /*IF :gauge.process = 'Y' THEN
    :gauge.file := 'Deleting Bank Schedule Information..';
  ELSE
    :gauge.file := 'passing delete policy DEL-WBANK-SCHEDULE';
  END IF;
  vbx_counter;*/
  DELETE FROM GIPI_WBANK_SCHEDULE     
     WHERE par_id  = p_par_id;
  /*IF :gauge.process = 'Y' THEN
    :gauge.file := 'Deleting Package Information..';
  ELSE
    :gauge.file := 'passing delete policy DEL-WPACK-LINE-SUBLINE';
  END IF;
  vbx_counter;*/
  DELETE   GIPI_WPACK_LINE_SUBLINE 
     WHERE par_id  = p_par_id;
  /*IF :gauge.process = 'Y' THEN
    :gauge.file := 'Deleting Bond Basic Information..';
  ELSE
    :gauge.file := 'passing delete policy DEL-WBOND-BASIC';
  END IF;
  vbx_counter;*/
  DELETE   GIPI_WBOND_BASIC
     WHERE par_id  = p_par_id;
  /*IF :gauge.process = 'Y' THEN
     :gauge.file := 'Deleting Basic Information...';
  ELSE
     :gauge.file := 'passing delete policy DEL-WPOLBAS';
  END IF;
  vbx_counter;*/
  DELETE FROM gipi_wpolbas
        WHERE par_id = p_par_id;
  --:gauge.file := 'Process now complete.';
END;
/


