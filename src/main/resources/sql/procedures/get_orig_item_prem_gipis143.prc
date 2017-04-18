DROP PROCEDURE CPI.GET_ORIG_ITEM_PREM_GIPIS143;

CREATE OR REPLACE PROCEDURE CPI.get_orig_item_prem_gipis143(
	   	  p_par_id			IN  GIPI_WPERIL_DISCOUNT.par_id%TYPE,
		  p_item_no			IN  GIPI_WITEM.item_no%TYPE,
		  p_msg_alert		OUT VARCHAR2,
		  p_orig_prem_amt	OUT GIPI_WITEM_DISCOUNT.orig_prem_amt%TYPE,
		  p_net_prem_amt	OUT GIPI_WITEM_DISCOUNT.net_prem_amt%TYPE 							  
	   	  )
	   IS
   v_disc_total   			GIPI_WITMPERL.prem_amt%TYPE := NULL;
   v_surc_total   			GIPI_WITMPERL.prem_amt%TYPE := NULL;
   v_orig_prem_amt			NUMBER;
   v_net_prem_amt			NUMBER;
   v_prem_amt1    			GIPI_WITMPERL.prem_amt%TYPE := NULL; 							  
BEGIN
    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.05.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: get_orig_item_prem program unit
	*/
	
	 /* Get the premium amount from gipi_witmperl table. */
     BEGIN
       SELECT DISTINCT(NVL(b480.prem_amt,0))
         INTO v_prem_amt1
         FROM GIPI_WITMPERL  b490,  GIPI_WITEM b480
        WHERE b480.par_id    = b490.par_id
          AND b480.item_no   = b490.item_no
          AND b480.par_id    = p_par_id
          AND b480.item_no    = p_item_no;
     EXCEPTION 
       WHEN NO_DATA_FOUND THEN
         p_msg_alert := 'Item No. does not exist in GIPI_WITMPERL table.';
     END;
    /* Check if there is same record in gipi_wperil_discount table and */
    /*    compute the premium amount applied with discount.  */
    BEGIN
      SELECT SUM(NVL(disc_amt,0))
        INTO v_disc_total
        FROM GIPI_WPERIL_DISCOUNT b390
       WHERE b390.par_id   = p_par_id
         AND b390.item_no  =  p_item_no; 
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
        NULL;
    END;

    /* Check if there is same record in gipi_wperil_discount table and */
    /*    compute the premium amount applied with surcharge.  */
    -- Added by RBD (08202002)
    BEGIN
      SELECT SUM(NVL(surcharge_amt,0))
        INTO v_surc_total
        FROM GIPI_WPERIL_DISCOUNT b390
       WHERE b390.par_id   = p_par_id
         AND b390.item_no  =  p_item_no; 
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
    -- Added by RBD (08202002)
    -- to deduct previously added surcharge.
    p_orig_prem_amt := v_orig_prem_amt - NVL(v_surc_total,0);
    p_net_prem_amt  := v_net_prem_amt  - NVL(v_surc_total,0);
END;
/


