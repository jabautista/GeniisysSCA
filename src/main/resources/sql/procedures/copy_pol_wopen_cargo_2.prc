DROP PROCEDURE CPI.COPY_POL_WOPEN_CARGO_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wopen_cargo_2(
    p_new_policy_id     gipi_open_cargo.policy_id%TYPE,
    p_old_pol_id        gipi_open_cargo.policy_id%TYPE
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
  **  Description  : copy_pol_wopen_cargo program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Cargo info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;  
  INSERT INTO gipi_open_cargo(policy_id,geog_cd,cargo_class_cd,rec_flag)
       SELECT p_new_policy_id,geog_cd,cargo_class_cd,rec_flag
         FROM gipi_open_cargo
        WHERE policy_id = p_old_pol_id;
END;
/


