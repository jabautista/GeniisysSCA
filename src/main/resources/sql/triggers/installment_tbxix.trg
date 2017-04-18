DROP TRIGGER CPI.INSTALLMENT_TBXIX;

CREATE OR REPLACE TRIGGER CPI.installment_tbxix
BEFORE INSERT OR UPDATE ON CPI.GIPI_INSTALLMENT FOR EACH ROW
/*Modified by:    Vincent
**Date Modified:  01102006
**Modification:   Added codes for new column (comm_vat) and new computation of
**                total_amt_due in giac_aging_ri_soa_details
*/
/*
|| overview: inserts corresponding records in accounting soa tables
||
|| modified:
|| 10.29.2001 - terrence - added on update clause to
||            consider payments made before updating
||
|| modified:
|| 08.24.2001 - rjluy - added on update clause for updating
||                      of tax allocations used in giuwts022
|| ??.??.???? - ???   - created
||
*/
DECLARE
   v_policy_id           gipi_polbasic.policy_id%TYPE;
   v_line_cd             gipi_polbasic.line_cd%TYPE;
   v_assd_no             gipi_polbasic.assd_no%TYPE;
   v_aging_id            giac_aging_parameters.aging_id%TYPE;
   v_max_no_days         giac_aging_parameters.max_no_days%TYPE;
   v_next_age_level_dt   DATE;
   v_overdue             giac_aging_parameters.max_no_days%TYPE;--NUMBER (8, 4); Gzelle 05252015 SR19242 AFPGEN
   v_total_amount_due    giac_aging_soa_details.total_amount_due%TYPE   := 0;
   v_total_amount_due2   giac_aging_soa_details.total_amount_due%TYPE   := 0;
   v_ri_cd               giri_inpolbas.ri_cd%TYPE;
   v_ri                  giis_parameters.param_value_v%TYPE;
   v_rb                  giis_parameters.param_value_v%TYPE;
   v_gif                 giis_parameters.param_value_v%TYPE;
   v_gr                  giis_parameters.param_value_v%TYPE;
   v_curr_rt             gipi_invoice.currency_rt%TYPE;
   v_curr_cd1            gipi_invoice.currency_cd%TYPE;
   v_curr_cd2            giac_parameters.param_value_n%TYPE;
   v_ri_comm             gipi_invoice.ri_comm_amt%TYPE;
   v_comm                gipi_invoice.ri_comm_amt%TYPE;
   v_sum_comm            gipi_invoice.ri_comm_amt%TYPE;
   v_comm_excess         gipi_invoice.ri_comm_amt%TYPE;
   v_comm_alloc          giac_parameters.param_value_v%TYPE;
   v_quotient_comm       gipi_invoice.ri_comm_amt%TYPE;
   v_product_comm        gipi_invoice.ri_comm_amt%TYPE;
   v_difference_comm     gipi_invoice.ri_comm_amt%TYPE;
   v_quotient_prem       gipi_invoice.prem_amt%TYPE;
   v_product_prem        gipi_invoice.prem_amt%TYPE;
   v_difference_prem     gipi_invoice.prem_amt%TYPE;
   v_inst_no             NUMBER;
   v_prem                gipi_invoice.prem_amt%TYPE;
   v_prem_amt            gipi_invoice.prem_amt%TYPE;
   v_par_id              gipi_polbasic.par_id%TYPE;
   v_pd_comm_amt         giac_inwfacul_prem_collns.comm_amt%TYPE;
   v_pd_prem_amt         giac_inwfacul_prem_collns.premium_amt%TYPE;
   v_pd_tax_amt          giac_inwfacul_prem_collns.tax_amount%TYPE;
   v_pd_comm_vat         giac_inwfacul_prem_collns.comm_vat%TYPE; --Vincent 01102006
   v_input_vat_rate      giis_reinsurer.input_vat_rate%TYPE; --Vincent 01102006
   /*v_comm_vat             giac_inwfacul_prem_collns.comm_vat%TYPE;--Vincent 01102006*/--jacq070506
   v_comm_vat            gipi_invoice.ri_comm_vat%TYPE;          --Jacq070506

   CURSOR get_ri (v_pol_id gipi_polbasic.policy_id%TYPE)
   IS
      SELECT ri_cd
        FROM giri_inpolbas
       WHERE policy_id = v_pol_id;
BEGIN
   v_ri := giisp.v ('RI');
   v_rb := giisp.v ('RB');
   v_gif := giisp.v ('ACCTG_FOR_FUND_CODE');
   v_gr := giisp.v ('ACCTG_ISS_CD_GR');

   IF v_ri IS NULL
   THEN
      raise_application_error
                          (-20010,
                           'PARAMETER RI DOES NOT EXIST IN GIAC PARAMETERS.',
                           TRUE
                          );
   END IF;

   IF v_rb IS NULL
   THEN
      raise_application_error
                          (-20010,
                           'PARAMETER RB DOES NOT EXIST IN GIAC PARAMETERS.',
                           TRUE
                          );
   END IF;

   IF v_gif IS NULL
   THEN
      raise_application_error
         (-20010,
          'PARAMETER ACCTG_FOR_FUND_CODE DOES NOT EXIST IN GIAC PARAMETERS.',
          TRUE
         );
   END IF;

   IF v_gr IS NULL
   THEN
      raise_application_error
             (-20010,
              'PARAMETER ACCTG_ISS_CD_GR DOES NOT EXIST IN GIAC PARAMETERS.',
              TRUE
             );
   END IF;

   BEGIN
      /*v_comm_vat modified by jacq070506,value from gipi_invoice*/
      SELECT policy_id, NVL (ri_comm_amt, 0) * NVL (currency_rt, 1),
             NVL (currency_rt, 1), NVL (prem_amt, 0) * NVL (currency_rt, 1),
             currency_cd,
               NVL (ri_comm_vat, 0) * NVL (currency_rt, 1) --roset, 4/24/2010, added conversion of ri_comm_vat
        INTO v_policy_id, v_comm,
             v_curr_rt, v_prem,
             v_curr_cd1,
             v_comm_vat
        FROM gipi_invoice
       WHERE iss_cd = :NEW.iss_cd AND prem_seq_no = :NEW.prem_seq_no;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   -- dong : 07-98
   -- this is the phil. peso currency
   -- code defined in giac_parameters.
   v_curr_cd2 := giacp.n ('CURRENCY_CD');

   IF v_curr_cd2 IS NULL
   THEN
      raise_application_error (-20011,
                               'CURRENCY CODE NOT FOUND ON GIAC_PARAMETERS'
                              );
   END IF;

   -- get the ri commission allocation tag
   v_comm_alloc := giacp.v ('RI_COMM_ALLOC');

   IF v_comm_alloc IS NULL
   THEN
      raise_application_error (-20011,
                               'RI_COMM_ALLOC NOT FOUND ON GIAC_PARAMETERS'
                              );
   END IF;

   BEGIN
      SELECT NVL(b.assd_no, a.assd_no), a.line_cd, a.par_id --Apollo Cruz 11.25.2014 - added NVL in assd_no
        INTO v_assd_no, v_line_cd, v_par_id
        FROM gipi_polbasic a, gipi_parlist b
       WHERE b.par_id = a.par_id AND a.policy_id = v_policy_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20012,
                                  'RECORD NOT FOUND ON GIPI_POLBASIC');
      WHEN TOO_MANY_ROWS
      THEN
         raise_application_error (-20013,
                                  'TOO MANY ROWS FOUND ON GIPI_POLBASIC'
                                 );
   END;

   -- add comments in here
   IF :NEW.iss_cd IN (v_ri, v_gr, v_rb)
   THEN
      FOR a IN get_ri (v_policy_id)
      LOOP
         v_ri_cd := a.ri_cd;
         EXIT;
      END LOOP;
   /*
      --Vincent 01102006: get the input vat rate
      FOR b IN
        (SELECT NVL(input_vat_rate,0) input_vat_rate, local_foreign_sw
           FROM GIIS_REINSURER
          WHERE ri_cd = v_ri_cd)
      LOOP
        IF b.local_foreign_sw = 'L' THEN
          v_input_vat_rate := b.input_vat_rate;
        ELSE
          v_input_vat_rate := 0;
        END IF;
        EXIT;
      END LOOP;--v--
      */
      IF v_comm_alloc = 'F'  -- alloc
      THEN
         -- ri commission will be allocated on the first installment but not to
         -- exceed premium amount, otherwise, the excess should be allocated on
         -- the succeding installments.
         DECLARE
            CURSOR c
            IS
               SELECT NVL (SUM (NVL (comm_balance_due, 0)),
                           0
                          ) comm_balance_due
                 FROM giac_aging_ri_soa_details
                WHERE prem_seq_no = :NEW.prem_seq_no
                      AND inst_no < :NEW.inst_no;
         BEGIN
            OPEN c;

            FETCH c
             INTO v_sum_comm;

            -- the cursor will fetch nothing on first installment.
            IF c%NOTFOUND
            THEN
               v_sum_comm := 0;
            END IF;

            v_comm := (v_comm - v_sum_comm);
            v_comm_excess := v_comm - (NVL (:NEW.prem_amt, 0) * NVL (v_curr_rt, 1));

            SELECT DECODE (SIGN (v_comm_excess),
                           -1, v_comm,
                           1, (v_comm - v_comm_excess),
                           v_comm
                          )
              INTO v_comm
              FROM DUAL;

            /*v_comm_vat := v_comm * (v_input_vat_rate/100); --Vincent 01102006*/--jacq070506
            -- rounded so that sum would be equal to the addends and the subtrahend
            v_total_amount_due :=
                 (  ROUND ((NVL (:NEW.prem_amt, 0) * NVL (v_curr_rt, 1)), 2)
                  + ROUND ((NVL (:NEW.tax_amt, 0) * NVL (v_curr_rt, 1)), 2)
                 )
               - ROUND (v_comm, 2)
               - ROUND (v_comm_vat, 2);                     --Vincent 01102006

            CLOSE c;
         END;
      ELSE     -- ri commission will be divided by the number of installments.
         /* replaced cursor that get the no. of installment. used function get_payt_terms instead*/
         /* rollback the changes done by Edison 06.28.2012
         /* to correct the computation of breakdown of commission and comm_vat if there is more than 1 installments*/
         DECLARE
          CURSOR d
          IS
           SELECT a.no_of_payt
             FROM giis_payterm a,
               gipi_invoice b
            WHERE a.payt_terms = b.payt_terms
              AND b.iss_cd = :NEW.iss_cd
              AND b.prem_seq_no = :NEW.prem_seq_no;
         
         BEGIN
            /* mark jm 09.16.09 (UW-SPECS-2009-00058) */
            /* comment codes related to cursor and replaced it with GET_PAYT_TERMS*/
            /* rollback the changes done by Edison 06.28.2012
            /* to correct the computation of breakdown of commission and comm_vat if there is more than 1 installments*/
            OPEN d;
            FETCH d INTO v_inst_no;
            IF d%NOTFOUND THEN
             RAISE_APPLICATION_ERROR(-20014,'MAX INSTALLMENT NO. NOT FOUND ON GIPI_WINSTALLMENT');
            END IF;
            
            --v_inst_no := get_payt_terms (:NEW.iss_cd, :NEW.prem_seq_no); comment out by Edison 06.28.2012

            IF v_inst_no != :NEW.inst_no
            THEN
               v_comm := ROUND (NVL (v_comm, 0) / NVL (v_inst_no, 0), 2);
               v_comm_vat :=
                           ROUND (NVL (v_comm_vat, 0) / NVL (v_inst_no, 0),
                                  2);                          --april 101409
            ELSE
                -- for last installment get full less all the previous installment amounts.
               v_comm :=
                    v_comm
                  - (  ROUND (NVL (v_comm, 0) / NVL (v_inst_no, 0), 2)
                     * (v_inst_no - 1)
                    );
               v_comm_vat :=
                    v_comm_vat
                  - (  ROUND (NVL (v_comm_vat, 0) / NVL (v_inst_no, 0), 2)
                     * (v_inst_no - 1)
                    );                                                 --april
            END IF;

              /*v_comm_vat := v_comm * (v_input_vat_rate/100); --Vincent 01102006*/--jacq070506
            -- rounding for same reason as above
            v_total_amount_due :=
                 ROUND ((NVL (:NEW.prem_amt, 0) * NVL (v_curr_rt, 1)), 2)
               + ROUND ((NVL (:NEW.tax_amt, 0) * NVL (v_curr_rt, 1)), 2)
               - ROUND (NVL (v_comm, 0), 2)
               - ROUND (v_comm_vat, 2);                     --Vincent 01102006
          CLOSE d;
         END;
      END IF;
   ELSE                                            --  for direct transactions
      v_total_amount_due :=
           ROUND ((NVL (:NEW.prem_amt, 0) * NVL (v_curr_rt, 1)), 2)
         + ROUND ((NVL (:NEW.tax_amt, 0) * NVL (v_curr_rt, 1)), 2);
   END IF;

   IF INSERTING
   THEN
      v_overdue := TRUNC (SYSDATE) - TRUNC (:NEW.due_date) + 1;

      IF v_overdue > 0
      THEN
         BEGIN
            SELECT aging_id, max_no_days
              INTO v_aging_id, v_max_no_days
              FROM giac_aging_parameters
             WHERE gibr_gfun_fund_cd = v_gif
               AND gibr_branch_cd = :NEW.iss_cd
               AND min_no_days <= ROUND (ABS (v_overdue))
               AND max_no_days >= ROUND (ABS (v_overdue))
               AND over_due_tag = 'Y';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                              (-20015,
                                  'Geniisys Exception#E#RECORD NOT FOUND ON GIAC_AGING_PARAMETERS.'--added period edgar 12/12/2014
                               --|| TO_CHAR (v_overdue) --commented out edgar 12/12/2014
                              );
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error
                              (-20016,
                               'Geniisys Exception#E#TOO MANY ROWS FOUND ON GIAC_AGING_PARAMETERS.'--added period edgar 12/12/2014
                              );
         END;
      ELSE  -- not overdue
         BEGIN
            SELECT aging_id, max_no_days
              INTO v_aging_id, v_max_no_days
              FROM giac_aging_parameters
             WHERE gibr_gfun_fund_cd = v_gif
               AND gibr_branch_cd = :NEW.iss_cd
               AND min_no_days <= ROUND (ABS (v_overdue))
               AND max_no_days >= ROUND (ABS (v_overdue))
               AND over_due_tag = 'N';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                                 (-20017,
                                  'Geniisys Exception#E#RECORD NOT FOUND ON GIAC_AGING_PARAMETERS.'--added period edgar 12/12/2014
                                 );
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error
                              (-20018,
                               'Geniisys Exception#E#TOO MANY ROWS FOUND ON GIAC_AGING_PARAMETERS.'--added period edgar 12/12/2014
                              );
         END;
      END IF;  -- overdue tag
      IF v_overdue < 0 THEN
         v_next_age_level_dt := :NEW.due_date;
      ELSE
         v_next_age_level_dt := :NEW.due_date + v_max_no_days;
      END IF;

      IF :NEW.iss_cd IN (v_ri, v_gr, v_rb)
      THEN
         BEGIN
            INSERT INTO giac_aging_ri_soa_details
                        (gagp_aging_id, a180_ri_cd, a020_assd_no,
                         a150_line_cd, prem_seq_no, total_amount_due,
                         total_payments, temp_payments, balance_due,
                         prem_balance_due,
                         comm_balance_due, wholding_tax_bal,
                         next_age_level_dt, inst_no,
                         tax_amount,
                         comm_vat
                        )                                   --Vincent 01102006
                 VALUES (v_aging_id, v_ri_cd, v_assd_no,
                         v_line_cd, :NEW.prem_seq_no, v_total_amount_due,
                         0, 0, v_total_amount_due,
                         (NVL (:NEW.prem_amt, 0) * NVL (v_curr_rt, 1)
                         ),
                         v_comm, 0,
                         v_next_age_level_dt, :NEW.inst_no,
                         (NVL (:NEW.tax_amt, 0) * NVL (v_curr_rt, 1)
                         ),
                         v_comm_vat
                        );                                  --Vincent 01102006
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               raise_application_error
                       (-20019,
                        'DUPLICATE RECORD FOUND ON GIAC_AGING_RI_SOA_DETAILS'
                       );
         END;
      ELSE
         BEGIN
            INSERT INTO giac_aging_soa_details
                        (gagp_aging_id, a150_line_cd, a020_assd_no, iss_cd,
                         prem_seq_no, total_amount_due, total_payments,
                         temp_payments, balance_amt_due,
                         prem_balance_due,
                         tax_balance_due,
                         next_age_level_dt, inst_no, policy_id
                        )
                 VALUES (v_aging_id, v_line_cd, v_assd_no, :NEW.iss_cd,
                         :NEW.prem_seq_no, v_total_amount_due, 0,
                         0, v_total_amount_due,
                         (NVL (:NEW.prem_amt, 0) * NVL (v_curr_rt, 1)
                         ),
                         (NVL (:NEW.tax_amt, 0) * NVL (v_curr_rt, 1)),
                         v_next_age_level_dt, :NEW.inst_no, v_policy_id
                        );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               raise_application_error
                          (-20020,
                           'DUPLICATE RECORD FOUND ON GIAC_AGING_SOA_DETAILS'
                          );
         END;

         -- dong : 07-98
         IF v_curr_cd1 <> v_curr_cd2
         THEN
            BEGIN
               INSERT INTO giac_aging_fc_soa_details
                           (iss_cd, prem_seq_no, inst_no,
                            gagp_aging_id, a020_assd_no, a150_line_cd,
                            currency_cd,
                            total_amount_due,
                            total_payments, temp_payments,
                            balance_amt_due,
                            prem_balance_due, tax_balance_due
                           )
                    VALUES (:NEW.iss_cd, :NEW.prem_seq_no, :NEW.inst_no,
                            v_aging_id, v_assd_no, v_line_cd,
                            v_curr_cd1,
                            (NVL (:NEW.prem_amt, 0) + NVL (:NEW.tax_amt, 0)
                            ),
                            0, 0,
                            (NVL (:NEW.prem_amt, 0) + NVL (:NEW.tax_amt, 0)
                            ),
                            NVL (:NEW.prem_amt, 0), NVL (:NEW.tax_amt, 0)
                           );
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  raise_application_error
                             (-20021,
                              'DUPLICATE RECORD ON GIAC_AGING_FC_SOA_DETAILS'
                             );
            END;
         END IF;
      END IF;
   --
   --  'updating' clause callec for in giuw022 module (change mode of payment and tax allocation)
   --
   ELSIF UPDATING
   THEN
      IF :NEW.iss_cd IN (v_ri, v_gr, v_rb)
      THEN
         -- rounded up, see reason below
         SELECT SUM (a.comm_amt), SUM (a.premium_amt), SUM (a.tax_amount),
                SUM (a.comm_vat)                            --Vincent 01102006
           INTO v_pd_comm_amt, v_pd_prem_amt, v_pd_tax_amt,
                v_pd_comm_vat                               --Vincent 01102006
           FROM giac_inwfacul_prem_collns a, giac_acctrans b
          WHERE a.b140_prem_seq_no = :NEW.prem_seq_no
            AND a.a180_ri_cd = v_ri_cd
            AND a.inst_no = :NEW.inst_no
            AND a.gacc_tran_id = b.tran_id
            AND b.tran_flag <> 'D'
            AND NOT EXISTS (
                   SELECT c.gacc_tran_id
                     FROM giac_reversals c, giac_acctrans d
                    WHERE c.reversing_tran_id = d.tran_id
                      AND d.tran_flag <> 'D'
                      AND c.gacc_tran_id = a.gacc_tran_id);

         UPDATE giac_aging_ri_soa_details
            SET balance_due =
                     v_total_amount_due
                   - (NVL (v_pd_prem_amt, 0) + NVL (v_pd_tax_amt, 0)),
                total_amount_due = v_total_amount_due,
                comm_balance_due = v_comm - NVL (v_pd_comm_amt, 0),
                tax_amount =
                   ROUND (  (NVL (:NEW.tax_amt, 0) * NVL (v_curr_rt, 1))
                          - NVL (v_pd_tax_amt, 0),
                          2
                         ),
                comm_vat =
                         v_comm_vat - NVL (v_pd_comm_vat, 0)
                                                            --Vincent 01102006
          WHERE gagp_aging_id >= 0
            AND a020_assd_no = v_assd_no
            AND a150_line_cd = v_line_cd
            AND prem_seq_no = :NEW.prem_seq_no
            AND a180_ri_cd = v_ri_cd
            AND inst_no = :NEW.inst_no;
      ELSE
         BEGIN
            SELECT SUM (a.premium_amt), SUM (a.tax_amt)
              INTO v_pd_prem_amt, v_pd_tax_amt
              FROM giac_direct_prem_collns a, giac_acctrans b
             WHERE a.b140_iss_cd = :NEW.iss_cd
               AND a.b140_prem_seq_no = :NEW.prem_seq_no
               AND a.inst_no = :NEW.inst_no
               AND a.gacc_tran_id = b.tran_id
               AND b.tran_flag <> 'D'
               AND NOT EXISTS (
                      SELECT c.gacc_tran_id
                        FROM giac_reversals c, giac_acctrans d
                       WHERE c.reversing_tran_id = d.tran_id
                         AND d.tran_flag <> 'D'
                         AND c.gacc_tran_id = a.gacc_tran_id);

            UPDATE giac_aging_soa_details
               SET tax_balance_due =
                      ROUND (  (NVL (:NEW.tax_amt, 0) * NVL (v_curr_rt, 1))
                             - NVL (v_pd_tax_amt, 0),
                             2
                            ),
                   balance_amt_due =
                        v_total_amount_due
                      - (NVL (v_pd_prem_amt, 0) + NVL (v_pd_tax_amt, 0)),
                   total_amount_due = v_total_amount_due,
                   prem_balance_due =
                      ROUND (  (NVL (:NEW.prem_amt, 0) * NVL (v_curr_rt, 1))
                             - NVL (v_pd_prem_amt, 0),
                             2
                            )
             WHERE iss_cd = :NEW.iss_cd
               AND prem_seq_no = :NEW.prem_seq_no
               AND inst_no = :NEW.inst_no;
         END;

         IF v_curr_cd1 <> v_curr_cd2
         THEN
            BEGIN
               UPDATE giac_aging_fc_soa_details
                  -- doesn't need rounding since database field has type number, no precesion
               SET tax_balance_due = NVL (:NEW.tax_amt, 0),
                   balance_amt_due =
                                 NVL (:NEW.prem_amt, 0)
                                 + NVL (:NEW.tax_amt, 0),
                   total_amount_due =
                                 NVL (:NEW.prem_amt, 0)
                                 + NVL (:NEW.tax_amt, 0),
                   prem_balance_due = NVL (:NEW.prem_amt, 0)
                WHERE iss_cd = :NEW.iss_cd
                  AND prem_seq_no = :NEW.prem_seq_no
                  AND inst_no = :NEW.inst_no;
            END;
         END IF;
      END IF;
   END IF;
END;
/


