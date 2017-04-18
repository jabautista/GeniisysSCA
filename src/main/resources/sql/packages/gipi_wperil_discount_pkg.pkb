CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wperil_Discount_Pkg
AS
    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.02.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: peril discount/surcharge
	*/
	FUNCTION get_gipi_wperil_discount (p_par_id     GIPI_WPERIL_DISCOUNT.par_id%TYPE)
    RETURN gipi_wperil_discount_tab PIPELINED IS
       v_wperil_discount		    gipi_wperil_discount_type;
    BEGIN
	   
		   FOR a IN (SELECT a.line_cd,	     a.subline_cd, 	       a.disc_rt,
	   	   	 				a.disc_amt,		 a.net_gross_tag,	   a.orig_peril_prem_amt,
	 						a.SEQUENCE,		 a.remarks,		   	   a.net_prem_amt,
	 						a.surcharge_rt,	 a.surcharge_amt,       a.par_id,
                            a.item_no,          a.peril_cd,           a.level_tag,
                            a.orig_peril_ann_prem_amt, a.orig_item_ann_prem_amt, a.orig_pol_ann_prem_amt,
                            b.peril_name
                           FROM GIPI_WPERIL_DISCOUNT a, GIIS_PERIL b 
                      WHERE a.par_id = p_par_id
                        AND a.peril_cd = b.peril_cd 
                        AND a.line_cd = b.line_cd
                        AND a.level_tag = '1'
                      ORDER BY SEQUENCE)
       LOOP
            v_wperil_discount.par_id                          := a.par_id;  
         v_wperil_discount.line_cd                      := a.line_cd;
         v_wperil_discount.item_no                        := a.item_no;
         v_wperil_discount.peril_cd                    := a.peril_cd;
         v_wperil_discount.subline_cd                 := a.subline_cd;
         v_wperil_discount.disc_rt                  := a.disc_rt;
         v_wperil_discount.level_tag                := a.level_tag;
         v_wperil_discount.disc_amt                  := a.disc_amt;
         v_wperil_discount.net_gross_tag              := a.net_gross_tag;
         v_wperil_discount.orig_peril_prem_amt      := a.orig_peril_prem_amt;
         v_wperil_discount.SEQUENCE                  := a.SEQUENCE;
         v_wperil_discount.remarks                  := a.remarks;
         v_wperil_discount.net_prem_amt              := a.net_prem_amt;
         v_wperil_discount.orig_peril_ann_prem_amt  := a.orig_peril_ann_prem_amt;
          v_wperil_discount.orig_item_ann_prem_amt   := a.orig_item_ann_prem_amt;
          v_wperil_discount.orig_pol_ann_prem_amt    := a.orig_pol_ann_prem_amt;
         v_wperil_discount.surcharge_rt              := a.surcharge_rt;
         v_wperil_discount.surcharge_amt              := a.surcharge_amt;
         v_wperil_discount.peril_name                := a.peril_name;
         
         PIPE ROW(v_wperil_discount);
       END LOOP;

      RETURN;
    END get_gipi_wperil_discount;
    
    /*
    **  Created by        : mark jm
    **  Date Created     : 11.02.2010
    **  Reference By     : (GIPIS061 - Endt Item Information - Casualty)
    **  Description     : returns list of records
    */
    FUNCTION get_gipi_wperil_discount1 (p_par_id IN GIPI_WPERIL_DISCOUNT.par_id%TYPE)
    RETURN gipi_wperil_discount_tab PIPELINED IS
        v_wperil_discount            gipi_wperil_discount_type;
    BEGIN       
        FOR a IN (
            SELECT a.line_cd,         a.subline_cd,            a.disc_rt,
                   a.disc_amt,         a.net_gross_tag,       a.orig_peril_prem_amt,
                   a.SEQUENCE,         a.remarks,                  a.net_prem_amt,
                   a.surcharge_rt,     a.surcharge_amt,       a.par_id,
                   a.item_no,          a.peril_cd,           a.level_tag,
                   a.orig_peril_ann_prem_amt, a.orig_item_ann_prem_amt, a.orig_pol_ann_prem_amt                   
              FROM GIPI_WPERIL_DISCOUNT a
             WHERE a.par_id = p_par_id
          ORDER BY SEQUENCE)
        LOOP
            v_wperil_discount.par_id                    := a.par_id;  
            v_wperil_discount.line_cd                    := a.line_cd;
            v_wperil_discount.item_no                    := a.item_no;
            v_wperil_discount.peril_cd                    := a.peril_cd;
            v_wperil_discount.subline_cd                 := a.subline_cd;
            v_wperil_discount.disc_rt                    := a.disc_rt;
            v_wperil_discount.level_tag                    := a.level_tag;
            v_wperil_discount.disc_amt                  := a.disc_amt;
            v_wperil_discount.net_gross_tag              := a.net_gross_tag;
            v_wperil_discount.orig_peril_prem_amt        := a.orig_peril_prem_amt;
            v_wperil_discount.SEQUENCE                  := a.SEQUENCE;
            v_wperil_discount.remarks                    := a.remarks;
            v_wperil_discount.net_prem_amt              := a.net_prem_amt;
            v_wperil_discount.orig_peril_ann_prem_amt    := a.orig_peril_ann_prem_amt;
            v_wperil_discount.orig_item_ann_prem_amt    := a.orig_item_ann_prem_amt;
            v_wperil_discount.orig_pol_ann_prem_amt        := a.orig_pol_ann_prem_amt;
            v_wperil_discount.surcharge_rt                := a.surcharge_rt;
            v_wperil_discount.surcharge_amt              := a.surcharge_amt;
            v_wperil_discount.peril_name                := NULL;

            PIPE ROW(v_wperil_discount);
        END LOOP;
        RETURN;
    END get_gipi_wperil_discount1;
    
    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 03.02.2010
    **  Reference By     : (GIPIS143 - Discount/Surcharge)
    **  Description     : peril discount/surcharge
    */
    PROCEDURE set_gipi_wperil_discount (p_wperil_disc IN GIPI_WPERIL_DISCOUNT%ROWTYPE)
         IS
    BEGIN
       MERGE INTO GIPI_WPERIL_DISCOUNT
       USING DUAL ON (par_id = p_wperil_disc.par_id AND
                            item_no = p_wperil_disc.item_no AND
                      peril_cd = p_wperil_disc.peril_cd AND
                       SEQUENCE = p_wperil_disc.SEQUENCE)
       WHEN NOT MATCHED THEN
            INSERT (line_cd,          subline_cd,        disc_rt,
                    disc_amt,         net_gross_tag,     orig_peril_prem_amt,
                    SEQUENCE,         remarks,           net_prem_amt,
                    surcharge_rt,     surcharge_amt,     last_update,
                    par_id,           item_no,           peril_cd,
                    level_tag,        discount_tag,      orig_peril_ann_prem_amt,
                    orig_item_ann_prem_amt,  orig_pol_ann_prem_amt)
            VALUES (p_wperil_disc.line_cd,           p_wperil_disc.subline_cd,        p_wperil_disc.disc_rt,
                    p_wperil_disc.disc_amt,          p_wperil_disc.net_gross_tag,     p_wperil_disc.orig_peril_prem_amt,
                    p_wperil_disc.SEQUENCE,          p_wperil_disc.remarks,           p_wperil_disc.net_prem_amt,
                    p_wperil_disc.surcharge_rt,      p_wperil_disc.surcharge_amt,     SYSDATE,
                    p_wperil_disc.par_id,            p_wperil_disc.item_no,           p_wperil_disc.peril_cd,
                    p_wperil_disc.level_tag,         p_wperil_disc.discount_tag,      p_wperil_disc.orig_peril_ann_prem_amt,
                    p_wperil_disc.orig_item_ann_prem_amt,  p_wperil_disc.orig_pol_ann_prem_amt)
       WHEN MATCHED THEN
         UPDATE SET 
                line_cd                  = p_wperil_disc.line_cd,
                subline_cd               = p_wperil_disc.subline_cd,        
                disc_rt                  = p_wperil_disc.disc_rt,
                disc_amt                 = p_wperil_disc.disc_amt,         
                net_gross_tag            = p_wperil_disc.net_gross_tag,      
                orig_peril_prem_amt      = p_wperil_disc.orig_peril_prem_amt, 
                remarks                  = p_wperil_disc.remarks,           
                net_prem_amt             = p_wperil_disc.net_prem_amt,
                surcharge_rt             = p_wperil_disc.surcharge_rt,     
                surcharge_amt            = p_wperil_disc.surcharge_amt,       
                last_update              = SYSDATE,
                level_tag                = p_wperil_disc.level_tag,         
                discount_tag             = p_wperil_disc.discount_tag,         
                orig_peril_ann_prem_amt  = p_wperil_disc.orig_peril_ann_prem_amt,
                orig_item_ann_prem_amt   = p_wperil_disc.orig_item_ann_prem_amt,  
                orig_pol_ann_prem_amt    = p_wperil_disc.orig_pol_ann_prem_amt;
    END;
     
    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.19.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Contains delete procedure of table GIPI_WPERIL_DISCOUNT
    */
    PROCEDURE del_gipi_wperil_discount (p_par_id     GIPI_WPERIL_DISCOUNT.par_id%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WPERIL_DISCOUNT
         WHERE par_id = p_par_id;
    END del_gipi_wperil_discount;
    
    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.03.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Contains delete procedure of table GIPI_WPERIL_DISCOUNT
    */
    PROCEDURE del_gipi_wperil_discount_1 (p_par_id     GIPI_WPERIL_DISCOUNT.par_id%TYPE,
        p_item_no    GIPI_WPERIL_DISCOUNT.item_no%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WPERIL_DISCOUNT
         WHERE par_id = p_par_id
           AND item_no = p_item_no;
    END del_gipi_wperil_discount_1;
    
    /*
    **  Created by        : Jerome Orio 
    **  Date Created     : 01.26.2011 
    **  Reference By     : (GIPIS143- Discount/Surcharge)
    **  Description     : Contains delete procedure of table GIPI_WPERIL_DISCOUNT
    */
    PROCEDURE del_gipi_wperil_discount_2 (p_par_id     GIPI_WPERIL_DISCOUNT.par_id%TYPE)
    IS
		v_cond	number := 0;
		v_prorate    NUMBER;
		 v_rate      GIPI_WITEM.currency_rt%TYPE;
	BEGIN
	--added by steven 10/04/2012 to return the prem_amts to its original value before the peril is added 
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
		
			FOR itm IN (SELECT distinct item_no
					FROM GIPI_WPERIL_DISCOUNT a 
					  WHERE a.par_id = p_par_id
						AND a.level_tag = '1')
						LOOP
							FOR perl IN (SELECT distinct peril_cd
										FROM GIPI_WPERIL_DISCOUNT a 
										  WHERE a.par_id = p_par_id
											AND item_no =  itm.item_no
											AND a.level_tag = '1')
											LOOP
												FOR perl_amt IN (SELECT sum(disc_amt) disc_amt,sum(surcharge_amt) surcharge_amt
																	FROM GIPI_WPERIL_DISCOUNT a 
																	  WHERE a.par_id = p_par_id
																		AND item_no =  itm.item_no
																		AND peril_cd = perl.peril_cd
																		AND a.level_tag = '1')
																		LOOP
																			FOR rate IN(SELECT b480.currency_rt
																						  FROM GIPI_WITEM b480
																							WHERE b480.par_id = p_par_id
																							  AND b480.item_no = itm.item_no)
																								LOOP
																								   v_rate := rate.currency_rt;
																							  END LOOP;
																			
																			 UPDATE GIPI_WPOLBAS
																				 SET prem_amt     = (prem_amt     - ROUND((NVL(perl_amt.surcharge_amt,0) * v_rate),2)) + ROUND((NVL(perl_amt.disc_amt,0) * v_rate),2) ,
																					 ann_prem_amt = (ann_prem_amt - (ROUND((NVL(perl_amt.surcharge_amt,0) * v_rate),2)/ NVL(v_prorate, 1))) + (ROUND((NVL(perl_amt.disc_amt,0) * v_rate),2)/ NVL(v_prorate, 1)) 
																			   WHERE par_id  = p_par_id;
																			  
																			  UPDATE GIPI_WITEM
																				 SET prem_amt     = (prem_amt     - NVL(perl_amt.surcharge_amt,0)) + NVL(perl_amt.disc_amt,0),
																					 ann_prem_amt = (ann_prem_amt - (NVL(perl_amt.surcharge_amt,0) / NVL(v_prorate, 1))) + (NVL(perl_amt.disc_amt,0) / NVL(v_prorate, 1))
																			   WHERE par_id  = p_par_id
																				 AND item_no = itm.item_no;
																			
																			  UPDATE GIPI_WITMPERL
																				 SET prem_amt     = (prem_amt     - NVL(perl_amt.surcharge_amt,0)) + NVL(perl_amt.disc_amt,0),
																					 ann_prem_amt = (ann_prem_amt - (NVL(perl_amt.surcharge_amt,0) / NVL(v_prorate, 1))) + (NVL(perl_amt.disc_amt,0) / NVL(v_prorate, 1))
																			   WHERE par_id   = p_par_id
																				 AND item_no  = itm.item_no
																				 AND peril_cd = perl.peril_cd;
																	END LOOP;
										END LOOP;
					END LOOP;
		--end steven
        DELETE FROM GIPI_WPERIL_DISCOUNT
         WHERE par_id = p_par_id
           AND level_tag = '1';
    END del_gipi_wperil_discount_2;
    
    /*
    **  Created by        : Bryan Joseph Abuluyan
    **  Date Created     : 02.25.2010
    **  Reference By     : (GIPIS038 - Peril Information)
    **  Description     : Deducts discount from table
    */
    PROCEDURE get_peril_discount(p_b240_par_id          IN     GIPI_PARLIST.par_id%TYPE
                                  ,p_b480_item_no       IN     GIPI_WITEM.item_no%TYPE
                                ,p_B480_prem_amt      IN  GIPI_WITEM.prem_amt%TYPE
                                ,p_b490_peril_cd      IN     GIPI_WITMPERL.peril_cd%TYPE
                                ,p_B490_prem_amt      IN     GIPI_WITMPERL.prem_amt%TYPE
                                ,p_b490_ri_comm_rate IN  GIPI_WITMPERL.ri_comm_rate%TYPE
                                ,p_B480_prem_amt2      OUT GIPI_WITEM.prem_amt%TYPE
                                ,p_B490_prem_amt2      OUT GIPI_WITMPERL.prem_amt%TYPE
                                ,p_B490_discount_sw  OUT GIPI_WITMPERL.discount_sw%TYPE
                                ,p_B490_ri_comm_amt  OUT GIPI_WITMPERL.ri_comm_amt%TYPE
                                ,p_B490_ann_prem_amt OUT GIPI_WITMPERL.ann_prem_amt%TYPE)
      IS
    BEGIN
      FOR D1 IN(SELECT SUM(disc_amt) disc_sum
                  FROM GIPI_WPERIL_DISCOUNT
                 WHERE par_id   = p_b240_par_id
                   AND item_no  = p_b480_item_no 
                   AND peril_cd = p_b490_peril_cd) 
      LOOP  
         p_B480_prem_amt2         := p_B480_prem_amt + NVL(D1.disc_sum,0);
         p_B490_prem_amt2         := p_B490_prem_amt + NVL(D1.disc_sum,0);
         p_B490_discount_sw       := 'N';
         p_b490_ri_comm_amt       :=  NVL(p_b490_ri_comm_rate,0) * NVL(p_b490_prem_amt,0) / 100;
         EXIT;
      END LOOP;
      FOR D2 IN (SELECT orig_peril_ann_prem_amt peril_prem
                   FROM GIPI_WPERIL_DISCOUNT
                  WHERE par_id   = p_b240_par_id
                    AND item_no  = p_b480_item_no 
                    AND peril_cd = p_b490_peril_cd
                    AND orig_peril_ann_prem_amt IS NOT NULL
                  ORDER BY last_update )  
      LOOP           
        p_B490_ann_prem_amt     := d2.peril_prem;
        EXIT;
      END LOOP;           

    END get_peril_discount;

    /*
    **  Created by        : Bryan Joseph Abuluyan
    **  Date Created     : 02.26.2010
    **  Reference By     : (GIPIS038 - Peril Information)
    **  Description     : Gets the default item premium value
    */
    FUNCTION get_orig_item_ann_prem_amt(p_par_id         GIPI_WPERIL_DISCOUNT.par_id%TYPE
                                         ,p_item_no         GIPI_WPERIL_DISCOUNT.item_no%TYPE)
      RETURN GIPI_WPERIL_DISCOUNT.orig_item_ann_prem_amt%TYPE IS
      v_item_prem                GIPI_WPERIL_DISCOUNT.orig_item_ann_prem_amt%TYPE;
    BEGIN
      FOR i IN (SELECT orig_item_ann_prem_amt item_prem
                  FROM GIPI_WPERIL_DISCOUNT
                 WHERE par_id   = p_par_id
                   AND item_no  = p_item_no 
                   AND orig_item_ann_prem_amt IS NOT NULL
                 ORDER BY last_update)
      LOOP
        v_item_prem := i.item_prem;
        EXIT;
      END LOOP;
      RETURN v_item_prem;
    END get_orig_item_ann_prem_amt;
    
    --checks if par has existing discount (BRYAN 03.31.2010)
    FUNCTION check_if_discount_exists(p_par_id     GIPI_WPERIL_DISCOUNT.par_id%TYPE)
      RETURN VARCHAR2
      IS
      v_exists         VARCHAR2(1) := 'N';
    BEGIN
      FOR i IN (
        SELECT 'Y' disc_exists
          FROM GIPI_WPERIL_DISCOUNT
         WHERE par_id = p_par_id)
      LOOP
        v_exists                   := i.disc_exists;
        EXIT;
      END LOOP;
      RETURN v_exists;
    END check_if_discount_exists;


  /*
  **  Created by    : Menandro G.C. Robes
  **  Date Created     : May 20, 2010
  **  Reference By     : (GIPIS097 - Endorsement Item Peril)
  **  Description     : Function to retrieve the total discount of a peril.
  */       
    FUNCTION get_peril_sum_discount(p_par_id   GIPI_WITMPERL.par_id%TYPE,
                                    p_item_no  GIPI_WITMPERL.item_no%TYPE,
                                    p_peril_cd GIPI_WITMPERL.peril_cd%TYPE)
      RETURN NUMBER IS
      
      v_disc_sum GIPI_WPERIL_DISCOUNT.disc_amt%TYPE := 0;
      
    BEGIN
      FOR i IN 
        (SELECT SUM(disc_amt) disc_sum
           FROM gipi_wperil_discount
          WHERE par_id   = p_par_id
            AND item_no  = p_item_no 
            AND peril_cd = p_peril_cd)
      LOOP
        v_disc_sum := i.disc_sum;
      END LOOP;
      RETURN v_disc_sum;                  
    END get_peril_sum_discount;    
    
END Gipi_Wperil_Discount_Pkg;
/


