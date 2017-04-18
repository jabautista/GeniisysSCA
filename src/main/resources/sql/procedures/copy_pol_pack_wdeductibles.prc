DROP PROCEDURE CPI.COPY_POL_PACK_WDEDUCTIBLES;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_pack_wdeductibles(
 		   		   p_item_no IN GIPI_WITEM.item_no%TYPE,
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
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_pack_wdeductibles program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Deductible info..';
  ELSE
    :gauge.FILE := 'passing copy policy WDEDUCTIBLES';
  END IF;
  vbx_counter;*/
       INSERT INTO GIPI_DEDUCTIBLES(
            policy_id, item_no, ded_line_cd, ded_subline_cd, ded_deductible_cd,
            deductible_text,deductible_amt, deductible_rt, peril_cd
            /*ramon, feb 01, 2008*/,aggregate_sw, ceiling_sw, min_amt, max_amt, range_sw)
            SELECT p_policy_id,item_no,ded_line_cd,ded_subline_cd,ded_deductible_cd,
                   deductible_text,deductible_amt, deductible_rt, peril_cd
                   /*ramon, feb 01, 2008*/,aggregate_sw, ceiling_sw, min_amt, max_amt, range_sw
              FROM GIPI_WDEDUCTIBLES
             WHERE item_no  = p_item_no
               AND par_id  =  p_par_id;
END;
/


