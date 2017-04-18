DROP PROCEDURE CPI.COPY_POL_WENGG_BASIC;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wengg_basic (
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
  **  Description  : copy_pol_wengg_basic program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Engineering info..';
  ELSE
    :gauge.FILE := 'passing copy policy WENGG_BASIC';
  END IF;
  vbx_counter;*/
  BEGIN
  INSERT INTO GIPI_ENGG_BASIC
   (policy_id,engg_basic_infonum,contract_proj_buss_title,site_location,
    construct_start_date,construct_end_date,maintain_start_date,
    maintain_end_date,weeks_test,time_excess,mbi_policy_no,
    testing_start_date,testing_end_date)
   SELECT p_policy_id,engg_basic_infonum,contract_proj_buss_title,
          site_location,construct_start_date,construct_end_date,
          maintain_start_date,maintain_end_date,weeks_test,time_excess,
          mbi_policy_no, testing_start_date,testing_end_date
     FROM GIPI_WENGG_BASIC
    WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;     
END;
/


