DROP PROCEDURE CPI.COPY_POL_WCOSIGNTRY;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcosigntry(
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
  **  Description  : copy_pol_wcosigntry program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Co-signatory info..';
  ELSE
    :gauge.FILE := 'passing copy policy COSIGNTRY';
  END IF; 
  vbx_counter;*/
  BEGIN
  INSERT INTO GIPI_COSIGNTRY(
       policy_id,cosign_id,assd_no,
       indem_flag,bonds_flag,bonds_ri_flag)
       SELECT p_policy_id,cosign_id,assd_no,
              indem_flag,bonds_flag,bonds_ri_flag
         FROM GIPI_WCOSIGNTRY
        WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END; 
END;
/


