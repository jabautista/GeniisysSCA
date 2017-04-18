CREATE OR REPLACE PROCEDURE CPI.gipis097_when_val_peril (
   p_par_id               gipi_witmperl.par_id%TYPE,
   p_item_no              gipi_witmperl.item_no%TYPE,
   p_peril_cd             gipi_witmperl.peril_cd%TYPE,
   p_peril_type           giis_peril.peril_type%TYPE,
   p_rec_flag       OUT   gipi_witmperl.rec_flag%TYPE,
   p_prem_rt        IN OUT   gipi_witmperl.prem_rt%TYPE,
   p_tsi_amt        IN OUT   gipi_witmperl.tsi_amt%TYPE,
   p_ann_tsi_amt    OUT   gipi_witmperl.ann_tsi_amt%TYPE, 
   p_prem_amt       IN OUT   gipi_witmperl.prem_amt%TYPE,
   p_ann_prem_amt   OUT   gipi_witmperl.ann_prem_amt%TYPE,
   p_base_ann_prem_amt   OUT   gipi_witmperl.ann_prem_amt%TYPE, 
   p_ri_comm_rate   OUT   gipi_witmperl.ri_comm_rate%TYPE,
   p_ri_comm_amt    OUT   gipi_witmperl.ri_comm_amt%TYPE,
   p_base_amt       OUT   gipi_witmperl.base_amt%TYPE,
   p_no_of_days     OUT   gipi_witmperl.no_of_days%TYPE,
   p_aggregate_sw   OUT   gipi_witmperl.aggregate_sw%TYPE
)
IS
   dummy_perl_cd     NUMBER (5);
   sho_lov           BOOLEAN;
   expired_sw        VARCHAR2 (1);
   x                 VARCHAR2 (1);
   --p_prem_rt       gipi_witmperl.prem_rt%TYPE;                                                          --     := p_b490_prem_rt;
   --p_tsi_amt       gipi_witmperl.tsi_amt%TYPE;                                                          --     := p_b490_tsi_amt;
   --p_prem_amt      gipi_witmperl.prem_amt%TYPE;                                                         --    := p_b490_prem_amt;
   --i_tsi_amt           gipi_witem.tsi_amt%TYPE        := p_b480_tsi_amt;
   --i_ann_tsi_amt       gipi_witem.ann_tsi_amt%TYPE    := p_b480_ann_tsi_amt;
   --i_prem_amt          gipi_witem.prem_amt%TYPE       := p_b480_prem_amt;
   --i_ann_prem_amt      gipi_witem.ann_prem_amt%TYPE   := p_b480_ann_prem_amt;
   v_prorate         NUMBER;
   v_policy_id       gipi_itmperil.policy_id%TYPE;
   v_line_cd         gipi_polbasic.line_cd%TYPE;
   v_subline_cd      gipi_polbasic.subline_cd%TYPE;
   v_iss_cd          gipi_polbasic.iss_cd%TYPE;
   v_issue_yy        gipi_polbasic.issue_yy%TYPE;
   v_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE;
   v_renew_no        gipi_polbasic.renew_no%TYPE;
   v_eff_date        gipi_polbasic.eff_date%TYPE;
   v_prov_prem_pct   gipi_wpolbas.prov_prem_pct%TYPE;
   v_prov_prem_tag   gipi_wpolbas.prov_prem_tag%TYPE;
   var_expiry_date   DATE;
   v_message         VARCHAR2 (500);
   v_changed_tag     gipi_witem.changed_tag%TYPE; 
   v_to_date         gipi_witem.TO_DATE%TYPE;
   v_from_date       gipi_witem.from_date%TYPE;
   v_comp_sw         gipi_witem.comp_sw%TYPE;
   v_cursor_sw       VARCHAR2 (1) := 'N';
   v_item_tsi_amt    gipi_witem.tsi_amt%TYPE;
   v_item_prem_amt   gipi_witem.prem_amt%TYPE;
   v_item_ann_tsi_amt gipi_witem.ann_tsi_amt%TYPE;
   v_item_ann_prem_amt gipi_witem.ann_prem_amt%TYPE;
   v_dummy  NUMBER;
   v_prov_discount   NUMBER;
BEGIN

   FOR i IN (SELECT prov_prem_tag, prov_prem_pct
               FROM gipi_wpolbas
              WHERE par_id = p_par_id)
   LOOP
      v_prov_prem_tag := i.prov_prem_tag;
      v_prov_prem_pct := i.prov_prem_pct;
      EXIT;
   END LOOP;

   v_prov_discount := NVL (v_prov_prem_pct / 100, 1);
   
   IF NVL (v_prov_prem_tag, 'N') != 'Y'
   THEN
      v_prov_discount := 1;
   END IF; 

   IF NVL(p_tsi_amt, 0) <> 0 THEN 
     p_base_ann_prem_amt := (NVL (p_tsi_amt, 0) * NVL (p_prem_rt, 0) / 100) * v_prov_discount;
   ELSE 
     p_base_ann_prem_amt := p_prem_amt;
   END IF;

--     SELECT changed_tag, TO_DATE, from_date, comp_sw, tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt
--       INTO v_changed_tag, v_to_date, v_from_date, v_comp_sw, v_item_tsi_amt, v_item_prem_amt, v_item_ann_tsi_amt, v_item_ann_prem_amt
--       FROM gipi_witem
--      WHERE par_id = p_par_id AND item_no = p_item_no;

--     gipis097_compute_tsi (p_par_id,
--                           p_peril_cd, 
--                           p_peril_type,
--                           v_changed_tag,
--                           p_tsi_amt,
--                           p_prem_rt,
--                           p_ann_tsi_amt,
--                           p_ann_prem_amt,
--                           v_item_tsi_amt,
--                           v_item_prem_amt,
--                           v_item_ann_tsi_amt,
--                           v_item_ann_prem_amt,
--                           p_no_of_days,                                                                                 -- no of days
--                           v_to_date,
--                           v_from_date,
--                           v_comp_sw,
--                           NULL,
--                           v_dummy,
--                           v_dummy,
--                           v_dummy,
--                           v_dummy,
--                           p_base_ann_prem_amt
--                          );

   var_expiry_date := extract_expiry (p_par_id);

   SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_eff_date
     FROM gipi_wpolbas
    WHERE par_id = p_par_id;

--   IF :SYSTEM.record_status NOT IN ('QUERY', 'NEW')
--   THEN
--      IF :b240.pack_pol_flag = 'Y'
--      THEN
--         validate_allied (:b480.pack_line_cd,
--                          :b490.peril_cd,
--                          :b490.dsp_peril_type,
--                          :b490.dsp_basc_perl_cd,
--                          :b490.tsi_amt,
--                          :b490.prem_amt
--                         );
--      ELSE
--         validate_allied (:b240.line_cd,
--                          :b490.peril_cd,
--                          :b490.dsp_peril_type,
--                          :b490.dsp_basc_perl_cd,
--                          :b490.tsi_amt,
--                          :b490.prem_amt
--                         );
--      END IF;
--   END IF;
   IF v_iss_cd = giisp.v ('RI')
   THEN
      --MODIFIED BY DANNEL 031207 get the latest comm rate when endorsing peril for inward reinsurance
      BEGIN
         SELECT policy_id
           INTO v_policy_id
           FROM gipi_polbasic
          WHERE 1 = 1
            AND line_cd = v_line_cd
            AND subline_cd = v_subline_cd
            AND iss_cd = v_iss_cd --'RI' changed to v_iss_cd by robert SR 21750 03.02.16
            AND issue_yy = v_issue_yy
            AND pol_seq_no = v_pol_seq_no
            AND renew_no = v_renew_no -- added by robert SR 21750 03.02.16
            AND pol_flag <> '5'
            AND endt_seq_no IN ( 
                   SELECT MAX(endt_seq_no)
                     FROM gipi_polbasic
                    WHERE 1 = 1
                      AND line_cd = v_line_cd
                      AND subline_cd = v_subline_cd
                      AND iss_cd = v_iss_cd --'RI' changed to v_iss_cd by robert SR 21750 03.02.16
                      AND issue_yy = v_issue_yy
                      AND pol_seq_no = v_pol_seq_no
                      AND renew_no = v_renew_no -- added by robert SR 21750 03.02.16
                      AND (eff_date = SYSDATE OR eff_date < SYSDATE));
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      FOR d IN (SELECT ri_comm_rate
                  FROM gipi_itmperil
                 WHERE policy_id = v_policy_id AND line_cd = v_line_cd AND item_no = p_item_no AND peril_cd = p_peril_cd)
      LOOP
         p_ri_comm_rate := d.ri_comm_rate;
         p_ri_comm_amt := (NVL (p_ri_comm_rate, 0) * NVL (p_prem_amt, 0)) / 100;
         EXIT;
      END LOOP;
   END IF;

   /* This will default the annual tsi and annual premium.
   ** It will also initiate the value of the tsi, annualized figures and
   ** the premium on the item level.  It will also initiate the value of the
   ** figures on the peril level.
   ** Created by   : Ja-mes
   ** Date Created :
   ** Updated by   : Daphne
   ** Last Update  : 18 July 1997
   */
--   IF p_b490_ann_tsi_amt IS NULL
--   THEN
--      :b490.ann_tsi_amt := 0;
--      :b490.ann_prem_amt := 0;
--   END IF;

   /* Initialize the values of the figures on the item level with respect
   ** to the previous figures on the peril level.
   ** Created by   :  Ja-mes
   ** Date Created :
   */
   --p_b480_prem_amt := NVL (i_prem_amt, 0) - NVL (p_b490_prem_amt, 0);

   --   IF :control.sve_peril_type = 'B'
--   THEN
--      :b480.tsi_amt := NVL (i_tsi_amt, 0) - NVL (:b490.tsi_amt, 0);
--      :b480.ann_tsi_amt := NVL (i_ann_tsi_amt, 0) - NVL (:b490.nbt_tsi_amt, 0);
--   END IF;

   /* The computation of the annualized premium amount depends upon the
   ** condition when the endorsement has been tagged as prorated, one-year or
   ** short rate endorsement.
   ** Created by   : Ja-mes
   ** Date Created :
   ** Updated by   : Daphne
   ** Last Update  : 18 July 1997
   */
--   IF ((NVL (p_prem_rt, 0) = 0) AND (NVL (p_tsi_amt, 0) = 0))
--   THEN
--      IF v_b240_prorate_flag = '1'
--      THEN
--         IF v_b240_endt_expiry_date <= v_b240_eff_date
--         THEN
--            raise_application_error(-20001, 'Geniisys Exception#E#Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.');
--         ELSE
--             /*By Iris Bordey 08.26.2003
--            **Removed add_months operation for computaton of premium.  Replaced
--            **it instead of variables.v_days (see check_duration) for short term endt.
--            */
--            --check_duration(:b540.incept_date,ADD_MONTHS(:b540.incept_date,12));
--            v_prorate := TRUNC (v_b240_endt_expiry_date - v_b240_eff_date) / check_duration (v_b540_incept_date, v_b540_expiry_date);
--         --(ADD_MONTHS(:b540.incept_date,12) - :b540.incept_date);
--         END IF;

   --         p_b480_ann_prem_amt := NVL (i_ann_prem_amt, 0) - (NVL (p_prem_amt, 0) / v_prorate);
--      ELSIF v_b240_prorate_flag = '2'
--      THEN
--         --v_b480_ann_prem_amt := NVL (i_ann_prem_amt, 0) - NVL (p_prem_amt, 0);
--      --ELSE
--         --v_b480_ann_prem_amt := NVL (i_ann_prem_amt, 0) - (NVL (p_prem_amt, 0) / (NVL (v_b240_short_rt_percent, 1) / 100));
--      END IF;
--   --ELSE
--      --v_b480_ann_prem_amt := NVL (i_ann_prem_amt, 0) - (NVL (p_prem_rt, 0) * NVL (p_tsi_amt, 0) / 100);
--   END IF;
   p_prem_rt := 0;
   p_tsi_amt := 0;
   p_prem_amt := 0;
   p_ann_tsi_amt := NULL;
   p_ann_prem_amt := NULL;

   --ASI 071299 For Backward Endorsement and peril that will be changed check first if
   --           particular peril had been endorsed during previous endorsement and warn
   --           the user that the item will affect other posted endorsements
--   IF :GLOBAL.cg$back_endt = 'Y'
--   THEN
--      FOR pol IN (SELECT   '1'
--                      FROM gipi_itmperil b380, gipi_polbasic b250
--                     WHERE b250.line_cd = v_b240_line_cd
--                       AND b250.subline_cd = v_b240_subline_cd
--                       AND b250.iss_cd = v_b240_iss_cd
--                       AND b250.issue_yy = v_b240_issue_yy
--                       AND b250.pol_seq_no = v_b240_pol_seq_no
--                       AND b250.renew_no = v_b240_renew_no
--                       AND b250.policy_id = b380.policy_id
--                       AND b380.item_no = v_b480_item_no
--                       AND b380.peril_cd = v_b490_peril_cd
--                       AND b250.pol_flag IN ('1', '2', '3', 'X')
--                       AND TRUNC (b250.eff_date) > TRUNC (:b240.eff_date)
--                       --AND NVL(b250.endt_expiry_date,b250.expiry_date) >= :b240.eff_date
--                       AND TRUNC (DECODE (NVL (b250.endt_expiry_date, b250.expiry_date),
--                                          b250.expiry_date, variables.v_expiry_date,
--                                          b250.endt_expiry_date, b250.endt_expiry_date
--                                         )
--                                 ) >= v_b240_eff_date
--                  ORDER BY b250.eff_date DESC)
--      LOOP
--         msg_alert (   'This is a backward endorsement, any changes made with this item peril will affect '
--                    || 'all previous endorsement that has an effectivity date later than '
--                    || TO_CHAR (:b240.eff_date, 'fmMonth DD, YYYY')
--                    || ' .',
--                    'I',
--                    FALSE
--                   );
--         EXIT;
--      END LOOP;
--   END IF;

   -- get the amount from latest endt. record
   FOR a1 IN (SELECT   a.ann_tsi_amt ann_tsi_amt, a.ann_prem_amt ann_prem_amt, a.rec_flag rec_flag,
                       a.prem_rt prem_rt                                                                            -- lian 071101
                  FROM gipi_itmperil a, gipi_polbasic b
                 WHERE b.line_cd = v_line_cd
                   AND b.subline_cd = v_subline_cd
                   AND b.iss_cd = v_iss_cd
                   AND b.issue_yy = v_issue_yy
                   AND b.pol_seq_no = v_pol_seq_no
                   AND b.renew_no = v_renew_no
                   AND b.policy_id = a.policy_id
                   AND a.item_no = p_item_no
                   AND a.peril_cd = p_peril_cd
                   AND b.pol_flag IN ('1', '2', '3', 'X')
                   AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                   AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                      b.expiry_date, var_expiry_date,
                                      b.endt_expiry_date, b.endt_expiry_date
                                     )
                             ) >= TRUNC (v_eff_date)
                   AND NVL (b.endt_seq_no, 0) > 0
              ORDER BY b.eff_date DESC)
   LOOP
      /* ASI 102299 check if policy has an existing expired short term endorsement(s) */
      expired_sw := 'N';
      FOR sw IN (SELECT   '1'
                     FROM gipi_itmperil a, gipi_polbasic b
                    WHERE b.line_cd = v_line_cd
                      AND b.subline_cd = v_subline_cd
                      AND b.iss_cd = v_iss_cd
                      AND b.issue_yy = v_issue_yy
                      AND b.pol_seq_no = v_pol_seq_no
                      AND b.renew_no = v_renew_no
                      AND b.policy_id = a.policy_id
                      AND b.pol_flag IN ('1', '2', '3', 'X')
                      AND (a.prem_amt <> 0 OR a.tsi_amt <> 0)
                      AND a.item_no = p_item_no
                      AND a.peril_cd = p_peril_cd
                      AND NVL (b.endt_seq_no, 0) > 0
                      AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                      AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                         b.expiry_date, var_expiry_date,
                                         b.endt_expiry_date, b.endt_expiry_date
                                        )
                                ) < TRUNC (v_eff_date)
                 ORDER BY b.eff_date DESC)
      LOOP
         expired_sw := 'Y';
         EXIT;
      END LOOP;

      /* ASI 102299 for policy that does not have existing short term endorsements */
      IF a1.rec_flag != 'D'
      THEN
         p_rec_flag := 'C';
      END IF;

      IF NVL (expired_sw, 'N') = 'N'
      THEN
         p_ann_tsi_amt := a1.ann_tsi_amt;
         p_ann_prem_amt := a1.ann_prem_amt;
         p_prem_rt := a1.prem_rt;                                                                                 -- lian 071101
      ELSE
         --ASI 102199 extract ann_tsi_amt , ann_prem_amt of peril. Recomputation of annualized
         --    amounts is consider over getting the latest annualized amounts because
         --    of the short term endorsements
         extract_ann_amt (p_par_id, p_item_no, p_peril_cd, p_ann_tsi_amt, p_ann_prem_amt, p_rec_flag, v_message);

         IF v_message IS NOT NULL
         THEN
            raise_application_error (-20001, 'Geniisys Exception#E#' || v_message); 
         END IF;
      END IF;

      v_cursor_sw := 'Y';      
      EXIT;
   END LOOP;

   -- if peril is not existing in any endt. get it's amount from policy record
   -- regardless if it is the latest or not
   IF v_cursor_sw = 'N'
   THEN
      FOR a1 IN (SELECT   a.tsi_amt, a.ann_tsi_amt ann_tsi_amt, a.ann_prem_amt ann_prem_amt, a.rec_flag rec_flag, a.prem_rt prem_rt,
                          a.no_of_days no_of_days, a.base_amt base_amt, a.aggregate_sw aggregate_sw
                     FROM gipi_itmperil a, gipi_polbasic b
                    WHERE b.line_cd = v_line_cd
                      AND b.subline_cd = v_subline_cd
                      AND b.iss_cd = v_iss_cd
                      AND b.issue_yy = v_issue_yy
                      AND b.pol_seq_no = v_pol_seq_no
                      AND b.renew_no = v_renew_no
                      AND b.policy_id = a.policy_id
                      AND a.item_no = p_item_no
                      AND a.peril_cd = p_peril_cd
                      AND b.pol_flag IN ('1', '2', '3', 'X')
                      AND NVL (b.endt_seq_no, 0) = 0
                 ORDER BY b.eff_date DESC)
      LOOP
         IF a1.rec_flag != 'D'
         THEN
            p_rec_flag := 'C';
         END IF;

         p_ann_tsi_amt := a1.ann_tsi_amt;
         p_ann_prem_amt := a1.ann_prem_amt;
         p_prem_rt := a1.prem_rt;
--            IF variables.v_canvas_sw = 'Y'
--         THEN
         p_base_amt := a1.base_amt;
         p_no_of_days := a1.no_of_days;
         p_aggregate_sw := a1.aggregate_sw;
--         END IF;
         EXIT;
      END LOOP;
   END IF;

   -- for new peril
--   IF     :SYSTEM.record_status NOT IN ('NEW', 'QUERY')
--      AND :parameter.cursor_sw = 'N'
--      AND :control.nbt_perl_cd IS NOT NULL
--      AND :control.nbt_perl_cd != :b490.peril_cd
--   THEN
--      --:parameter.commit_sw := 'Y';                               --BETH enable deletion of records in bill and distribution table
--      --:b490.nbt_prem_amt := :b490.prem_amt;
--      --:b490.nbt_prem_rt := :b490.prem_rt;
--      --:b490.nbt_tsi_amt := :b490.tsi_amt;
--      :b490.prem_rt := 0;
--      :b490.tsi_amt := 0;
--      :b490.prem_amt := 0;
--      :b490.ann_tsi_amt := 0;
--      :b490.ann_prem_amt := 0;
--      :b490.ri_comm_rate := 0;
--      :b490.ri_comm_amt := 0;
--      :parameter.validate_sw := 'Y';
--      compute_tsi (:b490.tsi_amt,
--                   :b490.prem_rt,
--                   :b490.ann_tsi_amt,
--                   :b490.ann_prem_amt,
--                   :b480.tsi_amt,
--                   :b480.prem_amt,
--                   :b480.ann_tsi_amt,
--                   :b480.ann_prem_amt,
--                   :b240.prov_prem_pct,
--                   :b240.prov_prem_tag
--                  );
--      p_b490_rec_flag := 'A';
--      --:parameter.validate_sw := 'N';
--      --:b490.nbt_tsi_amt := NULL;
--   END IF;

   --   :parameter.cursor_sw := 'N';

   /* beth  010499
   ** if line cd is MC and peril_cd is CTPL assign default TSI amount
   ** this amount will be derived from giis_parameters(ctpl_peril_tsi)
   */
   IF     v_line_cd = giisp.v ('MOTOR CAR LINE CODE')
      AND p_peril_cd = giisp.n ('CTPL')
      AND (p_tsi_amt IS NULL OR p_tsi_amt = 0)
      --AND :SYSTEM.record_status != 'QUERY'
      --AND NVL (:control.nbt_perl_cd, 0) != :b490.peril_cd
      AND NVL (p_ann_tsi_amt, 0) = 0
   THEN
      BEGIN
         SELECT param_value_n
           INTO p_tsi_amt
           FROM giis_parameters
          WHERE param_name = 'CTPL_PERIL_TSI';

         SELECT changed_tag, TO_DATE, from_date, comp_sw
           INTO v_changed_tag, v_to_date, v_from_date, v_comp_sw
           FROM gipi_witem
          WHERE par_id = p_par_id AND item_no = p_item_no;

         -- :parameter.ctpl_sw := 'Y';
         gipis097_compute_tsi (p_par_id,
                               p_peril_cd,
                               p_peril_type,
                               v_changed_tag,
                               p_tsi_amt,
                               p_prem_rt,
                               p_ann_tsi_amt,
                               p_ann_prem_amt,
                               NULL,
                               NULL,
                               NULL,
                               NULL,
                               NULL,                                                                                 -- no of days
                               v_to_date,
                               v_from_date,
                               v_comp_sw,
                               NULL,
                               p_tsi_amt,
                               p_prem_amt,
                               p_ann_tsi_amt,
                               p_ann_prem_amt,
                               p_base_ann_prem_amt
                              );
         --:b490.nbt_tsi_amt := :b490.tsi_amt;
         p_prem_rt := 0;
         p_rec_flag := 'A';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20001, 'Geniisys Exception#I#No TSI Amount in Giis_Parameters');
         WHEN TOO_MANY_ROWS
         THEN
            raise_application_error (-20001, 'Geniisys Exception#I#Too Many TSI Amount in Giis_Parameters');
      END;
   END IF;

   IF NVL (p_tsi_amt, 0) = 0 AND NVL (p_prem_amt, 0) = 0 AND NVL (p_ann_tsi_amt, 0) = 0 AND v_iss_cd != giisp.v ('RI')
   --AND                                                                                                            --BETH 020399
     --  p_comp_rem IS NULL
   THEN
      FOR c1 IN (SELECT a.tarf_rate
                   FROM gipi_wfireitm b370, giis_tariff a
                  WHERE a.tarf_cd = b370.tarf_cd AND b370.item_no = p_item_no AND b370.par_id = p_par_id)
      LOOP
         p_prem_rt := NVL (c1.tarf_rate, 0);
         EXIT;
      END LOOP;
   END IF;

   IF     NVL (p_tsi_amt, 0) = 0
      AND NVL (p_prem_amt, 0) = 0
      AND NVL (p_prem_rt, 0) = 0
      AND NVL (p_ann_tsi_amt, 0) = 0
      AND v_iss_cd != giisp.v ('RI')
   --AND p_comp_rem IS NULL
   THEN
      FOR c1 IN (SELECT a.default_rate
                   FROM giis_peril a
                  WHERE NVL (default_tag, 'N') = 'Y' AND peril_cd = p_peril_cd AND line_cd = v_line_cd)
      LOOP
         p_prem_rt := NVL (c1.default_rate, 0);
         EXIT;
      END LOOP;
   END IF;
   
   p_prem_rt := NVL(p_prem_rt, 0);
   p_tsi_amt := NVL(p_tsi_amt, 0);
   p_ann_tsi_amt := NVL(p_ann_tsi_amt, 0); 
   p_prem_amt := NVL(p_prem_amt, 0);
   p_ann_prem_amt := NVL(p_ann_prem_amt, 0);
   p_ri_comm_rate := NVL(p_ri_comm_rate, 0);
   p_ri_comm_amt := NVL(p_ri_comm_amt, 0);
   p_rec_flag := NVL(p_rec_flag, 'A');  
   
----patterned in gipis038 for automatic population of warranties and clauses, issa@fpac
--   IF :SYSTEM.record_status IN ('NEW', 'INSERT')
--   THEN
--      DECLARE
--         alert_id    alert;
--         alert_but   NUMBER;
--      BEGIN
--         FOR a IN (SELECT '1'
--                     FROM giis_peril_clauses a
--                    WHERE a.line_cd = :b240.line_cd
--                      AND a.peril_cd = :b490.peril_cd
--                      AND NOT EXISTS (SELECT '1'
--                                        FROM gipi_wpolwc b
--                                       WHERE par_id = :b240.par_id AND b.line_cd = a.line_cd AND b.wc_cd = a.main_wc_cd))
--         LOOP
--            --message ('dito');message ('dito');
--            alert_id := FIND_ALERT ('WC_ALERT');
--            alert_but := SHOW_ALERT (alert_id);

--            IF alert_but = alert_button1
--            THEN
--               :b490.wc_sw := 'Y';
--            END IF;

--            EXIT;
--         END LOOP;
--      END;
--   END IF;
--i--
END;
/


