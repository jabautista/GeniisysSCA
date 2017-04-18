DROP PROCEDURE CPI.COPY_POL_WFIRE;

CREATE OR REPLACE PROCEDURE CPI.copy_POL_WFIRE(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
				   ) 
		 IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_POL_WFIRE program unit
  */
 
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Fire info..';
  ELSE
    :gauge.FILE := 'passing copy policy WFIRE';
  END IF;
  vbx_counter;*/
  copy_pol_wfireitm(p_par_id,p_policy_id);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;
END;
/


