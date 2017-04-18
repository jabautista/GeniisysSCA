DROP PROCEDURE CPI.COMPUTE_PREMIUM_FINAL;

CREATE OR REPLACE PROCEDURE CPI.COMPUTE_PREMIUM_FINAL(
    i_ann_prem_amt      IN      NUMBER,     
    i_nbt_prem_amt      IN      NUMBER,     
    ig_nbt_prem_amt         OUT NUMBER,
    n_ann_prem_amt      IN  OUT NUMBER,     
    n_nbt_prem_amt      IN  OUT NUMBER,
    n_nbt_prem_rt       IN      NUMBER,
    n_nbt_tsi_amt       IN      NUMBER,
    n_prem_amt          IN      NUMBER,     
    n_prem_rt               OUT GIPI_WITMPERL.prem_rt%TYPE,
    n_tsi_amt           IN      NUMBER,     
    ng_ann_prem_amt     IN  OUT NUMBER,
    ng_nbt_prem_amt     IN      NUMBER,
    ng_nbt_prem_rt      IN      NUMBER,
    ng_nbt_tsi_amt      IN      NUMBER,
    ng_prem_rt              OUT GIPI_WITMPERL.prem_rt%TYPE,
    p_eff_date          IN      DATE,
    p_endt_expiry_date  IN      DATE,
    p_expiry_date       IN      DATE,
    p_msg                   OUT VARCHAR2,
    p_nbt_prorate_flag  IN      VARCHAR2,
    p_prov_prem_pct     IN      NUMBER,    
    p_prov_prem_tag     IN      VARCHAR2,
    p_short_rt_percent  IN      NUMBER,
    v_comp_sw           IN      VARCHAR2,
    v_is_gpa            IN      VARCHAR2
) 
IS 

   /*  GIVEN:    b490.prem_amt, b490.tsi_amt         *
    *  REQD:     b490.prem_amt,b490.ann_prem_amt,    *
    *            b490.prem_rt,b480.ann_prem_amt,     *
    *            b480.prem_amt                       */
    
    
   p_prem_amt        GIPI_WITMPERl.prem_amt%TYPE   :=  n_prem_amt;
   p_prem_rt         GIPI_WITMPERL.prem_rt%TYPE;        -- supposed value of b490.prem_rt

   p2_ann_tsi_amt    GIPI_WITMPERL.ann_tsi_amt%TYPE;    -- supposed value of b490.ann_tsi_amt
   p2_ann_prem_amt   GIPI_WITMPERL.ann_prem_amt%TYPE;   -- supposed value of b490.ann_prem_amt

   po_tsi_amt        GIPI_WITMPERL.tsi_amt%TYPE   :=  decode_grp(v_is_gpa, 'Y', ng_nbt_tsi_amt, n_nbt_tsi_amt);
   po_prem_amt       GIPI_WITMPERL.prem_amt%TYPE  :=  decode_grp(v_is_gpa, 'Y', ng_nbt_prem_amt, n_nbt_prem_amt);
   po_prem_rt        GIPI_WITMPERL.prem_rt%TYPE   :=  decode_grp(v_is_gpa, 'Y', ng_nbt_prem_rt, n_nbt_prem_rt);

   i2_tsi_amt        GIPI_WITEM.tsi_amt%TYPE;            -- supposed value of b480.tsi_amt
   i2_prem_amt       GIPI_WITEM.prem_amt%TYPE;           -- supposed value of b480.prem_amt
   i2_ann_tsi_amt    GIPI_WITEM.ann_tsi_amt%TYPE;        -- supposed value of b480.ann_tsi_amt
   i2_ann_prem_amt   GIPI_WITEM.ann_prem_amt%TYPE;       -- supposed value of b480.ann_prem_amt

   v_prorate         NUMBER;
   v_prem_amt        GIPI_WITMPERL.prem_amt%TYPE;
   vo_prem_amt       GIPI_WITMPERL.prem_amt%TYPE;

   p_prov_prem       GIPI_WITMPERL.prem_amt%TYPE;
   po_prov_prem      GIPI_WITMPERL.prem_amt%TYPE;

   prov_discount     NUMBER(12,9)  :=  NVL(p_prov_prem_pct/100,1);
BEGIN
   /* Special case where there is a prov_discount.
   ***********************************************
   */
   p_prov_prem        := NVL(n_prem_amt,0);
   po_prov_prem       := NVL(po_prem_amt,0);
   IF NVL(p_prov_prem_tag,'N') != 'Y' THEN
         prov_discount       :=  1;
   END IF;
   IF po_prem_amt is NOT NULL AND  po_tsi_amt is NOT NULL THEN      
      po_prem_rt :=   (po_prem_amt / po_tsi_amt) * 100;
   END IF;   

   /************************************************
   */
   /* Three conditions have to be considered for en- *
    * dorsements :  1 indicates that computation     *
    * should be prorated.                            */
   IF p_nbt_prorate_flag = 1 THEN
       IF p_endt_expiry_date <= p_eff_date THEN
              /*MSG_ALERT('Your endorsement expiry date is equal to or less than your effectivity date.'||
                        ' Restricted condition.','E',TRUE);*/
              p_msg := 'Your endorsement expiry date is equal to or less than your effectivity date.'||
                        ' Restricted condition.';
              RETURN;
       ELSE
/*BETH 021199 change the date from endt_expiry to policy expiry
         v_prorate  :=  TRUNC( p_endt_expiry_date - p_eff_date ) /
                             (ADD_MONTHS(p_eff_date,12) - p_eff_date);
*/
         IF v_comp_sw = 'Y' THEN
            v_prorate  :=  ((TRUNC( p_expiry_date) - TRUNC(p_eff_date )) + 1)/
                             (ADD_MONTHS(p_eff_date,12) - p_eff_date);
         ELSIF v_comp_sw = 'M' THEN
            v_prorate  :=  ((TRUNC( p_expiry_date) - TRUNC(p_eff_date )) - 1)/
                             (ADD_MONTHS(p_eff_date,12) - p_eff_date);
         ELSE
            v_prorate  :=  (TRUNC( p_expiry_date) - TRUNC(p_eff_date ) )/
                             (ADD_MONTHS(p_eff_date,12) - p_eff_date);
         END IF;
       END IF;
                     -- Solve for the prorate period

       --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
       IF ((NVL(n_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
          v_prem_amt :=  NVL(p_prem_amt,0) ;
          -- Compute for the prorated premium amount using the present premium
          -- as reference when tsi and premium rate are zero.
          IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
              vo_prem_amt:=  (NVL(po_prem_amt,0));
          ELSE
              vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                        -- Solve for the previous annualized premium amount
            -- Set another condition if the old tsi and premium rate are zero for 
            -- determining the old premium amount.
          END IF;
          -- Set another condition if the old tsi and premium rate are zero.
       ELSE
          p_prem_rt  :=  ((NVL(p_prem_amt,0) / NVL(n_tsi_amt,0)) * 100) / 
                          (v_prorate * prov_discount);
                     -- Solve for the premium rate
          v_prem_amt :=  (NVL(n_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                     -- Solve for the annualized premium amount
          IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
              vo_prem_amt:=  NVL(po_prem_amt,0);
          ELSE
              vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                        -- Solve for the previous annualized premium amount
          END IF;
          -- Set another condition if the old tsi and premium rate are zero.
       END IF;
       --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--

       p2_ann_prem_amt := (NVL(n_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                              NVL(decode_grp(v_is_gpa, 'Y', ng_ann_prem_amt, n_ann_prem_amt),0)); 
                              --beth 022699 NVL(vo_prem_amt,0)); 
                     -- Solve for the annualized prem amount for perils
       i2_prem_amt := (NVL(i_nbt_prem_amt,0) + NVL(n_prem_amt,0)) -
                              NVL(po_prem_amt,0);
                     -- Solve for the premium amount
       i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                              NVL(decode_grp(v_is_gpa, 'Y', ng_ann_prem_amt, n_ann_prem_amt),0)); 
                              --beth022699 NVL(vo_prem_amt,0));
                     -- Solve for the annualized prem amount

   /* Three conditions have to be considered for en- *
    * dorsements :  2 indicates that computation     *
    * should be based on a one year span.            */
   ELSIF p_nbt_prorate_flag = 2 THEN

       --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
       IF ((NVL(n_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
          v_prem_amt :=  (NVL(p_prem_amt,0));
          -- Compute for the prorated premium amount using the present premium
          -- as reference when tsi and premium rate are zero.
          IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
              vo_prem_amt:=  NVL(po_prem_amt,0);
          ELSE
              vo_prem_amt:=  NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100  * prov_discount;
                        -- Solve for the previous annualized premium amount
            -- Set another condition if the old tsi and premium rate are zero for
            -- determining of old tsi and premium.
          END IF;
          -- Set another condition if the old tsi and premium rate are zero.
       ELSE
          p_prem_rt  :=  ((NVL(p_prem_amt,0) / NVL(n_tsi_amt,0)) * 100) / prov_discount;
                     -- Solve for the premium rate
          v_prem_amt :=  (NVL(n_tsi_amt,0) * NVL(p_prem_rt,0) / 100 )  * prov_discount;
                     -- Solve for the annualized premium amount
          IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
              vo_prem_amt:=  (NVL(po_prem_amt,0));
          ELSE
              vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                        -- Solve for the previous annualized premium amount
          END IF;
          -- Set another condition if the old tsi and premium rate are zero.
       END IF;
       --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--

       p2_ann_prem_amt := (NVL(n_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                            NVL(decode_grp(v_is_gpa, 'Y', ng_ann_prem_amt, n_ann_prem_amt),0)); 
                              --beth022699NVL(vo_prem_amt,0)); 
                     -- Solve for the annualized prem amount for perils
       i2_prem_amt := (NVL(i_nbt_prem_amt,0) + NVL(n_prem_amt,0)) -
                              NVL(po_prem_amt,0);
                     -- Solve for the premium amount
       i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                            NVL(decode_grp(v_is_gpa, 'Y', ng_ann_prem_amt, n_ann_prem_amt),0)); 
                              --beth022699NVL(vo_prem_amt,0));
                     -- Solve for the annualized prem amount
   /* Three conditions have to be considered for en- *
    * dorsements :  3 indicates that computation     *
    * should be based with respect to the short rate *
    * percent.                                       */
   ELSE

       --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
       IF ((NVL(n_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
          v_prem_amt :=  (NVL(p_prem_amt,0) / (NVL(p_short_rt_percent,1)/100));
          -- Compute for the prorated premium amount using the present premium
          -- as reference when tsi and premium rate are zero.
          IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
              vo_prem_amt:= NVL(po_prem_amt,0);
          ELSE
              vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                        -- Solve for the previous annualized premium amount
            -- Set another condition if the old tsi and premium rate are zero for 
            -- determining the old premium amount.
          END IF;
          -- Set another condition if the old tsi and premium rate are zero.
       ELSE
          p_prem_rt  :=  ((NVL(p_prem_amt,0) * 10000) /
                           (NVL(n_tsi_amt,1) * NVL(p_short_rt_percent,1) * prov_discount));
                     -- Solve for the premium rate
          v_prem_amt :=  (NVL(n_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                     -- Solve for the annualized premium amount
          IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
              vo_prem_amt:=  (NVL(po_prem_amt,0));
          ELSE
              vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                        -- Solve for the previous annualized premium amount
          END IF;
          -- Set another condition if the old tsi and premium rate are zero.
       END IF;
       --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--

       p2_ann_prem_amt := (NVL(n_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                          NVL(decode_grp(v_is_gpa, 'Y', ng_ann_prem_amt, n_ann_prem_amt),0)); 
                              --beth022699NVL(vo_prem_amt,0)); 
                     -- Solve for the annualized prem amount for perils
       i2_prem_amt := (NVL(i_nbt_prem_amt,0) + NVL(n_prem_amt,0)) -
                              NVL(po_prem_amt,0);
                     -- Solve for the premium amount
       i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                               NVL(decode_grp(v_is_gpa, 'Y', ng_ann_prem_amt, n_ann_prem_amt),0)); 
                              --beth022699NVL(vo_prem_amt,0));
                     -- Solve for the annualized prem amount
   END IF;
   
   IF v_is_gpa = 'Y' THEN               
       ng_prem_rt          :=  NVL(p_prem_rt,0);
       ng_ann_prem_amt     :=  NVL(p2_ann_prem_amt,0);
       ig_nbt_prem_amt     :=  NVL(i2_prem_amt,0);
   ELSE                
       n_prem_rt          :=  NVL(p_prem_rt,0);
       n_ann_prem_amt     :=  NVL(p2_ann_prem_amt,0);
       n_nbt_prem_amt     :=  NVL(i2_prem_amt,0);
   END IF;   
EXCEPTION
    WHEN VALUE_ERROR THEN
    p_msg := 'Invalid value for field.';
END;
/


