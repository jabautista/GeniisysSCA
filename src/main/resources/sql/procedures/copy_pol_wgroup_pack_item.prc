DROP PROCEDURE CPI.COPY_POL_WGROUP_PACK_ITEM;

CREATE OR REPLACE PROCEDURE CPI.COPY_POL_WGROUP_PACK_ITEM (
	   	  		  p_item_no     IN  GIPI_WITEM.item_no%TYPE,
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
  */
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : COPY_POL_WGROUP_PACK_ITEM program unit
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
                   amount_coverage,remarks,line_cd, subline_cd,delete_sw, group_cd,
                   from_date, TO_DATE, payt_terms, pack_ben_cd,--added columns by : gmi 09/20/05
                   ann_tsi_amt, ann_prem_amt,   							 --gmi
                   control_cd, control_type_cd,								 --added columns by gmi 10/17/05
                   tsi_amt, prem_amt)	
      SELECT p_policy_id,item_no,grouped_item_no,include_tag,grouped_item_title,
             sex,position_cd,civil_status,date_of_birth,age,salary,salary_grade,
             amount_covered,remarks,line_cd, subline_cd,delete_sw,group_cd,
             from_date, TO_DATE, payt_terms, pack_ben_cd,--added columns by : gmi 09/20/05
             ann_tsi_amt, ann_prem_amt,   							 --gmi
             control_cd, control_type_cd,								 --added columns by gmi 10/17/05
             tsi_amt, prem_amt
            FROM GIPI_WGROUPED_ITEMS
            WHERE item_no = p_item_no
              AND par_id  = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;              
END;
/


