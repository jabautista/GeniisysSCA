CREATE OR REPLACE PACKAGE BODY CPI.giacr480b_pkg
AS
   FUNCTION get_giacr_480_b_report (
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
      FOR i IN (SELECT   a.policy_id, a.as_of_date, a.line_name,
                         a.employee_cd, a.employee_name, a.assured_name,
                         a.in_acct_of, a.company_cd, a.company_name,
                         a.employee_dept, a.policy_no, a.incept_date,
                         a.prem_amt, a.tax_amt, a.total_amt_due,
                         a.prem_balance, a.prem_due, a.amort_no,
                         a.pack_policy_no, a.user_id
                    FROM giac_sal_ded_billing_ext a
                   WHERE TRUNC (a.as_of_date) =
                                 TRUNC (TO_DATE (p_as_of_date, 'MM-dd-YYYY'))
                     AND a.company_cd = NVL (p_company_cd, a.company_cd)
                     AND a.employee_cd = NVL (p_employee_cd, a.employee_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.user_id = UPPER (p_user_id)
                ORDER BY a.employee_cd, a.line_name)
      LOOP
         BEGIN
            FOR NAME IN (SELECT param_value_v
                           FROM giac_parameters
                          WHERE param_name = 'COMPANY_NAME')
            LOOP
               v_list.cf_company_name := NAME.param_value_v;
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
            SELECT SYSDATE
              INTO v_list.sys_date1
              FROM DUAL;
         END;
         
         BEGIN
            FOR j IN (SELECT DISTINCT extract_date
                                 FROM giac_sal_ded_billing_ext
                                WHERE user_id = i.user_id)
            LOOP
               v_list.extract_date := j.extract_date;
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
            FOR NAME IN (SELECT param_value_v
                           FROM giac_parameters
                          WHERE param_name = 'BILLING_STMT_TEXT')
            LOOP
               v_list.billing_stmt_text := NAME.param_value_v;
            END LOOP;
         END;

         BEGIN
            FOR b IN (SELECT SUM (prem_paid) prem_paid
                        FROM giac_sal_ded_payt_ext
                       WHERE policy_id = i.policy_id)
            LOOP
               v_list.prem_paid := (b.prem_paid * -1);
            END LOOP;
         END;

         v_list.company_name := i.company_name;
         v_list.employee_cd := i.employee_cd;
         v_list.assd_name := i.assured_name;
         v_list.in_acct_of := i.in_acct_of;
         v_list.pack_policy_no := i.pack_policy_no;
         v_list.policy_no := i.policy_no;
         v_list.incept_date := i.incept_date;
         v_list.prem_amt := i.prem_amt;
         v_list.tax_amt := i.tax_amt;
         v_list.total_amt_due := i.total_amt_due;
         v_list.prem_balance := i.prem_balance;
         v_list.prem_due := i.prem_due;
         v_list.amort_no := i.amort_no;
         v_list.user_id := i.user_id;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr_480_b_report;
END;
/


