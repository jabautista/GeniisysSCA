DROP PROCEDURE CPI.COMPUTE_TSI_FINAL;

CREATE OR REPLACE PROCEDURE CPI.COMPUTE_TSI_FINAL(
    i_ann_prem_amt              GIPI_WITMPERL.ann_prem_amt%TYPE,
    i_ann_tsi_amt               GIPI_WITMPERL.ann_tsi_amt%TYPE,
    i_line_cd                   VARCHAR2,
    i_nbt_prem_amt          OUT GIPI_WITMPERL.prem_amt%TYPE,
    i_nbt_tsi_amt           OUT GIPI_WITEM.tsi_amt%TYPE,
    i_prem_amt                  GIPI_WITMPERL.prem_amt%TYPE,
    i_subline_cd                VARCHAR2,
    i_tsi_amt                   GIPI_WITEM.tsi_amt%TYPE,
    n_ann_prem_amt       IN OUT GIPI_WITMPERL.ann_prem_amt%TYPE,
    n_ann_tsi_amt        IN OUT GIPI_WITMPERL.ann_tsi_amt%TYPE,
    n_nbt_prem_amt              GIPI_WITMPERL.prem_amt%TYPE,
    n_nbt_prem_rt               NUMBER,
    n_nbt_tsi_amt               GIPI_WITEM.tsi_amt%TYPE,
    n_peril_cd                  VARCHAR2,
    n_tsi_amt                   GIPI_WITEM.tsi_amt%TYPE,
    p_dsp_peril_type            VARCHAR2,
    p_eff_date                  DATE,
    p_endt_expiry_date          DATE,
    p_expiry_date               DATE,
    p_nbt_prorate_flag          VARCHAR2,
    p_old_type                  VARCHAR2,
    p_prem_rt                   NUMBER,
    p_prem_amt              OUT GIPI_WITMPERL.prem_amt%TYPE,
    p_prov_prem_pct             NUMBER,
    p_prov_prem_tag             VARCHAR2,
    p_short_rt_percent          NUMBER,
    p_validate_sw               VARCHAR2,
    v_comp_sw                   VARCHAR2,
    p_msg                   OUT VARCHAR2
)
IS
    prov_discount     NUMBER(12,9)        :=  NVL(p_prov_prem_pct/100,1);
    var_type          VARCHAR2(1);
    v_prorate         NUMBER;
    v_prem_amt        GIPI_WITMPERL.prem_amt%TYPE;
    vo_prem_amt       GIPI_WITMPERL.prem_amt%TYPE;
    p2_ann_tsi_amt    GIPI_WITMPERL.ann_tsi_amt%TYPE;
    p2_ann_prem_amt   GIPI_WITMPERL.ann_prem_amt%TYPE;
    i2_prem_amt       GIPI_WITEM.prem_amt%TYPE;
    i2_ann_prem_amt   GIPI_WITEM.ann_prem_amt%TYPE;
    i2_tsi_amt        GIPI_WITEM.tsi_amt%TYPE;
    i2_ann_tsi_amt    GIPI_WITEM.ann_tsi_amt%TYPE;
    n_dsp_peril_type  VARCHAR2(1);
BEGIN
    IF NVL(p_prov_prem_tag,'N') != 'Y' THEN
         prov_discount  :=  1;
    END IF;
    
    IF p_dsp_peril_type IS NULL THEN
         FOR A1 IN (
             SELECT   peril_type
               FROM   giis_peril
              WHERE   line_cd    = i_line_cd
                AND  (subline_cd = i_subline_cd OR
                      subline_cd IS NULL)
                AND   peril_cd   = n_peril_cd) 
          LOOP
                n_dsp_peril_type :=  A1.peril_type;
          END LOOP;
    END IF;
    IF p_validate_sw  = 'Y' THEN
        var_type := nvl(p_old_type,n_dsp_peril_type);
    ELSE
        var_type := n_dsp_peril_type;
    END IF;
    
    IF p_nbt_prorate_flag = 1 THEN
       IF p_endt_expiry_date <= p_eff_date THEN
              /*MSG_ALERT('Your endorsement expiry date is equal to or less than your effectivity date.'||
                        ' Restricted condition.','E',TRUE);*/
          p_msg :=  'Your endorsement expiry date is equal to or less than your effectivity date.'||
                        ' Restricted condition.';
          RETURN;
       ELSE
       /*beth 021199 change the date from endt_expiry_date to expiry_date
        v_prorate  :=  TRUNC( :b240.endt_expiry_date - :b240.eff_date ) /
                             (ADD_MONTHS(:b240.eff_date,12) - :b240.eff_date);*/
         IF v_comp_sw = 'Y' THEN
           v_prorate  :=  ((TRUNC( p_expiry_date) - TRUNC(p_eff_date )) + 1 )/
                             (ADD_MONTHS(p_eff_date,12) - p_eff_date);
         ELSIF v_comp_sw = 'M' THEN
           v_prorate  :=  ((TRUNC( p_expiry_date) - TRUNC(p_eff_date )) - 1 )/
                             (ADD_MONTHS(p_eff_date,12) - p_eff_date);
         ELSE
           v_prorate  :=  (TRUNC( p_expiry_date) - TRUNC(p_eff_date ))/
                             (ADD_MONTHS(p_eff_date,12) - p_eff_date);
         END IF;
       END IF;
                     -- Solve for the prorate period
       v_prem_amt :=  (NVL(n_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                     -- Solve for the annualized premium amount

       --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
       IF ((NVL(n_nbt_tsi_amt,0) = 0) AND (NVL(n_nbt_prem_rt,0) = 0)) THEN
            vo_prem_amt:=   NVL(n_nbt_prem_amt,0);
       ELSE
            vo_prem_amt:=   NVL(n_nbt_prem_amt,0);
           -- vo_prem_amt:=  (NVL(:b490.nbt_tsi_amt,0) * NVL(n_nbt_prem_rt,0)/100 ) * prov_discount;
                     -- Solve for the old annualized premium amount
       END IF;
       --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--

       p_prem_amt :=  ((NVL(n_tsi_amt,0) * NVL(p_prem_rt,0)) / 100 ) * 
                              v_prorate * prov_discount;
                     -- Solve for the premium amount (prorated value) for perils
       p2_ann_tsi_amt := (NVL(n_ann_tsi_amt,0) + NVL(n_tsi_amt,0)  -
                              NVL(n_nbt_tsi_amt,0));
                     -- Solve for the annualized tsi amount for perils
       p2_ann_prem_amt := (NVL(n_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                              NVL(n_ann_prem_amt,0)); 
                              --beth 022699 NVL(vo_prem_amt,0)); 
                     -- Solve for the annualized prem amount for perils
       i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                              NVL(n_nbt_prem_amt,0);
                     -- Solve for the premium amount
       i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                              NVL(n_ann_prem_amt,0)); 
                              --beth 022699NVL(vo_prem_amt,0));
                     -- Solve for the annualized prem amount
       -- add tsi amount of items when peril type of peril is equal to 'B'
--       IF :b490.dsp_peril_type = 'B' THEN
       IF var_type = 'B' THEN
         i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(n_tsi_amt,0)) -
                                NVL(n_nbt_tsi_amt,0);
                       -- Solve for the tsi amt for items
         i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(n_tsi_amt,0)) -
                                NVL(n_nbt_tsi_amt,0);
                       -- Solve for the annualized tsi amount
       END IF;
   /* Three conditions have to be considered for en- *
    * dorsements :  2 indicates that computation     *
    * should be based on a one year span.            */
   ELSIF p_nbt_prorate_flag = 2 THEN
       v_prem_amt :=  (NVL(n_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                     -- Solve for the annualized premium amount

       --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
       IF ((NVL(n_nbt_tsi_amt,0) = 0) AND (NVL(n_nbt_prem_rt,0) = 0)) THEN
            vo_prem_amt:=  (NVL(n_nbt_prem_amt,0));
       ELSE
            vo_prem_amt:=  (NVL(n_nbt_prem_amt,0));
           -- vo_prem_amt:=  (NVL(:b490.nbt_tsi_amt,0) * NVL(n_nbt_prem_rt,0) / 100) * prov_discount;
                     -- Solve for the old annualized premium amount
       END IF;
       --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--

       p_prem_amt :=  (NVL(n_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                     -- Solve for the premium amount (for one year) for perils
       p2_ann_tsi_amt := (NVL(n_ann_tsi_amt,0) + NVL(n_tsi_amt,0)  -
                              NVL(n_nbt_tsi_amt,0));
                     -- Solve for the annualized tsi amount for perils
       p2_ann_prem_amt := (NVL(n_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                              NVL(vo_prem_amt,0)); 
                     -- Solve for the annualized prem amount for perils

       i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                              NVL(n_nbt_prem_amt,0);
                     -- Solve for the premium amount
       i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                              NVL(vo_prem_amt,0));
                     -- Solve for the annualized prem amount
--       IF :b490.dsp_peril_type  = 'B' THEN
         IF var_type = 'B' THEN
          i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(n_tsi_amt,0)) -
                                NVL(n_nbt_tsi_amt,0);
                       -- Solve for the tsi amt for items
          i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(n_tsi_amt,0)) -
                                NVL(n_nbt_tsi_amt,0);
                       -- Solve for the annualized tsi amount
       END IF;
   /* Three conditions have to be considered for en- *
    * dorsements :  3 indicates that computation     *
    * should be based with respect to the short rate *
    * percent.                                       */
   ELSE
       v_prem_amt :=  (NVL(n_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                     -- Solve for the annualized premium amount
       --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
       IF ((NVL(n_nbt_tsi_amt,0) = 0) AND (NVL(n_nbt_prem_rt,0) = 0)) THEN
            vo_prem_amt:=  (NVL(n_nbt_prem_amt,0));
       ELSE
            vo_prem_amt:=  (NVL(n_nbt_prem_amt,0));
           -- vo_prem_amt:=  (NVL(:b490.nbt_tsi_amt,0) * NVL(n_nbt_prem_rt,0)/100 ) * prov_discount;
                     -- Solve for the old annualized premium amount
       END IF;
       --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--

       p_prem_amt := (((NVL(p_prem_rt,0) * NVL(n_tsi_amt,0) * NVL(p_short_rt_percent,0))) /
                        10000) * prov_discount;
                     -- Solve for the premium amount (short rate) for perils
       p2_ann_tsi_amt := (NVL(n_ann_tsi_amt,0) + NVL(n_tsi_amt,0)  -
                              NVL(n_nbt_tsi_amt,0));
                     -- Solve for the annualized tsi amount for perils
       p2_ann_prem_amt := (NVL(n_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                              NVL(n_nbt_prem_amt,0)); 
                     -- Solve for the annualized prem amount for perils
       i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) -
                              NVL(n_nbt_prem_amt,0);
                     -- Solve for the premium amount
       i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) -
                              NVL(vo_prem_amt,0));
                     -- Solve for the annualized prem amount
     --  IF :b490.dsp_peril_type  =  'B' THEN
       IF var_type = 'B' THEN
          i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(n_tsi_amt,0)) -
                              NVL(n_nbt_tsi_amt,0);
                     -- Solve for the tsi amt for items
          i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(n_tsi_amt,0)) -
                              NVL(n_nbt_tsi_amt,0);
                     -- Solve for the annualized tsi amount
       END IF;
   END IF;
   n_ann_prem_amt :=  p2_ann_prem_amt;
   n_ann_tsi_amt  :=  p2_ann_tsi_amt;
   i_nbt_prem_amt :=  i2_prem_amt;
   IF p_dsp_peril_type = 'B' THEN
     i_nbt_tsi_amt      :=  i2_tsi_amt;
   END IF;
 
END;
/


