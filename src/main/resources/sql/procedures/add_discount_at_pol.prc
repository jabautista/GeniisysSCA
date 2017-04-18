DROP PROCEDURE CPI.ADD_DISCOUNT_AT_POL;

CREATE OR REPLACE PROCEDURE CPI.ADD_DISCOUNT_AT_POL(
	   	  p_par_id			GIPI_WPOLBAS_DISCOUNT.par_id%TYPE,
		  p_net_gross_tag	GIPI_WPOLBAS_DISCOUNT.net_gross_tag%TYPE,
		  p_disc_rt			GIPI_WPOLBAS_DISCOUNT.disc_rt%TYPE, 
		  p_surcharge_rt	GIPI_WPOLBAS_DISCOUNT.surcharge_rt%TYPE,
		  p_line_cd			GIPI_WPOLBAS_DISCOUNT.line_cd%TYPE,
		  p_subline_cd		GIPI_WPOLBAS_DISCOUNT.subline_cd%TYPE,
		  p_sequence		GIPI_WPOLBAS_DISCOUNT.SEQUENCE%TYPE,
		  p_disc_amt		GIPI_WPOLBAS_DISCOUNT.disc_amt%TYPE,
		  p_surcharge_amt   GIPI_WPOLBAS_DISCOUNT.surcharge_amt%TYPE						  
	   	  )
	    IS
  cnt_disc     NUMBER := 0;
  prem_1       NUMBER;
  prem_2       NUMBER;
  disc_1       NUMBER;
  disc_2       NUMBER :=0;
  orig         NUMBER;
  excess       NUMBER :=0;
-- Added by RBD (08142002)
-- variables used to store the total surcharge.
  surc_1       NUMBER;
  surc_2       NUMBER :=0;
  surc_3       NUMBER :=0;
  excess2      NUMBER :=0;
  v_prorate	   VARCHAR2(250);
BEGIN
    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.08.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: ADD_DISCOUNT_AT_POL program unit
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
  FOR item_perl IN( SELECT b490.item_no ITEM, b490.peril_cd PERIL,b490.prem_amt PREMIUM
                      FROM GIPI_WITMPERL  b490
                     WHERE b490.par_id  = p_par_id) LOOP
--  MSG_ALERT(TO_CHAR(item_perl.premium),'I',false);
         prem_1 := NULL;
         orig   := NULL;
         prem_2 := 0;
         disc_1 := 0;
         FOR A1 IN(SELECT b930.orig_peril_prem_amt ORIG
                    FROM GIPI_WPERIL_DISCOUNT b930
                   WHERE b930.par_id  = p_par_id
                     AND b930.item_no = item_perl.item
                     AND b930.peril_cd = item_perl.peril
                     AND B930.level_tag = '1') LOOP
              orig := a1.orig;
              EXIT;
         END LOOP;          
         IF orig IS NULL THEN 
            FOR A2 IN(SELECT SUM(NVL(b930.disc_amt,0)) SUM_DISC
                        FROM GIPI_WPERIL_DISCOUNT b930
                       WHERE b930.par_id  = p_par_id
                         AND b930.item_no = item_perl.item
                         AND b930.peril_cd = item_perl.peril) LOOP
                disc_1 := A2.sum_disc;
                EXIT; 
            END LOOP;
            orig := item_perl.premium + NVL(disc_1,0);
--
            FOR A3 IN(SELECT SUM(NVL(b930.surcharge_amt,0)) SUM_SURC
                        FROM GIPI_WPERIL_DISCOUNT b930
                       WHERE b930.par_id  = p_par_id
                         AND b930.item_no = item_perl.item
                         AND b930.peril_cd = item_perl.peril) LOOP
                surc_1 := A3.sum_surc;
                EXIT; 
            END LOOP;
            orig := orig + NVL(surc_1,0);
--
         END IF;
         IF NVL(p_net_gross_tag,'G') = 'G' THEN
               prem_1 := orig;
            ELSE
               prem_1 := item_perl.premium;
         END IF;

         prem_2 := (prem_1 * p_disc_rt)/100;
         surc_2 := (prem_1 * p_surcharge_rt)/100; 

         INSERT INTO GIPI_WPERIL_DISCOUNT(par_id,	       item_no,	      line_cd,
                                          peril_cd,	       disc_rt,	      disc_amt,
                                          net_gross_tag,   level_tag,	  subline_cd,	
                                          SEQUENCE,        last_update,   orig_peril_prem_amt,
                                          net_prem_amt,    surcharge_rt,  surcharge_amt)
              VALUES(p_par_id,	      	  item_perl.item,	     	p_line_cd,
                     item_perl.peril,     NVL(p_disc_rt,0),			prem_2,
           	         p_net_gross_tag, 	  '3',                  	p_subline_cd,
                     p_SEQUENCE,      	  SYSDATE,    				orig,
                     prem_1,              p_surcharge_rt,   		surc_2);
  END LOOP;
  SET_ORIG_AMOUNTS(p_par_id, '3', p_SEQUENCE);                   
  FOR A3 IN(SELECT SUM( ROUND((NVL(b930.disc_amt,0) * b480.currency_rt), 2)) DISCOUNT,
  								 SUM( ROUND((NVL(b930.surcharge_amt,0) * b480.currency_rt), 2)) SURCHARGE
              FROM GIPI_WPERIL_DISCOUNT b930 , GIPI_WITEM b480
             WHERE b930.par_id    = p_par_id
               AND b930.SEQUENCE  = p_SEQUENCE
               AND b930.level_tag = '3'
               AND b480.item_no   = b930.item_no
               AND b480.par_id    = b930.par_id ) LOOP
          disc_2 := a3.discount;
          surc_3 := a3.surcharge;
          EXIT;
  END LOOP;

  IF p_disc_amt != disc_2 THEN
     excess :=  disc_2 - p_disc_amt;
     FOR A4 IN(   SELECT b930.item_no ITEM, b930.peril_cd PERIL, b480.currency_rt RATE
                    FROM GIPI_WPERIL_DISCOUNT b930, GIPI_WITEM b480
                   WHERE b930.par_id     = p_par_id
                     AND b930.SEQUENCE   = p_SEQUENCE
                     AND b930.level_tag  = '3'
                     AND b480.item_no    = b930.item_no
                     AND b480.par_id     = b930.par_id
                     AND b930.orig_peril_prem_amt > 0) LOOP --issa02.01.2008 to add excess to peril w/ prem amt)
            UPDATE GIPI_WPERIL_DISCOUNT
               SET disc_amt = disc_amt - ROUND((excess / a4.rate),2)
             WHERE par_id   = p_par_id
               AND item_no  = a4.item
               AND peril_cd = a4.peril
               AND SEQUENCE = p_SEQUENCE
               AND level_tag = '3';
            EXIT;
      END LOOP;
  END IF;  
          
  IF p_surcharge_amt != surc_3 THEN
     excess2 :=  surc_3 - p_surcharge_amt;
     FOR A4 IN(   SELECT b930.item_no ITEM, b930.peril_cd PERIL, b480.currency_rt RATE
                    FROM GIPI_WPERIL_DISCOUNT b930, GIPI_WITEM b480
                   WHERE b930.par_id     = p_par_id
                     AND b930.SEQUENCE   = p_SEQUENCE
                     AND b930.level_tag  = '3'
                     AND b480.item_no    = b930.item_no
                     AND b480.par_id     = b930.par_id
                     AND b930.orig_peril_prem_amt > 0) LOOP --issa02.01.2008 to add excess to peril w/ prem amt)
            UPDATE GIPI_WPERIL_DISCOUNT
               SET surcharge_amt = surcharge_amt - ROUND((excess2 / a4.rate),2)
             WHERE par_id   = p_par_id
               AND item_no  = a4.item
               AND peril_cd = a4.peril
               AND SEQUENCE = p_SEQUENCE
               AND level_tag = '3';
            EXIT;
      END LOOP;
  END IF;  

  FOR delete_pol IN(SELECT SUM( ROUND((NVL(b930.disc_amt,0) * b480.currency_rt) ,2)) disc_amt,
  											   SUM( ROUND((NVL(b930.surcharge_amt,0) * b480.currency_rt) ,2)) surc_amt
                      FROM GIPI_WPERIL_DISCOUNT b930, GIPI_WITEM b480
                     WHERE b930.par_id     = p_par_id
                       AND b930.level_tag  = '3'
                       AND b930.SEQUENCE   = p_SEQUENCE
                       AND b480.item_no    = b930.item_no
                       AND b480.par_id     = b930.par_id) LOOP
        UPDATE GIPI_WPOLBAS
           SET prem_amt     = (prem_amt     + delete_pol.surc_amt) - delete_pol.disc_amt,
               ann_prem_amt = (ann_prem_amt + (delete_pol.surc_amt/ NVL(v_prorate, 1))) - (delete_pol.disc_amt/ NVL(v_prorate, 1))
--           SET prem_amt     = prem_amt     - delete_pol.disc_amt,
--               ann_prem_amt = ann_prem_amt - (delete_pol.disc_amt/ NVL(variable.v_prorate, 1))
         WHERE par_id  = p_par_id;
        EXIT;
    END LOOP;
    FOR item IN (SELECT b480.item_no item_no
                   FROM GIPI_WITEM b480
                  WHERE b480.par_id  = p_par_id)LOOP
         FOR delete_item IN(SELECT SUM(NVL(b930.disc_amt,0)) disc_amt,
         													 SUM(NVL(b930.surcharge_amt,0)) surc_amt  
                              FROM GIPI_WPERIL_DISCOUNT b930
                             WHERE b930.par_id     = p_par_id
                               AND b930.item_no    = item.item_no
                               AND b930.level_tag  = '3'
                               AND b930.SEQUENCE   = p_SEQUENCE) LOOP
             UPDATE GIPI_WITEM
                SET prem_amt     = (prem_amt     + delete_item.surc_amt) - delete_item.disc_amt,
                    ann_prem_amt = (ann_prem_amt + (delete_item.surc_amt / NVL(v_prorate, 1))) - (delete_item.disc_amt / NVL(v_prorate, 1))
--                SET prem_amt     = prem_amt     - delete_item.disc_amt,
--                    ann_prem_amt = ann_prem_amt - (delete_item.disc_amt / NVL(variable.v_prorate, 1))
              WHERE par_id  = p_par_id
                AND item_no = item.item_no;
             EXIT;        
         END LOOP;
    END LOOP;
    FOR peril IN (SELECT b490.item_no item_no, b490.peril_cd peril_cd
                    FROM GIPI_WITMPERL b490
                   WHERE b490.par_id  = p_par_id)LOOP
         FOR delete_peril IN(SELECT SUM(NVL(b930.disc_amt,0)) disc_amt, 
         														SUM(NVL(b930.surcharge_amt,0)) surc_amt
                               FROM GIPI_WPERIL_DISCOUNT b930
                              WHERE b930.par_id     = p_par_id
                                AND b930.item_no    = peril.item_no
                                AND b930.peril_cd   = peril.peril_cd
                                AND b930.level_tag  = '3'
                                AND b930.SEQUENCE   = p_SEQUENCE) LOOP
             UPDATE GIPI_WITMPERL
                SET prem_amt     = (prem_amt     + delete_peril.surc_amt) - delete_peril.disc_amt,
                    ann_prem_amt = (ann_prem_amt + (delete_peril.surc_amt / NVL(v_prorate, 1))) - (delete_peril.disc_amt / NVL(v_prorate, 1))
--                SET prem_amt     = prem_amt     - delete_peril.disc_amt,
--                    ann_prem_amt = ann_prem_amt - (delete_peril.disc_amt / NVL(variable.v_prorate, 1))
              WHERE par_id   = p_par_id
                AND item_no  = peril.item_no
                AND peril_cd = peril.peril_cd;

--update discounted ri_comm_amt
             UPDATE GIPI_WITMPERL
                SET ri_comm_amt  = NVL(ri_comm_rate,0) * NVL(prem_amt,0) / 100
              WHERE par_id   = p_par_id
                AND item_no  = peril.item_no
                AND peril_cd = peril.peril_cd;
             EXIT;        
         END LOOP;
    END LOOP;
END;
/


