DROP PROCEDURE CPI.COPY_POL_WPRINCIPAL_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wprincipal_2(
    p_new_policy_id     gipi_principal.policy_id%TYPE,
    p_old_pol_id        gipi_principal.policy_id%TYPE
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
  **  Description  : copy_pol_wprincipal program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Principal info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO gipi_principal
              (policy_id,principal_cd,engg_basic_infonum,subcon_sw)
       SELECT p_new_policy_id,principal_cd,engg_basic_infonum,subcon_sw
         FROM gipi_principal
        WHERE policy_id = p_old_pol_id;
END;
/


