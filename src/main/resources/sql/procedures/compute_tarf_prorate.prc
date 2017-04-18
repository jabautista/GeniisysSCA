DROP PROCEDURE CPI.COMPUTE_TARF_PRORATE;

CREATE OR REPLACE PROCEDURE CPI.COMPUTE_TARF_PRORATE (p_tsi_amt      IN NUMBER,     -- b490.tsi_amt
                                     p_prem_rt      IN NUMBER,     -- b490.prem_rt
                                     p_ann_tsi_amt  IN NUMBER,     -- b490.ann_tsi_amt
                                     p_ann_prem_amt IN NUMBER,     -- b490.ann_prem_amt
                                     i_tsi_amt      IN NUMBER,     -- b480.tsi_amt
                                     i_prem_amt     IN NUMBER,     -- b480.prem_amt
                                     i_ann_tsi_amt  IN NUMBER,     -- b480.ann_tsi_amt
                                     i_ann_prem_amt IN NUMBER,
                                     p_tariff_cd    IN NUMBER,
                                     default_tag    IN VARCHAR2,
                                     default_prem   IN NUMBER,
                                     pe_prem_amt    IN NUMBER,
                                     p_peril_cd        IN NUMBER,
                                     p_par_id        IN GIPI_PARLIST.par_id%TYPE,
                                     v_peril_prem_amt     OUT NUMBER,
                                     v_peril_ann_prem_amt OUT NUMBER,
                                     v_peril_ann_tsi_amt  OUT NUMBER,
                                     v_item_prem_amt      OUT NUMBER,
                                     v_item_ann_prem_amt  OUT NUMBER,
                                     v_item_tsi_amt          OUT NUMBER,
                                     v_item_ann_tsi_amt      OUT NUMBER) IS

   /*  GIVEN:    b490.tsi_amt, b490.prem_rt          *
    *  REQD:     b490.prem_amt, b490.ann_tsi_amt     *
    *            b490.ann_prem_amt                   *
    *            b480.tsi_amt, b480.prem_amt         *
    *            b480.ann_tsi_amt, b480.ann_prem_amt */

        var_type          VARCHAR2(1);

      p_prem_amt        GIPI_WITMPERL.prem_amt%TYPE;       -- supposed value of b490.prem_amt

      p2_ann_tsi_amt    GIPI_WITMPERL.ann_tsi_amt%TYPE;    -- supposed value of b490.ann_tsi_amt
      p2_ann_prem_amt   GIPI_WITMPERL.ann_prem_amt%TYPE;   -- supposed value of b490.ann_prem_amt

      po_tsi_amt        GIPI_WITMPERL.tsi_amt%TYPE   :=  p_tsi_amt;
      po_prem_amt       GIPI_WITMPERL.prem_amt%TYPE  :=  pe_prem_amt;
      po_prem_rt        GIPI_WITMPERL.prem_rt%TYPE   :=  p_prem_rt;

      i2_tsi_amt        GIPI_WITEM.tsi_amt%TYPE;            -- supposed value of b480.tsi_amt
      i2_prem_amt       GIPI_WITEM.prem_amt%TYPE;           -- supposed value of b480.prem_amt
      i2_ann_tsi_amt    GIPI_WITEM.ann_tsi_amt%TYPE;        -- supposed value of b480.ann_tsi_amt
      i2_ann_prem_amt   GIPI_WITEM.ann_prem_amt%TYPE;       -- supposed value of b480.ann_prem_amt

      v_prem_amt        GIPI_WITMPERL.prem_amt%TYPE;
      vo_prem_amt       GIPI_WITMPERL.prem_amt%TYPE;

      v_peril_type        GIIS_PERIL.PERIL_TYPE%TYPE;

      v_prorate                NUMBER;
      v_test                NUMBER;
      v_prorate_flag        GIPI_WPOLBAS.prorate_flag%TYPE;
      v_expiry_date            GIPI_WPOLBAS.EXPIRY_DATE%TYPE;
      v_eff_date            GIPI_WPOLBAS.EFF_DATE%TYPE;
      v_comp_sw                GIPI_WPOLBAS.comp_sw%TYPE;
      v_short_rt_percent    GIPI_WPOLBAS.SHORT_RT_PERCENT%TYPE;

BEGIN
   /*IF :b490.dsp_peril_type IS NULL THEN
     FOR A1 IN (
         SELECT   peril_type
           FROM   giis_peril
          WHERE   line_cd    = :b240.line_cd
            AND  (subline_cd = :b240.nbt_subline_cd OR
                  subline_cd IS NULL)
            AND   peril_cd   = :b490.peril_cd) LOOP
            :b490.dsp_peril_type :=  A1.peril_type;
      END LOOP;
   END IF;
*/

-- BETH 101598  make sure that the valid peril type will be passed
--              to var_type which is the basis in all the computation
--              in this procedure
  /*IF :parameter.validate_sw  = 'Y' THEN
        var_type := nvl(:parameter.old_type,:b490.dsp_peril_type);
  ELSE
    var_type := :b490.dsp_peril_type;
  END IF;
  */
  BEGIN
    SELECT peril_type
      INTO v_peril_type
      FROM GIIS_PERIL
     WHERE peril_cd = p_peril_cd
	   AND line_cd = (SELECT line_cd FROM GIPI_PARLIST WHERE par_id = p_par_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;

  IF default_tag = '1' THEN
     v_prem_amt := default_prem;
  ELSIF default_tag = '2' THEN
       FOR AMT IN
           ( SELECT NVL(fixed_premium,0) fix, NVL(si_deductible,0) deduct, NVL(excess_rate,0) excess,
                    NVL(loading_rate,0) load, NVL(discount_rate ,0) discount, NVL(additional_premium,0) add_prem
               FROM giis_tariff_rates_dtl
               WHERE tariff_cd = p_tariff_cd
            ) LOOP
            v_prem_amt := ( (amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess/100))) +
                         ((amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess/100))) * (amt.load/100))) -
                       ( ( (amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess/100))) +
                         ((amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess/100))) * (amt.load/100))) * (amt.discount/100)) +
                       amt.add_prem;
     END LOOP;
  ELSIF default_tag = '3' THEN
        FOR AMT IN
            ( SELECT NVL(fixed_premium,0) fixed
                FROM giis_tariff_rates_dtl
               WHERE tariff_cd = p_tariff_cd
            ) LOOP
            v_prem_amt := amt.fixed;
        END LOOP;
  END IF;

  BEGIN
    SELECT prorate_flag, expiry_date, eff_date, NVL(comp_sw, 'N'), short_rt_percent --added by Gzelle 11272014 (short_rt_percent)
      INTO v_prorate_flag, v_expiry_date, v_eff_date, v_comp_sw, v_short_rt_percent --added by Gzelle 11272014 (v_short_rt_percent)
      FROM GIPI_WPOLBAS
     WHERE par_id = p_par_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;

   IF v_prorate_flag = '1' THEN
      --if +1 is chosen
      IF v_comp_sw = 'Y' THEN
          v_prorate  :=  ((TRUNC( v_expiry_date) - TRUNC(v_eff_date )) + 1)/
                          check_duration(v_eff_date, v_expiry_date);
     --if -1 is chosen
     ELSIF v_comp_sw = 'M' THEN
          v_prorate  :=  ((TRUNC( v_expiry_date) - TRUNC(v_eff_date )) - 1)/
                           check_duration(v_eff_date, v_expiry_date);
     --if original
     ELSE
          v_prorate  :=  (TRUNC( v_expiry_date) - TRUNC(v_eff_date ) )/
                           check_duration(v_eff_date, v_expiry_date);
     END IF;
   END IF;
   --message ('prem_Amt='||v_prem_amt);message ('prem_Amt='||v_prem_amt);
   --v_test := check_duration (:b240.eff_date, :b240.expiry_date);
   --message ('duration='||v_test);message ('duration='||v_test);
   --message ('days='||v_prorate);message ('days='||v_prorate);

        --computation for the premium (v_prem_amt = default prem in default peril rate)
        IF v_prorate_flag = '1' THEN
            v_peril_prem_amt     :=  (v_prem_amt*nvl(v_prorate,1));
       --straight
       ELSIF v_prorate_flag = '2' THEN
           v_peril_prem_amt     :=  v_prem_amt;
       --short-rate
       ELSIF v_prorate_flag = '3' THEN
           v_peril_prem_amt     :=  (v_prem_amt*(nvl(v_short_rt_percent,1)/100));
       END IF;

       IF NVL(v_prem_amt,0) > NVL(p_tsi_amt,0) THEN
          v_prem_amt := 0;
    END IF;

       vo_prem_amt:=  (NVL(po_prem_amt,0));

       --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
       p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  -
                              NVL(po_tsi_amt,0));
                     -- Solve for the annualized tsi amount for perils
       p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                              NVL(vo_prem_amt,0));
                     -- Solve for the annualized prem amount for perils

       /*i2_prem_amt := (NVL(i_prem_amt,0) + NVL(v_prem_amt,0)) -
                              NVL(po_prem_amt,0);*/
       i2_prem_amt := (NVL(i_prem_amt,0) + NVL(pe_prem_amt,0)) -
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
       --message ('b40prem_Amt='||v_prem_amt);message ('b40prem_Amt='||v_prem_amt);
       v_peril_ann_prem_amt :=  p2_ann_prem_amt;
       v_peril_ann_tsi_amt  :=  p2_ann_tsi_amt;

       v_item_prem_amt     :=  i2_prem_amt;
       v_item_ann_prem_amt :=  i2_ann_prem_amt;

       IF var_type = 'B' THEN
     v_item_tsi_amt      :=  i2_tsi_amt;
     v_item_ann_tsi_amt  :=  i2_ann_tsi_amt;
       END IF;

END COMPUTE_TARF_PRORATE;
/


