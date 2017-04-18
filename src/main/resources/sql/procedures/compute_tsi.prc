DROP PROCEDURE CPI.COMPUTE_TSI;

CREATE OR REPLACE PROCEDURE CPI.compute_tsi (
   n_tsi_amt            IN      NUMBER,                              -- b490.tsi_amt
   n_prem_rt            IN      NUMBER,                              -- b490.prem_rt
   n_ann_tsi_amt        IN OUT  NUMBER,                          -- b490.ann_tsi_amt
   n_ann_prem_amt       IN OUT  NUMBER,                         -- b490.ann_prem_amt
   i_tsi_amt            IN      NUMBER,                              -- b480.tsi_amt
   i_prem_amt           IN      NUMBER,                             -- b480.prem_amt
   i_ann_tsi_amt        IN      NUMBER,                          -- b480.ann_tsi_amt
   i_ann_prem_amt       IN      NUMBER,
   n_nbt_tsi_amt        IN      NUMBER,
   n_nbt_prem_rt        IN      NUMBER,
   n_nbt_prem_amt       IN      NUMBER,
   p_prov_prem_pct      IN      NUMBER,
   p_prov_prem_tag      IN      VARCHAR2,
   p_is_gpa             IN      VARCHAR2,
   n_dsp_peril_type     IN OUT  VARCHAR2,
   i_line_cd            IN      VARCHAR2,
   i_subline_cd         IN      VARCHAR2,
   n_peril_cd           IN      VARCHAR2,
   p_validate_sw        IN      VARCHAR2,
   p_old_type           IN      VARCHAR2,
   p_nbt_prorate_flag   IN      VARCHAR2,
   p_endt_expiry_date   IN      DATE,
   p_eff_date           IN      DATE,
   p_expiry_date        IN      DATE,
   p_short_rt_percent   IN      NUMBER,
   v_comp_sw            IN      VARCHAR2,
   n_prem_amt              OUT  NUMBER,
   i_nbt_prem_amt          OUT  NUMBER,
   i_nbt_tsi_amt           OUT  NUMBER,
   p_msg                   OUT  VARCHAR2
)
IS   
    /*
    **  Created by     : Robert Virrey
    **  Date Created   : 04.23.2012
    **  Reference By   : (GIEXS007 - Edit Peril Information)
    **  Description    : compute_tsi program unit
	*/
                                                     -- b480.ann_prem_amt
   /*  GIVEN:    b490.tsi_amt, b490.prem_rt          *
    *  REQD:     b490.prem_amt, b490.ann_tsi_amt     *
    *            b490.ann_prem_amt                   *
    *            b480.tsi_amt, b480.prem_amt         *
    *            b480.ann_tsi_amt, b480.ann_prem_amt */
   var_type          VARCHAR2 (1);
   prov_discount     NUMBER (12, 9)         := NVL (p_prov_prem_pct / 100, 1);
   p_prem_amt        NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
   p2_ann_tsi_amt    NUMBER(20,2); --gipi_witmperl.ann_tsi_amt%TYPE; 
   p2_ann_prem_amt   NUMBER(20,2); --gipi_witmperl.ann_prem_amt%TYPE;
   --n_nbt_tsi_amt        gipi_witmperl.tsi_amt%TYPE:= decode_grp (variables.is_gpa,'Y',:b490_grp.nbt_tsi_amt, :b490.nbt_tsi_amt );
   --n_nbt_prem_amt       gipi_witmperl.prem_amt%TYPE := decode_grp (variables.is_gpa,'Y',:b490_grp.nbt_prem_amt,:b490.nbt_prem_amt);
   --n_nbt_prem_rt        gipi_witmperl.prem_rt%TYPE:= decode_grp (variables.is_gpa,'Y',:b490_grp.nbt_prem_rt,:b490_grp.nbt_prem_rt);
   i2_tsi_amt        gipi_witem.tsi_amt%TYPE;
   i2_prem_amt       NUMBER(20,2); --gipi_witem.prem_amt%TYPE;
   i2_ann_tsi_amt    NUMBER(20,2); --gipi_witem.ann_tsi_amt%TYPE;
   i2_ann_prem_amt   NUMBER(20,2); --gipi_witem.ann_prem_amt%TYPE;
   v_prorate         NUMBER;
   v_prem_amt        NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE; 
   vo_prem_amt       NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
   p_prov_tag        gipi_wpolbas.prov_prem_tag%TYPE;
   po_prov_prem      NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
   v_prov_prem       NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
   p_prov_prem       NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
BEGIN
   /* Special case when there is a prov_discount.
   ***********************************************
   */
   IF NVL (p_prov_prem_tag, 'N') != 'Y'
   THEN
      prov_discount := 1;
   END IF;

   /*
   ************************************************
   */
-- BETH 101598  make sure that the valid peril type will be passed
--              to var_type which is the basis in all the computation
--              in this procedure
   IF p_is_gpa = 'Y'
   THEN
      /* Determine peril type of peril being processed to determine whether
      ** we would consider its tsi amount as part of the tsi computation
      ** in the item level.
      */
      IF n_dsp_peril_type IS NULL
      THEN
         FOR a1 IN (SELECT peril_type
                      FROM giis_peril
                     WHERE line_cd = i_line_cd
                       AND subline_cd IS NULL
                       AND peril_cd = n_peril_cd)
         LOOP
            n_dsp_peril_type := a1.peril_type;
         END LOOP;
      END IF;

      IF p_validate_sw = 'Y'
      THEN
         var_type := NVL (p_old_type, n_dsp_peril_type);
      ELSE
         var_type := n_dsp_peril_type;
      END IF;
   ELSE
      /* Determine peril type of peril being processed to determine whether
      ** we would consider its tsi amount as part of the tsi computation
      ** in the item level.
      */
      IF n_dsp_peril_type IS NULL
      THEN
         FOR a1 IN (SELECT peril_type
                      FROM giis_peril
                     WHERE line_cd = i_line_cd
                       AND (subline_cd = i_subline_cd
                            OR subline_cd IS NULL
                           )
                       AND peril_cd = n_peril_cd)
         LOOP
            n_dsp_peril_type := a1.peril_type;
         END LOOP;
      END IF;

      IF p_validate_sw = 'Y'
      THEN
         var_type := NVL (p_old_type, n_dsp_peril_type);
      ELSE
         var_type := n_dsp_peril_type;
      END IF;
   END IF;

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
         /*beth 021199 change the date from endt_expiry_date to expiry_date
          v_prorate  :=  TRUNC( p_endt_expiry_date - p_eff_date ) /
                               (ADD_MONTHS(p_eff_date,12) - p_eff_date);*/
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
      v_prem_amt :=
                 (NVL (n_tsi_amt, 0) * NVL (n_prem_rt, 0) / 100)
                 * prov_discount;

      -- Solve for the annualized premium amount

      --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
      IF ((NVL (n_nbt_tsi_amt, 0) = 0) AND (NVL (n_nbt_prem_rt, 0) = 0))
      THEN
         vo_prem_amt := NVL (n_nbt_prem_amt, 0);
      ELSE
         vo_prem_amt := NVL (n_nbt_prem_amt, 0);
      -- vo_prem_amt:=  (NVL(n_nbt_tsi_amt,0) * NVL(n_nbt_prem_rt,0)/100 ) * prov_discount;
                -- Solve for the old annualized premium amount
      END IF;

      --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
      p_prem_amt :=
           ((NVL (n_tsi_amt, 0) * NVL (n_prem_rt, 0)) / 100) 
         * v_prorate
         * prov_discount;
      -- Solve for the premium amount (prorated value) for perils
      p2_ann_tsi_amt :=
            (NVL (n_ann_tsi_amt, 0) + NVL (n_tsi_amt, 0) - NVL (n_nbt_tsi_amt, 0)
            );
      -- Solve for the annualized tsi amount for perils
      p2_ann_prem_amt :=
         (  NVL (n_ann_prem_amt, 0)
          + NVL (v_prem_amt, 0)
          - NVL (n_ann_prem_amt, 0)
         );
               --beth 022699 NVL(vo_prem_amt,0));
      -- Solve for the annualized prem amount for perils
      i2_prem_amt :=
             (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0))
             - NVL (n_nbt_prem_amt, 0);
      -- Solve for the premium amount
      i2_ann_prem_amt :=
         (  NVL (i_ann_prem_amt, 0)
          + NVL (v_prem_amt, 0)
          - NVL (n_ann_prem_amt, 0)
         );

                              --beth 022699NVL(vo_prem_amt,0));
                     -- Solve for the annualized prem amount
       -- add tsi amount of items when peril type of peril is equal to 'B'
--       IF n_dsp_peril_type = 'B' THEN
      IF var_type = 'B'
      THEN
         i2_tsi_amt :=
               (NVL (i_tsi_amt, 0) + NVL (n_tsi_amt, 0))
               - NVL (n_nbt_tsi_amt, 0);
         -- Solve for the tsi amt for items
         i2_ann_tsi_amt :=
              (NVL (i_ann_tsi_amt, 0) + NVL (n_tsi_amt, 0))
            - NVL (n_nbt_tsi_amt, 0);
      -- Solve for the annualized tsi amount
      END IF;
   /* Three conditions have to be considered for en- *
    * dorsements :  2 indicates that computation     *
    * should be based on a one year span.            */
   ELSIF p_nbt_prorate_flag = 2
   THEN
      v_prem_amt :=
                (NVL (n_tsi_amt, 0) * NVL (n_prem_rt, 0) / 100)
                * prov_discount;

      -- Solve for the annualized premium amount

      --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
      IF ((NVL (n_nbt_tsi_amt, 0) = 0) AND (NVL (n_nbt_prem_rt, 0) = 0))
      THEN
         vo_prem_amt := (NVL (n_nbt_prem_amt, 0));
      ELSE
         vo_prem_amt := (NVL (n_nbt_prem_amt, 0));
      -- vo_prem_amt:=  (NVL(n_nbt_tsi_amt,0) * NVL(n_nbt_prem_rt,0) / 100) * prov_discount;
                -- Solve for the old annualized premium amount
      END IF;

      --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
      p_prem_amt :=
                 (NVL (n_tsi_amt, 0) * NVL (n_prem_rt, 0) / 100)
                 * prov_discount;
      -- Solve for the premium amount (for one year) for perils
      p2_ann_tsi_amt :=
            (NVL (n_ann_tsi_amt, 0) + NVL (n_tsi_amt, 0) - NVL (n_nbt_tsi_amt, 0)
            );
      -- Solve for the annualized tsi amount for perils
      p2_ann_prem_amt :=
         (NVL (n_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0)
         );
      -- Solve for the annualized prem amount for perils
      i2_prem_amt :=
             (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0))
             - NVL (n_nbt_prem_amt, 0);
      -- Solve for the premium amount
      i2_ann_prem_amt :=
         (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0)
         );

                     -- Solve for the annualized prem amount
--       IF n_dsp_peril_type  = 'B' THEN
      IF var_type = 'B'
      THEN
         i2_tsi_amt :=
               (NVL (i_tsi_amt, 0) + NVL (n_tsi_amt, 0))
               - NVL (n_nbt_tsi_amt, 0);
         -- Solve for the tsi amt for items
         i2_ann_tsi_amt :=
              (NVL (i_ann_tsi_amt, 0) + NVL (n_tsi_amt, 0))
            - NVL (n_nbt_tsi_amt, 0);
      -- Solve for the annualized tsi amount
      END IF;
   /* Three conditions have to be considered for en- *
    * dorsements :  3 indicates that computation     *
    * should be based with respect to the short rate *
    * percent.                                       */
   ELSE
      v_prem_amt :=
                (NVL (n_tsi_amt, 0) * NVL (n_prem_rt, 0) / 100)
                * prov_discount;

                    -- Solve for the annualized premium amount
      --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
      IF ((NVL (n_nbt_tsi_amt, 0) = 0) AND (NVL (n_nbt_prem_rt, 0) = 0))
      THEN
         vo_prem_amt := (NVL (n_nbt_prem_amt, 0));
      ELSE
         vo_prem_amt := (NVL (n_nbt_prem_amt, 0));
      -- vo_prem_amt:=  (NVL(n_nbt_tsi_amt,0) * NVL(n_nbt_prem_rt,0)/100 ) * prov_discount;
                -- Solve for the old annualized premium amount
      END IF;

      --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
      p_prem_amt :=
           (  ((  NVL (n_prem_rt, 0)
                * NVL (n_tsi_amt, 0)
                * NVL (p_short_rt_percent, 0)
               )
              )
            / 10000
           )
         * prov_discount;
      -- Solve for the premium amount (short rate) for perils
      p2_ann_tsi_amt :=
            (NVL (n_ann_tsi_amt, 0) + NVL (n_tsi_amt, 0) - NVL (n_nbt_tsi_amt, 0)
            );
      -- Solve for the annualized tsi amount for perils
      p2_ann_prem_amt :=
         (NVL (n_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (n_nbt_prem_amt, 0)
         );
      -- Solve for the annualized prem amount for perils
      i2_prem_amt :=
             (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0))
             - NVL (n_nbt_prem_amt, 0);
      -- Solve for the premium amount
      i2_ann_prem_amt :=
         (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0)
         );

                      -- Solve for the annualized prem amount
      --  IF n_dsp_peril_type  =  'B' THEN
      IF var_type = 'B'
      THEN
         i2_tsi_amt :=
               (NVL (i_tsi_amt, 0) + NVL (n_tsi_amt, 0))
               - NVL (n_nbt_tsi_amt, 0);
         -- Solve for the tsi amt for items
         i2_ann_tsi_amt :=
              (NVL (i_ann_tsi_amt, 0) + NVL (n_tsi_amt, 0))
            - NVL (n_nbt_tsi_amt, 0);
      -- Solve for the annualized tsi amount
      END IF;
   END IF;

--MSG_ALERT(TO_CHAR(:B490.ANN_PREM_AMT),'I',FALSE);
--   IF variables.is_gpa = 'Y'
--   THEN
      n_prem_amt := p_prem_amt;
      n_ann_prem_amt := p2_ann_prem_amt;
      n_ann_tsi_amt := p2_ann_tsi_amt;
      i_nbt_prem_amt := i2_prem_amt;

      IF n_dsp_peril_type = 'B'
      THEN
         -- IF var_type = 'B' THEN
         i_nbt_tsi_amt := i2_tsi_amt;
      END IF;
--   ELSE
--      :b490.prem_amt := p_prem_amt;
--      :b490.ann_prem_amt := p2_ann_prem_amt;
--      :b490.ann_tsi_amt := p2_ann_tsi_amt;-
--      :b480.nbt_prem_amt := i2_prem_amt;

--      IF n_dsp_peril_type = 'B'
--      THEN
--         -- IF var_type = 'B' THEN
--         :b480.nbt_tsi_amt := i2_tsi_amt;
--      END IF;
--   END IF;

--EXCEPTION
--    WHEN VALUE_ERROR THEN
--    p_msg := 'Invalid value for field.';
END;
/


