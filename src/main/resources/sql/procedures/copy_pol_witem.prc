DROP PROCEDURE CPI.COPY_POL_WITEM;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_witem(
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
  ** Revised to add region_cd to be passed from gipi_witem to gipi_item
  ** Updated by   : bdarusin
  ** Last Update  : 010303
  ** Added prorate_flag, comp_sw, short_rt_percent to be passed from gipi_witem to gipi_item
  ** Updated by   : bdarusin
  ** Last Update  : 022603
  */
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_witem program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Item info..';
  ELSE
    :gauge.FILE := 'passing copy policy WITEM';
  END IF;
  vbx_counter; */ 
  BEGIN
    INSERT INTO GIPI_ITEM
               (policy_id,item_no,item_grp,item_title,item_desc,tsi_amt,
            		prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,
		            currency_rt,group_cd,from_date,TO_DATE,pack_line_cd,
                pack_subline_cd,discount_sw,other_info, coverage_cd,item_desc2,
                surcharge_sw, region_cd, changed_tag, prorate_flag, comp_sw,
                short_rt_percent, PACK_BEN_CD, PAYT_TERMS, -- gmi 09/21/05 ; added columns
                risk_no, risk_item_no) -- grace 05/24/06
         SELECT p_policy_id,item_no,item_grp,item_title,item_desc,tsi_amt,
                prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,currency_rt,
		            group_cd,from_date,TO_DATE,pack_line_cd,
		            pack_subline_cd,discount_sw,other_info, coverage_cd, item_desc2,
		            surcharge_sw, region_cd, changed_tag, prorate_flag, comp_sw,
                short_rt_percent, PACK_BEN_CD, PAYT_TERMS, -- gmi 09/21/05 ; added columns
                risk_no, risk_item_no -- grace 05/24/06
           FROM GIPI_WITEM
          WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;           
END;
/


