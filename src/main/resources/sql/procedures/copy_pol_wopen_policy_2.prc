DROP PROCEDURE CPI.COPY_POL_WOPEN_POLICY_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wopen_policy_2(
    p_new_policy_id     gipi_open_policy.policy_id%TYPE,
    p_old_pol_id        gipi_open_policy.policy_id%TYPE
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
  **  Description  : copy_pol_wopen_policy program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Open policy info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO gipi_open_policy
              (policy_id,line_cd,op_subline_cd,op_iss_cd,
               op_pol_seqno,decltn_no,op_issue_yy,op_renew_no,eff_date) 
       SELECT p_new_policy_id,line_cd,op_subline_cd,op_iss_cd,
              op_pol_seqno,decltn_no,op_issue_yy,op_renew_no,eff_date
         FROM gipi_open_policy
        WHERE policy_id = p_old_pol_id;
END;
/


