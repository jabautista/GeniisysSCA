DROP PROCEDURE CPI.COPY_POL_WITMPERL_GROUPED;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_witmperl_grouped( 
				  p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
				  ) 
		 IS
-- by: gmi 09/21/05
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_witmperl_grouped program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Item Grouping info..';
  ELSE
    :gauge.FILE := 'passing copy policy WGROUP_ITEM';
  END IF;
  vbx_counter;*/
  BEGIN
     INSERT INTO GIPI_ITMPERIL_GROUPED
                  (POLICY_ID, ITEM_NO, GROUPED_ITEM_NO, LINE_CD, PERIL_CD, REC_FLAG, 
                  PREM_RT, TSI_AMT, PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT, AGGREGATE_SW, 
                  BASE_AMT, NO_OF_DAYS)
     SELECT p_policy_id, ITEM_NO, GROUPED_ITEM_NO, LINE_CD, PERIL_CD, REC_FLAG, 
     			    		PREM_RT, TSI_AMT, PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT, AGGREGATE_SW, 
     			    		BASE_AMT, NO_OF_DAYS
             FROM GIPI_WITMPERL_GROUPED
            WHERE par_id  = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;            
END;
/


