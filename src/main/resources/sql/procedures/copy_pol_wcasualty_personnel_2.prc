DROP PROCEDURE CPI.COPY_POL_WCASUALTY_PERSONNEL_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcasualty_personnel_2(
    p_new_policy_id     gipi_casualty_personnel.policy_id%TYPE,
    p_old_pol_id        gipi_casualty_personnel.policy_id%TYPE
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
  **  Description  : copy_pol_wcasualty_personnel program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Casualty Item personnel...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;    
 INSERT INTO gipi_casualty_personnel
             (policy_id,item_no,personnel_no,name,include_tag,capacity_cd,
              amount_covered,remarks)
      SELECT p_new_policy_id,item_no,personnel_no,name,include_tag,capacity_cd,
             amount_covered,remarks
        FROM gipi_casualty_personnel
       WHERE policy_id = p_old_pol_id;
END;
/


