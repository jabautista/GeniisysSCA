CREATE OR REPLACE PACKAGE BODY CPI.giacr107_pkg
AS
   FUNCTION get_giacr107_company
      RETURN VARCHAR2
   IS
      v_company   VARCHAR2 (100);
   BEGIN
      SELECT param_value_v
        INTO v_company
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_company);
   END get_giacr107_company;

   FUNCTION get_giacr107_company_address
      RETURN CHAR
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
         RETURN (v_address);
   END;

   FUNCTION get_giacr107_period (p_date1 DATE, p_date2 DATE)
      RETURN VARCHAR2
   IS
      v_period   VARCHAR2 (50);
   BEGIN
      SELECT 'From ' || TO_CHAR (p_date1, 'fm Month dd, yyyy') || ' to ' || TO_CHAR (p_date2, 'fm Month dd, yyyy')
        INTO v_period
        FROM DUAL;

      RETURN (v_period);
   END get_giacr107_period;

   FUNCTION get_giacr107_records (p_date1 VARCHAR2, p_date2 VARCHAR2, p_exclude_tag VARCHAR2, p_module_id VARCHAR2, p_payee VARCHAR2, p_post_tran_toggle VARCHAR2, p_user_id giis_users.user_id%TYPE)
      RETURN giacr107_record_tab PIPELINED
   IS
      v_list   giacr107_record_type;
      v_exist  VARCHAR2(1) := 'N';
      v_date1  DATE := TO_DATE (p_date1, 'MM/DD/RRRR');
      v_date2  DATE := TO_DATE (p_date2, 'MM/DD/RRRR');
   BEGIN
      FOR i IN (SELECT   a.payee_class_cd, INITCAP (d.class_desc) class_desc, a.payee_cd,
                         RTRIM (b.payee_last_name) || DECODE (b.payee_first_name, '', DECODE (b.payee_middle_name, '', NULL, ','), ',') || RTRIM (b.payee_first_name) || ' '
                         || b.payee_middle_name NAME, SUM (a.income_amt) income, SUM (a.wholding_tax_amt) wtax
                    FROM giac_taxes_wheld a, giis_payees b, giac_acctrans c, giis_payee_class d
                   WHERE a.gacc_tran_id NOT IN (SELECT e.gacc_tran_id
                                                  FROM giac_reversals e, giac_acctrans f
                                                 WHERE e.reversing_tran_id = f.tran_id AND f.tran_flag <> 'D')
                     AND a.payee_class_cd = b.payee_class_cd
                     AND a.payee_cd = b.payee_no
                     AND b.payee_class_cd = d.payee_class_cd
                     AND a.gacc_tran_id = c.tran_id
                     AND c.tran_flag <> 'D'
                     AND a.payee_class_cd = NVL (p_payee, a.payee_class_cd)
                     AND ((TRUNC (c.tran_date) BETWEEN v_date1 AND v_date2 AND p_post_tran_toggle = 'T') OR (TRUNC (c.posting_date) BETWEEN v_date1 AND v_date2 AND p_post_tran_toggle = 'P'))
                     AND ((p_post_tran_toggle = 'T' AND c.tran_flag <> NVL (p_exclude_tag, ' ')) OR p_post_tran_toggle = 'P')
                     AND check_user_per_iss_cd_acctg2 (NULL, c.gibr_branch_cd, p_module_id, p_user_id) = 1
                GROUP BY a.payee_class_cd,
                         d.class_desc,
                         a.payee_cd,
                         RTRIM (b.payee_last_name) || DECODE (b.payee_first_name, '', DECODE (b.payee_middle_name, '', NULL, ','), ',') || RTRIM (b.payee_first_name) || ' ' || b.payee_middle_name
                ORDER BY d.class_desc,
                         RTRIM (b.payee_last_name) || DECODE (b.payee_first_name, '', DECODE (b.payee_middle_name, '', NULL, ','), ',') || RTRIM (b.payee_first_name) || ' ' || b.payee_middle_name)
      LOOP
         v_list.payee_class_cd := i.payee_class_cd;
         v_list.class_desc := i.class_desc;
         v_list.payee_cd := i.payee_cd;
         v_list.NAME := i.NAME;
         v_list.income_amt := i.income;
         v_list.wholding_tax_amt := i.wtax;
         v_list.company := get_giacr107_company;
         v_list.company_address := get_giacr107_company_address;
         v_list.period := get_giacr107_period (v_date1, v_date2);
         v_exist := 'Y';
         
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_exist = 'N' THEN
         v_list.company := get_giacr107_company;
         v_list.company_address := get_giacr107_company_address;
         v_list.exist := 'N';
         
         PIPE ROW(v_list);
      END IF;
   END get_giacr107_records;
END;
/


