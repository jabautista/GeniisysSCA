DROP PROCEDURE CPI.COMPUTE_TSI_PERIL;

CREATE OR REPLACE PROCEDURE CPI.COMPUTE_TSI_PERIL(p_tsi_amt       IN NUMBER, 
                        p_prem_rt       IN NUMBER,    
                        p_ann_tsi_amt   IN NUMBER,    
                        p_ann_prem_amt  IN NUMBER,    
                        i_tsi_amt       IN NUMBER,    
                        i_prem_amt      IN NUMBER,     
                        i_ann_tsi_amt   IN NUMBER,    
                        i_ann_prem_amt  IN NUMBER,
                        p_prov_prem_pct IN NUMBER,
                        p_prov_prem_tag IN VARCHAR2,
						pe_prem_amt		IN NUMBER,
						p_peril_cd		IN NUMBER,
						p_par_id 		IN NUMBER,
						p_item_no		IN NUMBER,
						v_peril_prem_amt     OUT NUMBER,
						v_peril_ann_prem_amt OUT NUMBER,
						v_peril_ann_tsi_amt  OUT NUMBER,
						v_item_prem_amt	  	 OUT NUMBER,
						v_item_ann_prem_amt  OUT NUMBER,
						v_item_tsi_amt		 OUT NUMBER,
						v_item_ann_tsi_amt	 OUT NUMBER ) IS  

   var_type          VARCHAR2(1);
   v_peril_type		GIIS_PERIL.PERIL_TYPE%TYPE;

   prov_discount     NUMBER(12,9)        :=  NVL(p_prov_prem_pct/100,1);

   p_prem_amt        NUMBER(14,2); --gipi_witmperl.prem_amt%TYPE; to avoid exception ORA-06502 BRY      

   p2_ann_tsi_amt    gipi_witmperl.ann_tsi_amt%TYPE;   
   p2_ann_prem_amt   gipi_witmperl.ann_prem_amt%TYPE;  

   po_tsi_amt        gipi_witmperl.tsi_amt%TYPE   :=  p_tsi_amt;
   po_prem_amt       /*gipi_witmperl.prem_amt%TYPE to avoid exception ORA-06502 BRY*/ NUMBER(14,2)  :=  pe_prem_amt;
   po_prem_rt        gipi_witmperl.prem_rt%TYPE   :=  p_prem_rt;

   i2_tsi_amt        gipi_witem.tsi_amt%TYPE;       
   i2_prem_amt       gipi_witem.prem_amt%TYPE;
   i2_ann_tsi_amt    gipi_witem.ann_tsi_amt%TYPE;
   i2_ann_prem_amt   gipi_witem.ann_prem_amt%TYPE;

   v_prorate         NUMBER;
   v_prem_amt        NUMBER(14,2); --gipi_witmperl.prem_amt%TYPE; to avoid exception ORA-06502 BRY
   vo_prem_amt       NUMBER(14,2); --gipi_witmperl.prem_amt%TYPE; to avoid exception ORA-06502 BRY

   p_prov_tag        gipi_wpolbas.prov_prem_tag%TYPE;
   po_prov_prem      gipi_witmperl.prem_amt%TYPE;
   v_prov_prem       gipi_witmperl.prem_amt%TYPE;
   p_prov_prem       gipi_witmperl.prem_amt%TYPE; 
   
   v_changed_tag	  GIPI_WITEM.changed_tag%TYPE;
   v_prorate_flag	  GIPI_WITEM.prorate_flag%TYPE;
   v_comp_sw		  GIPI_WITEM.comp_sw%TYPE;
   v_to_date		  GIPI_WITEM.to_date%TYPE;
   v_from_date		  GIPI_WITEM.from_date%TYPE;
   v_short_rt_percent GIPI_WITEM.short_rt_percent%TYPE;
   
   v_prorate_flag2	   GIPI_WPOLBAS.PRORATE_FLAG%TYPE;
   v_comp_sw2		   GIPI_WPOLBAS.comp_sw%TYPE;
   v_eff_date		   GIPI_WPOLBAS.eff_date%TYPE;
   v_expiry_date	   GIPI_WPOLBAS.expiry_date%TYPE;
   v_short_rt_percent2 GIPI_WPOLBAS.short_rt_percent%TYPE;

BEGIN

   IF NVL(p_prov_prem_tag,'N') != 'Y' THEN
         prov_discount  :=  1;
   END IF;

   BEGIN
    SELECT peril_type
	  INTO v_peril_type
	  FROM GIIS_PERIL
	 WHERE peril_cd = p_peril_cd
	   AND line_cd = (SELECT line_cd FROM GIPI_PARLIST WHERE par_id = p_par_id);
   EXCEPTION
     WHEN NO_DATA_FOUND THEN NULL;
   END;
   
   BEGIN
    SELECT changed_tag, prorate_flag, comp_sw, to_date, from_date, short_rt_percent
	  INTO v_changed_tag, v_prorate_flag, v_comp_sw, v_to_date, v_from_date, v_short_rt_percent
	  FROM GIPI_WITEM
	 WHERE par_id = p_par_id
	   AND item_no = p_item_no;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN NULL;
   END;

   var_type := v_peril_type;

  IF NVL(v_changed_tag,'N') = 'Y' THEN
     IF v_prorate_flag = 1 THEN
       IF v_comp_sw = 'Y' THEN
          v_prorate  :=  ((TRUNC( v_TO_DATE) - TRUNC(v_from_date )) + 1 )/
            check_duration(v_from_date, v_to_date);
       ELSIF v_comp_sw = 'M' THEN
          v_prorate  :=  ((TRUNC( v_TO_DATE) - TRUNC(v_from_date )) - 1 )/
            check_duration(v_from_date, v_to_date);
       ELSE
          v_prorate  :=  (TRUNC( v_TO_DATE) - TRUNC(v_from_date ))/
            check_duration(v_from_date, v_to_date);
       END IF;
       v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;

       IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
            vo_prem_amt:=   NVL(po_prem_amt,0);
       ELSE
            vo_prem_amt:=   NVL(po_prem_amt,0);
       END IF;

       p_prem_amt :=  ((NVL(p_tsi_amt,0) * NVL(p_prem_rt,0)) / 100 ) * 
                              v_prorate * prov_discount;
       p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  -
                              NVL(po_tsi_amt,0));
       p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                              NVL(p_ann_prem_amt,0)); 
       i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                              NVL(po_prem_amt,0);
       i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                              NVL(p_ann_prem_amt,0)); 
       IF var_type = 'B' THEN
         i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                                NVL(po_tsi_amt,0);
         i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                                NVL(po_tsi_amt,0);
       END IF;

     ELSIF v_prorate_flag = 2 THEN
        v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;

        IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
             vo_prem_amt:=  (NVL(po_prem_amt,0));
        ELSE
             vo_prem_amt:=  (NVL(po_prem_amt,0));
        END IF;

        p_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;

        p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  -
                               NVL(po_tsi_amt,0));

        p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                               NVL(vo_prem_amt,0)); 
 
        i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                               NVL(po_prem_amt,0);

        i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                               NVL(vo_prem_amt,0));

        IF var_type = 'B' THEN
           i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                                NVL(po_tsi_amt,0);

           i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                                NVL(po_tsi_amt,0);

        END IF;

     ELSE
        v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;

        IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
             vo_prem_amt:=  (NVL(po_prem_amt,0));
        ELSE
             vo_prem_amt:=  (NVL(po_prem_amt,0));

        END IF;
 
        p_prem_amt := (((NVL(p_prem_rt,0) * NVL(p_tsi_amt,0) * NVL(v_short_rt_percent,0))) /
                         10000) * prov_discount;
                      -- Solve for the premium amount (short rate) for perils
        p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  -
                               NVL(po_tsi_amt,0));
                      -- Solve for the annualized tsi amount for perils
        p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                               NVL(po_prem_amt,0)); 
                      -- Solve for the annualized prem amount for perils
        i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                               NVL(po_prem_amt,0);
                      -- Solve for the premium amount
        i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                               NVL(vo_prem_amt,0));
                      -- Solve for the annualized prem amount
        IF var_type = 'B' THEN
           i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                               NVL(po_tsi_amt,0);
                      -- Solve for the tsi amt for items
           i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                               NVL(po_tsi_amt,0);
                      -- Solve for the annualized tsi amount
        END IF;
     END IF;
   /** end of added codes by bdarusin **/
  ELSE
        /* Three conditions have to be considered for en- *
      * dorsements :  1 indicates that computation     *
      * should be prorated.                            */

	 BEGIN
	   SELECT prorate_flag, comp_sw, eff_date, expiry_date, short_rt_percent
	     INTO v_prorate_flag2, v_comp_sw2, v_eff_date, v_expiry_date, v_short_rt_percent2
		 FROM GIPI_WPOLBAS
		WHERE par_id = p_par_id;
	 EXCEPTION
	   WHEN NO_DATA_FOUND THEN NULL; 
	 END;

     IF v_prorate_flag2 = 1 THEN
         --IF :b240.endt_expiry_date <= :b240.eff_date THEN
                --msg_alert('Your endorsement expiry date is equal to or less than your effectivity date.'||
                          --' Restricted condition.','E',TRUE);
         --ELSE
         /*beth 021199 change the date from endt_expiry_date to expiry_date
          v_prorate  :=  TRUNC( :b240.endt_expiry_date - :b240.eff_date ) /
                               (ADD_MONTHS(:b240.eff_date,12) - :b240.eff_date);*/
        --belle 02.03.2012 changed v_comp_sw to v_comp_sw2 to get correct premium amounts                                
  		      IF v_comp_sw2 = 'Y' THEN 
  		         v_prorate  :=  ((TRUNC( v_expiry_date) - TRUNC(v_eff_date )) + 1 )/
  		                          check_duration(v_eff_date, v_expiry_date);
  		                          --(ADD_MONTHS(:b240.eff_date,12) - :b240.eff_date);
                
  		      ELSIF v_comp_sw2 = 'M' THEN
  		         v_prorate  :=  ((TRUNC( v_expiry_date) - TRUNC(v_eff_date )) - 1 )/
  		                          check_duration(v_eff_date, v_expiry_date);
  		                          --(ADD_MONTHS(:b240.eff_date,12) - :b240.eff_date);
  		      ELSE
  		         v_prorate  :=  (TRUNC( v_expiry_date) - TRUNC(v_eff_date ))/
  		                          check_duration(v_eff_date, v_expiry_date);
  		                          --(ADD_MONTHS(:b240.eff_date,12) - :b240.eff_date);
  		      END IF;
         --END IF;
                       -- Solve for the prorate period
         v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                       -- Solve for the annualized premium amount
  
         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
              vo_prem_amt:=   NVL(po_prem_amt,0);
         ELSE
              vo_prem_amt:=   NVL(po_prem_amt,0);
             -- vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0)/100 ) * prov_discount;
                       -- Solve for the old annualized premium amount
         END IF;
         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
  
         p_prem_amt :=  ((NVL(p_tsi_amt,0) * NVL(p_prem_rt,0)) / 100 ) * 
                                v_prorate * prov_discount;
                       -- Solve for the premium amount (prorated value) for perils
         p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  -
                                NVL(po_tsi_amt,0));
                       -- Solve for the annualized tsi amount for perils
         p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                                NVL(p_ann_prem_amt,0)); 
                                --beth 022699 NVL(vo_prem_amt,0)); 
                       -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                                NVL(po_prem_amt,0);
                       -- Solve for the premium amount
         i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                                NVL(p_ann_prem_amt,0)); 
                                --beth 022699NVL(vo_prem_amt,0));
                       -- Solve for the annualized prem amount
         -- add tsi amount of items when peril type of peril is equal to 'B'
         IF var_type = 'B' THEN
           i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                                  NVL(po_tsi_amt,0);
                         -- Solve for the tsi amt for items
           i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                                  NVL(po_tsi_amt,0);
                         -- Solve for the annualized tsi amount
         END IF;
     /* Three conditions have to be considered for en- *
      * dorsements :  2 indicates that computation     *
      * should be based on a one year span.            */
     ELSIF v_prorate_flag2 = 2 THEN
         v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                       -- Solve for the annualized premium amount
  
         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
              vo_prem_amt:=  (NVL(po_prem_amt,0));
         ELSE
              vo_prem_amt:=  (NVL(po_prem_amt,0));
             -- vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                       -- Solve for the old annualized premium amount
         END IF;
         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
  
         p_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                       -- Solve for the premium amount (for one year) for perils
         p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  -
                                NVL(po_tsi_amt,0));
                       -- Solve for the annualized tsi amount for perils
         p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                                NVL(vo_prem_amt,0)); 
                       -- Solve for the annualized prem amount for perils
  
         i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                                NVL(po_prem_amt,0);
                       -- Solve for the premium amount
         i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                                NVL(vo_prem_amt,0));
                       -- Solve for the annualized prem amount
           IF var_type = 'B' THEN
            i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                                  NVL(po_tsi_amt,0);
                         -- Solve for the tsi amt for items
            i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                                  NVL(po_tsi_amt,0);
                         -- Solve for the annualized tsi amount
         END IF;
     /* Three conditions have to be considered for en- *
      * dorsements :  3 indicates that computation     *
      * should be based with respect to the short rate *
      * percent.                                       */
     ELSE
         v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                       -- Solve for the annualized premium amount
         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
              vo_prem_amt:=  (NVL(po_prem_amt,0));
         ELSE
              vo_prem_amt:=  (NVL(po_prem_amt,0));
             -- vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0)/100 ) * prov_discount;
                       -- Solve for the old annualized premium amount
         END IF;
         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
  
         p_prem_amt := (((NVL(p_prem_rt,0) * NVL(p_tsi_amt,0) * NVL(v_short_rt_percent2,0))) /
                          10000) * prov_discount;
                       -- Solve for the premium amount (short rate) for perils
         p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  -
                                NVL(po_tsi_amt,0));
                       -- Solve for the annualized tsi amount for perils
         p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                                NVL(po_prem_amt,0)); 
                       -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                                NVL(po_prem_amt,0);
                       -- Solve for the premium amount
         i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                                NVL(vo_prem_amt,0));
                       -- Solve for the annualized prem amount
         IF var_type = 'B' THEN
            i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                                NVL(po_tsi_amt,0);
                       -- Solve for the tsi amt for items
            i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) -
                                NVL(po_tsi_amt,0);
                       -- Solve for the annualized tsi amount
         END IF;
     END IF;
  END IF;

  v_peril_prem_amt     :=  p_prem_amt;
  v_peril_ann_prem_amt :=  p2_ann_prem_amt;
  v_peril_ann_tsi_amt  :=  p2_ann_tsi_amt;
  v_item_prem_amt     :=  i2_prem_amt;
  v_item_ann_prem_amt :=  i2_ann_prem_amt;
   	
  IF var_type = 'B' THEN
    v_item_tsi_amt      :=  i2_tsi_amt;
    v_item_ann_tsi_amt  :=  i2_ann_tsi_amt;
  END IF;
  
END COMPUTE_TSI_PERIL;
/


