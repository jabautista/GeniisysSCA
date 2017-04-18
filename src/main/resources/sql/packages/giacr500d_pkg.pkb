CREATE OR REPLACE PACKAGE BODY CPI.giacr500d_pkg
AS
   /*
    ** Created by   : Paolo J. Santos
    ** Date Created : 07.19.2013
    ** Reference By : GIACR500D
    ** Description  : Trial Balance 
   */

   FUNCTION cf_branchformula
      RETURN VARCHAR2
   IS
      v_branch_name   VARCHAR2 (50);
   BEGIN
      SELECT branch_name
        INTO v_branch_name
        FROM giac_branches
       WHERE branch_cd = branch_cd;

      RETURN (v_branch_name);
   END;

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

   FUNCTION get_giacr500d_record (p_month NUMBER, p_year NUMBER)
      RETURN giacr500d_record_tab PIPELINED
   IS
      v_list   giacr500d_record_type;
      cname    BOOLEAN               := TRUE;
   BEGIN
      v_list.cf_company_name := cf_company_nameformula;
      v_list.cf_company_add := cf_1formula;
      v_list.cf_date := cf_dateformula (p_month, p_year);

      FOR i IN
         (SELECT   DECODE (INSTR (a.gl_acct_no_formatted, '-', 1),
                           2, '0' || SUBSTR (a.gl_acct_no_formatted, 1, 1),
                           SUBSTR (a.gl_acct_no_formatted, 1, 2)
                          ) test1,
                   DECODE (  INSTR (a.gl_acct_no_formatted, '-', 1, 2)
                           - INSTR (a.gl_acct_no_formatted, '-', 1),
                           2,  '0'
                            || SUBSTR (a.gl_acct_no_formatted,
                                         INSTR (a.gl_acct_no_formatted,
                                                '-',
                                                1,
                                                2
                                               )
                                       - 1,
                                       1
                                      ),
                           SUBSTR (a.gl_acct_no_formatted,
                                     INSTR (a.gl_acct_no_formatted, '-', 1, 2)
                                   - 2,
                                   2
                                  )
                          ) test2,
                   DECODE
                      (DECODE (INSTR (a.gl_acct_no_formatted, '-', 1),
                               2, '0' || SUBSTR (a.gl_acct_no_formatted, 1, 1),
                               SUBSTR (a.gl_acct_no_formatted, 1, 2)
                              ),
                       '04', DECODE (  INSTR (a.gl_acct_no_formatted,
                                              '-',
                                              1,
                                              3
                                             )
                                     - INSTR (a.gl_acct_no_formatted,
                                              '-',
                                              1,
                                              2
                                             ),
                                     2,  '0'
                                      || SUBSTR
                                             (a.gl_acct_no_formatted,
                                                INSTR (a.gl_acct_no_formatted,
                                                       '-',
                                                       1,
                                                       3
                                                      )
                                              - 1,
                                              1
                                             ),
                                     SUBSTR (a.gl_acct_no_formatted,
                                               INSTR (a.gl_acct_no_formatted,
                                                      '-',
                                                      1,
                                                      3
                                                     )
                                             - 2,
                                             2
                                            )
                                    ),
                       DECODE (  INSTR (a.gl_acct_no_formatted, '-', 1, 2)
                               - INSTR (a.gl_acct_no_formatted, '-', 1),
                               2,  '0'
                                || SUBSTR (a.gl_acct_no_formatted,
                                             INSTR (a.gl_acct_no_formatted,
                                                    '-',
                                                    1,
                                                    2
                                                   )
                                           - 1,
                                           1
                                          ),
                               SUBSTR (a.gl_acct_no_formatted,
                                         INSTR (a.gl_acct_no_formatted,
                                                '-',
                                                1,
                                                2
                                               )
                                       - 2,
                                       2
                                      )
                              )
                      ) test3,
                   a.branch_cd, a.gl_acct_no_formatted,
                   a.gl_acct_name "ACCT_NAME", gl_acct_category,
                   gl_control_acct, a.branch_name,
                   DECODE (gl_sub_acct_1,
                           0, 0,
                           DECODE (gl_sub_acct_2,
                                   0, gl_control_acct,
                                   gl_sub_acct_1
                                  )
                          ) gl_sub_acct_1,
                   DECODE (gl_sub_acct_2,
                           0, 0,
                           DECODE (gl_sub_acct_3,
                                   0, gl_sub_acct_1,
                                   gl_sub_acct_2
                                  )
                          ) gl_sub_acct_2,
                   DECODE (gl_sub_acct_3,
                           0, 0,
                           DECODE (gl_sub_acct_4,
                                   0, gl_sub_acct_2,
                                   gl_sub_acct_3
                                  )
                          ) gl_sub_acct_3,
                   DECODE (gl_sub_acct_4,
                           0, 0,
                           DECODE (gl_sub_acct_5,
                                   0, gl_sub_acct_3,
                                   gl_sub_acct_4
                                  )
                          ) gl_sub_acct_4,
                   DECODE (gl_sub_acct_5,
                           0, 0,
                           DECODE (gl_sub_acct_6,
                                   0, gl_sub_acct_4,
                                   gl_sub_acct_5
                                  )
                          ) gl_sub_acct_5,
                   DECODE (gl_sub_acct_6,
                           0, 0,
                           DECODE (gl_sub_acct_7,
                                   0, gl_sub_acct_5,
                                   gl_sub_acct_6
                                  )
                          ) gl_sub_acct_6,
                   DECODE (gl_sub_acct_7, 0, 0, gl_sub_acct_6) gl_sub_acct_7,
                   a.tran_year YEAR, a.tran_mm MONTH,
                   SUM (a.trans_debit_bal) debit,
                   SUM (a.trans_credit_bal) credit
              FROM giac_trial_balance_v a
             WHERE a.tran_year = p_year AND a.tran_mm = p_month
          GROUP BY DECODE (INSTR (a.gl_acct_no_formatted, '-', 1),
                           2, '0' || SUBSTR (a.gl_acct_no_formatted, 1, 1),
                           SUBSTR (a.gl_acct_no_formatted, 1, 2)
                          ),
                   DECODE (  INSTR (a.gl_acct_no_formatted, '-', 1, 2)
                           - INSTR (a.gl_acct_no_formatted, '-', 1),
                           2,  '0'
                            || SUBSTR (a.gl_acct_no_formatted,
                                         INSTR (a.gl_acct_no_formatted,
                                                '-',
                                                1,
                                                2
                                               )
                                       - 1,
                                       1
                                      ),
                           SUBSTR (a.gl_acct_no_formatted,
                                     INSTR (a.gl_acct_no_formatted, '-', 1, 2)
                                   - 2,
                                   2
                                  )
                          ),
                   DECODE (DECODE (INSTR (a.gl_acct_no_formatted, '-', 1),
                                   2,  '0'
                                    || SUBSTR (a.gl_acct_no_formatted, 1, 1),
                                   SUBSTR (a.gl_acct_no_formatted, 1, 2)
                                  ),
                           '04', DECODE
                                    (  INSTR (a.gl_acct_no_formatted,
                                              '-',
                                              1,
                                              3
                                             )
                                     - INSTR (a.gl_acct_no_formatted,
                                              '-',
                                              1,
                                              2
                                             ),
                                     2,  '0'
                                      || SUBSTR
                                             (a.gl_acct_no_formatted,
                                                INSTR (a.gl_acct_no_formatted,
                                                       '-',
                                                       1,
                                                       3
                                                      )
                                              - 1,
                                              1
                                             ),
                                     SUBSTR (a.gl_acct_no_formatted,
                                               INSTR (a.gl_acct_no_formatted,
                                                      '-',
                                                      1,
                                                      3
                                                     )
                                             - 2,
                                             2
                                            )
                                    )
                          ),
                   a.branch_name,
                   a.branch_cd,
                   a.gl_acct_no_formatted,
                   a.gl_acct_name,
                   gl_acct_category,
                   gl_control_acct,
                   DECODE (gl_sub_acct_1,
                           0, 0,
                           DECODE (gl_sub_acct_2,
                                   0, gl_control_acct,
                                   gl_sub_acct_1
                                  )
                          ),
                   DECODE (gl_sub_acct_2,
                           0, 0,
                           DECODE (gl_sub_acct_3,
                                   0, gl_sub_acct_1,
                                   gl_sub_acct_2
                                  )
                          ),
                   DECODE (gl_sub_acct_3,
                           0, 0,
                           DECODE (gl_sub_acct_4,
                                   0, gl_sub_acct_2,
                                   gl_sub_acct_3
                                  )
                          ),
                   DECODE (gl_sub_acct_4,
                           0, 0,
                           DECODE (gl_sub_acct_5,
                                   0, gl_sub_acct_3,
                                   gl_sub_acct_4
                                  )
                          ),
                   DECODE (gl_sub_acct_5,
                           0, 0,
                           DECODE (gl_sub_acct_6,
                                   0, gl_sub_acct_4,
                                   gl_sub_acct_5
                                  )
                          ),
                   DECODE (gl_sub_acct_6,
                           0, 0,
                           DECODE (gl_sub_acct_7,
                                   0, gl_sub_acct_5,
                                   gl_sub_acct_6
                                  )
                          ),
                   DECODE (gl_sub_acct_7, 0, 0, gl_sub_acct_6),
                   a.tran_year,
                   a.tran_mm)
      LOOP
         cname := FALSE;
         v_list.test1 := i.test1;
         v_list.test2 := i.test2;
         v_list.test3 := i.test3;
         v_list.gl_acct_no_formatted := i.gl_acct_no_formatted;
         v_list.acct_name := i.acct_name;
         v_list.branch_cd := i.branch_cd;
         v_list.gl_acct_category := i.gl_acct_category;
         v_list.gl_control_acct := i.gl_control_acct;
         v_list.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_list.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_list.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_list.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_list.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_list.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_list.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_list.YEAR := i.YEAR;
         v_list.MONTH := i.MONTH;
         v_list.debit := i.debit;
         v_list.credit := i.credit;
         v_list.branch_name := i.branch_name;
         v_list.cf_company_name := cf_company_nameformula;
         v_list.cf_company_add := cf_1formula;
         v_list.cf_date := cf_dateformula (p_month, p_year);
         v_list.p_month := p_month;
         v_list.p_year := p_year;
         PIPE ROW (v_list);
      END LOOP;

      IF cname = TRUE
      THEN
         v_list.cname := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giacr500d_record;
END;
/


