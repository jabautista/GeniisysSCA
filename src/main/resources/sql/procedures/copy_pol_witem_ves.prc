DROP PROCEDURE CPI.COPY_POL_WITEM_VES;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_witem_ves(
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
  **  Description  : copy_pol_witem_ves program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Item info..';
  ELSE
    :gauge.FILE := 'passing copy policy WITEM';
  END IF;
  vbx_counter;  */
  BEGIN
  INSERT INTO GIPI_ITEM_VES
             (policy_id,item_no,vessel_cd,geog_limit,rec_flag,
              deduct_text,dry_date,dry_place)
       SELECT p_policy_id,item_no,vessel_cd,geog_limit,rec_flag,
              deduct_text,dry_date,dry_place
         FROM GIPI_WITEM_VES
        WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;         
END;
/


