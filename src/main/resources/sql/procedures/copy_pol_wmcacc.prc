DROP PROCEDURE CPI.COPY_POL_WMCACC;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wmcacc(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
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
  **  Description  : copy_pol_wmcacc program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Motor Accessories info..';
  ELSE
    :gauge.FILE := 'passing copy policy WMCACC';
  END IF;
  vbx_counter;  */
   INSERT INTO GIPI_MCACC
               (policy_id,accessory_cd,item_no,acc_amt,user_id,last_update,delete_sw)
       SELECT p_policy_id,accessory_cd,item_no, acc_amt,user_id,last_update ,delete_sw 	
         FROM GIPI_WMCACC
        WHERE par_id  =  p_par_id;
EXCEPTION 
  WHEN NO_DATA_FOUND THEN
      NULL;
  WHEN DUP_VAL_ON_INDEX THEN
	  null;   
END;
/


