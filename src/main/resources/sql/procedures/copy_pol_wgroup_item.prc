DROP PROCEDURE CPI.COPY_POL_WGROUP_ITEM;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wgroup_item(
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
  ** Modified by   : Loth
  ** Date modified : 020499
  ** mod1
  ** modified by: a_poncedeleon
  ** date:        07-04-06
  ** purpose:     added field principal_cd 
  */
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wgroup_item program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Item Grouping info..';
  ELSE
    :gauge.FILE := 'passing copy policy WGROUP_ITEM';
  END IF;
  vbx_counter;*/
  BEGIN
      INSERT INTO GIPI_GROUPED_ITEMS
                  (policy_id,item_no,grouped_item_no,include_tag,grouped_item_title,
                   sex,position_cd,civil_status,date_of_birth,age,salary,salary_grade,
                   amount_coverage, remarks,line_cd, subline_cd,delete_sw, group_cd,                   
                   from_date, TO_DATE, payt_terms, pack_ben_cd,--added columns by : gmi 09/20/05
                   ann_tsi_amt, ann_prem_amt,                  -- gmi
                   control_cd, control_type_cd,								 --added columns by gmi 10/17/05
                   tsi_amt, prem_amt, principal_cd)						 -- mod1 start/end		 
     SELECT p_policy_id,item_no,grouped_item_no,include_tag,grouped_item_title,
            sex,position_cd,civil_status,date_of_birth,age,salary,salary_grade,
                   amount_covered,remarks,line_cd, subline_cd,delete_sw, group_cd,
                   from_date, TO_DATE, payt_terms, pack_ben_cd, --added columns by : gmi 09/20/05
                   ann_tsi_amt, ann_prem_amt,                   -- gmi
                   control_cd, control_type_cd,								 --added columns by gmi 10/17/05
                   tsi_amt,prem_amt, principal_cd								--mod1 start/end
             FROM GIPI_WGROUPED_ITEMS
            WHERE par_id  = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;             
END;
/


