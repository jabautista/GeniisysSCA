DROP PROCEDURE CPI.COPY_POL_WITMPERL;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_witmperl(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE,
				   p_line_cd	IN  GIPI_PARLIST.line_cd%TYPE
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
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_witmperl program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Risk info..';
  ELSE
    :gauge.FILE := 'passing copy policy WITMPERL';
  END IF;
  vbx_counter;  */
  BEGIN
  INSERT INTO GIPI_ITMPERIL
             (policy_id,line_cd,item_no,peril_cd,tarf_cd,prem_rt,tsi_amt,
              prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,comp_rem,
              discount_sw,ri_comm_rate,ri_comm_amt,prt_flag,as_charge_sw,
              surcharge_sw, aggregate_sw, base_amt, no_of_days) --issa@fpac09.13.2006, added aggregate_sw, base_amt, no_of_days
      SELECT p_policy_id,line_cd,item_no,peril_cd,tarf_cd,prem_rt,tsi_amt,
             prem_amt,ann_tsi_amt,ann_prem_amt,NVL(rec_flag,'A'),comp_rem,
             discount_sw,ri_comm_rate,ri_comm_amt,prt_flag,as_charge_sw,
             surcharge_sw, aggregate_sw, base_amt, no_of_days --issa@fpac09.13.2006, added aggregate_sw, base_amt, no_of_days
        FROM GIPI_WITMPERL
        WHERE line_cd = p_line_cd AND
              par_id  = p_par_id;
  copy_pol_wdiscount_perils(p_par_id,p_policy_id);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END; 
END;
/


