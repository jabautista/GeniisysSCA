DROP PROCEDURE CPI.GIPIS097_COMPUTE_TSI;

CREATE OR REPLACE PROCEDURE CPI.gipis097_compute_tsi (
   p_par_id             IN       gipi_witmperl.par_id%TYPE,
   p_peril_cd           IN       gipi_witmperl.peril_cd%TYPE,
   p_peril_type         IN       giis_peril.peril_type%TYPE,
   p_changed_tag        IN       gipi_witem.changed_tag%TYPE,
   p_tsi_amt            IN       NUMBER,                                                                           -- b490.tsi_amt
   p_prem_rt            IN       NUMBER,                                                                           -- b490.prem_rt
   p_ann_tsi_amt        IN       NUMBER,                                                                       -- b490.ann_tsi_amt
   p_ann_prem_amt       IN       NUMBER,                                                                      -- b490.ann_prem_amt
   i_tsi_amt            IN       NUMBER,                                                                           -- b480.tsi_amt
   i_prem_amt           IN       NUMBER,                                                                          -- b480.prem_amt
   i_ann_tsi_amt        IN       NUMBER,                                                                       -- b480.ann_tsi_amt
   i_ann_prem_amt       IN       NUMBER,
   p_no_of_days         IN       NUMBER,
   p_item_to_date       IN       gipi_witem.TO_DATE%TYPE,
   p_item_from_date     IN       gipi_witem.from_date%TYPE,
   p_item_comp_sw       IN       gipi_witem.comp_sw%TYPE,
   p_plan_sw            IN       VARCHAR2,
--   p_message          OUT      VARCHAR2,
--   p_message_type     OUT      VARCHAR2,
   p_out_tsi_amt        OUT      NUMBER, --gipi_witmperl.tsi_amt%TYPE,
   p_out_prem_amt       OUT      NUMBER, --gipi_witmperl.prem_amt%TYPE,
   p_out_ann_tsi_amt    OUT      NUMBER, --gipi_witmperl.ann_tsi_amt%TYPE,
   p_out_ann_prem_amt   OUT      NUMBER, --gipi_witmperl.ann_prem_amt%TYPE
   p_base_ann_prem_amt  OUT      NUMBER
)
IS                                                                                                            -- b480.ann_prem_amt
   /*  GIVEN:    b490.tsi_amt, b490.prem_rt          *
    *  REQD:     b490.prem_amt, b490.ann_tsi_amt     *
    *            b490.ann_prem_amt                   *
    *            b480.tsi_amt, b480.prem_amt         *
    *            b480.ann_tsi_amt, b480.ann_prem_amt */
   prov_discount         NUMBER (12, 9);
   p_prem_amt            NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;		--d.alcantara, added precision to numbers
   -- supposed value of b490.prem_amt
   p2_ann_tsi_amt        NUMBER(20,2); --gipi_witmperl.ann_tsi_amt%TYPE;
   -- supposed value of b490.ann_tsi_amt
   p2_ann_prem_amt       NUMBER(20,2); --gipi_witmperl.ann_prem_amt%TYPE;
   -- supposed value of b490.ann_prem_amt
   po_tsi_amt            NUMBER(20,2); --gipi_witmperl.tsi_amt%TYPE;                                               --      := NVL (p_tsi_amt, 0);
   po_prem_amt           NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;                                               --    := NVL (p_prem_amt, 0);
   po_prem_rt            NUMBER; --gipi_witmperl.prem_rt%TYPE;                                               --      := NVL (p_prem_rt, 0);
   i2_tsi_amt            NUMBER(20,2);--gipi_witem.tsi_amt%TYPE;
   -- supposed value of b480.tsi_amt
   i2_prem_amt           NUMBER(20,2);--gipi_witem.prem_amt%TYPE;
   -- supposed value of b480.prem_amt
   i2_ann_tsi_amt        NUMBER(20,2);--gipi_witem.ann_tsi_amt%TYPE;
   -- supposed value of b480.ann_tsi_amt
   i2_ann_prem_amt       NUMBER(20,2);--gipi_witem.ann_prem_amt%TYPE;
   -- supposed value of b480.ann_prem_amt
   v_prorate             NUMBER;
   v_prem_amt            gipi_witmperl.prem_amt%TYPE;
   vo_prem_amt           NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
   p_prov_tag            gipi_wpolbas.prov_prem_tag%TYPE;
   -- variable to determine if tag is 'Y'
   po_prov_prem          NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
   v_prov_prem           NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
   p_prov_prem           NUMBER(20,2); --gipi_witmperl.prem_amt%TYPE;
                                            -- variable that would be used if
                                                          -- the basic info holds the
                                                          -- provisional switch equal to yes
   --bdarusin, 03012002
   v_prorate_prem        NUMBER (15, 5);
   --GIPI_WITMPERL.prem_amt%TYPE;  --variable for computed negated premium
   v_no_of_days          NUMBER;                                                                                                --
   v_days_of_policy      NUMBER;                                                                                                --
   /* added variables by gmi..
     ** var_no_of_days and var_peril_cd
     ** this variables hold values of
     ** :b490.no_of_days and :b490.peril_cd (if manual processing)
     ** or
     ** ret_no_of_days and ret_peril_cd (if retrieve peril button is used)
     */
   v_prov_prem_tag       gipi_wpolbas.prov_prem_tag%TYPE;
   v_prorate_flag        gipi_wpolbas.prorate_flag%TYPE;
   v_comp_sw             gipi_wpolbas.comp_sw%TYPE;
   v_short_rt_percent    gipi_wpolbas.short_rt_percent%TYPE;
   v_endt_expiry_date    gipi_wpolbas.endt_expiry_date%TYPE;
   v_eff_date            gipi_wpolbas.eff_date%TYPE;
   v_expiry_date         gipi_wpolbas.expiry_date%TYPE;
   v_incept_date         gipi_wpolbas.incept_date%TYPE;
   var_expiry_date       DATE;
   v_line_cd             gipi_wpolbas.line_cd%TYPE;
   v_subline_cd          gipi_wpolbas.subline_cd%TYPE;
   v_iss_cd              gipi_wpolbas.iss_cd%TYPE;
   v_issue_yy            gipi_wpolbas.issue_yy%TYPE;
   v_pol_seq_no          gipi_wpolbas.pol_seq_no%TYPE;
   v_renew_no            gipi_wpolbas.renew_no%TYPE;
   var_plan_sw           VARCHAR2 (1);
   var_comp_no_of_days   NUMBER;
   v_prov_prem_pct       gipi_wpolbas.prov_prem_pct%TYPE;
BEGIN
   --p_message_type := 'SUCCESS';
   var_expiry_date := extract_expiry (p_par_id);

   IF p_plan_sw IS NULL OR p_plan_sw = '' THEN
        var_plan_sw := 'Y';
   ELSE
        var_plan_sw := p_plan_sw;
   END IF;

   /*IF p_plan_sw IS NOT NULL OR p_plan_sw <> ''
   THEN
      var_plan_sw := p_plan_sw;
   ELSE
      var_plan_sw := 'Y';
   END IF;*/  -- edited by d.alcantara, 08.23.2013


   FOR i IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, prov_prem_tag, prorate_flag, comp_sw,
                    short_rt_percent, endt_expiry_date, prov_prem_pct, eff_date, expiry_date, incept_date
               FROM gipi_wpolbas
              WHERE par_id = p_par_id)
   LOOP
      v_line_cd := i.line_cd;
      v_subline_cd := i.subline_cd;
      v_iss_cd := i.iss_cd;
      v_issue_yy := i.issue_yy;
      v_pol_seq_no := i.pol_seq_no;
      v_renew_no := i.renew_no;
      v_prov_prem_tag := i.prov_prem_tag;
      v_prov_prem_pct := i.prov_prem_pct;
      v_prorate_flag := i.prorate_flag;
      v_comp_sw := i.comp_sw;
      v_short_rt_percent := i.short_rt_percent;
      v_endt_expiry_date := i.endt_expiry_date;
      v_incept_date := i.incept_date;
      v_expiry_date := i.expiry_date;
      v_eff_date := i.eff_date;
      EXIT;
   END LOOP;

   prov_discount := NVL (v_prov_prem_pct / 100, 1);

   FOR j IN (SELECT DISTINCT a.policy_id policy_id, TRUNC (a.incept_date) incept_date, TRUNC (a.expiry_date) expiry_date,
                             a.endt_seq_no
                        FROM gipi_polbasic a
                       WHERE a.line_cd = v_line_cd
                         AND a.subline_cd = v_subline_cd
                         AND a.iss_cd = v_iss_cd
                         AND a.issue_yy = v_issue_yy
                         AND a.pol_seq_no = v_pol_seq_no
                         AND a.renew_no = v_renew_no
                         AND a.pol_flag NOT IN ('4', '5')
                    ORDER BY a.endt_seq_no DESC)
   LOOP
      var_comp_no_of_days := TRUNC (v_expiry_date - v_incept_date) - TRUNC (j.expiry_date - j.incept_date);
      EXIT;
   END LOOP;

   /* Special case when there is a prov_discount.
   ***********************************************
   */
   IF NVL (v_prov_prem_tag, 'N') != 'Y'
   THEN
      prov_discount := 1;
   END IF;

   p_base_ann_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

   /* Three conditions have to be considered for en- *
    * dorsements :  1 indicates that computation     *
    * should be prorated.
                            */               
   IF NVL (p_changed_tag, 'N') = 'Y'
   THEN
      IF v_prorate_flag = 1
      THEN
         IF p_item_to_date <= p_item_from_date
         THEN
            raise_application_error
                         ('-20001',
                          'Geniisys Exception#E#Your item TO DATE is equal to or less than your FROM DATE. Restricted condition.'
                         );
         ELSE
                /*By Iris Bordey 08.26.2003
            **Removed add_months operation for computaton of premium.  Replaced
            **it instead of variables.v_days (see check_duration) for short term endt.
            */
            --check_duration(TRUNC(p_item_from_date), ADD_MONTHS(TRUNC(p_item_from_date),12));
            IF p_item_comp_sw = 'Y'
            THEN
               v_prorate :=
                    ((TRUNC (p_item_to_date) - TRUNC (p_item_from_date)) + 1)
                  / check_duration (TRUNC (p_item_from_date), TRUNC (p_item_to_date));
            --(ADD_MONTHS(TRUNC(p_item_from_date),12) - TRUNC(p_item_from_date));
            ELSIF v_comp_sw = 'M'
            THEN
               v_prorate :=
                    ((TRUNC (p_item_to_date) - TRUNC (p_item_from_date)) - 1)
                  / check_duration (TRUNC (p_item_from_date), TRUNC (p_item_to_date));
            --(ADD_MONTHS(TRUNC(p_item_from_date),12) - TRUNC(p_item_from_date));
            ELSE
               v_prorate :=
                    (TRUNC (p_item_to_date) - TRUNC (p_item_from_date))
                  / check_duration (TRUNC (p_item_from_date), TRUNC (p_item_to_date));
            --(ADD_MONTHS(TRUNC(p_item_from_date),12) - TRUNC(p_item_from_date));
            END IF;
         END IF;

         -- Solve for the prorate period
         v_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

         -- Solve for the annualized premium amount

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         --IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
         IF NVL (po_tsi_amt, 0) = 0
         THEN
            vo_prem_amt := (NVL (po_prem_amt, 0) / v_prorate);
         ELSE
            vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
         -- Solve for the old annualized premium amount
         END IF;

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         IF NVL (p_no_of_days, 0) = 0
         THEN
            p_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * v_prorate * prov_discount;
         ELSE
            --added by gmi 12/22/05 added no_of_days/1 year in computation of prem_amt.
            p_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * v_prorate * prov_discount * (p_no_of_days / 365);
         END IF;

         -- Solve for the premium amount (prorated value) for perils
         p2_ann_tsi_amt := (NVL (p_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0) - NVL (po_tsi_amt, 0));
         -- Solve for the annualized tsi amount for perils
         p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
         -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0)) - NVL (po_prem_amt, 0);
         -- Solve for the premium amount
         i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));

                         -- Solve for the annualized prem amount
         -- add tsi amount of items when peril type of peril is equal to 'B'
         IF p_peril_type = 'B'
         THEN                                                                                             --added condition by gmi
            i2_tsi_amt := (NVL (i_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
            -- Solve for the tsi amt for items
            i2_ann_tsi_amt := (NVL (i_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
         -- Solve for the annualized tsi amount
         END IF;
      /* Three conditions have to be considered for  *
       * endorsements :  2 indicates that computation     *
       * should be based on a one year span.            */
      ELSIF v_prorate_flag = 2
      THEN
         v_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

         -- Solve for the annualized premium amount

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         --IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
         IF NVL (po_tsi_amt, 0) = 0
         THEN
            vo_prem_amt := (NVL (po_prem_amt, 0));
         ELSE
            vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
         -- Solve for the old annualized premium amount
         END IF;

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         IF NVL (p_no_of_days, 0) = 0
         THEN                                                                                                      -- gmi 12/21/05
            p_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;
         ELSE
            p_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount * (p_no_of_days / 365);
         END IF;

         -- Solve for the premium amount (for one year) for perils
         p2_ann_tsi_amt := (NVL (p_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0) - NVL (po_tsi_amt, 0));
         -- Solve for the annualized tsi amount for perils
         p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
         -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0)) - NVL (po_prem_amt, 0);
         -- Solve for the premium amount
         i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));


         -- Solve for the annualized prem amount
         IF p_peril_type = 'B'
         THEN                                                                                             --added condition by gmi
            i2_tsi_amt := (NVL (i_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
            -- Solve for the tsi amt for items
            i2_ann_tsi_amt := (NVL (i_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
         -- Solve for the annualized tsi amount
         END IF;
      /* Three conditions have to be considered for       *
       * endorsements :  3 indicates that computation     *
       * should be based with respect to the short rate   *
       * percent.                                         */
      ELSE
         v_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

         -- Solve for the annualized premium amount

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         --IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
         IF NVL (po_tsi_amt, 0) = 0
         THEN
            vo_prem_amt := (NVL (po_prem_amt, 0) / (NVL (v_short_rt_percent, 1) / 100));
         ELSE
            vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
         -- Solve for the old annualized premium amount
         END IF;

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         IF NVL (p_no_of_days, 0) = 0
         THEN                                                                                                      -- gmi 12/21/05
            p_prem_amt := (((NVL (p_prem_rt, 0) * NVL (p_tsi_amt, 0) * NVL (v_short_rt_percent, 0))) / 10000) * prov_discount;
         ELSE
            --added by gmi 12/22/05 added no_of_days/1 year in computation of prem_amt.
            p_prem_amt :=
                 (((NVL (p_prem_rt, 0) * NVL (p_tsi_amt, 0) * NVL (v_short_rt_percent, 0))) / 10000)
               * prov_discount
               * (p_no_of_days / 365);
         END IF;

         -- Solve for the premium amount (short rate) for perils
         p2_ann_tsi_amt := (NVL (p_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0) - NVL (po_tsi_amt, 0));
         -- Solve for the annualized tsi amount for perils
         p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
         -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0)) - NVL (po_prem_amt, 0);
         -- Solve for the premium amount
         i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));

         -- Solve for the annualized prem amount
         IF p_peril_type = 'B'
         THEN                                                                                             --added condition by gmi
            i2_tsi_amt := (NVL (i_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
            -- Solve for the tsi amt for items
            i2_ann_tsi_amt := (NVL (i_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
         -- Solve for the annualized tsi amount
         END IF;
      END IF;
   ELSE
      IF v_prorate_flag = 1
      THEN
         IF v_endt_expiry_date <= v_eff_date
         THEN
            raise_application_error
               ('-20001',
                'Geniisys Exception#E#Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.'
               );
         ELSE
            /* beth 021199
            v_prorate  :=  TRUNC( v_endt_expiry_date - v_eff_date ) /
                           (ADD_MONTHS(v_eff_date,12) - v_eff_date);*//*bdarusin, jan282003, if policy is prorate, and item has its own effectivity,
                compute based on item effectivity*/
                /*By Iris Bordey 08.26.2003
              **Removed add_months operation for computaton of premium.  Replaced
              **it instead of variables.v_days (see check_duration) for short term endt.
              */
              --check_duration(v_incept_date,ADD_MONTHS(v_incept_date,12));
            IF NVL (p_changed_tag, 'N') = 'Y'
            THEN
               v_prorate := (TRUNC (p_item_to_date) - TRUNC (p_item_from_date)) / check_duration (v_incept_date, v_expiry_date);
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
                  v_prorate := (TRUNC (v_endt_expiry_date) - TRUNC (v_eff_date)) / check_duration (v_incept_date, v_expiry_date);
               --(ADD_MONTHS(TRUNC(v_incept_date),12) - TRUNC(v_incept_date));
               END IF;
            END IF;
         END IF;

         -- Solve for the prorate period
         v_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

         -- Solve for the annualized premium amount

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         --IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
         IF NVL (po_tsi_amt, 0) = 0
         THEN
            vo_prem_amt := (NVL (po_prem_amt, 0) / v_prorate);
         ELSE
            vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
         -- Solve for the old annualized premium amount
         END IF;

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         IF NVL (p_no_of_days, 0) = 0
         THEN                                                                                                      -- gmi 12/21/05
            p_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * v_prorate * prov_discount;
         ELSE
            --added by gmi 12/22/05 added no_of_days/1 year in computation of prem_amt.
            p_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * v_prorate * prov_discount * (p_no_of_days / 365);
         END IF;

         -- added by bdarusin
         -- on mar 01, 2002
         -- to compute for the negated premium which will be compared to the prem amt
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
                       -- AND nvl(b250.endt_expiry_date,b250.expiry_date) >= v_eff_date
                       AND TRUNC (DECODE (NVL (b250.endt_expiry_date, b250.expiry_date),
                                          b250.expiry_date, var_expiry_date,
                                          b250.endt_expiry_date, b250.endt_expiry_date
                                         )
                                 ) >= v_eff_date
                       AND b250.pol_flag IN ('1', '2', '3', 'X')
                       AND b250.policy_id = b380.policy_id
                       AND b380.item_no = b380.item_no
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

            -- get no. of days that will be returned
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

            --compute for negated premium for records with premium <> 0
            IF NVL (a2.prem, 0) <> 0
            THEN
               v_prorate_prem := v_prorate_prem + TRUNC((- (a2.prem / v_days_of_policy) * (v_no_of_days)),2);
            END IF;
         --computed negated premium is rounded off --
         --v_prorate_prem := round(v_prorate_prem,2);
         END LOOP;

             -- ann prem amt will be zeroed out if computed negated premium is equal to the premium
             -- amount entered
         -- IF p_prem_amt = trunc(v_prorate_prem,2) THEN
             --       p_prem_amt := round(v_prorate_prem,2);
             -- END IF;
         -- end of added script by bdarusin
                         -- Solve for the premium amount (prorated value) for perils
         p2_ann_tsi_amt := (NVL (p_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0) - NVL (po_tsi_amt, 0));
         -- Solve for the annualized tsi amount for perils
         
         p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (TRUNC(v_prem_amt,2), 0) - NVL (TRUNC(vo_prem_amt,2), 0)); -- 07.05.2013 - added truncate for decimal places
         
         -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL (TRUNC(i_prem_amt,2), 0) + NVL (TRUNC(p_prem_amt,2), 0)) - NVL (TRUNC(po_prem_amt,2), 0);
         -- Solve for the premium amount
         i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (TRUNC(v_prem_amt,2), 0) - NVL (TRUNC(vo_prem_amt,2), 0));

                         -- Solve for the annualized prem amount
         -- add tsi amount of items when peril type of peril is equal to 'B'
         IF p_peril_type = 'B'
         THEN                                                                                                       --gmi 12/21/05
            i2_tsi_amt := (NVL (i_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
            -- Solve for the tsi amt for items
            i2_ann_tsi_amt := (NVL (i_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
         -- Solve for the annualized tsi amount
         END IF;
      /* Three conditions have to be considered for  *
       * endorsements :  2 indicates that computation     *
       * should be based on a one year span.            */
      ELSIF v_prorate_flag = 2
      THEN
         v_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

         -- Solve for the annualized premium amount

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         --IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
         IF NVL (po_tsi_amt, 0) = 0
         THEN
            vo_prem_amt := (NVL (po_prem_amt, 0));
         ELSE
            vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
         -- Solve for the old annualized premium amount
         END IF; 

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         IF NVL (p_no_of_days, 0) = 0
         THEN                                                                                                      -- gmi 12/21/05
            p_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;
         ELSE
            --added by gmi 12/22/05 added no_of_days/1 year in computation of prem_amt.
            p_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount * (p_no_of_days / 365);
         END IF;

         BEGIN
            -- Solve for the premium amount (for one year) for perils
            p2_ann_tsi_amt := (NVL (p_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0) - NVL (po_tsi_amt, 0));
            -- Solve for the annualized tsi amount for perils
            p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
            -- Solve for the annualized prem amount for perils
            i2_prem_amt := (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0)) - NVL (po_prem_amt, 0);
            -- Solve for the premium amount
            i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));

--         EXCEPTION
--            WHEN VALUE_ERROR 
--            THEN                                                                                          --added steven 9.14.2012
--               raise_application_error
--                  ('-20001',
--                      'Geniisys Exception#E#Adding this Premium Amount will exceed the maximum Total Premium Allowed for this PAR.'
--                   || 'Total Premium Amount value must range from 0.00 to 9,999,999,999.99.'
--                  );
         --p_message_type := 'ERROR';
         END;

         -- Solve for the annualized prem amount
         IF p_peril_type = 'B'
         THEN                                                                                             --added condition by gmi
            i2_tsi_amt := (NVL (i_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
            -- Solve for the tsi amt for items
            i2_ann_tsi_amt := (NVL (i_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
         -- Solve for the annualized tsi amount
         END IF;
      /* Three conditions have to be considered for       *
       * endorsements :  3 indicates that computation     *
       * should be based with respect to the short rate   *
       * percent.                                         */
      ELSE
         v_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * prov_discount;

         -- Solve for the annualized premium amount

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         --IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
         IF NVL (po_tsi_amt, 0) = 0
         THEN
            vo_prem_amt := (NVL (po_prem_amt, 0) / (NVL (v_short_rt_percent, 1) / 100));
         ELSE
            vo_prem_amt := (NVL (po_tsi_amt, 0) * NVL (po_prem_rt, 0) / 100) * prov_discount;
         -- Solve for the old annualized premium amount 
         END IF;

         --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
         IF NVL (p_no_of_days, 0) = 0
         THEN                                                                                                      -- gmi 12/21/05
            p_prem_amt := (((NVL (p_prem_rt, 0) * NVL (p_tsi_amt, 0) * NVL (v_short_rt_percent, 0))) / 10000) * prov_discount;
         ELSE
            --added by gmi 12/22/05 added no_of_days/1 year in computation of prem_amt.
            p_prem_amt :=
                 (((NVL (p_prem_rt, 0) * NVL (p_tsi_amt, 0) * NVL (v_short_rt_percent, 0))) / 10000)
               * prov_discount
               * (p_no_of_days / 365);
         END IF;

         -- Solve for the premium amount (short rate) for perils
         p2_ann_tsi_amt := (NVL (p_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0) - NVL (po_tsi_amt, 0));
         -- Solve for the annualized tsi amount for perils
         p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
         -- Solve for the annualized prem amount for perils
         i2_prem_amt := (NVL (i_prem_amt, 0) + NVL (p_prem_amt, 0)) - NVL (po_prem_amt, 0);
         -- Solve for the premium amount
         i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));

         -- Solve for the annualized prem amount
         IF p_peril_type = 'B'
         THEN                                                                                             --added condition by gmi
            i2_tsi_amt := (NVL (i_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
            -- Solve for the tsi amt for items
            i2_ann_tsi_amt := (NVL (i_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
         -- Solve for the annualized tsi amount
         END IF;
      END IF;
   END IF;

   IF p2_ann_tsi_amt < 0
   THEN
      raise_application_error ('-20001',
                               'Geniisys Exception#I#Ann TSI Amount cannot be less than 0.'
                              );
--      raise_application_error ('-20001',
--                               'Geniisys Exception#E#Invalid TSI Amount. Value should be from 0.01 to 99,999,999,999,999.99.'
--                              );
   END IF;

   IF p2_ann_prem_amt < -.02 -- 07.05.2013 - changed from 0
   THEN
      raise_application_error ('-20001',
                                  'Geniisys Exception#E#The program automatically compute prem. (rate * TSI), '
                               || 'due to previous affecting endts. made on this policy '
                               || 'computed prem. exceeds the allowed prem. '
                               || 'To correct this error enter 0 TSI or 0 prem rate.'
                              );
   END IF;

   IF NVL (var_plan_sw, '&') <> 'X'
   THEN
      IF p_peril_type = 'B'
      THEN                                                                                               --added condition by gmi
         p_out_tsi_amt := i2_tsi_amt;
      --:b480.ann_tsi_amt  :=  i2_ann_tsi_amt;
      END IF;
   END IF;

   -- modified by gmi 12/20/05, variables are used in inserting records in procedure PACKAGE_BEN,
   --( [also used in retrieve_peril btn] added by gmi 032907 )
   IF var_plan_sw = 'Y' OR var_plan_sw = 'X'
   THEN
      IF var_plan_sw = 'X' AND var_comp_no_of_days <= 0
      THEN
--added by gmi.. no prorate computations pra sa pangyayaring ito.. ginamit lng ito sa retrieval ng perils at pang minus sa ann_prem_amt.. ANNUALIZED baby.. hehe.. do da mat
         p_out_prem_amt := v_prem_amt;
      ELSE
         p_out_prem_amt := p_prem_amt;
      END IF;

      p_out_ann_prem_amt := p2_ann_prem_amt;
      p_out_ann_tsi_amt := p2_ann_tsi_amt;
   ELSE
      p_out_prem_amt := p_prem_amt;
      p_out_ann_prem_amt := p2_ann_prem_amt;
      p_out_ann_tsi_amt := p2_ann_tsi_amt;
   END IF;

  IF p_out_ann_tsi_amt > 99999999999999.99 THEN
    raise_application_error(-20001, 'Geniisys Exception#E#The computed annual TSI amount exceeds the maximum allowable value. Please enter a different TSI amount.');
  END IF;

--   :b480.prem_amt := i2_prem_amt;
--:b480.ann_prem_amt :=  i2_ann_prem_amt;

   --variables.plan_sw := 'N';
--variables.v_dsp_peril_type := null;
 
  IF p_out_prem_amt > 9999999999.99 THEN
    raise_application_error(-20001, 'Geniisys Exception#E#The computed premium amount exceeds the maximum allowable value. Please enter a different Premium Rate or different TSI amount.');
  END IF;

  IF p_out_ann_prem_amt > 9999999999.99 THEN
    raise_application_error(-20001, 'Geniisys Exception#E#The computed annual premium amount exceeds the maximum allowable value. Please enter a different Premium Rate or different TSI amount.');
  END IF;

/* Added By    : Grace
** Date        : March 18, 2002
** Description : The following codes are added to automatically set the ann_prem_amt
**      to zero if the annual tsi = 0. The discrepancy is due to the rounding off of
**      amounts.
*/
   IF (p_out_ann_prem_amt BETWEEN -.02 AND .02) AND (p_out_ann_tsi_amt = 0)  -- 07.05.2013 - added -.02
   THEN
      p_out_ann_prem_amt := 0;
   END IF;
   
   p_out_prem_amt := ROUND(p_out_prem_amt, 2);
END;
/


