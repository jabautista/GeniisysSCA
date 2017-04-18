DROP PROCEDURE CPI.DELETE_DISCOUNT_AT_ITEM;

CREATE OR REPLACE PROCEDURE CPI.DELETE_DISCOUNT_AT_ITEM( 
	   	  		 p_par_id	   			GIPI_WITEM.par_id%TYPE,
				 p_item_no	   			GIPI_WITEM.item_no%TYPE,
				 p_nbt_orig_item_no		GIPI_WITEM.item_no%TYPE,
				 p_SEQUENCE	   	   		GIPI_WPERIL_DISCOUNT.SEQUENCE%TYPE,
	   	  		 p_delete_sw   			VARCHAR2
				 )  
		 IS
  cnt_disc     NUMBER := 0;
  v_rate       GIPI_WITEM.currency_rt%TYPE;
  v_prorate    NUMBER;
  v_last_sw    VARCHAR2(1) := 'N';
BEGIN
    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.08.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: DELETE_DISCOUNT_AT_ITEM program unit
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
  
  FOR rate IN
      ( SELECT b480.currency_rt
          FROM GIPI_WITEM b480
         WHERE b480.par_id = p_par_id
           AND b480.item_no = p_item_no
       ) LOOP
       v_rate := rate.currency_rt;
  END LOOP;
  SELECT COUNT(*)
    INTO cnt_disc
    FROM GIPI_WPERIL_DISCOUNT b930 
   WHERE b930.par_id      = p_par_id
     AND b930.item_no     = NVL(p_nbt_orig_item_no,p_item_no)
     AND b930.level_tag   = '2'
     AND b930.SEQUENCE    = p_SEQUENCE;
  IF cnt_disc > 0 THEN
     FOR delete_pol IN(SELECT SUM(NVL(b930.disc_amt,0)) disc_amt,
     													SUM(NVL(b930.surcharge_amt,0)) surc_amt
                         FROM GIPI_WPERIL_DISCOUNT b930
                        WHERE b930.par_id     = p_par_id
                          AND b930.level_tag  = '2'
                          AND b930.item_no    = NVL(p_nbt_orig_item_no,p_item_no)
                          AND b930.SEQUENCE   = p_SEQUENCE) LOOP
         UPDATE GIPI_WPOLBAS
            SET prem_amt     = (prem_amt     + ROUND((delete_pol.disc_amt * v_rate), 2)) - ROUND((delete_pol.surc_amt * v_rate), 2),
                ann_prem_amt = (ann_prem_amt + (ROUND((delete_pol.disc_amt * v_rate), 2) / NVL(v_prorate, 1))) - (ROUND((delete_pol.surc_amt * v_rate), 2) / NVL(v_prorate, 1))
          WHERE par_id  = p_par_id;
         EXIT;
     END LOOP;
     FOR item IN (SELECT b480.item_no item_no
                    FROM GIPI_WITEM b480
                   WHERE b480.par_id   = p_par_id
                     AND b480.item_no  = NVL(p_nbt_orig_item_no,p_item_no)) LOOP
         FOR delete_item IN(SELECT SUM(NVL(b930.disc_amt,0)) disc_amt,
         												   SUM(NVL(b930.surcharge_amt,0)) surc_amt
                              FROM GIPI_WPERIL_DISCOUNT b930
                             WHERE b930.par_id     = p_par_id
                               AND b930.item_no    = item.item_no
                               AND b930.level_tag  = '2'
                               AND b930.SEQUENCE   = p_SEQUENCE) LOOP
             UPDATE GIPI_WITEM
                SET prem_amt     = (prem_amt     + delete_item.disc_amt) - delete_item.surc_amt,
                    ann_prem_amt = (ann_prem_amt + (delete_item.disc_amt / NVL(v_prorate, 1))) - (delete_item.surc_amt / NVL(v_prorate, 1))
              WHERE par_id  = p_par_id
                AND item_no = item.item_no;
            EXIT;        
         END LOOP;
    END LOOP;
    FOR peril IN (SELECT b490.item_no item_no, b490.peril_cd peril_cd
                    FROM GIPI_WITMPERL b490
                   WHERE b490.par_id  = p_par_id
                     AND b490.item_no = NVL(p_nbt_orig_item_no,p_item_no))LOOP
         FOR delete_peril IN(SELECT SUM(NVL(b930.disc_amt,0)) disc_amt,
         														SUM(NVL(b930.surcharge_amt,0)) surc_amt
                               FROM GIPI_WPERIL_DISCOUNT b930
                              WHERE b930.par_id     = p_par_id
                                AND b930.item_no    = peril.item_no
                                AND b930.peril_cd   = peril.peril_cd
                                AND b930.level_tag  = '2'
                                AND b930.SEQUENCE   = p_SEQUENCE) LOOP
             UPDATE GIPI_WITMPERL
                SET prem_amt     = (prem_amt     + delete_peril.disc_amt) - delete_peril.surc_amt,
                    ann_prem_amt = (ann_prem_amt + (delete_peril.disc_amt / NVL(v_prorate, 1))) - (delete_peril.surc_amt / NVL(v_prorate, 1))
              WHERE par_id   = p_par_id
                AND item_no  = peril.item_no
                AND peril_cd = peril.peril_cd;

-- update discounted ri_comm_amt
             UPDATE GIPI_WITMPERL
                SET ri_comm_amt  = NVL(ri_comm_rate,0) * NVL(prem_amt,0) / 100
              WHERE par_id   = p_par_id
                AND item_no  = peril.item_no
                AND peril_cd = peril.peril_cd;
             EXIT;        
         END LOOP;
   END LOOP;
   IF p_delete_sw = 'Y' THEN
	 	  Last_Discount(p_par_id, '2', p_SEQUENCE);
   END IF;		                   
   DELETE FROM GIPI_WPERIL_DISCOUNT
         WHERE par_id    = p_par_id
           AND level_tag = '2'
           AND SEQUENCE  = p_SEQUENCE;
  END IF;
END;
/


