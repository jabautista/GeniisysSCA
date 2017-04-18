DROP PROCEDURE CPI.UPDATE_COLLATERAL_PAR;

CREATE OR REPLACE PROCEDURE CPI.update_collateral_par(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
				   ) 
		 IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : update_collateral_par program unit
  */
  
  UPDATE GIPI_COLLATERAL_PAR
     SET policy_id = p_policy_id
   WHERE par_id = p_par_id;
END;
/


