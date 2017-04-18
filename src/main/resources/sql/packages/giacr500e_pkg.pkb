CREATE OR REPLACE PACKAGE BODY CPI.giacr500e_pkg
AS
/*
   ** Created by : Ariel P. Ignas Jr
   ** Date Created : 07.20.2013
   ** Reference By : GIACR500E
   ** Description : Trial Balance
   */
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

   FUNCTION cf_company_add
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

   FUNCTION cf_dateformula (p_month NUMBER, p_year NUMBER)
      RETURN VARCHAR2
   IS
      v_date   VARCHAR (70);
   BEGIN
      SELECT    'For the month of '
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
             || ' ,'
             || TO_CHAR (p_year)
        INTO v_date
        FROM DUAL;

      RETURN (v_date);
   END;

   FUNCTION cf_currentdate
      RETURN DATE
   IS
   BEGIN
      RETURN (SYSDATE);
   END;

   FUNCTION get_giacr500e_record (p_month NUMBER, p_year NUMBER)
      RETURN giacr500e_record_tab PIPELINED
   IS
      v_list   giacr500e_record_type;
      v_test   BOOLEAN               := TRUE;
   BEGIN
      v_list.cf_company_nameformula := cf_company_nameformula;
      v_list.cf_company_add := cf_company_add;
      v_list.cf_dateformula := cf_dateformula (p_month, p_year);
      v_list.cf_currentdate :=
                              UPPER (TO_CHAR (cf_currentdate, 'mm-dd-yyyy'));

      FOR i IN (SELECT   branch_name, gl_acct_no, gl_acct_name,
                         trans_debit_bal, trans_credit_bal,
                            gl_acct_category
                         || '-'
                         || TO_CHAR (gl_control_acct, '09')
                         || '-'
                         || TO_CHAR (gl_sub_acct_1, '09')
                         || '-'
                         || TO_CHAR (gl_sub_acct_2, '09') sum2,
                            gl_acct_category
                         || '-'
                         || TO_CHAR (gl_control_acct, '09')
                         || '-'
                         || TO_CHAR (gl_sub_acct_1, '09') sum1,
                            gl_acct_category
                         || '-'
                         || TO_CHAR (gl_control_acct, '09') total,
                         gl_acct_category, gl_acct_no_formatted
                    FROM giac_trial_balance_v
                   WHERE 1 = 1 AND tran_year = p_year AND tran_mm = p_month
                ORDER BY gl_acct_no_formatted)
      LOOP
         v_test := FALSE;
         v_list.branch_name := i.branch_name;
         v_list.gl_acct_no := i.gl_acct_no;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.trans_debit_bal := i.trans_debit_bal;
         v_list.trans_credit_bal := i.trans_credit_bal;
         v_list.sum1 := i.sum1;
         v_list.sum2 := i.sum2;
         v_list.total := i.total;
         v_list.gl_acct_category := i.gl_acct_category;
         v_list.gl_acct_no_formatted := i.gl_acct_no_formatted;
         v_list.p_month := p_month;
         v_list.p_year := p_year;
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giacr500e_record;
END;
/


