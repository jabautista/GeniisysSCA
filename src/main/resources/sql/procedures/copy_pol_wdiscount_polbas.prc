DROP PROCEDURE CPI.COPY_POL_WDISCOUNT_POLBAS;

CREATE OR REPLACE PROCEDURE CPI.COPY_POL_WDISCOUNT_POLBAS(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE 
				   ) 
		 IS
   CURSOR discount IS  SELECT  line_cd,       subline_cd,    disc_rt,         
   														 disc_amt,      net_gross_tag, SEQUENCE,     orig_prem_amt,
                               net_prem_amt,  last_update,   remarks,      surcharge_rt,
                               surcharge_amt
                         FROM  GIPI_WPOLBAS_DISCOUNT
                        WHERE  par_id  =  p_par_id;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : COPY_POL_WDISCOUNT_POLBAS program unit
  */
  
 FOR D1 IN DISCOUNT LOOP 
INSERT INTO GIPI_POLBASIC_DISCOUNT
           (policy_id,    line_cd,       subline_cd,    disc_rt,
            disc_amt,     net_gross_tag, SEQUENCE,      orig_prem_amt,
            net_prem_amt, last_update,   remarks,       surcharge_rt,
            surcharge_amt)
     VALUES(p_policy_id, D1.line_cd,       D1.subline_cd,  D1.disc_rt,
            D1.disc_amt,        D1.net_gross_tag, D1.SEQUENCE,    D1.orig_prem_amt,
            D1.net_prem_amt,    D1.last_update,   D1.remarks,     D1.surcharge_rt,
            D1.surcharge_amt);
END LOOP;

END;
/


