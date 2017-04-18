CREATE OR REPLACE PROCEDURE CPI.copy_pol_wfireitm_2(
    p_new_policy_id     gipi_fireitem.policy_id%TYPE,
    p_old_pol_id        gipi_fireitem.policy_id%TYPE
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
  **  Description  : copy_pol_wfireitm program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Fire Item info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO gipi_fireitem
             (policy_id,item_no,district_no,eq_zone,tarf_cd,block_no,fr_item_type,
              loc_risk1,loc_risk2,loc_risk3,tariff_zone,typhoon_zone,construction_cd, risk_cd, --added by lhen  031104
              construction_remarks,front,right,left,rear,occupancy_cd,occupancy_remarks, flood_zone,
              assignee,block_id, user_id, last_update, latitude, longitude) --benjo 01.10.2017 SR-5749
       SELECT p_new_policy_id,item_no,district_no,eq_zone,tarf_cd,block_no,fr_item_type,
              loc_risk1,loc_risk2,loc_risk3,tariff_zone,typhoon_zone,construction_cd, risk_cd, --added by lhen 031104
              construction_remarks,front,right,left,rear,occupancy_cd,occupancy_remarks, flood_zone,
              assignee,block_id, user, sysdate, latitude, longitude --benjo 01.10.2017 SR-5749
         FROM gipi_fireitem
        WHERE policy_id = p_old_pol_id;
END;
/


