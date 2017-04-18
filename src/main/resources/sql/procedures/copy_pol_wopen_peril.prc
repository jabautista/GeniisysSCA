DROP PROCEDURE CPI.COPY_POL_WOPEN_PERIL;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wopen_peril(
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
  **  Description  : copy_pol_wopen_peril program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Open Policy info..';
  ELSE
    :gauge.FILE := 'passing copy policy WOPEN_PERIL';
  END IF;
  vbx_counter;  */
  INSERT INTO GIPI_OPEN_PERIL(policy_id,geog_cd,line_cd,peril_cd,rec_flag,prem_rate,remarks,with_invoice_tag)
       SELECT p_policy_id,geog_cd,line_cd,peril_cd,rec_flag,prem_rate, remarks,with_invoice_tag
         FROM GIPI_WOPEN_PERIL
        WHERE par_id = p_par_id;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
	  null;         
END;
/


