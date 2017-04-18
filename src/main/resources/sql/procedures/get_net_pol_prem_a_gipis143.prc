DROP PROCEDURE CPI.GET_NET_POL_PREM_A_GIPIS143;

CREATE OR REPLACE PROCEDURE CPI.Get_Net_Pol_Prem_A_Gipis143(
	   	  p_par_id			IN  GIPI_WPOLBAS_DISCOUNT.par_id%TYPE,
		  p_disc_total		OUT GIPI_WPERIL_DISCOUNT.disc_amt%TYPE,
		  p_surc_total		OUT GIPI_WPERIL_DISCOUNT.surcharge_amt%TYPE
	   	  )
    IS
  v_disc_total		GIPI_WPERIL_DISCOUNT.disc_amt%TYPE;
  v_surc_total		GIPI_WPERIL_DISCOUNT.surcharge_amt%TYPE;
BEGIN
	/*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.05.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: Get_Net_Pol_Prem program unit
	*/
	
  /* Check if there is same record in gipi_wperil_discount table and */
  /*    compute the premium amount applied with discount/surcharge.  */
 BEGIN
    SELECT SUM(NVL(disc_amt,0))
      INTO v_disc_total
      FROM GIPI_WPERIL_DISCOUNT b390
     WHERE par_id   = p_par_id
       AND level_tag IN('1','2');
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        NULL;
  END;
  
  -- Added by RBD (08202002)
  -- to consider surcharge amount when computing for the net/gross premium amount.
 BEGIN
    SELECT SUM(NVL(surcharge_amt,0))
      INTO v_surc_total
      FROM GIPI_WPERIL_DISCOUNT b390
     WHERE par_id   = p_par_id
       AND level_tag IN('1','2');
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        NULL;
  END;
  --
  
  p_disc_total := NVL(v_disc_total,0);
  p_surc_total := NVL(v_surc_total,0);
END;
/


