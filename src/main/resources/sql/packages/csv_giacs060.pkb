CREATE OR REPLACE PACKAGE BODY CPI.csv_giacs060
AS
   FUNCTION csv_giacr060 (
      p_dt_basis           NUMBER,
      p_consolidate        VARCHAR2,
      p_branch_cd          VARCHAR2,
      p_fund_cd            VARCHAR2,
      p_gl_acct_category   NUMBER,
      p_gl_control_acct    NUMBER,
      p_gl_acct_1          NUMBER,
      p_gl_acct_2          NUMBER,
      p_gl_acct_3          NUMBER,
      p_gl_acct_4          NUMBER,
      p_gl_acct_5          NUMBER,
      p_gl_acct_6          NUMBER,
      p_gl_acct_7          NUMBER,
      p_tran_class         VARCHAR2,
      p_eotran             VARCHAR2,
      p_fromdate           DATE,
      p_todate             DATE,
      p_user_id            VARCHAR2,
      p_module_id          VARCHAR2 -- jhing 01.28.2016 added p_user_id, p_module_id GENQA 5280,5200
   )
      RETURN giacr060_type PIPELINED
   IS
      v_giacr060    giacr060_rec_type;
      v_month_grp   VARCHAR2 (100);
      v_branch_accessible  VARCHAR2 (2000);  -- jhing 01.29.2016 -- GENQA 5280, 5200
   BEGIN
   
      v_branch_accessible  := giacr060_pkg.get_Branch_WithAccess (p_module_id, p_user_id );  -- jhing 01.29.2016 GENQA 5280,5200   
   
      FOR rec IN (SELECT      TO_CHAR (a.gl_acct_category)   -- jhing 01.29.2016 added padding to make it consistent with screen
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
                           || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00')) gl_acct_code,
                           e.gl_acct_name gl_acct_name,
                           DECODE (p_dt_basis,
                                   1, TO_CHAR (b.tran_date, 'MM YYYY'),
                                   2, TO_CHAR (b.posting_date, 'MM YYYY')
                                  ) month_grp,
                           b.tran_class, SUM (a.debit_amt) sum_debit,
                           SUM (a.credit_amt) sum_credit,
                             NVL (SUM (a.debit_amt), 0)
                           - NVL (SUM (a.credit_amt), 0) balance
                      FROM giac_chart_of_accts e,
                           giac_acctrans b,
                           giac_acct_entries a
                     WHERE a.gacc_tran_id = b.tran_id
                       AND a.gacc_gibr_branch_cd =
                              DECODE (p_consolidate,
                                      'N', p_branch_cd,
                                      a.gacc_gibr_branch_cd
                                     )
                       AND a.gacc_gibr_branch_cd IN (SELECT *
                                                    FROM TABLE (
                                                            SPLIT_COMMA_SEPARATED_STRING (
                                                                                 v_branch_accessible)))     -- added by jhing GENQA 5280,5200         
                       AND a.gacc_gfun_fund_cd = p_fund_cd
                       AND a.gl_acct_category = NVL (p_gl_acct_category, a.gl_acct_category) -- added NVL Mildred 11.07.2012
                       AND a.gl_control_acct =
                                    NVL (p_gl_control_acct, a.gl_control_acct)
                       AND a.gl_sub_acct_1 =
                                            NVL (p_gl_acct_1, a.gl_sub_acct_1)
                       AND a.gl_sub_acct_2 =
                                            NVL (p_gl_acct_2, a.gl_sub_acct_2)
                       AND a.gl_sub_acct_3 =
                                            NVL (p_gl_acct_3, a.gl_sub_acct_3)
                       AND a.gl_sub_acct_4 =
                                            NVL (p_gl_acct_4, a.gl_sub_acct_4)
                       AND a.gl_sub_acct_5 =
                                            NVL (p_gl_acct_5, a.gl_sub_acct_5)
                       AND a.gl_sub_acct_6 =
                                            NVL (p_gl_acct_6, a.gl_sub_acct_6)
                       AND a.gl_sub_acct_7 =
                                            NVL (p_gl_acct_7, a.gl_sub_acct_7)
                       AND b.tran_class = NVL (p_tran_class, b.tran_class)
                       AND a.gl_acct_id = e.gl_acct_id
                       AND b.tran_flag <> 'D'
                       AND b.tran_flag NOT IN (p_eotran)
                       AND DECODE (p_dt_basis,
                                   1, TRUNC (b.tran_date),
                                   2, b.posting_date,
                                   TRUNC (b.tran_date)
                                  ) BETWEEN p_fromdate AND p_todate
                  -- jeremy 05132010: added TRUNC in tran_date, pnbgen prf 4948
                  GROUP BY a.gl_acct_category,
                           a.gl_control_acct,
                           a.gl_sub_acct_1,
                           a.gl_sub_acct_2,
                           a.gl_sub_acct_3,
                           a.gl_sub_acct_4,
                           a.gl_sub_acct_5,
                           a.gl_sub_acct_6,
                           a.gl_sub_acct_7,
                           e.gl_acct_name,
                           DECODE (p_dt_basis,
                                   1, TO_CHAR (b.tran_date, 'MM YYYY'),
                                   2, TO_CHAR (b.posting_date, 'MM YYYY')
                                  ),
                           b.tran_class
                  ORDER BY    TO_CHAR (a.gl_acct_category)
                           || '-'
                           || TO_CHAR (a.gl_control_acct)
                           || '-'
                           || TO_CHAR (a.gl_sub_acct_1)
                           || '-'
                           || TO_CHAR (a.gl_sub_acct_2)
                           || '-'
                           || TO_CHAR (a.gl_sub_acct_3)
                           || '-'
                           || TO_CHAR (a.gl_sub_acct_4)
                           || '-'
                           || TO_CHAR (a.gl_sub_acct_5)
                           || '-'
                           || TO_CHAR (a.gl_sub_acct_6)
                           || '-'
                           || TO_CHAR (a.gl_sub_acct_7),
                           DECODE (p_dt_basis,
                                   1, TO_CHAR (b.tran_date, 'MM YYYY'),
                                   2, TO_CHAR (b.posting_date, 'MM YYYY')
                                  ),
                           b.tran_class)
      LOOP
         v_month_grp :=
                  TO_CHAR (TO_DATE (rec.month_grp, 'MMYYYY'), 'FmMonth YYYY');
         v_giacr060.gl_account := rec.gl_acct_code;
         v_giacr060.gl_account_name := rec.gl_acct_name;
         v_giacr060.month_grp := v_month_grp;
         v_giacr060.tran_class := rec.tran_class;
         v_giacr060.debit_amt := rec.sum_debit;
         v_giacr060.credit_amt := rec.sum_credit;
         v_giacr060.balance := rec.balance;
         PIPE ROW (v_giacr060);
      END LOOP;

      RETURN;
   END;

----------------------------------------------------------------------
   FUNCTION csv_giacr061 (
      p_dt_basis           NUMBER,
      p_consolidate        VARCHAR2,
      p_branch_cd          VARCHAR2,
      p_fund_cd            VARCHAR2,
      p_gl_acct_category   NUMBER,
      p_gl_control_acct    NUMBER,
      p_gl_acct_1          NUMBER,
      p_gl_acct_2          NUMBER,
      p_gl_acct_3          NUMBER,
      p_gl_acct_4          NUMBER,
      p_gl_acct_5          NUMBER,
      p_gl_acct_6          NUMBER,
      p_gl_acct_7          NUMBER,
      p_tran_class         VARCHAR2,
      p_sl_cd              NUMBER,
      p_sl_type_cd         VARCHAR2,
      p_eotran             VARCHAR2,
      p_fromdate           DATE,
      p_todate             DATE,
      p_user_id            VARCHAR2,
      p_module_id          VARCHAR2 -- jhing 01.28.2016 added p_user_id, p_module_id GENQA 5280,5200
   )
      RETURN giacr061_type PIPELINED
   IS
      v_giacr061    giacr061_rec_type;
      v_month_grp   VARCHAR2 (100);
      v_sl_cd       GIAC_SL_LISTS.SL_cd%type; -- VARCHAR2 (20); adpascual 08302012
      v_sl_name     GIAC_SL_LISTS.SL_NAME%type; -- VARCHAR2 (160); adpascual 08302012
      v_branch_accessible  VARCHAR2 (2000);  -- jhing 01.29.2016 -- GENQA 5280, 5200
   BEGIN
   
      v_branch_accessible  := giacr060_pkg.get_Branch_WithAccess (p_module_id, p_user_id );  -- jhing 01.29.2016 GENQA 5280,5200  
      
      FOR rec IN (SELECT      TO_CHAR (a.gl_acct_category)
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
                           e.gl_acct_name gl_acct_name,
                           DECODE (p_dt_basis,
                                   1, TO_CHAR (b.tran_date, 'MM YYYY'),
                                   2, TO_CHAR (b.posting_date, 'MM YYYY')
                                  ) month_grp,
                           b.tran_class, a.sl_source_cd sl_source_cd,
                           a.sl_type_cd sl_type_cd, a.sl_cd sl_cd,
                           NVL (SUM (a.debit_amt), 0) sum_debit,
                           NVL (SUM (a.credit_amt), 0) sum_credit,
                             NVL (SUM (a.debit_amt), 0)
                           - NVL (SUM (a.credit_amt), 0) balance
                      FROM giac_chart_of_accts e,
                           giac_acctrans b,
                           giac_acct_entries a
                     WHERE a.gacc_tran_id = b.tran_id
                       AND a.gacc_gibr_branch_cd =
                              DECODE (p_consolidate,
                                      'N', p_branch_cd,
                                      a.gacc_gibr_branch_cd
                                     )                       
                       AND a.gacc_gibr_branch_cd IN (SELECT *
                                                    FROM TABLE (
                                                            SPLIT_COMMA_SEPARATED_STRING (
                                                                                 v_branch_accessible)))     -- added by jhing GENQA 5280,5200 
                       AND a.gacc_gfun_fund_cd = p_fund_cd
                       AND a.gl_acct_category = NVL (p_gl_acct_category, a.gl_acct_category) -- added NVL Mildred 11.07.2012
                       AND a.gl_control_acct =
                                    NVL (p_gl_control_acct, a.gl_control_acct)
                       AND a.gl_sub_acct_1 =
                                            NVL (p_gl_acct_1, a.gl_sub_acct_1)
                       AND a.gl_sub_acct_2 =
                                            NVL (p_gl_acct_2, a.gl_sub_acct_2)
                       AND a.gl_sub_acct_3 =
                                            NVL (p_gl_acct_3, a.gl_sub_acct_3)
                       AND a.gl_sub_acct_4 =
                                            NVL (p_gl_acct_4, a.gl_sub_acct_4)
                       AND a.gl_sub_acct_5 =
                                            NVL (p_gl_acct_5, a.gl_sub_acct_5)
                       AND a.gl_sub_acct_6 =
                                            NVL (p_gl_acct_6, a.gl_sub_acct_6)
                       AND a.gl_sub_acct_7 =
                                            NVL (p_gl_acct_7, a.gl_sub_acct_7)
                       AND b.tran_class = NVL (p_tran_class, b.tran_class)
                       AND a.gl_acct_id = e.gl_acct_id
                       AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
                       AND NVL (a.sl_type_cd, '-') =
                                   NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
                       AND b.tran_flag <> 'D'
                       AND b.tran_flag NOT IN (p_eotran)
                       AND DECODE (p_dt_basis,
                                   1, TRUNC (b.tran_date),
                                   2, b.posting_date,
                                   TRUNC (b.tran_date)
                                  ) BETWEEN p_fromdate AND p_todate
                  -- jeremy 05132010: added TRUNC in tran_date, pnbgen prf 4948
                  GROUP BY a.gl_acct_category,
                           a.gl_control_acct,
                           a.gl_sub_acct_1,
                           a.gl_sub_acct_2,
                           a.gl_sub_acct_3,
                           a.gl_sub_acct_4,
                           a.gl_sub_acct_5,
                           a.gl_sub_acct_6,
                           a.gl_sub_acct_7,
                           e.gl_acct_name,
                           a.sl_source_cd,
                           a.sl_type_cd,
                           a.sl_cd,
                           DECODE (p_dt_basis,
                                   1, TO_CHAR (b.tran_date, 'MM YYYY'),
                                   2, TO_CHAR (b.posting_date, 'MM YYYY')
                                  ),
                           b.tran_class
                  ORDER BY    TO_CHAR (a.gl_acct_category)
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
                           DECODE (p_dt_basis,
                                   1, TO_CHAR (b.tran_date, 'MM YYYY'),
                                   2, TO_CHAR (b.posting_date, 'MM YYYY')
                                  ),
                           b.tran_class)
      LOOP
         v_month_grp :=
                  TO_CHAR (TO_DATE (rec.month_grp, 'MMYYYY'), 'FmMonth YYYY');

         --get SL Code and SL Name
         IF rec.sl_cd IS NOT NULL
         THEN
            IF rec.sl_source_cd = '2'
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
                                        ) sl_nm,
                                 payee_no
                            FROM giis_payees
                           WHERE payee_class_cd = rec.sl_type_cd
                             AND payee_no = rec.sl_cd)
               LOOP
                  v_sl_cd := c1.payee_no;
                  v_sl_name := c1.sl_nm;
               END LOOP;
            ELSE
               FOR c2 IN (SELECT sl_name sl_nm, sl_cd
                            FROM giac_sl_lists
                           WHERE sl_type_cd = rec.sl_type_cd
                             AND sl_cd = rec.sl_cd)
               LOOP
                  v_sl_cd := c2.sl_cd;
                  v_sl_name := c2.sl_nm;
               END LOOP;
            END IF;
         ELSE
            v_sl_name := 'No SL Code';
         END IF;

         v_giacr061.gl_account := rec.gl_acct_code;
         v_giacr061.gl_account_name := rec.gl_acct_name;
         v_giacr061.month_grp := v_month_grp;
         v_giacr061.tran_class := rec.tran_class;
         v_giacr061.sl_cd := v_sl_cd;
         v_giacr061.sl_name := v_sl_name;
         v_giacr061.debit_amt := rec.sum_debit;
         v_giacr061.credit_amt := rec.sum_credit;
         v_giacr061.balance := rec.balance;
         PIPE ROW (v_giacr061);
      END LOOP;

      RETURN;
   END;

----------------------------------------------------------------------
  -- START added by Jayson 11.04.2011 --
   FUNCTION csv_giacr062 (
      p_branch       VARCHAR2,
      p_company      VARCHAR2,
      p_category     VARCHAR2,
      p_control      VARCHAR2,
      p_sub_1        VARCHAR2,
      p_sub_2        VARCHAR2,
      p_sub_3        VARCHAR2,
      p_sub_4        VARCHAR2,
      p_sub_5        VARCHAR2,
      p_sub_6        VARCHAR2,
      p_sub_7        VARCHAR2,
      p_tran_class   VARCHAR2,
      p_tran_flag    VARCHAR2,
      p_dt_basis     NUMBER,
      p_date1        DATE,
      p_date2        DATE,
      p_user_id      VARCHAR2, -- jhing 01.28.2016 added p_user_id, p_module_id GENQA 5280,5200
      p_module_id    VARCHAR2 
   )
      RETURN giacr062_table_type PIPELINED
   IS
      v_giacr062_record   giacr062_rec_type;
      v_ref_no            VARCHAR2(32767); --VARCHAR2(50), --edited by gab 09.28.2015
      v_ctr               NUMBER (3)        := 0;
      v_branch_accessible  VARCHAR2 (2000);  -- jhing 01.29.2016 -- GENQA 5280, 5200
   BEGIN
   
      v_branch_accessible  := giacr060_pkg.get_Branch_WithAccess (p_module_id, p_user_id );  -- jhing 01.29.2016 GENQA 5280,5200   
   
      FOR rec1 IN
         (SELECT   a.gacc_tran_id, LPAD (a.gacc_tran_id, 12, 0) tran_id,
                      TO_CHAR (a.gl_acct_category)
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
                   || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00')) gl_acct_code,
                   e.gl_acct_name gl_acct_name,
                   TO_CHAR (DECODE (p_dt_basis,
                                    1, TRUNC (b.tran_date),
                                    2, TRUNC (b.posting_date)
                                   ),
                            'MM-DD-YYYY'
                           ) pdate,
                   b.tran_class CLASS,
                      c.or_pref_suf
                   || '-'
                   || LPAD (TO_CHAR (c.or_no), 10, '0') col_ref_no,
                   LPAD (TO_CHAR (b.tran_class_no), 10, '0') jv_ref_no,
                   DECODE (b.tran_class,
                           'COL', c.particulars,
                           'DV', d.particulars,
                           'JV', b.particulars,
                           b.particulars
                          ) particulars,
                   SUM (a.debit_amt) debit, SUM (a.credit_amt) credit,
                   SUM (a.debit_amt - a.credit_amt) balance, 
                   b.jv_pref, b.jv_seq_no -- added by gab 09.14.2015
              FROM giac_chart_of_accts e,
                   giac_disb_vouchers d,
                   giac_order_of_payts c,
                   giac_acctrans b,
                   giac_acct_entries a
             WHERE a.gacc_tran_id = b.tran_id
               AND a.gacc_tran_id = c.gacc_tran_id(+)
               AND a.gacc_tran_id = d.gacc_tran_id(+)
               AND a.gacc_gibr_branch_cd =
                                         NVL (p_branch, a.gacc_gibr_branch_cd)
               AND a.gacc_gibr_branch_cd IN (SELECT *
                                                    FROM TABLE (
                                                            SPLIT_COMMA_SEPARATED_STRING (
                                                                                 v_branch_accessible)))     -- added by jhing GENQA 5280,5200                                          
               AND a.gacc_gfun_fund_cd = p_company
               AND a.gl_acct_category = NVL (p_category, a.gl_acct_category)
               AND a.gl_control_acct = NVL (p_control, a.gl_control_acct)
               AND a.gl_sub_acct_1 = NVL (p_sub_1, a.gl_sub_acct_1)
               AND a.gl_sub_acct_2 = NVL (p_sub_2, a.gl_sub_acct_2)
               AND a.gl_sub_acct_3 = NVL (p_sub_3, a.gl_sub_acct_3)
               AND a.gl_sub_acct_4 = NVL (p_sub_4, a.gl_sub_acct_4)
               AND a.gl_sub_acct_5 = NVL (p_sub_5, a.gl_sub_acct_5)
               AND a.gl_sub_acct_6 = NVL (p_sub_6, a.gl_sub_acct_6)
               AND a.gl_sub_acct_7 = NVL (p_sub_7, a.gl_sub_acct_7)
               AND b.tran_class = NVL (p_tran_class, b.tran_class)
               AND a.gl_acct_id = e.gl_acct_id
               AND b.tran_flag <> 'D'
               AND b.tran_flag NOT IN (p_tran_flag)
               AND DECODE (p_dt_basis,
                           1, TO_CHAR (b.tran_date, 'YYYY-MM-DD'),
                           2, TO_CHAR (b.posting_date, 'YYYY-MM-DD'),
                           TO_CHAR (b.tran_date, 'YYYY-MM-DD')
                          ) BETWEEN TO_CHAR (p_date1, 'YYYY-MM-DD')
                                AND TO_CHAR (p_date2, 'YYYY-MM-DD')
          GROUP BY a.gacc_tran_id,
                   LPAD (a.gacc_tran_id, 12, 0),
                      TO_CHAR (a.gl_acct_category)
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
                   TO_CHAR (DECODE (p_dt_basis,
                                    1, TRUNC (b.tran_date),
                                    2, TRUNC (b.posting_date)
                                   ),
                            'MM-DD-YYYY'
                           ),
                   b.tran_class,
                   c.or_pref_suf || '-' || LPAD (TO_CHAR (c.or_no), 10, '0'),
                   LPAD (TO_CHAR (b.tran_class_no), 10, '0'),
                   DECODE (b.tran_class,
                           'COL', c.particulars,
                           'DV', d.particulars,
                           'JV', b.particulars,
                           b.particulars
                          ), b.jv_pref, b.jv_seq_no -- added by gab 09.14.2015
          ORDER BY 3, 1)
      LOOP
         --get ref_no
         IF rec1.CLASS = 'COL'
         THEN
            v_ref_no := rec1.col_ref_no;
         ELSIF rec1.CLASS = 'DV'
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
                  AND a.gacc_tran_id = rec1.tran_id;
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
                   WHERE a.ref_id = b.gprq_ref_id AND tran_id = rec1.tran_id;
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
                               AND a.gacc_tran_id = rec1.tran_id)
                  LOOP
                     v_ctr := v_ctr + 1;

                     IF v_ctr > 1
                     THEN
                        v_ref_no := v_ref_no || CHR (10) || x.refno;
                     END IF;
                  END LOOP;
            END;
         ELSIF rec1.CLASS = 'JV'
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
                WHERE tran_id = rec1.tran_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ref_no := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_ref_no := v_ref_no;
            END;
         ELSE
            v_ref_no := get_ref_no (rec1.gacc_tran_id);
         END IF;

         v_giacr062_record.gl_account := rec1.gl_acct_code;
         v_giacr062_record.gl_account_name := rec1.gl_acct_name;
         v_giacr062_record.tran_date := rec1.pdate;
         v_giacr062_record.tran_class := rec1.CLASS;
         v_giacr062_record.ref_no := v_ref_no;
         v_giacr062_record.tran_id := rec1.tran_id;
         v_giacr062_record.particulars := rec1.particulars;
         v_giacr062_record.debit_amt := rec1.debit;
         v_giacr062_record.credit_amt := rec1.credit;
         v_giacr062_record.balance := rec1.balance;
         v_giacr062_record.jv_ref_no := rec1.jv_pref || ' ' || LPAD(TO_CHAR(rec1.jv_seq_no), 12, '0'); --added by gab 09.14.2015
         PIPE ROW (v_giacr062_record);
      END LOOP;

      RETURN;
   END;

   -- END added by Jayson 11.04.2011 --
----------------------------------------------------------------------
  
/* Modified by : Abegail Pascual
   Date        : 08.16.2012
   Description : 
    added a select to check if tran_id exist on giac_reversal
    if it does exist, system will generate a reference no. using REV-tran_yy-tran_mo-tran_seq
    if not, system will generate based on tran class (usual process - old code)
    added modification made by edision dated 1005201z
*/   
    FUNCTION csv_giacr201 (
      p_dt_basis           NUMBER,
      p_consolidate        VARCHAR2,
      p_branch_cd          VARCHAR2,
      p_fund_cd            VARCHAR2,
      p_gl_acct_category   NUMBER,
      p_gl_control_acct    NUMBER,
      p_gl_acct_1          NUMBER,
      p_gl_acct_2          NUMBER,
      p_gl_acct_3          NUMBER,
      p_gl_acct_4          NUMBER,
      p_gl_acct_5          NUMBER,
      p_gl_acct_6          NUMBER,
      p_gl_acct_7          NUMBER,
      p_tran_class         VARCHAR2,
      p_eotran             VARCHAR2,
      p_fromdate           DATE,
      p_todate             DATE,
      p_begbal             VARCHAR2, --added by jhing 01.28.2016 from temp solution done by vondanix RSIC 20691 12.09.2015
      p_user_id            VARCHAR2, -- jhing 01.28.2016 added p_user_id, p_module_id GENQA 5280,5200
      p_module_id          VARCHAR2 
   )
      RETURN giacr201_type PIPELINED
   IS
      v_giacr201    giacr201_rec_type;
      v_month_grp   VARCHAR2 (100);
      v_tran_date   VARCHAR2 (50);
      v_date_post   VARCHAR2 (50);
      v_ref_no      VARCHAR2(32767); --VARCHAR2(50), --gab
      v_exist_rev   NUMBER := 0; -- adpascual 08162012
      v_ctr               NUMBER (3)        := 0; -- added by gab 09.28.2015
      
      v_branch_accessible  VARCHAR2 (2000);  -- jhing 01.29.2016 -- GENQA 5280, 5200
      
   BEGIN
   
      
      v_branch_accessible  := giacr060_pkg.get_Branch_WithAccess (p_module_id, p_user_id );  -- jhing 01.29.2016 GENQA 5280,5200  
      
      FOR rec IN (SELECT   LPAD(A.GACC_TRAN_ID,12,0) TRAN_ID,
                              TO_CHAR (a.gl_acct_category)
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
                           e.gl_acct_name gl_acct_name,
                           DECODE (p_dt_basis,
                                   1, TO_CHAR (b.tran_date, 'MM YYYY'),
                                   2, TO_CHAR (b.posting_date, 'MM YYYY')
                                  ) month_grp,
                           b.tran_class,
                           TO_CHAR (TRUNC (b.tran_date),
                                    'MM-DD-YYYY'
                                   ) tran_date,
                           TO_CHAR (TRUNC (b.posting_date),
                                    'MM-DD-YYYY'
                                   ) date_posted,
                           DECODE (b.tran_class,
                                   'COL', c.payor,
                                   'DV', d.payee
                                  ) pname,
                           b.tran_flag flag,
                           DECODE (b.tran_class,
                                   'COL', c.particulars,
                                   'DV', d.particulars,
                                   'JV', b.particulars,
                                   b.particulars
                                  ) particulars,
C.OR_PREF_SUF || ' ' || LPAD(TO_CHAR(C.OR_NO),10,'0') COL_REF_NO, -- added LPAD Mildred 11.07.2012 consolidate BIR enh
LPAD(TO_CHAR(B.TRAN_CLASS_NO),10,'0') JV_REF_NO, -- added LPAD Mildred 11.07.2012 consolidate BIR enh
                           /*c.or_pref_suf || ' '
                           || TO_CHAR (c.or_no) col_ref_no,
                           TO_CHAR (b.tran_class_no) jv_ref_no,*/ -- comment by Mildred 11.07.2012 consolidate BIR enh
                           NVL (a.debit_amt, 0) debit,
                           NVL (a.credit_amt, 0) credit,
                             NVL (a.debit_amt, 0)
                           - NVL (a.credit_amt, 0) balance,
                            b.jv_pref, b.jv_seq_no
                      FROM giac_chart_of_accts e,
                           giac_disb_vouchers d,
                           giac_order_of_payts c,
                           giac_acctrans b,
                           giac_acct_entries a
                     WHERE a.gacc_tran_id = b.tran_id
                       AND a.gacc_tran_id = c.gacc_tran_id(+)
                       AND a.gacc_tran_id = d.gacc_tran_id(+)
                       AND a.gacc_gibr_branch_cd =
                              DECODE (p_consolidate,
                                      'N', p_branch_cd,
                                      a.gacc_gibr_branch_cd
                                     )
                       AND a.gacc_gibr_branch_cd IN (SELECT *
                                                    FROM TABLE (
                                                            SPLIT_COMMA_SEPARATED_STRING (
                                                                                 v_branch_accessible)))     -- added by jhing GENQA 5280,5200                                     
                       AND a.gacc_gfun_fund_cd = p_fund_cd
                       AND a.gl_acct_category = NVL (p_gl_acct_category, a.gl_acct_category) -- added NVL Mildred 11.07.2012
                       AND a.gl_control_acct =
                                    NVL (p_gl_control_acct, a.gl_control_acct)
                       AND a.gl_sub_acct_1 =
                                            NVL (p_gl_acct_1, a.gl_sub_acct_1)
                       AND a.gl_sub_acct_2 =
                                            NVL (p_gl_acct_2, a.gl_sub_acct_2)
                       AND a.gl_sub_acct_3 =
                                            NVL (p_gl_acct_3, a.gl_sub_acct_3)
                       AND a.gl_sub_acct_4 =
                                            NVL (p_gl_acct_4, a.gl_sub_acct_4)
                       AND a.gl_sub_acct_5 =
                                            NVL (p_gl_acct_5, a.gl_sub_acct_5)
                       AND a.gl_sub_acct_6 =
                                            NVL (p_gl_acct_6, a.gl_sub_acct_6)
                       AND a.gl_sub_acct_7 =
                                            NVL (p_gl_acct_7, a.gl_sub_acct_7)
                       AND b.tran_class = NVL (p_tran_class, b.tran_class)
                       AND a.gl_acct_id = e.gl_acct_id
                       AND b.tran_flag <> 'D'
                       AND b.tran_flag NOT IN (p_eotran)
                       AND DECODE (p_dt_basis,
                                   1, TRUNC (b.tran_date),
                                   2, b.posting_date,
                                   TRUNC (b.tran_date)
                                  ) BETWEEN p_fromdate AND p_todate
                  -- jeremy 05132010: added TRUNC in tran_date, pnbgen prf 4948
       UNION ALL --added by vondanix RSIC 20691 12.09.2015 : to include Beginning Balance in CSV report.
        SELECT  NULL "TRAN_ID", TO_CHAR (a.gl_acct_category)
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
                           || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00')) GL_ACCT_CODE, 
                c.gl_acct_name "GL_ACCT_NAME", NULL "MONTH_GRP", NULL "TRAN_CLASS",NULL "TRAN_DATE", 
                NULL "DATE_POSTED", NULL "PNAME", NULL "FLAG", 'BEGINNING BALANCE' "PARTICULARS", NULL "COL_REF_NO", NULL "JV_REF_NO",
                NVL (SUM (A.DEBIT_AMT), 0) DEBIT, NVL (SUM (A.CREDIT_AMT), 0) CREDIT, NVL (SUM (A.DEBIT_AMT), 0) - NVL (SUM (A.CREDIT_AMT), 0) BALANCE,
                NULL "JV_PREF", NULL "JV_SEQ_NO"
            FROM giac_acct_entries a, giac_acctrans b, giac_chart_of_accts c
           WHERE a.gacc_tran_id = b.tran_id
             AND a.gl_acct_id = c.gl_acct_id --vondanix RSIC 20691 12.09.2015
             AND 'Y' = p_begbal
             AND b.tran_flag = 'P'
             AND a.gacc_gfun_fund_cd = p_fund_cd
             AND a.gl_acct_category = NVL (p_gl_acct_category, a.gl_acct_category)
             AND a.gl_control_acct = NVL (p_gl_control_acct, a.gl_control_acct)
             AND a.gl_sub_acct_1 = NVL (p_gl_acct_1, a.gl_sub_acct_1)
             AND a.gl_sub_acct_2 = NVL (p_gl_acct_2, a.gl_sub_acct_2)
             AND a.gl_sub_acct_3 = NVL (p_gl_acct_3, a.gl_sub_acct_3)
             AND a.gl_sub_acct_4 = NVL (p_gl_acct_4, a.gl_sub_acct_4)
             AND a.gl_sub_acct_5 = NVL (p_gl_acct_5, a.gl_sub_acct_5)
             AND a.gl_sub_acct_6 = NVL (p_gl_acct_6, a.gl_sub_acct_6)
             AND a.gl_sub_acct_7 = NVL (p_gl_acct_7, a.gl_sub_acct_7)
             AND b.posting_date < p_fromdate
             AND a.gacc_gibr_branch_cd =
                              DECODE (p_consolidate,
                                      'N', p_branch_cd,
                                      a.gacc_gibr_branch_cd
                                     )
             AND a.gacc_gibr_branch_cd IN (SELECT *
                                                    FROM TABLE (
                                                            SPLIT_COMMA_SEPARATED_STRING (
                                                                                 v_branch_accessible)))     -- added by jhing GENQA 5280,5200  
            AND b.tran_class = NVL (p_tran_class, b.tran_class)                                                                      
        GROUP BY a.gl_acct_id, a.gl_acct_category, a.gl_control_acct,
                 a.gl_sub_acct_1, a.gl_sub_acct_2, a.gl_sub_acct_3,
                 a.gl_sub_acct_4, a.gl_sub_acct_5, a.gl_sub_acct_6,
                 a.gl_sub_acct_7, c.gl_acct_name
        ORDER BY gl_acct_code, gl_acct_name, tran_class NULLS FIRST
        )
        /* comment by --vondanix RSIC 20691 12.09.2015
                  ORDER BY    TO_CHAR (a.gl_acct_category)
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
                           DECODE (p_dt_basis,
                                   1, TO_CHAR (b.tran_date, 'MM YYYY'),
                                   2, TO_CHAR (b.posting_date, 'MM YYYY')
                                  ),
                           b.tran_class,
                           TRUNC (b.tran_date))
       */
      LOOP
         v_month_grp := TO_CHAR (TO_DATE (rec.month_grp, 'MMYYYY'), 'FmMonth YYYY');
         v_tran_date := rec.tran_date;
         v_date_post := rec.date_posted;

         --get ref_no
         -- start  - changes; adpascual 8.16.2012 
         BEGIN
            SELECT 1
              INTO v_exist_rev
              FROM giac_reversals
             WHERE reversing_tran_id = rec.tran_id;
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
                WHERE tran_id = rec.tran_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ref_no := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_ref_no := v_ref_no;
            END;
         ELSE 
            IF rec.tran_class = 'COL'
            THEN
               v_ref_no := rec.col_ref_no;
            ELSIF rec.tran_class = 'DV'
            THEN
               BEGIN
                  SELECT    a.dv_pref
                         || '-'
                         || TO_CHAR (a.dv_no)
                         || '/'
                         || b.check_pref_suf
                         || '-'
                         || TO_CHAR (b.check_no)
                    INTO v_ref_no
                    FROM giac_disb_vouchers a, giac_chk_disbursement b
                   WHERE b.check_stat = 2
                     AND a.gacc_tran_id = b.gacc_tran_id
                     AND a.gacc_tran_id = rec.tran_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     SELECT    document_cd
                            || '-'
                            || branch_cd
                            || '-'
                            || TO_CHAR (doc_year)
                            || '-'
                            || TO_CHAR (doc_mm)
                            || '-'
                            || TO_CHAR (doc_seq_no)
                       INTO v_ref_no
                       FROM giac_payt_requests a, giac_payt_requests_dtl b
                      WHERE a.ref_id = b.gprq_ref_id AND tran_id = rec.tran_id;
                  WHEN TOO_MANY_ROWS THEN -- added by gab 09.28.2015
                      FOR x IN (SELECT a.dv_pref
                         || '-'
                         || TO_CHAR (a.dv_no)
                         || '/'
                         || b.check_pref_suf
                         || '-'
                         || TO_CHAR (b.check_no) refno
                              FROM giac_disb_vouchers a,
                                   giac_chk_disbursement b
                             WHERE b.check_stat = 2
                               AND a.gacc_tran_id = b.gacc_tran_id
                               AND a.gacc_tran_id = rec.tran_id)
                  LOOP
                     v_ctr := v_ctr + 1;

                     IF v_ctr > 1
                     THEN
                        v_ref_no := v_ref_no || CHR (10) || x.refno;
                     END IF;
                  END LOOP;
               END;
            ELSIF rec.tran_class = 'JV'
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
                         || jv_no
                    INTO v_ref_no
                    FROM giac_acctrans
                   WHERE tran_id = rec.tran_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_ref_no := NULL;
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_ref_no := v_ref_no;
               END;
            ELSE
               v_ref_no := rec.jv_ref_no;
            END IF;
         END IF; 
         
         v_ref_no := v_ref_no||' / '||rec.tran_id;
         
         IF rec.tran_id IS NULL THEN
         
            v_ref_no := NULL;
         END IF; 
         -- end adpascual 8.16.2012

         v_giacr201.gl_account := rec.gl_acct_code;
         v_giacr201.gl_account_name := rec.gl_acct_name;
         v_giacr201.month_grp := v_month_grp;
         v_giacr201.tran_class := rec.tran_class;
         v_giacr201.tran_date := v_tran_date;
         v_giacr201.date_posted := v_date_post;
         v_giacr201.pname := rec.pname;
         v_giacr201.tran_flag := rec.flag;
         v_giacr201.particulars := rec.particulars;
         v_giacr201.tran_id := rec.tran_id;
         v_giacr201.ref_no := v_ref_no;
         v_giacr201.debit_amt := rec.debit;
         v_giacr201.credit_amt := rec.credit;
         v_giacr201.balance := rec.balance;
         v_giacr201.jv_ref_no := rec.jv_pref || ' ' || LPAD(TO_CHAR(rec.jv_seq_no), 12, '0'); -- added by gab 09.14.2015
         PIPE ROW (v_giacr201);
      END LOOP;

      RETURN;
   END;

----------------------------------------------------------------------
/* Modified by : Abegail Pascual
   Date        : 08.16.2012
   Description : 
    added a select to check if tran_id exist on giac_reversal
    if it does exist, system will generate a reference no. using REV-tran_yy-tran_mo-tran_seq
    if not, system will generate based on tran class (usual process - old code)
    added modification made by edision dated 1005201z
*/   
   FUNCTION csv_giacr202 (
      p_dt_basis           NUMBER,
      p_consolidate        VARCHAR2,
      p_branch_cd          VARCHAR2,
      p_fund_cd            VARCHAR2,
      p_gl_acct_category   NUMBER,
      p_gl_control_acct    NUMBER,
      p_gl_acct_1          NUMBER,
      p_gl_acct_2          NUMBER,
      p_gl_acct_3          NUMBER,
      p_gl_acct_4          NUMBER,
      p_gl_acct_5          NUMBER,
      p_gl_acct_6          NUMBER,
      p_gl_acct_7          NUMBER,
      p_tran_class         VARCHAR2,
      p_sl_cd              NUMBER,
      p_sl_type_cd         VARCHAR2,
      p_eotran             VARCHAR2,
      p_fromdate           DATE,
      p_todate             DATE,
      p_user_id            VARCHAR2 , -- jhing 01.28.2016 added p_user_id, p_module_id GENQA 5280,5200
      p_module_id          VARCHAR2 
   )
      RETURN giacr202_type PIPELINED
   IS
      v_giacr202    giacr202_rec_type;
      v_month_grp   VARCHAR2 (100);
      v_tran_date   VARCHAR2 (50);
      v_date_post   VARCHAR2 (50);
      v_ref_no      VARCHAR2(32767); --VARCHAR2(50), --edited by gab 09.28.2015
      v_sl_cd       GIAC_SL_LISTS.SL_cd%type; -- VARCHAR2 (20); adpascual 08302012
      v_sl_name     GIAC_SL_LISTS.SL_NAME%type; -- VARCHAR2 (160); adpascual 08302012
      v_exist_rev   NUMBER; -- adpascual 08162012
      v_ctr               NUMBER (3)        := 0; --added by gab 09.28.2015
      v_branch_accessible  VARCHAR2 (2000);  -- jhing 01.29.2016 -- GENQA 5280, 5200
   BEGIN
   
      v_branch_accessible  := giacr060_pkg.get_Branch_WithAccess (p_module_id, p_user_id );  -- jhing 01.29.2016 GENQA 5280,5200   
      
      FOR rec IN
         (SELECT   a.gacc_tran_id tran_id,
                      TO_CHAR (a.gl_acct_category)
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
                   || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00')) gl_acct_code,
                   e.gl_acct_name gl_acct_name, a.sl_source_cd sl_source_cd,
                   a.sl_type_cd sl_type_cd, a.sl_cd sl_cd,
                   DECODE (p_dt_basis,
                           1, TO_CHAR (b.tran_date, 'MM YYYY'),
                           2, TO_CHAR (b.posting_date, 'MM YYYY')
                          ) month_grp,
                   b.tran_class,
                   TO_CHAR (TRUNC (b.tran_date), 'MM-DD-YYYY') tran_date,
                   TO_CHAR (TRUNC (b.posting_date), 'MM-DD-YYYY')
                                                                 date_posted,
                   DECODE (b.tran_class,
                           'COL', c.payor,
                           'DV', d.payee
                          ) pname, b.tran_flag flag,
                   DECODE (b.tran_class,
                           'COL', c.particulars,
                           'DV', d.particulars,
                           'JV', b.particulars,
                           b.particulars
                          ) particulars,
                   C.OR_PREF_SUF || ' ' || LPAD(TO_CHAR(C.OR_NO),10,'0') COL_REF_NO, -- added LPAD Mildred 11.07.2012 consolidate BIR enh
LPAD(TO_CHAR(B.TRAN_CLASS_NO),10,'0') JV_REF_NO, -- added LPAD Mildred 11.07.2012 consolidate BIR enh
                           /*c.or_pref_suf || ' '
                           || TO_CHAR (c.or_no) col_ref_no,
                           TO_CHAR (b.tran_class_no) jv_ref_no,*/ -- comment by Mildred 11.07.2012 consolidate BIR enh
                   NVL (a.debit_amt, 0) debit, NVL (a.credit_amt, 0) credit,
                   NVL (a.debit_amt, 0) - NVL (a.credit_amt, 0) balance, 
                   b.jv_pref, b.jv_seq_no -- added by gab 09.14.2015
              FROM giac_chart_of_accts e,
                   giac_disb_vouchers d,
                   giac_order_of_payts c,
                   giac_acctrans b,
                   giac_acct_entries a
             WHERE a.gacc_tran_id = b.tran_id
               AND a.gacc_tran_id = c.gacc_tran_id(+)
               AND a.gacc_tran_id = d.gacc_tran_id(+)
               AND a.gacc_gibr_branch_cd = DECODE(p_consolidate,'N', p_branch_cd,a.gacc_gibr_branch_cd)       --NVL(:g060.branch_cd, A.GACC_GIBR_BRANCH_CD)
               AND a.gacc_gibr_branch_cd IN (SELECT *
                                                    FROM TABLE (
                                                            SPLIT_COMMA_SEPARATED_STRING (
                                                                                 v_branch_accessible)))     -- added by jhing GENQA 5280,5200                
               AND a.gacc_gfun_fund_cd = p_fund_cd
               AND a.gl_acct_category = NVL (p_gl_acct_category, a.gl_acct_category) -- added NVL Mildred 11.07.2012
               AND a.gl_control_acct =
                                    NVL (p_gl_control_acct, a.gl_control_acct)
               AND a.gl_sub_acct_1 = NVL (p_gl_acct_1, a.gl_sub_acct_1)
               AND a.gl_sub_acct_2 = NVL (p_gl_acct_2, a.gl_sub_acct_2)
               AND a.gl_sub_acct_3 = NVL (p_gl_acct_3, a.gl_sub_acct_3)
               AND a.gl_sub_acct_4 = NVL (p_gl_acct_4, a.gl_sub_acct_4)
               AND a.gl_sub_acct_5 = NVL (p_gl_acct_5, a.gl_sub_acct_5)
               AND a.gl_sub_acct_6 = NVL (p_gl_acct_6, a.gl_sub_acct_6)
               AND a.gl_sub_acct_7 = NVL (p_gl_acct_7, a.gl_sub_acct_7)
               AND b.tran_class = NVL (p_tran_class, b.tran_class)
               AND a.gl_acct_id = e.gl_acct_id
               AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
               AND NVL (a.sl_type_cd, '-') =
                                   NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
               AND b.tran_flag <> 'D'
               AND b.tran_flag NOT IN (p_eotran)
               AND DECODE (p_dt_basis,
                           1, TRUNC (b.tran_date),
                           2, b.posting_date,
                           TRUNC (b.tran_date)
                          ) BETWEEN p_fromdate AND p_todate
          -- jeremy 05132010: added TRUNC in tran_date, pnbgen prf 4948
          ORDER BY    TO_CHAR (a.gl_acct_category)
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
                   DECODE (p_dt_basis,
                           1, TO_CHAR (b.tran_date, 'MM YYYY'),
                           2, TO_CHAR (b.posting_date, 'MM YYYY')
                          ),
                   b.tran_class,
                   TRUNC (b.tran_date))
      LOOP
         v_month_grp :=
                  TO_CHAR (TO_DATE (rec.month_grp, 'MMYYYY'), 'FmMonth YYYY');
         v_tran_date := rec.tran_date;
         v_date_post := rec.date_posted;

         --get ref_no
         
        -- start  - changes; adpascual 8.16.2012 
         BEGIN
            SELECT 1
              INTO v_exist_rev
              FROM giac_reversals
             WHERE reversing_tran_id = rec.tran_id;
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
                WHERE tran_id = rec.tran_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ref_no := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_ref_no := v_ref_no;
            END;
         ELSE
            IF rec.tran_class = 'COL'
            THEN
               v_ref_no := rec.col_ref_no;
            ELSIF rec.tran_class = 'DV'
            THEN
               BEGIN
                  SELECT    a.dv_pref
                         || '-'
                         || TO_CHAR (a.dv_no)
                         || '/'
                         || b.check_pref_suf
                         || '-'
                         || TO_CHAR (b.check_no)
                    INTO v_ref_no
                    FROM giac_disb_vouchers a, giac_chk_disbursement b
                   WHERE b.check_stat = 2
                     AND a.gacc_tran_id = b.gacc_tran_id
                     AND a.gacc_tran_id = rec.tran_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     SELECT    document_cd
                            || '-'
                            || branch_cd
                            || '-'
                            || TO_CHAR (doc_year)
                            || '-'
                            || TO_CHAR (doc_mm)
                            || '-'
                            || TO_CHAR (doc_seq_no)
                       INTO v_ref_no
                       FROM giac_payt_requests a, giac_payt_requests_dtl b
                      WHERE a.ref_id = b.gprq_ref_id AND tran_id = rec.tran_id;
                  WHEN TOO_MANY_ROWS THEN -- added by gab 09.28.2015
                      FOR x IN (SELECT a.dv_pref
                         || '-'
                         || TO_CHAR (a.dv_no)
                         || '/'
                         || b.check_pref_suf
                         || '-'
                         || TO_CHAR (b.check_no) refno
                              FROM giac_disb_vouchers a,
                                   giac_chk_disbursement b
                             WHERE b.check_stat = 2
                               AND a.gacc_tran_id = b.gacc_tran_id
                               AND a.gacc_tran_id = rec.tran_id)
                  LOOP
                     v_ctr := v_ctr + 1;

                     IF v_ctr > 1
                     THEN
                        v_ref_no := v_ref_no || CHR (10) || x.refno;
                     END IF;
                  END LOOP;
               END;
            ELSIF rec.tran_class = 'JV'
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
                         || jv_no
                    INTO v_ref_no
                    FROM giac_acctrans
                   WHERE tran_id = rec.tran_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_ref_no := NULL;
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_ref_no := v_ref_no;
               END;
            ELSE
               v_ref_no := rec.jv_ref_no;
            END IF;
            
         END IF;
         
         v_ref_no := v_ref_no||' / '||rec.tran_id;
         -- end adpascual 8.16.2012
         
        
         
         --get SL Code and SL Name
         IF rec.sl_cd IS NOT NULL
         THEN
            IF rec.sl_source_cd = '2'
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
                                        ) sl_nm,
                                 payee_no
                            FROM giis_payees
                           WHERE payee_class_cd = rec.sl_type_cd
                             AND payee_no = rec.sl_cd)
               LOOP
                  v_sl_cd := c1.payee_no;
                  v_sl_name := c1.sl_nm;
               END LOOP;
            ELSE
               FOR c2 IN (SELECT sl_name sl_nm, sl_cd
                            FROM giac_sl_lists
                           WHERE sl_type_cd = rec.sl_type_cd
                             AND sl_cd = rec.sl_cd)
               LOOP
                  v_sl_cd := c2.sl_cd;
                  v_sl_name := c2.sl_nm;
               END LOOP;
            END IF;
         ELSE
            v_sl_name := 'No SL Code';
         END IF;

         v_giacr202.gl_account := rec.gl_acct_code;
         v_giacr202.gl_account_name := rec.gl_acct_name;
         v_giacr202.month_grp := v_month_grp;
         v_giacr202.tran_class := rec.tran_class;
         v_giacr202.sl_cd := v_sl_cd;
         v_giacr202.sl_name := v_sl_name;
         v_giacr202.tran_date := v_tran_date;
         v_giacr202.date_posted := v_date_post;
         v_giacr202.pname := rec.pname;
         v_giacr202.tran_flag := rec.flag;
         v_giacr202.particulars := rec.particulars;
         v_giacr202.ref_no := v_ref_no;
         v_giacr202.debit_amt := rec.debit;
         v_giacr202.credit_amt := rec.credit;
         v_giacr202.balance := rec.balance;
         v_giacr202.jv_ref_no := rec.jv_pref || ' ' || LPAD(TO_CHAR(rec.jv_seq_no), 12, '0'); --added by gab 09.14.2015
         PIPE ROW (v_giacr202);
      END LOOP;

      RETURN;
   END;
END; 
/

