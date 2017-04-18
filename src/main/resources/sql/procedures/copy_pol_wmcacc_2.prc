DROP PROCEDURE CPI.COPY_POL_WMCACC_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wmcacc_2(
    p_new_policy_id     gipi_mcacc.policy_id%TYPE,
    p_old_pol_id        gipi_mcacc.policy_id%TYPE
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
  **  Description  : copy_pol_wmcacc program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying accessories...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
   INSERT INTO gipi_mcacc
               (policy_id,accessory_cd,item_no,acc_amt,user_id,last_update, delete_sw)
       SELECT p_new_policy_id,accessory_cd,item_no,acc_amt,USER,SYSDATE, delete_sw
         FROM gipi_mcacc
        WHERE policy_id = p_old_pol_id;
exception when no_data_found then
           null;
END;
/


