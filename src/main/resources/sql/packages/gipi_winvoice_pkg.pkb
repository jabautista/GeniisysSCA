CREATE OR REPLACE PACKAGE BODY CPI.gipi_winvoice_pkg
AS
   FUNCTION get_gipi_winvoice (
      p_par_id     gipi_winvoice.par_id%TYPE,
      p_item_grp   gipi_winvoice.item_grp%TYPE
   )
      RETURN gipi_winvoice_tab PIPELINED
   IS
      v_winvoice   gipi_winvoice_type;
   BEGIN
      FOR i IN
         (SELECT a.par_id, a.item_grp, a.insured,    --f.item_title property,
                                                 a.property, a.takeup_seq_no,
                 a.multi_booking_mm,
                 TO_CHAR (TO_DATE (a.multi_booking_mm, 'MM'),
                          'MM'
                         ) multi_booking_mm_num,
                 a.multi_booking_yy,
                 TO_CHAR
                        (TO_DATE ((   a.multi_booking_mm
                                   || '-'
                                   || a.multi_booking_yy
                                  ),
                                  'mm-rrrr'
                                 ),
                         'fmMON-rrrr'
                        ) multi_booking_date,
                 a.ref_inv_no, a.policy_currency, a.payt_terms,
                 e.no_of_takeup, b.payt_terms_desc, b.no_of_payt, a.due_date,
                 a.other_charges, a.tax_amt, a.prem_amt, a.prem_seq_no,
                 c.currency_desc, a.remarks, a.ri_comm_amt,
                 NVL (a.pay_type, 'A') pay_type, a.card_name, a.card_no,
                 d.expiry_date wpolbas_expiry_date, a.expiry_date,
                 d.eff_date eff_date, d.incept_date, a.approval_cd,
                 a.ri_comm_vat, a.changed_tag,
                   NVL (a.prem_amt, 0)
                 + NVL (a.tax_amt, 0)
                 + NVL (a.other_charges, 0)
                 - NVL (a.ri_comm_amt, 0)
                 - NVL (a.ri_comm_vat, 0) amount_due,
                 a.bond_tsi_amt, a.bond_rate, b.no_of_days
            FROM gipi_winvoice a,
                 giis_payterm b,
                 giis_currency c                               --cris 02/11/10
                                ,
                 gipi_wpolbas d                            --cris 02/2/18/2010
                               ,
                 giis_takeup_term e                          --cris 02/24/2010
                                   ,
                 gipi_witem f
           WHERE f.par_id = d.par_id
             AND a.par_id = d.par_id
             AND a.par_id = p_par_id
             AND d.takeup_term = e.takeup_term
             AND a.item_grp = f.item_grp
             AND a.item_grp = p_item_grp
             AND NVL (a.payt_terms, 'COD') = b.payt_terms
             --comment cris 02/11/10
             AND a.currency_cd = c.main_currency_cd)   --comment cris 02/11/10
      LOOP
         v_winvoice.par_id := i.par_id;
         v_winvoice.item_grp := i.item_grp;
         v_winvoice.insured := i.insured;
         v_winvoice.property := i.property;
         v_winvoice.takeup_seq_no := i.takeup_seq_no;
         v_winvoice.multi_booking_mm := i.multi_booking_mm;
         v_winvoice.multi_booking_mm_num := i.multi_booking_mm_num;
         v_winvoice.multi_booking_yy := i.multi_booking_yy;
         v_winvoice.multi_booking_date := i.multi_booking_date;
         v_winvoice.ref_inv_no := i.ref_inv_no;
         v_winvoice.policy_currency := i.policy_currency;
         v_winvoice.payt_terms := i.payt_terms;
         v_winvoice.no_of_takeup := i.no_of_takeup;
         v_winvoice.payt_terms_desc := i.payt_terms_desc;
         -- comment cris 02/11/10
         v_winvoice.no_of_payt := i.no_of_payt;       --comment cris 02/11/10
         v_winvoice.due_date := i.due_date;
         v_winvoice.other_charges := i.other_charges;
         v_winvoice.tax_amt := i.tax_amt;
         v_winvoice.prem_amt := i.prem_amt;
         v_winvoice.prem_seq_no := i.prem_seq_no;
         v_winvoice.currency_desc := i.currency_desc;
--    v_winvoice.currency_desc        := i.currency_cd; --cris
         v_winvoice.remarks := i.remarks;
         v_winvoice.ri_comm_amt := i.ri_comm_amt;
         v_winvoice.pay_type := i.pay_type;
         v_winvoice.card_name := i.card_name;
         v_winvoice.card_no := i.card_no;
         v_winvoice.expiry_date := i.expiry_date;
         v_winvoice.wpolbas_expiry_date := i.wpolbas_expiry_date;
         v_winvoice.eff_date := i.eff_date;
         v_winvoice.incept_date := i.incept_date;
         v_winvoice.approval_cd := i.approval_cd;
         v_winvoice.ri_comm_vat := i.ri_comm_vat;
         v_winvoice.changed_tag := i.changed_tag;
         v_winvoice.amount_due := i.amount_due;
         v_winvoice.bond_tsi_amt := i.bond_tsi_amt;
         v_winvoice.bond_rate := i.bond_rate;
		 v_winvoice.no_of_days := i.no_of_days;
		 FOR A IN (SELECT ri_comm_rate
			        FROM gipi_witmperl
		   		   WHERE par_id = p_par_id)
		 LOOP           
			v_winvoice.ri_comm_rt := a.ri_comm_rate;
		 END LOOP;
        PIPE ROW (v_winvoice);
      END LOOP;
      RETURN;
   END get_gipi_winvoice;
   /**
   * Modified by: Emman 4.27.10
   * primarily used for obtaining invoice only
   */
   FUNCTION get_gipi_winvoice2 (p_par_id gipi_winvoice.par_id%TYPE)
      RETURN gipi_winvoice_tab2 PIPELINED
   IS
      v_winvoice   gipi_winvoice_type2;
   BEGIN
      FOR i IN (SELECT a.par_id, a.item_grp, a.takeup_seq_no,
                       a.multi_booking_mm, a.multi_booking_yy, a.insured
                  FROM gipi_winvoice a
                 WHERE a.par_id = p_par_id)
      LOOP
         v_winvoice.par_id := i.par_id;
         v_winvoice.item_grp := i.item_grp;
         v_winvoice.takeup_seq_no := i.takeup_seq_no;
         v_winvoice.multi_booking_mm := i.multi_booking_mm;
         v_winvoice.multi_booking_yy := i.multi_booking_yy;
         --v_winvoice.insured             := i.insured;
         FOR i IN (SELECT assd_no
                     FROM gipi_parlist
                    WHERE par_id = p_par_id)
         LOOP
            FOR a IN (SELECT a020.assd_name assd_name
                        FROM giis_assured a020
                       WHERE a020.assd_no = i.assd_no)
            LOOP
               v_winvoice.insured := a.assd_name;
               EXIT;
            END LOOP;
            EXIT;
         END LOOP;
         PIPE ROW (v_winvoice);
      END LOOP;
      RETURN;
   END get_gipi_winvoice2;
   FUNCTION get_gipi_winvoice3 (p_par_id gipi_winvoice.par_id%TYPE)
      RETURN gipi_winvoice_tab PIPELINED
   IS
      v_winvoice   gipi_winvoice_type;
	  v_input_vat_rate      giis_reinsurer.input_vat_rate%TYPE;
	  v_local_foreign_sw	giis_reinsurer.local_foreign_sw%TYPE;
	  v_compute_inw_vat		giis_parameters.param_value_v%TYPE;
      v_ri_cd               giis_issource.iss_cd%TYPE := giisp.v('ISS_CD_RI');
      v_line_cd             gipi_wpolbas.line_cd%TYPE; --added by steven 07.18.2014
      v_assd_no             gipi_wpolbas.assd_no%TYPE; --added by steven 07.18.2014
      v_monthly_takeup      VARCHAR2(1) := 'N'; --added by steven 07.18.2014
      v_old_vat_rate        giis_reinsurer.input_vat_rate%TYPE; -- Added by Jerome Bautista 05.03.2016 SR 22186
   BEGIN
      FOR i IN
         (SELECT   a.par_id, a.item_grp, a.insured,  --f.item_title property,
                                                   a.property,
                   a.takeup_seq_no, a.multi_booking_mm,
                   TO_CHAR
                          (TO_DATE (a.multi_booking_mm, 'MM'),
                           'MM'
                          ) multi_booking_mm_num,
                   a.multi_booking_yy,
                   /*TO_CHAR
                        (TO_DATE ((   a.multi_booking_mm
                                   || '-'
                                   || a.multi_booking_yy
                                  ),
                                  'mm-rrrr'
                                 ),
                         'fmMON-rrrr'
                        ) multi_booking_date,*/  
                   a.ref_inv_no, a.policy_currency, a.payt_terms,
                   e.no_of_takeup, b.payt_terms_desc, b.no_of_payt,
                   TRUNC (d.expiry_date, 'MON') wpolbas_expiry_date,
                   TRUNC (d.eff_date, 'MON') eff_date, a.due_date,
                   TRUNC (d.endt_expiry_date, 'MON') endt_expiry_date,
                   a.other_charges, a.tax_amt, a.prem_amt, a.prem_seq_no,
                   c.currency_desc,c.currency_rt, a.remarks, a.ri_comm_amt, d.iss_cd, --added by steven 07.22.2014 c.currency_rt
                   NVL (a.pay_type, 'A') pay_type, a.card_name, a.card_no,
                   a.expiry_date, d.incept_date, a.approval_cd,
                   d.eff_date eff_date2,
                   --a.ri_comm_vat,
                   a.changed_tag,
                     NVL (a.prem_amt, 0)
                   + NVL (a.tax_amt, 0)
                   + NVL (a.other_charges, 0)
                   - NVL (a.ri_comm_amt, 0)
                   - NVL (a.ri_comm_vat, 0) amount_due,
                   a.bond_tsi_amt, a.bond_rate,
                   a.ri_comm_vat,
                   d.line_cd, d.subline_cd, d.issue_yy, d.pol_seq_no, d.renew_no, d.pol_flag -- Added by Jerome Bautista 05.06.2016
                   /*(SELECT   (NVL (a.ri_comm_amt, 0) * NVL (input_vat_rate, 0)
                             )
                           / 100
                      FROM giri_winpolbas giri, giis_reinsurer giis
                     WHERE giri.ri_cd = giis.ri_cd AND par_id = a.par_id)
                                                                 ri_comm_vat*/ -- Nica 07.24.2012
              FROM gipi_winvoice a,
                   giis_payterm b,
                   giis_currency c,
                   gipi_wpolbas d,
                   giis_takeup_term e                                      --,
             --gipi_witem f
          WHERE                                          --f.par_id = d.par_id
                   /*AND */
                   a.par_id = d.par_id
               AND a.par_id = p_par_id
               AND NVL (d.takeup_term, 'ST') = e.takeup_term
                                                -- modified by tonio May 24, 2011
               --AND a.item_grp = f.item_grp
               AND NVL (a.payt_terms, 'COD') = b.payt_terms
               AND a.currency_cd = c.main_currency_cd
          GROUP BY a.par_id,
                   a.item_grp,
                   a.insured,                         --f.item_title property,
                   a.property,
                   a.takeup_seq_no,
                   a.multi_booking_mm,
                   a.ref_inv_no,
                   a.policy_currency,
                   a.payt_terms,
                   e.no_of_takeup,
                   b.payt_terms_desc,
                   b.no_of_payt,
                   eff_date,
                   a.due_date,
                   endt_expiry_date,
                   a.other_charges,
                   a.tax_amt,
                   a.prem_amt,
                   a.prem_seq_no,
                   c.currency_desc,
                   c.currency_rt,
                   a.remarks,
                   a.ri_comm_amt,
                   pay_type,
                   a.card_name,
                   a.card_no,
                   a.expiry_date,
                   d.incept_date,
                   a.approval_cd,
                   a.ri_comm_vat,
                   a.changed_tag,
                   a.bond_tsi_amt,
                   a.bond_rate,
                   a.multi_booking_yy,
                   d.expiry_date,
                   d.iss_cd,
                   d.line_cd, -- Added by Jerome Bautista 05.06.2016 SR 22186
                   d.subline_cd,    
                   d.issue_yy,
                   d.pol_seq_no,
                   d.renew_no,
                   d.pol_flag -- End of addition
          ORDER BY a.item_grp, a.takeup_seq_no)
      LOOP
         BEGIN
            IF i.property IS NULL
            THEN
               FOR a IN (SELECT item_title
                           FROM gipi_witem
                          WHERE par_id = p_par_id AND item_grp = i.item_grp)
               LOOP
                  IF i.property IS NULL
                  THEN
                     i.property := a.item_title;
                  ELSE
                     i.property := 'VARIOUS';
                     EXIT;
                  END IF;
               END LOOP;
            END IF;
         END;
         v_winvoice.par_id := i.par_id;
         v_winvoice.item_grp := i.item_grp;
         v_winvoice.insured := i.insured;
         v_winvoice.property := i.property;
         v_winvoice.takeup_seq_no := i.takeup_seq_no;
         /*v_winvoice.multi_booking_mm := i.multi_booking_mm;
         v_winvoice.multi_booking_mm_num := i.multi_booking_mm_num;
         v_winvoice.multi_booking_yy := i.multi_booking_yy;
         v_winvoice.multi_booking_date := i.multi_booking_date;*/
         v_winvoice.ref_inv_no := i.ref_inv_no;
         v_winvoice.policy_currency := i.policy_currency;
         v_winvoice.payt_terms := i.payt_terms;
         v_winvoice.no_of_takeup := i.no_of_takeup;
         v_winvoice.payt_terms_desc := i.payt_terms_desc;
         -- comment cris 02/11/10
         v_winvoice.no_of_payt := i.no_of_payt;        --comment cris 02/11/10
         --v_winvoice.due_date := i.due_date;
         v_winvoice.other_charges := i.other_charges;
         v_winvoice.tax_amt := i.tax_amt;
         v_winvoice.prem_amt := i.prem_amt;
         v_winvoice.prem_seq_no := i.prem_seq_no;
         v_winvoice.currency_desc := i.currency_desc;
         v_winvoice.currency_rt := i.currency_rt;
--    v_winvoice.currency_desc        := i.currency_cd; --cris
         v_winvoice.remarks := i.remarks;
         v_winvoice.ri_comm_amt := i.ri_comm_amt;
         v_winvoice.pay_type := i.pay_type;
         v_winvoice.card_name := i.card_name;
         v_winvoice.card_no := i.card_no;
         v_winvoice.expiry_date := i.expiry_date;
         v_winvoice.endt_expiry_date := i.endt_expiry_date;
         v_winvoice.wpolbas_expiry_date := i.wpolbas_expiry_date;
         v_winvoice.eff_date := i.eff_date;
         v_winvoice.incept_date := i.incept_date;
         v_winvoice.approval_cd := i.approval_cd;
         v_winvoice.ri_comm_vat := i.ri_comm_vat;
         v_winvoice.changed_tag := i.changed_tag;
         v_winvoice.amount_due := i.amount_due;
         v_winvoice.bond_tsi_amt := i.bond_tsi_amt;
         v_winvoice.bond_rate := i.bond_rate;
         --added by d.alcantara, 02-09-2012
         if i.due_date IS NULL THEN
            v_winvoice.due_date := i.eff_date2;
         ELSE
            v_winvoice.due_date := i.due_date;
         END IF;
         IF i.multi_booking_mm IS NULL THEN
             FOR j IN (
                SELECT booking_mth, booking_year, TO_CHAR
                          (TO_DATE (booking_mth, 'MM'),
                           'MM'
                          ) booking_mm_num
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id
             ) LOOP
                v_winvoice.multi_booking_mm := j.booking_mth;
                v_winvoice.multi_booking_mm_num := j.booking_mm_num;
                v_winvoice.multi_booking_yy := j.booking_year;
                v_winvoice.multi_booking_date := TO_CHAR
                        (TO_DATE ((   j.booking_mth
                                   || '-'
                                   || j.booking_year
                                  ),
                                  'mm-rrrr'
                                 ),
                         'fmMON-rrrr'
                        );
             END LOOP;
         ELSE
             v_winvoice.multi_booking_mm := i.multi_booking_mm;
             v_winvoice.multi_booking_mm_num := i.multi_booking_mm_num;
             v_winvoice.multi_booking_yy := i.multi_booking_yy;
             v_winvoice.multi_booking_date := TO_CHAR
                        (TO_DATE ((   i.multi_booking_mm
                                   || '-'
                                   || i.multi_booking_yy
                                  ),
                                  'mm-rrrr'
                                 ),
                         'fmMON-rrrr'
                        );
         END IF;
		 /* These lines added by: Nica 07.24.2012 - to compute ri_comm_vat and amount due*/
		 IF(i.iss_cd = v_ri_cd) THEN         
            BEGIN              
              SELECT param_value_v
         	  INTO  v_compute_inw_vat
  		      FROM giis_parameters
		     WHERE param_name = 'COMPUTE_INW_COMM_VAT';
            EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                NULL;
            END;
             FOR a IN (SELECT input_vat_rate, b.local_foreign_sw
                         FROM giri_winpolbas a, giis_reinsurer b
                        WHERE a.ri_cd = b.ri_cd
                          AND par_id  = p_par_id)
             LOOP           
                v_input_vat_rate 	:= a.input_vat_rate;
                v_local_foreign_sw  := a.local_foreign_sw;
             END LOOP;
             /*IF v_compute_inw_vat = 'N' THEN
         		IF v_winvoice.ri_comm_vat IS NULL THEN
         	  	    v_winvoice.ri_comm_vat := v_winvoice.ri_comm_amt * NVL(v_input_vat_rate,0)/100;
         		END IF;
             ELSE
         		IF v_winvoice.ri_comm_vat IS NULL AND v_local_foreign_sw = 'L' THEN
         			v_winvoice.ri_comm_vat := v_winvoice.ri_comm_amt * NVL(v_input_vat_rate,0)/100;
         		ELSE
         		    v_winvoice.ri_comm_vat := 0;        		
    		 	END IF;
             END IF;*/
			 --replaced by Nica 08.30.2012
             IF v_winvoice.ri_comm_vat IS NULL THEN
                v_winvoice.ri_comm_vat := v_winvoice.ri_comm_amt * NVL(v_input_vat_rate,0)/100; -- Added by Jerome Bautista 05.04.2016 SR 22186
                IF i.iss_cd = 'RI' THEN 
                    v_winvoice.ri_comm_vat := v_winvoice.ri_comm_amt * NVL(v_input_vat_rate,0)/100;
--                    IF i.pol_flag = '4' THEN							--commented out by Daniel Marasigan SR 22649
                        
--                        v_winvoice.ri_comm_amt := 0;
--                        v_winvoice.ri_comm_amt := v_winvoice.ri_comm_amt + i.ri_comm_amt;
                        
--                        FOR y IN (SELECT policy_id
--                                    FROM gipi_polbasic
--                                   WHERE line_cd = i.line_cd
--                                    AND subline_cd = i.subline_cd
--                                     AND iss_cd = i.iss_cd
--                                     AND issue_yy = i.issue_yy
--                                     AND pol_seq_no = i.pol_seq_no
--                                     AND renew_no = i.renew_no
--                                ORDER BY endt_seq_no ASC)
--                         LOOP  
--                            FOR x IN (SELECT ri_comm_vat, ri_comm_amt
--                                        FROM gipi_invoice
--                                       WHERE policy_id = y.policy_id)
--                            LOOP
--                                v_old_vat_rate := x.ri_comm_vat / x.ri_comm_amt * 100;
--                                v_winvoice.ri_comm_vat := x.ri_comm_vat;
                                
--                                IF v_winvoice.ri_comm_vat <> 0 THEN
--                                    v_winvoice.ri_comm_vat := v_winvoice.ri_comm_amt * NVL(v_old_vat_rate,0)/100;
--                                END IF;
--                            END LOOP;
--                         END LOOP;
--                    END IF;
                END IF; -- End of addition
                    -- v_winvoice.ri_comm_vat := v_winvoice.ri_comm_amt * NVL(v_input_vat_rate,0)/100;
                   v_winvoice.amount_due := i.amount_due - NVL(v_winvoice.ri_comm_vat, 0); -- irwin
              END IF;
          --   v_winvoice.amount_due := i.amount_due - NVL(v_winvoice.ri_comm_vat, 0);  moved inside the null condition of nica - irwin 9.3.2012
         ELSE
            v_winvoice.amount_due := i.amount_due;
         END IF;
         --added by steven 07.18.2014
         FOR a IN (SELECT place_cd, takeup_term
             FROM gipi_wpolbas
            WHERE par_id = p_par_id)
         LOOP
            FOR b IN (SELECT '1'
                        FROM giis_takeup_term b
                       WHERE b.takeup_term = a.takeup_term
                         AND b.takeup_term_desc LIKE 'MONTH%')
            LOOP
               v_monthly_takeup := 'Y';
               EXIT;
            END LOOP;
            EXIT;
         END LOOP;
         FOR pol IN (SELECT line_cd, assd_no
                        FROM gipi_wpolbas
                    WHERE par_id = p_par_id) 
         LOOP
            v_line_cd := pol.line_cd;
            v_assd_no := pol.assd_no;
            EXIT;
         END LOOP;
         BEGIN
           IF i.payt_terms IS NULL
           THEN
              BEGIN
                 SELECT c.payt_terms_desc,
                        c.no_of_payt,
                        c.payt_terms
                   INTO v_winvoice.payt_terms_desc,
                        v_winvoice.no_of_payt,
                        v_winvoice.payt_terms
                   FROM giis_intermediary a, giis_assured_intm b, giis_payterm c
                  WHERE a.intm_no = b.intm_no
                    AND b.line_cd = v_line_cd
                    AND b.assd_no = v_assd_no
                    AND a.payt_terms = c.payt_terms
                    AND v_monthly_takeup = 'N';
              EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                    SELECT payt_terms_desc,
                           no_of_payt
                      INTO v_winvoice.payt_terms_desc,
                           v_winvoice.no_of_payt
                      FROM giis_payterm
                     WHERE payt_terms = giisp.v('CASH ON DELIVERY');
              END;
           END IF;
         END;
         PIPE ROW (v_winvoice);
      END LOOP;
   END get_gipi_winvoice3;
   --added by steven 07.21.2014
    FUNCTION get_range_amt (
       p_tax_cd             /*NUMBER*/ giis_tax_charges.tax_cd%TYPE ,  
       p_tax_id             giis_tax_charges.tax_id%TYPE ,    
       p_par_id             /*NUMBER,*/ gipi_parlist.par_id%TYPE ,
       p_prem_amt           /*NUMBER,*/ gipi_winvoice.prem_amt%TYPE ,
       p_item_grp           gipi_winvoice.item_grp%TYPE,
       p_takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE,
       p_takeup_alloc_tag   /*VARCHAR2*/ giis_tax_charges.takeup_alloc_tag%TYPE 
    )
       RETURN NUMBER
    IS
       /* This function is used to get tax amount if tax type is RANGE. */
       v_currency_rt   gipi_winvoice.currency_rt%TYPE;
       v_tax_amt       gipi_winv_tax.tax_amt%TYPE;
       v_tsi_amt       gipi_wpolbas.tsi_amt%TYPE;
       v_count         NUMBER;
       v_takeup        gipi_winvoice.takeup_seq_no%TYPE;
       v_sum_premium   gipi_witmperl.prem_amt%TYPE;
       v_sum_tsi       gipi_witmperl.tsi_amt%TYPE;
       v_takeup_term   gipi_wpolbas.takeup_term%TYPE;
       v_line_cd       gipi_wpolbas.line_cd%TYPE;
       v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
       v_place_cd      gipi_wpolbas.place_cd%TYPE;
       v_eff_date      gipi_wpolbas.eff_date%TYPE;
       v_incept_date   gipi_wpolbas.incept_date%TYPE;
       v_issue_date    gipi_wpolbas.issue_date%TYPE; 
       v_tax_id        giis_tax_charges.tax_id%TYPE;
    BEGIN    
--       -- Get currency rate
       FOR a IN (SELECT DISTINCT currency_rt
                            FROM gipi_winvoice
                           WHERE par_id = p_par_id
                             AND item_grp = p_item_grp
                             AND takeup_seq_no = p_takeup_seq_no)
       LOOP
          v_currency_rt := a.currency_rt;
       END LOOP;
       /*added to correct the premium input on tax computation*/
       SELECT NVL (SUM (a.prem_amt), 0)
         INTO v_sum_premium
         FROM gipi_witmperl a, giis_peril b, gipi_witem c
        WHERE a.line_cd = b.line_cd
          AND a.peril_cd = b.peril_cd
          AND a.item_no = c.item_no
          AND a.par_id = c.par_id
          AND NVL (c.item_grp, 1) = p_item_grp
          AND a.par_id = p_par_id;
       /*ended edgar nobleza 08/23/2013*/
       --    Get the tax amt from GIIS_TAX_RANGE.
      -- BEGIN
       SELECT takeup_term,line_cd,iss_cd,place_cd,eff_date,incept_date,issue_date
            INTO v_takeup_term,v_line_cd,v_iss_cd,v_place_cd,v_eff_date,v_incept_date,v_issue_date
            FROM gipi_wpolbas
           WHERE par_id = p_par_id;
       /*  SELECT distinct a230.tax_id
		  INTO v_tax_id
			FROM giis_tax_issue_place a,giis_tax_charges a230
		 WHERE A230.line_cd = v_line_cd
			 AND A230.iss_cd = v_iss_cd
             AND A230.tax_cd = p_tax_cd
             AND A230.tax_id = p_tax_id
			 AND a.line_cd(+) = a230.line_cd
			 AND a.iss_cd(+) = a230.iss_cd
			 AND a.tax_cd(+) = a230.tax_cd
			 AND a.tax_id(+) = a230.tax_id --added edgar nobleza 08/23/2013
			 AND a.place_cd(+) = v_place_cd ;
			 AND a230.pol_endt_sw in ('B','P')
			 AND a230.expired_sw <> 'Y'
			 AND a230.tax_cd = p_tax_cd
			 AND ( ( NVL(v_eff_date, v_incept_date) between a230.eff_start_date and a230.eff_end_date AND NVL(a230.issue_date_tag,'N') = 'N'  ) 
			       OR(v_issue_date between a230.eff_start_date and a230.eff_end_date AND nvl(a230.issue_date_tag,'N') = 'Y' )			 		
					 ) */ -- commented out jhing 11.09.2014 
          BEGIN     
              SELECT tax_amount / NVL (v_currency_rt, 1)
                INTO v_tax_amt
                FROM giis_tax_range gtr
               WHERE 1 = 1
                 AND gtr.line_cd = v_line_cd
                 AND gtr.iss_cd = v_iss_cd
                 AND gtr.tax_id = p_tax_id /* v_tax_id -- jhing 11.09.2014 replaced variable with parameter*/
                 AND gtr.tax_cd = p_tax_cd
                 AND (v_sum_premium * NVL (v_currency_rt, 1))
                        BETWEEN min_value
                            AND max_value; 
           EXCEPTION
                WHEN NO_DATA_FOUND
                          THEN
                             raise_application_error
                                (-20001,
                                 'Geniisys Exception#E#No records exist for Tax Range in this line and issue source (GIIS_TAX_RANGE).'
                                );
           END;
          /*added condition for consideration of tax allocation edgar nobleza 082320138*/
          IF v_takeup_term = 'ST'
          THEN
             v_tax_amt := v_tax_amt;
          ELSE
             SELECT COUNT (DISTINCT takeup_seq_no)
               INTO v_count
               FROM gipi_winvoice
              WHERE par_id = p_par_id;
              -- jhing 11.09.2014 
               SELECT MAX (takeup_seq_no)
                  INTO v_takeup
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id; 
             IF v_takeup = 1 THEN   -- jhing 11.09.2014 
                 v_tax_amt := v_tax_amt;
             ELSIF p_takeup_alloc_tag = 'S' 
             THEN
                IF p_takeup_seq_no <> v_takeup THEN 
                    --v_tax_amt := v_tax_amt / v_count;
                    v_tax_amt := ROUND(v_tax_amt / v_takeup,2);
                ELSE
                     v_tax_amt := v_tax_amt -(ROUND(v_tax_amt / v_takeup,2) * (v_takeup - 1) );
                END IF;
             ELSIF p_takeup_alloc_tag = 'F'
             THEN
                /*SELECT MIN (takeup_seq_no)
                  INTO v_takeup
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id;*/ -- jhing 11.09.2014 commented out
                IF p_takeup_seq_no = 1 --v_takeup  -- jhing 11.09.2014
                THEN
                   v_tax_amt := v_tax_amt;
                ELSE
                   v_tax_amt := 0;
                END IF;
             ELSIF p_takeup_alloc_tag = 'L'
             THEN
                /*SELECT MAX (takeup_seq_no)
                  INTO v_takeup
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id;*/ -- jhing 11.09.2014 commented out 
                IF p_takeup_seq_no = v_takeup
                THEN
                   v_tax_amt := v_tax_amt;
                ELSE
                   v_tax_amt := 0;
                END IF;
             END IF;
          END IF;
          /*ended edgar nobleza 08/23/2013*/
          RETURN v_tax_amt;
      /* EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             raise_application_error
                (-20001,
                 'Geniisys Exception#E#No records exist for doc stamps in this line and issue source (GIIS_TAX_CHARGES).'
                ); */ -- jhing 11.09.2014 commented out
      -- END;
    END;
    --added by steven 08.15.2014
    FUNCTION get_rate_amt (
       p_tax_cd             /*NUMBER*/ giis_tax_charges.tax_cd%TYPE ,
       p_tax_id             giis_tax_charges.tax_id%TYPE,
       p_par_id             /*NUMBER,*/ gipi_parlist.par_id%TYPE ,   -- jhing 11.09.2014 modified declaration
       p_item_grp           gipi_winvoice.item_grp%TYPE,
       p_takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE
    )
       RETURN NUMBER
    IS
       /* This function is used to get tax amount if tax type is RATE. */
       v_prem_amt           gipi_witmperl.prem_amt%TYPE              := 0;
       v_tax_amt            gipi_winv_tax.tax_amt%TYPE;
       v_count              NUMBER;
       v_takeup             gipi_winvoice.takeup_seq_no%TYPE;
       v_sum_premium        gipi_witmperl.prem_amt%TYPE;
       v_sum_tsi            gipi_witmperl.tsi_amt%TYPE;
       v_line_cd            gipi_parlist.line_cd%TYPE;
       v_iss_cd             gipi_parlist.iss_cd%TYPE;
       v_place_cd           gipi_wpolbas.place_cd%TYPE;
       v_eff_date           gipi_wpolbas.eff_date%TYPE;
       v_incept_date        gipi_wpolbas.incept_date%TYPE;
       v_issue_date         gipi_wpolbas.issue_date%TYPE;
       v_takeup_term        gipi_wpolbas.takeup_term%TYPE;
       v_tax_id             giis_tax_charges.tax_id%TYPE;
       v_rate               giis_tax_charges.rate%TYPE;
       v_tax_amount         giis_tax_charges.tax_amount%TYPE;
       v_peril_sw           giis_tax_charges.peril_sw%TYPE;
       v_takeup_alloc_tag   giis_tax_charges.takeup_alloc_tag%TYPE;
       v_takeup_tax         gipi_winv_tax.tax_amt%TYPE ; -- jhing 11.09.2014 
       v_assd_no            gipi_parlist.assd_no%TYPE ; 
       v_vat_tag            giis_assured.vat_tag%TYPE ;
       v_evat               giac_parameters.param_value_n%TYPE := giacp.n('EVAT');
    BEGIN
       SELECT a.line_cd, a.iss_cd, a.assd_no, NVL(b.vat_tag,'3')  
         INTO v_line_cd, v_iss_cd, v_assd_no, v_vat_tag
         FROM gipi_parlist a, giis_assured b
        WHERE a.par_id = p_par_id
            AND a.assd_no = b.assd_no;
       SELECT place_cd, eff_date, incept_date, issue_date, takeup_term
         INTO v_place_cd, v_eff_date, v_incept_date, v_issue_date, v_takeup_term
         FROM gipi_wpolbas
        WHERE par_id = p_par_id;
       SELECT DISTINCT a230.tax_id, NVL (a.rate, a230.rate), NVL(a230.tax_amount,0) , -- jhing added NVL to tax_amount
                       NVL(a230.peril_sw,'N'), NVL(a230.takeup_alloc_tag,'F')   -- jhing added NVL to peril_sw, and takeup_alloc_tag
                  INTO v_tax_id, v_rate, v_tax_amount,
                       v_peril_sw, v_takeup_alloc_tag
                  FROM giis_tax_issue_place a, giis_tax_charges a230
                 WHERE a230.line_cd = v_line_cd
                   AND a230.iss_cd = v_iss_cd
                   AND a.line_cd(+) = a230.line_cd
                   AND a.iss_cd(+) = a230.iss_cd
                   AND a.tax_cd(+) = a230.tax_cd
                   AND a.tax_id(+) = a230.tax_id
                   AND a.place_cd(+) = v_place_cd
                  /* AND a230.pol_endt_sw IN ('B', 'P')
                   AND a230.expired_sw <> 'Y'  */ -- jhing 11.09.2014 
                   AND a230.tax_cd = p_tax_cd
                   AND a230.tax_id = p_tax_id ; -- jhing 11.09.2014
                   /*AND (   (    NVL (v_eff_date, v_incept_date)
                                   BETWEEN a230.eff_start_date
                                       AND a230.eff_end_date
                            AND NVL (a230.issue_date_tag, 'N') = 'N'
                           )
                        OR (    v_issue_date BETWEEN a230.eff_start_date
                                                         AND a230.eff_end_date
                            AND NVL (a230.issue_date_tag, 'N') = 'Y'
                           ) 
                       );*/ -- jhing 11.09.2014 commented out.
       /*added to correct the premium input on tax computation*/
       SELECT NVL (SUM (a.prem_amt), 0)
         INTO v_sum_premium
         FROM gipi_witmperl a, giis_peril b, gipi_witem c
        WHERE a.line_cd = b.line_cd
          AND a.peril_cd = b.peril_cd
          AND a.item_no = c.item_no
          AND a.par_id = c.par_id
          AND NVL (c.item_grp, 1) = p_item_grp
          AND a.par_id = p_par_id;
       IF p_tax_cd = v_evat and v_vat_tag in ( '1', '2' ) THEN  -- jhing 11.09.2014 automatically set tax to zero for zero rated and vat exempt
          v_tax_amt := 0 ; 
       -- Get tax amount depending on PERIL_SW
       ELSIF v_peril_sw = 'N'
       THEN
          v_tax_amt := NVL (v_rate, 0) * NVL ( /*p_amt*/v_sum_premium, 0)
                       / 100;
         -- commented out and moved the codes below for maintainability 
         /* IF v_takeup_term = 'ST'
          THEN
             v_tax_amt := v_tax_amt;
          ELSE
             SELECT COUNT (DISTINCT takeup_seq_no)
               INTO v_count
               FROM gipi_winvoice
              WHERE par_id = p_par_id;
             IF v_takeup_alloc_tag = 'S'
             THEN
                v_tax_amt := v_tax_amt / v_count;
             ELSIF v_takeup_alloc_tag = 'F'
             THEN
                SELECT MIN (takeup_seq_no)
                  INTO v_takeup
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id;
                IF p_takeup_seq_no = v_takeup
                THEN
                   v_tax_amt := v_tax_amt;
                ELSE
                   v_tax_amt := 0;
                END IF;
             ELSIF v_takeup_alloc_tag = 'L'
             THEN
                SELECT MAX (takeup_seq_no)
                  INTO v_takeup
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id;
                IF p_takeup_seq_no = v_takeup
                THEN
                   v_tax_amt := v_tax_amt;
                ELSE
                   v_tax_amt := 0;
                END IF;
             END IF;
          END IF;
          RETURN v_tax_amt; */
       ELSE
          FOR d IN (SELECT   SUM (NVL (a.prem_amt, 0)) prem_amt
                        FROM gipi_witmperl a, gipi_witem b
                       WHERE a.par_id = p_par_id
                         AND a.par_id = b.par_id
                         AND a.item_no = b.item_no
                         AND b.item_grp = p_item_grp
                         AND a.peril_cd IN (
                                SELECT peril_cd
                                  FROM giis_tax_peril
                                 WHERE line_cd = v_line_cd
                                   AND iss_cd = v_iss_cd
                                   AND tax_cd = p_tax_cd
                                   AND tax_id = v_tax_id)
                    GROUP BY b.item_grp, a.peril_cd)
          LOOP
             v_prem_amt := v_prem_amt + d.prem_amt;
          END LOOP;
          v_tax_amt := NVL (v_rate, 0) * NVL (v_prem_amt, 0) / 100;
          -- jhing 11.09.2014 moved the codes to recompute tax based on takeup below 
          /*added condition for consideration of tax allocation edgar nobleza 08232013*/
         /* IF v_takeup_term = 'ST'
          THEN
             v_tax_amt := v_tax_amt;
          ELSE
             SELECT COUNT (DISTINCT takeup_seq_no)
               INTO v_count
               FROM gipi_winvoice
              WHERE par_id = p_par_id;
             IF v_takeup_alloc_tag = 'F'
             THEN
                SELECT MIN (takeup_seq_no)
                  INTO v_takeup
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id;
                IF p_takeup_seq_no = v_takeup
                THEN
                   v_tax_amt := v_tax_amt;
                ELSE
                   v_tax_amt := 0;
                END IF;
             ELSIF v_takeup_alloc_tag = 'L'
             THEN
                SELECT MAX (takeup_seq_no)
                  INTO v_takeup
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id;
                IF p_takeup_seq_no = v_takeup
                THEN
                   v_tax_amt := v_tax_amt;
                ELSE
                   v_tax_amt := 0;
                END IF;*/
             --END IF;
          END IF; 
          --  jhing 11.09.2014 recompute tax amount based on takeup allocation 
          SELECT MAX (takeup_seq_no)
                  INTO v_takeup
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id;
          IF  v_takeup = 1 THEN            
            v_takeup_tax := v_tax_amt ;
          ELSIF ( v_takeup_alloc_tag = 'L' AND p_takeup_seq_no =  v_takeup )
                OR ( v_takeup_alloc_tag = 'F' AND p_takeup_seq_no =  1 )  THEN
            v_takeup_tax := v_tax_amt;    
          ELSIF v_takeup_alloc_tag = 'S' AND p_takeup_seq_no <>  v_takeup THEN         
            v_takeup_tax := ROUND(v_tax_amt / v_takeup,2) ;
          ELSIF v_takeup_alloc_tag = 'S' AND p_takeup_seq_no =  v_takeup THEN         
            v_takeup_tax := v_tax_amt - ( ROUND(v_tax_amt / v_takeup,2) * (v_takeup - 1 ) ) ; 
          ELSE
            v_takeup_tax := 0 ; 
          END IF;
          RETURN /*v_tax_amt -- replaced by jhing 11.09.2014 */ v_takeup_tax ; 
       --END IF;
    END;
  /* added by jhing 11.07.2014 */ 
   FUNCTION get_DocStamps_TaxAmt (
      p_tax_cd             giis_tax_charges.tax_cd%TYPE ,
      p_tax_id             giis_tax_charges.tax_id%TYPE,
      p_par_id             gipi_wpolbas.par_id%TYPE,
      p_prem_amt           gipi_winvoice.prem_amt%TYPE,
      p_item_grp           gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE,
      p_takeup_alloc_tag   giis_tax_charges.takeup_alloc_tag%TYPE 
    )
       RETURN NUMBER
    IS
       v_param_pa_dst  giis_parameters.param_value_v%TYPE := NVL(giisp.v('COMPUTE_PA_DOC_STAMPS'),'1' ); 
       v_param_old_dst giis_parameters.param_value_v%TYPE := NVL(giisp.v('COMPUTE_OLD_DOC_STAMPS') ,'Y' ); 
       v_param_ac_line giis_parameters.param_value_v%TYPE := giisp.v('LINE_CODE_AH') ; 
       v_menu_line_cd  giis_line.menu_line_cd%TYPE ;
       v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
       v_line_cd       giis_line.line_cd%TYPE; 
       v_rate          giis_tax_charges.rate%TYPE ; 
       v_place_cd      gipi_wpolbas.place_cd%TYPE;
       v_tax_amount    gipi_winv_tax.tax_amt%TYPE ; 
       v_peril_sw      giis_tax_charges.peril_sw%TYPE;
       v_tax_type      giis_tax_charges.tax_type%TYPE; 
       v_computed_dst  gipi_winv_tax.tax_amt%TYPE ; 
       v_sum_tsi       gipi_wpolbas.tsi_amt%TYPE ; 
       v_sum_prem      gipi_wpolbas.prem_amt%TYPE ;
       v_currency_rt   gipi_winvoice.currency_rt%TYPE;
       v_max_takeup    gipi_winvoice.takeup_seq_no%TYPE; 
       v_takeup_tax    gipi_winvoice.tax_amt%TYPE ; 
       CURSOR get_taxcharge (
          p_line_cd    giis_tax_charges.line_cd%TYPE,
          p_iss_cd     giis_tax_charges.iss_cd%TYPE,
          p_place_cd   gipi_wpolbas.place_cd%TYPE
       )
       IS
          SELECT DISTINCT a.tax_cd, a.tax_id, NVL(a.tax_type,'R') tax_type, a.tax_amount,
                          NVL(a.peril_sw,'N') peril_sw, NVL (b.rate, NVL (a.rate, 0)) rate
                     FROM giis_tax_charges a, giis_tax_issue_place b
                    WHERE a.line_cd = p_line_cd
                      AND a.iss_cd = p_iss_cd
                      AND a.tax_cd = p_tax_cd
                      AND a.tax_id = p_tax_id
                      AND a.tax_cd = b.tax_cd(+)
                      AND a.tax_id = b.tax_id(+)
                      AND a.line_cd = b.line_cd(+)
                      AND a.iss_cd = b.iss_cd(+)
                      AND b.place_cd(+) = p_place_cd;
       CURSOR compute_tsi
       IS
          SELECT SUM (NVL (a.tsi_amt, 0)) tsi_amt
            FROM gipi_witmperl a, gipi_witem b, giis_peril c
           WHERE a.par_id = b.par_id
             AND a.item_no = b.item_no
             AND a.line_cd = c.line_cd
             AND a.peril_cd = c.peril_cd
             AND c.peril_type = 'B'
             AND a.par_id = p_par_id
             AND b.item_grp = p_item_grp;   
       CURSOR compute_prem
       IS
          SELECT SUM (NVL (a.prem_amt, 0)) prem_amt
            FROM gipi_witmperl a, gipi_witem b
           WHERE a.par_id = b.par_id
             AND a.item_no = b.item_no
             AND a.par_id = p_par_id
             AND b.item_grp = p_item_grp; 
       CURSOR compute_peril_dep_prem (
                  p_line_cd    giis_tax_charges.line_cd%TYPE,
                  p_iss_cd     giis_tax_charges.iss_cd%TYPE
       )
       IS
          SELECT SUM (a.prem_amt) prem_amt
            FROM gipi_witmperl a, giis_tax_peril b, gipi_witem c
           WHERE a.line_cd = b.line_cd
             AND a.peril_cd = b.peril_cd
             AND a.par_id = c.par_id
             AND a.item_no = c.item_no
             AND c.item_grp = p_item_grp
             AND a.par_id = p_par_id
             AND b.tax_cd = p_tax_cd
             AND b.line_cd = p_line_cd
             AND b.iss_cd = p_iss_cd
             AND b.tax_id = p_tax_id;    
    BEGIN
       FOR cur in (SELECT a.place_cd , a.iss_cd, a.line_cd, b.menu_line_cd , NVL(c.currency_rt,1) currency_rt
                FROM gipi_wpolbas a, giis_line b , gipi_winvoice c 
                WHERE a.par_id = p_par_id
                AND a.line_cd = b.line_cd
                AND a.par_id = c.par_id
                AND c.item_grp = p_item_grp
                AND c.takeup_seq_no = p_takeup_seq_no )
       LOOP
            v_place_cd := cur.place_cd ;
            v_line_cd  := cur.line_cd ;
            v_iss_cd   := cur.iss_cd; 
            v_menu_line_cd := cur.menu_line_cd ; 
            v_currency_rt := cur.currency_rt;        
       END LOOP;
       FOR tax in get_taxcharge (v_line_cd , v_iss_cd, v_place_cd)
       LOOP
           v_rate := tax.rate ;
           v_tax_type := tax.tax_type;
           v_tax_amount  := tax.tax_amount;   
           v_peril_sw := tax.peril_sw;        
       END LOOP;   
       v_max_takeup := 1; 
       FOR takeup in (SELECT MAX(takeup_seq_no) max_takeup FROM gipi_winvoice 
                        WHERE par_id = p_par_id 
                          AND item_grp = p_item_grp ) 
       LOOP
        v_max_takeup := takeup.max_takeup ;
       END LOOP;    
       v_computed_dst := 0 ; 
       IF v_tax_type = 'N' AND (v_menu_line_cd = 'AC' OR (v_menu_line_cd IS NULL and v_line_cd = v_param_ac_line ) ) AND v_param_pa_dst = '3' 
       THEN
             v_sum_tsi := 0 ; 
             FOR curx in compute_tsi
             LOOP
                v_sum_tsi := NVL(curx.tsi_amt,0) /** v_currency_rt  -- jhing 11.18.2014 commented out */  ; 
             END LOOP;
             v_computed_dst := 0 ; 
             BEGIN
                  SELECT tax_amount / v_currency_rt
                    INTO v_computed_dst
                    FROM giis_tax_range
                   WHERE line_cd = v_line_cd
                     AND iss_cd = v_iss_cd
                     AND tax_cd = p_tax_cd
                     AND tax_id = p_tax_id
                     AND (v_sum_tsi * v_currency_rt) BETWEEN min_value AND max_value;
             EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                         raise_application_error
                            (-20001,
                             'Geniisys Exception#E#No records exist for doc stamps in this line and issue source (GIIS_TAX_CHARGES).'
                            );
             END;           
       ELSE
           -- compute the premium amount per item group ( peril dependency should be considered )
           v_sum_prem := 0 ; 
           IF v_peril_sw = 'Y' THEN
             FOR curPrem in compute_peril_dep_prem ( v_line_cd, v_iss_cd )
             LOOP
                v_sum_prem := NVL(curPrem.prem_amt,0) /* * v_currency_rt  -- jhing 11.18.2014 commented out */ ; 
             END LOOP;           
           ELSE
             FOR curPrem in compute_prem 
             LOOP
                v_sum_prem := NVL(curPrem.prem_amt,0) /* * v_currency_rt  -- jhing 11.18.2014 commented out */; 
             END LOOP;  
           END IF;   
           -- compute the docstamps based on parameter values 
           IF (v_menu_line_cd = 'AC' OR (v_menu_line_cd IS NULL and v_line_cd = v_param_ac_line ) ) 
           THEN
                IF v_param_pa_dst = '2' THEN -- old docstamps 
                   IF  v_sum_prem > 0 THEN 
                       v_computed_dst := CEIL (v_sum_prem / 200) * (0.5);   
                   ELSE
                       v_computed_dst := FLOOR (v_sum_prem / 200) * (0.5);   
                   END IF;
                ELSIF  v_param_pa_dst = '1' THEN   -- rate 
                   v_computed_dst := ROUND( v_sum_prem * ( v_rate / 100) , 2 ) ;                       
                ELSE
                   IF v_param_old_dst = 'Y'
                   THEN             
                      IF v_sum_prem > 0 THEN
                        v_computed_dst := CEIL (v_sum_prem / 200) * (0.5);
                      ELSE
                        v_computed_dst := FLOOR (v_sum_prem / 200) * (0.5);
                      END IF; 
                   ELSE
                      v_computed_dst := ROUND( v_sum_prem * ( v_rate / 100) , 2 ) ;    
                   END IF;
                END IF; 
           ELSE                       
                IF v_param_old_dst = 'Y'
                THEN
                   IF v_sum_prem > 0 THEN 
                     v_computed_dst := CEIL (v_sum_prem / 4) * (0.5);
                   ELSE
                     v_computed_dst := FLOOR (v_sum_prem / 4) * (0.5);
                   END IF; 
                ELSE
                   v_computed_dst := ROUND( v_sum_prem * ( v_rate / 100) , 2 ) ;                      
                END IF;               
           END IF; 
       END IF; 
       -- consider takeup in the returned tax amount
     IF  v_max_takeup = 1 THEN            
        v_takeup_tax := v_computed_dst ;
     ELSIF ( p_takeup_alloc_tag = 'L' AND p_takeup_seq_no =  v_max_takeup )
                OR ( p_takeup_alloc_tag = 'F' AND p_takeup_seq_no =  1 )  THEN
        v_takeup_tax := v_computed_dst;    
     ELSIF p_takeup_alloc_tag = 'S' AND p_takeup_seq_no <>  v_max_takeup THEN         
        v_takeup_tax := ROUND(v_computed_dst / v_max_takeup,2) ;
     ELSIF p_takeup_alloc_tag = 'S' AND p_takeup_seq_no =  v_max_takeup THEN         
        v_takeup_tax := v_computed_dst - ( ROUND(v_computed_dst / v_max_takeup,2) * (v_max_takeup - 1 ) ) ; 
     ELSE
        v_takeup_tax := 0 ;       
     END IF; 
     RETURN v_takeup_tax ; 
    END;   
   FUNCTION get_Fixed_Amount_Tax (
      p_tax_cd             giis_tax_charges.tax_cd%TYPE ,
      p_tax_id             giis_tax_charges.tax_id%TYPE,
      p_par_id             gipi_wpolbas.par_id%TYPE,
      p_prem_amt           gipi_winvoice.prem_amt%TYPE,
      p_tax_amt            giis_tax_charges.tax_amount%TYPE,
      p_item_grp           gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE,
      p_takeup_alloc_tag   giis_tax_charges.takeup_alloc_tag%TYPE 
    )
       RETURN NUMBER
    IS
       v_computed_tax  gipi_winv_tax.tax_amt%TYPE ; 
       v_currency_rt   gipi_winvoice.currency_rt%TYPE := 1 ;
       v_max_takeup    gipi_winvoice.takeup_seq_no%TYPE; 
       v_takeup_tax    gipi_winvoice.tax_amt%TYPE ;  
       v_tax_amount    giis_tax_charges.tax_amount%TYPE := p_tax_amt ; 
       v_prem_amt      gipi_winvoice.prem_amt%TYPE;        
       v_main_tax_amt  giis_tax_charges.tax_amount%TYPE;             
    BEGIN
       FOR inv in ( SELECT nvl(currency_rt, 1 ) currency_rt 
                        FROM gipi_winvoice 
                            WHERE par_id = p_par_id 
                                AND item_grp = p_item_grp
                                AND takeup_seq_no = p_takeup_seq_no )
       LOOP
            v_currency_rt := inv.currency_rt; 
       END LOOP;
      SELECT NVL (SUM (a.prem_amt), 0)
         INTO v_prem_amt
         FROM gipi_witmperl a, giis_peril b, gipi_witem c
        WHERE a.line_cd = b.line_cd
          AND a.peril_cd = b.peril_cd
          AND a.item_no = c.item_no
          AND a.par_id = c.par_id
          AND NVL (c.item_grp, 1) = p_item_grp
          AND a.par_id = p_par_id;
       FOR cur2 in (SELECT NVL(a.tax_amount,0) tax_amount 
            FROM giis_tax_charges a, gipi_wpolbas b
                WHERE b.par_id = p_par_id
                    AND a.line_cd = b.line_cd
                    AND a.iss_cd = b.iss_cd
                    AND a.tax_cd = p_tax_cd
                    AND a.tax_id = p_tax_id )
       LOOP
            v_tax_amount := cur2.tax_amount;
       END LOOP;   
       v_computed_tax := ROUND( v_tax_amount / v_currency_rt * sign(v_prem_amt), 2 ) ; 
       v_max_takeup := 1; 
       FOR takeup in (SELECT MAX(takeup_seq_no) max_takeup FROM gipi_winvoice 
                        WHERE par_id = p_par_id 
                          AND item_grp = p_item_grp ) 
       LOOP
        v_max_takeup := takeup.max_takeup ;
       END LOOP;   
       -- consider takeup in the returned tax amount
     IF  v_max_takeup = 1 THEN            
        v_takeup_tax := v_computed_tax ;
     ELSIF ( p_takeup_alloc_tag = 'L' AND p_takeup_seq_no =  v_max_takeup )
                OR ( p_takeup_alloc_tag = 'F' AND p_takeup_seq_no =  1 )  THEN
        v_takeup_tax := v_computed_tax;    
     ELSIF p_takeup_alloc_tag = 'S' AND p_takeup_seq_no <>  v_max_takeup THEN         
        v_takeup_tax := ROUND(v_computed_tax / v_max_takeup,2) ;
     ELSIF p_takeup_alloc_tag = 'S' AND p_takeup_seq_no =  v_max_takeup THEN         
        v_takeup_tax := v_computed_tax - ( ROUND(v_computed_tax / v_max_takeup,2) * (v_max_takeup - 1 ) ) ; 
     ELSE
        v_takeup_tax := 0 ;       
     END IF; 
     RETURN v_takeup_tax ; 
   END;   
   -- added by jhing 11.11.2014 
   FUNCTION get_Comp_TaxAmt (
      p_tax_cd             giis_tax_charges.tax_cd%TYPE ,
      p_tax_id             giis_tax_charges.tax_id%TYPE,
      p_par_id             gipi_wpolbas.par_id%TYPE,
      p_item_grp           gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE      
    )
       RETURN NUMBER 
    IS
    v_doc_stamps    giac_parameters.param_value_n%TYPE := giacp.n('DOC_STAMPS');
    v_evat_taxCd    giac_parameters.param_value_n%TYPE := giacp.n('EVAT');             
    v_expect_tax_amt gipi_winv_tax.tax_amt%TYPE ;
    v_tax_type           giis_tax_charges.tax_type%TYPE ;
    v_tax_amount         giis_tax_charges.tax_amount%TYPE ;
    v_par_type           gipi_parlist.par_type%TYPE;      
    v_vat_tag            giis_assured.vat_tag%TYPE;     
    v_line_cd            gipi_parlist.line_cd%TYPE;
    v_iss_cd             gipi_parlist.iss_cd%TYPE;      
    v_takeup_alloc_tag   giis_tax_charges.takeup_alloc_tag%TYPE ;
    BEGIN
       FOR v1 IN (SELECT NVL (b.vat_tag, 3) vat_tag , c.par_type, c.line_cd, c.iss_cd
                    FROM giis_assured b, gipi_parlist c 
                   WHERE b.assd_no = c.assd_no 
                         AND c.par_id = p_par_id)
       LOOP
          v_vat_tag := v1.vat_tag;
          v_par_type := v1.par_type;
          v_line_cd := v1.line_cd;
          v_iss_cd   := v1.iss_cd;
       END LOOP;
       v_expect_tax_amt := 0 ;        
       IF p_tax_cd = v_evat_taxCd AND v_vat_tag IN ('1','2') THEN
            v_expect_tax_amt := 0 ; 
       ELSE
            FOR giisTxChrg in ( SELECT NVL(tax_type,'R') taxType , NVL(takeup_alloc_tag,'F') takeup_alloc_tag
                            FROM giis_tax_charges 
                                WHERE iss_cd = v_iss_cd
                                    AND line_cd = v_line_cd
                                    AND tax_cd = p_tax_cd
                                    AND tax_id = p_tax_id)
            LOOP
                v_tax_type := giisTxChrg.taxType;   
                v_takeup_alloc_tag :=  giisTxChrg.takeup_alloc_tag;  
                EXIT;
            END LOOP;
            IF p_tax_cd = v_doc_stamps THEN                 
                  v_expect_tax_amt := get_DocStamps_TaxAmt  (   p_tax_cd  ,
                                               p_tax_id , p_par_id  , 0 ,  p_item_grp   ,
                                               p_takeup_seq_no, v_takeup_alloc_tag  ) ;                        
            ELSE
                IF v_tax_type = 'A' THEN
                   v_expect_tax_amt := get_Fixed_Amount_Tax (   p_tax_cd  ,p_tax_id ,p_par_id  ,
                                               0, 0 ,p_item_grp   ,p_takeup_seq_no, v_takeup_alloc_tag ) ;                             
                ELSIF v_tax_type = 'N' THEN
                   v_expect_tax_amt := get_range_amt(   p_tax_cd  , p_tax_id , p_par_id  ,
                                               0 , p_item_grp   , p_takeup_seq_no, v_takeup_alloc_tag ) ;
                ELSE
                   v_expect_tax_amt := get_rate_amt
                                           (   p_tax_cd  ,
                                               p_tax_id ,
                                               p_par_id  ,
                                               p_item_grp   ,
                                               p_takeup_seq_no
                                               ) ;        
                END IF;
            END IF;       
       END IF;         
       RETURN v_expect_tax_amt;
    END;   
   PROCEDURE set_gipi_winvoice (p_winvoice gipi_winvoice%ROWTYPE)
   IS
   	v_no_of_takeup  gipi_winvoice.no_of_takeup%type;
   BEGIN
      /*CALC_PAYMENT_SCHED_GIPIS026(p_winvoice.payt_terms,
                           p_winvoice.due_date,
                           p_winvoice.prem_amt,
                           p_winvoice.tax_amt,
                           p_winvoice.par_id,
                           p_winvoice.item_grp,
                            p_winvoice.takeup_seq_no);*/
	  -- added for no of takeup term - irwin 9.5.2012
    for pol in(select takeup_term from gipi_wpolbas where par_id = p_winvoice.par_id)		
    loop
        FOR b1 IN (SELECT no_of_takeup, yearly_tag
                   FROM GIIS_TAKEUP_TERM
                  WHERE takeup_term =pol.takeup_term)
      LOOP
        v_no_of_takeup := b1.no_of_takeup;
      END LOOP;
    end loop;	
      MERGE INTO gipi_winvoice
         USING DUAL
         ON (    par_id = p_winvoice.par_id
             AND item_grp = p_winvoice.item_grp
             AND takeup_seq_no = p_winvoice.takeup_seq_no
                                                         --added by cris 2/4/10
      )
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_grp, insured, property, takeup_seq_no,
                    multi_booking_mm, multi_booking_yy, ref_inv_no,
                    policy_currency, payt_terms, due_date, other_charges,
                    tax_amt, prem_amt, prem_seq_no, remarks, no_of_takeup,
                    ri_comm_amt, pay_type, card_name, card_no, expiry_date,
                    approval_cd, ri_comm_vat, changed_tag)
            VALUES (p_winvoice.par_id, p_winvoice.item_grp,
                    p_winvoice.insured, p_winvoice.property,
                    p_winvoice.takeup_seq_no, p_winvoice.multi_booking_mm,
                    p_winvoice.multi_booking_yy, p_winvoice.ref_inv_no,
                    p_winvoice.policy_currency, p_winvoice.payt_terms,
                    p_winvoice.due_date, p_winvoice.other_charges,
                    p_winvoice.tax_amt, p_winvoice.prem_amt,
                    p_winvoice.prem_seq_no, p_winvoice.remarks,
                    /*p_winvoice.no_of_takeup*/ v_no_of_takeup, p_winvoice.ri_comm_amt,
                    p_winvoice.pay_type, p_winvoice.card_name,
                    p_winvoice.card_no, p_winvoice.expiry_date,
                    p_winvoice.approval_cd, p_winvoice.ri_comm_vat,
                    p_winvoice.changed_tag)
         WHEN MATCHED THEN
            UPDATE
               SET insured = p_winvoice.insured,
                   property = p_winvoice.property,
                   -- takeup_seq_no     = p_winvoice.takeup_seq_no,
                   multi_booking_mm = p_winvoice.multi_booking_mm,
                   multi_booking_yy = p_winvoice.multi_booking_yy,
                   ref_inv_no = p_winvoice.ref_inv_no,
                   policy_currency = p_winvoice.policy_currency,
                   payt_terms = p_winvoice.payt_terms,
                   due_date = p_winvoice.due_date,
                   other_charges = p_winvoice.other_charges,
                   tax_amt = p_winvoice.tax_amt,
                   prem_amt = p_winvoice.prem_amt,
                   prem_seq_no = p_winvoice.prem_seq_no,
                   remarks = p_winvoice.remarks,
                   no_of_takeup = /*p_winvoice.no_of_takeup*/ v_no_of_takeup,
                   ri_comm_amt = p_winvoice.ri_comm_amt,
                   pay_type = p_winvoice.pay_type,
                   card_name = p_winvoice.card_name,
                   card_no = p_winvoice.card_no,
                   expiry_date = p_winvoice.expiry_date,
                   approval_cd = p_winvoice.approval_cd,
                   ri_comm_vat = p_winvoice.ri_comm_vat,
                   changed_tag = p_winvoice.changed_tag
            ;
   END set_gipi_winvoice;
   PROCEDURE del_gipi_winvoice (p_par_id IN gipi_winvoice.par_id%TYPE)
   IS
   --  p_item_grp        IN  GIPI_WINVOICE.item_grp%TYPE) IS
   BEGIN
      DELETE FROM gipi_winvoice
            WHERE par_id = p_par_id;
      --AND item_grp = p_item_grp;
     -- COMMIT; PASAWAY - irwin 12.5.11
   END del_gipi_winvoice;
   FUNCTION get_distinct_gipi_winvoice (p_par_id gipi_winvoice.par_id%TYPE)
      RETURN gipi_winvoice_tab PIPELINED
   IS
      v_winvoice   gipi_winvoice_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.par_id, a.item_grp, a.takeup_seq_no
                           FROM gipi_winvoice a
                          WHERE a.par_id = p_par_id)
      LOOP
         v_winvoice.par_id := i.par_id;
         v_winvoice.item_grp := i.item_grp;
         v_winvoice.takeup_seq_no := i.takeup_seq_no;
         PIPE ROW (v_winvoice);
      END LOOP;
      RETURN;
   END get_distinct_gipi_winvoice;
   /*
       Created by Cris
       Created on March 12, 2010
       Purpose: To update the payment terms whenever a new payment term is chosen
       This updated payment term will be used in computing the new payment schedule
       even without saving.
   */
   PROCEDURE update_paytterms_gipi_winvoice (
      p_par_id          gipi_winvoice.par_id%TYPE,
      p_item_grp        gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no   gipi_winvoice.takeup_seq_no%TYPE,
      p_payt_terms      gipi_winvoice.payt_terms%TYPE,
      p_tax_amt         gipi_winvoice.tax_amt%TYPE,
      p_other_charges   gipi_winvoice.other_charges%TYPE,
      p_due_date        gipi_winvoice.due_date%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_winvoice
         SET payt_terms = p_payt_terms,
             tax_amt = NVL (p_tax_amt, tax_amt),
             other_charges = NVL (p_other_charges, other_charges),
             due_date = NVL (p_due_date, due_date)
       WHERE par_id = p_par_id
         AND item_grp = p_item_grp
         AND takeup_seq_no = p_takeup_seq_no;
   END update_paytterms_gipi_winvoice;
   PROCEDURE get_gipi_winvoice_exist (
      p_par_id   IN       gipi_winvoice.par_id%TYPE,
      p_exist    OUT      NUMBER
   )
   IS
      v_exist   NUMBER := 0;
   BEGIN
      FOR a IN (SELECT 1
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id)
      LOOP
         v_exist := 1;
      END LOOP;
      p_exist := v_exist;
   END;
   PROCEDURE get_gipi_winvoice_exist2 (
      p_par_id   IN       gipi_winvoice.par_id%TYPE,
      p_exist    OUT      NUMBER
   )
   IS
      v_exist   NUMBER := 0;
   BEGIN
      FOR a IN (SELECT 1
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id AND property IS NOT NULL)
      LOOP
         v_exist := 1;
      END LOOP;
      p_exist := v_exist;
   END;
   /*
   **  Created by    : Mark JM
   **  Date Created  : 06.01.2010
   **  Reference By  : (GIPIS031 - Endt Basic Information)
   **  Description   : This procedure deletes record based on the given par_id
   */
   PROCEDURE del_gipi_winvoice1 (p_par_id IN gipi_winvoice.par_id%TYPE)
   IS
   BEGIN
      DELETE FROM gipi_winvoice
            WHERE par_id = p_par_id;
   END del_gipi_winvoice1;
/***************************************************************************/
/*
** Transfered by: whofeih
** Date: 06.10.2010
** for GIPIS050A
*/
   PROCEDURE create_gipi_winvoice (p_par_id IN NUMBER)
   IS
   BEGIN
      FOR d IN (SELECT par_id, quote_id, line_cd, iss_cd
                  FROM gipi_parlist
                 WHERE pack_par_id = p_par_id)
      LOOP
         FOR itmperil IN (SELECT '1'
                            FROM gipi_witmperl
                           WHERE par_id = d.par_id)
         LOOP
            create_winvoice (0, 0, 0, d.par_id, d.line_cd, d.iss_cd);
         END LOOP;
      END LOOP;
   END create_gipi_winvoice;
   FUNCTION get_winvoice_bond_dtls (
      p_par_id   gipi_winvoice.par_id%TYPE,
      p_iss_cd   VARCHAR2
   )
      RETURN gipi_winvoice_bond_tab PIPELINED
   IS
      blongterm   gipi_winvoice_bond_type;
   BEGIN
      --edited by d.alcantara, 08-09-2011
      -- moved here
      FOR j IN (SELECT input_vat_rate
                  FROM giri_winpolbas a, giis_reinsurer b
                 WHERE a.ri_cd = b.ri_cd AND par_id = p_par_id)
      LOOP
         blongterm.input_vat_rate := NVL (j.input_vat_rate, 0);
      END LOOP;
      FOR x IN (SELECT   bond_tsi_amt, bond_rate, SUM (prem_amt) prem_amt,
                         SUM (tax_amt) tax_amt, SUM (ri_comm_amt) ri_comm_amt,
                         SUM (ri_comm_vat) ri_comm_vat
                    FROM gipi_winvoice
                   WHERE par_id = p_par_id
                GROUP BY bond_tsi_amt, bond_rate)
      LOOP
         FOR i IN (SELECT ri_comm_rate
                     FROM gipi_witmperl
                    WHERE par_id = p_par_id)
         LOOP
            blongterm.ri_comm_rt := i.ri_comm_rate;
         END LOOP;
         IF p_iss_cd IN (giisp.v ('ISS_CD_RI'), 'RB')
         THEN
            blongterm.total_amount_due :=
                 NVL (x.prem_amt, 0)
               + NVL (x.tax_amt, 0)
               - NVL (x.ri_comm_amt, 0)
               - NVL (x.ri_comm_vat, 0);
         ELSE
            blongterm.total_amount_due :=
                                      NVL (x.prem_amt, 0)
                                      + NVL (x.tax_amt, 0);
         END IF;
         blongterm.bond_tsi_amt := x.bond_tsi_amt;
         blongterm.bond_rate := x.bond_rate;
         blongterm.prem_amt := x.prem_amt;
         blongterm.ri_comm_amt := x.ri_comm_amt;
         blongterm.ri_comm_vat := x.ri_comm_vat;
         blongterm.tax_amt := x.tax_amt;
      END LOOP;
      PIPE ROW (blongterm);
   END get_winvoice_bond_dtls;
/***************************************************************************/
/*
   **  Created by    :TONIO
   **  Reference By  : GIPIS017B
   **  Description   : This procedure deletes record based on the given par_id
   */
   PROCEDURE get_gipi_winvoice_takeup_dtls (
      p_par_id                  NUMBER,
      p_line_cd                 gipi_parlist.line_cd%TYPE,
      p_iss_cd                  gipi_parlist.iss_cd%TYPE,
      p_item_grp                gipi_winvoice.item_grp%TYPE,
      p_takeup_list    OUT      gipi_winvoice_pkg.rc_gipi_winvoice_cur,
      p_bond_tsi_amt   IN OUT   gipi_winvoice.bond_tsi_amt%TYPE,
      p_prem_amt       IN OUT   gipi_winvoice.prem_amt%TYPE,
      p_ri_comm_rt     IN OUT   NUMBER,
      p_bond_rate      IN OUT   gipi_winvoice.bond_rate%TYPE,
      p_ri_comm_amt    IN OUT   gipi_winvoice.ri_comm_amt%TYPE,
      p_ri_comm_vat    IN OUT   gipi_winvoice.ri_comm_vat%TYPE,
      p_tax_amt        IN OUT   gipi_winvoice.tax_amt%TYPE,
      p_message        OUT      VARCHAR2
   )
   IS
      v_var            gipi_winvoice_type;
      v_witem          VARCHAR2 (1)                          := 'N';
      v_witmperl       VARCHAR2 (1)                          := 'N';
      v_ricommvat      gipi_winvoice.ri_comm_vat%TYPE;
      v_curr_cd        giis_currency.main_currency_cd%TYPE;
      v_curr_rt        giis_currency.currency_rt%TYPE;
      v_peril_cd       giis_peril.peril_cd%TYPE;
      v_input_vat_rt   giis_reinsurer.input_vat_rate%TYPE;
   BEGIN
      FOR x IN (SELECT input_vat_rate
                  FROM giri_winpolbas a, giis_reinsurer b
                 WHERE a.ri_cd = b.ri_cd AND par_id = p_par_id)
      LOOP
         v_input_vat_rt := x.input_vat_rate;
      END LOOP;
      BEGIN
         SELECT a.main_currency_cd, a.currency_rt
           INTO v_curr_cd, v_curr_rt
           FROM giis_currency a, giac_parameters b
          WHERE b.param_value_v = a.short_name
            AND b.param_type = 'V'
            AND b.param_name = 'DEFAULT_CURRENCY';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
      /*BEGIN
         SELECT peril_cd
           INTO v_peril_cd
           FROM giis_peril
          WHERE line_cd = p_line_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;*/
      /*select statement converted into loop to fetch only 
        one peril_cd - Nica 05.15.2012*/
      FOR W IN (SELECT peril_cd, ri_comm_rt
                FROM GIIS_PERIL
                WHERE line_cd = p_line_cd)
      LOOP
        v_peril_cd := w.peril_cd ;
        EXIT;
      END LOOP;
      FOR x IN (SELECT 1
                  FROM gipi_witem
                 WHERE par_id = p_par_id)
      LOOP
         v_witem := 'Y';
         EXIT;
      END LOOP;
      FOR x IN (SELECT 1
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id)
      LOOP
         v_witmperl := 'Y';
         EXIT;
      END LOOP;
      IF v_witem = 'N'
      THEN
         INSERT INTO gipi_witem
                     (par_id, item_no, item_grp, item_title, tsi_amt,
                      prem_amt, currency_cd, currency_rt
                     )
              VALUES (p_par_id, 1, 1, 'BOND UNDERTAKING', p_bond_tsi_amt,
                      p_prem_amt, v_curr_cd, v_curr_rt
                     );
      ELSE
         UPDATE gipi_witem
            SET tsi_amt = p_bond_tsi_amt,
                prem_amt = p_prem_amt
          WHERE par_id = p_par_id;
      END IF;
      IF p_iss_cd IN (giisp.v ('ISS_CD_RI'), 'RB')
      THEN
         IF p_ri_comm_rt IS NULL
         THEN
            p_message := 'Please enter the RI commission rate.';
         END IF;
      END IF;
      IF v_witmperl = 'N'
      THEN
         INSERT INTO gipi_witmperl
                     (par_id, item_no, line_cd, peril_cd, discount_sw,
                      tsi_amt, prem_amt, prem_rt, ri_comm_rate,
                      ri_comm_amt
                     )
              VALUES (p_par_id, 1, p_line_cd, v_peril_cd, 'N', --marco - 10.11.2014 - changed hard-coded 'SU' to p_line_cd
                      p_bond_tsi_amt, p_prem_amt, p_bond_rate, p_ri_comm_rt,
                      p_ri_comm_amt
                     );
      ELSE
         UPDATE gipi_witmperl
            SET tsi_amt = p_bond_tsi_amt,
                prem_amt = p_prem_amt,
                prem_rt = p_bond_rate,
                ri_comm_rate = p_ri_comm_rt,
                ri_comm_amt = p_ri_comm_amt
          WHERE par_id = p_par_id;
      END IF;
     /*added edgar 10/29/2014 : Updates gipi_wpolbas ann_tsi_amt in preparation for CREATE_WINVOICE procedure. This codes are used for Unposted Bond PAR only.*/
        DECLARE
           v_line_cd       gipi_wpolbas.line_cd%TYPE;
           v_subline_cd    gipi_wpolbas.subline_cd%TYPE;
           v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
           v_issue_yy      gipi_wpolbas.issue_yy%TYPE;
           v_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE;
           v_renew_no      gipi_wpolbas.renew_no%TYPE;
           v_ann_tsi_amt   gipi_wpolbas.ann_tsi_amt%TYPE;
           v_eff_date      gipi_wpolbas.eff_date%TYPE;
        BEGIN
           SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                  renew_no, eff_date
             INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no,
                  v_renew_no, v_eff_date 
             FROM gipi_wpolbas
            WHERE par_id = p_par_id;
           FOR a IN (SELECT   ann_tsi_amt, ann_prem_amt, endt_seq_no
                       FROM gipi_polbasic b250
                      WHERE b250.line_cd = v_line_cd
                        AND b250.subline_cd = v_subline_cd
                        AND b250.iss_cd = v_iss_cd
                        AND b250.issue_yy = v_issue_yy
                        AND b250.pol_seq_no = v_pol_seq_no
                        AND b250.renew_no = v_renew_no
                        AND b250.pol_flag NOT IN ('4', '5')
                        AND TRUNC (b250.eff_date) =
                               TRUNC ((SELECT MAX (b2501.eff_date)
                                         FROM gipi_polbasic b2501
                                        WHERE b2501.line_cd = v_line_cd
                                          AND b2501.subline_cd = v_subline_cd
                                          AND b2501.iss_cd = v_iss_cd
                                          AND b2501.issue_yy = v_issue_yy
                                          AND b2501.pol_seq_no = v_pol_seq_no
                                          AND b2501.renew_no = v_renew_no
                                          AND b2501.pol_flag NOT IN ('4', '5')
                                          AND TRUNC (b2501.eff_date) <=
                                                 DECODE (NVL (b2501.endt_seq_no, 0),
                                                         0, TRUNC (b2501.eff_date),
                                                         TRUNC (v_eff_date)
                                                        )
                                          AND TRUNC (NVL (b2501.endt_expiry_date,
                                                          b2501.expiry_date
                                                         )
                                                    ) >=
                                                 DECODE (NVL (b2501.endt_seq_no, 0),
                                                         0, TRUNC (b2501.eff_date),
                                                         TRUNC (v_eff_date)
                                                        ))
                                     )
                   ORDER BY TRUNC (b250.eff_date) DESC, b250.endt_seq_no DESC)
           LOOP
              v_ann_tsi_amt := a.ann_tsi_amt + p_bond_tsi_amt;
              EXIT;
           END LOOP;
            UPDATE gipi_wpolbas
               SET ann_tsi_amt = v_ann_tsi_amt
             WHERE par_id = p_par_id;
        END;
     /*ended edgar 10/29/2014*/
      --COMMIT;
      create_winvoice (0, 0, 0, p_par_id, p_line_cd, p_iss_cd);
      OPEN p_takeup_list FOR
         SELECT *
           FROM TABLE (gipi_winvoice_pkg.get_gipi_winvoice (p_par_id,
                                                            p_item_grp
                                                           )
                      );
      UPDATE gipi_winvoice
         SET property = 'BONDS',
             payt_terms = 'COD',
             bond_tsi_amt = p_bond_tsi_amt,
             bond_rate = p_bond_rate,
             --tax_amt = 0,
             ri_comm_vat = (ri_comm_amt * NVL (v_input_vat_rt, 0)) / 100
       WHERE par_id = p_par_id;
      FOR x IN (SELECT   bond_tsi_amt, bond_rate, SUM (prem_amt) prem_amt,
                         SUM (tax_amt) tax_amt, SUM (ri_comm_amt) ri_comm_amt,
                         SUM (ri_comm_vat) ri_comm_vat
                    FROM gipi_winvoice
                   WHERE par_id = p_par_id
                GROUP BY bond_tsi_amt, bond_rate)
      LOOP
         p_bond_tsi_amt := x.bond_tsi_amt;
         p_bond_rate := x.bond_rate;
         p_prem_amt := x.prem_amt;
         p_ri_comm_amt := x.ri_comm_amt;
         p_ri_comm_vat := x.ri_comm_vat;
      --p_tax_amt := x.tax_amt;
      END LOOP;
      FOR c IN (SELECT item_grp, takeup_seq_no
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id)
      LOOP
         FOR l IN (SELECT SUM (tax_amt) tax
                     FROM gipi_winv_tax
                    WHERE par_id = p_par_id
                      AND item_grp = c.item_grp
                      AND takeup_seq_no = c.takeup_seq_no)
         LOOP
            UPDATE gipi_winvoice
               SET tax_amt = l.tax
             --     payt_terms    = :gipi_winvoice5.nbt_payt_terms --issa@fpac
            WHERE  par_id = p_par_id
               AND item_grp = c.item_grp
               AND takeup_seq_no = c.takeup_seq_no;
         END LOOP;
      END LOOP;
   --p_tax_amt := nvl(:CG$CTRL.SUM_TAX_AMT,0);
   END get_gipi_winvoice_takeup_dtls;
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 04, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This determines whether Package PAR's sub-policies have
**                   exisiting records in GIPI_WINVOICE.
*/
   PROCEDURE check_gipi_winvoice_for_pack (
      p_pack_par_id   IN       gipi_pack_parlist.pack_par_id%TYPE,
      p_exist         OUT      NUMBER
   )
   IS
      v_exist   NUMBER := 0;
   BEGIN
      FOR a IN (SELECT 1
                  FROM gipi_winvoice
                 WHERE EXISTS (
                          SELECT 1
                            FROM gipi_parlist z
                           WHERE z.par_id = gipi_winvoice.par_id
                             AND z.par_status NOT IN (98, 99)
                             AND z.pack_par_id = p_pack_par_id)
                   AND property IS NOT NULL)
      LOOP
         v_exist := 1;
      END LOOP;
      p_exist := v_exist;
   END check_gipi_winvoice_for_pack;
   PROCEDURE post_forms_commit_gipis026 (
      p_par_id                     gipi_parlist.par_id%TYPE,
      p_pack_par_id                gipi_parlist.pack_par_id%TYPE,
      p_global_pack_par_id         gipi_parlist.pack_par_id%TYPE,
      p_item_grp                   gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no              gipi_winvoice.takeup_seq_no%TYPE,
      p_ri_comm_vat                gipi_winvoice.ri_comm_vat%TYPE,
      p_version                    VARCHAR2 DEFAULT '1',
      p_due_date                   VARCHAR2,
      p_line_cd                    VARCHAR2,
      p_temp_inst_cur        OUT   gipi_winstallment_pkg.gipi_winstallment_cur,
      p_booking_yy                 gipi_wpolbas.booking_year%TYPE, --belle 09022012
      p_booking_mm                 gipi_wpolbas.booking_mth%TYPE       
   )
   IS
      p_exist            NUMBER                               := 0;
      v_iss_cd           gipi_wpolbas.iss_cd%TYPE;
      v_co_ins_sw        gipi_wpolbas.co_insurance_sw%TYPE;
      v_cnt              NUMBER;
      v_cnt1             NUMBER;
      v_cnt2             NUMBER;
      v_cnt3             NUMBER;
      v_type             gipi_parlist.par_type%TYPE;
      v_param            giis_parameters.param_value_n%TYPE;
      ---tonio 10/06/08
      v_parlist_iss_cd   gipi_parlist.iss_cd%TYPE;
      CURSOR a
      IS
         SELECT property
           FROM gipi_winvoice
          WHERE par_id = p_par_id
            AND item_grp = p_item_grp
            AND takeup_seq_no = p_takeup_seq_no;
   BEGIN
      --robert 10.17.2012 post_update gipi_winvoice5 block
      IF p_global_pack_par_id IS NOT NULL
       THEN
          FOR gw IN (SELECT   item_grp, takeup_seq_no, SUM (prem_amt) prem_amt,
                              SUM (tax_amt) tax_amt,
                              SUM (ri_comm_amt) ri_comm_amt,
                              SUM (other_charges) other_charges,
                              SUM (bond_tsi_amt) bond_tsi_amt,
                              SUM (ri_comm_vat) ri_comm_vat
                         FROM gipi_winvoice a
                        WHERE EXISTS (
                                 SELECT 1
                                   FROM gipi_parlist gp
                                  WHERE gp.par_id = a.par_id
                                    AND gp.pack_par_id = p_pack_par_id)
                     GROUP BY item_grp, takeup_seq_no)
          LOOP
             UPDATE gipi_pack_winvoice
                SET prem_amt = gw.prem_amt,
                    tax_amt = gw.tax_amt,
                    ri_comm_amt = gw.ri_comm_amt,
                    other_charges = gw.other_charges,
                    bond_tsi_amt = gw.bond_tsi_amt,
                    ri_comm_vat = gw.ri_comm_vat
              WHERE pack_par_id = p_pack_par_id AND item_grp = gw.item_grp;
          END LOOP;
          FOR gw IN (SELECT item_grp, payt_terms, prem_seq_no, 'VARIOUS' property,
                            insured, due_date, notarial_fee, currency_cd,
                            currency_rt, remarks, ref_inv_no, policy_currency,
                            bond_rate, pay_type, card_name, card_no, approval_cd,
                            expiry_date
                       FROM gipi_winvoice a
                      WHERE EXISTS (
                               SELECT 1
                                 FROM gipi_parlist gp
                                WHERE gp.par_id = a.par_id
                                  AND gp.pack_par_id = p_pack_par_id
                                  AND gp.par_id = p_par_id))
          LOOP
             UPDATE gipi_pack_winvoice
                SET payt_terms = gw.payt_terms,
                    prem_seq_no = gw.prem_seq_no,
                    property = gw.property,
                    insured = gw.insured,
                    due_date = gw.due_date,
                    notarial_fee = gw.notarial_fee,
                    currency_cd = gw.currency_cd,
                    currency_rt = gw.currency_rt,
                    remarks = gw.remarks,
                    ref_inv_no = gw.ref_inv_no,
                    policy_currency = gw.policy_currency,
                    bond_rate = gw.bond_rate,
                    pay_type = gw.pay_type,
                    card_name = gw.card_name,
                    card_no = gw.card_no,
                    approval_cd = gw.approval_cd,
                    expiry_date = gw.expiry_date
              WHERE pack_par_id = p_pack_par_id AND item_grp = gw.item_grp;
          END LOOP;
       END IF;
      --robert end 
      payt_term_computation (p_version,
                             p_due_date,
                             p_par_id,
                             p_line_cd,
                             p_temp_inst_cur
                            );
      FOR a1 IN a
      LOOP
         IF a1.property IS NULL
         THEN
            p_exist := 1;
         ELSE
            NULL;
         END IF;
      END LOOP;
      BEGIN
         SELECT iss_cd
           INTO v_parlist_iss_cd
           FROM gipi_parlist
          WHERE par_id = p_par_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
      IF p_exist = 1
      THEN
         UPDATE gipi_parlist
            SET par_status = 5
          WHERE par_id = p_par_id;
         IF p_global_pack_par_id IS NOT NULL
         THEN
            UPDATE gipi_pack_parlist
               SET par_status = 5
             WHERE pack_par_id = p_pack_par_id;
         END IF;
      ELSE
         UPDATE gipi_parlist
            SET par_status = 6
          WHERE par_id = p_par_id;
         IF p_global_pack_par_id IS NOT NULL
         THEN
            UPDATE gipi_pack_parlist
               SET par_status = 6
             WHERE pack_par_id = p_pack_par_id;
         END IF;
         FOR tp IN (SELECT par_type
                      FROM gipi_parlist
                     WHERE par_id = p_par_id)
         LOOP
            v_type := tp.par_type;
         END LOOP;
         IF v_type = 'P'
         THEN
            FOR ins IN (SELECT co_insurance_sw
                          FROM gipi_wpolbas
                         WHERE par_id = p_par_id)
            LOOP
               v_co_ins_sw := ins.co_insurance_sw;
            END LOOP;
         ELSE
            FOR ins IN (SELECT a.co_insurance_sw
                          FROM gipi_polbasic a, gipi_wpolbas b
                         WHERE a.line_cd = b.line_cd
                           AND a.subline_cd = b.subline_cd
                           AND a.iss_cd = b.iss_cd
                           AND a.issue_yy = b.issue_yy
                           AND a.pol_seq_no = b.pol_seq_no
                           AND a.renew_no = b.renew_no
                           AND a.endt_seq_no = 0
                           AND b.par_id = p_par_id)
            LOOP
               v_co_ins_sw := ins.co_insurance_sw;
            END LOOP;
         END IF;
         IF v_co_ins_sw = '2'
         THEN
            pop_main_inv_tax_gipis026 (p_par_id);
         END IF;
         SELECT COUNT (*) cnt
           INTO v_cnt
           FROM gipi_wcomm_invoices
          WHERE par_id = p_par_id;
         SELECT COUNT (*) cnt
           INTO v_cnt1
           FROM gipi_orig_comm_invoice
          WHERE par_id = p_par_id;
         SELECT COUNT (*)
           INTO v_cnt3
           FROM gipi_witem
          WHERE par_id = p_par_id AND rec_flag = 'A';
         FOR pol IN (SELECT param_value_v
                       FROM giis_parameters
                      WHERE param_name = 'REINSURANCE')
         LOOP
            v_iss_cd := pol.param_value_v;
            EXIT;
         END LOOP;
      END IF;
/*
   BEGIN
     IF :parameter.change_date = 'N' THEN
        do_payt_terms_computation;
     ELSE
        do_payt_terms_computation('2');
     END IF;
     POP_PACKAGE1;
   END;
*/
      BEGIN
         --- created by tonio 10/06/08
         FOR i IN (SELECT param_value_n
                     FROM giis_parameters
                    WHERE param_name = 'OTHER_CHARGES_CODE')
         LOOP
            v_param := i.param_value_n;
         END LOOP;
--------------------------
         FOR c IN (SELECT item_grp, takeup_seq_no
                     FROM gipi_winvoice
                    WHERE par_id = p_par_id)
         LOOP
            IF v_param IS NULL
            THEN                                            ---tonio 10/06/08
               FOR l IN (SELECT SUM (tax_amt) tax
                           FROM gipi_winv_tax
                          WHERE par_id = p_par_id
                            AND item_grp = c.item_grp
                            AND takeup_seq_no = c.takeup_seq_no)
               LOOP
                  UPDATE gipi_winvoice
                     SET tax_amt = l.tax
                   WHERE par_id = p_par_id
                     AND item_grp = c.item_grp
                     AND takeup_seq_no = c.takeup_seq_no;
               END LOOP;
            END IF;
            IF v_param IS NOT NULL
            THEN                                             ---tonio 10/06/08
               FOR l IN (SELECT SUM (tax_amt) tax
                           FROM gipi_winv_tax
                          WHERE par_id = p_par_id
                            AND item_grp = c.item_grp
                            AND takeup_seq_no = c.takeup_seq_no
                            AND tax_cd <> v_param)
               LOOP
                  UPDATE gipi_winvoice
                     SET tax_amt = l.tax
                   WHERE par_id = p_par_id
                     AND item_grp = c.item_grp
                     AND takeup_seq_no = c.takeup_seq_no;
               END LOOP;
            END IF;
            /*added edgar 10/08/2014*/
            IF v_iss_cd = v_parlist_iss_cd THEN
                FOR x IN (SELECT c.input_vat_rate, b.ri_comm_amt,
                                 ROUND (NVL (b.ri_comm_amt, 0) * (NVL (c.input_vat_rate, 0) / 100),
                                        2
                                       ) ri_comm_vat
                            FROM giri_winpolbas a, gipi_winvoice b, giis_reinsurer c
                           WHERE a.par_id = b.par_id
                             AND a.ri_cd = c.ri_cd
                             AND a.par_id = p_par_id
                             AND b.item_grp = c.item_grp
                             AND b.takeup_seq_no = c.takeup_seq_no)
                LOOP
                     UPDATE gipi_winvoice
                        SET ri_comm_vat = x.ri_comm_vat
                      WHERE par_id = p_par_id
                        AND item_grp = c.item_grp
                        AND takeup_seq_no = c.takeup_seq_no;   
                END LOOP;
            END IF;
            /*ended edgar 10/08/2014*/
         END LOOP;
      END;
      --IF v_iss_cd = v_parlist_iss_cd
      --THEN
      --   UPDATE gipi_winvoice
      --      SET ri_comm_vat = p_ri_comm_vat
      --    WHERE par_id = p_par_id;
      --END IF; /*commented out edgar 10/07/2014 to handle error on amounts when processing multiple bill groups since only the ri_comm_vat of last item group is passed in the parameter*/
      -- belle 09022012 added to update gipi_wpolbas based on the changes made in booking month of takeupseqno = 1 in gipi_winvoice    
      UPDATE GIPI_WPOLBAS
         SET BOOKING_MTH  = p_booking_mm,
             BOOKING_YEAR = p_booking_yy
       WHERE par_id = p_par_id;
      adjust_pack_winv_tax_gipis026 (p_pack_par_id);
   END post_forms_commit_gipis026;
   /*
   **  Created by    :TONIO
   **  Reference By  : GIPIS017B
   	edited by: Irwin Tabisora
	Date: 5.25.2012
	Description: added loop for gipi_winvoice to address the issue regarding multiple takeup terms
   */
   PROCEDURE post_frm_commit_gipis017b (
      p_par_id               gipi_parlist.par_id%TYPE,
      p_bond_tsi_amt         gipi_winvoice.bond_tsi_amt%TYPE,
      p_prem_amt             gipi_winvoice.prem_amt%TYPE,
      p_bond_rate            gipi_winvoice.bond_rate%TYPE,
      p_iss_cd               gipi_parlist.iss_cd%TYPE,
      p_pay_term             giis_payterm.payt_terms%TYPE,
      p_tax_amt              gipi_winvoice.tax_amt%TYPE,
      p_message        OUT   VARCHAR2,
      p_booking_yy           gipi_wpolbas.booking_year%TYPE, --belle 09022012
      p_booking_mm           gipi_wpolbas.booking_mth%TYPE 
   )
   IS
      v_post           NUMBER                           := 0;
      v_ann_prem_amt   gipi_wpolbas.ann_prem_amt%TYPE;
      v_ann_tsi_amt    gipi_wpolbas.ann_tsi_amt%TYPE;
      v_dist_no        giuw_pol_dist.dist_no%TYPE;
      v_takeup_seq_no  giuw_pol_dist.takeup_seq_no%TYPE; -- jhing 11.19.2014  fullweb sit SR # 2805
      v_takeup_term    gipi_wpolbas.takeup_term%TYPE ;   -- jhing 11.19.2014 
      v_count           number ;                          -- jhing 11.19.2014 
	  v_fixed_flag     giis_bond_class.fixed_flag%TYPE;  --robert GENQA 4825 08.19.15
      v_prorate_flag   gipi_wpolbas.prorate_flag%TYPE;   --robert GENQA 4825 08.19.15
   BEGIN
      FOR x IN (SELECT 1
                  FROM gipi_wcomm_invoices
                 WHERE par_id = p_par_id)
      LOOP
         v_post := 1;
      END LOOP;
      -- jhing 11.19.2014 added query for takeup term 
      FOR y IN ( SELECT NVL(takeup_term,'ST') takeup_term 
                    FROM gipi_wpolbas
                        WHERE par_id = p_par_id )
      LOOP
        v_takeup_term := y.takeup_term;
        EXIT;
      END LOOP;
      IF p_bond_tsi_amt != 0
      THEN
	  	--robert GENQA 4825 08.19.15
	  	FOR i IN (SELECT   d.fixed_flag
                     FROM giis_bond_class_subline a,
                          gipi_wbond_basic b,
                          gipi_wpolbas c,
                          giis_bond_class d
                    WHERE b.par_id = c.par_id
                      AND a.line_cd = c.line_cd
                      AND a.subline_cd = c.subline_cd
                      AND a.clause_type = b.clause_type
                      AND d.class_no = a.class_no
                      AND c.par_id = p_par_id
                 ORDER BY a.class_no)
        LOOP
           v_fixed_flag := i.fixed_flag;
           EXIT;
        END LOOP;

          IF v_fixed_flag = 'A'
           THEN
              SELECT prorate_flag
                INTO v_prorate_flag
                FROM gipi_wpolbas
               WHERE par_id = p_par_id;

              IF v_prorate_flag = 1
              THEN
                 SELECT   p_prem_amt
                        / (  TRUNC (DECODE (par_type,
                                            'P', expiry_date,
                                            endt_expiry_date
                                           )
                                   )
                           - TRUNC (DECODE (par_type, 'P', incept_date, eff_date))
                           + DECODE (NVL (comp_sw, 'N'), 'Y', 1, 'M', -1, 0)
                          )
                        * check_duration (DECODE (par_type,
                                                  'P', incept_date,
                                                  eff_date
                                                 ),
                                          DECODE (par_type,
                                                  'P', expiry_date,
                                                  endt_expiry_date
                                                 )
                                         )
                   INTO v_ann_prem_amt
                   FROM gipi_wpolbas a, gipi_parlist b
                  WHERE a.par_id = p_par_id AND a.par_id = b.par_id;
              ELSIF v_prorate_flag = 2
              THEN
                 SELECT   p_prem_amt
                        * (  TRUNC (DECODE (par_type,
                                            'P', expiry_date,
                                            endt_expiry_date
                                           )
                                   )
                           - TRUNC (DECODE (par_type, 'P', incept_date, eff_date))
                           + DECODE (NVL (comp_sw, 'N'), 'Y', 1, 'M', -1, 0)
                          )
                        / check_duration (DECODE (par_type,
                                                  'P', incept_date,
                                                  eff_date
                                                 ),
                                          DECODE (par_type,
                                                  'P', expiry_date,
                                                  endt_expiry_date
                                                 )
                                         )
                   INTO v_ann_prem_amt
                   FROM gipi_wpolbas a, gipi_parlist b
                  WHERE a.par_id = p_par_id AND a.par_id = b.par_id;
              ELSIF v_prorate_flag = 3
              THEN
                 SELECT p_prem_amt / (short_rt_percent / 100)
                   INTO v_ann_prem_amt
                   FROM gipi_wpolbas
                  WHERE par_id = p_par_id;
              END IF;
          ELSE
              v_ann_prem_amt := p_bond_tsi_amt * (p_bond_rate / 100);
          END IF;
         --end robert GENQA 4825 08.19.15
         UPDATE gipi_witem
            SET ann_tsi_amt = p_bond_tsi_amt,
                ann_prem_amt = v_ann_prem_amt --p_prem_amt replaced by robert GENQA 4825 08.17.15
          WHERE par_id = p_par_id AND item_no = 1;
         UPDATE gipi_witmperl
            SET ann_tsi_amt = p_bond_tsi_amt,
                ann_prem_amt = v_ann_prem_amt --p_prem_amt replaced by robert GENQA 4825 08.17.15
          WHERE par_id = p_par_id AND item_no = 1;
         UPDATE gipi_wpolbas
            SET ann_tsi_amt = p_bond_tsi_amt,
                ann_prem_amt = v_ann_prem_amt, --p_prem_amt replaced by robert GENQA 4825 08.17.15
                tsi_amt = p_bond_tsi_amt,
                prem_amt = p_prem_amt
          WHERE par_id = p_par_id;
         gipi_winstallment_pkg.calc_payment_sched_gipis017b (p_par_id,
                                                             p_pay_term,
                                                             p_prem_amt,
                                                             p_tax_amt
                                                            );
		/*
		DELETE gipi_winstallment
  			 WHERE par_id   = p_par_id;													
		gipi_winstallment_pkg.calc_payment_sched_gipis017b_2 (p_par_id,
		 p_prem_amt,
		 p_tax_amt
		);*/
		/** START OF EDIT - IRWIN */				
		/* DELETE gipi_winstallment
  			 WHERE par_id   = p_par_id; 
			 for invoice_item in (
			 	SELECT PAYT_TERMS FROM  gipi_winvoice WHERE PAR_ID = P_PAR_OID
			 )loop
			gipi_winstallment_pkg.calc_payment_sched_gipis017b_2 (p_par_id,
                                                             invoice_item.PAYT_TERM,
                                                             p_prem_amt,
                                                             p_tax_amt
                                                            );
		 end loop;*/
		/**END OF EDIT*/									 
      END IF;
      IF p_iss_cd = 'RI' OR v_post = 1
      THEN
         UPDATE gipi_parlist
            SET par_status = 6
          WHERE par_id = p_par_id;
      END IF;
      FOR x IN (SELECT payt_terms
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id)
      LOOP
         IF x.payt_terms IS NULL
         THEN
            UPDATE gipi_winvoice
               SET payt_terms = 'COD',
                   bond_tsi_amt = p_bond_tsi_amt,
                   bond_rate = p_bond_rate
             WHERE par_id = p_par_id;
         ELSE
            UPDATE gipi_winvoice
               SET bond_tsi_amt = p_bond_tsi_amt,
                   bond_rate = p_bond_rate
             WHERE par_id = p_par_id;
         END IF;
      END LOOP;
      v_count := 0 ; -- jhing 11.19.2014 
      FOR a IN (SELECT dist_no , takeup_seq_no /* jhing 11.19.2014 added takeup_seq_no */
                  FROM giuw_pol_dist
                 WHERE par_id = p_par_id)
      LOOP
         v_dist_no := a.dist_no;
         v_takeup_seq_no := a.takeup_seq_no; -- jhing 11.19.2014 
         v_count := v_count + 1 ; 
        -- EXIT;  -- jhing commented out 11.19.2014 
      END LOOP;
      -- jhing 11.19.2014 for long term bonds, delete the distribution records then re-insert records
      -- to prevent missing dist records or incorrect update of distribution 
      IF v_takeup_term <> 'ST' OR v_count > 1 THEN
        DELETE FROM giuw_pol_dist
            WHERE par_id = p_par_id;
      END IF;
      IF v_dist_no IS NULL OR v_takeup_term <> 'ST' OR v_count > 1 -- jhing 11.19.2014 added condition for takeup term and v_count
      THEN
         dist_giuw_pol_dist (p_par_id,
                             p_bond_tsi_amt,
                             p_prem_amt,
                             p_bond_rate,
                             p_message
                            );
      ELSE
         -- jhing 11.19.2014 added takeup seq no in the update statement
         IF v_takeup_seq_no IS NULL AND  v_takeup_term = 'ST' THEN
             UPDATE giuw_pol_dist
                SET tsi_amt = p_bond_tsi_amt,
                    prem_amt = p_prem_amt,
                    ann_tsi_amt = p_bond_tsi_amt, 
                    takeup_seq_no = 1 
              WHERE dist_no = v_dist_no;
         ELSE
             UPDATE giuw_pol_dist
                SET tsi_amt = p_bond_tsi_amt,
                    prem_amt = p_prem_amt,
                    ann_tsi_amt = p_bond_tsi_amt
              WHERE dist_no = v_dist_no;
         END IF;
      END IF;
      -- belle 09022012 added to update gipi_wpolbas based on the changes made in booking month of takeupseqno = 1 in gipi_winvoice    
      UPDATE GIPI_WPOLBAS
         SET BOOKING_MTH  = p_booking_mm,
             BOOKING_YEAR = p_booking_yy
       WHERE par_id = p_par_id;
   END post_frm_commit_gipis017b;
   /*
   **  Modified by        : Mark JM
   **  Date Created    : 03.23.2011
   **  Reference By    : (GIPIS095 - Package Policy Items)
   **  Description     : Delete record from gipi_winvoice using the given parameters
   */
   PROCEDURE del_gipi_winvoice2 (
      p_par_id     IN   gipi_winvoice.par_id%TYPE,
      p_item_grp   IN   gipi_winvoice.item_grp%TYPE
   )
   IS
   BEGIN
      /*added by steven 2.1.2013;to handle the constraint*/
	 DELETE FROM GIPI_WINSTALLMENT
       WHERE par_id = p_par_id AND item_grp = p_item_grp;
     DELETE FROM GIPI_WCOMM_INV_PERILS
       WHERE par_id = p_par_id AND item_grp = p_item_grp;
     DELETE FROM GIPI_WCOMM_INVOICES
        WHERE par_id = p_par_id AND item_grp = p_item_grp;
     DELETE FROM GIPI_WINVPERL
        WHERE par_id = p_par_id AND item_grp = p_item_grp;
     DELETE FROM GIPI_WINV_TAX
        WHERE par_id = p_par_id AND item_grp = p_item_grp;
     DELETE FROM GIPI_WPACKAGE_INV_TAX
        WHERE par_id = p_par_id AND item_grp = p_item_grp;
	  DELETE FROM gipi_winvoice
            WHERE par_id = p_par_id AND item_grp = p_item_grp;
   END del_gipi_winvoice2;
   /*
   **  Created by        : Veronica V. Raymundo
   **  Date Created     : 04.30.2011
   **  Reference By     : (GIPIS154 - Lead Policy Information)
   **  Description     : Retrieves gipi_winvoice records of a given par_id
   */
   FUNCTION get_lead_pol_winvoice (p_par_id gipi_winvoice.par_id%TYPE)
      RETURN gipi_winvoice_tab3 PIPELINED
   AS
      v_winvoice   gipi_winvoice_type3;
   BEGIN
      FOR i IN (SELECT a.par_id, a.item_grp, a.property, a.insured,
                       a.ref_inv_no, a.prem_amt, a.tax_amt, a.other_charges,
                       a.currency_cd, b.currency_desc,
                         NVL (a.prem_amt, 0)
                       + NVL (a.tax_amt, 0)
                       + NVL (a.other_charges, 0) amount_due
                  FROM gipi_winvoice a, giis_currency b
                 WHERE a.par_id = p_par_id
                   AND a.currency_cd = b.main_currency_cd)
      LOOP
         v_winvoice.par_id := i.par_id;
         v_winvoice.item_grp := i.item_grp;
         v_winvoice.property := i.property;
         v_winvoice.insured := i.insured;
         v_winvoice.ref_inv_no := i.ref_inv_no;
         v_winvoice.prem_amt := i.prem_amt;
         v_winvoice.tax_amt := i.tax_amt;
         v_winvoice.other_charges := i.other_charges;
         v_winvoice.currency_cd := i.currency_cd;
         v_winvoice.currency_desc := i.currency_desc;
         v_winvoice.amount_due := i.amount_due;
         PIPE ROW (v_winvoice);
      END LOOP;
   END;
   /*
   **  Created by   :  Emman
   **  Date Created :  06.29.2011
   **  Reference By : (Gipis085 - Invoice Commission)
   **  Description  : Gets gipi_winvoices records based on pack_par_id, used for package
   */
   FUNCTION get_pack_gipi_winvoice (
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE
   )
      RETURN gipi_winvoice_tab2 PIPELINED
   IS
      v_winvoice   gipi_winvoice_type2;
   BEGIN
      FOR i IN (SELECT a.par_id, a.item_grp, a.takeup_seq_no,
                       a.multi_booking_mm, a.multi_booking_yy, a.insured
                  FROM gipi_winvoice a
                 WHERE a.par_id IN (SELECT DISTINCT par_id
                                               FROM gipi_parlist b240
                                              WHERE b240.pack_par_id =
                                                                p_pack_par_id))
      LOOP
         v_winvoice.par_id := i.par_id;
         v_winvoice.item_grp := i.item_grp;
         v_winvoice.takeup_seq_no := i.takeup_seq_no;
         v_winvoice.multi_booking_mm := i.multi_booking_mm;
         v_winvoice.multi_booking_yy := i.multi_booking_yy;
         --v_winvoice.insured             := i.insured;
         FOR i IN (SELECT assd_no
                     FROM gipi_parlist
                    WHERE pack_par_id = p_pack_par_id)
         LOOP
            FOR a IN (SELECT a020.assd_name assd_name
                        FROM giis_assured a020
                       WHERE a020.assd_no = i.assd_no)
            LOOP
               v_winvoice.insured := a.assd_name;
               EXIT;
            END LOOP;
            EXIT;
         END LOOP;
         PIPE ROW (v_winvoice);
      END LOOP;
      RETURN;
   END get_pack_gipi_winvoice;
   PROCEDURE get_annual_amount (
      p_par_id         IN       gipi_parlist.par_id%TYPE,
      p_line_cd        IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN       gipi_polbasic.renew_no%TYPE,
      p_ann_tsi_amt    OUT      gipi_polbasic.ann_tsi_amt%TYPE,
      p_ann_prem_amt   OUT      gipi_polbasic.ann_prem_amt%TYPE,
      p_exist_sw       OUT      VARCHAR2
   )
   IS
   BEGIN
      FOR a IN (SELECT   ann_tsi_amt, ann_prem_amt
                    FROM gipi_polbasic b250
                   WHERE b250.line_cd = p_line_cd
                     AND b250.subline_cd = p_subline_cd
                     AND b250.iss_cd = p_iss_cd
                     AND b250.issue_yy = p_issue_yy
                     AND b250.pol_seq_no = p_pol_seq_no
                     AND b250.renew_no = p_renew_no
                     AND b250.pol_flag IN ('1', '2', '3', 'X') --include Expired Policy in getting annual amount by MAC 04/30/2013
                     AND b250.eff_date =
                            (SELECT MAX (b2501.eff_date)
                               FROM gipi_polbasic b2501
                              WHERE b2501.line_cd = p_line_cd
                                AND b2501.subline_cd = p_subline_cd
                                AND b2501.iss_cd = p_iss_cd
                                AND b2501.issue_yy = p_issue_yy
                                AND b2501.pol_seq_no = p_pol_seq_no
                                AND b2501.renew_no = p_renew_no
                                AND b2501.pol_flag IN ('1', '2', '3', 'X')) --include Expired Policy in getting annual amount by MAC 04/30/2013
                ORDER BY b250.last_upd_date DESC)
      LOOP
         p_ann_tsi_amt := a.ann_tsi_amt;
         p_ann_prem_amt := a.ann_prem_amt;
         EXIT;
      END LOOP;
      FOR exist IN (SELECT 1
                      FROM gipi_winvoice
                     WHERE par_id = p_par_id)
      LOOP
         --exist_sw := true;
         p_exist_sw := 'Y';
         EXIT;
      END LOOP;
   /*    if exist_sw = false then
                   :blongterm.annual_tsi := variables.ann_tsi_amt;
                   :blongterm.annual_prem := variables.ann_prem_amt;
        end if;     */
   END;
    /**
       Created By Irwin Tabisora
       Date: Nov. 29, 2011
       Description: Post Form Commit for item Group items
   */
   PROCEDURE post_frm_gipis012_group (
      p_par_id    IN   NUMBER,
      p_line_cd   IN   VARCHAR2,
      p_iss_cd    IN   VARCHAR2
   )
   IS
      p_exist   NUMBER;
   BEGIN
      SELECT DISTINCT 1
                 INTO p_exist
                 FROM gipi_witmperl a, gipi_witem b
                WHERE a.par_id = b.par_id
                  AND a.par_id = p_par_id
                  AND a.item_no = b.item_no
             GROUP BY b.par_id, b.item_grp, a.peril_cd;
      --added by pol cruz 02.05.2014
      --ann_tsi_amt in gipi_wpolbas must be computed to populate the records in gipi_winv_tax
      --before calling the procedure create_winvoice     
      DECLARE
         v_sum_ann_tsi_amt NUMBER;
         v_sum_ann_prem_amt NUMBER;
      BEGIN
         SELECT SUM(ROUND(ann_tsi_amt * currency_rt, 2)),
                SUM(ROUND(ann_prem_amt * currency_rt, 2))
           INTO v_sum_ann_tsi_amt, v_sum_ann_prem_amt
           FROM gipi_witem
          WHERE par_id = p_par_id;
         UPDATE gipi_wpolbas
            SET ann_tsi_amt = v_sum_ann_tsi_amt,
                ann_prem_amt = v_sum_ann_prem_amt
           WHERE par_id = p_par_id;     
      END;       
      create_winvoice (0, 0, 0, p_par_id, p_line_cd, p_iss_cd);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DELETE      gipi_wcomm_inv_perils
               WHERE par_id = p_par_id;
         DELETE      gipi_winvperl
               WHERE par_id = p_par_id;
         DELETE      gipi_winv_tax
               WHERE par_id = p_par_id;
         DELETE      gipi_winstallment
               WHERE par_id = p_par_id;
         DELETE      gipi_wcomm_invoices
               WHERE par_id = p_par_id;
         DELETE      gipi_wpackage_inv_tax
               WHERE par_id = p_par_id;
         DELETE      gipi_winvoice
               WHERE par_id = p_par_id;
   END;
   /*
   **  Created by   :  D.Alcantara
   **  Date Created :  09.01.2012
   **  Reference By : (Gipis165b - Endt Bond Bill Premium)
   **  Description  : post forms commit
   */
   PROCEDURE post_frm_commit_gipis165b (
      p_par_id                  gipi_parlist.par_id%TYPE,
      p_bond_tsi_amt   IN       gipi_winvoice.bond_tsi_amt%TYPE,
      p_prem_amt       IN       gipi_winvoice.prem_amt%TYPE,
      p_bond_rate      IN       gipi_winvoice.bond_rate%TYPE,
      p_iss_cd         IN       gipi_parlist.iss_cd%TYPE,
      p_pay_term       IN       giis_payterm.payt_terms%TYPE,
      p_tax_amt        IN       gipi_winvoice.tax_amt%TYPE,
      p_ann_tsi        IN       gipi_wpolbas.ann_tsi_amt%TYPE,
      p_ann_prem       IN       gipi_wpolbas.ann_prem_amt%TYPE,
      p_message        OUT      VARCHAR2
   ) IS
      v_post          number := 0;
/*      v_ann_prem_amt   gipi_wpolbas.ann_prem_amt%TYPE;
      v_ann_tsi_amt    gipi_wpolbas.ann_tsi_amt%TYPE;*/
      v_dist_no        giuw_pol_dist.dist_no%TYPE;
      v_curr_pol_flag  gipi_wpolbas.pol_flag%TYPE;
   BEGIN
      SELECT pol_flag INTO v_curr_pol_flag 
        FROM gipi_wpolbas 
       WHERE par_id = p_par_id;
      IF p_bond_tsi_amt < 1 AND p_ann_tsi = 0 THEN
        BEGIN
		  UPDATE gipi_wpolbas
		  	 SET pol_flag = 4
    	 WHERE par_id = p_par_id;
		END;
      ELSIF v_curr_pol_flag != 1 THEN
        BEGIN
		  UPDATE gipi_wpolbas
		  	 SET pol_flag = 1
    	 WHERE par_id = p_par_id;
		END;
      END IF;
      FOR x IN (SELECT 1
                  FROM gipi_wcomm_invoices
                 WHERE par_id = p_par_id)
      LOOP
         v_post := 1;
      END LOOP;
      IF p_bond_tsi_amt IS NOT NULL THEN
         UPDATE gipi_witem
            SET ann_tsi_amt = p_ann_tsi,
              	 ann_prem_amt = p_ann_prem
          WHERE par_id = p_par_id
            AND item_no = 1;
         UPDATE gipi_witmperl
            SET ann_tsi_amt = p_ann_tsi,
		             ann_prem_amt = p_ann_prem
          WHERE par_id = p_par_id
            AND item_no = 1;
      	 UPDATE gipi_wpolbas
            SET tsi_amt = p_bond_tsi_amt,
                prem_amt = p_prem_amt,
                ann_tsi_amt = p_ann_tsi,
                ann_prem_amt = p_ann_prem
       	  WHERE par_id = p_par_id; 
         gipi_winstallment_pkg.calc_payment_sched_gipis017b (p_par_id,
                                                             p_pay_term,
                                                             p_prem_amt,
                                                             p_tax_amt
                                                            );
      END IF;
      IF p_iss_cd = 'RI' OR v_post = 1
      THEN
         UPDATE gipi_parlist
            SET par_status = 6
          WHERE par_id = p_par_id;
      END IF;
      FOR x IN (SELECT payt_terms
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id)
      LOOP
         IF x.payt_terms IS NULL
         THEN
            UPDATE gipi_winvoice
               SET payt_terms = 'COD',
                   bond_tsi_amt = p_bond_tsi_amt,
                   bond_rate = p_bond_rate
             WHERE par_id = p_par_id;
         ELSE
            UPDATE gipi_winvoice
               SET bond_tsi_amt = p_bond_tsi_amt,
                   bond_rate = p_bond_rate
             WHERE par_id = p_par_id;
         END IF;
      END LOOP;
      FOR a IN (SELECT dist_no
                  FROM giuw_pol_dist
                 WHERE par_id = p_par_id)
      LOOP
         v_dist_no := a.dist_no;
         EXIT;
      END LOOP;
      IF v_dist_no IS NULL
      THEN
         dist_giuw_pol_dist_gipis165b (p_par_id,
                             p_bond_tsi_amt,
                             p_prem_amt,
                             p_ann_tsi,
                             p_bond_rate,
                             p_message
                            );
      ELSE
         UPDATE giuw_pol_dist
            SET tsi_amt = p_bond_tsi_amt,
                prem_amt = p_prem_amt,
                ann_tsi_amt = p_ann_tsi
          WHERE dist_no = v_dist_no;
      END IF;
   END post_frm_commit_gipis165b;
   /*
   **  Created by   :  D.Alcantara
   **  Date Created :  09.01.2012
   **  Reference By : GIPIS017B
   **  Description  : validation of due date
   */
    PROCEDURE validate_bond_due_date1(
        p_due_date		    IN OUT  VARCHAR2,
        p_eff_date		    IN      VARCHAR2,
        p_issue_date       IN       VARCHAR2, --apollo cruz sr#19975
        p_expiry_date		IN      VARCHAR2,
        p_org_due_date      IN      VARCHAR2,
        p_takeup_seq_no     IN      NUMBER,
        p_info_msg          OUT     VARCHAR2    
    ) IS
        v_due_date          DATE := TRUNC(TO_DATE(p_due_date, 'MM-DD-YYYY'));
        v_eff_date          DATE := TRUNC(TO_DATE(p_eff_date, 'MM-DD-YYYY'));
        v_expiry_date       DATE := TRUNC(TO_DATE(p_expiry_date, 'MM-DD-YYYY'));
        v_issue_date        DATE := TRUNC(TO_DATE(p_issue_date, 'MM-DD-YYYY'));
		  v_allow_exp_pol_iss GIIS_PARAMETERS.PARAM_VALUE_V%TYPE := NVL(giisp.v('ALLOW_EXPIRED_POLICY_ISSUANCE'), 'N'); --added by robert SR 19785 07.20.15
        v_prod_take_up      NUMBER := NVL(giacp.n('PROD_TAKE_UP'), 1);
        v_str_date          VARCHAR2(20) := 'issue date';
        v_prod_take_up_date DATE := v_issue_date;        
    BEGIN
        
       /*IF v_prod_take_up IN (1, 3) THEN
          v_prod_take_up_date := v_issue_date;
          v_str_date := 'issue date';
       ELSE
          IF(v_issue_date > v_eff_date) THEN
             v_prod_take_up_date := v_issue_date;
             v_str_date := 'issue date';   
          ELSE
             v_prod_take_up_date := v_eff_date;
             v_str_date := 'effectivity date';
          END IF;
       END IF; */
       
       -- apollo cruz 10.09.2015 GENQA 4967, 5044
       -- codes from ma'am vj
       IF v_prod_take_up = 1 THEN
          v_prod_take_up_date := v_issue_date;
          v_str_date := 'issue date';
       ELSIF v_prod_take_up = 2 THEN
          v_prod_take_up_date := v_eff_date;
          v_str_date := 'effectivity date';
       ELSE
          IF (v_issue_date > v_eff_date) THEN
             v_prod_take_up_date := v_issue_date;
             v_str_date := 'issue date';
          ELSE
             v_prod_take_up_date := v_eff_date;
             v_str_date := 'effectivity date';
          END IF;
       END IF;
        
--     apollo cruz sr#19975 - modified validation for due date       
--       IF v_due_date < v_eff_date THEN
--          p_info_msg := 'Due date schedule must not be earlier than the effectivity date of the policy.';
--          v_due_date := TRUNC(TO_DATE(p_org_due_date, 'MM-DD-YYYY'));
--          p_due_date := TO_CHAR(v_due_date, 'MM-DD-YYYY');
       IF v_due_date < v_prod_take_up_date THEN
          p_info_msg := 'Due date schedule must not be earlier than the ' || v_str_date || ' of the policy.';
          v_due_date := TRUNC(TO_DATE(p_org_due_date, 'MM-DD-YYYY'));
          p_due_date := TO_CHAR(v_due_date, 'MM-DD-YYYY');
       ELSIF v_due_date > v_expiry_date AND v_allow_exp_pol_iss = 'N' THEN --added v_allow_exp_pol_iss by robert SR 19785 07.20.15
          p_info_msg := 'Due date schedule must not be later  than the expiry date of the policy.';
          v_due_date := TRUNC(TO_DATE(p_org_due_date, 'MM-DD-YYYY'));
          p_due_date := TO_CHAR(v_due_date, 'MM-DD-YYYY');
       END IF;
    END validate_bond_due_date1;
   /*
   **  Created by   :  D.Alcantara
   **  Date Created :  09.01.2012
   **  Reference By : GIPIS017B
   **  Description  : validation of due date, part 2
   */
    PROCEDURE validate_bond_due_date2(
        p_due_date		    IN  VARCHAR2,
        p_n_due_date        IN  VARCHAR2,    
        p_takeup_seq_no     IN  NUMBER,
        p_n_takeup_seq_no   IN  NUMBER,
        p_info_msg          OUT VARCHAR2    
    ) IS
        v_due_date          DATE := TRUNC(TO_DATE(p_due_date, 'MM-DD-YYYY'));
        v_n_due_date        DATE := TRUNC(TO_DATE(p_n_due_date, 'MM-DD-YYYY'));
    BEGIN
        IF p_takeup_seq_no < p_n_takeup_seq_no THEN
            p_info_msg := 'Due date schedule must be in proper sequence.';
        ELSE
            IF v_due_date < v_n_due_date THEN
                p_info_msg := 'Due date schedule must be in proper sequence.';
            END IF;
        END IF;
    END validate_bond_due_date2;
   -- bonok :: 12.10.2013 :: delete record from distribution working tables upon clicking Create Invoice
   PROCEDURE delete_wdist_tables(
      p_par_id          giuw_pol_dist.par_id%TYPE
   ) AS
      v_dist_no         giuw_pol_dist.dist_no%TYPE;
      v_line_cd         giri_wdistfrps.line_cd%TYPE;
      v_frps_yy         giri_wdistfrps.frps_yy%TYPE;
      v_frps_seq_no     giri_wdistfrps.frps_seq_no%TYPE;
      v_pre_binder_id   giri_wfrps_ri.pre_binder_id%TYPE;
   BEGIN
      /* -- jhing 01.23.2015 commented out. Will enclose codes in a loop 
         -- to handle possible failure in long term bonds with multiple distribution records.
      BEGIN --added by steven 10.14.2014
           SELECT dist_no
             INTO v_dist_no
             FROM giuw_pol_dist
            WHERE par_id = p_par_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_dist_no := NULL;
      END;*/
      FOR curdist IN ( select dist_no 
                         FROM giuw_pol_dist
                            WHERE par_id = p_par_id )
      LOOP
          v_dist_no := curdist.dist_no ; 
          IF v_dist_no IS NOT NULL THEN
             DELETE FROM gipi_wcomm_inv_perils
              WHERE p_par_id = p_par_id;
             DELETE FROM gipi_wcomm_invoices
              WHERE p_par_id = p_par_id;
             DELETE FROM gipi_winstallment
              WHERE p_par_id = p_par_id;
             DELETE FROM giuw_perilds_dtl
              WHERE dist_no = v_dist_no; 
             DELETE FROM giuw_perilds
              WHERE dist_no = v_dist_no; 
             DELETE FROM giuw_wperilds_dtl
              WHERE dist_no = v_dist_no; 
             DELETE FROM giuw_wperilds
              WHERE dist_no = v_dist_no; 
             DELETE FROM giuw_itemperilds_dtl
              WHERE dist_no = v_dist_no;
             DELETE FROM giuw_itemperilds
              WHERE dist_no = v_dist_no; 
             DELETE FROM giuw_witemperilds_dtl
              WHERE dist_no = v_dist_no;
             DELETE FROM giuw_witemperilds
              WHERE dist_no = v_dist_no; 
             DELETE FROM giuw_itemds_dtl
              WHERE dist_no = v_dist_no; 
             DELETE FROM giuw_itemds
              WHERE dist_no = v_dist_no;  
             DELETE FROM giuw_witemds_dtl
              WHERE dist_no = v_dist_no; 
             DELETE FROM giuw_witemds
              WHERE dist_no = v_dist_no; 
             DELETE FROM giuw_policyds_dtl
              WHERE dist_no = v_dist_no;
             DELETE FROM giuw_policyds
              WHERE dist_no = v_dist_no;
             DELETE FROM giuw_wpolicyds_dtl
              WHERE dist_no = v_dist_no; 
             /* removed by robert 03.25.2014
                DELETE FROM giuw_wpolicyds
                 WHERE dist_no = v_dist_no;
                DELETE FROM giri_wdistfrps
                 WHERE dist_no = v_dist_no;
             end here robert 03.25.2014*/
             /*BEGIN
                SELECT line_cd, frps_yy, frps_seq_no
                  INTO v_line_cd, v_frps_yy, v_frps_seq_no
                  FROM giri_wdistfrps
                 WHERE dist_no = v_dist_no;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   NULL;
             END; */  -- jhing 01.23.2015 commented out
             -- jhing 01.23.2015 enclosed retrieval of FRPS in a loop though this might not be needed
             -- since bonds only has one bill group or item group and cannot be regrouped by peril. However 
             -- this code is needed to be changed if in the future it is reused by other modules or scenarios.
             FOR frps IN (SELECT line_cd, frps_yy, frps_seq_no
                              INTO v_line_cd, v_frps_yy, v_frps_seq_no
                              FROM giri_wdistfrps
                             WHERE dist_no = v_dist_no)
             LOOP
                 v_line_cd := frps.line_cd ;
                 v_frps_yy := frps.frps_yy ;
                 v_frps_seq_no := frps.frps_seq_no; 
                 IF v_line_cd IS NOT NULL THEN
                    DELETE FROM giri_wfrperil
                     WHERE line_cd = v_line_cd
                       AND frps_yy = v_frps_yy
                       AND frps_seq_no = v_frps_seq_no;
                    -- jhing 01.23.2015 commented out. Causes error when there are multiple 
                    -- reinsurers in the working FRPS. Will enclose delete statement in a loop. 
                    /*BEGIN --added by robert 03.25.2014 to catch when no data found  
                        SELECT pre_binder_id
                          INTO v_pre_binder_id
                          FROM giri_wfrps_ri
                         WHERE line_cd = v_line_cd
                           AND frps_yy = v_frps_yy
                           AND frps_seq_no = v_frps_seq_no;
                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       NULL;
                    END;*/
                    -- jhing 01.23.2015 new codes to delete records in giri_wbinder_peril and giri_wbinder.
                    FOR c2 IN (SELECT pre_binder_id
                                 FROM giri_wfrps_ri
                                WHERE line_cd     = v_line_cd
                                  AND frps_yy     = v_frps_yy
                                  AND frps_seq_no = v_frps_seq_no  ) 
                    LOOP
                      DELETE giri_wbinder_peril
                       WHERE pre_binder_id = c2.pre_binder_id; 
                      DELETE giri_wbinder
                       WHERE pre_binder_id = c2.pre_binder_id;
                    END LOOP;               
                    DELETE FROM giri_wfrps_ri
                     WHERE line_cd = v_line_cd
                       AND frps_yy = v_frps_yy
                       AND frps_seq_no = v_frps_seq_no;
                    /*DELETE FROM giri_wbinder_peril
                     WHERE pre_binder_id = v_pre_binder_id;*/ -- jhing 01.23.2015 commented out 
                    DELETE FROM giri_wfrps_peril_grp
                     WHERE line_cd = v_line_cd
                       AND frps_yy = v_frps_yy
                       AND frps_seq_no = v_frps_seq_no;
                 END IF;                
             END LOOP;              
             --added by robert 03.25.2014
             DELETE FROM giri_wdistfrps
              WHERE dist_no = v_dist_no;
             DELETE FROM giuw_wpolicyds
              WHERE dist_no = v_dist_no;
             --end here robert 03.25.2014
             -- added by jhing 01.23.2015 
             UPDATE giuw_pol_dist
               SET dist_flag = '1' , auto_dist = 'N'
               WHERE dist_no   = v_dist_no ;
          END IF;        
      END LOOP; 
   END;
   FUNCTION check_for_posted_binders(
      p_par_id          giuw_pol_dist.par_id%TYPE
   ) RETURN VARCHAR2 AS
      v_dist_no         giuw_pol_dist.dist_no%TYPE;
      v_exist           VARCHAR2(1) := 'N';
   BEGIN
     -- jhing 11.09.2014 instead of a select into, used a for loop to be able to handle long term 
     FOR curLongTerm in ( 
              SELECT dist_no
              --  INTO v_dist_no  -- commented out jhing 11.09.2014 
                FROM giuw_pol_dist
               WHERE par_id = p_par_id )
     LOOP  
          FOR i IN (SELECT '1'
                      FROM giri_distfrps
                     WHERE dist_no = /*v_dist_no*/ curLongTerm.dist_no)
          LOOP
             v_exist := 'Y';
             EXIT;
          END LOOP;          
          IF v_exist = 'Y' THEN
            EXIT;
          END IF;
      END LOOP;
      RETURN v_exist;
   END;
   --added by robert GENQA 4828 08.27.15
   PROCEDURE auto_compute_bond_prem (
       p_par_id   gipi_wpolbas.par_id%TYPE
    )
    AS
       v_line_cd        gipi_parlist.line_cd%TYPE;
       v_iss_cd         gipi_parlist.iss_cd%TYPE;
       v_item_grp       gipi_winvoice.item_grp%TYPE;
       v_bond_tsi_amt   gipi_winvoice.bond_tsi_amt%TYPE        := 0;
       v_prem_amt       gipi_winvoice.prem_amt%TYPE;
       v_ri_comm_rt     NUMBER;
       v_bond_rate      gipi_winvoice.bond_rate%TYPE           := 0;
       v_ri_comm_amt    gipi_winvoice.ri_comm_amt%TYPE;
       v_ri_comm_vat    gipi_winvoice.ri_comm_vat%TYPE;
       v_tax_amt        gipi_winvoice.tax_amt%TYPE;
       v_prorate_flag   gipi_wpolbas.prorate_flag%TYPE;
       v_takeup_list    gipi_winvoice_pkg.rc_gipi_winvoice_cur;
       v_message        VARCHAR2 (32767);
       v_pay_term       gipi_winvoice.payt_terms%TYPE;
       v_ann_tsi        gipi_wpolbas.ann_tsi_amt%TYPE;
       v_ann_prem       gipi_wpolbas.ann_prem_amt%TYPE;
       v_subline_cd     gipi_wpolbas.subline_cd%TYPE;
       v_issue_yy       gipi_wpolbas.issue_yy%TYPE;
       v_pol_seq_no     gipi_wpolbas.pol_seq_no%TYPE;
       v_renew_no       gipi_wpolbas.renew_no%TYPE;
       v_eff_date       gipi_wpolbas.eff_date%TYPE;
	   v_expiry_date    gipi_wpolbas.expiry_date%TYPE;
	   v_policy_id      gipi_polbasic.policy_id%TYPE;
    BEGIN
       SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
              renew_no, eff_date, ann_prem_amt, prorate_flag, ann_tsi_amt
         INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no,
              v_renew_no, v_eff_date, v_ann_prem, v_prorate_flag, v_ann_tsi
         FROM gipi_wpolbas
        WHERE par_id = p_par_id;
       v_expiry_date := extract_expiry2(v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no);
       get_amounts (p_par_id,
                    v_line_cd,
                    v_subline_cd,
                    v_iss_cd,
                    v_issue_yy,
                    v_pol_seq_no,
                    v_renew_no,
                    v_expiry_date,
                    v_ann_tsi,
                    v_ann_prem,
                    v_message
                   );

       IF v_prorate_flag = 1
       THEN
          SELECT   v_ann_prem
                 * (  TRUNC (DECODE (par_type,
                                     'P', expiry_date,
                                     endt_expiry_date
                                    ))
                    - TRUNC (DECODE (par_type, 'P', incept_date, eff_date))
                    + DECODE (NVL (comp_sw, 'N'), 'Y', 1, 'M', -1, 0)
                   )
                 / check_duration (DECODE (par_type, 'P', incept_date, eff_date),
                                   DECODE (par_type,
                                           'P', expiry_date,
                                           endt_expiry_date
                                          )
                                  )
            INTO v_prem_amt
            FROM gipi_wpolbas a, gipi_parlist b
           WHERE a.par_id = p_par_id AND a.par_id = b.par_id;
       ELSIF v_prorate_flag = 2
       THEN
          v_prem_amt := v_ann_prem;
       ELSIF v_prorate_flag = 3
       THEN
          SELECT v_ann_prem * (short_rt_percent / 100)
            INTO v_prem_amt
            FROM gipi_wpolbas
           WHERE par_id = p_par_id;
       END IF;

       v_ann_prem := v_ann_prem + v_ann_prem;
       
       IF v_iss_cd = giisp.v ('ISS_CD_RI') THEN
		  FOR i IN (SELECT policy_id 
				   FROM gipi_polbasic
				  WHERE line_cd = v_line_cd
					AND subline_cd = v_subline_cd
					AND iss_cd = v_iss_cd
					AND issue_yy = v_issue_yy
					AND pol_seq_no = v_pol_seq_no
					AND renew_no = v_renew_no
					AND NVL(endt_type, 'x') = DECODE(endt_type, NULL, 'x', 'A')
				  ORDER by endt_seq_no DESC)
		  LOOP
			  v_policy_id := i.policy_id;
			  EXIT;
		  END LOOP;
       
          BEGIN
             SELECT ri_comm_rt, (v_prem_amt * (ri_comm_rt / 100)) ri_comm_amt
               INTO v_ri_comm_rt, v_ri_comm_amt
               FROM giis_peril
              WHERE line_cd = v_line_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                NULL;
             WHEN TOO_MANY_ROWS
             THEN
                SELECT b.ri_comm_rt, (v_prem_amt * (b.ri_comm_rt / 100)) ri_comm_amt
                  INTO v_ri_comm_rt, v_ri_comm_amt
                  FROM gipi_itmperil a, giis_peril b
                 WHERE a.line_cd = b.line_cd
                   AND a.peril_cd = b.peril_cd
                   AND policy_id = v_policy_id;
          END;
       END IF;
       
       gipi_winvoice_pkg.get_gipi_winvoice_takeup_dtls (p_par_id,
                                                        v_line_cd,
                                                        v_iss_cd,
                                                        1,
                                                        v_takeup_list,
                                                        v_bond_tsi_amt,
                                                        v_prem_amt,
                                                        v_ri_comm_rt,
                                                        v_bond_rate,
                                                        v_ri_comm_amt,
                                                        v_ri_comm_vat,
                                                        v_tax_amt,
                                                        v_message
                                                       );

       SELECT payt_terms, tax_amt
         INTO v_pay_term, v_tax_amt
         FROM gipi_winvoice
        WHERE par_id = p_par_id;

       gipi_winvoice_pkg.post_frm_commit_gipis165b (p_par_id,
                                                    v_bond_tsi_amt,
                                                    v_prem_amt,
                                                    v_bond_rate,
                                                    v_iss_cd,
                                                    v_pay_term,
                                                    v_tax_amt,
                                                    v_ann_tsi,
                                                    v_ann_prem,
                                                    v_message
                                                   );
    END;
	-- end robert GENQA 4828 08.27.15
END gipi_winvoice_pkg;
/


