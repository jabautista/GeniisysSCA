DROP PROCEDURE CPI.COPY_POL_WLOCATION_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wlocation_2(
    p_new_policy_id     gipi_location.policy_id%TYPE,
    p_old_pol_id        gipi_location.policy_id%TYPE
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
  **  Description  : copy_pol_wlocation program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Location info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
    INSERT INTO gipi_location
                (policy_id,item_no,region_cd,province_cd) 
         SELECT p_new_policy_id,item_no,region_cd,province_cd
           FROM gipi_location
          WHERE policy_id = p_old_pol_id;
END;
/


