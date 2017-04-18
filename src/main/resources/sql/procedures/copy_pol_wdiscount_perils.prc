DROP PROCEDURE CPI.COPY_POL_WDISCOUNT_PERILS;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wdiscount_perils(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE 
				   ) 
		 IS
   CURSOR discount_peril IS   SELECT  item_no,line_cd,peril_cd,disc_rt,disc_amt,
                                      net_gross_tag,discount_tag,SEQUENCE,
                                      level_tag,subline_cd,orig_peril_prem_amt,
                                      net_prem_amt,last_update,remarks,
                                      surcharge_rt,surcharge_amt
                                FROM  GIPI_WPERIL_DISCOUNT
                               WHERE  par_id  =  p_par_id;
 
 /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by    : Daphne
  ** Last Update   : 060798
  ** Modified by   : Loth
  ** Date modified : 090998
  */
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wdiscount_perils program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Peril Discount info..';
  ELSE
    :gauge.FILE := 'passing copy policy WDISCOUNT_PERILS';
  END IF;
  vbx_counter;*/
  copy_pol_wdiscount_polbas(p_par_id,p_policy_id);
  copy_pol_wdiscount_item(p_par_id,p_policy_id);
 FOR D1 IN DISCOUNT_PERIL LOOP 
INSERT INTO GIPI_PERIL_DISCOUNT
           (policy_id,item_no,line_cd,peril_cd,SEQUENCE,
            disc_rt,disc_amt,net_gross_tag,discount_tag,level_tag,
            subline_cd,orig_peril_prem_amt,
            net_prem_amt,last_update,remarks,surcharge_rt,surcharge_amt)
     VALUES(p_policy_id,D1.item_no,D1.line_cd,D1.peril_cd,D1.SEQUENCE,
            D1.disc_rt,D1.disc_amt,D1.net_gross_tag,D1.discount_tag,
            D1.level_tag,D1.subline_cd,D1.orig_peril_prem_amt,
            D1.net_prem_amt,D1.last_update,D1.remarks,D1.surcharge_rt,D1.surcharge_amt);
END LOOP;
END;
/


