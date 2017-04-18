DROP PROCEDURE CPI.LAST_DISCOUNT;

CREATE OR REPLACE PROCEDURE CPI.LAST_DISCOUNT (
	   	  p_par_id   IN GIPI_WPOLBAS_DISCOUNT.par_id%TYPE,
	   	  p_level_cd IN VARCHAR2,
	      p_sequence IN NUMBER 
		  )
	 IS
  pol_sw        VARCHAR2(1);
  pol_sw2       VARCHAR2(1);
  item_sw       VARCHAR2(1);
  peril_sw      VARCHAR2(1);                             
BEGIN
	/*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.08.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: LAST_DISCOUNT program unit
	*/
	pol_sw2     := 'N';
	FOR DISCOUNTS IN ( SELECT b930.peril_cd, b930.item_no, 
	                          orig_peril_ann_prem_amt,
	                          orig_item_ann_prem_amt,
	                          orig_pol_ann_prem_amt
	                     FROM GIPI_WPERIL_DISCOUNT b930
	                    WHERE b930.par_id = p_par_id
	                      AND b930.level_tag = p_level_cd
	                      AND b930.SEQUENCE = p_sequence )
  LOOP
    pol_sw := 'N';
    FOR POL IN (SELECT '1'
                  FROM GIPI_WPERIL_DISCOUNT b930
                 WHERE b930.par_id     = p_par_id
                    AND ((b930.SEQUENCE  <> p_sequence                          
                    AND b930.level_tag =   p_level_cd)
                     OR b930.level_tag <>  p_level_cd ))
    LOOP
      pol_sw := 'Y';
    END LOOP;
    IF pol_sw = 'N' THEN
    	 IF pol_sw2 = 'N' THEN
    	    UPDATE GIPI_WPOLBAS
    	       SET ann_prem_amt = discounts.orig_pol_ann_prem_amt
           WHERE par_id = p_par_id;
          pol_sw2 := 'Y';           
       END IF;    
       UPDATE GIPI_WITEM
    	    SET ann_prem_amt = discounts.orig_item_ann_prem_amt
        WHERE par_id   = p_par_id
          AND item_no  = discounts.item_no;
       UPDATE GIPI_WITMPERL
    	    SET ann_prem_amt = discounts.orig_peril_ann_prem_amt
        WHERE par_id   = p_par_id
          AND item_no  = discounts.item_no
          AND peril_cd = discounts.peril_cd;
    END IF;
    IF pol_sw = 'Y' THEN
       item_sw    := 'N';
	     FOR ITEM IN (SELECT '1'
                      FROM GIPI_WPERIL_DISCOUNT b930
                     WHERE b930.par_id     = p_par_id
                       AND b930.item_no    = discounts.item_no
                        AND ((b930.SEQUENCE  <> p_sequence                          
                        AND b930.level_tag =   p_level_cd)
                         OR b930.level_tag <>  p_level_cd )) 
       LOOP
    	   item_sw := 'Y';
       END LOOP;
       IF item_sw = 'N' THEN
          UPDATE GIPI_WITEM
    	       SET ann_prem_amt = discounts.orig_item_ann_prem_amt
           WHERE par_id   = p_par_id
             AND item_no  = discounts.item_no;
          UPDATE GIPI_WITMPERL
    	       SET ann_prem_amt = discounts.orig_peril_ann_prem_amt
           WHERE par_id   = p_par_id
             AND item_no  = discounts.item_no
             AND peril_cd = discounts.peril_cd;
       ELSE
          peril_sw := 'N'; 
          FOR PERIL IN (SELECT '1'
                          FROM GIPI_WPERIL_DISCOUNT b930
                         WHERE b930.par_id     = p_par_id
                           AND b930.item_no    = discounts.item_no
                           AND b930.peril_cd   = discounts.peril_cd
                           AND ((b930.SEQUENCE  <> p_sequence                          
                           AND b930.level_tag =   p_level_cd)
                            OR b930.level_tag <>  p_level_cd)) 
          LOOP
    	      peril_sw := 'Y';
          END LOOP;
          IF peril_sw = 'N' THEN
       	     UPDATE GIPI_WITMPERL
    	          SET ann_prem_amt = discounts.orig_peril_ann_prem_amt
              WHERE par_id   = p_par_id
                AND item_no  = discounts.item_no
                AND peril_cd = discounts.peril_cd;
          END IF;      
       END IF;
    END IF;
  END LOOP;
  
END;
/


