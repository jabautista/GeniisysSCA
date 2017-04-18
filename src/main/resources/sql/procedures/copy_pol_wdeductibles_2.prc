DROP PROCEDURE CPI.COPY_POL_WDEDUCTIBLES_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wdeductibles_2(
    p_new_policy_id     gipi_deductibles.policy_id%TYPE,
    p_old_pol_id        gipi_deductibles.policy_id%TYPE
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
  **  Description  : copy_pol_wdeductibles program unit 
  */
    --CLEAR_MESSAGE;
    --MESSAGE('Copying deductibles info...',NO_ACKNOWLEDGE);
    --SYNCHRONIZE;
    INSERT INTO gipi_deductibles
              (policy_id,item_no,ded_line_cd,ded_subline_cd,
               ded_deductible_cd,deductible_text,deductible_amt,deductible_rt,peril_cd)
        SELECT p_new_policy_id,item_no,ded_line_cd,ded_subline_cd,ded_deductible_cd,
               deductible_text,deductible_amt,deductible_rt,peril_cd
          FROM gipi_deductibles
         WHERE policy_id = p_old_pol_id;
END;
/


