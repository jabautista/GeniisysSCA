CREATE OR REPLACE PACKAGE BODY CPI.giacr164c_pkg
AS
/*
   ** Created by : Ariel P. Ignas Jr
   ** Date Created : 07.23.2013
   ** Reference By : GIACR164C
   ** Description : Statement of Accounts/Facultative Premiums
   */
   FUNCTION cf_company_nameformula
      RETURN VARCHAR2
   IS
      v_company_name   GIIS_PARAMETERS.PARAM_VALUE_V%TYPE; -- VARCHAR2 (100);
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

   FUNCTION cf_company_addrformula
      RETURN VARCHAR2
   IS
      v_company_addr   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE; --VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_company_addr
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_company_addr := ' ';
      END;

      RETURN (v_company_addr);
   END;

   FUNCTION cf_1formula
      RETURN CHAR
   IS
      v_title   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE; --VARCHAR2 (100);
   BEGIN
      v_title := giacp.v ('RI_SOA_TITLE');
      RETURN (v_title);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_title := '(NO EXISTING REPORT TITLE IN GIAC_PARAMETERS)';
         RETURN (v_title);
      WHEN TOO_MANY_ROWS
      THEN
         v_title := '(TOO MANY VALUES FOR REPORT TITLE IN GIAC_PARAMETERS)';
         RETURN (v_title);
   END;

   FUNCTION cf_1formula0010
      RETURN CHAR
   IS
      v_date_label   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE; --VARCHAR2 (100);
   BEGIN
      v_date_label := giacp.v ('RI_SOA_DATE_LABEL');
      RETURN (v_date_label);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_date_label := '(NO EXISTING DATE LABEL IN GIAC_PARAMETERS)';
         RETURN (v_date_label);
      WHEN TOO_MANY_ROWS
      THEN
         v_date_label :=
                        '(TOO MANY VALUES FOR DATE LABEL IN GIAC_PARAMETERS)';
         RETURN (v_date_label);
   END;

   FUNCTION cf_labelformula
      RETURN CHAR
   IS
      v_label   GIAC_REP_SIGNATORY.LABEL%TYPE; -- VARCHAR2 (100);
   BEGIN
      FOR i IN (SELECT label
                  FROM giac_rep_signatory
                 WHERE report_id = 'GIACR164')
      LOOP
         v_label := i.label;
         EXIT;
      END LOOP;

      RETURN (v_label);
   END;

   FUNCTION cf_1formula0016
      RETURN CHAR
   IS
      v_signatory   VARCHAR2 (100);
   BEGIN
      FOR i IN (SELECT signatory
                  FROM giac_rep_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND report_id = 'GIACR164')
      LOOP
         v_signatory := i.signatory;
         EXIT;
      END LOOP;

      RETURN (v_signatory);
   END;

   FUNCTION cf_remarksformula
      RETURN CHAR
   IS
      v_remarks   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE; -- VARCHAR2 (100);
   BEGIN
      SELECT param_value_v
        INTO v_remarks
        FROM giac_parameters
       WHERE param_name = 'REMARKS';

      RETURN (v_remarks);
   END;

   FUNCTION col1formula
      RETURN VARCHAR2
   IS
      v_value   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE; --VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_1';

      RETURN (v_value);
   END;

   FUNCTION col2formula
      RETURN VARCHAR2
   IS
      v_value   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE; --VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_2';

      RETURN (v_value);
   END;

   FUNCTION col3formula
      RETURN VARCHAR2
   IS
      v_value   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE; -- VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_3';

      RETURN (v_value);
   END;

   FUNCTION col4formula
      RETURN VARCHAR2
   IS
      v_value   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE; -- VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_4';

      RETURN (v_value);
   END;

   FUNCTION col5formula
      RETURN VARCHAR2
   IS
      v_value   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE; -- VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_5';

      RETURN (v_value);
   END;

   FUNCTION col6formula
      RETURN VARCHAR2
   IS
      v_value   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE; -- VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_6';

      RETURN (v_value);
   END;

   FUNCTION cf_1formula0005 (p_column_no NUMBER, p_value NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF     p_column_no != 2
         AND p_column_no != 3
         AND p_column_no != 4
         AND p_column_no != 5
         AND p_column_no != 6
         AND p_column_no != 7
         AND p_column_no != 8
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;
   END;

   FUNCTION cf_column2gformula (p_column_no NUMBER, p_value NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF p_column_no = 2
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;
   END;

   FUNCTION cf_column3gformula (p_column_no NUMBER, p_value NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF p_column_no = 3
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;
   END;

   FUNCTION cf_column4gformula (p_column_no NUMBER, p_value NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF p_column_no = 4
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;
   END;

   FUNCTION cf_column5gformula (p_column_no NUMBER, p_value NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF p_column_no = 5
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;
   END;

   FUNCTION cf_column6gformula (p_column_no NUMBER, p_value NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF p_column_no = 6 OR p_column_no = 7 OR p_column_no = 8
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;
   END;

   FUNCTION get_giacr164c_q1_record (p_ri_cd NUMBER, p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN giacr164c_q1_record_tab PIPELINED
   IS
      v_list   giacr164c_q1_record_type;
      v_test   BOOLEAN                  := TRUE;
   BEGIN
      v_list.cf_company_nameformula := cf_company_nameformula;
      v_list.cf_company_addrformula := cf_company_addrformula;
      v_list.cf_1formula := cf_1formula;
      v_list.cf_1formula0010 := cf_1formula0010;
      v_list.cf_labelformula := cf_labelformula;
      v_list.cf_1formula0016 := cf_1formula0016;
      v_list.cf_remarksformula := cf_remarksformula;
      v_list.ri_soa_header := giacp.v ('RI_SOA_HEADER');
      v_list.giacr121_header := giacp.v ('GIACR121_HEADER');

      FOR i IN (SELECT   ri_name || '  -  ' || ri_cd ri_name,
                         bill_address address, line_name || ':' line_name,
                         incept_date, policy_no POLICY, assd_name,
                         ri_policy_no, ri_binder_no,
                         'RI' || '-' || prem_seq_no premseqno,
                         inst_no instno, acct_ent_date,
                         (  (gross_prem_amt + prem_vat)
                          - (ri_comm_exp + comm_vat)
                         ) balancedue,
                         column_no, due_date, gross_prem_amt gross,
                         giac_ri_stmt_ext.currency_rt, currency_desc
                    FROM giac_ri_stmt_ext, giis_currency
                   WHERE ri_cd = NVL (p_ri_cd, ri_cd)
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND giac_ri_stmt_ext.user_id = p_user_id
                     AND giac_ri_stmt_ext.currency_cd = main_currency_cd
--                     AND check_user_per_line2(NVL(p_line_cd,giac_ri_stmt_ext.line_cd), giac_ri_stmt_ext.iss_cd, 'GIACS121', p_user_id) = 1 -- commented out by gab 09.30.2015
--                     AND check_user_per_iss_cd_acctg2(p_line_cd, giac_ri_stmt_ext.iss_cd, 'GIACS121', p_user_id) = 1
                     AND iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line ('AC','GIACS121',p_user_id)))-- added by gab 09.30.2015
                ORDER BY ri_name, line_name)
      LOOP
         v_test := FALSE;
         v_list.ri_name := i.ri_name;
         v_list.address := i.address;
         v_list.line_name := i.line_name;
         v_list.incept_date := i.incept_date;
         v_list.POLICY := i.POLICY;
         v_list.assd_name := i.assd_name;
         v_list.ri_policy_no := i.ri_policy_no;
         v_list.ri_binder_no := i.ri_binder_no;
         v_list.premseqno := i.premseqno;
         v_list.instno := i.instno;
         v_list.acct_ent_date := i.acct_ent_date;
         v_list.balancedue := i.balancedue;
         v_list.column_no := i.column_no;
         v_list.due_date := i.due_date;
         v_list.gross := i.gross;
         v_list.currency_rt := i.currency_rt;
         v_list.currency_desc := i.currency_desc;
         v_list.p_ri_cd := p_ri_cd;
         v_list.p_line_cd := p_line_cd;
         v_list.col1formula := col1formula;
         v_list.col2formula := col2formula;
         v_list.col3formula := col3formula;
         v_list.col4formula := col4formula;
         v_list.col5formula := col5formula;
         v_list.col6formula := col6formula;
         v_list.cf_column1g := cf_1formula0005 (i.column_no, i.gross);
         v_list.cf_column2g := cf_column2gformula (i.column_no, i.gross);
         v_list.cf_column3g := cf_column3gformula (i.column_no, i.gross);
         v_list.cf_column4g := cf_column4gformula (i.column_no, i.gross);
         v_list.cf_column5g := cf_column5gformula (i.column_no, i.gross);
         v_list.cf_column6g := cf_column6gformula (i.column_no, i.gross);
         v_list.sum_gross :=
              v_list.cf_column1g
            + v_list.cf_column2g
            + v_list.cf_column3g
            + v_list.cf_column4g
            + v_list.cf_column5g
            + v_list.cf_column6g;
         v_list.column1 := cf_1formula0005 (i.column_no, i.balancedue);
         v_list.column2 := cf_column2gformula (i.column_no, i.balancedue);
         v_list.column3 := cf_column3gformula (i.column_no, i.balancedue);
         v_list.column4 := cf_column4gformula (i.column_no, i.balancedue);
         v_list.column5 := cf_column5gformula (i.column_no, i.balancedue);
         v_list.column6 := cf_column6gformula (i.column_no, i.balancedue);
         v_list.sum_per_binder :=
              v_list.column1
            + v_list.column2
            + v_list.column3
            + v_list.column4
            + v_list.column5
            + v_list.column6;
         v_list.multiple_signatory := giacp.v ('MULTIPLE_SIGNATORY');
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giacr164c_q1_record;

   FUNCTION get_giacr164c_q2_record
      RETURN giacr164c_q2_record_tab PIPELINED
   IS
      v_list   giacr164c_q2_record_type;
   BEGIN
      FOR i IN (SELECT c.signatory, c.designation, b.label
                  FROM giac_documents a,
                       giac_rep_signatory b,
                       giis_signatory_names c
                 WHERE a.report_no = b.report_no
                   AND b.signatory_id = c.signatory_id
                   AND a.report_id = 'GIACR164')
      LOOP
         v_list.signatory := i.signatory;
         v_list.designation := i.designation;
         v_list.label := i.label;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr164c_q2_record;

   FUNCTION get_giacr164c_q3_record
      RETURN giacr164c_q3_record_tab PIPELINED
   IS
      v_list   giacr164c_q3_record_type;
   BEGIN
      FOR abc IN (SELECT c.signatory SIGN, c.designation desig,
                         b.label label
                    FROM giac_documents a,
                         giac_rep_signatory b,
                         giis_signatory_names c
                   WHERE a.report_no = b.report_no
                     AND b.signatory_id = c.signatory_id
                     AND a.report_id = 'GIACR164'
                     AND a.line_cd IS NULL)
      LOOP
         v_list.users := abc.SIGN;
         v_list.designation := abc.desig;
         v_list.text := abc.label;
         PIPE ROW (v_list);
         EXIT;
      END LOOP;
   END get_giacr164c_q3_record;
END;
/


