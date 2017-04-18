CREATE OR REPLACE PACKAGE BODY CPI.giacr480a_pkg
AS
   FUNCTION get_giacr_480_a_report (
      p_as_of_date    VARCHAR2,
      p_company_cd    VARCHAR2,
      p_employee_cd   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN (SELECT   a.prem_due, a.employee_cd, a.employee_name,
                         a.line_name, a.user_id
                    FROM giac_sal_ded_billing_ext a, giac_sal_ded_payt_ext b
                   WHERE a.policy_id = b.policy_id(+)
                     AND a.iss_cd = b.iss_cd(+)
                     AND a.prem_seq_no = b.prem_seq_no(+)
                     AND TRUNC (a.as_of_date) =
                                  TRUNC (TO_DATE (p_as_of_date, 'MM-dd-YYYY'))
                     AND a.company_cd = NVL (p_company_cd, a.company_cd)
                     AND a.employee_cd = NVL (p_employee_cd, a.employee_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.user_id = UPPER (p_user_id)
                GROUP BY a.prem_due,
                         a.employee_cd,
                         a.employee_name,
                         a.line_name,
                         a.user_id)
      LOOP
         BEGIN
            FOR NAME IN (SELECT param_value_v
                           FROM giac_parameters
                          WHERE param_name = 'COMPANY_NAME')
            LOOP
               v_list.company_name := NAME.param_value_v;
            END LOOP;
         END;

         BEGIN
            FOR NAME IN (SELECT param_value_v
                           FROM giac_parameters
                          WHERE param_name = 'COMPANY_ADDRESS')
            LOOP
               v_list.company_address := NAME.param_value_v;
            END LOOP;
         END;

         BEGIN
            v_list.as_of_date :=
                  'As of '
               || TO_CHAR (TO_DATE (p_as_of_date, 'mm/dd/yyyy'),
                           'fmMonth DD, YYYY'
                          );
         END;

         BEGIN
            SELECT TO_CHAR (SYSDATE, 'fmMonth DD, YYYY')
              INTO v_list.sys_date
              FROM DUAL;
         END;

         BEGIN
            SELECT SYSDATE
              INTO v_list.sys_date1
              FROM DUAL;
         END;

         BEGIN
            v_list.month_year :=
               TO_CHAR (TRUNC (TO_DATE (p_as_of_date, 'mm/dd/yyyy')),
                        'fmMonth YYYY'
                       );
         END;

         BEGIN
            FOR p IN (SELECT param_value_v
                        FROM giac_parameters
                       WHERE param_name = 'BILLING_ADVICE_TEXT')
            LOOP
               v_list.billing_advice_text := p.param_value_v;
            END LOOP;
         END;

         BEGIN
            FOR j IN (SELECT DISTINCT extract_date
                                 FROM giac_sal_ded_billing_ext
                                WHERE user_id = i.user_id)
            LOOP
               v_list.extract_date := j.extract_date;
            END LOOP;
         END;

         v_list.employee_name := i.employee_name;
         v_list.prem_due := i.prem_due;
         v_list.employee_cd := i.employee_cd;
         v_list.user_id := i.user_id;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr_480_a_report;

   FUNCTION get_giacr_480_a_details (
      p_as_of_date    VARCHAR2,
      p_company_cd    VARCHAR2,
      p_employee_cd   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN giacr480a_tab PIPELINED
   IS
      v_list   giacr480a_type;
   BEGIN
      FOR i IN (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.inst_no,
                         a.as_of_date, a.line_name, a.employee_cd,
                         a.employee_name, a.assured_name, a.in_acct_of,
                         a.company_name, a.employee_dept, a.policy_no,
                         TO_CHAR (a.incept_date, 'MON. dd, YYYY')
                                                                 incept_date,
                         TO_CHAR (a.expiry_date, 'MON. dd, YYYY')
                                                                 expiry_date,
                         a.pay_term, a.prem_amt, b.ref_no,
                         TO_CHAR (b.tran_date, 'MM-dd-YY') tran_date,
                         b.prem_paid, a.prem_balance, a.total_amt_due,
                         TO_CHAR (a.due_date, 'fmMon-DD') due_date, a.prem_due,
                         a.amort_no, a.pack_policy_no, a.company_cd,
                         a.user_id
                    FROM giac_sal_ded_billing_ext a, giac_sal_ded_payt_ext b
                   WHERE a.policy_id = b.policy_id(+)
                     AND a.iss_cd = b.iss_cd(+)
                     AND a.prem_seq_no = b.prem_seq_no(+)
                     AND TRUNC (a.as_of_date) =
                                  TRUNC (TO_DATE (p_as_of_date, 'MM-dd-YYYY'))
                     AND a.company_cd = NVL (p_company_cd, a.company_cd)
                     AND a.employee_cd = NVL (p_employee_cd, a.employee_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.user_id = UPPER (p_user_id)
                ORDER BY a.employee_name, a.line_name, a.inst_no, b.tran_date)
      LOOP
         BEGIN
            v_list.as_of_date :=
                  'As of '
               || TO_CHAR (TO_DATE (p_as_of_date, 'mm/dd/yyyy'),
                           'fmMonth DD, YYYY'
                          );
         END;

         BEGIN
            FOR NAME IN (SELECT param_value_v
                           FROM giac_parameters
                          WHERE param_name = 'BILLING_STMT_TEXT')
            LOOP
               v_list.billing_stmt_text := NAME.param_value_v;
            END LOOP;
         END;

         BEGIN
            v_list.cf_prem_paid := (i.prem_paid * -1);
         END;

         v_list.pack_policy_no := i.pack_policy_no;
         v_list.line_name := i.line_name;
         v_list.employee_cd := i.employee_cd;
         v_list.assd_name := i.assured_name;
         v_list.in_acct_of := i.in_acct_of;
         v_list.company_name := i.company_name;
         v_list.employee_dept := i.employee_dept;
         v_list.policy_no := i.policy_no;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.total_amt_due := i.total_amt_due;
         v_list.ref_no := i.ref_no;
         v_list.tran_date := i.tran_date;
         v_list.prem_balance := i.prem_balance;
         v_list.company_cd := i.company_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.due_date := i.due_date;
         v_list.prem_due := i.prem_due;
         v_list.amort_no := i.amort_no;
         v_list.user_id := i.user_id;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr_480_a_details;

   FUNCTION get_giacr_480_a_payt (
      p_as_of_date       VARCHAR2,
      p_company_cd       VARCHAR2,
      p_employee_cd      VARCHAR2,
      p_iss_cd           VARCHAR2,
      p_user_id          VARCHAR2,
      p_line_name        VARCHAR2,
      p_policy_no        VARCHAR2,
      p_pack_policy_no   VARCHAR2
   )
      RETURN giacr480a_tab PIPELINED
   IS
      v_list   giacr480a_type;
   BEGIN
      FOR i IN (SELECT   b.ref_no,
                         TO_CHAR (b.tran_date, 'MM-dd-YY') tran_date,
                         b.prem_paid, a.line_name, a.policy_no,
                         a.pack_policy_no
                    FROM giac_sal_ded_billing_ext a, giac_sal_ded_payt_ext b
                   WHERE a.policy_id = b.policy_id(+)
                     AND a.iss_cd = b.iss_cd(+)
                     AND a.prem_seq_no = b.prem_seq_no(+)
                     AND TRUNC (a.as_of_date) =
                                  TRUNC (TO_DATE (p_as_of_date, 'MM-dd-YYYY'))
                     AND a.company_cd = NVL (p_company_cd, a.company_cd)
                     AND a.employee_cd = NVL (p_employee_cd, a.employee_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.user_id = UPPER (p_user_id)
                     AND a.line_name = p_line_name
                     AND a.policy_no = p_policy_no
                     AND a.pack_policy_no = p_pack_policy_no
                ORDER BY a.employee_name, a.line_name, a.inst_no, b.tran_date)
      LOOP
         BEGIN
            v_list.cf_prem_paid := (i.prem_paid * -1);
         END;

         v_list.ref_no := i.ref_no;
         v_list.tran_date := i.tran_date;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr_480_a_payt;
END;
/


