DROP PROCEDURE CPI.COPY_POL_WITEM_VES_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_witem_ves_2(
    p_new_policy_id     gipi_item_ves.policy_id%TYPE,
    p_old_pol_id        gipi_item_ves.policy_id%TYPE
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
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_witem_ves program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Item vessel info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO gipi_item_ves
             (policy_id,item_no,vessel_cd,geog_limit,rec_flag,
              deduct_text,dry_date,dry_place)
       SELECT p_new_policy_id,item_no,vessel_cd,geog_limit,rec_flag,
              deduct_text,dry_date,dry_place
         FROM gipi_item_ves
        WHERE policy_id = p_old_pol_id;
END;
/


