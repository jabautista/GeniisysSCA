CREATE OR REPLACE PACKAGE BODY CPI.GICLR031_PKG
IS
   /* 
   ** Created By: Belle Bebing
   ** Date Created: 03.23.2012
   ** Reference By: GICLR031
   ** Description: Preliminary Claim Settlement Request
   */
   FUNCTION populate_giclr031 (p_claim_id     GICL_CLAIMS.claim_id%TYPE,
                               p_advice_id    GICL_ADVICE.advice_id%TYPE)
      RETURN giclr031_tab
      PIPELINED
   IS
      rep   giclr031_type;
   BEGIN
      FOR i
         IN (  SELECT A.assd_name2,
                      A.assd_no,
                      A.acct_of_cd,
                      A.line_cd,
                      A.iss_cd,
                         A.line_cd
                      || '-'
                      || A.subline_cd
                      || '-'
                      || A.pol_iss_cd
                      || '-'
                      || LPAD (TO_CHAR (A.issue_yy), 2, '0')
                      || '-'
                      || LPAD (TO_CHAR (A.pol_seq_no), 7, '0')
                      || '-'
                      || LPAD (TO_CHAR (A.renew_no), 2, '0')
                         POLICY,
                      A.assured_name,
                      TO_CHAR (A.dsp_loss_date, 'fmMonth dd, yyyy')
                         dsp_loss_date,
                         A.line_cd
                      || '-'
                      || A.subline_cd
                      || '-'
                      || A.iss_cd
                      || '-'
                      || LPAD (TO_CHAR (A.clm_yy), 2, '0')
                      || '-'
                      || LPAD (TO_CHAR (A.clm_seq_no), 7, '0')
                         claims,
                      DECODE (
                         d.payee_first_name,
                         NULL, d.payee_last_name,
                            d.payee_first_name
                         || ' '
                         || d.payee_middle_name
                         || ' '
                         || d.payee_last_name)
                         NAME,
                      c.claim_id,
                      c.advice_id,
                         b.line_cd
                      || '-'
                      || b.iss_cd
                      || '-'
                      || b.advice_year
                      || '-'
                      || LPAD (TO_CHAR (b.advice_seq_no), 6, '0')
                         advice,
                      c.payee_class_cd,
                      c.payee_cd,
                      NVL (c.final_tag, 'N') final_tag,
                      c.ex_gratia_sw,
                      E.line_cd line_cd2,
                      SUM (
                           DECODE (c.payee_type, 'L', c.net_amt, 0.00)
                         * DECODE (c.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   b.currency_cd, 1,
                                   (NVL (b.orig_curr_rate, b.convert_rate)))) --belle 12.03.2012
                                   --(NVL (b.convert_rate, b.orig_curr_rate))))--steven 01.09.2013 binalik ko siya sa dati, base on SR 0011441 and ung nakalagay sa RDF una talaga ung 'orig_curr_rate' dun.
                         loss_amt,
                      SUM (
                           DECODE (c.payee_type, 'E', c.net_amt, 0.00)
                         * DECODE (c.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   b.currency_cd, 1,
                                   (NVL (b.orig_curr_rate, b.convert_rate)))) --belle 12.03.2012
                                   --(NVL (b.convert_rate, b.orig_curr_rate))))--steven 01.09.2013 binalik ko siya sa dati, base on SR 0011441 and ung nakalagay sa RDF una talaga ung 'orig_curr_rate' dun.
                         exp_amt,
                      SUM (
                           c.advise_amt
                         * DECODE (c.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   b.currency_cd, 1,
                                   b.currency_cd, 1,
                                   (NVL (b.orig_curr_rate, b.convert_rate)))) --belle 12.03.2012
                                   --(NVL (b.convert_rate, b.orig_curr_rate))))--steven 01.09.2013 binalik ko siya sa dati, base on SR 0011441 and ung nakalagay sa RDF una talaga ung 'orig_curr_rate' dun.
                         advise_amt,
                      SUM (
                           c.net_amt
                         * DECODE (c.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   b.currency_cd, 1,
                                   b.currency_cd, 1,
                                   (NVL (b.orig_curr_rate, b.convert_rate)))) --belle 12.03.2012
                                   --(NVL (b.convert_rate, b.orig_curr_rate))))--steven 01.09.2013 binalik ko siya sa dati, base on SR 0011441 and ung nakalagay sa RDF una talaga ung 'orig_curr_rate' dun.
                         net_amt,
                      SUM (
                           c.paid_amt
                         * DECODE (c.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   b.currency_cd, 1,
                                   b.currency_cd, 1,
                                   (NVL (b.orig_curr_rate, b.convert_rate)))) --belle 12.03.2012
                                   --(NVL (b.convert_rate, b.orig_curr_rate))))--steven 01.09.2013 binalik ko siya sa dati, base on SR 0011441 and ung nakalagay sa RDF una talaga ung 'orig_curr_rate' dun.
                         paid_amt,
                      SUM (
                           E.net_ret
                         * DECODE (c.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   b.currency_cd, 1,
                                   (NVL (b.orig_curr_rate, b.convert_rate)))) --belle 12.03.2012
                                   --(NVL (b.convert_rate, b.orig_curr_rate))))--steven 01.09.2013 binalik ko siya sa dati, base on SR 0011441 and ung nakalagay sa RDF una talaga ung 'orig_curr_rate' dun.
                         net_ret,
                      SUM (
                           E.facul
                         * DECODE (c.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   b.currency_cd, 1,
                                   (NVL (b.orig_curr_rate, b.convert_rate)))) --belle 12.03.2012
                                   --(NVL (b.convert_rate, b.orig_curr_rate))))--steven 01.09.2013 binalik ko siya sa dati, base on SR 0011441 and ung nakalagay sa RDF una talaga ung 'orig_curr_rate' dun.
                         facul,
                      SUM (
                           E.treaty
                         * DECODE (c.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   b.currency_cd, 1,
                                   (NVL (b.orig_curr_rate, b.convert_rate)))) --belle 12.03.2012
                                   --(NVL (b.convert_rate, b.orig_curr_rate))))--steven 01.09.2013 binalik ko siya sa dati, base on SR 0011441 and ung nakalagay sa RDF una talaga ung 'orig_curr_rate' dun.
                         treaty,
                      DECODE (b.remarks, NULL, b.remarks, '***' || b.remarks)
                         remarks,
                      b.currency_cd,
                      b.convert_rate
                 FROM gicl_claims A,
                      gicl_advice b,
                      gicl_clm_loss_exp c,
                      giis_payees d,
                      (  SELECT A.claim_id,
                                A.clm_loss_id,
                                A.line_cd,
                                SUM (
                                   DECODE (A.grp_seq_no,
                                           1, A.shr_le_adv_amt,
                                           0.00))
                                   net_ret,
                                SUM (
                                   DECODE (A.grp_seq_no,
                                           999, A.shr_le_adv_amt,
                                           0.00))
                                   facul,
                                SUM (
                                   DECODE (A.grp_seq_no,
                                           1, 0.00,
                                           999, 0.00,
                                           A.shr_le_adv_amt))
                                   treaty
                           FROM gicl_loss_exp_ds A
                          WHERE (A.negate_tag = 'N' OR A.negate_tag IS NULL)
                       GROUP BY A.claim_id, A.clm_loss_id, A.line_cd) E
                WHERE     A.claim_id = b.claim_id
                      AND b.claim_id = c.claim_id
                      AND b.advice_id = c.advice_id
                      AND c.payee_class_cd = d.payee_class_cd
                      AND c.payee_cd = d.payee_no
                      AND c.claim_id = E.claim_id
                      AND c.clm_loss_id = E.clm_loss_id
                      AND c.claim_id = p_claim_id
                      AND c.advice_id = p_advice_id
             GROUP BY A.assd_name2,
                      A.assd_no,
                      A.acct_of_cd,
                         A.line_cd
                      || '-'
                      || A.subline_cd
                      || '-'
                      || A.pol_iss_cd
                      || '-'
                      || LPAD (TO_CHAR (A.issue_yy), 2, '0')
                      || '-'
                      || LPAD (TO_CHAR (A.pol_seq_no), 7, '0')
                      || '-'
                      || LPAD (TO_CHAR (A.renew_no), 2, '0'),
                      A.assured_name,
                      A.dsp_loss_date,
                         A.line_cd
                      || '-'
                      || A.subline_cd
                      || '-'
                      || A.iss_cd
                      || '-'
                      || LPAD (TO_CHAR (A.clm_yy), 2, '0')
                      || '-'
                      || LPAD (TO_CHAR (A.clm_seq_no), 7, '0'),
                      DECODE (
                         d.payee_first_name,
                         NULL, d.payee_last_name,
                            d.payee_first_name
                         || ' '
                         || d.payee_middle_name
                         || ' '
                         || d.payee_last_name),
                      c.claim_id,
                      c.advice_id,
                         b.line_cd
                      || '-'
                      || b.iss_cd
                      || '-'
                      || b.advice_year
                      || '-'
                      || LPAD (TO_CHAR (b.advice_seq_no), 6, '0'),
                      c.payee_class_cd,
                      c.payee_cd,
                      NVL (c.final_tag, 'N'),
                      c.ex_gratia_sw,
                      E.line_cd,
                      b.convert_rate,
                      A.line_cd,
                      A.iss_cd,
                      DECODE (b.remarks, NULL, b.remarks, '***' || b.remarks),
                      b.currency_cd)
      LOOP
         rep.claim_id := i.claim_id;
         rep.advice_id := i.advice_id;
         rep.policy_no := i.POLICY;
         rep.claim_no := i.claims;
         rep.advice_no := i.advice;
         rep.assd_no := i.assd_no;
         rep.assured_name := i.assured_name;
         rep.assd_name2 := i.assd_name2;
         rep.NAME := i.NAME;
         rep.payee_class_cd := i.payee_class_cd;
         rep.payee_cd := i.payee_cd;
         rep.acct_of_cd := i.acct_of_cd;
         rep.line_cd := i.line_cd;
         rep.iss_cd := i.iss_cd;
         rep.dsp_loss_date := i.dsp_loss_date;
         rep.currency_cd := i.currency_cd;
         rep.convert_rate := i.convert_rate;
         rep.final_tag := i.final_tag;
         rep.ex_gratia_sw := i.ex_gratia_sw;
         rep.loss_amt := i.loss_amt;
         rep.exp_amt := i.exp_amt;
         rep.advise_amt := i.advise_amt;
         rep.net_amt := i.net_amt;
         rep.paid_amt := i.paid_amt;
         rep.net_ret := i.net_ret;
         rep.facul := i.facul;
         rep.treaty := i.treaty;
         rep.remarks := i.remarks;
         rep.cf_v_sp :=
            giclr031_pkg.cf_v_spformula (i.claim_id,
                                         i.advice_id,
                                         i.NAME,
                                         i.ex_gratia_sw,
                                         i.currency_cd,
                                         i.paid_amt,
                                         i.final_tag,
                                         i.payee_class_cd,
                                         i.payee_cd);
         rep.term := giclr031_pkg.cf_termformula (i.claim_id);
         rep.intm := giclr031_pkg.cf_intmformula (i.claim_id);
         rep.loss_ctgry :=
            giclr031_pkg.cf_loss_ctgryFormula (i.claim_id, i.advice_id);
         rep.tax_input :=
            giclr031_pkg.get_tax_input (i.claim_id,
                                        i.advice_id,
                                        i.payee_class_cd,
                                        i.payee_cd);
         rep.tax_others :=
            giclr031_pkg.get_tax_others (i.claim_id,
                                         i.advice_id,
                                         i.payee_class_cd,
                                         i.payee_cd);
         rep.tax_in_adv :=
            giclr031_pkg.get_tax_in_adv (i.claim_id,
                                         i.advice_id,
                                         i.payee_class_cd,
                                         i.payee_cd);
         rep.tax_oth_adv :=
            giclr031_pkg.get_tax_oth_adv (i.claim_id,
                                          i.advice_id,
                                          i.payee_class_cd,
                                          i.payee_cd);
         rep.cf_final :=
            giclr031_pkg.CF_finalFormula (i.claim_id,
                                          i.advice_id,
                                          i.NAME,
                                          i.ex_gratia_sw,
                                          i.final_tag);
         rep.show_dist := giclr031_pkg.show_dist (i.line_cd);
         rep.show_peril := giclr031_pkg.show_peril (i.line_cd);
         rep.signatory_sw := giacp.v ('CSR_PREPARED_BY'); -- andrew - 04.18.2012

         SELECT short_name
           INTO rep.cf_curr
           FROM giis_currency
          WHERE main_currency_cd = i.currency_cd;

         SELECT param_value_v
           INTO rep.title
           FROM giac_parameters
          WHERE param_name = 'PREM_CSR_TITLE';

         SELECT param_value_v
           INTO rep.attention
           FROM giis_parameters
          WHERE param_name = 'PRELIM_CSR_ATTN';

         FOR assd IN (SELECT assd_name || ' ' || assd_name2 assured
                        FROM giis_assured
                       WHERE assd_no = i.acct_of_cd)
         LOOP
            rep.acct_of := assd.assured;
            EXIT;
         END LOOP;

         BEGIN
            SELECT NVL (giisp.v ('VAT_TITLE'), 'Input VAT')
              INTO rep.vat_label
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rep.vat_label := 'Input VAT';
         END;

		 rep.sum_loss := NVL(rep.net_amt,0) + NVL(rep.tax_input,0) + NVL(rep.tax_others,0);
         PIPE ROW (rep);
      END LOOP;
   END;

   FUNCTION CF_v_spFormula (
      p_claim_id          GICL_CLAIMS.claim_id%TYPE,
      p_advice_id         GICL_ADVICE.advice_id%TYPE,
      p_name              VARCHAR2,
      p_ex_gratia_sw      GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,
      p_currency_cd       GICL_CLM_LOSS_EXP.currency_cd%TYPE,
      p_paid_amt          GICL_CLM_LOSS_EXP.paid_amt%TYPE,
      p_final_tag         GICL_CLM_LOSS_EXP.final_tag%TYPE,
      p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
      p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE)
      RETURN VARCHAR2
   IS
      currency          VARCHAR2 (100) := NULL;
      var_v_sp          VARCHAR2 (2000);
      var_instr         NUMBER;
      var_lgt_payt      NUMBER;
      var_paid_amt1     NUMBER;
      var_paid_amt1t    NUMBER := 0;
      var_paid_amt1m    NUMBER := 0;
      var_paid_amt1b    NUMBER := 0;
      var_paid_amt2     NUMBER := 0;
      var_spaid_amt1    VARCHAR2 (200);
      var_spaid_amt1t   VARCHAR2 (200);
      var_spaid_amt1m   VARCHAR2 (200);
      var_spaid_amt1b   VARCHAR2 (200);
      var_spaid_amt2    VARCHAR2 (200);
      var_length        NUMBER := 0;
      var_length1       NUMBER := 0;
      var_length2       NUMBER := 0;
      var_amt           NUMBER := 0;
      var_currency      VARCHAR2 (20);
      var_currency_sn   VARCHAR2 (3);
      v_final           VARCHAR2 (50);
      v_param_value_v   giis_parameters.param_value_v%TYPE;
      v_hist_seq_no     gicl_clm_loss_exp.hist_seq_no%TYPE;
      v_remarks         gicl_clm_loss_exp.remarks%TYPE;
      v_payee_type      VARCHAR2 (20);
      v_ctr             NUMBER (5) := 0;
   BEGIN
      v_param_value_v := giisp.v ('PRELIM_CSR_BEGINNING_TEXT');

      IF v_param_value_v IS NOT NULL
      THEN
         RETURN (v_param_value_v);
      ELSE
         FOR i
            IN (SELECT DISTINCT (payee_type) payee_type
                  FROM gicl_clm_loss_exp A
                 WHERE     NVL (dist_sw, 'N') = 'Y'
                       AND claim_id = p_claim_id
                       AND advice_id = p_advice_id
                       /* comment out by MAC 11/22/2013
                       AND payee_class_cd IN
                              (SELECT payee_class_cd
                                 FROM giis_payees
                                WHERE DECODE (
                                         payee_first_name,
                                         NULL, payee_last_name,
                                            payee_first_name
                                         || ' '
                                         || payee_middle_name
                                         || ' '
                                         || payee_last_name) = p_name))*/
                       --used payee_class_cd and payee_cd in retrieving distinct payee type by MAC 11/22/2013
                       AND EXISTS ( SELECT 1
                                    FROM giis_payees b
                                   WHERE DECODE (payee_first_name,
                                                 NULL, payee_last_name,
                                                    payee_first_name
                                                 || ' '
                                                 || payee_middle_name
                                                 || ' '
                                                 || payee_last_name
                                                ) = p_name
                                     AND A.payee_class_cd = b.payee_class_cd
                                     AND A.payee_cd = b.payee_no)
                       AND A.payee_class_cd = p_payee_class_cd
                       AND A.payee_cd = p_payee_cd)
         LOOP
            IF v_ctr = 0 AND i.payee_type = 'L'
            THEN                                  --this is for payee type 'L'
               v_ctr := 1;
               v_payee_type := ' loss ';
            ELSIF v_ctr = 0 AND i.payee_type = 'E'
            THEN                                  --this is for payee type 'E'
               v_ctr := 1;
               v_payee_type := ' expense ';
            ELSIF v_ctr = 1
            THEN                          --this is for more than 1 payee type
               v_payee_type := ' loss/expense ';
            END IF;
         END LOOP;

         IF p_ex_gratia_sw = 'Y'
         THEN
            v_final := ' as Ex Gratia settlement of the' || v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011
         ELSIF (p_ex_gratia_sw = 'N' OR p_ex_gratia_sw IS NULL)
         THEN
            IF (p_final_tag = 'N' OR p_final_tag IS NULL)
            THEN
               v_final := ' as partial settlement of the' || v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011
            ELSIF p_final_tag = 'Y'
            THEN
               v_final :=
                  'as full and final settlement of the' || v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011
            END IF;
         END IF;

         SELECT currency_desc, short_name
           INTO var_currency, var_currency_sn
           FROM giis_currency
          WHERE main_currency_cd = p_currency_cd;

         SELECT INSTR (TO_CHAR (p_paid_amt), '.', 1) INTO var_instr FROM DUAL;

         var_length := LENGTH (TO_CHAR (p_paid_amt * 100));

         IF var_instr = 0
         THEN
            var_paid_amt1 := p_paid_amt;
         ELSE
            SELECT SUBSTR (TO_CHAR (p_paid_amt), 1, var_instr - 1)
              INTO var_paid_amt1
              FROM DUAL;

            SELECT SUBSTR (TO_CHAR (p_paid_amt),
                           var_instr + 1,
                           LENGTH (TO_CHAR (p_paid_amt)))
              INTO var_paid_amt2
              FROM DUAL;
         END IF;

         SELECT LENGTH (TO_CHAR (var_paid_amt1)) INTO var_lgt_payt FROM DUAL;

         IF var_lgt_payt <= 6
         THEN
            var_paid_amt1t := var_paid_amt1;
            var_length1 := LENGTH (TO_CHAR (var_paid_amt1t));
         ELSIF var_lgt_payt IN (9, 8, 7)
         THEN
            SELECT SUBSTR (TO_CHAR (var_paid_amt1),
                           var_lgt_payt - 5,
                           var_lgt_payt)
              INTO var_paid_amt1t
              FROM DUAL;

            var_length1 := LENGTH (TO_CHAR (var_paid_amt1t));
            var_paid_amt1m := var_paid_amt1 - var_paid_amt1t;

            SELECT SUBSTR (TO_CHAR (var_paid_amt1),
                           0,
                           var_lgt_payt - var_length1)
              INTO var_paid_amt1m
              FROM DUAL;
         ELSIF var_lgt_payt IN (10, 11, 12)
         THEN
            SELECT SUBSTR (TO_CHAR (var_paid_amt1),
                           var_lgt_payt - 5,
                           var_lgt_payt)
              INTO var_paid_amt1t
              FROM DUAL;

            var_length1 := LENGTH (TO_CHAR (var_paid_amt1t));

            SELECT SUBSTR (TO_CHAR (var_paid_amt1), var_lgt_payt - 8, 3)
              INTO var_paid_amt1m
              FROM DUAL;

            var_length2 := LENGTH (TO_CHAR (var_paid_amt1m));
            var_paid_amt1b :=
               var_paid_amt1 - var_paid_amt1t - (var_paid_amt1m * 1000000);

            SELECT SUBSTR (TO_CHAR (var_paid_amt1),
                           0,
                           var_lgt_payt - var_length2 - var_length1)
              INTO var_paid_amt1b
              FROM DUAL;
         END IF;

         IF var_length = 2
         THEN
            var_amt := p_paid_amt * 100;
         END IF;

         BEGIN
              SELECT MAX (hist_seq_no)
                INTO v_hist_seq_no
                FROM gicl_clm_loss_exp b
               WHERE     1 = 1
                     AND b.claim_id = p_claim_id
                     AND b.advice_id = p_advice_id
                     AND b.payee_class_cd = p_payee_class_cd
                     AND b.payee_cd = p_payee_cd
            GROUP BY b.claim_id,
                     b.advice_id,
                     b.payee_class_cd,
                     b.payee_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_hist_seq_no := NULL;
         END;

         BEGIN
            SELECT payee_remarks
              INTO v_remarks
              FROM gicl_advice
             WHERE     1 = 1
                   AND claim_id = p_claim_id
                   AND advice_id = p_advice_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_remarks := NULL;
         END;

         IF v_remarks IS NOT NULL
         THEN
            var_v_sp :=
                  '       Please issue a check in favor of '
               || p_name
               || ' '
               || v_remarks
               || ' in '
               || var_currency
               || ' : '
               || dh_util.check_protect (p_paid_amt, currency, TRUE)
               || ' only ('
               || var_currency_sn
               || ' '
               || LTRIM (TO_CHAR (p_paid_amt, '999,999,999,999.00'))
               || '), '
               || v_final
               || 'under the following :';
         ELSE
            var_v_sp :=
                  '       Please issue a check in favor of '
               || p_name
               || ' in '
               || var_currency
               || ' : '
               || dh_util.check_protect (p_paid_amt, currency, TRUE)
               || ' only ('
               || var_currency_sn
               || ' '
               || LTRIM (TO_CHAR (p_paid_amt, '999,999,999,999.00'))
               || '), '
               || v_final
               || 'under the following :';
         END IF;

         RETURN (var_v_sp);
      END IF;
   END;

   FUNCTION CF_termFormula (p_claim_id GICL_CLAIMS.claim_id%TYPE)
      RETURN VARCHAR2
   IS
      v_eff_date   VARCHAR2 (100);
      v_exp_date   VARCHAR2 (100);
      v_date       VARCHAR2 (100);
      v_message    VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT TO_CHAR (MIN (pol_eff_date), 'fmMonth dd, yyyy')
           INTO v_eff_date
           FROM gicl_claims
          WHERE claim_id = p_claim_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_message := 'Claim ID not in GICL_CLM_POLBAS';
      END;

      BEGIN
         SELECT TO_CHAR (MAX (expiry_date), 'fmMonth dd, yyyy')
           INTO v_exp_date
           FROM gicl_claims
          WHERE claim_id = p_claim_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_message := 'Claim ID not in GICL_CLM_POLBAS';
      END;

      v_date := v_eff_date || ' - ' || v_exp_date;

      RETURN (v_date);
   END;

   FUNCTION CF_intmFormula (p_claim_id GICL_CLAIMS.claim_id%TYPE)
      RETURN VARCHAR2
   IS
      v_intm         VARCHAR2 (250);
      v_print_name   giac_parameters.param_value_v%TYPE;
   BEGIN
      v_intm := NULL;

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
         FOR i
            IN (SELECT DISTINCT
                          TO_CHAR (c.intm_no)
                       || ' / '
                       || UPPER (NVL (c.ref_intm_cd, ' '))
                          INTM
                  FROM gicl_claims A,
                       gicl_intm_itmperil b,
                       giis_intermediary c
                 WHERE     A.claim_id = b.claim_id
                       AND b.intm_no = c.intm_no
                       AND A.claim_id = p_claim_id)
         LOOP
            IF v_intm IS NULL
            THEN
               v_intm := i.INTM;
            ELSIF v_intm IS NOT NULL
            THEN
               v_intm := v_intm || CHR (10) || i.INTM;
            END IF;
         END LOOP;
      ELSE
         FOR j
            IN (SELECT DISTINCT
                          TO_CHAR (c.intm_no)
                       || ' / '
                       || UPPER (NVL (c.ref_intm_cd, ' '))
                       || ' / '
                       || c.intm_name
                          INTM
                  FROM gicl_claims A,
                       gicl_intm_itmperil b,
                       giis_intermediary c
                 WHERE     A.claim_id = b.claim_id
                       AND b.intm_no = c.intm_no
                       AND A.claim_id = p_claim_id)
         LOOP
            IF v_intm IS NULL
            THEN
               v_intm := j.INTM;
            ELSIF v_intm IS NOT NULL
            THEN
               v_intm := v_intm || CHR (10) || j.INTM;
            END IF;
         END LOOP;
      END IF;

      RETURN (v_intm);
   END;

   FUNCTION CF_loss_ctgryFormula (p_claim_id     GICL_CLAIMS.claim_id%TYPE,
                                  p_advice_id    GICL_ADVICE.advice_id%TYPE)
      RETURN VARCHAR2
   IS
      v_loss_cat_des   VARCHAR2 (100);
   BEGIN
      v_loss_cat_des := NULL;

      FOR i
         IN (SELECT DISTINCT c.loss_cat_des
               FROM gicl_item_peril A, gicl_clm_loss_exp b, giis_loss_ctgry c
              WHERE     A.claim_id = b.claim_id
                    AND A.item_no = b.item_no
                    AND A.peril_cd = b.peril_cd
                    AND A.line_cd = c.line_cd
                    AND A.loss_cat_cd = c.loss_cat_cd
                    AND b.claim_id = p_claim_id
                    AND b.advice_id = p_advice_id)
      LOOP
         IF v_loss_cat_des IS NULL
         THEN
            v_loss_cat_des := i.loss_cat_des;
         ELSIF v_loss_cat_des IS NOT NULL
         THEN
            v_loss_cat_des := v_loss_cat_des || '/' || i.loss_cat_des;
         END IF;
      END LOOP;

      RETURN (v_loss_cat_des);
   END;

   FUNCTION get_clm_loss_exp_desc (
      p_claim_id          GICL_CLAIMS.claim_id%TYPE,
      p_advice_id         GICL_ADVICE.advice_id%TYPE,
      p_payee_class_cd    GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
      p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE)
      RETURN giclr031_tab
      PIPELINED
   IS
      rep   giclr031_type;
   BEGIN
      FOR i
         IN (  SELECT A.claim_id, A.payee_class_cd, A.payee_cd, b.loss_exp_cd,
               --comment out by MAGeamoga 09/22/2011
               --SUM(b.dtl_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate))) sum_b_dtl_amt,
               --modified by MAGeamoga 09/22/2011. Alter value of sum_b_dtl_amt to negative once loss_exp_cd is 'DP'.
               --replaced hard-coded 'DP' with giisp.v('MC_DEPRECIATION_CD') by MAC 04/13/2012
               --SUM( DECODE (b.loss_exp_cd, giisp.v('MC_DEPRECIATION_CD'), ABS(b.dtl_amt) * -1, --comment out by MAC 04/27/2012
               SUM( b.dtl_amt + NVL( (SELECT SUM ( 
                                     DECODE ( E.tax_type,
                                            --if tax_type is equal to W, multiply its value by -1 
                                            'W', (-1 * ( DECODE ( E.loss_exp_cd,
                                                                --if loss_exp_cd is equal to 0, get the corresponding tax amount for each loss ( (dtl_amt - NVL(ded_amt,0) * tax_pct/100 )
                                                                '0', ROUND( ( b.dtl_amt + NVL( (SELECT SUM ( ABS( f.ded_amt ) * -1 )
                                                                                         FROM GICL_LOSS_EXP_DED_DTL f
                                                                                        WHERE f.claim_id = A.claim_id
                                                                                          AND f.clm_loss_id = A.clm_loss_id
                                                                                          AND f.ded_cd = b.loss_exp_cd ), 0 ) ) * ( E.tax_pct/100 ), 2),
                                                                --if loss_exp_cd is equal to 0-NI, get the corresponding tax amount for each loss ( (dtl_amt - NVL(ded_amt,0 - input_vat) * tax_pct/100 )                                   
                                                                '0-NI', ROUND( ( ( b.dtl_amt + NVL( ( SELECT SUM ( ABS( f.ded_amt ) * -1)
                                                                                                        FROM GICL_LOSS_EXP_DED_DTL f
                                                                                                       WHERE f.claim_id = A.claim_id
                                                                                                         AND f.clm_loss_id = A.clm_loss_id
                                                                                                         AND f.ded_cd = b.loss_exp_cd), 0 ) )
                                                                                             --get input vat 
                                                                                             - NVL( ( SELECT SUM ( DECODE ( G.loss_exp_cd,
                                                                                                                           --if loss_exp_cd is equal to 0, compute for individual tax amount depending on the value of w_tax
                                                                                                                           '0', DECODE ( G.w_tax, 
                                                                                                                                       --if w_tax is equal to Y, get tax amount using this formula : ( (dtl_amt - NVL(ded_amt,0)) / (1+tax_pct/100) * tax_pct/100 )
                                                                                                                                       'Y', ROUND( ( b.dtl_amt + NVL( (SELECT SUM ( ABS(f.ded_amt ) * -1)
                                                                                                                                                                         FROM GICL_LOSS_EXP_DED_DTL f
                                                                                                                                                                        WHERE f.claim_id = A.claim_id
                                                                                                                                                                          AND f.clm_loss_id = A.clm_loss_id
                                                                                                                                                                          AND f.ded_cd = b.loss_exp_cd), 0 ) ) /(1 + G.tax_pct/100) * (G.tax_pct/100), 2), 
                                                                                                                                        --if w_tax is not equal to Y, get tax amount using this formula : ( (dtl_amt - NVL(ded_amt,0)) * tax_pct/100 )    
                                                                                                                                            ROUND( ( b.dtl_amt + NVL( (SELECT SUM ( ABS(f.ded_amt ) * -1)
                                                                                                                                                                         FROM GICL_LOSS_EXP_DED_DTL f
                                                                                                                                                                        WHERE f.claim_id = A.claim_id
                                                                                                                                                                          AND f.clm_loss_id = A.clm_loss_id
                                                                                                                                                                          AND f.ded_cd = b.loss_exp_cd), 0 ) ) * (G.tax_pct/100), 2)), 
                                                                                                                            --if loss_exp_cd is not equal to 0, compute for tax amount based on the value of base_amt
                                                                                                                            DECODE ( G.w_tax,
                                                                                                                                   --if w_tax is equal to Y, get tax amount using this formula : ( (base_amt / (1+tax_pct/100) * tax_pct/100 ) 
                                                                                                                                   'Y', ROUND( G.base_amt /(1 + G.tax_pct/100) * (G.tax_pct/100), 2), 
                                                                                                                                   --if w_tax is not equal to Y, get tax amount using this formula : ( (base_amt * tax_pct/100 ) 
                                                                                                                                   ROUND( G.base_amt * (G.tax_pct/100), 2) )                                               
                                                                                                                            ) 
                                                                                                                    ) 
                                                                                                         FROM gicl_loss_exp_tax G
                                                                                                        WHERE G.claim_id = A.claim_id
                                                                                                          AND G.clm_loss_id = A.clm_loss_id
                                                                                                          AND G.tax_type = 'I'
                                                                                                          AND DECODE(REPLACE(G.loss_exp_cd, '0-'), b.loss_exp_cd, 1, '0', 1, 0) = 1 ), 0) ) 
                                                                              * (E.tax_pct/100), 2 ),
                                                                   --if loss_exp_cd is not equal to 0 and 0-NI, get tax amount using this formula ( base-amt * tax_pct/100 )
                                                                   ROUND( E.base_amt * ( E.tax_pct/100 ), 2 ) )
                                                        )
                                                   ),
                                            --if tax_type is not equal to W
                                            DECODE ( b.w_tax, 
                                                   --if w_tax is equal to Y then return 0
                                                   'Y', 0,
                                                   --if w_tax is not equal to Y,
                                                    DECODE ( E.loss_exp_cd,
                                                           --if loss_exp_cd is equal to 0, get the corresponding tax amount for each loss ( (dtl_amt - NVL(ded_amt,0)) * tax_pct/100 )  
                                                           '0', ROUND( ( b.dtl_amt + NVL( (SELECT SUM ( ABS(f.ded_amt) * -1)
                                                                                             FROM GICL_LOSS_EXP_DED_DTL f
                                                                                            WHERE f.claim_id = A.claim_id
                                                                                              AND f.clm_loss_id = A.clm_loss_id
                                                                                              AND f.ded_cd = b.loss_exp_cd), 0 ) ) * (E.tax_pct/100), 2),
                                                            --if loss_exp_cd is not equal to 0, compute tax amount using this formula : ( base_amt * tax_pct/100 )
                                                           ROUND(E.base_amt * (E.tax_pct/100), 2)                                               
                                                           )
                                                   )    
                                            ) 
                                         )
                               FROM gicl_loss_exp_tax E
                              WHERE E.claim_id = A.claim_id
                                AND E.clm_loss_id = A.clm_loss_id
                                AND DECODE( E.loss_exp_cd, b.loss_exp_cd, 1, '0', 1, '0-NI', 1,
                                    DECODE ( b.loss_exp_cd, REPLACE(E.loss_exp_cd, '0-'), 1, REPLACE(E.loss_exp_cd, '-NI'), 1,
                                    REPLACE(E.loss_exp_cd, '-DI'), 1, 0 ) ) = 1
                              ),                
                         0 ) )
                 -- * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate)) sum_b_dtl_amt, --belle 12.03.2012
                  * DECODE(A.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.convert_rate,d.orig_curr_rate)) sum_b_dtl_amt, 
                  c.loss_exp_desc, A.advice_id,                             
                  DECODE(A.clm_clmnt_no,NULL,0,A.clm_clmnt_no) clm_clmnt_no,
                  d.convert_rate,
                  --a.currency_cd --belle 12.03.2012
                  d.currency_cd
                 FROM gicl_clm_loss_exp A, gicl_loss_exp_dtl b,
                      giis_loss_exp c, gicl_advice d
                WHERE A.claim_id = b.claim_id
                  AND A.clm_loss_id = b.clm_loss_id
                  AND A.payee_type = c.loss_exp_type
                  AND b.line_cd = c.line_cd
                  AND NVL(b.subline_cd,'XX') = NVL(c.subline_cd,'XX')
                  AND b.loss_exp_cd = c.loss_exp_cd
                  AND A.claim_id = d.claim_id
                  AND A.advice_id = d.advice_id
                  AND (b.dtl_amt > 0 OR b.dtl_amt = 0)
                --added two conditions to consider claim_id and advice_id of USER PARAMETER by MAC 04/13/2012
                   AND A.claim_id = p_claim_id
                   AND A.advice_id = p_advice_id
                   AND A.payee_class_cd = p_payee_class_cd
                   AND A.payee_cd = p_payee_cd
             GROUP BY A.claim_id,
                      A.payee_class_cd,
                      A.payee_cd,
                      b.loss_exp_cd,
                      c.loss_exp_desc,
                      A.advice_id,
                      DECODE (A.clm_clmnt_no, NULL, 0, A.clm_clmnt_no),
                      A.currency_cd,
                      d.currency_cd,
                      d.convert_rate,
                      d.orig_curr_rate
             --comment out the old value of ORDER BY by replacing with sum_b_dtl_amt by MAC 04/16/2012
             -- SUM(b.dtl_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate)))
             ORDER BY sum_b_dtl_amt)
      LOOP
         rep.claim_id := i.claim_id;
         rep.payee_class_cd := i.payee_class_cd;
         rep.payee_cd := i.payee_cd;
         rep.loss_exp_cd := i.loss_exp_cd;
         rep.sum_b_dtl_amt := i.sum_b_dtl_amt;
         rep.loss_exp_Desc := i.loss_exp_desc;
         rep.advice_id := i.advice_id;
         rep.clm_clmnt_no := i.clm_clmnt_no;
         rep.convert_rate := i.convert_rate;

         SELECT short_name
           INTO rep.cf_curr
           FROM giis_currency
          WHERE main_currency_cd = i.currency_cd;

         PIPE ROW (rep);
      END LOOP;
   END;
   
   -- bonok :: 01.04.2013
   FUNCTION get_clm_loss_exp_desc2 (  
      p_claim_id          GICL_CLAIMS.claim_id%TYPE,
      p_advice_id         GICL_ADVICE.advice_id%TYPE,
      p_payee_class_cd    GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
      p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE)
      RETURN giclr031_tab
      PIPELINED
   IS
      rep   giclr031_type;
   BEGIN
      FOR i
         IN ( SELECT A.claim_id, A.payee_class_cd, A.payee_cd,
       		  b.loss_exp_cd, 
       		  --comment out by MAGeamoga 09/22/2011
       		  --SUM(b.dtl_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate))) sum_b_dtl_amt,
       		  --modified by MAGeamoga 09/22/2011. Alter value of sum_b_dtl_amt to negative once loss_exp_cd is 'DP'.
       		  SUM( DECODE (b.loss_exp_cd, DECODE(c.line_cd,'MC',giisp.v('MC_DEPRECIATION_CD'),NULL), ABS(b.dtl_amt) * -1, b.dtl_amt) * DECODE(A.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate))) sum_b_dtl_amt,
       		  c.loss_exp_desc, A.advice_id,                             
       		  DECODE(A.clm_clmnt_no,NULL,0,A.clm_clmnt_no) clm_clmnt_no,
      		  d.convert_rate,
              d.currency_cd --change by steve 01.09.2013 from: "a.currency_cd"  to: "d.currency_cd"
                FROM gicl_clm_loss_exp A, gicl_loss_exp_dtl b,
                     giis_loss_exp c, gicl_advice d
               WHERE A.claim_id = b.claim_id
                 AND A.clm_loss_id = b.clm_loss_id
                 AND A.payee_type = c.loss_exp_type
                 AND b.line_cd = c.line_cd
                 AND NVL(b.subline_cd,'XX') = NVL(c.subline_cd,'XX')
                 AND b.loss_exp_cd = c.loss_exp_cd
                 AND A.claim_id = d.claim_id
                 AND A.advice_id = d.advice_id
                 AND (b.dtl_amt > 0 OR b.dtl_amt = 0)
               --added two conditions to consider claim_id and advice_id of USER PARAMETER by MAC 04/13/2012
                 AND A.claim_id = p_claim_id
                 AND A.advice_id = p_advice_id
                 AND A.payee_class_cd = p_payee_class_cd
                 AND A.payee_cd = p_payee_cd
            GROUP BY A.claim_id,
                     A.payee_class_cd,
                     A.payee_cd,
                     b.loss_exp_cd,
                     c.loss_exp_desc,
                     A.advice_id,
                     DECODE (A.clm_clmnt_no, NULL, 0, A.clm_clmnt_no),
                     A.currency_cd,
                     d.currency_cd,
                     d.convert_rate
             --comment out the old value of ORDER BY by replacing with sum_b_dtl_amt by MAC 04/16/2012
             -- SUM(b.dtl_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate)))
            ORDER BY sum_b_dtl_amt)
      LOOP
         rep.claim_id := i.claim_id;
         rep.payee_class_cd := i.payee_class_cd;
         rep.payee_cd := i.payee_cd;
         rep.loss_exp_cd := i.loss_exp_cd;
         rep.sum_b_dtl_amt := i.sum_b_dtl_amt;
         rep.loss_exp_Desc := i.loss_exp_desc;
         rep.advice_id := i.advice_id;
         rep.clm_clmnt_no := i.clm_clmnt_no;
         rep.convert_rate := i.convert_rate;

         SELECT short_name
           INTO rep.cf_curr
           FROM giis_currency
          WHERE main_currency_cd = i.currency_cd;

         PIPE ROW (rep);
      END LOOP;
   END;

   FUNCTION get_clm_deductibles (
      p_claim_id          GICL_CLAIMS.claim_id%TYPE,
      p_advice_id         GICL_ADVICE.advice_id%TYPE,
      p_payee_class_cd    GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
      p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE)
      RETURN giclr031_tab
      PIPELINED
   IS
      rep   giclr031_type;
   BEGIN
      FOR i
         IN (  SELECT A.claim_id,
                      A.payee_class_cd,
                      A.payee_cd,
                      b.loss_exp_cd,
                      SUM (
                           DECODE (b.loss_exp_cd,
                                   'DP', ABS (b.dtl_amt) * -1,
                                   b.dtl_amt)
                         /** DECODE (a.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   d.currency_cd, 1,
                                   NVL (d.orig_curr_rate, d.convert_rate)))*/ --belle 12.03.2012
                           * DECODE (A.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   d.currency_cd, 1,
                                   NVL (d.convert_rate, d.orig_curr_rate)))
                         sum_b_dtl_amt,
                      c.loss_exp_desc,
                      A.advice_id,
                      DECODE (A.clm_clmnt_no, NULL, 0, A.clm_clmnt_no)
                         clm_clmnt_no,
                      d.convert_rate
                 FROM gicl_clm_loss_exp A,
                      gicl_loss_exp_dtl b,
                      giis_loss_exp c,
                      gicl_advice d
                WHERE     A.claim_id = b.claim_id
                      AND A.clm_loss_id = b.clm_loss_id
                      AND A.payee_type = c.loss_exp_type
                      AND b.line_cd = c.line_cd
                      AND NVL (b.subline_cd, 'XX') = NVL (c.subline_cd, 'XX')
                      AND b.loss_exp_cd = c.loss_exp_cd
                      AND A.claim_id = d.claim_id
                      AND A.advice_id = d.advice_id
                      AND b.dtl_amt < 0
                      AND d.claim_id = p_claim_id
                      AND d.advice_id = p_advice_id
                      AND A.payee_class_cd = p_payee_class_cd
                      AND A.payee_cd = p_payee_cd
             GROUP BY A.claim_id,
                      A.payee_class_cd,
                      A.payee_cd,
                      b.loss_exp_cd,
                      c.loss_exp_desc,
                      A.advice_id,
                      DECODE (A.clm_clmnt_no, NULL, 0, A.clm_clmnt_no),
                      A.currency_cd,
                      d.convert_rate,
                      d.currency_cd
             ORDER BY SUM (
                           b.dtl_amt
                         * DECODE (A.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   d.currency_cd, 1,
                                   NVL (d.orig_curr_rate, d.convert_rate))))
      LOOP
         rep.claim_id := i.claim_id;
         rep.payee_class_cd := i.payee_class_cd;
         rep.payee_cd := i.payee_cd;
         rep.loss_exp_cd := i.loss_exp_cd;
         rep.sum_b_dtl_amt := i.sum_b_dtl_amt;
         rep.loss_exp_Desc := i.loss_exp_desc;
         rep.advice_id := i.advice_id;
         rep.clm_clmnt_no := i.clm_clmnt_no;
         rep.convert_rate := i.convert_rate;

         PIPE ROW (rep);
      END LOOP;
   END;

   FUNCTION get_tax_input (
      p_claim_id          GICL_CLAIMS.claim_id%TYPE,
      p_advice_id         GICL_ADVICE.advice_id%TYPE,
      p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
      p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE)
      RETURN NUMBER
   IS
      v_tax_input   GICL_LOSS_EXP_TAX.tax_amt%TYPE;
   BEGIN
      FOR i
         IN (  SELECT A.claim_id claim_id,
                      A.payee_class_cd payee_class_cd,
                      A.payee_cd payee_cd,
                      A.advice_id advice_id,
                      DECODE (A.clm_clmnt_no, NULL, 0, A.clm_clmnt_no)
                         clm_clmnt_no,
                      SUM (A.sum_tax_amt) sum_sum_tax_amt,
                      SUM (A.sum_b_tax_amt) sum_sum_b_tax_amt
                 FROM (  SELECT A.claim_id claim_id,
                                A.payee_class_cd payee_class_cd,
                                A.payee_cd payee_cd,
                                A.advice_id advice_id,
                                b.w_tax w_tax,
                                DECODE (A.clm_clmnt_no, NULL, 0, A.clm_clmnt_no)
                                   clm_clmnt_no,
                                DECODE (
                                   b.w_tax,
                                   'Y', 0,
                                   (SUM (
                                         b.tax_amt
                                       * DECODE (
                                            A.currency_cd,
                                            GIACP.N ('CURRENCY_CD'), 1,
                                            c.currency_cd, 1,
                                            NVL (c.orig_curr_rate,
                                                 c.convert_rate)))))
                                   sum_tax_amt,
                                SUM (
                                     b.tax_amt
                                   * DECODE (
                                        A.currency_cd,
                                        GIACP.N ('CURRENCY_CD'), 1,
                                        c.currency_cd, 1,
                                        NVL (c.orig_curr_rate, c.convert_rate)))
                                   sum_b_tax_amt,
                                c.convert_rate convert_rate
                           FROM gicl_clm_loss_exp A,
                                gicl_loss_exp_tax b,
                                gicl_advice c
                          WHERE     A.claim_id = b.claim_id
                                AND A.clm_loss_id = b.clm_loss_id
                                AND A.claim_id = c.claim_id
                                AND A.advice_id = c.advice_id
                                AND b.tax_type = 'I'
                                AND A.claim_id = p_claim_id
                                AND A.advice_id = p_advice_id
                                AND A.payee_class_cd = p_payee_class_cd
                                AND A.payee_cd = p_payee_cd
                       GROUP BY A.claim_id,
                                A.payee_class_cd,
                                A.payee_cd,
                                A.advice_id,
                                b.w_tax,
                                DECODE (A.clm_clmnt_no,
                                        NULL, 0,
                                        A.clm_clmnt_no),
                                DECODE (
                                   b.w_tax,
                                   'N', (  b.tax_amt
                                         * DECODE (A.currency_cd,
                                                   GIACP.N ('CURRENCY_CD'), 1,
                                                   c.convert_rate)),
                                   NULL, (  b.tax_amt
                                          * DECODE (A.currency_cd,
                                                    GIACP.N ('CURRENCY_CD'), 1,
                                                    c.convert_rate)),
                                   'Y', 0),
                                A.currency_cd,
                                c.convert_rate) A
             GROUP BY A.claim_id,
                      A.payee_class_cd,
                      A.payee_cd,
                      A.advice_id,
                      DECODE (A.clm_clmnt_no, NULL, 0, A.clm_clmnt_no))
      LOOP
         v_tax_input := i.sum_sum_b_tax_amt;
      END LOOP;

      RETURN (v_tax_input);
   END;

   FUNCTION get_tax_others (
      p_claim_id          GICL_CLAIMS.claim_id%TYPE,
      p_advice_id         GICL_ADVICE.advice_id%TYPE,
      p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
      p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE)
      RETURN NUMBER
   IS
      v_tax_others   GICL_LOSS_EXP_TAX.tax_amt%TYPE;
   BEGIN
      FOR i IN (SELECT SUM (A.sum_a_tax_amt) sum_sum_a_tax_amt
                  FROM (  SELECT A.claim_id,
                                 A.payee_class_cd,
                                 A.payee_cd,
                                 A.advice_id,
                                 DECODE (A.clm_clmnt_no,
                                         NULL, 0,
                                         A.clm_clmnt_no)
                                    clm_clmnt_no,
                                 DECODE (
                                    b.net_tag,
                                    'N', (SUM (
                                               b.tax_amt
                                             * DECODE (
                                                  A.currency_cd,
                                                  giacp.n ('CURRENCY_CD'), 1,
                                                  c.currency_cd, 1,
                                                  NVL (c.orig_curr_rate,
                                                       c.convert_rate)))),
                                    - (SUM (
                                            b.tax_amt
                                          * DECODE (
                                               A.currency_cd,
                                               giacp.n ('CURRENCY_CD'), 1,
                                               c.currency_cd, 1,
                                               NVL (c.orig_curr_rate,
                                                    c.convert_rate)))))
                                    sum_a_tax_amt
                            FROM gicl_clm_loss_exp A,
                                 gicl_loss_exp_tax b,
                                 gicl_advice c
                           WHERE     A.claim_id = b.claim_id
                                 AND A.clm_loss_id = b.clm_loss_id
                                 AND A.claim_id = c.claim_id
                                 AND A.advice_id = c.advice_id
                                 AND b.tax_type IN ('O', 'W')
                                 AND c.claim_id = p_claim_id
                                 AND c.advice_id = p_advice_id
                                 AND A.payee_class_cd = p_payee_class_cd
                                 AND A.payee_cd = p_payee_cd
                        GROUP BY A.claim_id,
                                 A.payee_class_cd,
                                 A.payee_cd,
                                 A.advice_id,
                                 DECODE (A.clm_clmnt_no,
                                         NULL, 0,
                                         A.clm_clmnt_no),
                                 A.currency_cd,
                                 b.net_tag) A)
      LOOP
         v_tax_others := i.sum_sum_a_tax_amt;
      END LOOP;

      RETURN (v_tax_others);
   END;

   FUNCTION get_tax_oth_adv (
      p_claim_id          GICL_CLAIMS.claim_id%TYPE,
      p_advice_id         GICL_ADVICE.advice_id%TYPE,
      p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
      p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE)
      RETURN NUMBER
   IS
      v_tax_oth_adv   GICL_LOSS_EXP_TAX.tax_amt%TYPE;
   BEGIN
      FOR i
         IN (  SELECT A.claim_id,
                      A.payee_class_cd,
                      A.payee_cd,
                      A.advice_id,
                      DECODE (A.clm_clmnt_no, NULL, 0, A.clm_clmnt_no)
                         clm_clmnt_no,
                      - (SUM (
                              b.tax_amt
                            * DECODE (A.currency_cd,
                                      GIACP.N ('CURRENCY_CD'), 1,
                                      c.currency_cd, 1,
                                      NVL (c.orig_curr_rate, c.convert_rate))))
                         sum_d_tax_amt
                 FROM gicl_clm_loss_exp A, gicl_loss_exp_tax b, gicl_advice c
                WHERE     A.claim_id = b.claim_id
                      AND A.clm_loss_id = b.clm_loss_id
                      AND A.claim_id = c.claim_id
                      AND A.advice_id = c.advice_id
                      AND b.tax_type IN ('O', 'W')
                      AND b.adv_tag = 'Y'
                      AND c.claim_id = p_claim_id
                      AND c.advice_id = p_advice_id
                      AND A.payee_class_cd = p_payee_class_cd
                      AND A.payee_cd = p_payee_cd
             GROUP BY A.claim_id,
                      A.payee_class_cd,
                      A.payee_cd,
                      A.advice_id,
                      DECODE (A.clm_clmnt_no, NULL, 0, A.clm_clmnt_no),
                      A.currency_cd)
      LOOP
         v_tax_oth_adv := i.sum_d_tax_amt;
      END LOOP;

      RETURN (v_tax_oth_adv);
   END;

   FUNCTION get_tax_in_adv (
      p_claim_id          GICL_CLAIMS.claim_id%TYPE,
      p_advice_id         GICL_ADVICE.advice_id%TYPE,
      p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
      p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE)
      RETURN NUMBER
   IS
      v_tax_in_adv   GICL_LOSS_EXP_TAX.tax_amt%TYPE;
   BEGIN
      FOR i
         IN (  SELECT A.claim_id,
                      A.payee_class_cd,
                      A.payee_cd,
                      A.advice_id,
                      DECODE (A.clm_clmnt_no, NULL, 0, A.clm_clmnt_no)
                         clm_clmnt_no,
                      - (SUM (
                              b.tax_amt
                            * DECODE (A.currency_cd,
                                      GIACP.N ('CURRENCY_CD'), 1,
                                      c.currency_cd, 1,
                                      NVL (c.orig_curr_rate, c.convert_rate))))
                         sum_c_tax_amt
                 FROM gicl_clm_loss_exp A, gicl_loss_exp_tax b, gicl_advice c
                WHERE     A.claim_id = b.claim_id
                      AND A.clm_loss_id = b.clm_loss_id
                      AND A.claim_id = c.claim_id
                      AND A.advice_id = c.advice_id
                      AND b.tax_type = 'I'
                      AND b.adv_tag = 'Y'
                      AND c.claim_id = p_claim_id
                      AND c.advice_id = p_advice_id
                      AND A.payee_class_cd = p_payee_class_cd
                      AND A.payee_cd = p_payee_cd
             GROUP BY A.claim_id,
                      A.payee_class_cd,
                      A.payee_cd,
                      A.advice_id,
                      DECODE (A.clm_clmnt_no, NULL, 0, A.clm_clmnt_no),
                      A.currency_cd)
      LOOP
         v_tax_in_adv := i.sum_c_tax_amt;
      END LOOP;

      RETURN (v_tax_in_adv);
   END;

   FUNCTION CF_finalFormula (
      p_claim_id        GICL_CLAIMS.claim_id%TYPE,
      p_advice_id       GICL_ADVICE.advice_id%TYPE,
      p_name            VARCHAR2,
      p_ex_gratia_sw    GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,
      p_final_tag       GICL_CLM_LOSS_EXP.final_tag%TYPE)
      RETURN VARCHAR2
   IS
      v_payee_type   VARCHAR2 (20);
      v_ctr          NUMBER (5) := 0;
      v_final        VARCHAR2 (200);
   BEGIN
      FOR i
         IN (SELECT DISTINCT (payee_type) payee_type
               FROM gicl_clm_loss_exp A
              WHERE     NVL (dist_sw, 'N') = 'Y'
                    AND claim_id = p_claim_id
                    AND advice_id = p_advice_id
                    /*comment out by MAC 11/22/2013
                    AND payee_class_cd IN
                           (SELECT payee_class_cd
                              FROM giis_payees
                             WHERE DECODE (
                                      payee_first_name,
                                      NULL, payee_last_name,
                                         payee_first_name
                                      || ' '
                                      || payee_middle_name
                                      || ' '
                                      || payee_last_name) = p_name))*/
                     --used payee_class_cd and payee_cd in retrieving distinct payee type by MAC 11/22/2013
                     AND EXISTS ( SELECT 1
                                FROM giis_payees b
                               WHERE DECODE (payee_first_name,
                                             NULL, payee_last_name,
                                                payee_first_name
                                             || ' '
                                             || payee_middle_name
                                             || ' '
                                             || payee_last_name
                                            ) = p_name
                                 AND A.payee_class_cd = b.payee_class_cd
                                 AND A.payee_cd = b.payee_no))
      LOOP
         IF v_ctr = 0 AND i.payee_type = 'L'
         THEN                                     --this is for payee type 'L'
            v_ctr := 1;
            v_payee_type := ' loss.';
         ELSIF v_ctr = 0 AND i.payee_type = 'E'
         THEN                                     --this is for payee type 'E'
            v_ctr := 1;
            v_payee_type := ' expense.';
         ELSIF v_ctr = 1
         THEN                             --this is for more than 1 payee type
            v_payee_type := ' loss/expense.';
         END IF;
      END LOOP;

      IF p_ex_gratia_sw = 'Y'
      THEN
         v_final := 'As Ex Gratia settlement of the above' || v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011
      ELSIF (p_ex_gratia_sw = 'N' OR p_ex_gratia_sw IS NULL)
      THEN
         IF (p_final_tag IS NULL) OR (p_final_tag = 'N')
         THEN
            v_final := 'As partial settlement of the above' || v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011
         ELSIF p_final_tag = 'Y'
         THEN
            v_final :=
               'As full and final settlement of the above' || v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011
         END IF;
      END IF;

      RETURN (v_final);
   END;

   FUNCTION get_clm_perils (p_claim_id     GICL_CLAIMS.claim_id%TYPE,
                            p_advice_id    GICL_ADVICE.advice_id%TYPE,
                            p_line_cd      GICL_ADVICE.line_cd%TYPE)
      RETURN giclr031_tab
      PIPELINED
   IS
      rep   giclr031_type;
   BEGIN
      FOR i
         IN (  SELECT A.claim_id,
                      A.advice_id,
                      A.peril_cd,
                      A.payee_class_cd,
                      A.payee_cd,
                      SUM (
                           A.paid_amt
                         * DECODE (A.currency_cd,
                                   GIACP.N ('CURRENCY_CD'), 1,
                                   b.currency_cd, 1,
                                   --NVL (b.orig_curr_rate, b.convert_rate))) --belle 12.03.2012
                                   NVL (b.convert_rate, b.orig_curr_rate)))
                         peril_paid_amt
                 FROM gicl_clm_loss_exp A, gicl_advice b
                WHERE     A.claim_id = b.claim_id
                      AND A.advice_id = b.advice_id
                      AND A.claim_id = p_claim_id
                      AND A.advice_id = p_advice_id
             GROUP BY A.claim_id,
                      A.advice_id,
                      A.peril_cd,
                      A.payee_class_cd,
                      A.payee_cd,
                      A.currency_cd)
      LOOP
         rep.peril_paid_amt := i.peril_paid_amt;

         BEGIN
            SELECT peril_sname
              INTO rep.peril_sname
              FROM giis_peril
             WHERE line_cd = p_line_cd AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rep.peril_sname := '';
         END;

         PIPE ROW (rep);
      END LOOP;
   END;

   FUNCTION get_payment_dtls (
      p_claim_id          GICL_CLAIMS.claim_id%TYPE,
      p_advice_id         GICL_ADVICE.advice_id%TYPE,
      p_payee_class_cd    GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
      p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE)
      RETURN giclr031_tab
      PIPELINED
   IS
      rep               giclr031_type;
      v_doc_type_desc   VARCHAR2 (100);
   BEGIN
      FOR i
         IN (SELECT A.class_desc,
                    b.doc_number,
                    b.doc_type,
                    b.claim_id,
                    d.advice_id,
                    d.payee_class_cd,
                    d.payee_cd,
                    b.claim_loss_id,
                       c.payee_last_name
                    || ' '
                    || c.payee_first_name
                    || ' '
                    || c.payee_middle_name
                       payee_name
               FROM giis_payee_class A,
                    gicl_loss_exp_bill b,
                    giis_payees c,
                    gicl_clm_loss_exp d
              WHERE     A.payee_class_cd = b.payee_class_cd
                    AND A.payee_class_cd = c.payee_class_cd
                    AND b.payee_cd = c.payee_no
                    AND b.claim_id = d.claim_id
                    AND b.claim_loss_id = d.clm_loss_id
                    AND d.claim_id = p_claim_id
                    AND d.advice_id = p_advice_id
                    AND d.payee_class_cd = p_payee_class_cd
                    AND d.payee_cd = p_payee_cd)
      LOOP
         SELECT rv_meaning
           INTO v_doc_type_desc
           FROM cg_ref_codes
          WHERE     rv_domain = 'GICL_LOSS_EXP_BILL.DOC_TYPE'
                AND rv_low_value = i.doc_type;

         rep.doc_type_desc := v_doc_type_desc || ' Number';
         rep.payment_for := i.class_desc || ' ' || i.payee_name;
         rep.doc_no := i.doc_number;

         PIPE ROW (rep);
      END LOOP;
   END;

   FUNCTION get_g_report_no2 (p_line_cd      GIIS_LINE.line_cd%TYPE,
                              p_branch_cd    GICL_CLAIMS.iss_cd%TYPE,
                              p_user         GIIS_USERS.user_id%TYPE)
      RETURN giclr031_tab
      PIPELINED
   IS
      rep   giclr031_type;
   BEGIN
      FOR i
         IN (SELECT A.report_no,
                    b.item_no,
                    b.LABEL,
                    c.signatory,
                    c.designation
               FROM giac_documents A,
                    giac_rep_signatory b,
                    giis_signatory_names c
              WHERE     A.report_no = b.report_no
                    AND A.report_id = b.report_id
                    AND A.report_id = 'GICLR031'
                    AND NVL (A.line_cd, '@') = NVL (p_line_cd, '@')
                    AND NVL (A.branch_cd, '@') = NVL (p_branch_cd, '@')
					AND b.signatory_id = c.signatory_id
                    AND b.LABEL = 'Prepared By:'
             UNION
             SELECT 1 rep_no,
                    1 item_no,
                    'Prepared By :' lbel,
                    user_name,
                    ' ' designation
               FROM giis_users
              WHERE user_id = p_user)
      LOOP
         rep.LABEL := i.LABEL;
         rep.signatory := i.signatory;
         rep.designation := i.designation;

         PIPE ROW (rep);
      END LOOP;
   END;

   FUNCTION get_g_label (p_line_cd      GIIS_LINE.line_cd%TYPE,
                         p_branch_cd    GICL_CLAIMS.iss_cd%TYPE)
      RETURN giclr031_tab
      PIPELINED
   IS
      rep   giclr031_type;
   BEGIN
      FOR i
         IN (SELECT A.report_no,
                    b.item_no,
                    b.LABEL,
                    c.signatory,
                    c.designation
               FROM giac_documents A,
                    giac_rep_signatory b,
                    giis_signatory_names c
              WHERE     A.report_no = b.report_no
                    AND A.report_id = b.report_id
                    AND A.report_id = 'GICLR031'
					AND NVL (A.line_cd,p_line_cd) = p_line_cd --edited by steven 11/29/2012
                    AND NVL (A.branch_cd,p_branch_cd) = p_branch_cd
                    /*AND NVL (a.line_cd, '@') = NVL (p_line_cd, '@')
                    AND NVL (a.branch_cd, '@') = NVL (p_branch_cd, '@')*/
                    AND b.signatory_id = c.signatory_id
                    AND b.LABEL != 'Prepared By:')
      LOOP
         rep.LABEL := i.LABEL;
         rep.signatory := i.signatory;
         rep.designation := i.designation;

         PIPE ROW (rep);
      END LOOP;
   END;

   FUNCTION get_g_report_no1 (p_line_cd      GIIS_LINE.line_cd%TYPE,
                              p_branch_cd    GICL_CLAIMS.iss_cd%TYPE,
                              p_user         GIIS_USERS.user_id%TYPE)
      RETURN giclr031_tab
      PIPELINED
   IS
      rep   giclr031_type;
   BEGIN
      FOR i
         IN (SELECT A.report_no,
                    b.item_no,
                    b.LABEL,
                    c.signatory,
                    c.designation
               FROM giac_documents A,
                    giac_rep_signatory b,
                    giis_signatory_names c
              WHERE     A.report_no = b.report_no
                    AND A.report_id = b.report_id
                    AND A.report_id = 'GICLR031'
                    --AND NVL (a.line_cd, '@') = NVL (p_line_cd, '@') // replaced by: Nica 12.07.2012
                    --AND NVL (a.branch_cd, '@') = NVL (p_branch_cd, '@')
                    AND NVL (A.line_cd,p_line_cd) = p_line_cd 
                    AND NVL (A.branch_cd,p_branch_cd) = p_branch_cd
                    AND b.signatory_id = c.signatory_id
                    AND b.LABEL != 'Prepared By:'
             UNION
             SELECT 1 rep_no,
                    1 item_no,
                    'Prepared By :' lbel,
                    user_name,
                    ' ' designation
               FROM giis_users
              WHERE user_id = p_user)
      LOOP
         rep.LABEL := i.LABEL;
         rep.signatory := i.signatory;
         rep.designation := i.designation;

         PIPE ROW (rep);
      END LOOP;
   END;

   FUNCTION show_dist (p_line_cd GICL_CLAIMS.line_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_csr_dist_display   VARCHAR2 (1) := 'Y';
   BEGIN
      IF p_line_cd = 'MC'
      THEN
         SELECT param_value_v
           INTO v_csr_dist_display
           FROM giac_parameters
          WHERE param_name = 'CSR_DIST_DISPLAY';
      END IF;

      RETURN (v_csr_dist_display);
   END;

   FUNCTION show_peril (p_line_cd GICL_CLAIMS.line_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_show_csr_peril   VARCHAR2 (1);
      v_show             VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_show_csr_peril
           FROM giis_parameters
          WHERE param_name = 'SHOW_CSR_PERIL';
      END;

      IF p_line_cd = 'SU' OR NVL (v_show_csr_peril, 'N') <> 'Y'
      THEN
         v_show := 'N';
      ELSE
         v_show := 'Y';
      END IF;

      RETURN (v_show);
   END;
END;
/


