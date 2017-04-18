DROP PROCEDURE CPI.COPY_POL_WINPOLBAS_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_winpolbas_2(
    p_old_pol_id    giri_inpolbas.policy_id%TYPE,
    p_new_policy_id giri_inpolbas.policy_id%TYPE
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
  **  Date Created : 10-12-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_winpolbas program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Re-insurance info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO giri_inpolbas
             (accept_no,policy_id,ri_policy_no,ri_endt_no,
              ri_binder_no,ri_cd,writer_cd,
              accept_date,offer_date,accept_by,orig_tsi_amt,orig_prem_amt,remarks,ref_accept_no)
      SELECT  accept_no, p_new_policy_id,ri_policy_no,ri_endt_no,ri_binder_no,
              ri_cd,writer_cd,accept_date,offer_date,accept_by,orig_tsi_amt,
              orig_prem_amt,remarks, ref_accept_no
         FROM giri_inpolbas
        WHERE policy_id = p_old_pol_id;
END;
/


