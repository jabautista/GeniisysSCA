DROP PROCEDURE CPI.GET_ORIG_PREM_AMT_GIPIS143;

CREATE OR REPLACE PROCEDURE CPI.Get_Orig_Prem_Amt_Gipis143(
	   	  p_par_id			IN    GIPI_WPOLBAS_DISCOUNT.par_id%TYPE,
		  p_var_orig_prem   OUT	  GIPI_WPOLBAS_DISCOUNT.orig_prem_amt%TYPE
	   	  )
	IS
  v_var_orig_prem     GIPI_WPOLBAS_DISCOUNT.orig_prem_amt%TYPE := 0;
BEGIN
	/*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.08.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: when-new-rec-instance B430
	*/
	 FOR orig_prem IN(SELECT b430.orig_prem_amt premium
                        FROM GIPI_WPOLBAS_DISCOUNT b430
                       WHERE b430.par_id = p_par_id) LOOP
         v_var_orig_prem  := orig_prem.premium;
         EXIT;
     END LOOP;
	 p_var_orig_prem := v_var_orig_prem;
END;
/


