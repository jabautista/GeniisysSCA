DROP PROCEDURE CPI.GET_ORIG_POLICY_PREM_GIPIS143;

CREATE OR REPLACE PROCEDURE CPI.Get_Orig_Policy_Prem_Gipis143(
	   	  p_par_id			IN  GIPI_WPOLBAS.par_id%TYPE,
		  p_msg_alert		OUT VARCHAR2,
		  p_orig_prem_amt	OUT GIPI_WPOLBAS_DISCOUNT.orig_prem_amt%TYPE,
		  p_net_prem_amt 	OUT GIPI_WPOLBAS_DISCOUNT.net_prem_amt%TYPE
	   	  )
	   IS
  v_orig_prem_amt	 GIPI_WPOLBAS_DISCOUNT.orig_prem_amt%TYPE;
  v_net_prem_amt 	 GIPI_WPOLBAS_DISCOUNT.net_prem_amt%TYPE;
  v_disc_total   	 GIPI_WITMPERL.prem_amt%TYPE := 0;
  v_surc_total   	 GIPI_WITMPERL.prem_amt%TYPE := 0;
  v_prem_amt1    	 GIPI_WITMPERL.prem_amt%TYPE := 0;
BEGIN
	/*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.05.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: Get_Orig_Policy_Prem program unit
	*/
	BEGIN
      SELECT NVL(b540.prem_amt,0)
        INTO v_prem_amt1
        FROM GIPI_WPOLBAS b540
       WHERE b540.par_id   = p_par_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
        p_msg_alert := 'This PAR has no existing record in table GIPI_WPOLBAS.';
    END;

    /* Check if there is same record in gipi_wperil_discount table and */
    /*    compute the premium amount applied with discount.  */
    BEGIN
      SELECT SUM(NVL(disc_amt,0))
        INTO v_disc_total
        FROM GIPI_WPERIL_DISCOUNT b390
       WHERE par_id   = p_par_id;
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         NULL;
    END;

    /* Check if there is same record in gipi_wperil_discount table and */
    /*    compute the premium amount applied with surcharge.  */
    -- Added by RBD (08202002)
    -- to deduct previously added surcharge.
    BEGIN
      SELECT SUM(NVL(surcharge_amt,0))
        INTO v_surc_total
        FROM GIPI_WPERIL_DISCOUNT b390
       WHERE par_id   = p_par_id;
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         NULL;
    END;

    IF NVL(v_disc_total,0) > 0 THEN
      v_orig_prem_amt := v_prem_amt1 + NVL(v_disc_total,0);
      v_net_prem_amt  := v_prem_amt1 + NVL(v_disc_total,0);
    ELSE
      v_orig_prem_amt := v_prem_amt1;
      v_net_prem_amt  := v_prem_amt1;
    END IF;
    p_orig_prem_amt := v_orig_prem_amt - NVL(v_surc_total,0);
    p_net_prem_amt  := v_net_prem_amt  - NVL(v_surc_total,0);
	
END;
/


