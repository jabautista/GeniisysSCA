DROP PROCEDURE CPI.UPDATE_COLLATERAL_PAR_2;

CREATE OR REPLACE PROCEDURE CPI.update_collateral_par_2(
    p_new_par_id    gipi_collateral_par.par_id%TYPE,
    p_new_policy_id gipi_collateral_par.policy_id%TYPE,
    p_old_pol_id    gipi_collateral_par.policy_id%TYPE
) 
IS
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : update_collateral_par program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying collateral par info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;    
INSERT INTO gipi_collateral_par
            (coll_id,       par_id,     pol_rel_dt   , coll_par_id,   deed_no,    policy_id)
  SELECT coll_id,       p_new_par_id,     pol_rel_dt   ,1,   deed_no,  p_new_policy_id
    FROM gipi_collateral_par
   WHERE policy_id = p_old_pol_id;
END;
/


