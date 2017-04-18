CREATE OR REPLACE PACKAGE BODY CSV_AC_EOM_REPORTS
AS
   /*
   **  Created by   : Carlo de guzman
   **  Date Created : 03.07.2016
   **  Reference By : GIACR225
   **  Description  : Batch Accounting entries csv
   */
   FUNCTION cf_tran_class_nameformula (p_tran_class VARCHAR2)
      RETURN CHAR
   IS
      v_name   VARCHAR2 (500);
   BEGIN
      FOR rec IN (SELECT rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIAC_ACCTRANS.TRAN_CLASS'
                     AND rv_low_value = p_tran_class)
      LOOP
         v_name := rec.rv_meaning;
         EXIT;
      END LOOP;

      RETURN (v_name);
   END;

   FUNCTION cf_branchformula (p_branch_cd VARCHAR2)
      RETURN CHAR
   IS
      v_branch_name   giac_branches.branch_name%TYPE;
   BEGIN
      IF p_branch_cd IS NULL
      THEN
         RETURN ('ALL BRANCHES');
      ELSE
         FOR rec IN (SELECT branch_name
                       FROM giac_branches
                      WHERE branch_cd = UPPER (p_branch_cd))
         LOOP
            v_branch_name := rec.branch_name;
            EXIT;
         END LOOP;

         RETURN UPPER (v_branch_name);
      END IF;
   END;

   FUNCTION cf_dateformula (p_date VARCHAR2)
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (60);
   BEGIN
      SELECT TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'), 'fmMONTH yyyy')
        INTO v_date
        FROM DUAL;

      RETURN INITCAP (v_date);
   END;

   FUNCTION cf_addressformula
      RETURN VARCHAR2
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN UPPER (v_address);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (NULL);
   END;

   FUNCTION cf_company_nameformula
      RETURN VARCHAR2
   IS
      v_company   VARCHAR2 (100);
   BEGIN
      SELECT param_value_v
        INTO v_company
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_company);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (NULL);
   END;

   FUNCTION csv_giacr225(
      p_branch_cd   VARCHAR2,
      p_date        VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr225_record_tab PIPELINED
   IS
      v_list   giacr225_record_type;
      v_flag   BOOLEAN              := FALSE;
   BEGIN
      v_list.branch_name := cf_branchformula (p_branch_cd);

      FOR i IN (SELECT   b.tran_date, b.tran_class, a.gl_acct_id,
                            TO_CHAR (a.gl_acct_category)
                         || '-'
                         || TRIM (TO_CHAR (a.gl_control_acct, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_7, '00')) gl_acct,
                         a.gl_acct_name, NVL (SUM (c.debit_amt), 0)
                                                                   debit_amt,
                         NVL (SUM (c.credit_amt), 0) credit_amt,
                         (  (NVL (SUM (c.debit_amt), 0))
                          - (NVL (SUM (c.credit_amt), 0))
                         ) balance_amt
                    FROM giac_chart_of_accts a,
                         giac_acctrans b,
                         giac_acct_entries c
                   WHERE a.gl_acct_id = c.gl_acct_id
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       b.gibr_branch_cd,
                                                       'GIARPR001',
                                                       p_user_id
                                                      ) = 1
                     AND c.gacc_tran_id = b.tran_id
                     AND b.tran_class IN ('PRD', 'UW', 'INF', 'OF', 'PPR')
                     AND b.tran_flag IN ('C', 'P')
                     AND b.tran_month =
                            TO_NUMBER (TO_CHAR (TO_DATE (p_date, 'MM/DD/YYYY'),
                                                'MM'
                                               )
                                      )
                     AND b.tran_year =
                            TO_NUMBER (TO_CHAR (TO_DATE (p_date, 'MM/DD/YYYY'),
                                                'YYYY'
                                               )
                                      )
                     AND b.gibr_branch_cd =
                                           NVL (p_branch_cd, b.gibr_branch_cd)
                  HAVING SUM (c.debit_amt) > 0 OR SUM (c.credit_amt) > 0
                GROUP BY b.tran_date,
                         b.tran_class,
                         a.gl_acct_id,
                            TO_CHAR (a.gl_acct_category)
                         || '-'
                         || TRIM (TO_CHAR (a.gl_control_acct, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_7, '00')),
                         a.gl_acct_name
                ORDER BY p_branch_cd,tran_class,gl_acct_name)
      LOOP
         v_flag := TRUE;
         v_list.branch_code := p_branch_cd;
         v_list.gl_account_name := i.gl_acct_name;
         v_list.debit_amount := i.debit_amt;
         v_list.credit_amount := i.credit_amt;
         v_list.gl_account_no := i.gl_acct;
         v_list.balance_amount := i.balance_amt;
         v_list.transaction_class := cf_tran_class_nameformula (i.tran_class);
         PIPE ROW (v_list);
      END LOOP;

      IF v_flag = FALSE
      THEN
         PIPE ROW (v_list);
      END IF;
   END csv_giacr225;
END CSV_AC_EOM_REPORTS;
/
