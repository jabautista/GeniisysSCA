CREATE OR REPLACE PACKAGE BODY CPI.select_quote_to_par
AS
/* Created by: Rose
** Created on: August 22, 2008
** This package procedure will copy records from quotation tables
** to PAR tables during creation of PAR. This package is used by module GIPIS050.
*/
   PROCEDURE select_quotation (p_quote_id NUMBER)
   AS
      v_quote_id     NUMBER;
      v_line_cd      VARCHAR2 (10);
      v_iss_cd       VARCHAR2 (2);
      v_subline_cd   VARCHAR2 (20);
      v_remarks      VARCHAR2 (4000);
      v_par_id       NUMBER (20);
      v_assd_no      NUMBER;
   BEGIN
      FOR x IN (SELECT quote_id, line_cd, subline_cd, remarks, assd_no,
                       iss_cd
                  FROM gipi_quote
                 WHERE quote_id = p_quote_id)
      LOOP
         v_quote_id := x.quote_id;
         v_line_cd := x.line_cd;
         v_subline_cd := x.subline_cd;
         v_remarks := x.remarks;
         v_iss_cd := x.iss_cd;

         SELECT parlist_par_id_s.NEXTVAL
           INTO v_par_id
           FROM SYS.DUAL;

         INSERT INTO gipi_parlist
                     (par_id, line_cd, iss_cd, par_yy,
                      par_type, assign_sw, par_status, quote_seq_no, quote_id
                     )
              VALUES (v_par_id, v_line_cd, v_iss_cd, TO_CHAR (SYSDATE, 'YY'),
                      'P', 'Y', 2, 0, v_quote_id
                     );
      END LOOP;
   END;

   PROCEDURE create_gipi_wpolbas2 (
      p_quote_id         NUMBER,
      p_par_id           NUMBER,
      p_line_cd          giis_line.line_cd%TYPE,
      p_iss_cd           VARCHAR2,
      p_assd_no          NUMBER,
      p_user             gipi_pack_wpolbas.user_id%TYPE,
      p_out        OUT   VARCHAR2
   )
   IS
      v_line_cd                gipi_wpolbas.line_cd%TYPE;
      v_iss_cd                 gipi_wpolbas.iss_cd%TYPE;
      v_subline_cd             gipi_wpolbas.subline_cd%TYPE;
      v_issue_yy               gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no             gipi_wpolbas.pol_seq_no%TYPE;
      v_endt_iss_cd            gipi_wpolbas.endt_iss_cd%TYPE;
      v_endt_yy                gipi_wpolbas.endt_yy%TYPE;
      v_endt_seq_no            gipi_wpolbas.endt_seq_no%TYPE;
      v_renew_no               gipi_wpolbas.renew_no%TYPE;
      v_endt_type              gipi_wpolbas.endt_type%TYPE;
      v_incept_date            gipi_wpolbas.incept_date%TYPE;
      v_expiry_date            gipi_wpolbas.expiry_date%TYPE;
      v_eff_date               gipi_wpolbas.eff_date%TYPE;
      v_issue_date             gipi_wpolbas.issue_date%TYPE;
      v_pol_flag               gipi_wpolbas.pol_flag%TYPE;
      v_foreign_acc_sw         gipi_wpolbas.foreign_acc_sw%TYPE;
      v_assd_no                gipi_wpolbas.assd_no%TYPE;
      v_designation            gipi_wpolbas.designation%TYPE;
      v_address1               gipi_wpolbas.address1%TYPE;
      v_address2               gipi_wpolbas.address2%TYPE;
      v_address3               gipi_wpolbas.address3%TYPE;
      v_mortg_name             gipi_wpolbas.mortg_name%TYPE;
      v_tsi_amt                gipi_wpolbas.tsi_amt%TYPE;
      v_prem_amt               gipi_wpolbas.prem_amt%TYPE;
      v_ann_tsi_amt            gipi_wpolbas.ann_tsi_amt%TYPE;
      v_ann_prem_amt           gipi_wpolbas.ann_prem_amt%TYPE;
      v_invoice_sw             gipi_wpolbas.invoice_sw%TYPE;
      v_pool_pol_no            gipi_wpolbas.pool_pol_no%TYPE;
      v_user_id                gipi_wpolbas.user_id%TYPE;
      v_quotation_printed_sw   gipi_wpolbas.quotation_printed_sw%TYPE;
      v_covernote_printed_sw   gipi_wpolbas.covernote_printed_sw%TYPE;
      v_orig_policy_id         gipi_wpolbas.orig_policy_id%TYPE;
      v_endt_expiry_date       gipi_wpolbas.endt_expiry_date%TYPE;
      v_no_of_items            gipi_wpolbas.no_of_items%TYPE;
      v_subline_type_cd        gipi_wpolbas.subline_type_cd%TYPE;
      v_auto_renew_flag        gipi_wpolbas.auto_renew_flag%TYPE;
      v_prorate_flag           gipi_wpolbas.prorate_flag%TYPE;
      v_short_rt_percent       gipi_wpolbas.short_rt_percent%TYPE;
      v_prov_prem_tag          gipi_wpolbas.prov_prem_tag%TYPE;
      v_type_cd                gipi_wpolbas.type_cd%TYPE;
      v_acct_of_cd             gipi_wpolbas.acct_of_cd%TYPE;
      v_prov_prem_pct          gipi_wpolbas.prov_prem_pct%TYPE;
      v_same_polno_sw          gipi_wpolbas.same_polno_sw%TYPE;
      v_pack_pol_flag          gipi_wpolbas.pack_pol_flag%TYPE;
      v_expiry_tag             gipi_wpolbas.expiry_tag%TYPE;
      v_prem_warr_tag          gipi_wpolbas.prem_warr_tag%TYPE;
      v_ref_pol_no             gipi_wpolbas.ref_pol_no%TYPE;
      v_ref_open_pol_no        gipi_wpolbas.ref_open_pol_no%TYPE;
      v_reg_policy_sw          gipi_wpolbas.reg_policy_sw%TYPE;
      v_co_insurance_sw        gipi_wpolbas.co_insurance_sw%TYPE;
      v_discount_sw            gipi_wpolbas.discount_sw%TYPE;
      v_fleet_print_tag        gipi_wpolbas.fleet_print_tag%TYPE;
      v_incept_tag             gipi_wpolbas.incept_tag%TYPE;
      v_comp_sw                gipi_wpolbas.comp_sw%TYPE;
      v_booking_mth            gipi_wpolbas.booking_mth%TYPE;
      v_endt_expiry_tag        gipi_wpolbas.endt_expiry_tag%TYPE;
      v_booking_yr             gipi_wpolbas.booking_year%TYPE;
      v_prod_take_up           giac_parameters.param_value_n%TYPE;
      v_later_date             gipi_wpolbas.issue_date%TYPE;
      v_acct_of_cd_sw          gipi_wpolbas.acct_of_cd_sw%TYPE;
      v_cred_branch            gipi_wpolbas.cred_branch%TYPE;
      v_with_tariff_sw         gipi_wpolbas.with_tariff_sw%TYPE;
      v_bank_ref_no            gipi_wpolbas.bank_ref_no%TYPE;
      v_takeup_term            gipi_wpolbas.takeup_term%TYPE;
      v_industry_cd            gipi_wpolbas.industry_cd %TYPE; --Added by MarkS 10.27.2016 SR5804
      v_region_cd               gipi_wpolbas.region_cd %TYPE;  --Added by MarkS 10.27.2016 SR5804
                                                            -- bmq 05/05/2011
                                                            
      var_display_def_cred_branch   giis_parameters.param_value_v%TYPE; --added by robert 10.03.2013
      v_def_cred_branch             giis_parameters.param_value_v%TYPE; --added by robert 10.03.2013
      v_quote_assd_no               gipi_wpolbas.assd_no%TYPE; --added by robert 11.04.2014
      v_quote_account_sw            gipi_quote.account_sw%TYPE; --Added by Jerome 08.25.2016
      v_label_tag                   gipi_wpolbas.label_tag%TYPE;
      CURSOR cur_b
      IS
         SELECT subline_cd, NVL (tsi_amt, 0), NVL (prem_amt, 0),
                NVL (print_tag, 'N'), incept_date, expiry_date, address1,
                address2, address3, prorate_flag, short_rt_percent, comp_sw,
                ann_prem_amt, ann_tsi_amt, acct_of_cd, acct_of_cd_sw,
                cred_branch, with_tariff_sw, bank_ref_no, assd_no, NVL(account_sw,1) --added assd_no by robert
           FROM gipi_quote
          WHERE quote_id = p_quote_id;
   BEGIN
      /*v_line_cd := p_line_cd;
      v_iss_cd := p_iss_cd;
      v_assd_no := p_assd_no;
      v_issue_date := SYSDATE;
      v_later_date := SYSDATE;

      SELECT param_value_n
        INTO v_prod_take_up
        FROM giac_parameters
       WHERE param_name = 'PROD_TAKE_UP';

      IF v_prod_take_up = 1
      THEN
         FOR A IN
            (SELECT   booking_year, booking_mth,
                      TO_CHAR (TO_DATE (   '01-'
                                        || SUBSTR (booking_mth, 1, 3)
                                        || booking_year,
                                        'DD-MON-RRRR'
                                       ),
                               'MM'
                              )
                 FROM giis_booking_month
                WHERE (NVL (booked_tag, 'N') != 'Y')
                  AND (   booking_year >
                                    TO_NUMBER (TO_CHAR (v_issue_date, 'YYYY'))
                       OR booking_year =
                                    TO_NUMBER (TO_CHAR (v_issue_date, 'YYYY'))
                      )
                  AND (TO_NUMBER (TO_CHAR (TO_DATE (   '01-'
                                                    || SUBSTR (booking_mth,
                                                               1,
                                                               3
                                                              )
                                                    || booking_year,
                                                    'DD-MON-RRRR'
                                                   ),
                                           'MM'
                                          )
                                 ) >= TO_NUMBER (TO_CHAR (v_issue_date, 'MM'))
                      )
             ORDER BY 1, 3)
         LOOP
            v_booking_mth := A.booking_mth;
            v_booking_yr := A.booking_year;
            EXIT;
         END LOOP;
      ELSIF v_prod_take_up = 2
      THEN
         FOR A IN
            (SELECT   booking_year, booking_mth,
                      TO_CHAR (TO_DATE (   '01-'
                                        || SUBSTR (booking_mth, 1, 3)
                                        || booking_year,
                                        'DD-MON-RRRR'
                                       ),
                               'MM'
                              )
                 FROM giis_booking_month
                WHERE (NVL (booked_tag, 'N') != 'Y')
                  AND (   booking_year >
                                      TO_NUMBER (TO_CHAR (v_eff_date, 'YYYY'))
                       OR booking_year =
                                      TO_NUMBER (TO_CHAR (v_eff_date, 'YYYY'))
                      )
                  AND (TO_NUMBER (TO_CHAR (TO_DATE (   '01-'
                                                    || SUBSTR (booking_mth,
                                                               1,
                                                               3
                                                              )
                                                    || booking_year,
                                                    'DD-MON-RRRR'
                                                   ),
                                           'MM'
                                          )
                                 ) >= TO_NUMBER (TO_CHAR (v_eff_date, 'MM'))
                      )
             ORDER BY 1, 3)
         LOOP
            v_booking_mth := A.booking_mth;
            v_booking_yr := A.booking_year;
            EXIT;
         END LOOP;
      ELSIF v_prod_take_up = 3
      THEN
         IF v_issue_date > v_eff_date
         THEN
            v_later_date := v_issue_date;
         ELSIF v_eff_date > v_issue_date
         THEN
            v_later_date := v_eff_date;
         END IF;

         FOR A IN
            (SELECT   booking_year, booking_mth,
                      TO_CHAR (TO_DATE (   '01-'
                                        || SUBSTR (booking_mth, 1, 3)
                                        || booking_year,
                                        'DD-MON-RRRR'
                                       ),
                               'MM'
                              )
                 FROM giis_booking_month
                WHERE (NVL (booked_tag, 'N') != 'Y')
                  AND (   booking_year >
                                    TO_NUMBER (TO_CHAR (v_later_date, 'YYYY'))
                       OR booking_year =
                                    TO_NUMBER (TO_CHAR (v_later_date, 'YYYY'))
                      )
                  AND (TO_NUMBER (TO_CHAR (TO_DATE (   '01-'
                                                    || SUBSTR (booking_mth,
                                                               1,
                                                               3
                                                              )
                                                    || booking_year,
                                                    'DD-MON-RRRR'
                                                   ),
                                           'MM'
                                          )
                                 ) >= TO_NUMBER (TO_CHAR (v_later_date, 'MM'))
                      )
             ORDER BY 1, 3)
         LOOP
            v_booking_mth := A.booking_mth;
            v_booking_yr := A.booking_year;
            EXIT;
         END LOOP;
      ELSE
         p_out :=
            'Wrong Parameter....Please make the necessary changes in Giac_Parameters.';
      --msg_alert('Wrong Parameter....Please make the necessary changes in Giac_Parameters.','I',TRUE);
      END IF; moved by: Nica 06.06.2012*/

      OPEN cur_b;

      FETCH cur_b
       INTO v_subline_cd, v_tsi_amt, v_prem_amt, v_quotation_printed_sw,
            v_incept_date, v_expiry_date, v_address1, v_address2, v_address3,
            v_prorate_flag, v_short_rt_percent, v_comp_sw, v_ann_prem_amt,
            v_ann_tsi_amt, v_acct_of_cd, v_acct_of_cd_sw, v_cred_branch,
            v_with_tariff_sw, v_bank_ref_no, v_quote_assd_no, v_quote_account_sw; --added assd_no by robert
      
      CLOSE cur_b;
      
      v_line_cd    := p_line_cd;
      v_iss_cd     := p_iss_cd;
      v_assd_no    := p_assd_no;
      v_issue_date := SYSDATE;
      v_later_date := SYSDATE;
      v_eff_date   := v_incept_date; -- Nica 06.06.2012 - added this line to assign value to v_eff_date
                                     -- which must be equal to the incept date of the quotation
      IF v_quote_account_sw = 2 THEN -- Added by Jerome 08.25.2016
         v_label_tag := 'Y';
      ELSE
         v_label_tag := 'N';
      END IF;
      
      
      SELECT param_value_n
        INTO v_prod_take_up
        FROM giac_parameters
       WHERE param_name = 'PROD_TAKE_UP';

      IF v_prod_take_up = 1 THEN
         FOR A IN
            (SELECT   booking_year, booking_mth,
                      TO_CHAR (TO_DATE (   '01-'
                                        || SUBSTR (booking_mth, 1, 3)
                                        || booking_year,
                                        'DD-MON-RRRR'
                                       ),
                               'MM'
                              )
                 FROM giis_booking_month
                WHERE (NVL (booked_tag, 'N') != 'Y')
                  AND (   booking_year >
                                    TO_NUMBER (TO_CHAR (v_issue_date, 'YYYY'))
                       OR booking_year =
                                    TO_NUMBER (TO_CHAR (v_issue_date, 'YYYY'))
                      )
                  AND (TO_NUMBER (TO_CHAR (TO_DATE (   '01-'
                                                    || SUBSTR (booking_mth,
                                                               1,
                                                               3
                                                              )
                                                    || booking_year,
                                                    'DD-MON-RRRR'
                                                   ),
                                           'MM'
                                          )
                                 ) >= TO_NUMBER (TO_CHAR (v_issue_date, 'MM'))
                      )
             ORDER BY 1, 3)
         LOOP
            v_booking_mth := A.booking_mth;
            v_booking_yr := A.booking_year;
            EXIT;
         END LOOP;
      ELSIF v_prod_take_up = 2
      THEN
         FOR A IN
            (SELECT   booking_year, booking_mth,
                      TO_CHAR (TO_DATE (   '01-'
                                        || SUBSTR (booking_mth, 1, 3)
                                        || booking_year,
                                        'DD-MON-RRRR'
                                       ),
                               'MM'
                              )
                 FROM giis_booking_month
                WHERE (NVL (booked_tag, 'N') != 'Y')
                  AND (   booking_year >
                                      TO_NUMBER (TO_CHAR (v_eff_date, 'YYYY'))
                       OR booking_year =
                                      TO_NUMBER (TO_CHAR (v_eff_date, 'YYYY'))
                      )
                  AND (TO_NUMBER (TO_CHAR (TO_DATE (   '01-'
                                                    || SUBSTR (booking_mth,
                                                               1,
                                                               3
                                                              )
                                                    || booking_year,
                                                    'DD-MON-RRRR'
                                                   ),
                                           'MM'
                                          )
                                 ) >= TO_NUMBER (TO_CHAR (v_eff_date, 'MM'))
                      )
             ORDER BY 1, 3)
         LOOP
            v_booking_mth := A.booking_mth;
            v_booking_yr := A.booking_year;
            EXIT;
         END LOOP;
      ELSIF v_prod_take_up = 3
      THEN
         IF v_issue_date > v_eff_date
         THEN
            v_later_date := v_issue_date;
         ELSIF v_eff_date > v_issue_date
         THEN
            v_later_date := v_eff_date;
         END IF;

         FOR A IN
            (SELECT   booking_year, booking_mth,
                      TO_CHAR (TO_DATE (   '01-'
                                        || SUBSTR (booking_mth, 1, 3)
                                        || booking_year,
                                        'DD-MON-RRRR'
                                       ),
                               'MM'
                              )
                 FROM giis_booking_month
                WHERE (NVL (booked_tag, 'N') != 'Y')
                  AND (   booking_year >
                                    TO_NUMBER (TO_CHAR (v_later_date, 'YYYY'))
                       OR booking_year =
                                    TO_NUMBER (TO_CHAR (v_later_date, 'YYYY'))
                      )
                  AND (TO_NUMBER (TO_CHAR (TO_DATE (   '01-'
                                                    || SUBSTR (booking_mth,
                                                               1,
                                                               3
                                                              )
                                                    || booking_year,
                                                    'DD-MON-RRRR'
                                                   ),
                                           'MM'
                                          )
                                 ) >= TO_NUMBER (TO_CHAR (v_later_date, 'MM'))
                      )
             ORDER BY 1, 3)
         LOOP
            v_booking_mth := A.booking_mth;
            v_booking_yr := A.booking_year;
            EXIT;
         END LOOP;
      ELSE
         p_out :=
            'Wrong Parameter....Please make the necessary changes in Giac_Parameters.';
      --msg_alert('Wrong Parameter....Please make the necessary changes in Giac_Parameters.','I',TRUE);
      END IF;
      
      FOR A IN (SELECT designation
                  FROM giis_assured
                 WHERE assd_no = v_assd_no)
      LOOP
         v_designation := A.designation;
         EXIT;
      END LOOP;
      
      /*added by: Nica 06.27.2012 to retrieve the address of 
        the assured if there is no address save in gipi_quote*/
      --added condition by robert 11.04.14
      IF (v_address1 IS NULL AND v_address2 IS NULL AND
         v_address3 IS NULL) OR v_quote_assd_no IS NULL THEN 
         
         FOR addr IN (SELECT mail_addr1, mail_addr2,
                             mail_addr3 
                        FROM giis_assured
                       WHERE assd_no = v_assd_no)
         LOOP
           v_address1 := addr.mail_addr1;
           v_address2 := addr.mail_addr2;
           v_address3 := addr.mail_addr3;
           EXIT;
         END LOOP;
      END IF;

      v_endt_iss_cd := NULL;
      v_foreign_acc_sw := 'N';
      v_endt_yy := 0;
      v_endt_seq_no := 0;
      v_renew_no := 0;
      v_endt_type := NULL;
      v_pol_flag := 1;
      v_mortg_name := NULL;
      v_invoice_sw := 'N';
      v_pool_pol_no := NULL;
      v_covernote_printed_sw := 'N';
      v_orig_policy_id := NULL;
      v_endt_expiry_date := NULL;
      v_no_of_items := NULL;
      v_subline_type_cd := NULL;
      v_auto_renew_flag := 'N';
      v_prov_prem_tag := 'N';
      v_type_cd := NULL;
      v_prov_prem_pct := NULL;
      v_same_polno_sw := 'N';
      v_pack_pol_flag := 'N';
      v_expiry_tag := 'N';
      v_discount_sw := 'N';
      v_prem_warr_tag := 'N';
      v_ref_pol_no := NULL;
      v_reg_policy_sw := 'Y';
      v_co_insurance_sw := 1;
      v_ref_open_pol_no := NULL;
      v_incept_tag := 'N';
      v_endt_expiry_tag := NULL;
      v_fleet_print_tag := 'N';
      v_takeup_term := giisp.v ('TAKEUP_TERM');                         -- bmq
      
      -- Apollo Cruz 10.20.2014
      -- Conversion of amounts to local rate before inserting to gipi_wpolbas
      BEGIN
      
         v_tsi_amt := 0;
         v_prem_amt := 0;
         v_ann_tsi_amt := 0;
         v_ann_prem_amt := 0;
      
         FOR i IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,
                          currency_rate
                     FROM gipi_quote_item
                   WHERE quote_id = p_quote_id)
         LOOP
            v_tsi_amt := v_tsi_amt + ROUND (NVL (i.tsi_amt, 0) * NVL (i.currency_rate, 1), 2);
            v_prem_amt := v_prem_amt + ROUND (NVL (i.prem_amt, 0) * NVL (i.currency_rate, 1), 2);
            v_ann_tsi_amt := v_ann_tsi_amt + ROUND (NVL (i.ann_tsi_amt, 0) * NVL (i.currency_rate, 1), 2);
            v_ann_prem_amt := v_ann_prem_amt + ROUND (NVL (i.ann_prem_amt, 0) * NVL (i.currency_rate, 1), 2);
         END LOOP;
      END;
      
      --Added by MarkS 10.27.2016 SR5804
      BEGIN
	      IF v_assd_no IS NOT NULL THEN
	      	 SELECT industry_cd
	          INTO v_industry_cd
	          FROM GIIS_INDUSTRY
	          WHERE industry_cd = (SELECT industry_cd 
	             FROM GIIS_ASSURED 
	                WHERE assd_no = v_assd_no);
	      ELSE 
	         v_industry_cd := NULL;
	      END IF; 
          
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            v_industry_cd := NULL;
      END;
      
      BEGIN
	      IF v_iss_cd IS NOT NULL THEN
	      	SELECT region_cd
          		INTO v_region_cd
          	FROM GIIS_REGION
          	WHERE region_cd = (SELECT region_cd 
              					FROM GIIS_ISSOURCE
              					WHERE iss_cd = v_iss_cd);
	      ELSE 
	         v_region_cd := NULL;
	      END IF; 
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
                v_region_cd := NULL;
      END;      
      --END MarkS 10.27.2016 SR5804
      

      INSERT INTO gipi_wpolbas
                  (par_id, line_cd, subline_cd, iss_cd,
                   issue_yy, pol_seq_no,
                   endt_iss_cd, endt_yy, endt_seq_no, renew_no,
                   endt_type, incept_date, expiry_date, eff_date,
                   issue_date, pol_flag, foreign_acc_sw, assd_no,
                   designation, address1, address2, address3,
                   mortg_name, tsi_amt, prem_amt, ann_tsi_amt,
                   ann_prem_amt, invoice_sw, pool_pol_no, user_id,
                   quotation_printed_sw, covernote_printed_sw,
                   orig_policy_id, endt_expiry_date, no_of_items,
                   subline_type_cd, auto_renew_flag, prorate_flag,
                   short_rt_percent, prov_prem_tag, type_cd,
                   acct_of_cd, prov_prem_pct, same_polno_sw,
                   pack_pol_flag, expiry_tag, prem_warr_tag,
                   ref_pol_no, ref_open_pol_no, reg_policy_sw,
                   co_insurance_sw, discount_sw, fleet_print_tag,
                   incept_tag, comp_sw, booking_mth, endt_expiry_tag,
                   booking_year, acct_of_cd_sw, cred_branch,
                   with_tariff_sw, bank_ref_no, takeup_term, label_tag,             -- bmq
                   industry_cd,region_cd --Added by MarkS 10.27.2016 SR5804
                  )
           VALUES (p_par_id, v_line_cd, v_subline_cd, v_iss_cd,
                   TO_NUMBER (TO_CHAR (SYSDATE, 'YY')), v_pol_seq_no,
                   v_endt_iss_cd, v_endt_yy, v_endt_seq_no, v_renew_no,
                   v_endt_type, v_incept_date, v_expiry_date, v_incept_date,
                   v_issue_date, v_pol_flag, v_foreign_acc_sw, v_assd_no,
                   v_designation, v_address1, v_address2, v_address3,
                   v_mortg_name, v_tsi_amt, v_prem_amt, v_ann_tsi_amt,
                   v_ann_prem_amt, v_invoice_sw, v_pool_pol_no, p_user,
                   v_quotation_printed_sw, v_covernote_printed_sw,
                   v_orig_policy_id, v_endt_expiry_date, v_no_of_items,
                   v_subline_type_cd, v_auto_renew_flag, v_prorate_flag,
                   v_short_rt_percent, v_prov_prem_tag, v_type_cd,
                   v_acct_of_cd, v_prov_prem_pct, v_same_polno_sw,
                   v_pack_pol_flag, v_expiry_tag, v_prem_warr_tag,
                   v_ref_pol_no, v_ref_open_pol_no, v_reg_policy_sw,
                   v_co_insurance_sw, v_discount_sw, v_fleet_print_tag,
                   v_incept_tag, v_comp_sw, v_booking_mth, v_endt_expiry_tag,
                   v_booking_yr, v_acct_of_cd_sw, v_cred_branch,
                   v_with_tariff_sw, v_bank_ref_no, v_takeup_term, v_label_tag,
                   v_industry_cd, v_region_cd --Added by MarkS 10.27.2016 SR5804
                  );

      UPDATE gipi_parlist
         SET par_status = 3
       WHERE par_id = p_par_id;
       
       --added to assign default value to cred_branch if crediting branch is null in quotation by robert 10.03.2013
        BEGIN
           IF v_cred_branch IS NULL
           THEN
              FOR x IN (SELECT c.param_value_v cp
                          FROM giis_parameters c
                         WHERE c.param_name = 'DISPLAY_DEF_CRED_BRANCH')
              LOOP
                 var_display_def_cred_branch := x.cp;
                 EXIT;
              END LOOP;

              FOR a IN (SELECT param_value_v
                          FROM giis_parameters
                         WHERE param_name = 'DEFAULT_CRED_BRANCH')
              LOOP
                 v_def_cred_branch := a.param_value_v;
                 EXIT;
              END LOOP;

              IF v_def_cred_branch = 'ISS_CD' AND var_display_def_cred_branch = 'Y'
              THEN
                 UPDATE gipi_wpolbas
                    SET cred_branch = giis_issource_pkg.get_iss_code (NULL, p_user)
                  WHERE par_id = p_par_id;
              END IF;
           END IF;
        END;

      delete_workflow_rec ('GIIMM001', USER, p_quote_id);
      COMMIT;
   END;

   PROCEDURE create_gipi_wpolbas (
      p_quote_id         NUMBER,
      p_par_id           NUMBER,
      p_line_cd          giis_line.line_cd%TYPE,
      p_iss_cd           VARCHAR2,
      p_assd_no          NUMBER,
      p_user             gipi_pack_wpolbas.user_id%TYPE,
      p_out        OUT   VARCHAR2
   )
   IS
      v_line_cd                gipi_wpolbas.line_cd%TYPE;
      v_iss_cd                 gipi_wpolbas.iss_cd%TYPE;
      v_subline_cd             gipi_wpolbas.subline_cd%TYPE;
      v_issue_yy               gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no             gipi_wpolbas.pol_seq_no%TYPE;
      v_endt_iss_cd            gipi_wpolbas.endt_iss_cd%TYPE;
      v_endt_yy                gipi_wpolbas.endt_yy%TYPE;
      v_endt_seq_no            gipi_wpolbas.endt_seq_no%TYPE;
      v_renew_no               gipi_wpolbas.renew_no%TYPE;
      v_endt_type              gipi_wpolbas.endt_type%TYPE;
      v_incept_date            gipi_wpolbas.incept_date%TYPE;
      v_expiry_date            gipi_wpolbas.expiry_date%TYPE;
      v_eff_date               gipi_wpolbas.eff_date%TYPE;
      v_issue_date             gipi_wpolbas.issue_date%TYPE;
      v_pol_flag               gipi_wpolbas.pol_flag%TYPE;
      v_foreign_acc_sw         gipi_wpolbas.foreign_acc_sw%TYPE;
      v_assd_no                gipi_wpolbas.assd_no%TYPE;
      v_designation            gipi_wpolbas.designation%TYPE;
      v_address1               gipi_wpolbas.address1%TYPE;
      v_address2               gipi_wpolbas.address2%TYPE;
      v_address3               gipi_wpolbas.address3%TYPE;
      v_mortg_name             gipi_wpolbas.mortg_name%TYPE;
      v_tsi_amt                gipi_wpolbas.tsi_amt%TYPE;
      v_prem_amt               gipi_wpolbas.prem_amt%TYPE;
      v_ann_tsi_amt            gipi_wpolbas.ann_tsi_amt%TYPE;
      v_ann_prem_amt           gipi_wpolbas.ann_prem_amt%TYPE;
      v_invoice_sw             gipi_wpolbas.invoice_sw%TYPE;
      v_pool_pol_no            gipi_wpolbas.pool_pol_no%TYPE;
      v_user_id                gipi_wpolbas.user_id%TYPE;
      v_quotation_printed_sw   gipi_wpolbas.quotation_printed_sw%TYPE;
      v_covernote_printed_sw   gipi_wpolbas.covernote_printed_sw%TYPE;
      v_orig_policy_id         gipi_wpolbas.orig_policy_id%TYPE;
      v_endt_expiry_date       gipi_wpolbas.endt_expiry_date%TYPE;
      v_no_of_items            gipi_wpolbas.no_of_items%TYPE;
      v_subline_type_cd        gipi_wpolbas.subline_type_cd%TYPE;
      v_auto_renew_flag        gipi_wpolbas.auto_renew_flag%TYPE;
      v_prorate_flag           gipi_wpolbas.prorate_flag%TYPE;
      v_short_rt_percent       gipi_wpolbas.short_rt_percent%TYPE;
      v_prov_prem_tag          gipi_wpolbas.prov_prem_tag%TYPE;
      v_type_cd                gipi_wpolbas.type_cd%TYPE;
      v_acct_of_cd             gipi_wpolbas.acct_of_cd%TYPE;
      v_prov_prem_pct          gipi_wpolbas.prov_prem_pct%TYPE;
      v_same_polno_sw          gipi_wpolbas.same_polno_sw%TYPE;
      v_pack_pol_flag          gipi_wpolbas.pack_pol_flag%TYPE;
      v_expiry_tag             gipi_wpolbas.expiry_tag%TYPE;
      v_prem_warr_tag          gipi_wpolbas.prem_warr_tag%TYPE;
      v_ref_pol_no             gipi_wpolbas.ref_pol_no%TYPE;
      v_ref_open_pol_no        gipi_wpolbas.ref_open_pol_no%TYPE;
      v_reg_policy_sw          gipi_wpolbas.reg_policy_sw%TYPE;
      v_co_insurance_sw        gipi_wpolbas.co_insurance_sw%TYPE;
      v_discount_sw            gipi_wpolbas.discount_sw%TYPE;
      v_fleet_print_tag        gipi_wpolbas.fleet_print_tag%TYPE;
      v_incept_tag             gipi_wpolbas.incept_tag%TYPE;
      v_comp_sw                gipi_wpolbas.comp_sw%TYPE;
      v_booking_mth            gipi_wpolbas.booking_mth%TYPE;
      v_endt_expiry_tag        gipi_wpolbas.endt_expiry_tag%TYPE;
      v_booking_yr             gipi_wpolbas.booking_year%TYPE;
      v_prod_take_up           giac_parameters.param_value_n%TYPE;
      v_later_date             gipi_wpolbas.issue_date%TYPE;
      v_acct_of_cd_sw          gipi_wpolbas.acct_of_cd_sw%TYPE;
      v_cred_branch            gipi_wpolbas.cred_branch%TYPE;
      v_with_tariff_sw         gipi_wpolbas.with_tariff_sw%TYPE;
      v_bank_ref_no            gipi_wpolbas.bank_ref_no%TYPE;
      v_takeup_term            gipi_wpolbas.takeup_term%TYPE;           --bmq

      CURSOR cur_b
      IS
         SELECT subline_cd, NVL (tsi_amt, 0), NVL (prem_amt, 0),
                NVL (print_tag, 'N'), incept_date, expiry_date, address1,
                address2, address3, prorate_flag, short_rt_percent, comp_sw,
                ann_prem_amt, ann_tsi_amt, acct_of_cd, acct_of_cd_sw,
                cred_branch, with_tariff_sw, bank_ref_no
           FROM gipi_quote
          WHERE quote_id = p_quote_id;
   BEGIN
      v_line_cd := p_line_cd;
      v_iss_cd := p_iss_cd;
      v_assd_no := p_assd_no;
      v_issue_date := SYSDATE;
      v_later_date := SYSDATE;

      SELECT param_value_n
        INTO v_prod_take_up
        FROM giac_parameters
       WHERE param_name = 'PROD_TAKE_UP';

      IF v_prod_take_up = 1
      THEN
         FOR A IN
            (SELECT   booking_year, booking_mth,
                      TO_CHAR (TO_DATE (   '01-'
                                        || SUBSTR (booking_mth, 1, 3)
                                        || booking_year
                                       ),
                               'MM'
                              )
                 FROM giis_booking_month
                WHERE (NVL (booked_tag, 'N') != 'Y')
                  AND (   booking_year >
                                    TO_NUMBER (TO_CHAR (v_issue_date, 'YYYY'))
                       OR booking_year =
                                    TO_NUMBER (TO_CHAR (v_issue_date, 'YYYY'))
                      )
                  AND (TO_NUMBER (TO_CHAR (TO_DATE (   '01-'
                                                    || SUBSTR (booking_mth,
                                                               1,
                                                               3
                                                              )
                                                    || booking_year
                                                   ),
                                           'MM'
                                          )
                                 ) >= TO_NUMBER (TO_CHAR (v_issue_date, 'MM'))
                      )
             ORDER BY 1, 3)
         LOOP
            v_booking_mth := A.booking_mth;
            v_booking_yr := A.booking_year;
            EXIT;
         END LOOP;
      ELSIF v_prod_take_up = 2
      THEN
         FOR A IN
            (SELECT   booking_year, booking_mth,
                      TO_CHAR (TO_DATE (   '01-'
                                        || SUBSTR (booking_mth, 1, 3)
                                        || booking_year
                                       ),
                               'MM'
                              )
                 FROM giis_booking_month
                WHERE (NVL (booked_tag, 'N') != 'Y')
                  AND (   booking_year >
                                      TO_NUMBER (TO_CHAR (v_eff_date, 'YYYY'))
                       OR booking_year =
                                      TO_NUMBER (TO_CHAR (v_eff_date, 'YYYY'))
                      )
                  AND (TO_NUMBER (TO_CHAR (TO_DATE (   '01-'
                                                    || SUBSTR (booking_mth,
                                                               1,
                                                               3
                                                              )
                                                    || booking_year
                                                   ),
                                           'MM'
                                          )
                                 ) >= TO_NUMBER (TO_CHAR (v_eff_date, 'MM'))
                      )
             ORDER BY 1, 3)
         LOOP
            v_booking_mth := A.booking_mth;
            v_booking_yr := A.booking_year;
            EXIT;
         END LOOP;
      ELSIF v_prod_take_up = 3
      THEN
         IF v_issue_date > v_eff_date
         THEN
            v_later_date := v_issue_date;
         ELSIF v_eff_date > v_issue_date
         THEN
            v_later_date := v_eff_date;
         END IF;

         FOR A IN
            (SELECT   booking_year, booking_mth,
                      TO_CHAR (TO_DATE (   '01-'
                                        || SUBSTR (booking_mth, 1, 3)
                                        || booking_year
                                       ),
                               'MM'
                              )
                 FROM giis_booking_month
                WHERE (NVL (booked_tag, 'N') != 'Y')
                  AND (   booking_year >
                                    TO_NUMBER (TO_CHAR (v_later_date, 'YYYY'))
                       OR booking_year =
                                    TO_NUMBER (TO_CHAR (v_later_date, 'YYYY'))
                      )
                  AND (TO_NUMBER (TO_CHAR (TO_DATE (   '01-'
                                                    || SUBSTR (booking_mth,
                                                               1,
                                                               3
                                                              )
                                                    || booking_year
                                                   ),
                                           'MM'
                                          )
                                 ) >= TO_NUMBER (TO_CHAR (v_later_date, 'MM'))
                      )
             ORDER BY 1, 3)
         LOOP
            v_booking_mth := A.booking_mth;
            v_booking_yr := A.booking_year;
            EXIT;
         END LOOP;
      ELSE
         p_out :=
            'Wrong Parameter....Please make the necessary changes in Giac_Parameters.';
      --msg_alert('Wrong Parameter....Please make the necessary changes in Giac_Parameters.','I',TRUE);
      END IF;

      OPEN cur_b;

      FETCH cur_b
       INTO v_subline_cd, v_tsi_amt, v_prem_amt, v_quotation_printed_sw,
            v_incept_date, v_expiry_date, v_address1, v_address2, v_address3,
            v_prorate_flag, v_short_rt_percent, v_comp_sw, v_ann_prem_amt,
            v_ann_tsi_amt, v_acct_of_cd, v_acct_of_cd_sw, v_cred_branch,
            v_with_tariff_sw, v_bank_ref_no;

      CLOSE cur_b;

      FOR A IN (SELECT designation
                  FROM giis_assured
                 WHERE assd_no = v_assd_no)
      LOOP
         v_designation := A.designation;
         EXIT;
      END LOOP;

      v_endt_iss_cd := NULL;
      v_foreign_acc_sw := 'N';
      v_endt_yy := 0;
      v_endt_seq_no := 0;
      v_renew_no := 0;
      v_endt_type := NULL;
      v_pol_flag := 1;
      v_mortg_name := NULL;
      v_invoice_sw := 'N';
      v_pool_pol_no := NULL;
      v_covernote_printed_sw := 'N';
      v_orig_policy_id := NULL;
      v_endt_expiry_date := NULL;
      v_no_of_items := NULL;
      v_subline_type_cd := NULL;
      v_auto_renew_flag := 'N';
      v_prov_prem_tag := 'N';
      v_type_cd := NULL;
      v_prov_prem_pct := NULL;
      v_same_polno_sw := 'N';
      v_pack_pol_flag := 'N';
      v_expiry_tag := 'N';
      v_discount_sw := 'N';
      v_prem_warr_tag := 'N';
      v_ref_pol_no := NULL;
      v_reg_policy_sw := 'Y';
      v_co_insurance_sw := 1;
      v_ref_open_pol_no := NULL;
      v_incept_tag := 'N';
      v_endt_expiry_tag := NULL;
      v_fleet_print_tag := 'N';
      v_takeup_term := giisp.v ('TAKEUP_TERM');                          --bmq

      INSERT INTO gipi_wpolbas
                  (par_id, line_cd, subline_cd, iss_cd,
                   issue_yy, pol_seq_no,
                   endt_iss_cd, endt_yy, endt_seq_no, renew_no,
                   endt_type, incept_date, expiry_date, eff_date,
                   issue_date, pol_flag, foreign_acc_sw, assd_no,
                   designation, address1, address2, address3,
                   mortg_name, tsi_amt, prem_amt, ann_tsi_amt,
                   ann_prem_amt, invoice_sw, pool_pol_no, user_id,
                   quotation_printed_sw, covernote_printed_sw,
                   orig_policy_id, endt_expiry_date, no_of_items,
                   subline_type_cd, auto_renew_flag, prorate_flag,
                   short_rt_percent, prov_prem_tag, type_cd,
                   acct_of_cd, prov_prem_pct, same_polno_sw,
                   pack_pol_flag, expiry_tag, prem_warr_tag,
                   ref_pol_no, ref_open_pol_no, reg_policy_sw,
                   co_insurance_sw, discount_sw, fleet_print_tag,
                   incept_tag, comp_sw, booking_mth, endt_expiry_tag,
                   booking_year, acct_of_cd_sw, cred_branch,
                   with_tariff_sw, bank_ref_no, takeup_term
                  )
           VALUES (p_par_id, v_line_cd, v_subline_cd, v_iss_cd,
                   TO_NUMBER (TO_CHAR (SYSDATE, 'YY')), v_pol_seq_no,
                   v_endt_iss_cd, v_endt_yy, v_endt_seq_no, v_renew_no,
                   v_endt_type, v_incept_date, v_expiry_date, v_incept_date,
                   v_issue_date, v_pol_flag, v_foreign_acc_sw, v_assd_no,
                   v_designation, v_address1, v_address2, v_address3,
                   v_mortg_name, v_tsi_amt, v_prem_amt, v_ann_tsi_amt,
                   v_ann_prem_amt, v_invoice_sw, v_pool_pol_no, p_user,
                   v_quotation_printed_sw, v_covernote_printed_sw,
                   v_orig_policy_id, v_endt_expiry_date, v_no_of_items,
                   v_subline_type_cd, v_auto_renew_flag, v_prorate_flag,
                   v_short_rt_percent, v_prov_prem_tag, v_type_cd,
                   v_acct_of_cd, v_prov_prem_pct, v_same_polno_sw,
                   v_pack_pol_flag, v_expiry_tag, v_prem_warr_tag,
                   v_ref_pol_no, v_ref_open_pol_no, v_reg_policy_sw,
                   v_co_insurance_sw, v_discount_sw, v_fleet_print_tag,
                   v_incept_tag, v_comp_sw, v_booking_mth, v_endt_expiry_tag,
                   v_booking_yr, v_acct_of_cd_sw, v_cred_branch,
                   v_with_tariff_sw, v_bank_ref_no, v_takeup_term
                  );

      UPDATE gipi_parlist
         SET par_status = 3
       WHERE par_id = p_par_id;

      delete_workflow_rec ('GIIMM001', USER, p_quote_id);
   END;

   PROCEDURE create_gipi_witem (p_quote_id NUMBER, p_par_id NUMBER)
   IS
      v_item_no           gipi_witem.item_no%TYPE;
      v_item_group        gipi_witem.item_grp%TYPE;
      v_item_title        gipi_witem.item_title%TYPE;
      v_item_desc         gipi_witem.item_desc%TYPE;
      v_tsi_amt           gipi_witem.tsi_amt%TYPE;
      v_prem_amt          gipi_witem.prem_amt%TYPE;
      v_ann_prem          gipi_witem.ann_prem_amt%TYPE;
      v_ann_tsi           gipi_witem.ann_tsi_amt%TYPE;
      v_rec_stat          gipi_witem.rec_flag%TYPE;
      v_currency_cd       gipi_witem.currency_cd%TYPE;
      v_currency_rt       gipi_witem.currency_rt%TYPE;
      v_group_cd          gipi_witem.group_cd%TYPE;
      v_from_date         gipi_witem.from_date%TYPE;
      v_to_date           gipi_witem.TO_DATE%TYPE;
      v_discount_sw       gipi_witem.discount_sw%TYPE;
      v_other_info        gipi_witem.other_info%TYPE;
      v_pack_line_cd      gipi_witem.pack_line_cd%TYPE;
      v_pack_subline_cd   gipi_witem.pack_subline_cd%TYPE;
      v_coverage_cd       gipi_witem.coverage_cd%TYPE;
      v_mc_motor_no       gipi_quote_item.mc_motor_no%TYPE;
      v_mc_serial_no      gipi_quote_item.mc_serial_no%TYPE;
      v_mc_plate_no       gipi_quote_item.mc_plate_no%TYPE;
      v_ann_prem_amt      gipi_quote_item.ann_prem_amt%TYPE;
      v_ann_tsi_amt       gipi_quote_item.ann_tsi_amt%TYPE;
      v_region_cd         gipi_quote_item.region_cd%TYPE;
      p_group_no          gipi_wgrouped_items.grouped_item_no%TYPE;
      p_count             NUMBER;
      v_item_desc2        gipi_witem.item_desc2%TYPE;    --added by Gzelle 09172014

      CURSOR cur_a
      IS
         SELECT item_no, item_title, item_desc, tsi_amt, prem_amt,
                b.main_currency_cd currency_cd, b.currency_rt currency_rt,
                pack_line_cd, pack_subline_cd, date_from, date_to,
                coverage_cd, A.ann_prem_amt, A.ann_tsi_amt, A.region_cd, A.item_desc2   --added by Gzelle 09172014
           FROM gipi_quote_item A, giis_currency b
          WHERE A.currency_cd = b.main_currency_cd
            AND A.currency_rate = b.currency_rt
            AND quote_id = p_quote_id;

      CURSOR cur_b
      IS
         SELECT mc_motor_no, mc_serial_no, mc_plate_no
           FROM gipi_quote_item
          WHERE quote_id = p_quote_id;
   BEGIN
      FOR A IN cur_a
      LOOP
         v_item_no := A.item_no;
         v_item_title := A.item_title;
         v_item_desc := A.item_desc;
         v_tsi_amt := A.tsi_amt;
         v_prem_amt := A.prem_amt;
         v_currency_cd := A.currency_cd;
         v_currency_rt := A.currency_rt;
         v_pack_line_cd := A.pack_line_cd;
         v_pack_subline_cd := A.pack_subline_cd;
         v_coverage_cd := A.coverage_cd;
         v_rec_stat := NULL;
         v_group_cd := NULL;
         v_from_date := A.date_from;
         v_to_date := A.date_to;
         v_discount_sw := 'N';
         v_other_info := NULL;
         v_ann_prem_amt := A.ann_prem_amt;
         v_ann_tsi_amt := A.ann_tsi_amt;
         v_region_cd := A.region_cd;
         v_item_desc2 := A.item_desc2;  --added by Gzelle 09172014

         OPEN cur_b;

         FETCH cur_b
          INTO v_mc_motor_no, v_mc_serial_no, v_mc_plate_no;

         CLOSE cur_b;
         
         
         IF a.pack_line_cd IS NOT NULL THEN
            BEGIN
               SELECT item_grp
                 INTO v_item_group
                 FROM gipi_witem
                WHERE pack_line_cd = v_pack_line_cd
                  AND pack_subline_cd = v_pack_subline_cd
                  AND currency_cd = v_currency_cd
                  AND currency_rt = v_currency_rt;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  BEGIN
                     SELECT NVL (MAX (item_grp), 0)
                       INTO p_group_no
                       FROM gipi_witem
                      WHERE pack_line_cd = v_pack_line_cd
                        AND pack_subline_cd = v_pack_subline_cd
                        AND currency_cd = v_currency_cd
                        AND currency_rt = v_currency_rt;

                     v_item_group := NVL (p_group_no, 0) + 1;
                  END;
            END;
            
         ELSE
         
            -- Apollo Cruz 10.20.2014
            -- Different way of populating item_grp for non-package lines
         
            BEGIN
               SELECT item_grp
                 INTO v_item_group
                 FROM gipi_witem
                WHERE par_id = p_par_id
                  AND currency_cd = v_currency_cd
                  AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               SELECT MAX(item_grp) + 1
                 INTO v_item_group
                 FROM gipi_witem
                WHERE par_id = p_par_id;      
            END;
         END IF;

         INSERT INTO gipi_witem
                     (par_id, item_no, item_grp, item_title,
                      item_desc, tsi_amt, prem_amt, ann_tsi_amt,
                      ann_prem_amt, rec_flag, currency_cd,
                      currency_rt, group_cd, from_date, TO_DATE,
                      pack_line_cd, pack_subline_cd, discount_sw,
                      other_info, coverage_cd, region_cd, item_desc2    --added by Gzelle 09172014
                     )
              VALUES (p_par_id, v_item_no, NVL(v_item_group, 1), v_item_title,
                      v_item_desc, v_tsi_amt, v_prem_amt, v_ann_tsi_amt,
                      v_ann_prem_amt, v_rec_stat, v_currency_cd,
                      v_currency_rt, v_group_cd, v_from_date, v_to_date,
                      v_pack_line_cd, v_pack_subline_cd, v_discount_sw,
                      v_other_info, v_coverage_cd, v_region_cd, v_item_desc2    --added by Gzelle 09172014
                     );
        p_count := 1;             
      END LOOP;
      
      IF p_count = 1 THEN
       UPDATE gipi_parlist
         SET par_status = 4
       WHERE par_id = p_par_id;
      END IF;
   END;

   PROCEDURE create_item_info (p_par_id NUMBER, p_quote_id NUMBER)
   IS
/* This procedure will check the lines included in a package quotation and
** then copy records from quotation tables to par tables depending on the
** lines.
*/
      with_mc     VARCHAR2 (1);
      with_av     VARCHAR2 (1);
      with_mh     VARCHAR2 (1);
      with_mn     VARCHAR2 (1);
      with_ca     VARCHAR2 (1);
      with_ac     VARCHAR2 (1);
      with_en     VARCHAR2 (1);
      with_fi     VARCHAR2 (1);
      with_su     VARCHAR2 (1);
      v_line_cd   giis_line.line_cd%TYPE;

      CURSOR mc
      IS
         SELECT par_id, quote_id
           FROM gipi_parlist
          WHERE par_id = p_par_id AND line_cd = giisp.v ('LINE_CODE_MC');

      CURSOR av
      IS
         SELECT par_id, quote_id
           FROM gipi_parlist
          WHERE par_id = p_par_id AND line_cd = giisp.v ('LINE_CODE_AV');

      CURSOR mh
      IS
         SELECT par_id, quote_id
           FROM gipi_parlist
          WHERE par_id = p_par_id AND line_cd = giisp.v ('LINE_CODE_MH');

      CURSOR mn
      IS
         SELECT par_id, quote_id
           FROM gipi_parlist
          WHERE par_id = p_par_id AND line_cd = giisp.v ('LINE_CODE_MN');

      CURSOR ca
      IS
         SELECT par_id, quote_id
           FROM gipi_parlist
          WHERE par_id = p_par_id AND line_cd = giisp.v ('LINE_CODE_CA');

      CURSOR ac
      IS
         SELECT par_id, quote_id
           FROM gipi_parlist
          WHERE par_id = p_par_id AND line_cd = giisp.v ('LINE_CODE_AC');

      CURSOR en
      IS
         SELECT par_id, quote_id
           FROM gipi_parlist
          WHERE par_id = p_par_id AND line_cd = giisp.v ('LINE_CODE_EN');

      CURSOR fi
      IS
         SELECT par_id, quote_id
           FROM gipi_parlist
          WHERE par_id = p_par_id AND line_cd = giisp.v ('LINE_CODE_FI');
          
      -- added by grace 09.19.2012
      -- to handle transfer of bond policy date to PAR
      CURSOR su
      IS
         SELECT par_id, quote_id
           FROM gipi_parlist
          WHERE par_id = p_par_id AND line_cd = giisp.v ('LINE_CODE_SU');
      
      --modified by gab 09.09.2016 SR 22761
      CURSOR par (p_menu_line_cd IN GIIS_LINE.MENU_LINE_CD%TYPE,
                  p_line_cd      IN GIIS_LINE.LINE_CD%TYPE)
      IS
         SELECT par_id, quote_id
           FROM gipi_parlist
          WHERE par_id = p_par_id 
            AND line_cd = (SELECT line_cd
                             FROM giis_line
                            WHERE NVL(menu_line_cd, line_cd) = p_menu_line_cd
                              AND line_cd = p_line_cd);
        
      v_menu_line_cd        GIIS_MENU_LINE.MENU_LINE_CD%TYPE;
              
   BEGIN
      FOR x IN (SELECT quote_id, line_cd, subline_cd, remarks, assd_no
                  FROM gipi_quote
                 WHERE quote_id = p_quote_id)
      LOOP
         v_line_cd := x.line_cd;
         
         BEGIN
            SELECT NVL(menu_line_cd, line_cd)
              INTO v_menu_line_cd
              FROM giis_line
             WHERE line_cd = v_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_menu_line_cd := NULL;
         END;

         /*IF v_line_cd = giisp.v ('LINE_CODE_MC')
         THEN
            with_mc := 'Y';
         ELSIF v_line_cd = giisp.v ('LINE_CODE_AV')
         THEN
            with_av := 'Y';
         ELSIF v_line_cd = giisp.v ('LINE_CODE_MH')
         THEN
            with_mh := 'Y';
         ELSIF v_line_cd = giisp.v ('LINE_CODE_MN')
         THEN
            with_mn := 'Y';
         ELSIF v_line_cd = giisp.v ('LINE_CODE_CA')
         THEN
            with_ca := 'Y';
         ELSIF v_line_cd = giisp.v ('LINE_CODE_AC')
         THEN
            with_ac := 'Y';
         ELSIF v_line_cd = giisp.v ('LINE_CODE_EN')
         THEN
            with_en := 'Y';
         ELSIF v_line_cd = giisp.v ('LINE_CODE_FI')
         THEN
            with_fi := 'Y';
         ELSIF v_line_cd = giisp.v ('LINE_CODE_SU')
         THEN
            with_su := 'Y';   
         END IF;*/
         
         IF v_menu_line_cd = 'MC'
         THEN
            with_mc := 'Y';
         ELSIF v_menu_line_cd = 'AV'
         THEN
            with_av := 'Y';
         ELSIF v_menu_line_cd = 'MH'
         THEN
            with_mh := 'Y';
         ELSIF v_menu_line_cd = 'MN'
         THEN
            with_mn := 'Y';
         ELSIF v_menu_line_cd = 'CA'
         THEN
            with_ca := 'Y';
         ELSIF v_menu_line_cd = 'AC'
         THEN
            with_ac := 'Y';
         ELSIF v_menu_line_cd = 'EN'
         THEN
            with_en := 'Y';
         ELSIF v_menu_line_cd = 'FI'
         THEN
            with_fi := 'Y';
         ELSIF v_menu_line_cd = 'SU'
         THEN
            with_su := 'Y';   
         END IF;
      END LOOP;

      IF with_mc = 'Y'
      THEN
/* This will copy records from gipi_quote_item_mc
** to gipi_wvehicle during creation of PAR from a package
** quotation.
*/
         FOR parlist_rec IN par(v_menu_line_cd, v_line_cd) -- mc --edited by gab 09.09.2016 SR 22761
         LOOP
            FOR v IN
               (      /*SELECT item_no, plate_no, motor_no, serial_no,
                             subline_type_cd, subline_cd, mot_type, coc_yy,
                             coc_seq_no, coc_type, repair_lim, color,
                             model_year, make, est_value, towing, assignee,
                             no_of_pass, tariff_zone, coc_issue_date,
                             mv_file_no, acquired_from, ctv_tag,
                             type_of_body_cd, unladen_wt, make_cd, series_cd,
                             basic_color_cd, color_cd, origin, destination,
                             coc_atcn, car_company_cd, coc_serial_no
                        FROM gipi_quote_item_mc
                       WHERE quote_id = p_quote_id*/
                SELECT b.item_no, b.plate_no, b.motor_no, b.serial_no,
                       b.subline_type_cd, A.subline_cd, b.mot_type, b.coc_yy,
                       b.coc_seq_no, b.coc_type, b.repair_lim, b.color,
                       b.model_year, b.make, b.est_value, b.towing,
                       b.assignee, b.no_of_pass, b.tariff_zone,
                       b.coc_issue_date, b.mv_file_no, b.acquired_from,
                       b.ctv_tag, b.type_of_body_cd, b.unladen_wt, b.make_cd,
                       b.series_cd, b.basic_color_cd, b.color_cd, b.origin,
                       b.destination, b.coc_atcn, b.car_company_cd,
                       b.coc_serial_no
                  FROM gipi_quote A, gipi_quote_item_mc b
                 WHERE A.quote_id = p_quote_id AND A.quote_id = b.quote_id)
            LOOP
               INSERT INTO gipi_wvehicle
                           (par_id, item_no, subline_cd,
                            motor_no, plate_no, serial_no,
                            subline_type_cd, mot_type, coc_yy,
                            coc_seq_no, coc_type, repair_lim, color,
                            model_year, make, est_value, towing,
                            assignee, no_of_pass, tariff_zone,
                            coc_issue_date, mv_file_no, acquired_from,
                            ctv_tag, type_of_body_cd, unladen_wt,
                            make_cd, series_cd, basic_color_cd,
                            color_cd, origin, destination, coc_atcn,
                            car_company_cd, coc_serial_no
                           )
                    VALUES (p_par_id, v.item_no, v.subline_cd,
                            NVL(v.motor_no, '-'), v.plate_no, v.serial_no, -- add nvl to motor_no to prevent inserting null value to motor_no Nica 06.29.2012
                            v.subline_type_cd, v.mot_type, v.coc_yy,
                            v.coc_seq_no, v.coc_type, v.repair_lim, v.color,
                            v.model_year, v.make, v.est_value, v.towing,
                            v.assignee, v.no_of_pass, v.tariff_zone,
                            v.coc_issue_date, v.mv_file_no, v.acquired_from,
                            v.ctv_tag, v.type_of_body_cd, v.unladen_wt,
                            v.make_cd, v.series_cd, v.basic_color_cd,
                            v.color_cd, v.origin, v.destination, v.coc_atcn,
                            v.car_company_cd, v.coc_serial_no
                           );
            END LOOP;
         END LOOP;
      END IF;                                                -- end of with_mc

      IF with_av = 'Y'
      THEN
/* This will copy records from gipi_quote_av_item
** to gipi_waviation_item during creation of PAR from a package
** quotation.
*/
         FOR parlist_rec IN par(v_menu_line_cd, v_line_cd) -- av --edited by gab 09.09.2016 SR 22761
         LOOP
            FOR rec IN (SELECT item_no, vessel_cd, total_fly_time,
                               qualification, purpose, geog_limit,
                               deduct_text, rec_flag, fixed_wing, rotor,
                               prev_util_hrs, est_util_hrs
                          FROM gipi_quote_av_item
                         WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_waviation_item
                           (par_id, item_no, vessel_cd,
                            total_fly_time, qualification,
                            purpose, geog_limit, deduct_text,
                            rec_flag, fixed_wing, rotor,
                            prev_util_hrs, est_util_hrs
                           )
                    VALUES (p_par_id, rec.item_no, rec.vessel_cd,
                            rec.total_fly_time, rec.qualification,
                            rec.purpose, rec.geog_limit, rec.deduct_text,
                            rec.rec_flag, rec.fixed_wing, rec.rotor,
                            rec.prev_util_hrs, rec.est_util_hrs
                           );
            END LOOP;
         END LOOP;
      END IF;                                                -- end of with_av

      IF with_mh = 'Y'
      THEN
         FOR parlist_rec IN par(v_menu_line_cd, v_line_cd) -- mh --edited by gab 09.09.2016 SR 22761
         LOOP
            FOR rec IN (SELECT item_no, vessel_cd, geog_limit, rec_flag,
                               deduct_text, dry_date, dry_place
                          FROM gipi_quote_mh_item
                         WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_witem_ves
                           (par_id, item_no, vessel_cd,
                            geog_limit, rec_flag, deduct_text,
                            dry_date, dry_place
                           )
                    VALUES (p_par_id, rec.item_no, rec.vessel_cd,
                            rec.geog_limit, rec.rec_flag, rec.deduct_text,
                            rec.dry_date, rec.dry_place
                           );
            END LOOP;
         END LOOP;
      END IF;                                                -- end of with_mh

      IF with_mn = 'Y'
      THEN
/* This will copy recorsd from gipi_quote_cargo to gipi_wcargo.
** The column rec_flag in gipi_wcargo is hardcoded to 'A' since
** it cannot be null. In the marketing modules, the column rec_flag
** in gipi_quote_cargo is not populated.
*/
         FOR parlist_rec IN par(v_menu_line_cd, v_line_cd) -- mn --edited by gab 09.09.2016 SR 22761
         LOOP
            --added by Gzelle 01052014 - Carrier Information
            FOR r IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                        FROM gipi_quote_ves_air
                       WHERE quote_id = p_quote_id)
            LOOP
               IF r.vessel_cd IS NOT NULL THEN 
                   INSERT INTO gipi_wves_air
                               (par_id, vessel_cd, rec_flag,
                                vescon, voy_limit
                               )
                        VALUES (p_par_id, r.vessel_cd, r.rec_flag,
                                r.vescon, r.voy_limit
                               );
                 END IF;          
            END LOOP;  
                     
            FOR rec IN (SELECT item_no, vessel_cd, geog_cd, cargo_class_cd,
                               voyage_no, bl_awb, origin, destn, etd, eta,
                               cargo_type, pack_method, tranship_origin,
                               tranship_destination, lc_no, print_tag
                          FROM gipi_quote_cargo
                         WHERE quote_id = p_quote_id)
            LOOP
               IF rec.vessel_cd IS NOT NULL THEN 
                   INSERT INTO gipi_wcargo
                               (par_id, item_no, vessel_cd,
                                geog_cd, cargo_class_cd, voyage_no,
                                bl_awb, origin, destn, etd,
                                eta, cargo_type, pack_method,
                                tranship_origin, tranship_destination,
                                lc_no, print_tag, rec_flag
                               )
                        VALUES (p_par_id, rec.item_no, rec.vessel_cd,
                                rec.geog_cd, rec.cargo_class_cd, rec.voyage_no,
                                rec.bl_awb, rec.origin, rec.destn, rec.etd,
                                rec.eta, rec.cargo_type, rec.pack_method,
                                rec.tranship_origin, rec.tranship_destination,
                                rec.lc_no, rec.print_tag, 'A'
                               );
                 END IF;          
            END LOOP;
         END LOOP;
      END IF;                                                -- end of with_mn

      IF with_ca = 'Y'
      THEN
         FOR parlist_rec IN par(v_menu_line_cd, v_line_cd) -- ca --edited by gab 09.09.2016 SR 22761
         LOOP
            FOR rec IN (SELECT item_no, capacity_cd, conveyance_info,
                               interest_on_premises, limit_of_liability,
                               LOCATION, property_no, property_no_type,
                               section_line_cd, section_or_hazard_cd,
                               section_or_hazard_info, section_subline_cd
                          FROM gipi_quote_ca_item
                         WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_wcasualty_item
                           (par_id, item_no, capacity_cd,
                            conveyance_info, interest_on_premises,
                            limit_of_liability, LOCATION,
                            property_no, property_no_type,
                            section_line_cd, section_or_hazard_cd,
                            section_or_hazard_info,
                            section_subline_cd
                           )
                    VALUES (p_par_id, rec.item_no, rec.capacity_cd,
                            rec.conveyance_info, rec.interest_on_premises,
                            rec.limit_of_liability, rec.LOCATION,
                            rec.property_no, rec.property_no_type,
                            rec.section_line_cd, rec.section_or_hazard_cd,
                            rec.section_or_hazard_info,
                            rec.section_subline_cd
                           );
            END LOOP;
         END LOOP;
      END IF;                                                -- end of with_ca

      IF with_ac = 'Y'
      THEN
         FOR parlist_rec IN par(v_menu_line_cd, v_line_cd) -- ac --edited by gab 09.09.2016 SR 22761
         LOOP
            FOR rec IN (SELECT item_no, destination, monthly_salary,
                               no_of_persons, position_cd, salary_grade, age,
                               civil_status, date_of_birth, height, sex,
                               weight
                          FROM gipi_quote_ac_item
                         WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_waccident_item
                           (par_id, item_no, destination,
                            monthly_salary, no_of_persons,
                            position_cd, salary_grade, age,
                            civil_status, date_of_birth, height,
                            sex, weight
                           )
                    VALUES (p_par_id, rec.item_no, rec.destination,
                            rec.monthly_salary, rec.no_of_persons,
                            rec.position_cd, rec.salary_grade, rec.age,
                            rec.civil_status, rec.date_of_birth, rec.height,
                            rec.sex, rec.weight
                           );
            END LOOP;
         END LOOP;
      END IF;                                                -- end of with_ac

      IF with_su = 'Y'
      THEN
         FOR parlist_rec IN par(v_menu_line_cd, v_line_cd) -- su --edited by gab 09.09.2016 SR 22761
         LOOP
            FOR rec IN (SELECT obligee_no, prin_id, val_period_unit,
                               val_period, coll_flag, clause_type, np_no,
                               contract_dtl, contract_date, co_prin_sw,
                               waiver_limit, indemnity_text, bond_dtl, 
                               endt_eff_date, remarks
                          FROM gipi_quote_bond_basic
                         WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_wbond_basic
                           (par_id, obligee_no, prin_id, val_period_unit,
                               val_period, coll_flag, clause_type, np_no,
                               contract_dtl, contract_date, co_prin_sw,
                               waiver_limit, indemnity_text, bond_dtl, 
                               endt_eff_date, remarks
                           )
                    VALUES (p_par_id, rec.obligee_no, rec.prin_id, 
                            rec.val_period_unit, rec.val_period, rec.coll_flag, 
                            rec.clause_type, rec.np_no, rec.contract_dtl, 
                            rec.contract_date, rec.co_prin_sw, rec.waiver_limit, 
                            rec.indemnity_text, rec.bond_dtl, 
                            rec.endt_eff_date, rec.remarks
                           );
            END LOOP;
         END LOOP;
      END IF;                                                -- end of with_su

      IF with_en = 'Y'
      THEN
         FOR parlist_rec IN par(v_menu_line_cd, v_line_cd) -- en --edited by gab 09.09.2016 SR 22761
         LOOP
            FOR rec IN (SELECT construct_end_date, construct_start_date,
                               contract_proj_buss_title, engg_basic_infonum,
                               maintain_end_date, maintain_start_date,
                               mbi_policy_no, site_location,
                               testing_end_date, testing_start_date,
                               time_excess, weeks_test
                          FROM gipi_quote_en_item
                         WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_wengg_basic
                           (par_id, construct_end_date,
                            construct_start_date,
                            contract_proj_buss_title,
                            engg_basic_infonum, maintain_end_date,
                            maintain_start_date, mbi_policy_no,
                            site_location, testing_end_date,
                            testing_start_date, time_excess,
                            weeks_test
                           )
                    VALUES (p_par_id, rec.construct_end_date,
                            rec.construct_start_date,
                            rec.contract_proj_buss_title,
                            rec.engg_basic_infonum, rec.maintain_end_date,
                            rec.maintain_start_date, rec.mbi_policy_no,
                            rec.site_location, rec.testing_end_date,
                            rec.testing_start_date, rec.time_excess,
                            rec.weeks_test
                           );
            END LOOP;
         END LOOP;
      END IF;                                                -- end of with_en

      IF with_fi = 'Y'
      THEN
         FOR parlist_rec IN par(v_menu_line_cd, v_line_cd) -- fi --edited by gab 09.09.2016 SR 22761
         LOOP
            FOR rec IN (SELECT item_no, assignee, block_id, block_no,
                               construction_cd, construction_remarks,
                               district_no, eq_zone, flood_zone,
                               fr_item_type, front, LEFT, loc_risk1,
                               loc_risk2, loc_risk3, occupancy_cd,
                               occupancy_remarks, rear, RIGHT, tarf_cd,
                               tariff_zone, typhoon_zone, risk_cd,
                               latitude,longitude --Added by MarkS 02/09/2017 SR5918
                               
                          FROM gipi_quote_fi_item
                         WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_wfireitm
                           (par_id, item_no, assignee,
                            block_id, block_no, construction_cd,
                            construction_remarks, district_no,
                            eq_zone, flood_zone, fr_item_type,
                            front, LEFT, loc_risk1,
                            loc_risk2, loc_risk3, occupancy_cd,
                            occupancy_remarks, rear, RIGHT,
                            tarf_cd, tariff_zone, typhoon_zone,
                            risk_cd,
                            latitude,longitude --Added by MarkS 02/09/2017 SR5918
                           )
                    VALUES (p_par_id, rec.item_no, rec.assignee,
                            rec.block_id, rec.block_no, rec.construction_cd,
                            rec.construction_remarks, rec.district_no,
                            rec.eq_zone, rec.flood_zone, rec.fr_item_type,
                            rec.front, rec.LEFT, rec.loc_risk1,
                            rec.loc_risk2, rec.loc_risk3, rec.occupancy_cd,
                            rec.occupancy_remarks, rec.rear, rec.RIGHT,
                            rec.tarf_cd, rec.tariff_zone, rec.typhoon_zone,
                            rec.risk_cd,
                            rec.latitude,rec.longitude --Added by MarkS 02/09/2017 SR5918
                           );

               IF rec.item_no IS NOT NULL
               THEN
                  FOR A IN (SELECT region_cd
                              FROM giis_block A, giis_province b
                             WHERE A.province_cd = b.province_cd
                               AND A.block_id = rec.block_id)
                  LOOP
                     UPDATE gipi_witem
                        SET region_cd = A.region_cd
                      WHERE par_id = p_par_id AND item_no = rec.item_no;

                     EXIT;
                  END LOOP;
               END IF;
            END LOOP;
         END LOOP;
      END IF;                                                -- end of with_fi
   END;

   PROCEDURE create_peril_wc (p_par_id NUMBER)
/* This procedure will insert records in
** gipi_witmperl and gipi_wpolwc.
*/
   IS
      v_item_no        gipi_witmperl.item_no%TYPE;
      v_line_cd        gipi_witmperl.line_cd%TYPE;
      v_peril_cd       gipi_witmperl.peril_cd%TYPE;
      v_tarf_cd        gipi_witmperl.tarf_cd%TYPE;
      v_prem_rt        gipi_witmperl.prem_rt%TYPE;
      v_tsi_amt        gipi_witmperl.tsi_amt%TYPE;
      v_prem_amt       gipi_witmperl.prem_amt%TYPE;
      v_ann_tsi_amt    gipi_witmperl.ann_tsi_amt%TYPE;
      v_ann_prem_amt   gipi_witmperl.ann_prem_amt%TYPE;
      v_rec_flag       gipi_witmperl.rec_flag%TYPE;
      v_comp_rem       gipi_witmperl.comp_rem%TYPE;
      v_discount_sw    gipi_witmperl.discount_sw%TYPE;
      v_ri_comm_rate   gipi_witmperl.ri_comm_rate%TYPE;
      v_ri_comm_amt    gipi_witmperl.ri_comm_amt%TYPE;
      v_count          NUMBER;

      CURSOR par
      IS
         SELECT par_id, quote_id, line_cd
           FROM gipi_parlist
          WHERE par_id = p_par_id;
   BEGIN
      FOR x IN par
      LOOP
         FOR A IN (SELECT item_no, peril_cd, prem_rt, tsi_amt, prem_amt,
                          ann_prem_amt, ann_tsi_amt, comp_rem
                     FROM gipi_quote_itmperil
                    WHERE quote_id = x.quote_id)
         LOOP
            v_item_no := A.item_no;
            v_peril_cd := A.peril_cd;
            v_prem_rt := A.prem_rt;
            v_tsi_amt := A.tsi_amt;
            v_prem_amt := A.prem_amt;
            v_tarf_cd := NULL;
            v_rec_flag := NULL;
            v_comp_rem := A.comp_rem;   --NULL; modified by Gzelle 09172014
            v_discount_sw := 'N';
            v_ri_comm_rate := NULL;
            v_ri_comm_amt := 0;
            v_ann_tsi_amt := A.ann_tsi_amt;
            v_ann_prem_amt := A.ann_prem_amt;

            INSERT INTO gipi_witmperl
                        (par_id, item_no, line_cd, peril_cd,
                         tarf_cd, prem_rt, tsi_amt, prem_amt,
                         ann_tsi_amt, ann_prem_amt, rec_flag,
                         comp_rem, discount_sw, ri_comm_rate,
                         ri_comm_amt
                        )
                 VALUES (p_par_id, v_item_no, x.line_cd, v_peril_cd,
                         v_tarf_cd, v_prem_rt, v_tsi_amt, v_prem_amt,
                         v_ann_tsi_amt, v_ann_prem_amt, v_rec_flag,
                         v_comp_rem, v_discount_sw, v_ri_comm_rate,
                         v_ri_comm_amt
                        );
            v_count := 1;         
         END LOOP;

         FOR rec IN (SELECT change_tag, line_cd, print_seq_no, print_sw,
                            wc_cd, wc_remarks, wc_text01, wc_text02,
                            wc_text03, wc_text04, wc_text05, wc_text06,
                            wc_text07, wc_text08, wc_text09, wc_text10,
                            wc_text11, wc_text12, wc_text13, wc_text14,
                            wc_text15, wc_text16, wc_text17, wc_title
                       FROM gipi_quote_wc
                      WHERE quote_id = x.quote_id)
         LOOP
            INSERT INTO gipi_wpolwc
                        (par_id, change_tag, line_cd,
                         print_seq_no, print_sw, wc_cd,
                         wc_remarks, wc_text01, wc_text02,
                         wc_text03, wc_text04, wc_text05,
                         wc_text06, wc_text07, wc_text08,
                         wc_text09, wc_text10, wc_text11,
                         wc_text12, wc_text13, wc_text14,
                         wc_text15, wc_text16, wc_text17,
                         wc_title, swc_seq_no
                        )
                 VALUES (p_par_id, rec.change_tag, rec.line_cd,
                         rec.print_seq_no, rec.print_sw, rec.wc_cd,
                         rec.wc_remarks, rec.wc_text01, rec.wc_text02,
                         rec.wc_text03, rec.wc_text04, rec.wc_text05,
                         rec.wc_text06, rec.wc_text07, rec.wc_text08,
                         rec.wc_text09, rec.wc_text10, rec.wc_text11,
                         rec.wc_text12, rec.wc_text13, rec.wc_text14,
                         rec.wc_text15, rec.wc_text16, rec.wc_text17,
                         rec.wc_title, 0
                        );
         END LOOP;
      END LOOP;
      
      IF v_count = 1 THEN
       UPDATE gipi_parlist
         SET par_status = 5
       WHERE par_id = p_par_id;
      END IF;
   END;

   PROCEDURE create_dist_deduct (p_par_id NUMBER)
/* This procedure will create distribution and deductible records
*/
   IS
      p_dist_no       giuw_pol_dist.dist_no%TYPE;
      v_tsi_amt       gipi_polbasic.ann_tsi_amt%TYPE;
      v_ann_tsi_amt   gipi_polbasic.ann_tsi_amt%TYPE;
      v_prem_amt      gipi_polbasic.ann_prem_amt%TYPE;
      p_eff_date      gipi_wpolbas.incept_date%TYPE;
      p_expiry_date   gipi_wpolbas.expiry_date%TYPE;

      CURSOR par
      IS
         SELECT par_id, quote_id, line_cd
           FROM gipi_parlist
          WHERE par_id = p_par_id;
   BEGIN
      FOR dist_ded IN par
      LOOP
         SELECT pol_dist_dist_no_s.NEXTVAL
           INTO p_dist_no
           FROM DUAL;

         FOR A IN (SELECT SUM (tsi_amt * currency_rt) tsi,
                          SUM (ann_tsi_amt * currency_rt) ann_tsi,
                          SUM (prem_amt * currency_rt) prem
                     FROM gipi_witem
                    WHERE par_id = p_par_id)
         LOOP
            v_tsi_amt := A.tsi;
            v_ann_tsi_amt := A.ann_tsi;
            v_prem_amt := A.prem;
         END LOOP;

         FOR b IN (SELECT incept_date, expiry_date
                     FROM gipi_quote
                    WHERE quote_id = dist_ded.quote_id)
         LOOP
            p_eff_date := b.incept_date;
            p_expiry_date := b.expiry_date;
         END LOOP;

         INSERT INTO giuw_pol_dist
                     (dist_no, par_id, tsi_amt,
                      prem_amt, ann_tsi_amt, dist_flag, redist_flag,
                      eff_date, expiry_date, create_date, user_id,
                      last_upd_date, post_flag, auto_dist
                     )
              VALUES (p_dist_no, p_par_id, NVL (v_tsi_amt, 0),
                      NVL (v_prem_amt, 0), NVL (v_ann_tsi_amt, 0), 1, 1,
                      p_eff_date, p_expiry_date, SYSDATE, USER,
                      SYSDATE, 'O', 'N'
                     );

         FOR rec IN (SELECT ded_deductible_cd, deductible_amt, deductible_rt,
                            deductible_text, item_no, peril_cd,
                            -- added nieko 04052016 UW-SPECS-2015-086 Quotation Deductibles
                            aggregate_sw, ceiling_sw, create_date, 
                            create_user, max_amt, min_amt,
                            range_sw
                            -- added nieko 04052016 end
                       FROM gipi_quote_deductibles
                      WHERE quote_id = dist_ded.quote_id)
         LOOP
            FOR A IN (SELECT line_cd, subline_cd
                        FROM gipi_quote
                       WHERE quote_id = dist_ded.quote_id)
            LOOP
               INSERT INTO gipi_wdeductibles
                           (par_id, ded_line_cd, ded_subline_cd,
                            ded_deductible_cd, deductible_amt,
                            deductible_rt, deductible_text,
                            item_no, peril_cd,
                            -- added nieko 04052016 UW-SPECS-2015-086 Quotation Deductibles
                            aggregate_sw, ceiling_sw, create_date, 
                            create_user, max_amt, min_amt,
                            range_sw
                            -- added nieko 04052016 end
                           )
                    VALUES (p_par_id, A.line_cd, A.subline_cd,
                            rec.ded_deductible_cd, rec.deductible_amt,
                            rec.deductible_rt, rec.deductible_text,
                            rec.item_no, rec.peril_cd,
                            -- added nieko 04052016 UW-SPECS-2015-086 Quotation Deductibles
                            rec.aggregate_sw, rec.ceiling_sw, rec.create_date, 
                            rec.create_user, rec.max_amt, rec.min_amt,
                            rec.range_sw
                            -- added nieko 04052016 end
                           );

               EXIT;
            END LOOP;
         END LOOP;
      END LOOP;
   END;

   PROCEDURE create_discounts (p_par_id NUMBER)
/* This procedure will insert records into the discount tables
*/
   IS
      CURSOR par
      IS
         SELECT par_id, quote_id
           FROM gipi_parlist
          WHERE par_id = p_par_id;
   BEGIN
      FOR disc IN par
      LOOP
         FOR witem IN (SELECT surcharge_rt, surcharge_amt, subline_cd,
                              SEQUENCE, remarks, orig_prem_amt, net_prem_amt,
                              net_gross_tag, line_cd, item_no, disc_rt,
                              disc_amt
                         FROM gipi_quote_item_discount
                        WHERE quote_id = disc.quote_id)
         LOOP
            INSERT INTO gipi_witem_discount
                        (par_id, line_cd, item_no,
                         subline_cd, disc_rt, disc_amt,
                         net_gross_tag, orig_prem_amt,
                         SEQUENCE, remarks, net_prem_amt,
                         surcharge_rt, surcharge_amt
                        )
                 VALUES (p_par_id, witem.line_cd, witem.item_no,
                         witem.subline_cd, witem.disc_rt, witem.disc_amt,
                         witem.net_gross_tag, witem.orig_prem_amt,
                         witem.SEQUENCE, witem.remarks, witem.net_prem_amt,
                         witem.surcharge_rt, witem.surcharge_amt
                        );
         END LOOP;

         FOR peril IN (SELECT item_no, line_cd, peril_cd, disc_rt, level_tag,
                              disc_amt, net_gross_tag, discount_tag,
                              subline_cd, orig_peril_prem_amt, SEQUENCE,
                              net_prem_amt, remarks, surcharge_rt,
                              surcharge_amt
                         FROM gipi_quote_peril_discount
                        WHERE quote_id = disc.quote_id)
         LOOP
            INSERT INTO gipi_wperil_discount
                        (par_id, item_no, line_cd,
                         peril_cd, disc_rt, level_tag,
                         disc_amt, net_gross_tag,
                         discount_tag, subline_cd,
                         orig_peril_prem_amt, SEQUENCE,
                         net_prem_amt, remarks,
                         surcharge_rt, surcharge_amt
                        )
                 VALUES (p_par_id, peril.item_no, peril.line_cd,
                         peril.peril_cd, peril.disc_rt, peril.level_tag,
                         peril.disc_amt, peril.net_gross_tag,
                         peril.discount_tag, peril.subline_cd,
                         peril.orig_peril_prem_amt, peril.SEQUENCE,
                         peril.net_prem_amt, peril.remarks,
                         peril.surcharge_rt, peril.surcharge_amt
                        );
         END LOOP;

         FOR rec IN (SELECT line_cd, subline_cd, disc_rt, disc_amt,
                            net_gross_tag, orig_prem_amt, SEQUENCE,
                            net_prem_amt, remarks, surcharge_rt,
                            surcharge_amt
                       FROM gipi_quote_polbasic_discount
                      WHERE quote_id = disc.quote_id)
         LOOP
            INSERT INTO gipi_wpolbas_discount
                        (par_id, line_cd, subline_cd, disc_rt,
                         disc_amt, net_gross_tag, orig_prem_amt,
                         SEQUENCE, remarks, net_prem_amt,
                         surcharge_rt, surcharge_amt
                        )
                 VALUES (p_par_id, rec.line_cd, rec.subline_cd, rec.disc_rt,
                         rec.disc_amt, rec.net_gross_tag, rec.orig_prem_amt,
                         rec.SEQUENCE, rec.remarks, rec.net_prem_amt,
                         rec.surcharge_rt, rec.surcharge_amt
                        );
         END LOOP;
      END LOOP;
   END;

   PROCEDURE insert_reminder (p_quote_id NUMBER, p_par_id NUMBER)
   IS
      v_note_id        gipi_quote_reminder.note_id%TYPE;
      v_note_type      gipi_quote_reminder.note_type%TYPE;
      v_note_subject   gipi_quote_reminder.note_subject%TYPE;
      v_note_text      gipi_quote_reminder.note_text%TYPE;
      v_alarm_flag     gipi_quote_reminder.alarm_flag%TYPE;
      v_alarm_date     gipi_quote_reminder.alarm_date%TYPE;
      v_alarm_user     gipi_quote_reminder.alarm_user%TYPE;
      v_date_created   gipi_quote_reminder.date_created%TYPE;
      v_user_id        gipi_quote_reminder.user_id%TYPE;
   BEGIN
      FOR x IN (SELECT note_id, note_type, note_subject, note_text,
                       alarm_flag, alarm_date, alarm_user, date_created,
                       user_id
                  FROM gipi_quote_reminder
                 WHERE quote_id = p_quote_id)
      LOOP
         v_note_id := x.note_id;
         v_note_type := x.note_type;
         v_note_subject := x.note_subject;
         v_note_text := x.note_text;
         v_alarm_flag := x.alarm_flag;
         v_alarm_date := x.alarm_date;
         v_alarm_user := x.alarm_user;
         v_date_created := x.date_created;
         v_user_id := x.user_id;

         INSERT INTO gipi_reminder
                     (quote_id, par_id, note_id, note_type,
                      note_subject, note_text, alarm_flag,
                      alarm_date, alarm_user, date_created, user_id,
                      renew_flag
                     )
              VALUES (p_quote_id, p_par_id, v_note_id, v_note_type,
                      v_note_subject, v_note_text, v_alarm_flag,
                      v_alarm_date, v_alarm_user, v_date_created, v_user_id,
                      'Y'
                     );
      END LOOP;
   END;

   PROCEDURE delete_workflow_rec (
      p_module_id        VARCHAR2,
      p_user        IN   VARCHAR2,
      p_col_value   IN   VARCHAR2
   )
   IS
      v_tran_id   gipi_user_events.tran_id%TYPE;
   BEGIN
      FOR a_rec IN (SELECT b.event_user_mod, c.event_col_cd
                      FROM giis_events_column c,
                           giis_event_mod_users b,
                           giis_event_modules A
                     WHERE 1 = 1
                       AND c.event_cd = A.event_cd
                       AND c.event_mod_cd = A.event_mod_cd
                       AND b.event_mod_cd = A.event_mod_cd
                       --AND b.userid = p_user
                       AND A.module_id = p_module_id)
      LOOP
         FOR b_rec IN (SELECT b.col_value, b.tran_id, b.event_col_cd,
                              b.event_user_mod, b.SWITCH, b.user_id
                         FROM gipi_user_events b
                        WHERE b.event_user_mod = a_rec.event_user_mod
                          AND b.event_col_cd = a_rec.event_col_cd)
         LOOP
            IF b_rec.col_value = p_col_value
            THEN
               BEGIN
                  INSERT INTO gipi_user_events_hist
                              (event_user_mod, event_col_cd,
                               tran_id, col_value, date_received,
                               old_userid, new_userid
                              )
                       VALUES (b_rec.event_user_mod, b_rec.event_col_cd,
                               b_rec.tran_id, b_rec.col_value, SYSDATE,
                               USER, '-'
                              );

                  DELETE FROM gipi_user_events
                        WHERE event_user_mod = b_rec.event_user_mod
                          AND event_col_cd = b_rec.event_col_cd
                          AND tran_id = b_rec.tran_id;
               END;
            ELSE
               IF b_rec.SWITCH = 'N' AND b_rec.user_id = p_user
               THEN
                  UPDATE gipi_user_events
                     SET SWITCH = 'Y'
                   WHERE event_user_mod = b_rec.event_user_mod
                     AND event_col_cd = b_rec.event_col_cd
                     AND tran_id = b_rec.tran_id;
               END IF;
            END IF;
         END LOOP;
      END LOOP;
   END;
END select_quote_to_par;
/


