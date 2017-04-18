DROP PROCEDURE CPI.INSERT_PARHIST_GIPIS055;

CREATE OR REPLACE PROCEDURE CPI.insert_parhist_gipis055(
	   	  		  p_par_id				IN  GIPI_PARLIST.par_id%TYPE,
				  p_user_id				IN  VARCHAR2
	   	  		  )
	    IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : insert_parhist program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Updating PAR history...';
  ELSE
    :gauge.FILE := 'passing insert policy PARHIST';
  END IF;
  vbx_counter;*/
  INSERT INTO GIPI_PARHIST
             (par_id,user_id,parstat_date,entry_source,parstat_cd)
       VALUES(p_par_id,p_user_id,SYSDATE,
              NULL,'10');
END;
/


