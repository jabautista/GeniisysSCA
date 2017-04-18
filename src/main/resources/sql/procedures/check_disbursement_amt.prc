DROP PROCEDURE CPI.CHECK_DISBURSEMENT_AMT;

CREATE OR REPLACE PROCEDURE CPI.check_disbursement_amt (
   p_transaction_type         giac_outfacul_prem_payts.transaction_type%TYPE,
   p_ri_cd                    giac_outfacul_prem_payts.a180_ri_cd%TYPE,
   p_gacc_tran_id             giac_direct_prem_collns.gacc_tran_id%TYPE,
   p_binder_id                giri_binder.fnl_binder_id%TYPE,
   p_line_cd                  giri_binder.line_cd%TYPE,
   p_binder_yy                giri_binder.binder_yy%TYPE,
   p_binder_seq_no            giri_binder.binder_seq_no%TYPE,
   p_record_no                GIAC_OUTFACUL_PREM_PAYTS.RECORD_NO%TYPE,  -- SR-19631 : shan 08.19.2015
   p_policy_id                gipi_invoice.prem_amt%TYPE,
   p_user                     giac_outfacul_prem_payts.user_id%TYPE,
   p_module_name              VARCHAR2,
   p_message            OUT   VARCHAR2
)
IS
   v_payable_exists           giri_binder.ri_prem_amt%TYPE               := 0;
   v_total_payable            giri_binder.ri_prem_amt%TYPE               := 0;
   v_total_receivable         gipi_invoice.prem_amt%TYPE;
   v_actual_prem_collection   giac_direct_prem_collns.collection_amt%TYPE
                                                                         := 0;
   v_actual_payments          giac_outfacul_prem_payts.disbursement_amt%TYPE
                                                                         := 0;
   v_percent_payable          giac_outfacul_prem_payts.disbursement_amt%TYPE
                                                                         := 0;
   v_default_disb_amt         giac_outfacul_prem_payts.disbursement_amt%TYPE
                                                                         := 0;
   al_button                  NUMBER;
   v_iss_cd                   gipi_invoice.iss_cd%TYPE;
   v_prem_seq_no              gipi_invoice.prem_seq_no%TYPE;
   v_set_prem_switch          BOOLEAN                                := FALSE;
   v_convert_rate             giac_outfacul_prem_payts.convert_rate%TYPE;
   v_allow_default            VARCHAR2 (10);
   v_binder_balance           NUMBER; --Added by Jerome Bautista 03.11.2016 SR 21229
   v_currency_rt              gipi_invoice.currency_rt%TYPE; -- bonok :: 5/10/2016 :: SR 20296
BEGIN
   v_allow_default := giac_validate_user_fn (p_user, 'OD', p_module_name);
   DBMS_OUTPUT.put_line ('allow default: ' || v_allow_default);
   
   BEGIN -- bonok :: 5/10/2016 :: SR 20296
      SELECT currency_rt
        INTO v_currency_rt
        FROM gipi_invoice
       WHERE policy_id = p_policy_id;
   EXCEPTION WHEN OTHERS THEN
      v_currency_rt := 1;
   END;

   FOR c1 IN (SELECT 1
                FROM giac_outfacul_prem_payts d010
               WHERE d010.gacc_tran_id = p_gacc_tran_id
                 AND d010.a180_ri_cd = p_ri_cd
                 AND d010.d010_fnl_binder_id = p_binder_id
                 AND record_no = p_record_no)   -- SR-19631 : shan 08.19.2015
   LOOP
      p_message :=
                'Record already exist with the same Reinsurer and Binder No.';
				return;
   END LOOP;

   FOR a1 IN (SELECT g.iss_cd, g.prem_seq_no
                FROM giri_binder a,
                     giri_frps_ri b,
                     giri_distfrps c,
                     giuw_policyds d,
                     giuw_pol_dist e,
                     gipi_polbasic f,
                     gipi_invoice g
               WHERE f.policy_id = g.policy_id
                 AND e.policy_id = f.policy_id
                 AND d.dist_no = e.dist_no
                 AND c.dist_no = d.dist_no
                 AND c.dist_seq_no = d.dist_seq_no
                 AND b.line_cd = c.line_cd
                 AND b.frps_yy = c.frps_yy
                 AND b.frps_seq_no = c.frps_seq_no
                 AND a.fnl_binder_id = b.fnl_binder_id
                 AND a.ri_cd = p_ri_cd
                 AND a.line_cd = p_line_cd
                 AND a.fnl_binder_id = p_binder_id)
   LOOP
      v_iss_cd := a1.iss_cd;
      v_prem_seq_no := a1.prem_seq_no;
      EXIT;
   END LOOP;

   FOR a1 IN (SELECT NVL (ri_prem_amt, 0) ri_prem
                FROM giri_binder
               WHERE binder_yy = p_binder_yy
                 AND line_cd = p_line_cd
                 AND binder_seq_no = p_binder_seq_no
                 AND ri_cd = p_ri_cd)
   LOOP
      v_payable_exists := a1.ri_prem;
      EXIT;
   END LOOP;

   -- get total outfacul premium payable.
   BEGIN
      SELECT convert_rate
        INTO v_convert_rate
        FROM giac_outfacul_prem_payts
       WHERE gacc_tran_id = p_gacc_tran_id
         AND a180_ri_cd = p_ri_cd
         AND d010_fnl_binder_id = p_binder_id
         AND record_no = p_record_no;      -- SR-19631 : shan 08.19.2015
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_convert_rate := NULL;
   END;

   FOR a2 IN (SELECT /*(  NVL (ri_prem_amt, 0)
                      - (NVL (ri_comm_amt, 0) + NVL (prem_tax, 0))
                     )*/
                     (  (NVL (ri_prem_amt, 0) + NVL (ri_prem_vat, 0)) --Deo [01.27.2017]: replace computation (SR-23187)
                         - (  NVL (ri_comm_amt, 0)
                            + NVL (ri_comm_vat, 0)
                            + NVL (ri_wholding_vat, 0)
                           )
                        ) tot_payable
                FROM giri_binder
               WHERE binder_yy = p_binder_yy
                 AND line_cd = p_line_cd
                 AND binder_seq_no = p_binder_seq_no
                 AND ri_cd = p_ri_cd)
   LOOP
      v_total_payable := (a2.tot_payable) * NVL (v_convert_rate, 1);
      EXIT;
   END LOOP;
   
    DBMS_OUTPUT.put_line ('total payable: ' || v_total_payable);

   -- get total premium receivable.
   FOR a5 IN (SELECT NVL (prem_amt, 0) tot_receivable
                FROM gipi_invoice
               WHERE iss_cd = v_iss_cd AND prem_seq_no = v_prem_seq_no)
   LOOP
      v_total_receivable := a5.tot_receivable;
      EXIT;
   END LOOP;
   
   DBMS_OUTPUT.put_line ('v_total_receivable: ' || v_total_receivable);

   v_set_prem_switch := FALSE;

   FOR c1 IN (SELECT 1
                FROM gipi_polbasic a, giri_inpolbas b
               WHERE a.policy_id = b.policy_id AND a.policy_id = p_policy_id)
   LOOP
      v_set_prem_switch := TRUE;
   END LOOP;

   IF v_set_prem_switch = TRUE
   THEN
      FOR a4 IN (SELECT NVL (SUM (premium_amt), 0) actual_prem_coll
                   FROM giac_inwfacul_prem_collns gipc,
                        gipi_invoice b140,
                        giac_acctrans gacc
                  WHERE gipc.b140_iss_cd = b140.iss_cd
                    AND gipc.b140_prem_seq_no = b140.prem_seq_no
                    AND gipc.gacc_tran_id = gacc.tran_id
                    AND gacc.tran_flag <> 'D'
                    AND NOT EXISTS (
                           SELECT '1'
                             FROM giac_acctrans c, giac_reversals d
                            WHERE c.tran_flag != 'D'
                              AND c.tran_id = d.reversing_tran_id
                              AND d.gacc_tran_id = gacc.tran_id)
                    AND gipc.b140_iss_cd = v_iss_cd
                    AND gipc.b140_prem_seq_no = v_prem_seq_no)
      LOOP
         --v_actual_prem_collection := a4.actual_prem_coll;
         v_actual_prem_collection := a4.actual_prem_coll / v_currency_rt; -- bonok :: 5.10.2016 :: SR 20296
         EXIT;
      END LOOP;
	  
	  DBMS_OUTPUT.put_line ('v_actual_prem_collection: ' || v_actual_prem_collection);
   ELSIF v_set_prem_switch = FALSE
   THEN
      FOR a4 IN (SELECT NVL (SUM (premium_amt), 0) actual_prem_coll
                   FROM giac_direct_prem_collns gdpc,
                        gipi_invoice b140,
                        giac_acctrans gacc
                  WHERE gdpc.b140_iss_cd = b140.iss_cd
                    AND gdpc.b140_prem_seq_no = b140.prem_seq_no
                    AND gdpc.gacc_tran_id = gacc.tran_id
                    AND gacc.tran_flag <> 'D'
                    AND NOT EXISTS (
                           SELECT '1'
                             FROM giac_acctrans c, giac_reversals d
                            WHERE c.tran_flag != 'D'
                              AND c.tran_id = d.reversing_tran_id
                              AND d.gacc_tran_id = gacc.tran_id)
                    AND gdpc.b140_iss_cd = v_iss_cd
                    AND gdpc.b140_prem_seq_no = v_prem_seq_no)
      LOOP
         --v_actual_prem_collection := a4.actual_prem_coll;
         v_actual_prem_collection := a4.actual_prem_coll / v_currency_rt; -- bonok :: 5.10.2016 :: SR 20296
         EXIT;
      END LOOP;
   END IF;
   
   DBMS_OUTPUT.put_line ('1: trantype: ' || p_transaction_type || ' v_payable_exist: ' || v_payable_exists);

   IF v_payable_exists >= 0
   THEN
      IF p_transaction_type IN (1, 2)
      THEN
         FOR a5 IN (SELECT NVL (SUM (gfpp.disbursement_amt),
                                0
                               ) actual_payments
                      FROM giac_outfacul_prem_payts gfpp,
                           giac_acctrans gacc,
                           giri_binder gibr
                     WHERE gfpp.gacc_tran_id = gacc.tran_id
                       AND gacc.tran_flag != 'D'
                       AND NOT EXISTS (
                              SELECT '1'
                                FROM giac_acctrans c, giac_reversals d
                               WHERE c.tran_flag != 'D'
                                 AND c.tran_id = d.reversing_tran_id
                                 AND d.gacc_tran_id = gacc.tran_id)
                       AND gfpp.d010_fnl_binder_id = gibr.fnl_binder_id
                       AND binder_yy = p_binder_yy
                       AND line_cd = p_line_cd
                       AND binder_seq_no = p_binder_seq_no
                       AND ri_cd = p_ri_cd
                       AND gfpp.transaction_type IN (1, 2))
         LOOP
            --v_actual_payments := a5.actual_payments;
            v_actual_payments := a5.actual_payments / v_currency_rt; -- bonok :: 5.10.2016 :: SR 20296
            EXIT;
         END LOOP;

         IF v_total_receivable = 0
         THEN
            v_percent_payable := NULL;
         ELSE
            v_percent_payable :=
                 (v_actual_prem_collection / v_total_receivable
                 )
               * v_total_payable;
         END IF;

         DBMS_OUTPUT.put_line ('2: trantype: ' || p_transaction_type);

         IF p_transaction_type = 1
         THEN
            v_default_disb_amt := v_percent_payable - v_actual_payments;
            v_binder_balance := v_total_payable - v_actual_payments; --Added by Jerome Bautista 03.11.2016 SR 21229
            /*IF v_allow_default = 'TRUE' THEN    -- to allow partial payment for no prem payt ::: SR-19631 : shan 08.17.2015
                IF v_default_disb_amt <= 0 THEN
                    v_default_disb_amt := v_total_payable - v_actual_payments;
                END IF;
            END IF;*/ --Dren 02.22.2016 SR-21364 - Moved to codes below.

            IF v_total_payable = v_actual_payments
            THEN
				DBMS_OUTPUT.put_line ('This binder has been fully paid 1');
               p_message := 'This binder has been fully paid.';
			   return;
            END IF;

            IF v_allow_default = 'TRUE'
            THEN
               IF v_default_disb_amt = 0
               THEN
                  v_default_disb_amt := v_total_payable - v_actual_payments; --Dren 02.22.2016 SR-21364
                  p_message := 'No collection has been made for this binder.';
				  return;
               ELSIF v_default_disb_amt < 0 AND v_binder_balance < 0 --Added by Jerome Bautista 03.11.2016 SR 21229
               THEN
                  v_default_disb_amt := v_total_payable - v_actual_payments; --Dren 02.22.2016 SR-21364
                  p_message :=
                     'Amount previously disbursed/refunded already exceeds the default amount.';
					 return;
               END IF;
            ELSE
               IF v_default_disb_amt = 0
               THEN
                  p_message :=
                        'There is still no premium payment for this policy. ';
						return;
               ELSIF v_default_disb_amt < 0 AND v_binder_balance < 0 --Added by Jerome Bautista 03.11.2016 SR 21229
               THEN
                  p_message :=
                     'Amount previously disbursed/refunded already exceeds the default amount.';
					 return;
               END IF;
            END IF;
         ELSIF p_transaction_type = 2
         THEN
            v_default_disb_amt := (-1) * v_actual_payments;

            IF v_default_disb_amt = 0
            THEN
               p_message :=
                  'Trantype 2 not allowed. No payment has been made for this Binder No.';
				  return;
            ELSIF v_default_disb_amt > 0
            THEN
               p_message := 'Positive amount for entered Binder No.';
			   return;
            END IF;
         END IF;
      ELSE
         p_message :=
            'This is a positive binder. Only transaction type [1,2] are allowed.';
			return;
      END IF;
   ELSIF v_payable_exists < 0
   THEN
   	   dbms_output.put_line('3: Trantype: ' || p_transaction_type);
      IF p_transaction_type IN (3, 4)
      THEN
         FOR a6 IN (SELECT NVL (SUM (gfpp.disbursement_amt),
                                0
                               ) actual_payments
                      FROM giac_outfacul_prem_payts gfpp,
                           giac_acctrans gacc,
                           giri_binder gibr
                     WHERE gfpp.gacc_tran_id = gacc.tran_id
                       AND gacc.tran_flag != 'D'
                       AND NOT EXISTS (
                              SELECT '1'
                                FROM giac_acctrans c, giac_reversals d
                               WHERE c.tran_flag != 'D'
                                 AND c.tran_id = d.reversing_tran_id
                                 AND d.gacc_tran_id = gacc.tran_id)
                       AND gfpp.d010_fnl_binder_id = gibr.fnl_binder_id
                       AND gibr.binder_yy = p_binder_yy
                       AND gibr.line_cd = p_line_cd
                       AND gibr.binder_seq_no = p_binder_seq_no
                       AND gibr.ri_cd = p_ri_cd --Deo [01.27.2017]: SR-23187
                       AND gfpp.transaction_type IN (3, 4))
         LOOP
            --v_actual_payments := a6.actual_payments;
            v_actual_payments := a6.actual_payments / v_currency_rt; -- bonok :: 5.10.2016 :: SR 20296
            EXIT;
         END LOOP;

         IF v_total_receivable = 0
         THEN                                        
            v_percent_payable := NULL;            
         ELSE
            v_percent_payable :=
                 (v_actual_prem_collection / v_total_receivable
                 )
               * v_total_payable;
         END IF;
		 
		 DBMS_OUTPUT.put_line ('v_percent_payable ' || v_percent_payable);

         IF p_transaction_type = 3
         THEN
            v_default_disb_amt := v_percent_payable - v_actual_payments;
			
            /*IF v_allow_default = 'TRUE' THEN    -- to allow partial payment for no prem payt ::: SR-19631 : shan 08.17.2015
                IF v_default_disb_amt <= 0 THEN
                    v_default_disb_amt := v_total_payable - v_actual_payments;
                END IF;
            END IF;*/ --Dren 02.22.2016 SR-21364 - Moved to codes below.
			
			dbms_output.put_line('v_default_disb_amt: ' || v_default_disb_amt || ' v_allow_default: ' || v_allow_default);

            IF v_total_payable = v_actual_payments
            THEN
				DBMS_OUTPUT.put_line ('This binder has been fully paid 2');
               p_message := 'This binder has been fully paid.';
			   return;
            END IF;

            IF v_allow_default = 'TRUE'
            THEN
               IF v_default_disb_amt = 0
               THEN
                  v_default_disb_amt := v_total_payable - v_actual_payments; --Dren 02.22.2016 SR-21364
                  p_message :=
                     'No collection has been made for this binder. Will now override default computation.';
					 return;
               ELSIF v_default_disb_amt > 0
               THEN
                  v_default_disb_amt := v_total_payable - v_actual_payments; --Dren 02.22.2016 SR-21364
                  p_message :=
                     'Positive amount for entered Binder No. Will override default amount';
					 return;
               END IF;
            ELSE
               IF v_default_disb_amt = 0
               THEN
                  p_message := 'No collection has been made for this binder.';
				  return;
               ELSIF v_default_disb_amt > 0
               THEN
                  p_message := ' Positive amount for entered Binder No.';
				  return;
               END IF;
            END IF;
         ELSIF p_transaction_type = 4
         THEN
            v_default_disb_amt := (-1) * v_actual_payments;

            IF v_default_disb_amt = 0
            THEN
               p_message :=
                  'Trantype 4 not allowed. No payment has been made for this Binder No.';
				  return;
            ELSIF v_default_disb_amt < 0
            THEN
               p_message := ' Negative amount for entered Binder No.';
			   return;
            END IF;
         END IF;
      ELSE
         p_message :=
            'This is a negative binder. Only transaction type [3,4] are allowed.';
			return;
      END IF;
   END IF;
END;
/


