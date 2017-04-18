DROP PROCEDURE CPI.COPY_POL_WBENEFICIARY;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wbeneficiary(
                       p_par_id        IN  GIPI_PARLIST.par_id%TYPE,
                  p_policy_id    IN  GIPI_POLBASIC.policy_id%TYPE
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
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wbeneficiary program unit
  */
  /*
  **  Modified by   : Gzelle
  **  Date Created : May 13, 2014
  **  Reference By : (GIPIS207 - BATCH POSTING)
  **  Description  : added remarks, date of birth and age
  */  
  --:gauge.FILE := 'passing copy policy BENEFICIARY';
  --vbx_counter;
  BEGIN
  INSERT INTO GIPI_BENEFICIARY
               (policy_id,item_no,beneficiary_name,beneficiary_addr,
                relation,
                beneficiary_no,delete_sw,date_of_birth,age,remarks) 
   SELECT p_policy_id,item_no,beneficiary_name,beneficiary_addr,
          relation,beneficiary_no,delete_sw,date_of_birth,age,remarks
         FROM GIPI_WBENEFICIARY
        WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      null;                
  END;         
END;
/


