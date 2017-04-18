DROP PROCEDURE CPI.ADD_DISCOUNT_AT_PERIL;

CREATE OR REPLACE PROCEDURE CPI.ADD_DISCOUNT_AT_PERIL(
	   	  		  p_par_id	   			    GIPI_WITEM.par_id%TYPE,
				  p_item_no	   				GIPI_WITEM.item_no%TYPE,
				  p_peril_cd	   			GIPI_WPERIL_DISCOUNT.peril_cd%TYPE,
				  p_disc_amt				GIPI_WPERIL_DISCOUNT.disc_amt%TYPE,
				  p_surcharge_amt			GIPI_WPERIL_DISCOUNT.surcharge_amt%TYPE
	   	  		  )
	    IS
  v_rate      GIPI_WITEM.currency_rt%TYPE;
  v_prorate    NUMBER;
BEGIN
    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.11.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: ADD_DISCOUNT_AT_PERIL program unit
	*/
  --this part is from Post-Query in B240 for prorate
  FOR B540 IN (SELECT b540.comp_sw comp_sw, b540.eff_date eff_date,
                      b540.expiry_date expiry_date
                 FROM GIPI_WPOLBAS b540
                WHERE b540.par_id = p_par_id
                  AND b540.prorate_flag = '1') 
  LOOP
    IF b540.comp_sw = 'Y' THEN
       v_prorate  := ((TRUNC( b540.expiry_date) - TRUNC(b540.eff_date )) + 1 )/
                               (ADD_MONTHS(b540.eff_date,12) - b540.eff_date);
    ELSIF b540.comp_sw = 'M' THEN
       v_prorate  := ((TRUNC( b540.expiry_date) - TRUNC(b540.eff_date )) - 1 )/
                               (ADD_MONTHS(b540.eff_date,12) - b540.eff_date);
    ELSE
       v_prorate  := (TRUNC( b540.expiry_date) - TRUNC(b540.eff_date ))/
                               (ADD_MONTHS(b540.eff_date,12) - b540.eff_date);
    END IF;
  END LOOP;
  --
-- Updated by RBD (08142002)
-- to include/add surcharge amount when updating the policy table(gipi_wpolbas), item table(gipi_witem) and peril table(gipi_witmperl)
  FOR rate IN
      ( SELECT b480.currency_rt
          FROM GIPI_WITEM b480
         WHERE b480.par_id = p_par_id
           AND b480.item_no = p_item_no
       ) LOOP
       v_rate := rate.currency_rt;
  END LOOP;
  UPDATE GIPI_WPOLBAS
     SET prem_amt     = (prem_amt     + ROUND((NVL(p_surcharge_amt,0) * v_rate),2)) - ROUND((NVL(p_disc_amt,0) * v_rate),2) ,
         ann_prem_amt = (ann_prem_amt + (ROUND((NVL(p_surcharge_amt,0) * v_rate),2)/ NVL(v_prorate, 1))) - (ROUND((NVL(p_disc_amt,0) * v_rate),2)/ NVL(v_prorate, 1)) 
   WHERE par_id  = p_par_id;
--     SET prem_amt     = prem_amt     - round((:b390.disc_amt * v_rate),2) ,
--         ann_prem_amt = ann_prem_amt - (round((:b390.disc_amt * v_rate),2)/ NVL(variable.v_prorate, 1)) 

  UPDATE GIPI_WITEM
     SET prem_amt     = (prem_amt     + NVL(p_surcharge_amt,0)) - NVL(p_disc_amt,0),
         ann_prem_amt = (ann_prem_amt + (NVL(p_surcharge_amt,0) / NVL(v_prorate, 1))) - (NVL(p_disc_amt,0) / NVL(v_prorate, 1))
   WHERE par_id  = p_par_id
     AND item_no = p_item_no;
--     SET prem_amt     = prem_amt     - :b390.disc_amt,
--         ann_prem_amt = ann_prem_amt - (:b390.disc_amt / NVL(variable.v_prorate, 1))

  UPDATE GIPI_WITMPERL
     SET prem_amt     = (prem_amt     + NVL(p_surcharge_amt,0)) - NVL(p_disc_amt,0),
         ann_prem_amt = (ann_prem_amt + (NVL(p_surcharge_amt,0) / NVL(v_prorate, 1))) - (NVL(p_disc_amt,0) / NVL(v_prorate, 1))
   WHERE par_id   = p_par_id
     AND item_no  = p_item_no
     AND peril_cd = p_peril_cd;
--     SET prem_amt     = prem_amt     - :b390.disc_amt,
--         ann_prem_amt = ann_prem_amt - (:b390.disc_amt / NVL(variable.v_prorate, 1))

--update discounted ri_comm_amt
  UPDATE GIPI_WITMPERL
     SET ri_comm_amt  = NVL(ri_comm_rate,0) * NVL(prem_amt,0) / 100
   WHERE par_id   = p_par_id
     AND item_no  = p_item_no
     AND peril_cd = p_peril_cd;

END;
/


