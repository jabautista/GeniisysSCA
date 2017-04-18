CREATE OR REPLACE PROCEDURE CPI.copy_pol_wfireitm(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
				   ) 
		 IS
  /*Modified by Iris Bordey 10.30.2003
  **See spec# UW-SPECS-GIPIS055-003-0026
  **To populate risk_cd.
  */
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
  **  Description  : copy_pol_wfireitm program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Fire Item info..';
  ELSE
    :gauge.FILE := 'passing copy policy WFIREITM';
  END IF;
  vbx_counter;*/
  BEGIN
  INSERT INTO GIPI_FIREITEM
             (policy_id,item_no,district_no,eq_zone,tarf_cd,block_no,fr_item_type,
              loc_risk1,loc_risk2,loc_risk3,tariff_zone,typhoon_zone,construction_cd,
              construction_remarks,front,RIGHT,LEFT,rear,occupancy_cd,occupancy_remarks, flood_zone,
              assignee, block_id, risk_cd, latitude, longitude) -- latitude and longitude added by Jerome 11.14.2016 SR 5749
       SELECT p_policy_id,item_no,district_no,eq_zone,tarf_cd,block_no,fr_item_type,
              loc_risk1,loc_risk2,loc_risk3,tariff_zone,typhoon_zone,construction_cd,
              construction_remarks,front,RIGHT,LEFT,rear,occupancy_cd,occupancy_remarks, flood_zone,
              assignee, block_id, risk_cd, latitude, longitude
         FROM GIPI_WFIREITM
        WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;        
END;
/


