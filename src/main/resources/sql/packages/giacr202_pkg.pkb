CREATE OR REPLACE PACKAGE BODY CPI.giacr202_pkg
AS
   FUNCTION get_gl_acct_code (
      p_gacc_tran_id    giac_acct_entries.gacc_tran_id%TYPE,
      p_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_gl_acct_code   VARCHAR2 (100);
   BEGIN
      SELECT    TO_CHAR (a.gl_acct_category)
             || '-'
             || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00')) gl_acct_code
        INTO v_gl_acct_code
        FROM giac_acct_entries a
       WHERE a.gacc_tran_id = p_gacc_tran_id
         AND a.acct_entry_id = p_acct_entry_id;

      RETURN v_gl_acct_code;
   END get_gl_acct_code;

   FUNCTION /*get_giacr202_records*/ get_giacr202_records_old ( --benjo 08.03.2015 UCPBGEN-SR-19710
      p_branch_cd    VARCHAR2,
      p_company      VARCHAR2,
      p_control      VARCHAR2,
      p_sub_1        VARCHAR2,
      p_sub_2        VARCHAR2,
      p_sub_3        VARCHAR2,
      p_sub_4        VARCHAR2,
      p_sub_5        VARCHAR2,
      p_sub_6        VARCHAR2,
      p_sub_7        VARCHAR2,
      p_tran_class   VARCHAR2,
      p_sl_cd        VARCHAR2,
      p_sl_type_cd   VARCHAR2,
      p_tran_flag    VARCHAR2,
      p_tran_post    VARCHAR2,
      p_date_from    VARCHAR2,
      p_date_to      VARCHAR2,
      p_category     VARCHAR2
   )
      RETURN giacr202_record_tab PIPELINED
   IS
      v_list   giacr202_record_type;
   BEGIN
      FOR i IN
         (SELECT giacr202_pkg.get_gl_acct_code (a.gacc_tran_id,
                                                a.acct_entry_id
                                               ) gl_acct_code,
                 e.gl_acct_name,
                 DECODE (p_tran_post,
                         'T', b.tran_date,
                         'P', b.posting_date
                        ) month_grp,
                 b.tran_class,
                 SUM(NVL (a.debit_amt, 0)) debit,
                 SUM(NVL (a.credit_amt, 0)) credit,
                 SUM(NVL (a.debit_amt, 0) - NVL (a.credit_amt, 0)) cf_balance
            FROM giac_acct_entries a,
                 giac_acctrans b,
                 giac_order_of_payts c,
                 giac_disb_vouchers d,
                 giac_chart_of_accts e
           WHERE a.gacc_tran_id = b.tran_id
             AND a.gacc_tran_id = c.gacc_tran_id(+)
             AND a.gacc_tran_id = d.gacc_tran_id(+)
             AND a.gl_acct_id = e.gl_acct_id
             --AND UPPER (a.gacc_gibr_branch_cd) = UPPER (NVL (p_branch_cd, '%')) 
             AND UPPER (a.gacc_gibr_branch_cd) LIKE UPPER (NVL (p_branch_cd, '%')) --kenneth @fgic 10302014
             AND a.gacc_gfun_fund_cd = UPPER (NVL (p_company, '%'))
             AND a.gl_control_acct = NVL (p_control, a.gl_control_acct)
             AND a.gl_sub_acct_1 = NVL (p_sub_1, a.gl_sub_acct_1)
             AND a.gl_sub_acct_2 = NVL (p_sub_2, a.gl_sub_acct_2)
             AND a.gl_sub_acct_3 = NVL (p_sub_3, a.gl_sub_acct_3)
             AND a.gl_sub_acct_4 = NVL (p_sub_4, a.gl_sub_acct_4)
             AND a.gl_sub_acct_5 = NVL (p_sub_5, a.gl_sub_acct_5)
             AND a.gl_sub_acct_6 = NVL (p_sub_6, a.gl_sub_acct_6)
             AND a.gl_sub_acct_7 = NVL (p_sub_7, a.gl_sub_acct_7)
             AND b.tran_class = NVL (p_tran_class, b.tran_class)
             AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
             AND NVL (a.sl_type_cd, '-') =
                                   NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
             AND b.tran_flag <> 'D'
             AND b.tran_flag NOT IN (UPPER (p_tran_flag))
             AND a.gl_acct_category = NVL(p_category, a.gl_acct_category)
             AND DECODE (p_tran_post,
                         'T', b.tran_date,
                         'P', b.posting_date,
                         b.tran_date
                        ) BETWEEN TO_DATE (p_date_from, 'mm-dd-yyyy')
                              AND TO_DATE (p_date_to, 'mm-dd-yyyy')
        GROUP BY giacr202_pkg.get_gl_acct_code (a.gacc_tran_id,
                                                a.acct_entry_id),
                 e.gl_acct_name,
                 DECODE (p_tran_post,
                         'T', b.tran_date,
                         'P', b.posting_date
                        ),
                 b.tran_class
                 )
      LOOP
         v_list.gl_acct_code := i.gl_acct_code;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.month_grp := TO_CHAR (i.month_grp, 'MONTH yyyy');
         v_list.month_grp_date :=
                        TO_DATE (TO_CHAR (i.month_grp, 'mm-yyyy'), 'mm-yyyy');
         v_list.tran_class := i.tran_class;
         v_list.debit := i.debit;
         v_list.credit := i.credit;
         v_list.cf_bal := i.cf_balance;

         IF v_list.company_name IS NULL
         THEN
            IF v_list.company_name IS NULL
            THEN
               v_list.company_name := giisp.v ('COMPANY_NAME');
               v_list.company_address := giisp.v ('COMPANY_ADDRESS');
            END IF;

            IF v_list.date_from IS NULL
            THEN
               v_list.date_from :=
                     TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'),
                                    'Month'
                                   )
                          )
                  || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'),
                              ' DD, YYYY');
               v_list.date_to :=
                     TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'),
                                    'Month')
                          )
                  || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
            END IF;

            IF p_branch_cd IS NOT NULL AND v_list.branch_name IS NULL
            THEN
               BEGIN
                  SELECT UPPER (branch_name)
                    INTO v_list.branch_name
                    FROM giac_branches
                   WHERE branch_cd = p_branch_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_list.branch_name := NULL;
               END;
            END IF;

            PIPE ROW (v_list);
         END IF;

         PIPE ROW (v_list);
      END LOOP;

      IF v_list.company_name IS NULL
      THEN
         IF v_list.company_name IS NULL
         THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;

         IF v_list.date_from IS NULL
         THEN
            v_list.date_from :=
                  TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to :=
                  TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month'))
               || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF p_branch_cd IS NOT NULL AND v_list.branch_name IS NULL
         THEN
            BEGIN
               SELECT UPPER (branch_name)
                 INTO v_list.branch_name
                 FROM giac_branches
                WHERE branch_cd = p_branch_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_list.branch_name := NULL;
            END;
         END IF;

         PIPE ROW (v_list);
      END IF;

      RETURN;
   END /*get_giacr202_records*/ get_giacr202_records_old; --benjo 08.03.2015 UCPBGEN-SR-19710
   
/* 
** Created By: Benjo Brito
** Date Created: 08.03.2015
** Remarks: UCPBGEN-SR-19710 - Optimization 
*/ 
    FUNCTION get_giacr202_records (
       p_branch_cd    VARCHAR2,
       p_company      VARCHAR2,
       p_control      VARCHAR2,
       p_sub_1        VARCHAR2,
       p_sub_2        VARCHAR2,
       p_sub_3        VARCHAR2,
       p_sub_4        VARCHAR2,
       p_sub_5        VARCHAR2,
       p_sub_6        VARCHAR2,
       p_sub_7        VARCHAR2,
       p_tran_class   VARCHAR2,
       p_sl_cd        VARCHAR2,
       p_sl_type_cd   VARCHAR2,
       p_tran_flag    VARCHAR2,
       p_tran_post    VARCHAR2,
       p_date_from    VARCHAR2,
       p_date_to      VARCHAR2,
       p_category     VARCHAR2,
      -- jhing GENQA 5280,5200 added parameters p_user_id and p_module_id
      p_user_id      VARCHAR2,
      p_module_id    VARCHAR2
    )
       RETURN giacr202_record_tab PIPELINED
    IS
       v_list        giacr202_record_type;
       v_exist_rev   NUMBER               := 0;
       v_ref_no      VARCHAR2 (200);
       v_ctr         NUMBER (3)           := 0;
       v_temp1       VARCHAR2 (32767)     := NULL;
       v_temp2       VARCHAR2 (32767)     := NULL;
       v_temp3       VARCHAR2 (32767)     := NULL;
       -- jhing added new fields  GENQA 5280,5200
       v_branch_accessible  VARCHAR2 (2000);    
       v_withTargetRec      VARCHAR2 (2000);
       v_recPrinted         NUMBER ; 
    BEGIN
       -- added by jhing 01.27.2016 GENQA 5280,5200
       v_branch_accessible  := giacr060_pkg.get_Branch_WithAccess (p_module_id, p_user_id ); 
       v_withTargetRec := 'N';
       v_recPrinted    := 0 ; 
       
       
       IF v_branch_accessible IS NOT NULL THEN
           v_withTargetRec := 'Y';
       END IF; 
       
       IF v_withTargetRec = 'Y' THEN   -- jhing 01.27.2016, if user has no access to any branch, do not execute query
       
           FOR i IN (SELECT      TO_CHAR (a.gl_acct_category)
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00'))
                                                                        gl_acct_code,
                              e.gl_acct_name,
                              DECODE (p_tran_post,
                                      'T', b.tran_date,
                                      'P', b.posting_date
                                     ) month_grp,
                              b.tran_class, a.sl_source_cd, a.sl_type_cd, a.sl_cd,
                              TRUNC (b.tran_date) tran_date, a.gacc_tran_id,
                              TRUNC (b.posting_date) posting_date,
                              DECODE (b.tran_class,
                                      'COL', c.payor,
                                      'DV', d.payee
                                     ) NAME,
                              b.tran_flag,
                              DECODE (b.tran_class,
                                      'COL', NVL (c.particulars, b.particulars),
                                      'DV', d.particulars,
                                      'JV', b.particulars,
                                      b.particulars
                                     ) particulars,
                                 c.or_pref_suf
                              || ' '
                              || LPAD (TO_CHAR (c.or_no), 10, '0') col_ref_no,
                              LPAD (TO_CHAR (b.tran_class_no), 10, '0') jv_ref_no,
                              SUM (NVL (a.debit_amt, 0)) debit,
                              SUM (NVL (a.credit_amt, 0)) credit,
                              SUM (NVL (a.debit_amt, 0) - NVL (a.credit_amt, 0)
                                  ) cf_balance, 
                                  b.jv_pref, b.jv_seq_no -- added by gab 09.14.2015
                         FROM giac_acct_entries a,
                              giac_acctrans b,
                              giac_order_of_payts c,
                              giac_disb_vouchers d,
                              giac_chart_of_accts e
                        WHERE a.gacc_tran_id = b.tran_id
                          AND a.gacc_tran_id = c.gacc_tran_id(+)
                          AND a.gacc_tran_id = d.gacc_tran_id(+)
                          AND a.gl_acct_id = e.gl_acct_id
                          AND a.gacc_gibr_branch_cd =
                                      UPPER (NVL (p_branch_cd, a.gacc_gibr_branch_cd))
                          AND a.gacc_gibr_branch_cd IN (SELECT *
                                                        FROM TABLE (
                                                                SPLIT_COMMA_SEPARATED_STRING (
                                                                                     v_branch_accessible)))   -- added by jhing 01.27.2016 GENQA 5280,5200          
                          AND a.gacc_gfun_fund_cd =
                                          UPPER (NVL (p_company, a.gacc_gfun_fund_cd))
                          AND a.gl_control_acct = NVL (p_control, a.gl_control_acct)
                          AND a.gl_sub_acct_1 = NVL (p_sub_1, a.gl_sub_acct_1)
                          AND a.gl_sub_acct_2 = NVL (p_sub_2, a.gl_sub_acct_2)
                          AND a.gl_sub_acct_3 = NVL (p_sub_3, a.gl_sub_acct_3)
                          AND a.gl_sub_acct_4 = NVL (p_sub_4, a.gl_sub_acct_4)
                          AND a.gl_sub_acct_5 = NVL (p_sub_5, a.gl_sub_acct_5)
                          AND a.gl_sub_acct_6 = NVL (p_sub_6, a.gl_sub_acct_6)
                          AND a.gl_sub_acct_7 = NVL (p_sub_7, a.gl_sub_acct_7)
                          AND b.tran_class = NVL (p_tran_class, b.tran_class)
                          AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
                          AND NVL (a.sl_type_cd, '-') =
                                           NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
                          AND b.tran_flag <> 'D'
                          AND b.tran_flag NOT IN (UPPER (p_tran_flag))
                          AND a.gl_acct_category =
                                                  NVL (p_category, a.gl_acct_category)
                          AND DECODE (p_tran_post,
                                      'T', b.tran_date,
                                      'P', b.posting_date,
                                      b.tran_date
                                     ) BETWEEN TO_DATE (p_date_from, 'mm-dd-yyyy')
                                           AND TO_DATE (p_date_to, 'mm-dd-yyyy')
                     GROUP BY    TO_CHAR (a.gl_acct_category)
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                              || '-'
                              || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00')),
                              e.gl_acct_name,
                              DECODE (p_tran_post,
                                      'T', b.tran_date,
                                      'P', b.posting_date
                                     ),
                              b.tran_class,
                              a.sl_source_cd,
                              a.sl_type_cd,
                              a.sl_cd,
                              TRUNC (b.tran_date),
                              a.gacc_tran_id,
                              TRUNC (b.posting_date),
                              DECODE (b.tran_class, 'COL', c.payor, 'DV', d.payee),
                              b.tran_flag,
                              DECODE (b.tran_class,
                                      'COL', NVL (c.particulars, b.particulars),
                                      'DV', d.particulars,
                                      'JV', b.particulars,
                                      b.particulars
                                     ),
                              c.or_pref_suf || ' '
                              || LPAD (TO_CHAR (c.or_no), 10, '0'),
                              LPAD (TO_CHAR (b.tran_class_no), 10, '0'),
                              b.jv_pref,
                              b.jv_seq_no
                     ORDER BY gl_acct_code,
                              gl_acct_name,
                              month_grp,
                              tran_class,
                              sl_source_cd,
                              sl_type_cd,
                              sl_cd,
                              tran_date,
                              gacc_tran_id,
                              posting_date,
                              NAME,
                              tran_flag,
                              particulars,
                              col_ref_no,
                              jv_ref_no)
           LOOP
              v_list.company_name := giisp.v ('COMPANY_NAME');
              v_list.company_address := giisp.v ('COMPANY_ADDRESS');
              v_list.jv_ref_no := i.jv_pref || ' ' ||LPAD (TO_CHAR(i.jv_seq_no), 12, '0'); -- added by gab 09.14.2015

              BEGIN
                 SELECT UPPER (branch_name)
                   INTO v_list.branch_name
                   FROM giac_branches
                  WHERE branch_cd = p_branch_cd;
              EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                    v_list.branch_name := NULL;
              END;

              v_list.date_from :=
                    TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month'))
                 || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
              v_list.date_to :=
                    TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month'))
                 || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
              v_list.gl_acct_code := i.gl_acct_code;
              v_list.gl_acct_name := i.gl_acct_name;
              v_list.month_grp := TO_CHAR (i.month_grp, 'MONTH yyyy');
              v_list.month_grp_date :=
                                 TO_DATE (TO_CHAR (i.month_grp, 'mm-yyyy'), 'mm-yyyy');
              v_list.tran_class := i.tran_class;
              v_list.sl_source_cd := i.sl_source_cd;
              v_list.sl_type_cd := i.sl_type_cd;
              v_list.sl_cd := i.sl_cd;

              IF i.sl_cd IS NOT NULL
              THEN
                 IF i.sl_source_cd = '2'
                 THEN
                    BEGIN
                       SELECT DECODE (payee_first_name,
                                      NULL, payee_last_name
                                       || ' '
                                       || payee_first_name
                                       || ' '
                                       || payee_middle_name
                                       || '  *',
                                         payee_last_name
                                      || ', '
                                      || payee_first_name
                                      || ' '
                                      || payee_middle_name
                                      || '  *'
                                     )
                         INTO v_list.sl_name
                         FROM giis_payees
                        WHERE payee_class_cd = i.sl_type_cd AND payee_no = i.sl_cd;
                    EXCEPTION
                       WHEN NO_DATA_FOUND
                       THEN
                          v_list.sl_name := '_______No SL Code_______';
                    END;
                 ELSE
                    BEGIN
                       SELECT sl_name
                         INTO v_list.sl_name
                         FROM giac_sl_lists
                        WHERE sl_type_cd = i.sl_type_cd AND sl_cd = i.sl_cd;
                    EXCEPTION
                       WHEN NO_DATA_FOUND
                       THEN
                          v_list.sl_name := '_______No SL Code_______';
                    END;
                 END IF;
              ELSE
                 v_list.sl_name := '_______No SL Code_______';
              END IF;

              v_list.tran_date := TO_CHAR (i.tran_date, 'MM-DD-YYYY');
              v_list.gacc_tran_id := i.gacc_tran_id;
              v_list.posting_date := TO_CHAR (i.posting_date, 'MM-DD-YYYY');
              v_list.NAME := i.NAME;
              v_list.particulars := i.particulars;
              v_list.tran_flag := i.tran_flag;

              BEGIN
                 SELECT 1
                   INTO v_exist_rev
                   FROM giac_reversals
                  WHERE reversing_tran_id = i.gacc_tran_id;
              EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                    v_exist_rev := 0;
              END;

              IF v_exist_rev = 1
              THEN
                 BEGIN
                    SELECT 'REV-' || tran_year || '-' || tran_month || '-'
                           || tran_seq_no
                      INTO v_ref_no
                      FROM giac_acctrans
                     WHERE tran_id = i.gacc_tran_id;
                 EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                       v_ref_no := NULL;
                    WHEN TOO_MANY_ROWS
                    THEN
                       v_ref_no := v_ref_no;
                 END;
              ELSE
                 IF i.tran_class = 'COL'
                 THEN
                    v_ref_no := i.col_ref_no;
                 ELSIF i.tran_class = 'DV'
                 THEN
                    BEGIN
                       SELECT    a.dv_pref
                              || '-'
                              || LPAD (TO_CHAR (a.dv_no), 10, '0')
                              || '/'
                              || b.check_pref_suf
                              || '-'
                              || LPAD (TO_CHAR (b.check_no), 10, '0')
                         INTO v_ref_no
                         FROM giac_disb_vouchers a, giac_chk_disbursement b
                        WHERE b.check_stat = 2
                          AND a.gacc_tran_id = b.gacc_tran_id
                          AND a.gacc_tran_id = i.gacc_tran_id;
                    EXCEPTION
                       WHEN NO_DATA_FOUND
                       THEN
                          SELECT    document_cd
                                 || '-'
                                 || branch_cd
                                 || '-'
                                 || LPAD (TO_CHAR (doc_year), 4, '0')
                                 || '-'
                                 || LPAD (TO_CHAR (doc_mm), 2, '0')
                                 || '-'
                                 || LPAD (TO_CHAR (doc_seq_no), 6, '0')
                            INTO v_ref_no
                            FROM giac_payt_requests a, giac_payt_requests_dtl b
                           WHERE a.ref_id = b.gprq_ref_id AND tran_id = i.gacc_tran_id;
                       WHEN TOO_MANY_ROWS
                       THEN
                          FOR x IN (SELECT    a.dv_pref
                                           || '-'
                                           || LPAD (TO_CHAR (a.dv_no), 10, '0')
                                           || '/'
                                           || b.check_pref_suf
                                           || '-'
                                           || LPAD (TO_CHAR (b.check_no), 10, '0')
                                                                               refno
                                      FROM giac_disb_vouchers a,
                                           giac_chk_disbursement b
                                     WHERE b.check_stat = 2
                                       AND a.gacc_tran_id = b.gacc_tran_id
                                       AND a.gacc_tran_id = i.gacc_tran_id)
                          LOOP
                             v_ctr := v_ctr + 1;

                             IF v_ctr > 1
                             THEN
                                v_ref_no := v_ref_no || CHR (10) || x.refno;
                             END IF;
                          END LOOP;
                    END;
                 ELSIF i.tran_class = 'JV'
                 THEN
                    BEGIN
                       SELECT    DECODE (ref_jv_no, NULL, NULL, ref_jv_no || ' / ')
                              || tran_year
                              || '-'
                              || tran_month
                              || '-'
                              || tran_seq_no
                              || ' / '
                              || jv_pref_suff
                              || '-'
                              || LPAD (TO_CHAR (jv_no), 6, '0')
                         INTO v_ref_no
                         FROM giac_acctrans
                        WHERE tran_id = i.gacc_tran_id;
                    EXCEPTION
                       WHEN NO_DATA_FOUND
                       THEN
                          v_ref_no := NULL;
                       WHEN TOO_MANY_ROWS
                       THEN
                          v_ref_no := v_ref_no;
                    END;
                 ELSE
                    v_ref_no := i.jv_ref_no;
                 END IF;
              END IF;

              v_list.cf_ref_no := v_ref_no || ' / ' || LPAD (i.gacc_tran_id, 12, 0);
              v_list.debit := i.debit;
              v_list.credit := i.credit;
              v_list.cf_bal := i.cf_balance;

              IF v_temp1 =
                       i.gl_acct_code || i.gl_acct_name || i.month_grp || i.tran_class
              THEN
                 v_list.print_tran_class := 'N';
              ELSE
                 v_list.print_tran_class := 'Y';
              END IF;

              IF v_temp2 =
                       i.gl_acct_code
                    || i.gl_acct_name
                    || i.month_grp
                    || i.tran_class
                    || i.sl_source_cd
                    || i.sl_type_cd
                    || i.sl_cd
              THEN
                 v_list.print_sl := 'N';
              ELSE
                 v_list.print_sl := 'Y';
              END IF;

              IF v_temp3 =
                       i.gl_acct_code
                    || i.gl_acct_name
                    || i.month_grp
                    || i.tran_class
                    || i.sl_source_cd
                    || i.sl_type_cd
                    || i.sl_cd
                    || i.tran_date
              THEN
                 v_list.print_tran_date := 'N';
              ELSE
                 v_list.print_tran_date := 'Y';
              END IF;

              v_temp1 :=
                       i.gl_acct_code || i.gl_acct_name || i.month_grp || i.tran_class;
              v_temp2 :=
                    i.gl_acct_code
                 || i.gl_acct_name
                 || i.month_grp
                 || i.tran_class
                 || i.sl_source_cd
                 || i.sl_type_cd
                 || i.sl_cd;
              v_temp3 :=
                    i.gl_acct_code
                 || i.gl_acct_name
                 || i.month_grp
                 || i.tran_class
                 || i.sl_source_cd
                 || i.sl_type_cd
                 || i.sl_cd
                 || i.tran_date;
             
              v_recPrinted := v_recPrinted + 1 ; -- jhing 01.27.2016 GENQA 5280, 5200    
              PIPE ROW (v_list);
           END LOOP;

           RETURN;
       END IF;  
       
       -- jhing 01.27.2016 GENQA 5280,5200, if there are no records to be printed, display header
       IF v_withTargetRec = 'N' OR v_recPrinted = 0 THEN 
             BEGIN
                 SELECT UPPER (branch_name)
                   INTO v_list.branch_name
                   FROM giac_branches
                  WHERE branch_cd = p_branch_cd;
              EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                    v_list.branch_name := NULL;
              END;
              v_list.date_from :=
                    TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month'))
                 || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
              v_list.date_to :=
                    TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month'))
                 || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
              v_list.company_name := giisp.v ('COMPANY_NAME');
              v_list.company_address := giisp.v ('COMPANY_ADDRESS');
              
              IF p_category IS NOT NULL OR p_control IS NOT NULL THEN
                BEGIN
                    SELECT gl_acct_name
                        INTO v_list.gl_acct_name
                        FROM giac_chart_of_accts 
                    WHERE gl_acct_category = NVL(p_category,0)
                       AND gl_control_acct = NVL(p_control,0)
                       AND gl_sub_acct_1 =  NVL(p_sub_1,0)
                       AND gl_sub_acct_2 =  NVL(p_sub_2,0)
                       AND gl_sub_acct_3 =  NVL(p_sub_3,0)
                       AND gl_sub_acct_4 =  NVL(p_sub_4,0)
                       AND gl_sub_acct_5 =  NVL(p_sub_5,0)
                       AND gl_sub_acct_6 =  NVL(p_sub_6,0)
                       AND gl_sub_acct_7 =  NVL(p_sub_7,0); 
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_list.gl_acct_name := null;
                END;           
            
                 v_list.gl_acct_code :=  TO_CHAR (NVL(p_category,0))
                                            || '-'
                                            || LTRIM (TO_CHAR (NVL(p_control,0), '00'))
                                            || '-'
                                            || LTRIM (TO_CHAR (NVL(p_sub_1,0), '00'))
                                            || '-'
                                            || LTRIM (TO_CHAR (NVL(p_sub_2,0), '00'))
                                            || '-'
                                            || LTRIM (TO_CHAR (NVL(p_sub_3,0), '00'))
                                            || '-'
                                            || LTRIM (TO_CHAR (NVL(p_sub_4,0), '00'))
                                            || '-'
                                            || LTRIM (TO_CHAR (NVL(p_sub_5,0), '00'))
                                            || '-'
                                            || LTRIM (TO_CHAR (NVL(p_sub_6,0), '00'))
                                            || '-'
                                            || LTRIM (TO_CHAR (NVL(p_sub_7,0), '00'));
              END IF;
       
              PIPE ROW (v_list);   
       END IF;      
    END get_giacr202_records;

   FUNCTION get_sl (
      p_branch_cd        VARCHAR2,
      p_company          VARCHAR2,
      p_tran_class       VARCHAR2,
      p_sl_cd            VARCHAR2,
      p_sl_type_cd       VARCHAR2,
      p_tran_flag        VARCHAR2,
      p_tran_post        VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_gl_acct_code     VARCHAR2,
      p_month_grp_date   DATE
   )
      RETURN sl_tab PIPELINED
   IS
      v_list    sl_type;
      v_sl_nm   VARCHAR2 (1000);
   BEGIN
      FOR i IN (SELECT a.sl_source_cd, a.sl_type_cd, a.sl_cd sl_cd,
                       SUM(NVL (a.debit_amt, 0)) debit,
                       SUM(NVL (a.credit_amt, 0)) credit,
                       SUM(NVL (a.debit_amt, 0) - NVL (a.credit_amt, 0)) cf_balance
                  FROM giac_acct_entries a,
                       giac_acctrans b,
                       giac_order_of_payts c,
                       giac_disb_vouchers d,
                       giac_chart_of_accts e
                 WHERE a.gacc_tran_id = b.tran_id
                   AND a.gacc_tran_id = c.gacc_tran_id(+)
                   AND a.gacc_tran_id = d.gacc_tran_id(+)
                   AND a.gl_acct_id = e.gl_acct_id
                   AND UPPER (a.gacc_gibr_branch_cd) =
                              UPPER (NVL (p_branch_cd, a.gacc_gibr_branch_cd))
                   AND a.gacc_gfun_fund_cd =
                                  UPPER (NVL (p_company, a.gacc_gfun_fund_cd))
                   AND b.tran_class = NVL (p_tran_class, b.tran_class)
                   AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
                   AND NVL (a.sl_type_cd, '-') =
                                   NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
                   AND b.tran_flag <> 'D'
                   AND b.tran_flag NOT IN (UPPER (p_tran_flag))
                   AND giacr202_pkg.get_gl_acct_code (a.gacc_tran_id,
                                                      a.acct_entry_id
                                                     ) = p_gl_acct_code
                   AND TO_DATE (TO_CHAR (DECODE (p_tran_post,
                                                 'T', b.tran_date,
                                                 'P', b.posting_date
                                                ),
                                         'mm-yyyy'
                                        ),
                                'mm-yyyy'
                               ) = p_month_grp_date
                   AND DECODE (p_tran_post,
                               'T', b.tran_date,
                               'P', b.posting_date,
                               b.tran_date
                              ) BETWEEN TO_DATE (p_date_from, 'mm-dd-yyyy')
                                    AND TO_DATE (p_date_to, 'mm-dd-yyyy')
              GROUP BY a.sl_source_cd, a.sl_type_cd, a.sl_cd)
      LOOP
         v_list.sl_type_cd := i.sl_type_cd;
         v_list.sl_source_cd := i.sl_source_cd;
         v_list.sl_cd := i.sl_cd;
         v_list.debit := i.debit;
         v_list.credit := i.credit;
         v_list.cf_bal := i.cf_balance;

         IF i.sl_cd IS NOT NULL
         THEN
            IF i.sl_source_cd = '2'
            THEN
               FOR c1 IN (SELECT DECODE (payee_first_name,
                                         NULL, payee_last_name
                                          || ' '
                                          || payee_first_name
                                          || ' '
                                          || payee_middle_name
                                          || '  *',
                                            payee_last_name
                                         || ', '
                                         || payee_first_name
                                         || ' '
                                         || payee_middle_name
                                         || '  *'
                                        ) sl_nm
                            FROM giis_payees
                           WHERE payee_class_cd = i.sl_type_cd
                             AND payee_no = i.sl_cd)
               LOOP
                  v_sl_nm := c1.sl_nm;
                  EXIT;
               END LOOP;
            ELSE
               FOR c2 IN (SELECT sl_name sl_nm
                            FROM giac_sl_lists
                           WHERE sl_type_cd = i.sl_type_cd
                                 AND sl_cd = i.sl_cd)
               LOOP
                  v_sl_nm := c2.sl_nm;
                  EXIT;
               END LOOP;
            END IF;

--            IF UPPER(:MODE) = 'CHARACTER' THEN
--               v_sl_nm := REPLACE(v_sl_nm, '?', 'Y');
--            END IF;
            v_list.sl_name := v_sl_nm;
         ELSE
            v_list.sl_name := '_______No SL Code_______';
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_sl;

   FUNCTION get_tran_date (
      p_branch_cd        VARCHAR2,
      p_company          VARCHAR2,
      p_tran_class       VARCHAR2,
      p_sl_cd            VARCHAR2,
      p_sl_type_cd       VARCHAR2,
      p_tran_flag        VARCHAR2,
      p_tran_post        VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_gl_acct_code     VARCHAR2,
      p_month_grp_date   DATE
   )
      RETURN tran_date_tab PIPELINED
   IS
      v_list   tran_date_type;
   BEGIN
      FOR i IN (SELECT TRUNC (b.tran_date) tran_date
                  FROM giac_acct_entries a,
                       giac_acctrans b,
                       giac_order_of_payts c,
                       giac_disb_vouchers d,
                       giac_chart_of_accts e
                 WHERE a.gacc_tran_id = b.tran_id
                   AND a.gacc_tran_id = c.gacc_tran_id(+)
                   AND a.gacc_tran_id = d.gacc_tran_id(+)
                   AND a.gl_acct_id = e.gl_acct_id
				   AND NVL(a.sl_cd,0) = NVL(p_sl_cd,0) -- added by robert SR 19262 07.13.15
                   AND UPPER (a.gacc_gibr_branch_cd) =
                              UPPER (NVL (p_branch_cd, a.gacc_gibr_branch_cd))
                   AND a.gacc_gfun_fund_cd =
                                  UPPER (NVL (p_company, a.gacc_gfun_fund_cd))
                   AND b.tran_class = NVL (p_tran_class, b.tran_class)
                   AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
                   AND NVL (a.sl_type_cd, '-') =
                                   NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
                   AND b.tran_flag <> 'D'
                   AND b.tran_flag NOT IN (UPPER (p_tran_flag))
                   AND giacr202_pkg.get_gl_acct_code (a.gacc_tran_id,
                                                      a.acct_entry_id
                                                     ) = p_gl_acct_code
                   AND TO_DATE (TO_CHAR (DECODE (p_tran_post,
                                                 'T', b.tran_date,
                                                 'P', b.posting_date
                                                ),
                                         'mm-yyyy'
                                        ),
                                'mm-yyyy'
                               ) = p_month_grp_date
                   AND DECODE (p_tran_post,
                               'T', b.tran_date,
                               'P', b.posting_date,
                               b.tran_date
                              ) BETWEEN TO_DATE (p_date_from, 'mm-dd-yyyy')
                                    AND TO_DATE (p_date_to, 'mm-dd-yyyy'))
      LOOP
         v_list.tran_date := i.tran_date;
         PIPE ROW (v_list);
      END LOOP;
   END get_tran_date;

   FUNCTION get_details (
      p_branch_cd        VARCHAR2,
      p_company          VARCHAR2,
      p_tran_class       VARCHAR2,
      p_sl_cd            VARCHAR2,
      p_sl_type_cd       VARCHAR2,
      p_tran_flag        VARCHAR2,
      p_tran_post        VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_gl_acct_code     VARCHAR2,
      p_month_grp_date   DATE,
      p_tran_date        DATE
   )
      RETURN details_tab PIPELINED
   IS
      v_list        details_type;
      v_ref_no      VARCHAR2 (200);
      v_ctr         NUMBER (3)     := 0;
      v_exist_rev   NUMBER         := 0;
   BEGIN
      FOR i IN (SELECT a.gacc_tran_id, TRUNC (b.posting_date) posting_date,
                       DECODE (b.tran_class,
                               'COL', c.payor,
                               'DV', d.payee
                              ) NAME,
                       DECODE (p_tran_post,
                               'T', b.tran_date,
                               'P', b.posting_date
                              ) month_grp,
                       b.tran_class CLASS, b.tran_flag,
                       DECODE (b.tran_class,
                               'COL', NVL (c.particulars, b.particulars),
                               'DV', d.particulars,
                               'JV', b.particulars,
                               b.particulars
                              ) particulars,
                          c.or_pref_suf
                       || ' '
                       || LPAD (TO_CHAR (c.or_no), 10, '0') col_ref_no,
                       LPAD (TO_CHAR (b.tran_class_no), 10, '0') jv_ref_no,
                       get_ref_no (a.gacc_tran_id) cf_ref_no
                  FROM giac_acct_entries a,
                       giac_acctrans b,
                       giac_order_of_payts c,
                       giac_disb_vouchers d,
                       giac_chart_of_accts e
                 WHERE a.gacc_tran_id = b.tran_id
                   AND a.gacc_tran_id = c.gacc_tran_id(+)
                   AND a.gacc_tran_id = d.gacc_tran_id(+)
                   AND a.gl_acct_id = e.gl_acct_id
				   AND NVL(a.sl_cd,0) = NVL(p_sl_cd,0) -- added by robert SR 19262 07.13.15
                   AND UPPER (a.gacc_gibr_branch_cd) =
                              UPPER (NVL (p_branch_cd, a.gacc_gibr_branch_cd))
                   AND a.gacc_gfun_fund_cd =
                                  UPPER (NVL (p_company, a.gacc_gfun_fund_cd))
                   AND b.tran_class = NVL (p_tran_class, b.tran_class)
                   AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
                   AND NVL (a.sl_type_cd, '-') =
                                   NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
                   AND b.tran_flag <> 'D'
                   AND b.tran_flag NOT IN (UPPER (p_tran_flag))
                   AND giacr202_pkg.get_gl_acct_code (a.gacc_tran_id,
                                                      a.acct_entry_id
                                                     ) = p_gl_acct_code
                   AND TO_DATE (TO_CHAR (DECODE (p_tran_post,
                                                 'T', b.tran_date,
                                                 'P', b.posting_date
                                                ),
                                         'mm-yyyy'
                                        ),
                                'mm-yyyy'
                               ) = p_month_grp_date
                   AND TRUNC (b.tran_date) = p_tran_date
                   AND DECODE (p_tran_post,
                               'T', b.tran_date,
                               'P', b.posting_date,
                               b.tran_date
                              ) BETWEEN TO_DATE (p_date_from, 'mm-dd-yyyy')
                                    AND TO_DATE (p_date_to, 'mm-dd-yyyy'))
      LOOP
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.posting_date := i.posting_date;
         v_list.NAME := i.NAME;
         v_list.particulars := i.particulars;
         v_list.tran_flag := i.tran_flag;
         v_list.col_ref_no := i.col_ref_no;
         v_list.jv_ref_no := i.jv_ref_no;
         v_list.cf_ref_no := NULL;

         BEGIN
            BEGIN
               SELECT 1
                 INTO v_exist_rev
                 FROM giac_reversals
                WHERE reversing_tran_id = i.gacc_tran_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_exist_rev := 0;
            END;

            IF v_exist_rev = 1
            THEN
               BEGIN
                  SELECT    'REV-'
                         || tran_year
                         || '-'
                         || tran_month
                         || '-'
                         || tran_seq_no
                    INTO v_ref_no
                    FROM giac_acctrans
                   WHERE tran_id = i.gacc_tran_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_ref_no := NULL;
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_ref_no := v_ref_no;
               END;
            ELSE
               IF p_tran_class = 'COL'
               THEN
                  v_list.cf_ref_no :=
                        i.col_ref_no || ' / ' || LPAD (i.gacc_tran_id, 12, 0);
               ELSIF p_tran_class = 'DV'
               THEN
                  BEGIN
                     SELECT    a.dv_pref
                            || '-'
                            || LPAD (TO_CHAR (a.dv_no), 10, '0')
                            || '/'
                            || b.check_pref_suf
                            || '-'
                            || LPAD (TO_CHAR (b.check_no), 10, '0')
                       INTO v_ref_no
                       FROM giac_disb_vouchers a, giac_chk_disbursement b
                      WHERE b.check_stat = 2
                        AND a.gacc_tran_id = b.gacc_tran_id
                        AND a.gacc_tran_id = i.gacc_tran_id;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        SELECT    document_cd
                               || '-'
                               || branch_cd
                               || '-'
                               || LPAD (TO_CHAR (doc_year), 4, '0')
                               || '-'
                               || LPAD (TO_CHAR (doc_mm), 2, '0')
                               || '-'
                               || LPAD (TO_CHAR (doc_seq_no), 6, '0')
                          INTO v_ref_no
                          FROM giac_payt_requests a, giac_payt_requests_dtl b
                         WHERE a.ref_id = b.gprq_ref_id
                           AND tran_id = i.gacc_tran_id;
                     WHEN TOO_MANY_ROWS
                     THEN
                        FOR x IN (SELECT    a.dv_pref
                                         || '-'
                                         || LPAD (TO_CHAR (a.dv_no), 10, '0')
                                         || '/'
                                         || b.check_pref_suf
                                         || '-'
                                         || LPAD (TO_CHAR (b.check_no),
                                                  10,
                                                  '0'
                                                 ) refno
                                    FROM giac_disb_vouchers a,
                                         giac_chk_disbursement b
                                   WHERE b.check_stat = 2
                                     AND a.gacc_tran_id = b.gacc_tran_id
                                     AND a.gacc_tran_id = i.gacc_tran_id)
                        LOOP
                           v_ctr := v_ctr + 1;

                           IF v_ctr > 1
                           THEN
                              v_ref_no := v_ref_no || CHR (10) || x.refno;
                           END IF;
                        END LOOP;
                  END;
               ELSIF p_tran_class = 'JV'
               THEN
                  BEGIN
                     SELECT    DECODE (ref_jv_no,
                                       NULL, NULL,
                                       ref_jv_no || ' / '
                                      )
                            || tran_year
                            || '-'
                            || tran_month
                            || '-'
                            || tran_seq_no
                            || ' / '
                            || jv_pref_suff
                            || '-'
                            || LPAD (TO_CHAR (jv_no), 6, '0')
                       INTO v_ref_no
                       FROM giac_acctrans
                      WHERE tran_id = i.gacc_tran_id;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_ref_no := NULL;
                     WHEN TOO_MANY_ROWS
                     THEN
                        v_ref_no := v_ref_no;
                  END;
               ELSE
                  v_ref_no := i.jv_ref_no;
               END IF;
            END IF;
            
            IF v_list.cf_ref_no IS NULL THEN
               v_list.cf_ref_no := v_ref_no || ' / ' || LPAD (i.gacc_tran_id, 12, 0);
            END IF;   
         END;

         PIPE ROW (v_list);
      END LOOP;
   END get_details;
   
   FUNCTION get_amounts (
      p_branch_cd        VARCHAR2,
      p_company          VARCHAR2,
      p_tran_class       VARCHAR2,
      p_sl_cd            VARCHAR2,
      p_sl_type_cd       VARCHAR2,
      p_tran_flag        VARCHAR2,
      p_tran_post        VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_gl_acct_code     VARCHAR2,
      p_month_grp_date   DATE,
      p_tran_date        DATE,
      p_gacc_tran_id     NUMBER
   )
      RETURN amounts_tab PIPELINED
   IS
      v_list amounts_type;
   BEGIN
      FOR i IN (SELECT NVL (a.debit_amt, 0) debit,
                       NVL (a.credit_amt, 0) credit,
                       NVL (a.debit_amt, 0) - NVL (a.credit_amt, 0) cf_balance,
                       a.gacc_tran_id
                  FROM giac_acct_entries a,
                       giac_acctrans b,
                       giac_order_of_payts c,
                       giac_disb_vouchers d,
                       giac_chart_of_accts e
                 WHERE a.gacc_tran_id = b.tran_id
                   AND a.gacc_tran_id = c.gacc_tran_id(+)
                   AND a.gacc_tran_id = d.gacc_tran_id(+)
                   AND a.gl_acct_id = e.gl_acct_id
				   AND NVL(a.sl_cd,0) = NVL(p_sl_cd,0) -- added by robert SR 19262 07.13.15
                   AND UPPER (a.gacc_gibr_branch_cd) =
                              UPPER (NVL (p_branch_cd, a.gacc_gibr_branch_cd))
                   AND a.gacc_gfun_fund_cd =
                                  UPPER (NVL (p_company, a.gacc_gfun_fund_cd))
                   AND b.tran_class = NVL (p_tran_class, b.tran_class)
                   AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
                   AND NVL (a.sl_type_cd, '-') =
                                   NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
                   AND b.tran_flag <> 'D'
                   AND b.tran_flag NOT IN (UPPER (p_tran_flag))
                   AND giacr202_pkg.get_gl_acct_code (a.gacc_tran_id,
                                                      a.acct_entry_id
                                                     ) = p_gl_acct_code
                   AND TO_DATE (TO_CHAR (DECODE (p_tran_post,
                                                 'T', b.tran_date,
                                                 'P', b.posting_date
                                                ),
                                         'mm-yyyy'
                                        ),
                                'mm-yyyy'
                               ) = p_month_grp_date
                   AND TRUNC (b.tran_date) = p_tran_date
                   AND a.gacc_tran_id = p_gacc_tran_id
                   AND DECODE (p_tran_post,
                               'T', b.tran_date,
                               'P', b.posting_date,
                               b.tran_date
                              ) BETWEEN TO_DATE (p_date_from, 'mm-dd-yyyy')
                                    AND TO_DATE (p_date_to, 'mm-dd-yyyy'))
      LOOP
         v_list.debit := i.debit;
         v_list.credit := i.credit;
         v_list.cf_bal := i.cf_balance;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_amounts;   
END;
/
