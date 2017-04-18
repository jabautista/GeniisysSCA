DROP PROCEDURE CPI.COPY_POL_WOPEN_LIAB_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wopen_liab_2(
    p_new_policy_id     gipi_open_liab.policy_id%TYPE,
    p_old_pol_id        gipi_open_liab.policy_id%TYPE
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
  **  Description  : copy_pol_wopen_liab program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Open limit of liabilities info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE; 
  INSERT INTO gipi_open_liab
             (policy_id,geog_cd,limit_liability,currency_cd,currency_rt,
              voy_limit,rec_flag,prem_tag, with_invoice_tag, multi_geog_tag)
       SELECT p_new_policy_id,geog_cd,limit_liability,currency_cd,currency_rt,
              voy_limit,rec_flag,prem_tag, with_invoice_tag, multi_geog_tag
         FROM gipi_open_liab
        WHERE policy_id = p_old_pol_id; 
END;
/


