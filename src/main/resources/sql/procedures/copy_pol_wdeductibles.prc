DROP PROCEDURE CPI.COPY_POL_WDEDUCTIBLES;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wdeductibles(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
				   ) 
		 IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Date Updated : 060798
  */
  v_exist VARCHAR2(1) := 'N'; --**gmi**--
 BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : COPY_POL_WPICTURES program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Deductible info..';
  ELSE
    :gauge.FILE := 'passing copy policy WDEDUCTIBLES';
  END IF;
  vbx_counter;*/
  --**gmi 09/26/05**-- 
  --added condition to determine whether gipi_wdeductibles have existing record or not--
  --insert process is halt if there are no records to transfer--
  FOR a IN (SELECT 1 
  	    	    FROM GIPI_WDEDUCTIBLES
  	    	   WHERE par_id = p_par_id) LOOP
  v_exist := 'Y';
  EXIT;
  END LOOP;
  IF v_exist = 'Y' THEN	  
    BEGIN  	   
       INSERT INTO GIPI_DEDUCTIBLES(
            policy_id, item_no, ded_line_cd, ded_subline_cd, ded_deductible_cd,
            deductible_text,deductible_amt, deductible_rt, peril_cd
            /*ramon, feb 01, 2008*/,aggregate_sw, ceiling_sw, min_amt, max_amt, range_sw)
            SELECT p_policy_id,item_no,ded_line_cd,ded_subline_cd,ded_deductible_cd,
                   deductible_text,deductible_amt, deductible_rt, peril_cd
                   /*ramon, feb 01, 2008*/,aggregate_sw, ceiling_sw, min_amt, max_amt, range_sw
              FROM GIPI_WDEDUCTIBLES
             WHERE par_id  =  p_par_id;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
	      null;                
    END;              
  ELSE
  	NULL;
  END IF;
 END;
/


