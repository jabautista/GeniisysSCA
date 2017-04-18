DROP PROCEDURE CPI.GET_ORIG_PERIL_PREM_GIPIS143;

CREATE OR REPLACE PROCEDURE CPI.get_orig_peril_prem_Gipis143(
	   	  p_par_id				IN  GIPI_WPERIL_DISCOUNT.par_id%TYPE,
		  p_item_no				IN  GIPI_WITEM.item_no%TYPE,
		  p_peril_cd			IN  GIPI_WITMPERL.peril_cd%TYPE,
		  p_msg_alert			OUT VARCHAR2,
		  p_orig_peril_prem_amt	OUT GIPI_WPERIL_DISCOUNT.orig_peril_prem_amt%TYPE,
		  p_net_prem_amt		OUT GIPI_WPERIL_DISCOUNT.net_prem_amt%TYPE 							  
	   	  )
	   IS
  v_disc_total   			GIPI_WPERIL_DISCOUNT.disc_amt%TYPE := NULL;
  v_prem_amt1    			GIPI_WITMPERL.prem_amt%TYPE := NULL; 							  
BEGIN
    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.05.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: get_orig_peril_prem program unit
	*/
	
	 /* Get the premium amount from gipi_witmperl table. */
     BEGIN
       SELECT DISTINCT(NVL(b490.prem_amt,0))
         INTO v_prem_amt1
         FROM GIPI_WITMPERL  b490
        WHERE b490.par_id     = p_par_id
          AND b490.item_no    = p_item_no
          AND b490.peril_cd   = p_peril_cd;
     EXCEPTION 
       WHEN NO_DATA_FOUND THEN
         p_msg_alert := 'Peril code does not exist in GIPI_WITMPERL table.';
     END;
    BEGIN
      SELECT SUM(NVL(b930.disc_amt,0))
        INTO v_disc_total
        FROM GIPI_WPERIL_DISCOUNT b930
       WHERE b930.par_id   =  p_par_id
         AND b930.item_no  =  p_item_no
         AND b930.peril_cd =  p_peril_cd;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
        NULL;
    END;
    IF NVL(v_disc_total,0) > 0 THEN
       p_orig_peril_prem_amt := v_prem_amt1 + NVL(v_disc_total,0);
       p_net_prem_amt  := v_prem_amt1 + NVL(v_disc_total,0);
    ELSE
       p_orig_peril_prem_amt := v_prem_amt1;
       p_net_prem_amt  := v_prem_amt1;
    END IF;
	
END;
/


