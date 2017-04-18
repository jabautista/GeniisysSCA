DROP PROCEDURE CPI.COPY_POL_WMORTGAGEE;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wmortgagee(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
				   ) 
		 IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wmortgagee program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Policy Mortgagee info..';
  ELSE
    :gauge.FILE := 'passing copy policy WMORTGAGEE';
  END IF;
  vbx_counter;  */
      INSERT INTO GIPI_MORTGAGEE
        (policy_id, iss_cd, mortg_cd,
         item_no, amount, remarks,
         last_update, user_id, delete_sw)
      SELECT p_policy_id, iss_cd, mortg_cd,
             item_no, amount, remarks,
             last_update, user_id, delete_sw
        FROM GIPI_WMORTGAGEE
       WHERE par_id  =  p_par_id;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
	  null; 
END;
/


