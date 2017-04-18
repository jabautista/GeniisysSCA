DROP PROCEDURE CPI.COPY_POL_WGRP_ITEMS_BEN;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wgrp_items_ben(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
				   ) 
		 IS
/* Created By  : GRACE
   Date Created: 05/15/2000 */
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wgrp_items_ben program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Item Grouping info..';
  ELSE
    :gauge.FILE := 'passing copy policy WGRP_ITEM_BENEFICIARY';
  END IF;
  vbx_counter;*/
  BEGIN
  INSERT INTO GIPI_GRP_ITEMS_BENEFICIARY
        (policy_id,item_no,grouped_item_no,beneficiary_no,beneficiary_name,
         beneficiary_addr,relation,date_of_birth,age,civil_status,sex)
  SELECT p_policy_id,item_no,grouped_item_no,beneficiary_no,beneficiary_name,
         beneficiary_addr,relation,date_of_birth,age,civil_status,sex
    FROM GIPI_WGRP_ITEMS_BENEFICIARY
   WHERE par_id  = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;    
END;
/


