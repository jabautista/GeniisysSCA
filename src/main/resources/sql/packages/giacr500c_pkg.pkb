CREATE OR REPLACE PACKAGE BODY CPI.GIACR500C_PKG
AS
   /*
     **  Created by   :  Kenneth Mark Labrador
     **  Date Created : 07.22.2013
     **  Reference By : GIAR500C - Trial Balance
   */
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

   FUNCTION cf_branch_nameformula (p_branch_cd VARCHAR2)
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

   FUNCTION get_giacr500c_record (
      p_month     NUMBER,
      p_year      NUMBER,
      p_user_id   VARCHAR
   )
      RETURN giacr500c_record_tab PIPELINED
   IS
      v_list   giacr500c_record_type;
      cname    BOOLEAN               := TRUE;
   BEGIN
      v_list.cf_company_name := cf_company_nameformula;
      v_list.cf_company_add := cf_1formula;
      v_list.cf_date := cf_dateformula (p_month, p_year);

      FOR i IN (SELECT   a.fund_cd, a.branch_cd, b.gl_acct_name, a.gl_acct_id, 
                         get_gl_acct_no (a.gl_acct_id) gl_no,
                         SUM (debit) debit, SUM (credit) credit
                    FROM giac_trial_balance_summary a, giac_chart_of_accts b
                   WHERE a.user_id = p_user_id
                         AND a.gl_acct_id = b.gl_acct_id
                GROUP BY a.fund_cd,
                         a.branch_cd,
                         b.gl_acct_name,
                         a.gl_acct_id,
                         get_gl_acct_no (a.gl_acct_id)
                ORDER BY 5)
      LOOP
         cname := FALSE;
         v_list.branch_cd := i.branch_cd;
         v_list.fund_cd := i.fund_cd;
         v_list.branch_name := cf_branch_nameformula (i.branch_cd);
         v_list.gl_acct_id := i.gl_acct_id;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.gl_no := i.gl_no;
         v_list.debit := i.debit;
         v_list.credit := i.credit;
         PIPE ROW (v_list);
      END LOOP;

      IF cname = TRUE
      THEN
         v_list.cname := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giacr500c_record;
END GIACR500C_PKG;
/


