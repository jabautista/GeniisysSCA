DROP PROCEDURE CPI.GIPIS097_COMPUTE_TARF;

CREATE OR REPLACE PROCEDURE CPI.gipis097_compute_tarf (
   p_par_id                      gipi_witmperl.par_id%TYPE,
   p_peril_cd                    gipi_witmperl.peril_cd%TYPE,
   p_peril_type         IN OUT   giis_peril.peril_type%TYPE,
   p_tsi_amt            IN       NUMBER,                                                                           -- b490.tsi_amt
   p_prem_rt            IN       NUMBER,                                                                           -- b490.prem_rt
   p_ann_tsi_amt        IN       NUMBER,                                                                       -- b490.ann_tsi_amt
   p_ann_prem_amt       IN       NUMBER,                                                                      -- b490.ann_prem_amt
   i_tsi_amt            IN       NUMBER,                                                                           -- b480.tsi_amt
   i_prem_amt           IN       NUMBER,                                                                          -- b480.prem_amt
   i_ann_tsi_amt        IN       NUMBER,                                                                       -- b480.ann_tsi_amt
   i_ann_prem_amt       IN       NUMBER,
   p_tariff_cd          IN       NUMBER,
   default_tag          IN       VARCHAR2,
   default_prem         IN       NUMBER,
   p_out_prem_amt       OUT      NUMBER, --gipi_witmperl.prem_amt%TYPE,
   p_out_ann_tsi_amt    OUT      NUMBER, --gipi_witmperl.ann_tsi_amt%TYPE,
   p_out_ann_prem_amt   OUT      NUMBER, --gipi_witmperl.ann_prem_amt%TYPE,
   p_base_ann_prem_amt OUT       NUMBER --gipi_witmperl.ann_prem_amt%TYPE
) 
IS
   /*  GIVEN:    b490.tsi_amt, b490.prem_rt          *
    *  REQD:     b490.prem_amt, b490.ann_tsi_amt     *
    *            b490.ann_prem_amt                   *
    *            b480.tsi_amt, b480.prem_amt         *
    *            b480.ann_tsi_amt, b480.ann_prem_amt */
   var_type           VARCHAR2 (1);
   p_prem_amt         gipi_witmperl.prem_amt%TYPE;                                             -- supposed value of b490.prem_amt
   p2_ann_tsi_amt     gipi_witmperl.ann_tsi_amt%TYPE;                                       -- supposed value of b490.ann_tsi_amt
   p2_ann_prem_amt    gipi_witmperl.ann_prem_amt%TYPE;                                     -- supposed value of b490.ann_prem_amt
   po_tsi_amt         gipi_witmperl.tsi_amt%TYPE;                                                         --:= :b490.nbt_tsi_amt;
   po_prem_amt        gipi_witmperl.prem_amt%TYPE;                                                       --:= :b490.nbt_prem_amt;
   po_prem_rt         gipi_witmperl.prem_rt%TYPE;                                                         --:= :b490.nbt_prem_rt;
   i2_tsi_amt         gipi_witem.tsi_amt%TYPE;                                                  -- supposed value of b480.tsi_amt
   i2_prem_amt        gipi_witem.prem_amt%TYPE;                                                -- supposed value of b480.prem_amt
   i2_ann_tsi_amt     gipi_witem.ann_tsi_amt%TYPE;                                          -- supposed value of b480.ann_tsi_amt
   i2_ann_prem_amt    gipi_witem.ann_prem_amt%TYPE;                                        -- supposed value of b480.ann_prem_amt
   v_prem_amt         gipi_witmperl.prem_amt%TYPE;
   vo_prem_amt        gipi_witmperl.prem_amt%TYPE;
   v_prorate_prem     NUMBER (15, 5);                     --GIPI_WITMPERL.prem_amt%TYPE;  --variable for computed negated premium
   v_no_of_days       NUMBER;                                                                                                   --
   v_days_of_policy   NUMBER;
   v_line_cd          gipi_wpolbas.line_cd%TYPE;
   v_subline_cd       gipi_wpolbas.subline_cd%TYPE;
   v_iss_cd           gipi_wpolbas.iss_cd%TYPE;
   v_issue_yy         gipi_wpolbas.issue_yy%TYPE;
   v_pol_seq_no       gipi_wpolbas.pol_seq_no%TYPE;
   v_renew_no         gipi_wpolbas.renew_no%TYPE;
   v_eff_date         gipi_wpolbas.eff_date%TYPE;
   var_expiry_date    DATE;
   v_prorate_flag     gipi_wpolbas.prorate_flag%TYPE;
   v_comp_sw          gipi_wpolbas.comp_sw%TYPE;
BEGIN
   var_expiry_date := extract_expiry (p_par_id);

   FOR i IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, prorate_flag, NVL (comp_sw, 'N') comp_sw,
                    eff_date
               FROM gipi_wpolbas
              WHERE par_id = p_par_id)
   LOOP
      v_line_cd := i.line_cd;
      v_subline_cd := i.subline_cd;
      v_iss_cd := i.iss_cd;
      v_issue_yy := i.issue_yy;
      v_pol_seq_no := i.pol_seq_no;
      v_renew_no := i.renew_no;
      v_prorate_flag := i.prorate_flag;
      v_comp_sw := i.comp_sw;
      v_eff_date := i.eff_date;
      EXIT;
   END LOOP;

   IF p_peril_type IS NULL
   THEN
      FOR a1 IN (SELECT peril_type
                   FROM giis_peril
                  WHERE line_cd = v_line_cd AND (subline_cd = v_subline_cd OR subline_cd IS NULL) AND peril_cd = p_peril_cd)
      LOOP
         p_peril_type := a1.peril_type;
      END LOOP;
   END IF;

   var_type := p_peril_type;

   IF default_tag = '1'
   THEN
      v_prem_amt := default_prem;
   ELSIF default_tag = '2'
   THEN
      FOR amt IN (SELECT NVL (fixed_premium, 0) fix, NVL (si_deductible, 0) deduct, NVL (excess_rate, 0) excess,
                         NVL (loading_rate, 0) LOAD, NVL (discount_rate, 0) discount, NVL (additional_premium, 0) add_prem
                    FROM giis_tariff_rates_dtl
                   WHERE tariff_cd = p_tariff_cd)
      LOOP
         v_prem_amt :=
              (  (amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess / 100)))
               + ((amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess / 100))) * (amt.LOAD / 100))
              )
            - (  (  (amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess / 100)))
                  + ((amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess / 100))) * (amt.LOAD / 100))
                 )
               * (amt.discount / 100)
              )
            + amt.add_prem;
      END LOOP;
   ELSIF default_tag = '3'
   THEN
      FOR amt IN (SELECT NVL (fixed_premium, 0) FIXED
                    FROM giis_tariff_rates_dtl
                   WHERE tariff_cd = p_tariff_cd)
      LOOP
         v_prem_amt := amt.FIXED;
      END LOOP;
   END IF;

   IF NVL (v_prem_amt, 0) > NVL (p_tsi_amt, 0)
   THEN
      v_prem_amt := 0;
   END IF;

   vo_prem_amt := (NVL (po_prem_amt, 0));

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
                 --AND nvl(b250.endt_expiry_date,b250.expiry_date) >= v_eff_date
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

      -- compute for negated premium for records with premium <> 0
      IF NVL (a2.prem, 0) <> 0
      THEN
         v_prorate_prem := v_prorate_prem + (- (a2.prem / v_days_of_policy) * (v_no_of_days));
      END IF;
   -- computed negated premium is rounded off --
   -- v_prorate_prem := round(v_prorate_prem,2);
   END LOOP;

   -- ann prem amt will be zeroed out if computed negated premium is equal to the premium
   -- amount entered
   -- IF p_prem_amt = trunc(v_prorate_prem,2) THEN
   --    p_prem_amt := round(v_prorate_prem,2);
   -- END IF;
   --end of added script by bdarusin
   --*RESOLVE COMPUTATION IF OLD TSI AND OLD PREMIUM IS EQUAL TO ZERO *--
   p2_ann_tsi_amt := (NVL (p_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0) - NVL (po_tsi_amt, 0)); 
   -- Solve for the annualized tsi amount for perils
   p2_ann_prem_amt := (NVL (p_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));
   -- Solve for the annualized prem amount for perils
   i2_prem_amt := (NVL (i_prem_amt, 0) + NVL (v_prem_amt, 0)) - NVL (po_prem_amt, 0);
   -- Solve for the premium amount
   i2_ann_prem_amt := (NVL (i_ann_prem_amt, 0) + NVL (v_prem_amt, 0) - NVL (vo_prem_amt, 0));

   -- Solve for the annualized prem amount
   p_base_ann_prem_amt := NVL (p_tsi_amt, 0) - NVL (po_tsi_amt, 0);
   
   IF var_type = 'B'
   THEN
      i2_tsi_amt := (NVL (i_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
      -- Solve for the tsi amt for items
      i2_ann_tsi_amt := (NVL (i_ann_tsi_amt, 0) + NVL (p_tsi_amt, 0)) - NVL (po_tsi_amt, 0);
   -- Solve for the annualized tsi amount
   END IF;

   p_out_prem_amt := v_prem_amt;
   p_out_ann_prem_amt := p2_ann_prem_amt;
   p_out_ann_tsi_amt := p2_ann_tsi_amt;

--   :b480.prem_amt := i2_prem_amt;
--   :b480.ann_prem_amt := i2_ann_prem_amt;

   --   IF var_type = 'B'
--   THEN
--      :b480.tsi_amt := i2_tsi_amt;
--      :b480.ann_tsi_amt := i2_ann_tsi_amt;
--   END IF;

   /* Added By    : Grace
   ** Date        : March 18, 2002
   ** Description : The following codes are added to automatically set the ann_prem_amt
   **      to zero if the annual tsi = 0. The discrepancy is due to the rounding off of
   **      amounts.
   */
   IF (p_out_ann_prem_amt BETWEEN 0 AND .02) AND (p_out_ann_tsi_amt = 0)
   THEN
      p_out_ann_prem_amt := 0;
   END IF;
END;
/


