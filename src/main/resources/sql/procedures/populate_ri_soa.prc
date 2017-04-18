CREATE OR REPLACE PROCEDURE CPI.POPULATE_RI_SOA (
   P_PREM_SEQ_NO GIPI_INVOICE.PREM_SEQ_NO%TYPE)
IS
   ws_fund_cd              cpi.giis_funds.fund_cd%TYPE;
   ws_policy_id            cpi.gipi_invoice.policy_id%TYPE;
   ws_curr_rt              cpi.gipi_invoice.currency_rt%TYPE;
   ws_curr_cd              cpi.gipi_invoice.currency_cd%TYPE;
   ws_colln_amt            cpi.giac_inwfacul_prem_collns.collection_amt%TYPE;
   ws_gidc_prem            cpi.giac_inwfacul_prem_collns.premium_amt%TYPE;
   ws_gidc_tax             cpi.giac_inwfacul_prem_collns.tax_amount%TYPE;
   ws_gidc_rt              cpi.giac_inwfacul_prem_collns.convert_rate%TYPE;
   ws_comm_amt             cpi.giac_inwfacul_prem_collns.comm_amt%TYPE;
   ws_wtax_amt             cpi.giac_inwfacul_prem_collns.wholding_tax%TYPE;
   ws_comm_vat_amt         cpi.giac_inwfacul_prem_collns.comm_vat%TYPE;
   ws_max_no_days          cpi.giac_aging_parameters.max_no_days%TYPE;
   ws_aging_id             cpi.giac_aging_ri_soa_details.gagp_aging_id%TYPE;
   ws_nxt_age_lvl_dt       cpi.giac_aging_ri_soa_details.next_age_level_dt%TYPE;
   ws_line_cd              cpi.giac_aging_ri_soa_details.a150_line_cd%TYPE;
   ws_ri_cd                cpi.giac_aging_ri_soa_details.a180_ri_cd%TYPE;
   ws_assd_no              cpi.giac_aging_ri_soa_details.a020_assd_no%TYPE;
   ws_total_amt_due        cpi.giac_aging_ri_soa_details.total_amount_due%TYPE;
   ws_total_payts          cpi.giac_aging_ri_soa_details.total_payments%TYPE;
   ws_temp_payts           cpi.giac_aging_ri_soa_details.temp_payments%TYPE;
   ws_bal_amt_due          cpi.giac_aging_ri_soa_details.balance_due%TYPE;
   ws_prem_bal_due         cpi.giac_aging_ri_soa_details.prem_balance_due%TYPE;
   ws_tax_amount           cpi.giac_aging_ri_soa_details.tax_amount%TYPE;
   ws_comm_bal_due         cpi.giac_aging_ri_soa_details.comm_balance_due%TYPE;
   ws_wtax_bal_due         cpi.giac_aging_ri_soa_details.wholding_tax_bal%TYPE;
   ws_comm_vat             cpi.giac_aging_ri_soa_details.comm_vat%TYPE;
   ws_ri_comm_amt          cpi.gipi_invoice.ri_comm_amt%TYPE;
   ws_ri_comm_vat          cpi.gipi_invoice.ri_comm_vat%TYPE;
   ws_ri_comm_amt_tot      cpi.gipi_invoice.ri_comm_amt%TYPE;
   ws_ri_comm_vat_tot      cpi.gipi_invoice.ri_comm_vat%TYPE;
   ws_bal_due              cpi.giac_aging_ri_soa_details.balance_due%TYPE;
   ws_prem_amt             cpi.gipi_invoice.prem_amt%TYPE;
   ws_tax_amt              cpi.gipi_invoice.tax_amt%TYPE;
   ws_total_due            cpi.giac_aging_ri_soa_details.total_amount_due%TYPE;
   ws_total_prem_due       cpi.giac_aging_ri_soa_details.prem_balance_due%TYPE;
   ws_total_tax_due        cpi.giac_aging_ri_soa_details.tax_amount%TYPE;
   ws_total_ri_comm_due    cpi.giac_aging_ri_soa_details.comm_balance_due%TYPE;
   ws_total_comm_vat_due   cpi.giac_aging_ri_soa_details.comm_vat%TYPE;

   CURSOR b300
   IS
        SELECT a.iss_cd,
               a.prem_seq_no,
               a.inst_no,
               a.prem_amt,
               NVL (a.tax_amt, 0) tax_amt,
               a.due_date,
               get_count_inst_no (a.iss_cd, a.prem_seq_no) no_of_payt,
               (  NVL (b.ri_comm_amt, 0)
                / get_count_inst_no (a.iss_cd, a.prem_seq_no))
                  ri_comm_amt,
               (  NVL (b.ri_comm_vat, 0)
                / get_count_inst_no (a.iss_cd, a.prem_seq_no))
                  ri_comm_vat,
               ROWNUM,
               NVL (ri_comm_amt, 0) tot_ri_comm,
               NVL (ri_comm_vat, 0) tot_comm_vat,
               NVL (b.prem_amt, 0) tot_prem,
               NVL (b.tax_amt, 0) tot_tax
          FROM cpi.gipi_installment a, cpi.gipi_invoice b, cpi.gipi_polbasic c
         WHERE     a.iss_cd = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND b.policy_id = c.policy_id
               AND c.pol_flag <> '5'
               AND b.iss_cd = 'RI'
               AND b.prem_seq_no IN (p_prem_seq_no)
      ORDER BY 1, 2, 3;

   b300_buf                b300%ROWTYPE;
   ws_overdue              NUMBER (8, 4);
   ws_rowid                VARCHAR2 (20);
   ws_rowcnt               NUMBER (5);
   ins_ctr                 NUMBER (5);
   upd_ctr                 NUMBER (5);
   v_counter               NUMBER := 0;
BEGIN
   BEGIN
      SELECT param_value_v
        INTO ws_fund_cd
        FROM cpi.giac_parameters
       WHERE param_name = 'FUND_CD';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20000,
                                  'No data found in GIAC PARAMETERS table.');
   END;

   FOR b300_rec IN b300
   LOOP
      ws_rowcnt := b300_rec.ROWNUM;

      DELETE FROM giac_aging_ri_soa_details
            WHERE     prem_seq_no = b300_rec.prem_seq_no
                  AND inst_no = b300_rec.inst_no;

      BEGIN
         SELECT policy_id, NVL (currency_rt, 1), currency_cd
           INTO ws_policy_id, ws_curr_rt, ws_curr_cd
           FROM cpi.gipi_invoice
          WHERE     iss_cd = b300_rec.iss_cd
                AND prem_seq_no = b300_rec.prem_seq_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20016,
               'No record found in GIPI_INVOICE table.');
         WHEN TOO_MANY_ROWS
         THEN
            raise_application_error (
               -20017,
               'Too many rows found in GIPI_INVOICE table.');
      END;

      IF ws_policy_id IS NOT NULL
      THEN
         ws_prem_amt := b300_rec.prem_amt * NVL (ws_curr_rt, 1);
         ws_tax_amt := b300_rec.tax_amt * NVL (ws_curr_rt, 1);
         ws_ri_comm_amt := b300_rec.ri_comm_amt * NVL (ws_curr_rt, 1);
         ws_ri_comm_vat := b300_rec.ri_comm_vat * NVL (ws_curr_rt, 1);
         ws_total_amt_due :=
              (NVL (ws_prem_amt, 0) + NVL (ws_tax_amt, 0))
            - (NVL (ws_ri_comm_amt, 0) + NVL (ws_ri_comm_vat, 0));

         IF b300_rec.inst_no <> b300_rec.no_of_payt
         THEN
            ws_total_due := NVL (ws_total_due, 0) + NVL (ws_total_amt_due, 0);
            ws_total_prem_due :=
               NVL (ws_total_prem_due, 0) + NVL (ws_prem_amt, 0);
            ws_total_tax_due :=
               NVL (ws_total_tax_due, 0) + NVL (ws_tax_amt, 0);
            ws_total_ri_comm_due :=
               NVL (ws_total_ri_comm_due, 0) + NVL (ws_ri_comm_amt, 0);
            ws_total_comm_vat_due :=
               NVL (ws_total_comm_vat_due, 0) + NVL (ws_ri_comm_vat, 0);
         ELSE
            ws_total_amt_due :=
                 (  (  (  NVL (b300_rec.tot_prem, 0)
                        + NVL (b300_rec.tot_tax, 0))
                     - (  NVL (b300_rec.tot_ri_comm, 0)
                        + NVL (b300_rec.tot_comm_vat, 0)))
                  * NVL (ws_curr_rt, 1))
               - NVL (ws_total_due, 0);
            ws_prem_amt :=
                 (NVL (b300_rec.tot_prem, 0) * NVL (ws_curr_rt, 1))
               - NVL (ws_total_prem_due, 0);
            ws_tax_amt :=
               NVL (b300_rec.tot_tax, 0) - NVL (ws_total_tax_due, 0);
            ws_ri_comm_amt :=
                 (NVL (b300_rec.tot_ri_comm, 0) * NVL (ws_curr_rt, 1))
               - NVL (ws_total_ri_comm_due, 0);
            ws_ri_comm_vat :=
                 (NVL (b300_rec.tot_comm_vat, 0) * NVL (ws_curr_rt, 1))
               - NVL (ws_total_comm_vat_due, 0);
         END IF;

         DBMS_OUTPUT.put_line (
               'prem_amt '
            || ws_prem_amt
            || ' ri_comm_amt '
            || ws_ri_comm_amt
            || ' ri_comm_vat '
            || ws_ri_comm_vat);

         BEGIN
            SELECT a.assd_no, b.line_cd, c.ri_cd
              INTO ws_assd_no, ws_line_cd, ws_ri_cd
              FROM cpi.gipi_polbasic b,
                   cpi.gipi_parlist a,
                   cpi.giri_inpolbas c
             WHERE     a.par_id = b.par_id
                   AND c.policy_id = b.policy_id
                   AND b.policy_id = ws_policy_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20018,
                  'No record found in GIPI_POLBASIC table.');
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error (
                  -20019,
                  'Too many rows found in GIPI_POLBASIC table.');
         END;
      END IF;

      BEGIN
         SELECT SUM (a.collection_amt),
                SUM (a.premium_amt),
                SUM (a.tax_amount),
                SUM (a.comm_amt),
                SUM (a.wholding_tax),
                SUM (comm_vat)
           INTO ws_colln_amt,
                ws_gidc_prem,
                ws_gidc_tax,
                ws_comm_amt,
                ws_wtax_amt,
                ws_comm_vat_amt
           FROM cpi.giac_inwfacul_prem_collns a, cpi.giac_acctrans b
          WHERE     a.gacc_tran_id = b.tran_id
                AND a.gacc_tran_id NOT IN
                       (SELECT c.gacc_tran_id
                          FROM cpi.giac_reversals c, cpi.giac_acctrans d
                         WHERE     c.reversing_tran_id = d.tran_id
                               AND d.tran_flag <> 'D')
                AND b.tran_flag <> 'D'
                AND a.b140_iss_cd = b300_rec.iss_cd
                AND a.b140_prem_seq_no = b300_rec.prem_seq_no
                AND a.inst_no = b300_rec.inst_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ws_colln_amt := 0;
            ws_gidc_prem := 0;
            ws_gidc_tax := 0;
            ws_comm_amt := 0;
            ws_wtax_amt := 0;
            ws_comm_vat_amt := 0;
         WHEN TOO_MANY_ROWS
         THEN
            raise_application_error (
               -20019,
               'Too many rows found in GIAC_INWFACUL_PREM_COLLNS table.');
      END;

      BEGIN
         SELECT NVL (SUM (NVL (a.collection_amt, 0)), 0) temp_payt
           INTO ws_temp_payts
           FROM cpi.giac_inwfacul_prem_collns a, cpi.giac_acctrans b
          WHERE     a.gacc_tran_id = b.tran_id
                AND a.gacc_tran_id NOT IN
                       (SELECT c.gacc_tran_id
                          FROM cpi.giac_reversals c, cpi.giac_acctrans d
                         WHERE     c.reversing_tran_id = d.tran_id
                               AND d.tran_flag <> 'D')
                AND b.tran_flag = 'O'
                AND a.b140_iss_cd = b300_rec.iss_cd
                AND a.b140_prem_seq_no = b300_rec.prem_seq_no
                AND a.inst_no = b300_rec.inst_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ws_temp_payts := 0;
         WHEN TOO_MANY_ROWS
         THEN
            raise_application_error (
               -20019,
               'Too many rows found in GIAC_INWFACUL_PREM_COLLNS table.');
      END;

      ws_total_payts := NVL (ws_colln_amt, 0);
      ws_bal_amt_due := NVL (ws_total_amt_due, 0) - NVL (ws_colln_amt, 0);
      ws_prem_bal_due := NVL (ws_prem_amt, 0) - NVL (ws_gidc_prem, 0);
      ws_tax_amount := NVL (ws_tax_amt, 0) - NVL (ws_gidc_tax, 0);
      ws_comm_bal_due := NVL (ws_ri_comm_amt, 0) - NVL (ws_comm_amt, 0);
      ws_comm_vat := NVL (ws_ri_comm_vat, 0) - NVL (ws_comm_vat_amt, 0);
      ws_overdue := (TRUNC (SYSDATE) - TRUNC (b300_rec.due_date) + 1);

      IF ws_overdue > 0
      THEN
         BEGIN
            SELECT aging_id, max_no_days
              INTO ws_aging_id, ws_max_no_days
              FROM cpi.giac_aging_parameters
             WHERE     gibr_gfun_fund_cd = ws_fund_cd
                   AND gibr_branch_cd = b300_rec.iss_cd
                   AND min_no_days <= ABS (ws_overdue)
                   AND max_no_days >= ABS (ws_overdue)
                   AND over_due_tag = 'Y';

            IF ws_max_no_days < 99999
            THEN
               ws_nxt_age_lvl_dt := b300_rec.due_date + ws_max_no_days;
            ELSE
               ws_nxt_age_lvl_dt := b300_rec.due_date;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20015,
                  'No record found in GIAC_AGING_PARAMETERS table.');
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error (
                  -20014,
                  'Too many rows found in GIAC_AGING_PARAMETERS table.');
         END;
      ELSE
         BEGIN
            SELECT aging_id, max_no_days
              INTO ws_aging_id, ws_max_no_days
              FROM cpi.giac_aging_parameters
             WHERE     gibr_gfun_fund_cd = ws_fund_cd
                   AND gibr_branch_cd = b300_rec.iss_cd
                   AND min_no_days <= ROUND (ABS (ws_overdue))
                   AND max_no_days >= ROUND (ABS (ws_overdue))
                   AND over_due_tag = 'N';

            ws_nxt_age_lvl_dt := b300_rec.due_date;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20015,
                  'No record found in GIAC_AGING_PARAMETERS table.');
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error (
                  -20014,
                  'Too many rows found in GIAC_AGING_PARAMETERS table.');
         END;
      END IF;

      BEGIN
         SELECT ROWID
           INTO ws_rowid
           FROM cpi.giac_aging_ri_soa_details
          WHERE     inst_no = b300_rec.inst_no
                AND prem_seq_no = b300_rec.prem_seq_no
                AND a180_ri_cd = ws_ri_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ins_ctr := NVL (ins_ctr, 0) + 1;

            INSERT INTO cpi.giac_aging_ri_soa_details (gagp_aging_id,
                                                       a180_ri_cd,
                                                       a020_assd_no,
                                                       a150_line_cd,
                                                       prem_seq_no,
                                                       total_amount_due,
                                                       total_payments,
                                                       temp_payments,
                                                       balance_due,
                                                       prem_balance_due,
                                                       next_age_level_dt,
                                                       inst_no,
                                                       comm_balance_due,
                                                       wholding_tax_bal,
                                                       tax_amount,
                                                       comm_vat)
                 VALUES (ws_aging_id,
                         ws_ri_cd,
                         ws_assd_no,
                         ws_line_cd,
                         b300_rec.prem_seq_no,
                         ws_total_amt_due,
                         ws_total_payts,
                         ws_temp_payts,
                         ws_bal_amt_due,
                         ws_prem_bal_due,
                         ws_nxt_age_lvl_dt,
                         b300_rec.inst_no,
                         ws_comm_bal_due,
                         0,
                         ws_tax_amount,
                         ws_comm_vat);
      END;

      /* mikel 03.21.2013
      ** for adjustments in comm amt and comm vat of bills with invoice value not divisible by the no. of installments
      */
      /*ws_ri_comm_amt := ws_comm_bal_due;
      ws_ri_comm_vat := ws_comm_vat;

      IF b300_buf.inst_no <> b300_rec.no_of_payt
      THEN
         ws_ri_comm_amt_tot :=
                         NVL (ws_ri_comm_amt_tot, 0)
                         + NVL (ws_ri_comm_amt, 0);
         ws_ri_comm_vat_tot := NVL (ws_ri_comm_vat_tot, 0) + ws_ri_comm_vat;
      ELSE
         ws_comm_bal_due :=
                           b300_rec.tot_ri_comm - NVL (ws_ri_comm_amt_tot, 0);
         ws_comm_vat := b300_rec.tot_comm_vat - NVL (ws_ri_comm_vat_tot, 0);
         ws_bal_amt_due :=
              (ws_prem_bal_due + ws_tax_amount)
            - (ws_comm_bal_due + ws_comm_vat);
         ws_total_amt_due :=
              (b300_rec.prem_amt + b300_rec.tax_amt)
            - (  (b300_rec.tot_ri_comm - NVL (ws_ri_comm_amt_tot, 0))
               + (b300_rec.tot_comm_vat - NVL (ws_ri_comm_vat_tot, 0))
              );
      END IF;*/
      IF ws_rowid IS NOT NULL
      THEN
         upd_ctr := NVL (upd_ctr, 0) + 1;

         UPDATE cpi.giac_aging_ri_soa_details
            SET total_amount_due = ws_total_amt_due,
                total_payments = ws_total_payts,
                temp_payments = ws_temp_payts,
                balance_due = ws_bal_amt_due,
                prem_balance_due = ws_prem_bal_due,
                tax_amount = ws_tax_amount,
                comm_balance_due = ws_comm_bal_due,
                comm_vat = ws_comm_vat
          WHERE     gagp_aging_id >= 0
                AND a020_assd_no = ws_assd_no
                AND a150_line_cd = ws_line_cd
                AND prem_seq_no = b300_rec.prem_seq_no
                AND a180_ri_cd = ws_ri_cd
                AND inst_no = b300_rec.inst_no;
      END IF;

      ws_total_payts := 0;
      ws_temp_payts := 0;
      ws_bal_amt_due := 0;
      ws_prem_bal_due := 0;
      ws_tax_amount := 0;
      ws_colln_amt := 0;
      ws_gidc_prem := 0;
      ws_gidc_tax := 0;
      ws_comm_bal_due := 0;
      ws_comm_vat := 0;
      v_counter := v_counter + 1;
      COMMIT;
   END LOOP;
END;