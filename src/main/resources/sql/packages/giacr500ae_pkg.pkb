CREATE OR REPLACE PACKAGE BODY CPI.GIACR500AE_PKG
AS
   FUNCTION cf_dateformula (p_month NUMBER, p_year NUMBER)
      RETURN VARCHAR2
   IS
      v_date   VARCHAR (70);
   BEGIN
      SELECT    'For the month ending '
             || DECODE (p_month,
                        1, 'January',
                        2, 'February',
                        3, 'March',
                        4, 'April',
                        5, 'May',
                        6, 'June',
                        7, 'July',
                        8, 'August',
                        9, 'September',
                        10, 'October',
                        11, 'November',
                        12, 'December'
                       )
             || ', '
             || TO_CHAR (p_year)
        INTO v_date
        FROM DUAL;

      RETURN (v_date);
   END;

   FUNCTION cf_1formula
      RETURN CHAR
   IS
      v_company_address   giac_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_company_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_company_address := ' ';
      END;

      RETURN (v_company_address);
   END;

   FUNCTION cf_company_nameformula
      RETURN VARCHAR2
   IS
      v_company_name   giis_parameters.param_name%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_company_name
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_company_name := ' ';
      END;

      RETURN (v_company_name);
   END;

   FUNCTION cf_branch_nameformula(p_branch_cd VARCHAR2)
      RETURN CHAR
   IS
      v_branch_name   giac_branches.branch_name%TYPE;
   BEGIN
      IF p_branch_cd IS NOT NULL
      THEN
         SELECT branch_name
           INTO v_branch_name
           FROM giac_branches
          WHERE branch_cd = p_branch_cd;
      ELSE
         v_branch_name := 'Consolidated';
      END IF;

      RETURN (v_branch_name);
   END;

   FUNCTION get_giacr500ae_record (
      p_month    NUMBER,
      p_year     NUMBER,
      p_branch   VARCHAR
   )
      RETURN giacr500ae_record_tab PIPELINED
   IS
      v_list   giacr500ae_record_type;
      cname    BOOLEAN              := TRUE;
   BEGIN
      v_list.cf_company_name := cf_company_nameformula;
      v_list.cf_company_add := cf_1formula;
      v_list.cf_date := cf_dateformula (p_month, p_year);

      FOR i IN (SELECT   a.branch_cd, a.gl_acct_id, gl_acct_no_formatted,
                         gl_acct_name, YEAR, MONTH, NVL (debit, 0) debit,
                         NVL (credit, 0) credit, NVL (adj_debit, 0)
                                                                   adj_debit,
                         NVL (adj_credit, 0) adj_credit
                    FROM (SELECT   NULL branch_cd, a.gl_acct_id,
                                   a.gl_acct_no_formatted, a.gl_acct_name,
                                   a.tran_year YEAR, a.tran_mm MONTH,
                                   SUM (a.trans_debit_bal) debit,
                                   SUM (a.trans_credit_bal) credit
                              FROM giac_trial_balance_v a
                             WHERE a.tran_year = p_year
                               AND a.tran_mm = p_month
                               AND p_branch = 'N'
                          GROUP BY NULL,
                                   a.gl_acct_id,
                                   a.gl_acct_no_formatted,
                                   a.gl_acct_name,
                                   a.tran_year,
                                   a.tran_mm
                          UNION
                          SELECT   branch_cd, a.gl_acct_id,
                                   a.gl_acct_no_formatted, a.gl_acct_name,
                                   a.tran_year YEAR, a.tran_mm MONTH,
                                   SUM (a.trans_debit_bal) debit,
                                   SUM (a.trans_credit_bal) credit
                              FROM giac_trial_balance_v a
                             WHERE a.tran_year = p_year
                               AND a.tran_mm = p_month
                               AND p_branch = 'Y'
                          GROUP BY branch_cd,
                                   a.gl_acct_id,
                                   a.gl_acct_no_formatted,
                                   a.gl_acct_name,
                                   a.tran_year,
                                   a.tran_mm) a,
                         (SELECT   DECODE (SIGN (  SUM (debit_amt)
                                                 - SUM (credit_amt)
                                                ),
                                           1, SUM (debit_amt)
                                            - SUM (credit_amt),
                                           0
                                          ) adj_debit,
                                   SUM (credit_amt) adj_credit, a.gl_acct_id,
                                   a.branch_cd
                              FROM giac_trial_balance_v a,
                                   giac_acct_entries b,
                                   giac_acctrans c
                             WHERE b.gacc_tran_id = c.tran_id
                               AND ae_tag = 'Y'
                               AND TRUNC (posting_date) =
                                      LAST_DAY
                                              (TO_DATE (   TO_CHAR (a.tran_mm,
                                                                    '09'
                                                                   )
                                                        || '-01-'
                                                        || TO_CHAR
                                                                 (a.tran_year,
                                                                  'fm0999'
                                                                 ),
                                                        'MM/DD/RRRR'
                                                       )
                                              )
                               AND a.gl_acct_id = b.gl_acct_id
                               AND a.branch_cd = b.gacc_gibr_branch_cd
                               AND a.tran_mm = p_month
                               AND a.tran_year = p_year
                          GROUP BY a.gl_acct_id, branch_cd) b
                   WHERE a.gl_acct_id = b.gl_acct_id(+)
                     AND NVL (a.branch_cd, 'N') = NVL2 (a.branch_cd, b.branch_cd(+),
                                                        'N')
                ORDER BY gl_acct_no_formatted)
      LOOP
         cname := FALSE;
         v_list.branch_cd := i.branch_cd;
         v_list.branch_name := cf_branch_nameformula(i.branch_cd);
         v_list.gl_acct_id := i.gl_acct_id;
         v_list.gl_acct_no_formatted := i.gl_acct_no_formatted;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.YEAR := i.YEAR;
         v_list.MONTH := i.MONTH;
         v_list.debit := i.debit;
         v_list.credit := i.credit;
         v_list.adj_debit := i.adj_debit;
         v_list.adj_credit := i.adj_credit;
         v_list.cf_unadj_debit := i.debit - nvl(i.adj_debit, 0);
         v_list.cf_unadj_credit := i.credit - nvl(i.adj_credit, 0);
         PIPE ROW (v_list);
      END LOOP;

      IF cname = TRUE
      THEN
         v_list.cname := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giacr500ae_record;
END GIACR500AE_PKG;
/


