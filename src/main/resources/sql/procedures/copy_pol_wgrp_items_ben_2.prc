DROP PROCEDURE CPI.COPY_POL_WGRP_ITEMS_BEN_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wgrp_items_ben_2(
    p_new_policy_id     gipi_grp_items_beneficiary.policy_id%TYPE,
    p_old_pol_id        gipi_grp_items_beneficiary.policy_id%TYPE
)
IS
/* Created By  : GRACE
   Date Created: 05/15/2000 */
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wgrp_items_ben program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Group items beneficiary...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
   INSERT INTO gipi_grp_items_beneficiary
        (policy_id,item_no,grouped_item_no,beneficiary_no,beneficiary_name,
         beneficiary_addr,relation,date_of_birth,age,civil_status,sex)
  SELECT p_new_policy_id,item_no,grouped_item_no,beneficiary_no,beneficiary_name,
         beneficiary_addr,relation,date_of_birth,trunc(to_number(months_between(sysdate,date_of_birth))/12),civil_status,sex
    FROM gipi_grp_items_beneficiary
   WHERE policy_id = p_old_pol_id;
END;
/


