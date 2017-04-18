DROP PROCEDURE CPI.COPY_POL_WENGG_BASIC_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wengg_basic_2(
    p_new_policy_id     gipi_engg_basic.policy_id%TYPE,
    p_old_pol_id        gipi_engg_basic.policy_id%TYPE
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
  **  Description  : copy_pol_wengg_basic program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Engineering Item info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO gipi_engg_basic
   (policy_id,engg_basic_infonum,contract_proj_buss_title,site_location,
    construct_start_date,construct_end_date,maintain_start_date,
    maintain_end_date,weeks_test,time_excess,mbi_policy_no,
    testing_start_date, testing_end_date)
   SELECT p_new_policy_id,engg_basic_infonum,contract_proj_buss_title,
          site_location,construct_start_date,construct_end_date,
          maintain_start_date,maintain_end_date,weeks_test,time_excess,
          mbi_policy_no, testing_start_date, testing_end_date
     FROM gipi_engg_basic
    WHERE policy_id = p_old_pol_id;
END;
/


