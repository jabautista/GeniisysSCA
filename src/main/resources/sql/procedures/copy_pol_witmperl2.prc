DROP PROCEDURE CPI.COPY_POL_WITMPERL2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_witmperl2(
	   	  		  p_item_no     IN  GIPI_WITMPERL.item_no%TYPE,
				  p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE 
				  ) 
 		 IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_witmperl2 program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Risk info..';
  ELSE
    :gauge.FILE := 'passing copy policy WITMPERL';
  END IF;
  vbx_counter;  */
  BEGIN
    INSERT INTO GIPI_ITMPERIL
             (policy_id,line_cd,item_no,peril_cd,tsi_amt,prem_amt,
              ann_tsi_amt,ann_prem_amt,rec_flag,comp_rem,discount_sw,tarf_cd,
              prem_rt,ri_comm_rate,ri_comm_amt,surcharge_sw, no_of_days, base_amt, 
              aggregate_sw)
      SELECT p_policy_id,line_cd,item_no,peril_cd,tsi_amt,prem_amt,
	            ann_tsi_amt,ann_prem_amt,NVL(rec_flag,'A'),comp_rem,discount_sw,tarf_cd,
              prem_rt,ri_comm_rate,ri_comm_amt,surcharge_sw, no_of_days, base_amt, 
              aggregate_sw
         FROM GIPI_WITMPERL
        WHERE par_id  = p_par_id
          AND item_no = p_item_no;
  EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
		null;                
  END;
   copy_pol_wdiscounts2(p_item_no,p_par_id,p_policy_id);
END;
/


