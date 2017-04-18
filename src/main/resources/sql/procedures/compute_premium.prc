DROP PROCEDURE CPI.COMPUTE_PREMIUM;

CREATE OR REPLACE PROCEDURE CPI.compute_premium (
   n_prem_amt           IN      NUMBER,          
   n_tsi_amt            IN      NUMBER,         
   n_ann_prem_amt       IN OUT  NUMBER,       
   i_nbt_prem_amt       IN      NUMBER,        
   i_ann_prem_amt       IN      NUMBER,
   p_prov_prem_pct      IN      NUMBER,
   n_nbt_tsi_amt        IN OUT  NUMBER,
   n_nbt_prem_amt       IN OUT  NUMBER,
   n_nbt_prem_rt        IN OUT  NUMBER,
   p_eff_date           IN      DATE,
   p_endt_expiry_date   IN      DATE,
   p_expiry_date        IN      DATE,
   p_prov_prem_tag      IN      VARCHAR2,
   p_nbt_prorate_flag   IN      VARCHAR2,  
   p_short_rt_percent   IN      NUMBER,
   v_comp_sw            IN      VARCHAR2,
   n_prem_rt               OUT GIPI_WITMPERL.prem_rt%TYPE, 
   p_msg                   OUT VARCHAR2
)
IS    
    /*
    **  Created by     : Robert Virrey
    **  Date Created   : 04.23.2012
    **  Reference By   : (GIEXS007 - Edit Peril Information)
    **  Description    : compute_premium program unit
	*/         
   p_prem_amt        NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE       := n_prem_amt;
   p_prem_rt         gipi_witmperl.prem_rt%TYPE;
   p2_ann_tsi_amt    NUMBER(20,2); --gipi_witmperl.ann_tsi_amt%TYPE;
   p2_ann_prem_amt   NUMBER(20,2); --gipi_witmperl.ann_prem_amt%TYPE;
   --n_nbt_tsi_amt        gipi_witmperl.tsi_amt%TYPE := decode_grp (variables.is_gpa,'Y', :b490_grp.nbt_tsi_amt,:b490.nbt_tsi_amt );
   --n_nbt_prem_amt       gipi_witmperl.prem_amt%TYPE:= decode_grp (variables.is_gpa,'Y',:b490_grp.nbt_prem_amt,:b490.nbt_prem_amt );
   --n_nbt_prem_rt        gipi_witmperl.prem_rt%TYPE:= decode_grp (variables.is_gpa,'Y',:b490_grp.nbt_prem_rt, :b490.nbt_prem_rt);
   i2_tsi_amt        NUMBER(20,2); --gipi_witem.tsi_amt%TYPE;
   i2_prem_amt       NUMBER(20,2); --gipi_witem.prem_amt%TYPE;
   i2_ann_tsi_amt    NUMBER(20,2); --gipi_witem.ann_tsi_amt%TYPE;
   i2_ann_prem_amt   NUMBER(20,2); --gipi_witem.ann_prem_amt%TYPE;
   v_prorate         NUMBER;
   v_prem_amt        NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
   vo_prem_amt       NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
   p_prov_prem       NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
   po_prov_prem      NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
   prov_discount     NUMBER (12, 9)          := NVL (p_prov_prem_pct / 100, 1);
BEGIN
   /* Special case where there is a prov_discount.
   ***********************************************
   */
   p_prov_prem := NVL (n_prem_amt, 0);
   po_prov_prem := NVL (n_nbt_prem_amt, 0);

   IF NVL (p_prov_prem_tag, 'N') != 'Y'
   THEN
      prov_discount := 1;
   END IF;

--   IF n_nbt_prem_amt IS NOT NULL AND n_nbt_tsi_amt IS NOT NULL -- Commented out by Jerome Bautista 03.14.2016 SR 21369
--   THEN
--      n_nbt_prem_rt := (n_nbt_prem_amt / n_nbt_tsi_amt) * 100;
--   END IF;

   IF n_prem_amt IS NOT NULL AND n_tsi_amt IS NOT NULL -- Added by Jerome Bautista 03.14.2016 SR 21369
   THEN
      n_prem_rt := (n_prem_amt / n_tsi_amt) * 100;
   END IF;

/************************************************
*/
/* Three conditions have to be considered for en- *
 * dorsements :  1 indicates that computation     *
 * should be prorated.                            */
   IF p_nbt_prorate_flag = 1
   THEN
      IF p_endt_expiry_date <= p_eff_date
      THEN
         p_msg := 'Your endorsement expiry date is equal to or less than your effectivity date.'
             || ' Restricted condition.';
      ELSE
/*BETH 021199 change the date from endt_expiry to policy expiry
         v_prorate  :=  TRUNC( :b240.endt_expiry_date - :b240.eff_date ) /
                             (ADD_MONTHS(:b240.eff_date,12) - :b240.eff_date);
*/
         IF v_comp_sw = 'Y'
         THEN
            v_prorate :=
                 ((TRUNC (p_expiry_date) - TRUNC (p_eff_date)) + 1
                 )
               / (ADD_MONTHS (p_eff_date, 12) - p_eff_date);
         ELSIF v_comp_sw = 'M'
         THEN
            v_prorate :=
                 ((TRUNC (p_expiry_date) - TRUNC (p_eff_date)) - 1
                 )
               / (ADD_MONTHS (p_eff_date, 12) - p_eff_date);
         ELSE
            v_prorate :=
                 (TRUNC (p_expiry_date) - TRUNC (p_eff_date))
               / (ADD_MONTHS (p_eff_date, 12) - p_eff_date);
         END IF;
      END IF;

      -- Solve for the prorate period

      --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
      IF ((NVL (n_tsi_amt, 0) = 0) AND (NVL (p_prem_rt, 0) = 0))
      THEN
         v_prem_amt := NVL (p_prem_amt, 0);

         -- Compute for the prorated premium amount using the present premium
         -- as reference when tsi and premium rate are zero.
         IF ((NVL (n_nbt_tsi_amt, 0) = 0) AND (NVL (n_nbt_prem_rt, 0) = 0))
         THEN
            vo_prem_amt := (NVL (n_nbt_prem_amt, 0));
         ELSE
            vo_prem_amt :=
                 (NVL (n_nbt_tsi_amt, 0) * NVL (n_nbt_prem_rt, 0) / 100)
               * prov_discount;
                     -- Solve for the previous annualized premium amount
         -- Set another condition if the old tsi and premium rate are zero for
         -- determining the old premium amount.
         END IF;
      -- Set another condition if the old tsi and premium rate are zero.
      ELSE
         p_prem_rt :=
              ((NVL (p_prem_amt, 0) / NVL (n_tsi_amt, 0)) * 100)
            / (v_prorate * prov_discount);
         -- Solve for the premium rate
         v_prem_amt :=
                 (NVL (n_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100)
                 * prov_discount;

         -- Solve for the annualized premium amount
         IF ((NVL (n_nbt_tsi_amt, 0) = 0) AND (NVL (n_nbt_prem_rt, 0) = 0))
         THEN
            vo_prem_amt := NVL (n_nbt_prem_amt, 0);
         ELSE
            vo_prem_amt :=
                 (NVL (n_nbt_tsi_amt, 0) * NVL (n_nbt_prem_rt, 0) / 100)
               * prov_discount;
         -- Solve for the previous annualized premium amount
         END IF;
      -- Set another condition if the old tsi and premium rate are zero.
      END IF;

      --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
      p2_ann_prem_amt :=
         (  NVL (n_ann_prem_amt, 0)
          + NVL (v_prem_amt, 0)
          - NVL (n_ann_prem_amt, 0)
         );
               --beth 022699 NVL(vo_prem_amt,0));
      -- Solve for the annualized prem amount for perils
      i2_prem_amt :=
            (NVL (i_nbt_prem_amt, 0) + NVL (n_prem_amt, 0))
            - NVL (n_nbt_prem_amt, 0);
      -- Solve for the premium amount
      i2_ann_prem_amt :=
         (  NVL (i_ann_prem_amt, 0)
          + NVL (v_prem_amt, 0)
          - NVL (n_ann_prem_amt, 0)
         );
            --beth022699 NVL(vo_prem_amt,0));
   -- Solve for the annualized prem amount

   /* Three conditions have to be considered for en- *
    * dorsements :  2 indicates that computation     *
    * should be based on a one year span.            */
   ELSIF p_nbt_prorate_flag = 2
   THEN
      --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
      IF ((NVL (n_tsi_amt, 0) = 0) AND (NVL (p_prem_rt, 0) = 0))
      THEN
         v_prem_amt := (NVL (p_prem_amt, 0));

         -- Compute for the prorated premium amount using the present premium
         -- as reference when tsi and premium rate are zero.
         IF ((NVL (n_nbt_tsi_amt, 0) = 0) AND (NVL (n_nbt_prem_rt, 0) = 0))
         THEN
            vo_prem_amt := NVL (n_nbt_prem_amt, 0);
         ELSE
            vo_prem_amt :=
                NVL (n_nbt_tsi_amt, 0) * NVL (n_nbt_prem_rt, 0) / 100
                * prov_discount;
                     -- Solve for the previous annualized premium amount
         -- Set another condition if the old tsi and premium rate are zero for
         -- determining of old tsi and premium.
         END IF;
      -- Set another condition if the old tsi and premium rate are zero.
      ELSE
         p_prem_rt :=
            ((NVL (p_prem_amt, 0) / NVL (n_tsi_amt, 0)) * 100)
            / prov_discount;
         -- Solve for the premium rate
         v_prem_amt :=
                (NVL (n_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100)
                * prov_discount;

         -- Solve for the annualized premium amount
         IF ((NVL (n_nbt_tsi_amt, 0) = 0) AND (NVL (n_nbt_prem_rt, 0) = 0))
         THEN
            vo_prem_amt := (NVL (n_nbt_prem_amt, 0));
         ELSE
            vo_prem_amt :=
                 (NVL (n_nbt_tsi_amt, 0) * NVL (n_nbt_prem_rt, 0) / 100)
               * prov_discount;
         -- Solve for the previous annualized premium amount
         END IF;
      -- Set another condition if the old tsi and premium rate are zero.
      END IF;

      --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
      p2_ann_prem_amt :=
         (  NVL (n_ann_prem_amt, 0)
          + NVL (v_prem_amt, 0)
          - NVL (n_ann_prem_amt,0)
         );
               --beth022699NVL(vo_prem_amt,0));
      -- Solve for the annualized prem amount for perils
      i2_prem_amt :=
            (NVL (i_nbt_prem_amt, 0) + NVL (n_prem_amt, 0))
            - NVL (n_nbt_prem_amt, 0);
      -- Solve for the premium amount
      i2_ann_prem_amt :=
         (  NVL (i_ann_prem_amt, 0)
          + NVL (v_prem_amt, 0)
          - NVL (n_ann_prem_amt,0)
         );
                              --beth022699NVL(vo_prem_amt,0));
                     -- Solve for the annualized prem amount
   /* Three conditions have to be considered for en- *
    * dorsements :  3 indicates that computation     *
    * should be based with respect to the short rate *
    * percent.                                       */
   ELSE
      --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
      IF ((NVL (n_tsi_amt, 0) = 0) AND (NVL (p_prem_rt, 0) = 0))
      THEN
         v_prem_amt :=
               (NVL (p_prem_amt, 0) / (NVL (p_short_rt_percent, 1) / 100)
               );

         -- Compute for the prorated premium amount using the present premium
         -- as reference when tsi and premium rate are zero.
         IF ((NVL (n_nbt_tsi_amt, 0) = 0) AND (NVL (n_nbt_prem_rt, 0) = 0))
         THEN
            vo_prem_amt := NVL (n_nbt_prem_amt, 0);
         ELSE
            vo_prem_amt :=
                 (NVL (n_nbt_tsi_amt, 0) * NVL (n_nbt_prem_rt, 0) / 100)
               * prov_discount;
                     -- Solve for the previous annualized premium amount
         -- Set another condition if the old tsi and premium rate are zero for
         -- determining the old premium amount.
         END IF;
      -- Set another condition if the old tsi and premium rate are zero.
      ELSE
         p_prem_rt :=
            (  (NVL (p_prem_amt, 0) * 10000)
             / (  NVL (n_tsi_amt, 1)
                * NVL (p_short_rt_percent, 1)
                * prov_discount
               )
            );
         -- Solve for the premium rate
         v_prem_amt :=
                 (NVL (n_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100)
                 * prov_discount;

         -- Solve for the annualized premium amount
         IF ((NVL (n_nbt_tsi_amt, 0) = 0) AND (NVL (n_nbt_prem_rt, 0) = 0))
         THEN
            vo_prem_amt := (NVL (n_nbt_prem_amt, 0));
         ELSE
            vo_prem_amt :=
                 (NVL (n_nbt_tsi_amt, 0) * NVL (n_nbt_prem_rt, 0) / 100)
               * prov_discount;
         -- Solve for the previous annualized premium amount
         END IF;
      -- Set another condition if the old tsi and premium rate are zero.
      END IF;

      --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
      p2_ann_prem_amt :=
         (  NVL (n_ann_prem_amt, 0)
          + NVL (v_prem_amt, 0)
          - NVL (n_ann_prem_amt,0)
         );
               --beth022699NVL(vo_prem_amt,0));
      -- Solve for the annualized prem amount for perils
      i2_prem_amt :=
            (NVL (i_nbt_prem_amt, 0) + NVL (n_prem_amt, 0))
            - NVL (n_nbt_prem_amt, 0);
      -- Solve for the premium amount
      i2_ann_prem_amt :=
         (  NVL (i_ann_prem_amt, 0)
          + NVL (v_prem_amt, 0)
          - NVL (n_ann_prem_amt,0)
         );
            --beth022699NVL(vo_prem_amt,0));
   -- Solve for the annualized prem amount
   END IF;

      --n_prem_rt := NVL (p_prem_rt, 0); -- Commented out by Jerome Bautista 03.14.2016 SR 21369
      n_ann_prem_amt := NVL (p2_ann_prem_amt, 0);
      n_nbt_prem_amt := NVL (i2_prem_amt, 0);
      n_nbt_tsi_amt  := NVL (n_nbt_tsi_amt, 0);
      
EXCEPTION
    WHEN VALUE_ERROR THEN
    p_msg := 'Invalid value for field.';
END;
/


