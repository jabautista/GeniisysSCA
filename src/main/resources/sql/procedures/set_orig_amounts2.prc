DROP PROCEDURE CPI.SET_ORIG_AMOUNTS2;

CREATE OR REPLACE PROCEDURE CPI.SET_ORIG_AMOUNTS2(
	   	  p_par_id				IN  GIPI_WPERIL_DISCOUNT.par_id%TYPE,
		  p_item_no				IN  GIPI_WITEM.item_no%TYPE,
		  p_peril_cd			IN  GIPI_WITMPERL.peril_cd%TYPE,
		  p_SEQUENCE			IN  GIPI_WPERIL_DISCOUNT.SEQUENCE%TYPE,
		  p_orig_peril_ann_prem_amt   OUT  GIPI_WPERIL_DISCOUNT.orig_peril_ann_prem_amt%TYPE,
		  p_orig_item_ann_prem_amt	  OUT  GIPI_WPERIL_DISCOUNT.orig_item_ann_prem_amt%TYPE,
		  p_orig_pol_ann_prem_amt	  OUT  GIPI_WPERIL_DISCOUNT.orig_pol_ann_prem_amt%TYPE
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
	**  Date Created 	: 03.10.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: SET_ORIG_AMOUNTS2 program unit
	*/
	
  v_orig_peril := NULL;
  v_orig_item  := NULL;
  v_orig_pol   := NULL;        
  FOR CHECK1 IN(SELECT b930.peril_cd, b930.item_no,
                       b930.orig_peril_ann_prem_amt ann_peril,
                       b930.orig_item_ann_prem_amt  ann_item,
                       b930.orig_pol_ann_prem_amt   ann_pol
                  FROM GIPI_WPERIL_DISCOUNT b930
                 WHERE b930.par_id    =  p_par_id
                   AND ((b930.SEQUENCE  <> p_SEQUENCE
                   AND b930.level_tag =  '1' )
                    OR b930.level_tag <>  '1' ) 
              ORDER BY last_update)
  LOOP   
    IF v_orig_pol IS NULL THEN
       v_orig_pol := check1.ann_pol;
    END IF ;  
    IF v_orig_item IS NULL AND
     	 p_item_no = check1.item_no THEN
       v_orig_item := check1.ann_item;
    END IF; 	 
    IF v_orig_peril IS NULL AND
    	 p_item_no  = check1.item_no AND
    	 p_peril_cd = check1.peril_cd THEN
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
   	                 AND b480.item_no = p_item_no)
     LOOP 
     	 v_orig_item := item.ann_prem_amt;
     END LOOP;
  END IF; 	 
  IF v_orig_peril IS NULL THEN
   	 FOR PERIL IN (SELECT b490.ann_prem_amt
  	                 FROM GIPI_WITMPERL b490
   	                WHERE b490.par_id   = p_par_id
   	                  AND b490.item_no  = p_item_no
   	                  AND b490.peril_cd = p_peril_cd)
     LOOP 
     	 v_orig_peril := peril.ann_prem_amt;
     END LOOP;
  END IF; 	 
  p_orig_peril_ann_prem_amt := v_orig_peril;
  p_orig_item_ann_prem_amt  := v_orig_item;
  p_orig_pol_ann_prem_amt   := v_orig_pol;
END;
/


