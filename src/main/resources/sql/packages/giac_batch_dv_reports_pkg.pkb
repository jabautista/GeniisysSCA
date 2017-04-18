CREATE OR REPLACE PACKAGE BODY CPI.giac_batch_dv_reports_pkg
AS
    /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  3 January.2011
   **  Reference By : (GIACR086, GIACR086C - Special Claim Settlement Request REPORTS)
   **  Description  : Retrieves the main query of the report
   */
   FUNCTION get_main_query_086c (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE,
      p_report_id     VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN main_query_tab PIPELINED
   IS
      currency          VARCHAR2 (100);
      v_query           main_query_type;
      v_final           VARCHAR2 (50);
      v_payee           VARCHAR2 (2000);
      var_currency      VARCHAR2 (20);
      var_currency_sn   VARCHAR2 (3);
      -- var_v_sp          VARCHAR2 (2000);
      v_param_value_v   giis_parameters.param_value_v%TYPE;
      v_hist_seq_no     gicl_clm_loss_exp.hist_seq_no%TYPE;
      v_remarks         gicl_clm_loss_exp.remarks%TYPE;
      v_eff_date        VARCHAR2 (100);
      v_exp_date        VARCHAR2 (100);
      v_print_name      VARCHAR2 (1);
      v_deductible_cd    VARCHAR2 (2);
      v_cnt             NUMBER(12) := 0; --added by steven 03.26.2014
   BEGIN
      FOR i IN
         (SELECT a.line_cd line_cd_1, a.claim_id claim_id_1,
                 c.advice_id advice_id_1, b.payee_class_cd payee_class_cd_1,
                 b.payee_cd payee_cd_1,
                    a.line_cd
                 || '-'
                 || a.subline_cd
                 || '-'
                 || a.pol_iss_cd
                 || '-'
                 || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                 || '-'
                 || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                 || '-'
                 || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_no,
                 a.assured_name, a.assd_name2, a.acct_of_cd,
                 --TO_CHAR (a.dsp_loss_date, 'MON-DD-YYYY') dsp_loss_date, replaced date format Nica 12.04.2012
                 TO_CHAR (a.dsp_loss_date, 'fmMonth dd,yyyy') dsp_loss_date,
                 a.line_cd,
                    a.line_cd
                 || '-'
                 || a.subline_cd
                 || '-'
                 || a.iss_cd
                 || '-'
                 || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                 || '-'
                 || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_no,
                 b.payee_class_cd, b.payee_cd,
                    b.fund_cd
                 || '-'
                 || b.branch_cd
                 || '-'
                 || b.batch_year
                 || '-'
                 || b.batch_mm
                 || '-'
                 || b.batch_seq_no batch_no,
                 DECODE
                    (d.currency_cd,
                     c.currency_cd, d.advise_amt,
                     (  d.advise_amt
                      * c.orig_curr_rate  /*d.currency_rate /*c.convert_rate*/
                     )
                    ) advise_amt,               -- Modified by Marlo 10272010
                 DECODE
                    (d.currency_cd,
                     c.currency_cd, d.net_amt,
                     (  d.net_amt
                      * c.orig_curr_rate  /*d.currency_rate /*c.convert_rate*/
                     )
                    ) net_amt,                  -- Modified by Marlo 10272010
                 DECODE
                    (d.currency_cd,
                     c.currency_cd, d.paid_amt,
                     (  d.paid_amt
                      * c.orig_curr_rate  /*d.currency_rate /*c.convert_rate*/
                     )
                    ) paid_amt,                 -- Modified by Marlo 10272010
                 b.batch_dv_id, c.convert_rate, a.claim_id, c.advice_id,
                 d.clm_loss_id, a.iss_cd,
                 DECODE (d.clm_clmnt_no,
                         NULL, 0,
                         d.clm_clmnt_no
                        ) clm_clmnt_no,
                 b.tran_id, d.final_tag, d.ex_gratia_sw, d.claim_id clm_id,
                 b.branch_cd
            FROM gicl_claims a,
                 giac_batch_dv b,
                 gicl_advice c,
                 gicl_clm_loss_exp d
           WHERE a.claim_id = c.claim_id
             AND a.claim_id = d.claim_id
             AND b.batch_dv_id = c.batch_dv_id
             AND b.batch_dv_id = p_batch_dv_id
             AND c.advice_id = d.advice_id)
      LOOP
         v_cnt := v_cnt + 1;  --added by steven 03.26.2014
         v_query.cnt := v_cnt;  --added by steven 03.26.2014
         v_query.claim_no := i.claim_no;
         v_query.policy_no := i.policy_no;
         v_query.batch_no := i.batch_no;
         v_query.line_cd_1 := i.line_cd_1;
         v_query.branch_cd := i.branch_cd; -- Nica 12.04.2012
         v_query.f_assured_name := i.assured_name;
         v_query.f_assd_name2 := i.assd_name2;
         v_query.final_assured_name := i.assured_name || ' ' || i.assd_name2;
         v_query.dsp_loss_date := i.dsp_loss_date;
         v_query.line_cd_1 := i.line_cd_1;
         v_query.claim_id := i.claim_id;
         v_query.advice_id := i.advice_id;

         -- get sum of paid_amt
         BEGIN
            SELECT SUM (DECODE (d.currency_cd,
                                c.currency_cd, d.paid_amt,
                                (d.paid_amt * c.orig_curr_rate
                                )
                               )
                       )
              INTO v_query.sum_paid_amt
              FROM gicl_claims a,
                   giac_batch_dv b,
                   gicl_advice c,
                   gicl_clm_loss_exp d
             WHERE a.claim_id = c.claim_id
               AND a.claim_id = d.claim_id
               AND b.batch_dv_id = c.batch_dv_id
               AND b.batch_dv_id = p_batch_dv_id
               AND c.advice_id = d.advice_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_query.sum_paid_amt := 0;
         END;

         -- (start) restore from geniisys devt for ucbp --nante 8-14-2013
         -- get sum of net_amt
         BEGIN
            SELECT SUM (DECODE (d.currency_cd,
                                c.currency_cd, d.net_amt,
                                (d.net_amt * c.orig_curr_rate
                                )
                               )
                       )
              INTO v_query.sum_net_amt
              FROM gicl_claims a,
                   giac_batch_dv b,
                   gicl_advice c,
                   gicl_clm_loss_exp d
             WHERE a.claim_id = c.claim_id
               AND a.claim_id = d.claim_id
               AND b.batch_dv_id = c.batch_dv_id
               AND b.batch_dv_id = p_batch_dv_id
               AND c.advice_id = d.advice_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_query.sum_net_amt := 0;
         END;
        -- (end) restore from geniisys devt for ucbp --nante 8-14-2013
        
        -- (start) add parameter for loss amount with deductible   -- nante 8-14-2013
        BEGIN
            SELECT param_value_v
              INTO v_deductible_cd
              FROM giac_parameters
             WHERE param_name = 'TAX_BASE_AMT';
             v_query.deductible_cd := v_deductible_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_query.deductible_cd := 'LD';     
        END;
        -- (end) add parameter for loss amount with deductible   -- nante 8-14-2013
 
         FOR t IN (SELECT param_value_v title
                     FROM giac_parameters
                    WHERE param_name = 'FINAL_CSR_TITLE')
         LOOP
            v_query.title := t.title;
         END LOOP;

         FOR c IN (SELECT param_value_v attn
                     FROM giac_parameters
                    WHERE param_name = 'CSR_ATTN')
         LOOP
            v_query.csr_attn := c.attn;
         END LOOP;

         IF i.ex_gratia_sw = 'Y'
         THEN
            v_final := ' as Ex Gratia settlement of the loss ';
         ELSIF (i.ex_gratia_sw = 'N' OR i.ex_gratia_sw IS NULL)
         THEN
            IF (i.final_tag = 'N' OR i.final_tag IS NULL)
            THEN
               v_final := ' as partial settlement of the loss ';
            ELSIF i.final_tag = 'Y'
            THEN
               v_final := 'as full and final settlement of the loss ';
            END IF;
         END IF;

         BEGIN
            SELECT    DECODE (a.payee_first_name,
                              NULL, a.payee_last_name,
                                 a.payee_first_name
                              || ' '
                              || a.payee_middle_name
                              || ' '
                              || a.payee_last_name
                             )
                   || ' '
                   || b.payee_remarks payee_name
              INTO v_payee
              FROM giis_payees a, giac_batch_dv b
             WHERE a.payee_class_cd = b.payee_class_cd
               AND a.payee_no = b.payee_cd
               AND b.batch_dv_id = p_batch_dv_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_payee := '';
         END;

         SELECT currency_desc, short_name
           INTO var_currency, var_currency_sn
           FROM giis_currency
          WHERE main_currency_cd IN (SELECT NVL (currency_cd, 1) currency_cd
                                       FROM giac_batch_dv
                                      WHERE batch_dv_id = p_batch_dv_id);

         BEGIN
            SELECT param_value_v
              INTO v_param_value_v
              FROM giis_parameters
             WHERE param_name = 'INCLUDE_REMARKS_TO_PAYEE';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_param_value_v := NULL;
         END;

         BEGIN
            SELECT   MAX (hist_seq_no), remarks
                INTO v_hist_seq_no, v_remarks
                FROM gicl_clm_loss_exp b
               WHERE 1 = 1
                 AND b.claim_id = i.claim_id_1
                 AND b.advice_id = i.advice_id_1
                 AND b.payee_class_cd = i.payee_class_cd_1
                 AND b.payee_cd = i.payee_cd_1
            GROUP BY b.claim_id,
                     b.advice_id,
                     b.payee_class_cd,
                     b.payee_cd,
                     b.remarks;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_hist_seq_no := NULL;
               v_remarks := NULL;
         END;

         IF v_param_value_v = 'Y' AND v_remarks IS NOT NULL
         THEN
            v_query.var_v_sp :=
                  '       Please issue a check in favor of '
               || v_payee
               || ' '
               || v_remarks
               || ' in '
               || var_currency
               || ' : '
               || dh_util.check_protect (v_query.sum_paid_amt, currency, TRUE)
               || ' only ('
               || var_currency_sn
               || ' '
               || LTRIM (TO_CHAR (v_query.sum_paid_amt, '999,999,999,999.00'))
               || '), '
               || v_final
               || 'under the following :';
         ELSE
            v_query.var_v_sp :=
                  '       Please issue a check in favor of '
               || v_payee
               || ' in '
               || var_currency
               || ' : '
               || dh_util.check_protect (v_query.sum_paid_amt, currency, TRUE)
               || ' only ('
               || var_currency_sn
               || ' '
               || LTRIM (TO_CHAR (v_query.sum_paid_amt, '999,999,999,999.00'))
               || '), '
               || v_final
               || 'under the following :';
         END IF;

         FOR assd IN (SELECT assd_name || ' ' || assd_name2 assured
                        FROM giis_assured
                       WHERE assd_no = i.acct_of_cd)
         LOOP
            v_query.acct_of := assd.assured;
            EXIT;
         END LOOP;

         BEGIN
            SELECT TO_CHAR (MIN (pol_eff_date), 'fmMonth dd,yyyy')
              INTO v_eff_date
              FROM gicl_claims
             WHERE claim_id = i.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_eff_date := NULL;
         --srw.message(1,'Claim ID not in GICL_CLM_POLBAS');
         END;

         BEGIN
            SELECT TO_CHAR (MAX (expiry_date), 'fmMonth dd,yyyy')
              INTO v_exp_date
              FROM gicl_claims
             WHERE claim_id = i.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exp_date := NULL;
         -- srw.message(1,'Claim ID not in GICL_CLM_POLBAS');
         END;

         v_query.term_date := v_eff_date || ' - ' || v_exp_date;
         v_query.intm := NULL;

         BEGIN
            SELECT param_value_v
              INTO v_print_name
              FROM giac_parameters
             WHERE param_name = 'PRINT_INTM_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_print_name := 'N';
         END;

         IF v_print_name = 'N'
         THEN
            FOR m IN (SELECT DISTINCT    TO_CHAR (c.intm_no)
                                      || '/'
                                      || NVL (c.ref_intm_cd, ' ') intm
                                 FROM gicl_claims a,
                                      gicl_intm_itmperil b,
                                      giis_intermediary c
                                WHERE a.claim_id = b.claim_id
                                  AND b.intm_no = c.intm_no
                                  AND a.claim_id = i.claim_id)
            LOOP
               IF v_query.intm IS NULL
               THEN
                  v_query.intm := m.intm;
               ELSIF v_query.intm IS NOT NULL
               THEN
                  v_query.intm := v_query.intm || CHR (10) || m.intm;
               END IF;
            END LOOP;
         ELSE
            FOR m IN (SELECT DISTINCT    TO_CHAR (c.intm_no)
                                      || '/'
                                      || NVL (c.ref_intm_cd, ' ')
                                      || '/'
                                      || c.intm_name intm
                                 FROM gicl_claims a,
                                      gicl_intm_itmperil b,
                                      giis_intermediary c
                                WHERE a.claim_id = b.claim_id
                                  AND b.intm_no = c.intm_no
                                  AND a.claim_id = i.claim_id)
            LOOP
               IF v_query.intm IS NULL
               THEN
                  v_query.intm := m.intm;
               ELSIF v_query.intm IS NOT NULL
               THEN
                  v_query.intm := v_query.intm || CHR (10) || m.intm;
               END IF;
            END LOOP;
         END IF;

         FOR l IN (SELECT c.loss_cat_des
                     FROM giis_loss_ctgry c,
                          gicl_item_peril a,
                          gicl_clm_loss_exp b
                    WHERE c.loss_cat_cd = a.loss_cat_cd
                      AND a.claim_id = b.claim_id
                      AND a.item_no = b.item_no
                      AND a.grouped_item_no = b.grouped_item_no
                      AND a.peril_cd = b.peril_cd
                      AND c.line_cd = i.line_cd
                      AND b.claim_id = i.claim_id
                      AND b.advice_id = i.advice_id
                      AND b.clm_loss_id = i.clm_loss_id)      -- alex 11/22/06
         LOOP
            IF v_query.loss_cat_des IS NULL
            THEN
               v_query.loss_cat_des := l.loss_cat_des;
            ELSIF v_query.loss_cat_des IS NOT NULL
            THEN
               v_query.loss_cat_des :=
                                v_query.loss_cat_des || '/' || l.loss_cat_des;
            END IF;
         END LOOP;

         FOR r IN (SELECT    document_cd
                          || '-'
                          || branch_cd
                          || '-'
                          || TO_CHAR (doc_year)
                          || '-'
                          || TO_CHAR (doc_mm)
                          || '-'
                          || LPAD (TO_CHAR (doc_seq_no), 6, '0') request_no
                     -- jess 11.25.2010 add LPAD to display leading zeros for doc_seq_no
                   FROM   giac_payt_requests a, giac_payt_requests_dtl b
                    WHERE a.ref_id = b.gprq_ref_id AND b.tran_id = i.tran_id)
         LOOP
            v_query.request_no := r.request_no;
         END LOOP;

         BEGIN
            SELECT short_name
              INTO v_query.currency
              FROM giis_currency
             WHERE main_currency_cd IN (
                                        SELECT NVL (currency_cd,
                                                    1
                                                   ) currency_cd
                                          FROM giac_batch_dv
                                         WHERE batch_dv_id = p_batch_dv_id);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            IF i.ex_gratia_sw = 'Y'
            THEN
               v_query.remark := 'As Ex Gratia settlement of the above loss.';
            ELSIF (i.ex_gratia_sw = 'N' OR i.ex_gratia_sw IS NULL)
            THEN
               IF (i.final_tag IS NULL) OR (i.final_tag = 'N')
               THEN
                  v_query.remark :=
                                   'As partial settlement of the above loss.';
               ELSIF i.final_tag = 'Y'
               THEN
                  v_query.remark :=
                            'As full and final settlement of the above loss.';
               END IF;
            END IF;
         END;

         BEGIN
            SELECT param_value_v
              INTO v_query.show_csr_peril
              FROM giis_parameters
             WHERE param_name = 'SHOW_CSR_PERIL';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_query.show_csr_peril := 'N';
         END;

         FOR rec IN (SELECT param_value_v
                       FROM giac_parameters
                      WHERE param_name = 'CSR_PREPARED_BY')
         LOOP
            v_query.SWITCH := rec.param_value_v;
         END LOOP;

         FOR s IN (SELECT   a.report_no, b.item_no, b.label, c.signatory,
                            c.designation
                       FROM giac_documents a,
                            giac_rep_signatory b,
                            giis_signatory_names c
                      WHERE a.report_no = b.report_no
                        AND a.report_id = b.report_id
                        AND a.report_id = p_report_id
                        AND NVL (a.line_cd, '@') = NVL (i.line_cd_1, '@')
                        AND NVL (a.branch_cd, '@') = NVL (i.branch_cd, '@')
                        AND b.signatory_id = c.signatory_id
                   UNION
                   SELECT   1 rep_no, 1 item_no, 'PREPARED BY :' lbel,
                            user_name, ' ' designation
                       FROM giis_users
                      WHERE user_id = p_user_id
                   ORDER BY 2)
         LOOP
            v_query.label := s.label;
            v_query.signatory := s.signatory;
            v_query.designation := s.designation;
         END LOOP;

         BEGIN
            SELECT DECODE (remarks, NULL, remarks, '***' || remarks) remarks
              INTO v_query.remarks
              FROM gicl_advice
             WHERE advice_id = i.advice_id;
         END;

         PIPE ROW (v_query);
      END LOOP;
   END;

   FUNCTION get_main_query_086 (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE,
      p_tran_id       giac_batch_dv.tran_id%TYPE,
      p_report_id     VARCHAR2,
      p_user_id       VARCHAR2,
      p_line_cd       gicl_claims.line_cd%TYPE,
      p_branch_cd     gicl_claims.line_cd%TYPE
   )
      RETURN main_query_tab PIPELINED
   IS
      currency          VARCHAR2 (100);
      v_query           main_query_type;
      v_payee           VARCHAR2 (2000);
      var_v_sp          VARCHAR2 (2000);
      var_currency      VARCHAR2 (20);
      var_currency_sn   VARCHAR2 (3);
      v_deductible_cd   VARCHAR2 (2);
   /* v_query           main_query_type;
    v_final           VARCHAR2 (50);
    v_payee           VARCHAR2 (2000);


    v_param_value_v   giis_parameters.param_value_v%TYPE;
    v_hist_seq_no     gicl_clm_loss_exp.hist_seq_no%TYPE;
    v_remarks         gicl_clm_loss_exp.remarks%TYPE;
    v_eff_date        VARCHAR2 (100);
    v_exp_date        VARCHAR2 (100);
    v_print_name      VARCHAR2 (1);*/
   BEGIN
      BEGIN
         SELECT SUM (DECODE (d.currency_cd,
                             c.currency_cd, d.paid_amt,
                             (d.paid_amt * c.orig_curr_rate
                             )
                            )
                    )
           INTO v_query.sum_paid_amt
           FROM gicl_claims a,
                giac_batch_dv b,
                gicl_advice c,
                gicl_clm_loss_exp d
          WHERE a.claim_id = c.claim_id
            AND a.claim_id = d.claim_id
            AND b.batch_dv_id = c.batch_dv_id
            AND b.batch_dv_id = p_batch_dv_id
            AND c.advice_id = d.advice_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_query.sum_paid_amt := 0;
      END;

      -- (start) restore from geniisys devt for ucbp --nante 8-14-2013
      -- added by: Nica 02.12.2013
      BEGIN
         SELECT SUM (DECODE (d.currency_cd,
                             c.currency_cd, d.net_amt,
                             (d.net_amt * c.orig_curr_rate
                             )
                            )
                    )
           INTO v_query.sum_net_amt
           FROM gicl_claims a,
                giac_batch_dv b,
                gicl_advice c,
                gicl_clm_loss_exp d
          WHERE a.claim_id = c.claim_id
            AND a.claim_id = d.claim_id
            AND b.batch_dv_id = c.batch_dv_id
            AND b.batch_dv_id = p_batch_dv_id
            AND c.advice_id = d.advice_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_query.sum_net_amt := 0;
      END;
     -- (end) restore from geniisys devt for ucbp --nante 8-14-2013
     
     -- (start) add parameter for loss amount with deductible   -- nante 8-14-2013
        BEGIN
            SELECT param_value_v
              INTO v_deductible_cd
              FROM giac_parameters
             WHERE param_name = 'TAX_BASE_AMT';
             v_query.deductible_cd := v_deductible_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_query.deductible_cd := 'LD'; 
        END;
        -- (end) add parameter for loss amount with deductible   -- nante 8-14-2013
     
      BEGIN
         SELECT    DECODE (a.payee_first_name,
                           NULL, a.payee_last_name,
                              a.payee_first_name
                           || ' '
                           || a.payee_middle_name
                           || ' '
                           || a.payee_last_name
                          )
                || ' '
                || b.payee_remarks payee_name
           INTO v_payee
           FROM giis_payees a, giac_batch_dv b
          WHERE a.payee_class_cd = b.payee_class_cd
            AND a.payee_no = b.payee_cd
            AND b.batch_dv_id = p_batch_dv_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_payee := '';
      END;

      SELECT currency_desc, short_name
        INTO var_currency, var_currency_sn
        FROM giis_currency
       WHERE short_name IN (SELECT param_value_v
                              FROM giac_parameters
                             WHERE param_name = 'DEFAULT_CURRENCY');

      v_query.var_v_sp :=
            '       Please issue a check in favor of '
         || v_payee
         || ' '
         || ' in '
         || var_currency
         || ' : '
         || dh_util.check_protect (v_query.sum_paid_amt, currency, TRUE)
         || ' only ('
         || var_currency_sn
         || ' '
         || LTRIM (TO_CHAR (v_query.sum_paid_amt, '999,999,999,999.00'))
         || '), under the following :';

      FOR t IN (SELECT param_value_v title
                  FROM giac_parameters
                 WHERE param_name = 'FINAL_CSR_TITLE')
      LOOP
         v_query.title := t.title;
      END LOOP;

      FOR c IN (SELECT param_value_v attn
                  FROM giac_parameters
                 WHERE param_name = 'CSR_ATTN')
      LOOP
         v_query.csr_attn := c.attn;
      END LOOP;

      FOR r IN (SELECT    document_cd
                       || '-'
                       || branch_cd
                       || '-'
                       || TO_CHAR (doc_year)
                       || '-'
                       || TO_CHAR (doc_mm)
                       || '-'
                       || LPAD (TO_CHAR (doc_seq_no), 6, '0') request_no
                  -- jess 11.25.2010 add LPAD to display leading zeros for doc_seq_no
                FROM   giac_payt_requests a, giac_payt_requests_dtl b
                 WHERE a.ref_id = b.gprq_ref_id AND b.tran_id = p_tran_id)
      LOOP
         v_query.request_no := r.request_no;
      END LOOP;

      BEGIN
         SELECT short_name
           INTO v_query.currency
           FROM giis_currency
          WHERE main_currency_cd IN (SELECT NVL (currency_cd, 1) currency_cd
                                       FROM giac_batch_dv
                                      WHERE batch_dv_id = p_batch_dv_id);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_query.remark
           FROM giac_parameters
          WHERE param_name LIKE 'BCSR_PAYT_REMARK';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_query.remark :=
                    'As partial/full and final settlement of the above loss.';
      END;

      FOR rec IN (SELECT param_value_v
                    FROM giac_parameters
                   WHERE param_name = 'CSR_PREPARED_BY')
      LOOP
         v_query.SWITCH := rec.param_value_v;
      END LOOP;

      FOR s IN (SELECT   a.report_no, b.item_no, b.label, c.signatory,
                         c.designation
                    FROM giac_documents a,
                         giac_rep_signatory b,
                         giis_signatory_names c
                   WHERE a.report_no = b.report_no
                     AND a.report_id = b.report_id
                     AND a.report_id = p_report_id
                     AND NVL (a.line_cd, '@') = NVL (p_line_cd, '@')
                     AND NVL (a.branch_cd, '@') = NVL (p_branch_cd, '@')
                     AND b.signatory_id = c.signatory_id
                UNION
                SELECT   1 rep_no, 1 item_no, 'PREPARED BY :' lbel, user_name,
                         ' ' designation
                    FROM giis_users
                   WHERE user_id = p_user_id
                ORDER BY 2)
      LOOP
         v_query.label := s.label;
         v_query.signatory := s.signatory;
         v_query.designation := s.designation;
      END LOOP;

      PIPE ROW (v_query);
   END;

   
   FUNCTION get_policies (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN policy_list_tab PIPELINED
   IS
      v_pol          policy_list_type;
      v_print_name   VARCHAR2 (1);
   BEGIN
      FOR i IN
         (SELECT    a.line_cd
                 || '-'
                 || a.subline_cd
                 || '-'
                 || a.pol_iss_cd
                 || '-'
                 || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                 || '-'
                 || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                 || '-'
                 || LPAD (TO_CHAR (a.renew_no), 2, '0') POLICY,
                 a.assured_name, a.dsp_loss_date, a.line_cd,
                    a.line_cd
                 || '-'
                 || a.subline_cd
                 || '-'
                 || a.iss_cd
                 || '-'
                 || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                 || '-'
                 || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim,
                 b.payee_class_cd, b.payee_cd,
                    b.fund_cd
                 || '-'
                 || b.branch_cd
                 || '-'
                 || b.batch_year
                 || '-'
                 || b.batch_mm
                 || '-'
                 || b.batch_seq_no batch_no,
                 DECODE
                    (d.currency_cd,
                     c.currency_cd, d.advise_amt,
                     (  d.advise_amt
                      * c.orig_curr_rate  /*d.currency_rate /*c.convert_rate*/
                     )
                    ) advise_amt,               -- Modified by Marlo 07132010
                 DECODE
                    (d.currency_cd,
                     c.currency_cd, d.net_amt,
                     (  d.net_amt
                      * c.orig_curr_rate  /*d.currency_rate /*c.convert_rate*/
                     )
                    ) net_amt,                  -- Modified by Marlo 07132010
                 DECODE
                    (d.currency_cd,
                     c.currency_cd, d.paid_amt,
                     (  d.paid_amt
                      * c.orig_curr_rate  /*d.currency_rate /*c.convert_rate*/
                     )
                    ) paid_amt,                 -- Modified by Marlo 07132010
                 b.batch_dv_id, c.convert_rate, a.claim_id, c.advice_id,
                 d.clm_loss_id,
                 DECODE (d.clm_clmnt_no,
                         NULL, 0,
                         d.clm_clmnt_no
                        ) clm_clmnt_no,
                 b.tran_id
            FROM gicl_claims a,
                 giac_batch_dv b,
                 gicl_advice c,
                 gicl_clm_loss_exp d
           WHERE a.claim_id = c.claim_id
             AND a.claim_id = d.claim_id
             AND b.batch_dv_id = c.batch_dv_id
             AND b.batch_dv_id = p_batch_dv_id
             AND c.advice_id = d.advice_id)
      LOOP
         v_pol.policy_no := i.POLICY;
         v_pol.claim_no := i.claim;
         v_pol.assured_name := i.assured_name;
         v_pol.dsp_loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY');
         v_pol.paid_amt := i.paid_amt;
         v_pol.intm := NULL;

         BEGIN
            SELECT param_value_v
              INTO v_print_name
              FROM giac_parameters
             WHERE param_name = 'PRINT_INTM_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_print_name := 'N';
         END;

         IF v_print_name = 'N'
         THEN
            FOR a IN (SELECT DISTINCT    TO_CHAR (c.intm_no)
                                      || '/'
                                      || NVL (c.ref_intm_cd, ' ') intm
                                 FROM gicl_claims a,
                                      gicl_intm_itmperil b,
                                      giis_intermediary c
                                WHERE a.claim_id = b.claim_id
                                  AND b.intm_no = c.intm_no
                                  AND a.claim_id = i.claim_id)
            LOOP
               IF v_pol.intm IS NULL
               THEN
                  v_pol.intm := a.intm;
               ELSIF v_pol.intm IS NOT NULL
               THEN
                  v_pol.intm := v_pol.intm || CHR (10) || a.intm;
               END IF;
            END LOOP;
         ELSE
            FOR a IN (SELECT DISTINCT    TO_CHAR (c.intm_no)
                                      || '/'
                                      || NVL (c.ref_intm_cd, ' ')
                                      || '/'
                                      || c.intm_name intm
                                 FROM gicl_claims a,
                                      gicl_intm_itmperil b,
                                      giis_intermediary c
                                WHERE a.claim_id = b.claim_id
                                  AND b.intm_no = c.intm_no
                                  AND a.claim_id = i.claim_id)
            LOOP
               IF v_pol.intm IS NULL
               THEN
                  v_pol.intm := a.intm;
               ELSIF v_pol.intm IS NOT NULL
               THEN
                  v_pol.intm := v_pol.intm || CHR (10) || a.intm;
               END IF;
            END LOOP;
         END IF;

         v_pol.loss_cat_des := NULL;

         FOR c IN (SELECT c.loss_cat_des
                     FROM giis_loss_ctgry c,
                          gicl_item_peril a,
                          gicl_clm_loss_exp b
                    WHERE c.loss_cat_cd = a.loss_cat_cd
                      AND a.claim_id = b.claim_id
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND c.line_cd = i.line_cd
                      AND b.claim_id = i.claim_id
                      AND b.advice_id = i.advice_id
                      AND b.clm_loss_id = i.clm_loss_id)
         LOOP
            IF v_pol.loss_cat_des IS NULL
            THEN
               v_pol.loss_cat_des := c.loss_cat_des;
            ELSIF v_pol.loss_cat_des IS NOT NULL
            THEN
               v_pol.loss_cat_des :=
                                  v_pol.loss_cat_des || '/' || c.loss_cat_des;
            END IF;
         END LOOP;

         PIPE ROW (v_pol);
      END LOOP;
   END;

   FUNCTION get_loss_exp (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN loss_exp_tab PIPELINED
   IS
      v_loss   loss_exp_type;
   BEGIN
      FOR i IN
         (SELECT a.*
            FROM (SELECT   SUM (DECODE (c.currency_cd,
                                        d.currency_cd, a.dtl_amt,
                                        -- a.dtl_amt * c.currency_rate
                                        a.dtl_amt * d.orig_curr_rate
                                       )
                               ) a_dtl_amt,
                           b.loss_exp_desc, e.batch_dv_id
                      FROM gicl_loss_exp_dtl a,
                           giis_loss_exp b,
                           gicl_clm_loss_exp c,
                           gicl_advice d,
                           giac_batch_dv e
                     WHERE a.loss_exp_cd IN (
                              SELECT a.loss_exp_cd
                                FROM gicl_loss_exp_dtl a,
                                     giis_loss_exp b,
                                     gicl_clm_loss_exp c,
                                     gicl_advice d,
                                     giac_batch_dv e
                               WHERE a.loss_exp_cd = b.loss_exp_cd
                                 AND a.line_cd = b.line_cd
                                 AND a.claim_id = c.claim_id
                                 AND a.clm_loss_id = c.clm_loss_id
                                 AND a.claim_id = d.claim_id
                                 AND NVL (b.loss_exp_type, 'L') =
                                                       NVL (c.payee_type, 'L')
                                 AND c.advice_id = d.advice_id
                                 AND d.batch_dv_id = e.batch_dv_id
                                 AND (a.dtl_amt >= 0))
                       AND a.loss_exp_cd = b.loss_exp_cd
--      AND a.loss_exp_type = b.loss_exp_type
                       AND NVL (a.loss_exp_type, 'L') =
                                                    NVL (b.loss_exp_type, 'L')
                       AND a.line_cd = b.line_cd
                       AND NVL (a.subline_cd, 'XX') = NVL (b.subline_cd, 'XX')
                       AND a.claim_id = c.claim_id
                       AND a.clm_loss_id = c.clm_loss_id
                       AND a.claim_id = d.claim_id
                       AND NVL (b.loss_exp_type, 'L') =
                                                       NVL (c.payee_type, 'L')
                       -- AND b.loss_exp_type = c.payee_type
                       AND c.advice_id = d.advice_id
                       AND d.batch_dv_id = e.batch_dv_id
                       AND (a.dtl_amt >= 0)
                  GROUP BY b.loss_exp_desc, e.batch_dv_id
                  ORDER BY SUM (a.dtl_amt * d.convert_rate)) a
           WHERE a.batch_dv_id = p_batch_dv_id)
      LOOP
         v_loss.loss_exp_desc := i.loss_exp_desc;
         v_loss.dtl_amt := i.a_dtl_amt;
         PIPE ROW (v_loss);
      END LOOP;
   END;

   FUNCTION get_loss_exp2 (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN loss_exp_tab PIPELINED
   IS
      v_loss   loss_exp_type;
   BEGIN
      FOR i IN
         (SELECT a.*
            FROM (SELECT   SUM (DECODE (c.currency_cd,
                                        d.currency_cd, a.dtl_amt,
                                        a.dtl_amt * d.orig_curr_rate
                                       /*c.currency_rate /*d.convert_rate*/
                                       )
                               ) a_dtl_amt,
                           b.loss_exp_desc, e.batch_dv_id
                      FROM gicl_loss_exp_dtl a,
                           giis_loss_exp b,
                           gicl_clm_loss_exp c,
                           gicl_advice d,
                           giac_batch_dv e
                     WHERE a.loss_exp_cd IN (
                              SELECT a.loss_exp_cd
                                FROM gicl_loss_exp_dtl a,
                                     giis_loss_exp b,
                                     gicl_clm_loss_exp c,
                                     gicl_advice d,
                                     giac_batch_dv e
                               WHERE a.loss_exp_cd = b.loss_exp_cd
                                 AND a.line_cd = b.line_cd
                                 AND a.claim_id = c.claim_id
                                 AND a.clm_loss_id = c.clm_loss_id
                                 AND a.claim_id = d.claim_id
                                 AND NVL (b.loss_exp_type, 'L') =
                                                       NVL (c.payee_type, 'L')
                                 AND c.advice_id = d.advice_id
                                 AND d.batch_dv_id = e.batch_dv_id
                                 AND (a.dtl_amt < 0))
                       AND a.loss_exp_cd = b.loss_exp_cd
--      AND a.loss_exp_type = b.loss_exp_type
                       AND NVL (a.loss_exp_type, 'L') =
                                                    NVL (b.loss_exp_type, 'L')
                       AND a.line_cd = b.line_cd
                       AND NVL (a.subline_cd, 'XX') = NVL (b.subline_cd, 'XX')
                       AND a.claim_id = c.claim_id
                       AND a.clm_loss_id = c.clm_loss_id
                       AND a.claim_id = d.claim_id
                       AND NVL (b.loss_exp_type, 'L') =
                                                       NVL (c.payee_type, 'L')
                       -- AND b.loss_exp_type = c.payee_type
                       AND c.advice_id = d.advice_id
                       AND d.batch_dv_id = e.batch_dv_id
                       AND (a.dtl_amt < 0)
                  GROUP BY b.loss_exp_desc, e.batch_dv_id
                  ORDER BY SUM (a.dtl_amt * d.convert_rate)) a
           WHERE batch_dv_id = p_batch_dv_id)
      LOOP
         v_loss.loss_exp_desc := i.loss_exp_desc;
         v_loss.dtl_amt := i.a_dtl_amt;
         PIPE ROW (v_loss);
      END LOOP;
   END;

   FUNCTION get_tax_amt (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN tax_amt_tab PIPELINED
   IS
      v_tax   tax_amt_type;
   BEGIN
      FOR i IN
         (SELECT a.*
            FROM (SELECT   - (SUM (  b.tax_amt
                                   * DECODE (a.currency_cd,
                                             giacp.n ('CURRENCY_CD'), 1,
                                             c.currency_cd, 1,
                                             NVL (c.orig_curr_rate,
                                                  c.convert_rate
                                                 )
                                            )
                                  )
                             ) b_tax_amt,
                           
/*czie, 03/30/2009, commented out and copied code from giclr031, sum(b.tax_amt * c.convert_rate * -1) b_tax_amt,*/
                           d.batch_dv_id
                      FROM gicl_clm_loss_exp a,
                           gicl_loss_exp_tax b,
                           gicl_advice c,
                           giac_batch_dv d
                     WHERE b.tax_type IN (
                              SELECT b.tax_type
                                FROM gicl_clm_loss_exp a,
                                     gicl_loss_exp_tax b,
                                     gicl_advice c,
                                     giac_batch_dv d
                               WHERE a.claim_id = b.claim_id
                                 AND a.clm_loss_id = b.clm_loss_id
                                 AND a.claim_id = c.claim_id
                                 AND a.advice_id = c.advice_id
                                 AND b.tax_type IN ('O', 'W')
                                 AND b.net_tag = 'Y'
                                 AND c.batch_dv_id = d.batch_dv_id)
                       AND a.claim_id = b.claim_id
                       AND a.clm_loss_id = b.clm_loss_id
                       AND a.claim_id = c.claim_id
                       AND a.advice_id = c.advice_id
                       AND b.tax_type IN ('O', 'W')
                       AND b.net_tag = 'Y'
                       AND c.batch_dv_id = d.batch_dv_id
                  GROUP BY d.batch_dv_id) a
           WHERE batch_dv_id = p_batch_dv_id)
      LOOP
         v_tax.tax_amt := NVL (i.b_tax_amt, 0);
         PIPE ROW (v_tax);
      END LOOP;
   /* for testing
   v_tax.tax_amt := 200000;
   PIPE ROW (v_tax);
   v_tax.tax_amt := 200000;
   PIPE ROW (v_tax);*/
   END;

   FUNCTION get_tax_amt2 (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN tax_amt_tab PIPELINED
   IS
      v_tax   tax_amt_type;
   BEGIN
      FOR i IN
         (SELECT a.*
            FROM (SELECT   - (SUM (  b.tax_amt
                                   * DECODE (a.currency_cd,
                                             giacp.n ('CURRENCY_CD'), 1,
                                             c.currency_cd, 1,
                                             NVL (c.orig_curr_rate,
                                                  c.convert_rate
                                                 )
                                            )
                                  )
                             ) b_tax_amt,
                           
/*czie, 03/30/2009, commented out and copied code from giclr031, sum(b.tax_amt * c.convert_rate * -1) b_tax_amt,*/
                           d.batch_dv_id
                      FROM gicl_clm_loss_exp a,
                           gicl_loss_exp_tax b,
                           gicl_advice c,
                           giac_batch_dv d
                     WHERE b.tax_type IN (
                              SELECT b.tax_type
                                FROM gicl_clm_loss_exp a,
                                     gicl_loss_exp_tax b,
                                     gicl_advice c,
                                     giac_batch_dv d
                               WHERE a.claim_id = b.claim_id
                                 AND a.clm_loss_id = b.clm_loss_id
                                 AND a.claim_id = c.claim_id
                                 AND a.advice_id = c.advice_id
                                 AND b.tax_type IN ('O', 'W')
                                 AND b.adv_tag = 'Y'
                                 AND c.batch_dv_id = d.batch_dv_id)
                       AND a.claim_id = b.claim_id
                       AND a.clm_loss_id = b.clm_loss_id
                       AND a.claim_id = c.claim_id
                       AND a.advice_id = c.advice_id
                       AND b.tax_type IN ('O', 'W')
                       AND b.adv_tag = 'Y'
                       AND c.batch_dv_id = d.batch_dv_id
                  GROUP BY d.batch_dv_id) a
           WHERE batch_dv_id = p_batch_dv_id)
      LOOP
         v_tax.tax_amt := i.b_tax_amt;
         PIPE ROW (v_tax);
      END LOOP;
   /* for testing
   v_tax.tax_amt := 200000;
   PIPE ROW (v_tax);
   v_tax.tax_amt := 200000;
   PIPE ROW (v_tax);*/
   END;

   FUNCTION get_tax_input (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN tax_amt_tab PIPELINED
   IS
      v_tax           tax_amt_type;
      v_sum_tax_amt   gicl_loss_exp_tax.tax_amt%TYPE;
   BEGIN
      FOR i IN
         (SELECT a.*
            FROM (SELECT   DECODE
                              (b.w_tax,
                               'Y', 0,
                               (SUM (  b.tax_amt
                                     * DECODE (a.currency_cd,
                                               giacp.n ('CURRENCY_CD'), 1,
                                               c.currency_cd, 1,
                                               NVL (c.orig_curr_rate,
                                                    c.convert_rate
                                                   )
                                              )
                                    )
                               )
                              ) sum_tax_amt,
                           
-- DECODE(b.w_tax,'Y',0,(SUM(b.tax_amt) * DECODE(a.currency_cd,Giacp.N('CURRENCY_CD'),1,c.convert_rate))) sum_tax_amt,  --added by yvette 01172005 /*comment out by jeremy on 03132009*/
 /* b.w_tax,*/   --edit out by yvette 01172005
-- decode(b.w_tax,'N',(b.tax_amt * c.convert_rate),null,(b.tax_amt * c.convert_rate), 'Y',0) tax_amt, /*comment out by jeremy on 03132009*/
                           SUM (  b.tax_amt
                                * DECODE (a.currency_cd,
                                          giacp.n ('CURRENCY_CD'), 1,
                                          c.currency_cd, 1,
                                          NVL (c.orig_curr_rate,
                                               c.convert_rate
                                              )
                                         )
                               ) b_tax_amt,
                           
                           /*copied from GICLR031 by jeremy on 03132009*/

                           --SUM(b.tax_amt) * (c.convert_rate) b_tax_amt
                           d.batch_dv_id
                      FROM gicl_clm_loss_exp a,
                           gicl_loss_exp_tax b,
                           gicl_advice c,
                           giac_batch_dv d
                     WHERE a.claim_id = b.claim_id
                       AND a.clm_loss_id = b.clm_loss_id
                       AND a.claim_id = c.claim_id
                       AND a.advice_id = c.advice_id
                       AND b.tax_type = 'I'
                       AND c.batch_dv_id = d.batch_dv_id
                  GROUP BY b.w_tax,
--decode(b.w_tax,'N',(b.tax_amt * c.convert_rate),null,(b.tax_amt * c.convert_rate), 'Y',0),
                           c.convert_rate,
                           d.batch_dv_id,
                           a.currency_cd) a
           WHERE a.batch_dv_id = p_batch_dv_id)
      LOOP
         v_sum_tax_amt := NVL (v_sum_tax_amt, 0) + NVL (i.b_tax_amt, 0);
      END LOOP;

      IF v_sum_tax_amt <> 0
      THEN
         v_tax.tax_input := v_sum_tax_amt;       -- + 20000+8000; for testing
         PIPE ROW (v_tax);
      END IF;
   END;

   FUNCTION get_tax_input2 (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN tax_amt_tab PIPELINED
   IS
      v_tax   tax_amt_type;
   BEGIN
      FOR i IN
         (SELECT *
            FROM (SELECT   - (SUM (  b.tax_amt
                                   * DECODE (a.currency_cd,
                                             giacp.n ('CURRENCY_CD'), 1,
                                             c.currency_cd, 1,
                                             NVL (c.orig_curr_rate,
                                                  c.convert_rate
                                                 )
                                            )
                                  )
                             ) b_tax_amt,
                           
/*czie, 03/30/2009, commented out and copied code from giclr031, sum(b.tax_amt * c.convert_rate * -1) b_tax_amt,*/
                           d.batch_dv_id
                      FROM gicl_clm_loss_exp a,
                           gicl_loss_exp_tax b,
                           gicl_advice c,
                           giac_batch_dv d
                     WHERE a.claim_id = b.claim_id
                       AND a.clm_loss_id = b.clm_loss_id
                       AND a.claim_id = c.claim_id
                       AND a.advice_id = c.advice_id
                       AND b.tax_type = 'I'
                       AND b.adv_tag = 'Y'
                       AND c.batch_dv_id = d.batch_dv_id
                  GROUP BY d.batch_dv_id)
           WHERE batch_dv_id = p_batch_dv_id)
      LOOP
         v_tax.tax_input := NVL (i.b_tax_amt, 0);
         PIPE ROW (v_tax);
      END LOOP;
/*
      v_tax.tax_input := 200000;
      PIPE ROW (v_tax);
      v_tax.tax_input := 200000;
      PIPE ROW (v_tax);*/
   END;

   FUNCTION get_total_dist_liab (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN gicl_loss_exp_dtl.dtl_amt%TYPE
   IS
      v_net_ret   gicl_loss_exp_dtl.dtl_amt%TYPE;
      v_facul     gicl_loss_exp_dtl.dtl_amt%TYPE;
      v_treaty    gicl_loss_exp_dtl.dtl_amt%TYPE;
   BEGIN
      v_net_ret := 0;
      v_facul := 0;
      v_treaty := 0;

      FOR i IN (SELECT   b.batch_dv_id,
                         SUM (DECODE (a.grp_seq_no,
                                      1, DECODE (d.currency_cd,
                                                 c.currency_cd, a.shr_le_adv_amt,
                                                   a.shr_le_adv_amt
                                                 * c.orig_curr_rate
                                                ),
                                      0.00
                                     )
                             ) net_ret,
                         SUM (DECODE (a.grp_seq_no,
                                      999, DECODE (d.currency_cd,
                                                   c.currency_cd, a.shr_le_adv_amt,
                                                     a.shr_le_adv_amt
                                                   * c.orig_curr_rate
                                                  ),
                                      0.00
                                     )
                             ) facul,
                         SUM (DECODE (a.grp_seq_no,
                                      1, 0.00,
                                      999, 0.00,
                                      DECODE (d.currency_cd,
                                              c.currency_cd, a.shr_le_adv_amt,
                                                a.shr_le_adv_amt
                                              * c.orig_curr_rate
                                             )
                                     )
                             ) treaty
                    FROM gicl_loss_exp_ds a,
                         giac_batch_dv b,
                         gicl_advice c,
                         gicl_clm_loss_exp d
                   WHERE (a.negate_tag = 'N' OR a.negate_tag IS NULL)
                     AND a.claim_id = c.claim_id
                     AND a.claim_id = d.claim_id
                     AND a.clm_loss_id = d.clm_loss_id
                     AND b.batch_dv_id = c.batch_dv_id
                     AND b.batch_dv_id = p_batch_dv_id
                     AND c.advice_id = d.advice_id
                GROUP BY b.batch_dv_id)
      LOOP
         v_net_ret := NVL (i.net_ret, 0);
         v_facul := NVL (i.facul, 0);
         v_treaty := NVL (i.treaty, 0);
      END LOOP;

      RETURN (v_net_ret + v_facul + v_treaty);
   END;

   FUNCTION get_distribution (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN distribution_tab PIPELINED
   IS
      v_dist   distribution_type;
   BEGIN
      v_dist.net_ret := 0;
      v_dist.facul := 0;
      v_dist.treaty := 0;

      FOR i IN (SELECT   b.batch_dv_id,
                         SUM (DECODE (a.grp_seq_no,
                                      1, DECODE (d.currency_cd,
                                                 c.currency_cd, a.shr_le_adv_amt,
                                                   a.shr_le_adv_amt
                                                 * c.orig_curr_rate
                                                ),
                                      0.00
                                     )
                             ) net_ret,
                         SUM (DECODE (a.grp_seq_no,
                                      999, DECODE (d.currency_cd,
                                                   c.currency_cd, a.shr_le_adv_amt,
                                                     a.shr_le_adv_amt
                                                   * c.orig_curr_rate
                                                  ),
                                      0.00
                                     )
                             ) facul,
                         SUM (DECODE (a.grp_seq_no,
                                      1, 0.00,
                                      999, 0.00,
                                      DECODE (d.currency_cd,
                                              c.currency_cd, a.shr_le_adv_amt,
                                                a.shr_le_adv_amt
                                              * c.orig_curr_rate
                                             )
                                     )
                             ) treaty
                    FROM gicl_loss_exp_ds a,
                         giac_batch_dv b,
                         gicl_advice c,
                         gicl_clm_loss_exp d
                   WHERE (a.negate_tag = 'N' OR a.negate_tag IS NULL)
                     AND a.claim_id = c.claim_id
                     AND a.claim_id = d.claim_id
                     AND a.clm_loss_id = d.clm_loss_id
                     AND b.batch_dv_id = c.batch_dv_id
                     AND b.batch_dv_id = p_batch_dv_id
                     AND c.advice_id = d.advice_id
                GROUP BY b.batch_dv_id)
      LOOP
         v_dist.net_ret := NVL (i.net_ret, 0);
         v_dist.facul := NVL (i.facul, 0);
         v_dist.treaty := NVL (i.treaty, 0);
         v_dist.total := v_dist.net_ret + v_dist.facul + v_dist.treaty;
         PIPE ROW (v_dist);
      END LOOP;
   END;

   FUNCTION get_payee_information (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE
   )
      RETURN payee_info_tab PIPELINED
   IS
      v_payee   payee_info_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.class_desc, a.payee_last_name,
                                c.doc_number, c.doc_type, c.bill_date,
                                
                                --Added by Marlo 06242010
                                c.claim_id, c.payee_cd, c.payee_class_cd,
                                c.claim_loss_id, d.batch_dv_id
                           FROM giis_payees a,
                                giis_payee_class b,
                                gicl_loss_exp_bill c,
                                giac_batch_dv_dtl d
                          WHERE a.payee_class_cd = c.payee_class_cd
                            AND b.payee_class_cd = a.payee_class_cd
                            AND a.payee_no = c.payee_cd
                            AND c.claim_id = d.claim_id
                            AND c.claim_loss_id = d.clm_loss_id
                            AND batch_dv_id = p_batch_dv_id)
      LOOP
         v_payee.class_desc := i.class_desc;
         v_payee.payee_last_name := i.payee_last_name;
         v_payee.doc_number := i.doc_number;
         v_payee.bill_date := i.bill_date;

         FOR rec IN (SELECT rv_meaning
                       FROM cg_ref_codes
                      WHERE rv_domain = 'GICL_LOSS_EXP_BILL.DOC_TYPE'
                        AND rv_low_value = i.doc_type)
         LOOP
            v_payee.title := rec.rv_meaning;
         END LOOP;

         PIPE ROW (v_payee);
      END LOOP;
   END;

   FUNCTION get_perils (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE,
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_advice_id     gicl_advice.advice_id%TYPE,
      p_line_cd       gicl_claims.line_cd%TYPE
   )
      RETURN perils_tab PIPELINED
   IS
      v_perils   perils_type;
   BEGIN
      FOR i IN (SELECT   a.claim_id, a.advice_id, a.peril_cd,
                         a.payee_class_cd, a.payee_cd,
                           SUM (a.paid_amt)
                         * DECODE (a.currency_cd,
                                   giacp.n ('CURRENCY_CD'), 1,
                                   b.currency_cd, 1,
                                   NVL (b.orig_curr_rate, b.convert_rate)
                                  ) peril_paid_amt
                    FROM gicl_clm_loss_exp a, gicl_advice b
                   WHERE a.claim_id = b.claim_id
                     AND a.advice_id = b.advice_id
                     AND a.claim_id = p_claim_id
                     AND a.advice_id = p_advice_id
                GROUP BY a.claim_id,
                         a.advice_id,
                         a.peril_cd,
                         a.payee_class_cd,
                         a.payee_cd,
                         a.currency_cd,
                         b.currency_cd,
                         b.orig_curr_rate,
                         b.convert_rate)
      LOOP
         v_perils.peril_paid_amt := i.peril_paid_amt;

         FOR p IN (SELECT peril_sname
                     FROM giis_peril
                    WHERE line_cd = p_line_cd AND peril_cd = i.peril_cd)
         LOOP
            v_perils.peril_name := p.peril_sname;
         END LOOP;

         PIPE ROW (v_perils);
      END LOOP;
   END;

   FUNCTION get_policies_and_perils (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE
    
   )
      RETURN policy_list_tab PIPELINED
   IS
      v_pol          policy_list_type;
      v_print_name   VARCHAR2 (1);
   BEGIN
      FOR i IN
         (SELECT    a.line_cd
                 || '-'
                 || a.subline_cd
                 || '-'
                 || a.pol_iss_cd
                 || '-'
                 || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                 || '-'
                 || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                 || '-'
                 || LPAD (TO_CHAR (a.renew_no), 2, '0') POLICY,
                 a.assured_name, a.dsp_loss_date, a.line_cd,
                    a.line_cd
                 || '-'
                 || a.subline_cd
                 || '-'
                 || a.iss_cd
                 || '-'
                 || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                 || '-'
                 || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim,
                 b.payee_class_cd, b.payee_cd,
                    b.fund_cd
                 || '-'
                 || b.branch_cd
                 || '-'
                 || b.batch_year
                 || '-'
                 || b.batch_mm
                 || '-'
                 || b.batch_seq_no batch_no,
                 DECODE
                    (d.currency_cd,
                     c.currency_cd, d.advise_amt,
                     (  d.advise_amt
                      * c.orig_curr_rate  /*d.currency_rate /*c.convert_rate*/
                     )
                    ) advise_amt,               -- Modified by Marlo 07132010
                 DECODE
                    (d.currency_cd,
                     c.currency_cd, d.net_amt,
                     (  d.net_amt
                      * c.orig_curr_rate  /*d.currency_rate /*c.convert_rate*/
                     )
                    ) net_amt,                  -- Modified by Marlo 07132010
                 DECODE
                    (d.currency_cd,
                     c.currency_cd, d.paid_amt,
                     (  d.paid_amt
                      * c.orig_curr_rate  /*d.currency_rate /*c.convert_rate*/
                     )
                    ) paid_amt,                 -- Modified by Marlo 07132010
                 b.batch_dv_id, c.convert_rate, a.claim_id, c.advice_id,
                 d.clm_loss_id,
                 DECODE (d.clm_clmnt_no,
                         NULL, 0,
                         d.clm_clmnt_no
                        ) clm_clmnt_no,
                 b.tran_id
            FROM gicl_claims a,
                 giac_batch_dv b,
                 gicl_advice c,
                 gicl_clm_loss_exp d
           WHERE a.claim_id = c.claim_id
             AND a.claim_id = d.claim_id
             AND b.batch_dv_id = c.batch_dv_id
             AND b.batch_dv_id = p_batch_dv_id
             AND c.advice_id = d.advice_id)
      LOOP
         v_pol.policy_no := i.POLICY;
         v_pol.claim_no := i.claim;
         v_pol.assured_name := i.assured_name;
         v_pol.dsp_loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY');
         v_pol.paid_amt := i.paid_amt;
         v_pol.intm := NULL;
         v_pol.peril := NULL;

         FOR p IN (SELECT c.peril_sname
                     FROM giis_peril c,
                          gicl_item_peril a,
                          gicl_clm_loss_exp b
                    WHERE c.peril_cd = a.peril_cd
                      AND a.claim_id = b.claim_id
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND c.line_cd = i.line_cd
                      AND b.claim_id = i.claim_id
                      AND b.advice_id = i.advice_id
                      AND b.clm_loss_id = i.clm_loss_id)
         LOOP
            IF v_pol.peril IS NULL
            THEN
               v_pol.peril := p.peril_sname;
            ELSIF v_pol.peril IS NOT NULL
            THEN
               v_pol.peril := v_pol.peril || '/' || p.peril_sname;
            END IF;
         END LOOP;

         BEGIN
            SELECT param_value_v
              INTO v_print_name
              FROM giac_parameters
             WHERE param_name = 'PRINT_INTM_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_print_name := 'N';
         END;

         IF v_print_name = 'N'
         THEN
            FOR intm IN (SELECT DISTINCT    TO_CHAR (c.intm_no)
                                         || '/'
                                         || NVL (c.ref_intm_cd, ' ') intm
                                    FROM gicl_claims a,
                                         gicl_intm_itmperil b,
                                         giis_intermediary c
                                   WHERE a.claim_id = b.claim_id
                                     AND b.intm_no = c.intm_no
                                     AND a.claim_id = i.claim_id)
            LOOP
               IF v_pol.intm IS NULL
               THEN
                  v_pol.intm := intm.intm;
               ELSIF v_pol.intm IS NOT NULL
               THEN
                  v_pol.intm := v_pol.intm || CHR (10) || intm.intm;
               END IF;
            END LOOP;
         ELSE
            FOR intm IN (SELECT DISTINCT    TO_CHAR (c.intm_no)
                                         || '/'
                                         || NVL (c.ref_intm_cd, ' ')
                                         || '/'
                                         || c.intm_name intm
                                    FROM gicl_claims a,
                                         gicl_intm_itmperil b,
                                         giis_intermediary c
                                   WHERE a.claim_id = b.claim_id
                                     AND b.intm_no = c.intm_no
                                     AND a.claim_id = i.claim_id)
            LOOP
               IF v_pol.intm IS NULL
               THEN
                  v_pol.intm := intm.intm;
               ELSIF v_pol.intm IS NOT NULL
               THEN
                  v_pol.intm := v_pol.intm || CHR (10) || intm.intm;
               END IF;
            END LOOP;
         END IF;

         PIPE ROW (v_pol);
      END LOOP;
   END;

   FUNCTION get_request_no (p_tran_id giac_payt_requests_dtl.tran_id%TYPE)
      RETURN VARCHAR2
   IS
      v_request_no   VARCHAR2 (50);
   BEGIN
      FOR r IN (SELECT    document_cd
                       || '-'
                       || branch_cd
                       || '-'
                       || TO_CHAR (doc_year)
                       || '-'
                       || TO_CHAR (doc_mm)
                       || '-'
                       || LPAD (TO_CHAR (doc_seq_no), 6, '0') request_no
                  FROM giac_payt_requests a, giac_payt_requests_dtl b
                 WHERE a.ref_id = b.gprq_ref_id AND b.tran_id = p_tran_id)
      LOOP
         v_request_no := r.request_no;
      END LOOP;

      RETURN v_request_no;
   END;
   
   /*
    **  Created by     : Veronica V. Raymundo
    **  Date Created   : 12.04.2012
    **  Reference By   : GIACS086C - Batch Special CSR
    **  Description    : Retrieve list of report signatories for GIACS086
    */
   
   FUNCTION get_report_signatory (p_report_id     GIAC_DOCUMENTS.report_id%TYPE,    
                                     p_line_cd      GIIS_LINE.line_cd%TYPE,
                                    p_branch_cd    GICL_CLAIMS.iss_cd%TYPE,
                                  p_user         GIIS_USERS.user_id%TYPE)
      RETURN signatory_tab PIPELINED
   IS
      rep            signatory_type;
      v_line_cd      GIIS_LINE.line_cd%TYPE;
      v_branch_cd    GICL_CLAIMS.iss_cd%TYPE;
                                  
   BEGIN
    FOR get_line_iss IN (SELECT 1
                           FROM giac_documents a, giac_rep_signatory b
                          WHERE a.report_no = b.report_no
                            AND a.report_id = b.report_id
                            AND a.report_id = p_report_id
--                            AND a.branch_cd = p_branch_cd
--                            AND a.line_cd   = p_line_cd)
                            AND NVL(a.branch_cd, p_branch_cd) = p_branch_cd
                            AND NVL(a.line_cd, p_line_cd) = p_line_cd) --modified by gab 10.18.2016 SR 5711
    LOOP
       v_line_cd     := p_line_cd;
       v_branch_cd  := p_branch_cd;    
       EXIT;
    END LOOP;
    
      FOR i IN (SELECT a.report_no, 
                       b.item_no, 
                       b.LABEL, 
                       c.signatory, 
                       c.designation
                  FROM giac_documents a, 
                       giac_rep_signatory b, 
                       giis_signatory_names c 
                 WHERE a.report_no = b.report_no 
                   AND a.report_id = b.report_id 
                   AND a.report_id = p_report_id 
--                   AND NVL(a.line_cd, '@')= NVL(v_line_cd,'@') 
--                   AND NVL(a.branch_cd,  '@') = NVL(v_branch_cd,'@')
                   AND NVL(a.line_cd, v_line_cd)= v_line_cd
                   AND NVL(a.branch_cd,  v_branch_cd) = v_branch_cd --modified by gab 10.18.2016 SR 5711
                   AND b.signatory_id = c.signatory_id     
                UNION
                SELECT  1 rep_no, 
                        1 item_no,
                        'PREPARED BY :' lbel, user_name, ' ' designation
                  FROM giis_users
                 WHERE user_id = p_user
                ORDER BY 2)
      LOOP
         rep.label := i.label;
         rep.signatory := i.signatory;
         rep.designation := i.designation;
         PIPE ROW (rep);
      END LOOP;
   END;
END;
/


