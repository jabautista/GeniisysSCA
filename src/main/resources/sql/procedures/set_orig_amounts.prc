DROP PROCEDURE CPI.SET_ORIG_AMOUNTS;

CREATE OR REPLACE PROCEDURE CPI.SET_ORIG_AMOUNTS (
	   	     p_par_id   GIPI_WPOLBAS_DISCOUNT.par_id%TYPE,
	   	  	 p_level    VARCHAR2,
             p_sequence NUMBER 
			 )
	 IS
  v_orig_peril           GIPI_WPERIL_DISCOUNT.orig_peril_ann_prem_amt%TYPE;
  v_orig_item            GIPI_WPERIL_DISCOUNT.orig_item_ann_prem_amt%TYPE;
  v_orig_pol             GIPI_WPERIL_DISCOUNT.orig_pol_ann_prem_amt%TYPE;
  peril_sw               VARCHAR2(1);
  item__sw               VARCHAR2(1);
  pol_sw                 VARCHAR2(1);
BEGIN
    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.08.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: SET_ORIG_AMOUNTS program unit
	*/
	
  FOR DISCOUNTS IN(SELECT b930.peril_cd, b930.item_no
                     FROM GIPI_WPERIL_DISCOUNT b930
                    WHERE b930.par_id    =  p_par_id
                      AND b930.SEQUENCE  = p_sequence
                      AND b930.level_tag = p_level) 
  LOOP
      v_orig_peril := NULL;
      v_orig_item  := NULL;
      v_orig_pol   := NULL;        
      FOR CHECK1 IN(SELECT b930.peril_cd, b930.item_no,
                           b930.orig_peril_ann_prem_amt ann_peril,
                           b930.orig_item_ann_prem_amt  ann_item,
                           b930.orig_pol_ann_prem_amt   ann_pol
                      FROM GIPI_WPERIL_DISCOUNT b930
                     WHERE b930.par_id    =  p_par_id
                       AND ((b930.SEQUENCE  <> p_sequence                          
                       AND b930.level_tag =   p_level)
                        OR b930.level_tag <>  p_level ) 
                  ORDER BY last_update)
      LOOP   
          IF v_orig_pol IS NULL THEN
             v_orig_pol := check1.ann_pol;
          END IF ;  
          IF v_orig_item IS NULL AND
          	 discounts.item_no = check1.item_no THEN
          	 v_orig_item := check1.ann_item;
          END IF; 	 
          IF v_orig_peril IS NULL AND
          	 discounts.item_no  = check1.item_no AND
          	 discounts.peril_cd = check1.peril_cd THEN
          	 v_orig_peril := check1.ann_peril;
          END IF; 	 
          IF v_orig_pol IS NOT NULL AND
          	 v_orig_item IS NOT NULL AND
          	 v_orig_peril IS NOT NULL THEN
          	 EXIT;
          END IF;
      END LOOP;
      IF v_orig_pol IS NULL THEN
      	 FOR POL IN (SELECT b540.ann_prem_amt
      	               FROM GIPI_WPOLBAS b540
      	              WHERE b540.par_id = p_par_id)
      	 LOOP 
      	 	 v_orig_pol := pol.ann_prem_amt;
      	 END LOOP;
      END IF;
      IF v_orig_item IS NULL THEN
      	 FOR ITEM IN (SELECT b480.ann_prem_amt
      	                FROM GIPI_WITEM b480
      	               WHERE b480.par_id  = p_par_id
      	                 AND b480.item_no = discounts.item_no)
      	 LOOP 
      	 	 v_orig_item := item.ann_prem_amt;
      	 END LOOP;
      END IF; 	 
      IF v_orig_peril IS NULL THEN
      	 FOR PERIL IN (SELECT b490.ann_prem_amt
      	                 FROM GIPI_WITMPERL b490
      	                WHERE b490.par_id   = p_par_id
      	                  AND b490.item_no  = discounts.item_no
      	                  AND b490.peril_cd = discounts.peril_cd)
      	 LOOP 
      	 	 v_orig_peril := peril.ann_prem_amt;
      	 END LOOP;
     END IF; 	 
     UPDATE GIPI_WPERIL_DISCOUNT
        SET orig_peril_ann_prem_amt = v_orig_peril,
            orig_item_ann_prem_amt  = v_orig_item,
            orig_pol_ann_prem_amt   = v_orig_pol
      WHERE par_id = p_par_id
        AND level_tag = p_level
        AND SEQUENCE  = p_sequence
        AND item_no   = discounts.item_no
        AND peril_cd  = discounts.peril_cd;
  END LOOP;                                  
END;
/


