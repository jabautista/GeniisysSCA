DROP PROCEDURE CPI.COPY_POL_WOPEN_POLICY;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wopen_policy(
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
  **  Description  : copy_pol_wopen_policy program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Open Policy info..';
  ELSE
    :gauge.FILE := 'passing copy policy WOPEN_PERIL';
  END IF;
  vbx_counter;  */
 
  INSERT INTO GIPI_OPEN_POLICY
              (policy_id,line_cd,op_subline_cd,op_iss_cd,
               op_pol_seqno,decltn_no,op_issue_yy,op_renew_no,eff_date) 
       SELECT p_policy_id,line_cd,op_subline_cd,op_iss_cd,
              op_pol_seqno,decltn_no,op_issue_yy,op_renew_no,eff_date
         FROM GIPI_WOPEN_POLICY
        WHERE par_id = p_par_id;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
	  null;         
END;
/


