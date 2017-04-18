DROP PROCEDURE CPI.COPY_POL_WAVIATION_ITEM_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_waviation_item_2(
    p_new_policy_id     gipi_aviation_item.policy_id%TYPE,
    p_old_pol_id        gipi_aviation_item.policy_id%TYPE
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
  **  Description  : copy_pol_waviation_item program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying aviation info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;    
  INSERT INTO gipi_aviation_item
             (policy_id,item_no,vessel_cd,total_fly_time,qualification,
              purpose,geog_limit,deduct_text,rec_flag,fixed_wing,
              rotor,prev_util_hrs,est_util_hrs)
       SELECT p_new_policy_id,item_no,vessel_cd,total_fly_time,qualification,
              purpose,geog_limit,deduct_text,rec_flag,fixed_wing,
              rotor,prev_util_hrs,est_util_hrs
         FROM gipi_aviation_item
        WHERE policy_id = p_old_pol_id;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
       null;
END;
/


