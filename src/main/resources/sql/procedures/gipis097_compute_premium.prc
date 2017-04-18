DROP PROCEDURE CPI.GIPIS097_COMPUTE_PREMIUM;

CREATE OR REPLACE PROCEDURE CPI.gipis097_compute_premium (
   p_par_id             IN       gipi_witmperl.par_id%TYPE,
   p_item_no            IN       gipi_witem.item_no%TYPE,
   p_peril_cd           IN       gipi_witmperl.peril_cd%TYPE,
   p_prem_amt           IN       NUMBER, --gipi_witmperl.prem_amt%TYPE,
   p_tsi_amt            IN       NUMBER,                                                                           -- b490.tsi_amt
   p_ann_prem_amt       IN       NUMBER,                                                                      -- b490.ann_prem_amt
   p_ann_tsi_amt        IN       NUMBER,                                                                      -- b490.ann_prem_amt
   i_prem_amt           IN       NUMBER,
   i_ann_prem_amt       IN       NUMBER,
   p_changed_tag        IN       gipi_witem.changed_tag%TYPE,
   p_to_date            IN       VARCHAR2,                                                              --gipi_witem.TO_DATE%TYPE,
   p_from_date          IN       VARCHAR2,                                                            --gipi_witem.from_date%TYPE,
   p_short_rt_percent   IN       gipi_witem.short_rt_percent%TYPE,
   p_prorate_flag       IN       gipi_witem.prorate_flag%TYPE,
   p_ri_comm_rate       IN       gipi_witmperl.ri_comm_rate%TYPE,
   p_ri_comm_amt        OUT      gipi_witmperl.ri_comm_amt%TYPE,
   p_out_ann_prem_amt   OUT      NUMBER, --gipi_witmperl.ann_prem_amt%TYPE,
   p_base_ann_prem_amt   OUT      NUMBER,
   p_out_prem_rt        OUT      NUMBER, -- gipi_witmperl.prem_rt%TYPE
   p_item_prem_amt      OUT      NUMBER,
   p_item_ann_prem_amt  OUT      NUMBER
)
IS                                                                                                            -- b480.ann_prem_amt
     /*  GIVEN:    b490.prem_amt, b490.tsi_amt         *
      *  REQD:     b490.prem_amt,b490.ann_prem_amt,    *
      *            b490.prem_rt,b480.ann_prem_amt,     *
      *            b480.prem_amt                       */
   --  p_prem_amt           NUMBER (15, 5)                       := px_prem_amt;     --GIPI_WITMPERl.prem_amt%TYPE   :=  px_prem_amt;
   p_prem_rt            NUMBER(20, 9); --gipi_witmperl.prem_rt%TYPE;                                             -- supposed value of b490.prem_rt
   p2_ann_tsi_amt       NUMBER(18, 2); --gipi_witmperl.ann_tsi_amt%TYPE;                                     -- supposed value of b490.ann_tsi_amt
   p2_ann_prem_amt      NUMBER(18, 2); --gipi_witmperl.ann_prem_amt%TYPE;                                   -- supposed value of b490.ann_prem_amt
   po_tsi_amt           NUMBER(18, 2); --gipi_witmperl.tsi_amt%TYPE;                                               --        := :b490.nbt_tsi_amt;
   po_prem_amt          NUMBER (15, 5);                                              --                    := :b490.nbt_prem_amt;
   --GIPI_WITMPERL.prem_amt%TYPE  :=  :b490.nbt_prem_amt;
   po_prem_rt           gipi_witmperl.prem_rt%TYPE;                                               --        := :b490.nbt_prem_rt;
   i2_tsi_amt           NUMBER(18, 2);--gipi_witem.tsi_amt%TYPE;                                                -- supposed value of b480.tsi_amt
   i2_prem_amt          NUMBER (20, 9);                  --GIPI_WITEM.prem_amt%TYPE;           -- supposed value of b480.prem_amt
   i2_ann_tsi_amt       NUMBER(18, 2);--gipi_witem.ann_tsi_amt%TYPE;                                        -- supposed value of b480.ann_tsi_amt
   i2_ann_prem_amt      NUMBER(18, 2);--gipi_witem.ann_prem_amt%TYPE;                                      -- supposed value of b480.ann_prem_amt
   v_prorate            NUMBER;
   v_prem_amt           NUMBER (15, 2);                                                            --GIPI_WITMPERL.prem_amt%TYPE;
   vo_prem_amt          NUMBER (15, 5);                                                            --GIPI_WITMPERL.prem_amt%TYPE;
   p_prov_prem          NUMBER (15, 5);                                                            --GIPI_WITMPERL.prem_amt%TYPE;
   po_prov_prem         NUMBER (15, 5);                                                            --GIPI_WITMPERL.prem_amt%TYPE;
   prov_discount        NUMBER (12, 9);                               --                       := NVL (p_prov_prem_pct / 100, 1);
   --bdarusin, 02202002
   v_prorate_prem       NUMBER (15, 5);                   --GIPI_WITMPERL.prem_amt%TYPE;  --variable for computed negated premium
   v_no_of_days         NUMBER;                                                                                                 --
   v_days_of_policy     NUMBER;                                                                                                 --
   v_comp_sw            gipi_wpolbas.comp_sw%TYPE;
   v_prorate_flag       gipi_wpolbas.prorate_flag%TYPE;
   v_eff_date           gipi_wpolbas.eff_date%TYPE;
   v_endt_expiry_date   gipi_wpolbas.endt_expiry_date%TYPE;
   v_incept_date        gipi_wpolbas.incept_date%TYPE;
   v_expiry_date        gipi_wpolbas.expiry_date%TYPE;
   var_expiry_date      gipi_wpolbas.expiry_date%TYPE;
   v_line_cd            gipi_wpolbas.line_cd%TYPE;
   v_subline_cd         gipi_wpolbas.subline_cd%TYPE;
   v_iss_cd             gipi_wpolbas.iss_cd%TYPE;
   v_issue_yy           gipi_wpolbas.issue_yy%TYPE;
   v_pol_seq_no         gipi_wpolbas.pol_seq_no%TYPE;
   v_renew_no           gipi_wpolbas.renew_no%TYPE;
   v_prov_prem_pct      gipi_wpolbas.prov_prem_pct%TYPE;
   v_prov_prem_tag      gipi_wpolbas.prov_prem_tag%TYPE;
   v_short_rt_percent   gipi_wpolbas.short_rt_percent%TYPE;
BEGIN
   var_expiry_date := extract_expiry (p_par_id);

   SELECT comp_sw, prorate_flag, eff_date, endt_expiry_date, incept_date, expiry_date, line_cd, subline_cd,
          iss_cd, pol_seq_no, issue_yy, renew_no, prov_prem_pct, prov_prem_tag, short_rt_percent
     INTO v_comp_sw, v_prorate_flag, v_eff_date, v_endt_expiry_date, v_incept_date, v_expiry_date, v_line_cd, v_subline_cd,
          v_iss_cd, v_pol_seq_no, v_issue_yy, v_renew_no, v_prov_prem_pct, v_prov_prem_tag, v_short_rt_percent
     FROM gipi_wpolbas
    WHERE par_id = p_par_id;

   prov_discount := NVL (v_prov_prem_pct / 100, 1);
   /* Special case where there is a prov_discount.
   ***********************************************
   */
   p_prov_prem := NVL (p_prem_amt, 0);
   po_prov_prem := NVL (po_prem_amt, 0);

   IF NVL (v_prov_prem_tag, 'N') != 'Y'
   THEN
      prov_discount := 1;
   END IF;

/*
************************************************
*/
   IF NVL (p_changed_tag, 'N') = 'Y'
   THEN
      /* Three conditions have to be considered for en- *
       * dorsements :  1 indicates that computation     *
       * should be prorated.                            */
      IF p_prorate_flag = 1
      THEN
         IF TO_DATE (p_to_date, 'MM-DD-YYYY') <= TO_DATE (p_from_date, 'MM-DD-YYYY')
         THEN
            raise_application_error
                        (-20001,
                         'Geniisys Exception#E#Your item TO DATE is equal to or less than your FROM DATE.  Restricted condition.'
                        );
         ELSE
            /*By Iris Bordey 08.26.2003
            **Removed add_months operation for computaton of premium.  Replaced
            **it instead of variables.v_days (see check_duration) for short term endt.
            */
            --check_duration(TRUNC(p_from_date),ADD_MONTHS(TRUNC(p_from_date),12));
            IF v_comp_sw = 'Y'
            THEN
               v_prorate :=
                    ((TRUNC (TO_DATE (p_to_date, 'MM-DD-YYYY')) - TRUNC (TO_DATE (p_from_date, 'MM-DD-YYYY'))) + 1)
                  / check_duration (TRUNC (TO_DATE (p_from_date, 'MM-DD-YYYY')), TRUNC (TO_DATE (p_to_date, 'MM-DD-YYYY')));
            --(ADD_MONTHS(TRUNC(p_from_date),12) - TRUNC(p_from_date));
            ELSIF v_comp_sw = 'M'
            THEN
               v_prorate :=
                    ((TRUNC (TO_DATE (p_to_date, 'MM-DD-YYYY')) - TRUNC (v_eff_date)) - 1)
                  / check_duration (TRUNC (TO_DATE (p_from_date, 'MM-DD-YYYY')), TRUNC (TO_DATE (p_to_date, 'MM-DD-YYYY')));
            --(ADD_MONTHS(TRUNC(p_from_date),12) - TRUNC(p_from_date));
            ELSE
               v_prorate :=
                    (TRUNC (TO_DATE (p_to_date, 'MM-DD-YYYY')) - TRUNC (v_eff_date))
                  / check_duration (TRUNC (TO_DATE (p_from_date, 'MM-DD-YYYY')), TRUNC (TO_DATE (p_to_date, 'MM-DD-YYYY')));
            --(ADD_MONTHS(TRUNC(p_from_date),12) - TRUNC(p_from_date));
            END IF;
         END IF;

                         -- Solve for the prorate period
         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         IF ((NVL (p_tsi_amt, 0) = 0) AND (NVL (p_prem_rt, 0) = 0))
         THEN
            v_prem_amt := (NVL (p_prem_amt, 0) / v_prorate);

            -- Compute for the prorated premium amount using the present premium
            -- as reference when tsi and premium rate are zero.
            IF ((NVL (po_tsi_amt, 0) = 0) AND (NVL (po_prem_rt, 0) = 0))
            THEN
               vo_prem_amt := (NVL (po_prem_amt, 0) / v_prorate);
            ELSE
               vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
                      -- Solve for the previous annualized premium amount
            -- Set another condition if the old tsi and premium rate are zero for
            -- determining the old premium amount.
            END IF;
         -- Set another condition if the old tsi and premium rate are zero.
         ELSIF (NVL (p_tsi_amt, 0) != 0)
         THEN
            p_prem_rt := ((NVL (p_prem_amt, 0) / NVL (p_tsi_amt, 0)) * 100) / (v_prorate * prov_discount);
            -- Solve for the premium rate
            v_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

            -- Solve for the annualized premium amount
            IF ((NVL (po_tsi_amt, 0) = 0) AND (NVL (po_prem_rt, 0) = 0))
            THEN
               vo_prem_amt := (NVL (po_prem_amt, 0) / v_prorate);
            ELSE
               vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
            -- Solve for the previous annualized premium amount
            END IF;
         -- Set another condition if the old tsi and premium rate are zero.
         END IF;

         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
         -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0)) - NVL (po_prem_amt, 0);
         -- Solve for the premium amount
         i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
      -- Solve for the annualized prem amount

      /* Three conditions have to be considered for     *
       * endorsements :  2 indicates that computation   *
       * should be based on a one year span.            */
      ELSIF p_prorate_flag = 2
      THEN
         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         IF ((NVL (p_tsi_amt, 0) = 0) AND (NVL (p_prem_rt, 0) = 0))
         THEN
            v_prem_amt := (NVL (p_prem_amt, 0));

            -- Compute for the prorated premium amount using the present premium
            -- as reference when tsi and premium rate are zero.
            IF ((NVL (po_tsi_amt, 0) = 0) AND (NVL (po_prem_rt, 0) = 0))
            THEN
               vo_prem_amt := NVL (po_prem_amt, 0);
            ELSE
               vo_prem_amt := NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100 * prov_discount;
                       -- Solve for the previous annualized premium amount
            -- Set another condition if the old tsi and premium rate are zero for
            -- determining of old tsi and premium.
            END IF;
         -- Set another condition if the old tsi and premium rate are zero.
         ELSIF (NVL (p_tsi_amt, 0) != 0)
         THEN
            p_prem_rt := ((NVL (p_prem_amt, 0) / NVL (p_tsi_amt, 0)) * 100) / prov_discount;
            -- Solve for the premium rate
            v_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

            -- Solve for the annualized premium amount
            IF ((NVL (po_tsi_amt, 0) = 0) AND (NVL (po_prem_rt, 0) = 0))
            THEN
               vo_prem_amt := (NVL (po_prem_amt, 0));
            ELSE
               vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
            -- Solve for the previous annualized premium amount
            END IF;
         -- Set another condition if the old tsi and premium rate are zero.
         END IF;

         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
         -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0)) - NVL (po_prem_amt, 0);
         -- Solve for the premium amount
         i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
                          -- Solve for the annualized prem amount
   
       /* Three conditions have to be considered for en- *
        * dorsements :  3 indicates that computation     *
        * should be based with respect to the short rate *
        * percent.                                       */
       ELSIF v_prorate_flag = 3 THEN
         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
          IF ((NVL(p_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
             v_prem_amt :=  (NVL(p_prem_amt,0) / (NVL(v_short_rt_percent,1)/100));
              -- Compute for the prorated premium amount using the present premium
              -- as reference when tsi and premium rate are zero.
             IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
                vo_prem_amt:= NVL(po_prem_amt,0)/ (NVL(p_short_rt_percent,1)/100);
             ELSE
                vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                            -- Solve for the previous annualized premium amount
               -- Set another condition if the old tsi and premium rate are zero for 
               -- determining the old premium amount.
             END IF;
             -- Set another condition if the old tsi and premium rate are zero.
          ELSIF (NVL(p_tsi_amt,0) != 0) THEN
             p_prem_rt  :=  ((NVL(p_prem_amt,0) * 10000) /
                             (NVL(p_tsi_amt,1) * NVL(v_short_rt_percent,1) * prov_discount));
                          -- Solve for the premium rate
             v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                          -- Solve for the annualized premium amount
             IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
                vo_prem_amt:=  (NVL(po_prem_amt,0)/ (NVL(v_short_rt_percent,1)/100));
             ELSE
                vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                           -- Solve for the previous annualized premium amount
             END IF;
             -- Set another condition if the old tsi and premium rate are zero.
          END IF;
         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
          p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                             NVL(vo_prem_amt,0)); 
                           -- Solve for the annualized prem amount for perils
          i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                             NVL(po_prem_amt,0);
                         -- Solve for the premium amount
          i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                            NVL(vo_prem_amt,0));
                         -- Solve for the annualized prem amount
       
       
       /* Three conditions have to be considered for        *
        * endorsements :  2 indicates that computation      *
        * should be based on a one year span. default value */
       ELSE    
         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
          IF ((NVL(p_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
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
          ELSIF (NVL(p_tsi_amt,0) != 0)  THEN
              p_prem_rt  :=  ((NVL(p_prem_amt,0) / NVL(p_tsi_amt,0)) * 100) / prov_discount;
                          -- Solve for the premium rate
             v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 )  * prov_discount;
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
    
          p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                             NVL(vo_prem_amt,0)); 
                          -- Solve for the annualized prem amount for perils
          i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                             NVL(po_prem_amt,0);
                          -- Solve for the premium amount
          i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                             NVL(vo_prem_amt,0));
                          -- Solve for the annualized prem amount
       
       END IF;
   ELSE
/*bdarusin, feb032003, end of added codes*/
  /* Three conditions have to be considered for en- *
   * dorsements :  1 indicates that computation     *
   * should be prorated.                            */
      IF v_prorate_flag = 1
      THEN
         IF v_endt_expiry_date <= v_eff_date
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.'
               );
         ELSE
             /*beth 021199
             v_prorate  :=  TRUNC( v_endt_expiry_date - v_eff_date ) /
                                  (ADD_MONTHS(v_eff_date,12) - v_eff_date);*/
            /*bdarusin, jan282003, if policy is prorate, and item has its own effectivity,
              compute based on item effectivity*/
              /*By Iris Bordey 08.26.2003
              **Removed add_months operation for computaton of premium.  Replaced
              **it instead of variables.v_days (see check_duration) for short term endt.
              */
              --check_duration(v_incept_date, ADD_MONTHS(v_incept_date,12));
            IF NVL (p_changed_tag, 'N') = 'Y'
            THEN
               v_prorate :=
                    (TRUNC (TO_DATE (p_to_date, 'MM-DD-YYYY')) - TRUNC (TO_DATE (p_from_date, 'MM-DD-YYYY')))
                  / check_duration (v_incept_date, v_expiry_date);
            --(ADD_MONTHS(v_incept_date,12) - v_incept_date);
            ELSE
               IF v_comp_sw = 'Y'
               THEN
                  v_prorate :=
                           ((TRUNC (v_endt_expiry_date) - TRUNC (v_eff_date)) + 1)
                           / check_duration (v_incept_date, v_expiry_date);
               --(ADD_MONTHS(TRUNC(v_incept_date),12) - TRUNC(v_incept_date));
               ELSIF v_comp_sw = 'M'
               THEN
                  v_prorate :=
                           ((TRUNC (v_endt_expiry_date) - TRUNC (v_eff_date)) - 1)
                           / check_duration (v_incept_date, v_expiry_date);
               --(ADD_MONTHS(TRUNC(v_incept_date),12) - TRUNC(v_incept_date));
               ELSE
                  v_prorate := (TRUNC (v_endt_expiry_date) - TRUNC (v_eff_date)) /
                                                                                  --variables.v_days;--(ADD_MONTHS(TRUNC(v_incept_date),12) - TRUNC(v_incept_date));
                                                                                  check_duration (v_incept_date, v_expiry_date);
               END IF;
            END IF;
         END IF;

         -- Solve for the prorate period

         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         IF ((NVL (p_tsi_amt, 0) = 0) AND (NVL (p_prem_rt, 0) = 0))
         THEN
            v_prem_amt := (NVL (p_prem_amt, 0) / v_prorate);

            -- Compute for the prorated premium amount using the present premium
            -- as reference when tsi and premium rate are zero.
            IF ((NVL (po_tsi_amt, 0) = 0) AND (NVL (po_prem_rt, 0) = 0))
            THEN
               vo_prem_amt := (NVL (po_prem_amt, 0) / v_prorate);
            ELSE
               vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
                      -- Solve for the previous annualized premium amount
            -- Set another condition if the old tsi and premium rate are zero for
            -- determining the old premium amount.
            END IF;
         -- Set another condition if the old tsi and premium rate are zero.
         ELSIF (NVL (p_tsi_amt, 0) != 0)
         THEN
            p_prem_rt := ((NVL (p_prem_amt, 0) / NVL (p_tsi_amt, 0)) * 100) / (v_prorate * prov_discount);
            -- Solve for the premium rate
            v_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

            -- Solve for the annualized premium amount
            IF ((NVL (po_tsi_amt, 0) = 0) AND (NVL (po_prem_rt, 0) = 0))
            THEN
               vo_prem_amt := (NVL (po_prem_amt, 0) / v_prorate);
            ELSE
               vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
            -- Solve for the previous annualized premium amount
            END IF;
         -- Set another condition if the old tsi and premium rate are zero.
         END IF;

         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
         -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0)) - NVL (po_prem_amt, 0);
         -- Solve for the premium amount
         i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));

                         -- Solve for the annualized prem amount
         -- added by bdarusin
         -- on feb 20, 2002
         -- to compute for the negated premium which will be compared to the prem amt entered by the user
         -- based on the create_negated_records_prorate procedure of gipis031
         FOR a2 IN (SELECT b380.peril_cd peril, b380.prem_amt prem, b380.tsi_amt tsi, b380.ri_comm_amt comm, b380.prem_rt rate,
                           NVL (b250.endt_expiry_date, b250.expiry_date) expiry_date, b250.eff_date, b250.prorate_flag,
                           DECODE (NVL (comp_sw, 'N'), 'Y', 1, 'M', -1, 0) comp_sw
                      FROM gipi_polbasic b250, gipi_itmperil b380
                     WHERE b250.line_cd = v_line_cd
                       AND b250.subline_cd = v_subline_cd
                       AND b250.iss_cd = v_iss_cd
                       AND b250.issue_yy = v_issue_yy
                       AND b250.pol_seq_no = v_pol_seq_no
                       AND b250.renew_no = v_renew_no
                       --AND nvl(b250.endt_expiry_date,b250.expiry_date) >= v_eff_date
                       AND TRUNC (DECODE (NVL (b250.endt_expiry_date, b250.expiry_date),
                                          b250.expiry_date, var_expiry_date,
                                          b250.endt_expiry_date, b250.endt_expiry_date
                                         )
                                 ) >= v_eff_date
                       AND b250.pol_flag IN ('1', '2', '3', 'X')
                       AND b250.policy_id = b380.policy_id
                       AND b380.item_no = p_item_no
                       AND b380.peril_cd = p_peril_cd)
         LOOP
            v_no_of_days := NULL;
            v_days_of_policy := NULL;
            v_prorate_prem := 0;
            -- get no of days that a particular record exists
            -- in order to get correct computation of perm. per day
            v_days_of_policy := TRUNC (a2.expiry_date) - TRUNC (a2.eff_date);

            IF v_prorate_flag = 1
            THEN
               v_days_of_policy := v_days_of_policy + a2.comp_sw;
            END IF;

            --get no. of days that will be returned
            IF v_comp_sw = 'Y'
            THEN
               v_no_of_days := (TRUNC (a2.expiry_date) - TRUNC (v_eff_date)) + 1;
            ELSIF v_comp_sw = 'M'
            THEN
               v_no_of_days := (TRUNC (a2.expiry_date) - TRUNC (v_eff_date)) - 1;
            ELSE
               v_no_of_days := TRUNC (a2.expiry_date) - TRUNC (v_eff_date);
            END IF;
			
			-- When TRUNC (a2.expiry_date) = TRUNC (a2.eff_date) and comp_sw = 'N', this result 
			-- to v_policy_days = 0 which triggers ORA-01476 (divisor is equal to zero) error.
			-- As per Ma'am Grace, same  dates of a2.expiry_date and a2.eff_date should already
			-- be considered as 1 day. -- Nica 06.04.2013 
			IF NVL (v_days_of_policy, 0) = 0 THEN
				v_days_of_policy := 1;
			END IF;

            -- for policy or endt with no of days less than the no. of days of cancelling
            -- endt. no_of days of cancelling endt. should be equal to the no_of days
            -- of policy/endt. on process
            IF NVL (v_no_of_days, 0) > NVL (v_days_of_policy, 0)
            THEN
               v_no_of_days := v_days_of_policy;
            END IF;

            -- compute for negated premium for records with premium <> 0
            IF NVL (a2.prem, 0) <> 0
            THEN
               --issa@fpac--v_prorate_prem := v_prorate_prem + (-(a2.prem /v_days_of_policy)*(v_no_of_days));
               --issa 08.28.2006, replacement
               v_prorate_prem := ROUND (v_prorate_prem + (- (a2.prem / v_days_of_policy) * (v_no_of_days)), 2);
            END IF;
         END LOOP;
      /* Three conditions have to be considered for     *
       * endorsements :  2 indicates that computation   *
       * should be based on a one year span.            */
      ELSIF v_prorate_flag = 2
      THEN
         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         IF ((NVL (p_tsi_amt, 0) = 0) AND (NVL (p_prem_rt, 0) = 0))
         THEN
            v_prem_amt := (NVL (p_prem_amt, 0));

            -- Compute for the prorated premium amount using the present premium
            -- as reference when tsi and premium rate are zero.
            IF ((NVL (po_tsi_amt, 0) = 0) AND (NVL (po_prem_rt, 0) = 0))
            THEN
               vo_prem_amt := NVL (po_prem_amt, 0);
            ELSE
               vo_prem_amt := NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100 * prov_discount;
                       -- Solve for the previous annualized premium amount
            -- Set another condition if the old tsi and premium rate are zero for
            -- determining of old tsi and premium.
            END IF;
         -- Set another condition if the old tsi and premium rate are zero.
         ELSIF (NVL (p_tsi_amt, 0) != 0)
         THEN
            p_prem_rt := ((NVL (p_prem_amt, 0) / NVL (p_tsi_amt, 0)) * 100) / prov_discount;
            -- Solve for the premium rate
            v_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

            -- Solve for the annualized premium amount
            IF ((NVL (po_tsi_amt, 0) = 0) AND (NVL (po_prem_rt, 0) = 0))
            THEN
               vo_prem_amt := (NVL (po_prem_amt, 0));
            ELSE
               vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
            -- Solve for the previous annualized premium amount
            END IF;
         -- Set another condition if the old tsi and premium rate are zero.
         END IF;

         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
         -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0)) - NVL (po_prem_amt, 0);
         -- Solve for the premium amount
         i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
                         -- Solve for the annualized prem amount
         
      /* Three conditions have to be considered for en- *
       * dorsements :  3 indicates that computation     *
       * should be based with respect to the short rate *
       * percent.                                       */
      ELSIF v_prorate_flag = 3 THEN
         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         IF ((NVL(p_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
            v_prem_amt :=  (NVL(p_prem_amt,0) / (NVL(v_short_rt_percent,1)/100));
            -- Compute for the prorated premium amount using the present premium
            -- as reference when tsi and premium rate are zero.
            IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
               vo_prem_amt:= NVL(po_prem_amt,0)/ (NVL(v_short_rt_percent,1)/100);
            ELSE
               vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                            -- Solve for the previous annualized premium amount
               -- Set another condition if the old tsi and premium rate are zero for 
               -- determining the old premium amount.
            END IF;
            -- Set another condition if the old tsi and premium rate are zero.
         ELSIF (NVL(p_tsi_amt,0) != 0) THEN
            p_prem_rt  :=  ((NVL(p_prem_amt,0) * 10000) /
                           (NVL(p_tsi_amt,1) * NVL(v_short_rt_percent,1) * prov_discount));
                         -- Solve for the premium rate
            v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                         -- Solve for the annualized premium amount
            IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
               vo_prem_amt:=  (NVL(po_prem_amt,0)/ (NVL(v_short_rt_percent,1)/100));
            ELSE
               vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                          -- Solve for the previous annualized premium amount
            END IF;
            -- Set another condition if the old tsi and premium rate are zero.
         END IF;
         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                            NVL(vo_prem_amt,0)); 
                         -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                            NVL(po_prem_amt,0);
                         -- Solve for the premium amount
         i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                            NVL(vo_prem_amt,0));
                         -- Solve for the annualized prem amount
         
      /* Three conditions have to be considered for     *
       * endorsements :  2 indicates that computation   *
       * should be based on a one year span.            */
      ELSE
         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         IF ((NVL (p_tsi_amt, 0) = 0) AND (NVL (p_prem_rt, 0) = 0))
         THEN
            v_prem_amt := (NVL (p_prem_amt, 0) / (NVL (p_short_rt_percent, 1) / 100));

            -- Compute for the prorated premium amount using the present premium
            -- as reference when tsi and premium rate are zero.
            IF ((NVL (po_tsi_amt, 0) = 0) AND (NVL (po_prem_rt, 0) = 0))
            THEN
               vo_prem_amt := NVL (po_prem_amt, 0) / (NVL (p_short_rt_percent, 1) / 100);
            ELSE
               vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
                         -- Solve for the previous annualized premium amount
            -- Set another condition if the old tsi and premium rate are zero for
            -- determining the old premium amount.
            END IF;
         -- Set another condition if the old tsi and premium rate are zero.
         ELSIF (NVL (p_tsi_amt, 0) != 0)
         THEN
            p_prem_rt := ((NVL (p_prem_amt, 0) * 10000) / (NVL (p_tsi_amt, 1) * NVL (p_short_rt_percent, 1) * prov_discount));
            -- Solve for the premium rate
            v_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

            -- Solve for the annualized premium amount
            IF ((NVL (po_tsi_amt, 0) = 0) AND (NVL (po_prem_rt, 0) = 0))
            THEN
               vo_prem_amt := (NVL (po_prem_amt, 0) / (NVL (p_short_rt_percent, 1) / 100));
            ELSE
               vo_prem_amt :=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
            -- Solve for the previous annualized premium amount
            END IF;
         -- Set another condition if the old tsi and premium rate are zero.
         END IF;

         --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
         p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
         -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0)) - NVL (po_prem_amt, 0);
         -- Solve for the premium amount
         i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
      	 -- Solve for the annualized prem amount
      END IF;
   END IF;

/**/
   p2_ann_prem_amt := ROUND (p2_ann_prem_amt, 2);                                                            --issa@cic 01.30.2007

   IF p2_ann_prem_amt < 0
   THEN
      --issa@fpac--msg_alert('Ann Premium Amount Cannot be less than 0.','I',true);
      --issa 08.28.2006, replacement
      raise_application_error (-20001,
                               'Geniisys Exception#I#You cannot return annual premium that is more than ' || TO_CHAR(NVL(ABS (p_ann_prem_amt), 0), '99,999,999,999.99')
                              );
--      raise_application_error (-20001,
--                               'Geniisys Exception#I#Invalid Premium Amount. Value should be from 0.00 to 9,999,999,999.99 and must not be greater than TSI Amt.');      
   END IF;
 
   IF (NVL (p_tsi_amt, 0) != 0)
   THEN
      p_prem_rt := NVL (p_prem_rt, 0);
   END IF;

   p_out_ann_prem_amt := NVL (p2_ann_prem_amt, 0);

  IF p_out_ann_prem_amt > 9999999999.99 THEN
    raise_application_error(-20001, 'Geniisys Exception#E#The computed annual premium amount exceeds the maximum allowable value. Please enter a different Premium Amount.');
  END IF;

   /* Added By    : Grace
   ** Date        : March 18, 2002
   ** Description : The following codes are added to automatically set the ann_prem_amt
   **      to zero if the annual tsi = 0. The discrepancy is due to the rounding off of
   **      amounts. 
   */
   IF (p_out_ann_prem_amt BETWEEN 0 AND .02) AND (p_ann_tsi_amt = 0)
   THEN
      p_out_ann_prem_amt := 0; 
   END IF;

--   IF v_nbt_prem <> v_prem
--   THEN
   auto_compute_prem_rt (p_par_id, p_prem_amt, p_tsi_amt, p_prorate_flag, p_prem_rt);
   p_out_prem_rt := p_prem_rt;

   --END IF;
   IF giisp.v ('RI') = v_iss_cd
   THEN
      p_ri_comm_amt := NVL (p_ri_comm_rate, 0) * NVL (p_prem_amt, 0) / 100;
   END IF;
   
   IF NVL(p_tsi_amt, 0) <> 0 THEN
     p_base_ann_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;
   ELSE
     p_base_ann_prem_amt := p_prem_amt;
   END IF;
   
   p_item_prem_amt := i2_prem_amt;
   p_item_ann_prem_amt := i2_ann_prem_amt;

--EXCEPTION
--   WHEN VALUE_ERROR
--   THEN
--     raise_application_error (-20001, 'Geniisys Exception#I#Invalid value for field.');
END;
/


