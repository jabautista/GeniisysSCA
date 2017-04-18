DROP PROCEDURE CPI.GIPIS065_VALIDATE_COV_PERIL;

CREATE OR REPLACE PROCEDURE CPI.GIPIS065_VALIDATE_COV_PERIL(
  p_par_id gipi_parlist.par_id%TYPE,
  p_item_no gipi_witmperl_grouped.item_no%TYPE,
  p_grouped_item_no gipi_witmperl_grouped.grouped_item_no%TYPE,
  p_peril_cd gipi_witmperl_grouped.peril_cd%TYPE,
  p_peril_type giis_peril.peril_type%TYPE,
  p_prem_rt IN OUT gipi_witmperl_grouped.prem_rt%TYPE,
  p_tsi_amt IN OUT gipi_witmperl_grouped.tsi_amt%TYPE,
  p_ann_tsi_amt IN OUT gipi_witmperl_grouped.ann_tsi_amt%TYPE,
  p_prem_amt IN OUT gipi_witmperl_grouped.prem_amt%TYPE,
  p_ann_prem_amt IN OUT gipi_witmperl_grouped.ann_prem_amt%TYPE,  
--  p_item_tsi_amt IN OUT gipi_witem.tsi_amt%TYPE,
--  p_item_ann_tsi_amt IN OUT gipi_witem.ann_tsi_amt%TYPE,
--  p_item_prem_amt IN OUT gipi_witem.prem_amt%TYPE,
--  p_item_ann_prem_amt IN OUT gipi_witem.ann_prem_amt%TYPE,
  p_rec_flag OUT gipi_witmperl_grouped.rec_flag%TYPE,
  p_aggregate_sw OUT gipi_witmperl_grouped.aggregate_sw%TYPE,
  p_base_amount OUT gipi_witmperl_grouped.base_amt%TYPE,
  p_ri_comm_rate IN OUT gipi_witmperl_grouped.ri_comm_rate%TYPE,
  p_ri_comm_amt IN OUT gipi_witmperl_grouped.ri_comm_amt%TYPE,
  p_back_endt IN VARCHAR2,
  p_message OUT VARCHAR2,
  p_message_type OUT VARCHAR2
)
IS
   expired_sw          VARCHAR2 (1);
   v_prem_rt           gipi_witmperl_grouped.prem_rt%TYPE      := p_prem_rt;
   v_tsi_amt           gipi_witmperl_grouped.tsi_amt%TYPE      := p_tsi_amt;
   v_prem_amt          gipi_witmperl_grouped.prem_amt%TYPE     := p_prem_amt;
   --i_tsi_amt           gipi_wgrouped_items.tsi_amt%TYPE        := p_item_tsi_amt;
   --i_ann_tsi_amt       gipi_wgrouped_items.ann_tsi_amt%TYPE    := p_item_ann_tsi_amt;
   --i_prem_amt          gipi_wgrouped_items.prem_amt%TYPE       := p_item_prem_amt;
   --i_ann_prem_amt      gipi_wgrouped_items.ann_prem_amt%TYPE   := p_item_ann_prem_amt;
   v_prorate           NUMBER;
       
   var_expiry_date DATE;   
   
   v_line_cd gipi_wpolbas.line_cd%TYPE;
   v_subline_cd gipi_wpolbas.subline_cd%TYPE; 
   v_iss_cd gipi_wpolbas.iss_cd%TYPE;
   v_issue_yy gipi_wpolbas.issue_yy%TYPE;
   v_pol_seq_no gipi_wpolbas.pol_seq_no%TYPE;
   v_renew_no gipi_wpolbas.renew_no%TYPE;
   v_prov_prem_pct gipi_wpolbas.prov_prem_pct%TYPE;
   v_prov_prem_tag gipi_wpolbas.prov_prem_tag%TYPE;
   v_prorate_flag gipi_wpolbas.prorate_flag%TYPE;
   v_expiry_date gipi_wpolbas.expiry_date%TYPE;
   v_endt_expiry_date gipi_wpolbas.endt_expiry_date%TYPE; 
   v_eff_date gipi_wpolbas.eff_date%TYPE;
   v_incept_date gipi_wpolbas.incept_date%TYPE;
   v_short_rt_percent gipi_wpolbas.short_rt_percent%TYPE;   
   
   v_cursor_sw          VARCHAR2(1) := 'N';
BEGIN
   p_message := 'SUCCESS';
   p_message_type := 'INFO';
   var_expiry_date := extract_expiry(p_par_id);                                                                                            --A.R.C. 10.18.2006   

   SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, prov_prem_pct, prov_prem_tag, 
          prorate_flag, expiry_date, endt_expiry_date, eff_date, incept_date, short_rt_percent
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_prov_prem_pct, v_prov_prem_tag, 
          v_prorate_flag, v_expiry_date, v_endt_expiry_date, v_eff_date, v_incept_date, v_short_rt_percent
     FROM gipi_wpolbas
    WHERE par_id = p_par_id;           

--         IF :SYSTEM.record_status != 'QUERY'
--         THEN
            /* This will default the annual tsi and annual premium.
            ** It will also initiate the value of the tsi, annualized figures and
            ** the premium on the item level.  It will also initiate the value of the
            ** figures on the peril level.
            ** Created by   : Ja-mes
            ** Date Created :
            ** Updated by   : Daphne
            ** Last Update  : 18 July 1997
            */
            IF p_ann_tsi_amt IS NULL
            THEN
               p_ann_tsi_amt := 0;
               p_ann_prem_amt := 0;
            END IF;

            /* Initialize the values of the figures on the item level with respect
            ** to the previous figures on the peril level.
            ** Created by   :  Ja-mes
            ** Date Created :
            */
            --p_item_prem_amt := NVL (i_prem_amt, 0) - NVL (p_prem_amt, 0);

--            IF p_peril_type = 'B'
--            THEN
--               p_item_tsi_amt := NVL (i_tsi_amt, 0) - NVL (p_tsi_amt, 0);
--               p_item_ann_tsi_amt := NVL (i_ann_tsi_amt, 0) - NVL (p_tsi_amt, 0);
--            END IF;

            /* The computation of the annualized premium amount depends upon the
            ** condition when the endorsement has been tagged as prorated, one-year or
            ** short rate endorsement.
            ** Created by   : Ja-mes
            ** Date Created :
            ** Updated by   : Daphne
            ** Last Update  : 18 July 1997
            */
            IF ((NVL (v_prem_rt, 0) = 0) AND (NVL (v_tsi_amt, 0) = 0))
            THEN
               IF v_prorate_flag = '1'
               THEN
                  IF v_endt_expiry_date <= v_eff_date
                  THEN
                     p_message := 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.';
                     p_message_type := 'ERROR';
                     RETURN;
                  ELSE
                      /*By Iris Bordey 08.26.2003
                     **Removed add_months operation for computaton of premium.  Replaced
                     **it instead of variables.v_days (see check_duration) for short term endt.
                     */
                     --check_duration(:b540.incept_date,ADD_MONTHS(:b540.incept_date,12));
                     v_prorate :=
                           TRUNC (v_endt_expiry_date - v_eff_date)
                           / check_duration (v_incept_date, v_expiry_date);
                  --(ADD_MONTHS(:b540.incept_date,12) - :b540.incept_date);
                  END IF;

                  --p_item_ann_prem_amt := NVL (i_ann_prem_amt, 0) - (NVL (v_prem_amt, 0) / v_prorate);
--               ELSIF v_prorate_flag = '2'
--               THEN
--                  p_item_ann_prem_amt := NVL (i_ann_prem_amt, 0) - NVL (v_prem_amt, 0);
--               ELSE
--                  p_item_ann_prem_amt :=
--                                             NVL (i_ann_prem_amt, 0)
--                                           - (NVL (v_prem_amt, 0) / (NVL (v_short_rt_percent, 1) / 100));
               END IF;
--            ELSE
--               p_item_ann_prem_amt := NVL (i_ann_prem_amt, 0) - (NVL (v_prem_rt, 0) * NVL (v_tsi_amt, 0) / 100);
            END IF;

            p_prem_rt := 0;
            p_tsi_amt := 0;
            p_prem_amt := 0;
            p_ann_tsi_amt := NULL;
            p_ann_prem_amt := NULL;

            --ASI 071299 For Backward Endorsement and peril that will be changed check first if
            --           particular peril had been endorsed during previous endorsement and warn
            --           the user that the item will affect other posted endorsements
            IF p_back_endt = 'Y'
            THEN
               FOR pol IN (SELECT   '1'
                               FROM gipi_itmperil_grouped b380, gipi_polbasic b250
                              WHERE b250.line_cd = v_line_cd
                                AND b250.subline_cd = v_subline_cd
                                AND b250.iss_cd = v_iss_cd
                                AND b250.issue_yy = v_issue_yy
                                AND b250.pol_seq_no = v_pol_seq_no
                                AND b250.renew_no = v_renew_no
                                AND b250.policy_id = b380.policy_id
                                AND b380.item_no = p_item_no
                                AND b380.grouped_item_no = p_grouped_item_no
                                AND b380.peril_cd = p_peril_cd
                                AND b250.pol_flag IN ('1', '2', '3', 'X')
                                AND TRUNC (b250.eff_date) > TRUNC (v_eff_date)
                                --AND NVL(b250.endt_expiry_date,b250.expiry_date) >= v_eff_date
                                AND TRUNC (DECODE (NVL (b250.endt_expiry_date, b250.expiry_date),
                                                   b250.expiry_date, var_expiry_date,
                                                   b250.endt_expiry_date, b250.endt_expiry_date
                                                  )
                                          ) >= v_eff_date
                           ORDER BY b250.eff_date DESC)
               LOOP
                  p_message := 'This is a backward endorsement, any changes made with this item peril will affect all previous endorsement that has an effectivity date later than '
                             || TO_CHAR (v_eff_date, 'fmMonth DD, YYYY') || ' .';
                  p_message_type := 'INFO';
               END LOOP;
            END IF;

            -- get the amount from latest endt. record
            FOR a1 IN (SELECT   a.ann_tsi_amt ann_tsi_amt, a.ann_prem_amt ann_prem_amt, a.rec_flag rec_flag, a.prem_rt prem_rt,
                                                                                                                    -- lian 071101
                                a.base_amt base_amt,                                                                --gmi 03/27/07
                                                    a.aggregate_sw agg_sw                                           --gmi 03/27/07
                           FROM gipi_itmperil_grouped a, gipi_polbasic b
                          WHERE b.line_cd = v_line_cd
                            AND b.subline_cd = v_subline_cd
                            AND b.iss_cd = v_iss_cd
                            AND b.issue_yy = v_issue_yy
                            AND b.pol_seq_no = v_pol_seq_no
                            AND b.renew_no = v_renew_no
                            AND b.policy_id = a.policy_id
                            AND a.item_no = p_item_no
                            AND a.grouped_item_no = p_grouped_item_no
                            AND a.peril_cd = p_peril_cd
                            AND b.pol_flag IN ('1', '2', '3', 'X')
                            --AND A.prem_rt      > 0 --lian 071201
                            AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                            --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(v_eff_date)
                            AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                               b.expiry_date, var_expiry_date,
                                               b.endt_expiry_date, b.endt_expiry_date
                                              )
                                      ) >= TRUNC (v_eff_date)
                            AND NVL (b.endt_seq_no, 0) > 0                                     -- to query records from endt. only
                       ORDER BY b.eff_date DESC)
            LOOP
               /* ASI 102299 check if policy has an existing expired short term endorsement(s) */
               expired_sw := 'N';
               
               FOR sw IN (SELECT   '1'
                              FROM gipi_itmperil_grouped a, gipi_polbasic b
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
                               AND a.grouped_item_no = p_grouped_item_no
                               AND a.peril_cd = p_peril_cd
                               AND NVL (b.endt_seq_no, 0) > 0
                               AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                               --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) < TRUNC(v_eff_date)
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
                  p_prem_rt := a1.prem_rt;                                                                    -- lian 071101
                  p_aggregate_sw := a1.agg_sw;                                                               -- gmi 03/27/07
                  p_base_amount := a1.base_amt;                                                              -- gmi 03/27/07
               ELSE
                  --ASI 102199 extract ann_tsi_amt , ann_prem_amt of peril. Recomputation of annualized
                  --    amounts is consider over getting the latest annualized amounts because
                  --    of the short term endorsements
                  extract_ann_amt(p_par_id, p_item_no, p_peril_cd, p_ann_tsi_amt, p_ann_prem_amt, p_rec_flag, p_message);
               END IF;

               --:parameter.cursor_sw := 'Y';
               v_cursor_sw := 'Y';
               EXIT;
            END LOOP;
            
            -- if peril is not existing in any endt. get it's amount from policy record
            -- regardless if it is the latest or not
            --IF :SYSTEM.record_status NOT IN ('NEW', 'QUERY') AND :parameter.cursor_sw = 'N'
            --THEN
            
            IF v_cursor_sw = 'N' THEN
               FOR a1 IN (SELECT   a.ann_tsi_amt ann_tsi_amt, a.ann_prem_amt ann_prem_amt, a.rec_flag rec_flag,
                                   a.prem_rt prem_rt,                                                              -- lian 071101
                                                     a.no_of_days no_of_days,                                     -- gmi 12/19/05
                                                                             a.base_amt base_amt,                 -- gmi 12/19/05
                                   a.aggregate_sw agg_sw                                                          -- gmi 12/19/05
                              FROM gipi_itmperil_grouped a, gipi_polbasic b
                             WHERE b.line_cd = v_line_cd
                               AND b.subline_cd = v_subline_cd
                               AND b.iss_cd = v_iss_cd
                               AND b.issue_yy = v_issue_yy
                               AND b.pol_seq_no = v_pol_seq_no
                               AND b.renew_no = v_renew_no
                               AND b.policy_id = a.policy_id
                               AND a.item_no = p_item_no
                               AND a.grouped_item_no = p_grouped_item_no
                               AND a.peril_cd = p_peril_cd
                               -- AND A.prem_rt      > 0 --lian 071201
                               AND b.pol_flag IN ('1', '2', '3', 'X')
                               --AND NVL (b.endt_seq_no, 0) = 0
                          ORDER BY b.eff_date DESC)
               LOOP
                  IF a1.rec_flag != 'D'
                  THEN
                     p_rec_flag := 'C';
                  END IF;
                  
                  p_ann_tsi_amt := a1.ann_tsi_amt;
                  p_ann_prem_amt := a1.ann_prem_amt;
                  p_prem_rt := a1.prem_rt;                                                                     -- lian 071101
                  p_aggregate_sw := a1.agg_sw;                                                                -- gmi 03/27/07
                  p_base_amount := a1.base_amt;                                                               -- gmi 03/27/07
                  EXIT;
               END LOOP;
            END IF;

            --END IF;

            -- for new peril
--            IF     :SYSTEM.record_status NOT IN ('NEW', 'QUERY')
--               AND :parameter.cursor_sw = 'N'
--               AND :cg$ctrl.nbt_perl_cd IS NOT NULL
--               AND :cg$ctrl.nbt_perl_cd != p_peril_cd
--            THEN
               --:parameter.commit_sw := 'Y';                      --BETH enable deletion of records in bill and distribution table
--               :cv001.nbt_prem_amt := p_prem_amt;
--               :cv001.nbt_prem_rt := p_prem_rt;
--               :cv001.nbt_tsi_amt := p_tsi_amt;
--               p_prem_rt := 0;
--               p_tsi_amt := 0;
--               p_prem_amt := 0;
--               p_ann_tsi_amt := 0;
--               p_ann_prem_amt := 0;
--               p_ri_comm_rate := 0;
--               p_ri_comm_amt := 0;
               --:parameter.validate_sw := 'Y';
               /*compute_tsi(p_tsi_amt,p_prem_rt,p_ann_tsi_amt,p_ann_prem_amt,
                           :gipi_wgr_i.tsi_amt,:gipi_wgr_i.prem_amt,:gipi_wgr_i.ann_tsi_amt,
                           :gipi_wgr_i.ann_prem_amt,v_prov_prem_pct,v_prov_prem_tag);*/
--               compute_tsi (p_tsi_amt,
--                            p_prem_rt,
--                            p_ann_tsi_amt,
--                            p_ann_prem_amt,
--                            p_item_tsi_amt,
--                            p_item_prem_amt,
--                            p_item_ann_tsi_amt,
--                            p_item_ann_prem_amt,
--                            v_prov_prem_pct,
--                            v_prov_prem_tag
--                           );
--               p_rec_flag := 'A';
               --:parameter.validate_sw := 'N';
               --:cv001.nbt_tsi_amt := NULL;
            --END IF;

            --:parameter.cursor_sw := 'N';

--            IF ((:cv001.dum_peril_cd) != (p_peril_cd))
--            THEN
--               deletion_process (:cv001.dum_peril_cd);
--               :cv001.dum_peril_cd := p_peril_cd;
--               p_prem_rt := 0;
--               p_tsi_amt := 0;
--               p_prem_amt := 0;
--               :cv001.nbt_tsi_amt := 0;
--               :cv001.nbt_prem_amt := 0;
--            END IF;
        -- END IF;

----------------------------------
         IF     NVL (p_tsi_amt, 0) = 0
            AND NVL (p_prem_amt, 0) = 0
            AND NVL (p_prem_rt, 0) = 0
            AND NVL (p_ann_tsi_amt, 0) = 0
            AND v_iss_cd != GIISP.V('ISS_CD_RI')
         THEN
            FOR c1 IN (SELECT a.default_rate
                         FROM giis_peril a
                        WHERE NVL (default_tag, 'N') = 'Y' AND peril_cd = p_peril_cd AND line_cd = v_line_cd)
            LOOP
               p_prem_rt := NVL (c1.default_rate, 0);
               EXIT;
            END LOOP;
         END IF;
     -- END IF;
   --END IF;
END;
/


