DROP PROCEDURE CPI.COPY_POL_WLIM_LIAB_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wlim_liab_2(
    p_old_pol_id        gipi_lim_liab.policy_id%TYPE,
    p_new_policy_id     gipi_lim_liab.policy_id%TYPE
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
  **  Description  : copy_pol_wlim_liab program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Limit of liability info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO gipi_lim_liab
              (policy_id,line_cd,liab_cd,limit_liability,currency_cd
              ,currency_rt) 
       SELECT p_new_policy_id,line_cd,liab_cd,limit_liability,currency_cd,
              currency_rt
         FROM gipi_lim_liab
        WHERE policy_id = p_old_pol_id;
END;
/


