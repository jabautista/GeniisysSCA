DROP PROCEDURE CPI.COPY_POL_WDISCOUNTS2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wdiscounts2(
	   	  		  p_item_no   GIPI_WPERIL_DISCOUNT.item_no%TYPE,
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
    :gauge.FILE := 'Finalising Peril Discount info..';
  ELSE
    :gauge.FILE := 'passing copy policy WDISCOUNT_PERILS1';
  END IF;
  vbx_counter;*/
  BEGIN
  INSERT INTO GIPI_PERIL_DISCOUNT
           (policy_id,item_no,line_cd,peril_cd,SEQUENCE,
            disc_rt,disc_amt,net_gross_tag,discount_tag,level_tag,
            subline_cd,orig_peril_prem_amt,surcharge_rt,surcharge_amt)
       SELECT   p_policy_id,item_no,line_cd,peril_cd,SEQUENCE,
                disc_rt,disc_amt,net_gross_tag,discount_tag,level_tag,
                subline_cd,orig_peril_prem_amt,surcharge_rt,surcharge_amt
         FROM   GIPI_WPERIL_DISCOUNT
        WHERE   par_id  =  p_par_id
          AND   item_no =  p_item_no;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;           
END;
/


