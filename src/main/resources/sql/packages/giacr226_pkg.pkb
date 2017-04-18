CREATE OR REPLACE PACKAGE BODY CPI.GIACR226_PKG
AS
/*
   ** Created by : Ariel P. Ignas Jr
   ** Date Created : 07.17.2013
   ** Reference By : GIACR226
   ** Description : Treaty Distribution (Summary)
   */
   FUNCTION cf_company
      RETURN VARCHAR2
   IS
      v_name   VARCHAR2 (200);
   BEGIN
      SELECT param_value_v
        INTO v_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_name);
   END;

   FUNCTION cf_month_year (p_date VARCHAR2)
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (60);
   BEGIN
      SELECT TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'), 'fmMONTH yyyy')
        INTO v_date
        FROM DUAL;

      RETURN INITCAP (v_date);
   END;

   FUNCTION cf_address
      RETURN VARCHAR2
   IS
      v_address   VARCHAR2 (200);
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
         v_address := 'No Existing Address In GIIS_PARAMETERS';
         RETURN UPPER (v_address);
   END;

   FUNCTION get_giacr226_record (
      v_iss_cd    VARCHAR2,
      p_date      VARCHAR2,
      p_user_id   VARCHAR2
   )
      RETURN giacr226_record_tab PIPELINED
   IS
      v_list   giacr226_record_type;
      v_flag   BOOLEAN              := FALSE;
   BEGIN
      v_list.cf_company_name := cf_company;
      v_list.cf_company_month_year := cf_month_year (p_date);
      v_list.cf_company_add := cf_address;
      v_list.v_flag := 'N';

      FOR i IN
         (SELECT      a.gl_acct_category
                   || '-'
                   || a.gl_control_acct
                   || '-'
                   || a.gl_sub_acct_1
                   || '-'
                   || a.gl_sub_acct_2
                   || '-'
                   || a.gl_sub_acct_3
                   || '-'
                   || a.gl_sub_acct_4
                   || '-'
                   || a.gl_sub_acct_5
                   || '-'
                   || a.gl_sub_acct_6
                   || '-'
                   || a.gl_sub_acct_7 gl_acct,
                   b.gl_acct_name, debit_amt, credit_amt, sl_cd,
                   gslt_sl_type_cd, gacc_tran_id
              FROM giac_acct_entries a, giac_chart_of_accts b
             WHERE b.gl_acct_id = a.gl_acct_id
               AND check_user_per_iss_cd_acctg2 (NULL,
                                                 a.gacc_gibr_branch_cd,
                                                 'GIARPR001',
                                                 p_user_id
                                                ) = 1
               AND a.gacc_tran_id IN (
                      SELECT DISTINCT gacc_tran_id
                                 FROM giac_treaty_cessions
                                WHERE branch_cd = NVL (v_iss_cd, branch_cd)
                                  AND cession_mm =
                                         TO_NUMBER
                                              (TO_CHAR (TO_DATE (p_date,
                                                                 'MM/DD/YYYY'
                                                                ),
                                                        'MM'
                                                       )
                                              )
                                  AND cession_year =
                                         TO_NUMBER
                                              (TO_CHAR (TO_DATE (p_date,
                                                                 'MM/DD/YYYY'
                                                                ),
                                                        'YYYY'
                                                       )
                                              ))
          ORDER BY 1, 5)
      LOOP
         v_flag := TRUE;
         v_list.v_flag := 'Y';
         v_list.p_date := p_date;
         v_list.p_user_id := p_user_id;
         v_list.v_iss_cd := v_iss_cd;
         v_list.gl_acct := i.gl_acct;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.debit_amt := i.debit_amt;
         v_list.credit_amt := i.credit_amt;
         v_list.sl_cd := i.sl_cd;
         v_list.gslt_sl_type_cd := i.gslt_sl_type_cd;
         v_list.gacc_tran_id := i.gacc_tran_id;
         PIPE ROW (v_list);
      END LOOP;

      IF v_flag = FALSE
      THEN
         PIPE ROW (v_list);
      END IF;
   END get_giacr226_record;
END GIACR226_PKG;
/


