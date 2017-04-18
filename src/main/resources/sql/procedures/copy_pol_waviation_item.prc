DROP PROCEDURE CPI.COPY_POL_WAVIATION_ITEM;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_waviation_item(
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
  **  Description  : copy_pol_waviation_item program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Aviation Item info....';
  ELSE
    :gauge.FILE := 'passing copy policy AVIATION ITEM';
  END IF;
  vbx_counter;*/
  INSERT INTO GIPI_AVIATION_ITEM
             (policy_id,item_no,vessel_cd,total_fly_time,qualification,
              purpose,geog_limit,deduct_text,rec_flag,fixed_wing,
              rotor,prev_util_hrs,est_util_hrs)
       SELECT p_policy_id,item_no,vessel_cd,total_fly_time,qualification,
              purpose,geog_limit,deduct_text,rec_flag,fixed_wing,
              rotor,prev_util_hrs,est_util_hrs
         FROM GIPI_WAVIATION_ITEM
        WHERE par_id = p_par_id;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
       NULL;
END;
/


