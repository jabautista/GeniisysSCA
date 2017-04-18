CREATE OR REPLACE PACKAGE BODY CPI.giacr500A_pkg
AS
/*
   ** Created by : Ariel P. Ignas Jr
   ** Date Created : 07.19.2013
   ** Reference By : GIACR500a
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
             || ' ,'
             || TO_CHAR (p_year)
        INTO v_date
        FROM DUAL;

      RETURN (v_date);
   END;

   FUNCTION get_giacr500a_record (p_month NUMBER, p_year NUMBER)
      RETURN giacr500a_record_tab PIPELINED
   IS
      v_list   giacr500a_record_type;
      v_test    BOOLEAN               := TRUE;
   BEGIN
      v_list.cf_company_nameformula := cf_company_nameformula;
      v_list.cf_1formula := cf_1formula;
      v_list.cf_dateformula := cf_dateformula (p_month, p_year);

      FOR i IN (SELECT   a.gl_acct_no_formatted, a.gl_acct_name "ACCT_NAME",
                         gl_acct_category, gl_control_acct,
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
                         DECODE (gl_sub_acct_7,
                                 0, 0,
                                 gl_sub_acct_6
                                ) gl_sub_acct_7,
                         a.tran_year YEAR, a.tran_mm MONTH,
                         SUM (a.trans_debit_bal) debit,
                         SUM (a.trans_credit_bal) credit
                    FROM giac_trial_balance_v a
                   WHERE a.tran_year = NVL (p_year, a.tran_year)
                     AND a.tran_mm = NVL (p_month, a.tran_mm)
                GROUP BY a.gl_acct_no_formatted,
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
                         a.tran_mm
                ORDER BY a.gl_acct_no_formatted,
                         gl_acct_category,
                         gl_control_acct,
                         gl_sub_acct_1,
                         gl_sub_acct_2,
                         gl_sub_acct_3,
                         gl_sub_acct_4,
                         gl_sub_acct_5,
                         gl_sub_acct_6,
                         gl_sub_acct_7)
      LOOP
         v_test := FALSE;
         v_list.p_month := p_month;
         v_list.p_year := p_year;
         v_list.gl_acct_no_formatted := i.gl_acct_no_formatted;
         v_list.acct_name := i.acct_name;
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
         PIPE ROW (v_list); 
      END LOOP;

      IF v_test = TRUE 
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF; 
   END get_giacr500a_record;
END;
/


