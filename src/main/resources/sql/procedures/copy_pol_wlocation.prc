DROP PROCEDURE CPI.COPY_POL_WLOCATION;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wlocation(
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
  **  Description  : copy_pol_wlocation program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Location info..';
  ELSE
    :gauge.FILE := 'passing copy policy WLOCATION';
  END IF;
  vbx_counter;*/
  BEGIN
    INSERT INTO GIPI_LOCATION
                (policy_id,item_no,region_cd,province_cd) 
         SELECT p_policy_id,item_no,region_cd,province_cd
           FROM GIPI_WLOCATION
          WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;           
END;
/


