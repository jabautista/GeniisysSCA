CREATE OR REPLACE PACKAGE BODY CPI.giacr164_pkg
AS
/*
** Created by   : Paolo J. Santos
** Date Created : 07.24.2013
** Reference By : GIACR164
** Description  : Statement of Accounts/ Facultative Premiums */
   FUNCTION column6gformula (p_column_no NUMBER, p_value NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF    p_column_no = 6
         OR p_column_no = 7
         OR p_column_no = 8
         OR p_column_no = 9
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;

      RETURN NULL;
   END;

   FUNCTION column5gformula (p_column_no NUMBER, p_value NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF p_column_no = 5
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;

      RETURN NULL;
   END;

   FUNCTION column4gformula (p_column_no NUMBER, p_value NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF p_column_no = 4
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;

      RETURN NULL;
   END;

   FUNCTION column3gformula (p_column_no NUMBER, p_value NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF p_column_no = 3
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;

      RETURN NULL;
   END;

   FUNCTION column2gformula (p_column_no NUMBER, p_value NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF p_column_no = 2
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;

      RETURN NULL;
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
         AND p_column_no != 9
      THEN
         RETURN p_value;
      ELSE
         RETURN 0;
      END IF;
   END;

   FUNCTION col6formula
      RETURN VARCHAR2
   IS
      v_value   giac_parameters.param_value_v%TYPE; -- VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_6';

      RETURN (v_value);
   END;

   FUNCTION col5formula
      RETURN VARCHAR2
   IS
      v_value   giac_parameters.param_value_v%TYPE; -- VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_5';

      RETURN (v_value);
   END;

   FUNCTION col4formula
      RETURN VARCHAR2
   IS
      v_value   giac_parameters.param_value_v%TYPE; -- VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_4';

      RETURN (v_value);
   END;

   FUNCTION col3formula
      RETURN VARCHAR2
   IS
      v_value   giac_parameters.param_value_v%TYPE; -- VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_3';

      RETURN (v_value);
   END;

   FUNCTION col2formula
      RETURN VARCHAR2
   IS
      v_value   giac_parameters.param_value_v%TYPE; -- VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_2';

      RETURN (v_value);
   END;

   FUNCTION col1formula
      RETURN VARCHAR2
   IS
      v_value   giac_parameters.param_value_v%TYPE; -- VARCHAR2 (20);
   BEGIN
      SELECT param_value_v
        INTO v_value
        FROM giac_parameters
       WHERE param_name = 'COLUMN_1';

      RETURN (v_value);
   END;

   FUNCTION cf_remarksformula
      RETURN CHAR
   IS
      v_remarks   VARCHAR2 (4000);
   BEGIN
      SELECT param_value_v
        INTO v_remarks
        FROM giac_parameters
       WHERE param_name = 'REMARKS';

      RETURN (v_remarks);
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

   FUNCTION cf_labelformula
      RETURN CHAR
   IS
      v_label   giac_rep_signatory.label%TYPE; -- VARCHAR2 (100);
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

   FUNCTION cf_1formula0010
      RETURN CHAR
   IS
      v_date_label   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE; -- VARCHAR2 (100);
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

   FUNCTION cf_company_addrformula
      RETURN VARCHAR2
   IS
      v_company_addr   giac_parameters.param_value_v%TYPE; -- VARCHAR2 (100);
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

   FUNCTION cf_company_nameformula
      RETURN VARCHAR2
   IS
      v_company_name   giis_parameters.param_value_v%TYPE; -- VARCHAR2 (100);
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

   FUNCTION get_giacr164q1_record (p_line_cd VARCHAR2, p_ri_cd NUMBER, p_user_id VARCHAR2)
      RETURN giacr164q1_record_tab PIPELINED
   IS
      v_not_exist   BOOLEAN        := TRUE; 
      v_list   giacr164q1_record_type;
   BEGIN
         v_list.cf_company_name := cf_company_nameformula;
         v_list.cf_company_addr := cf_company_addrformula;
         v_list.cf_title := cf_1formula;
         v_list.cf_date_label := cf_1formula0010;
         
      FOR i IN (SELECT   ri_cd, ri_name || '  -  ' || ri_cd ri_name,
                         bill_address address, line_name || ':' line_name,
                         incept_date, get_policy_no (policy_id) POLICY,
                         assd_name, ri_policy_no, ri_binder_no,
                            'RI'
                         || '-'
                         || TO_CHAR (prem_seq_no, 'FM099999999999')
                                                                   premseqno,
                         inst_no instno, acct_ent_date,
                         (  (gross_prem_amt + prem_vat)
                          - (ri_comm_exp + comm_vat)
                         ) balancedue,
                         column_no, due_date, --gross_prem_amt gross 
                         (  (gross_prem_amt + prem_vat)
                          - (ri_comm_exp + comm_vat)
                         ) gross --replaced formula of gross by robert SR 5291 02.04.16
                    FROM giac_ri_stmt_ext
                   WHERE ri_cd = NVL (p_ri_cd, ri_cd)
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND user_id = p_user_id
--                     AND check_user_per_line2(NVL(p_line_cd,line_cd), iss_cd, 'GIACS121', p_user_id) = 1  -- commented out by gab 09.30.2015
--                     AND check_user_per_iss_cd_acctg2(p_line_cd, iss_cd, 'GIACS121', p_user_id) = 1
                     AND iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line ('AC','GIACS121',p_user_id)))-- added by gab 09.30.2015
                ORDER BY ri_name, line_name)
      LOOP
         v_not_exist := FALSE;
         v_list.column1g := cf_1formula0005 (i.column_no, i.gross);
         v_list.column2g := column2gformula (i.column_no, i.gross);
         v_list.column3g := column3gformula (i.column_no, i.gross);
         v_list.column4g := column4gformula (i.column_no, i.gross);
         v_list.column5g := column5gformula (i.column_no, i.gross);
         v_list.column6g := column6gformula (i.column_no, i.gross);
         v_list.column1 := cf_1formula0005 (i.column_no, i.balancedue);
         v_list.column2 := column2gformula (i.column_no, i.balancedue);
         v_list.column3 := column3gformula (i.column_no, i.balancedue);
         v_list.column4 := column4gformula (i.column_no, i.balancedue);
         v_list.column5 := column5gformula (i.column_no, i.balancedue);
         v_list.column6 := column6gformula (i.column_no, i.balancedue);
         v_list.sumcolumn1g := cf_1formula0005 (i.column_no, i.gross);
         v_list.sumcolumn2g := column2gformula (i.column_no, i.gross);
         v_list.sumcolumn3g := column3gformula (i.column_no, i.gross);
         v_list.sumcolumn4g := column4gformula (i.column_no, i.gross);
         v_list.sumcolumn5g := column5gformula (i.column_no, i.gross);
         v_list.sumcolumn6g := column6gformula (i.column_no, i.gross);
         v_list.sumcolumn1 := cf_1formula0005 (i.column_no, i.balancedue);
         v_list.sumcolumn2 := column2gformula (i.column_no, i.balancedue);
         v_list.sumcolumn3 := column3gformula (i.column_no, i.balancedue);
         v_list.sumcolumn4 := column4gformula (i.column_no, i.balancedue);
         v_list.sumcolumn5 := column5gformula (i.column_no, i.balancedue);
         v_list.sumcolumn6 := column6gformula (i.column_no, i.balancedue);
         v_list.ri_name := i.ri_name;
         v_list.ri_cd := i.ri_cd;
         v_list.address := i.address;
         v_list.line_name := i.line_name;
         v_list.incept_date := i.incept_date;
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
         v_list.p_line_cd := p_line_cd;
         v_list.p_ri_cd := p_ri_cd;
         v_list.cf_signatory := cf_1formula0016;
         v_list.cf_remarks := cf_remarksformula;
         v_list.cf_label := cf_labelformula;
         v_list.col1 := col1formula;
         v_list.col2 := col2formula;
         v_list.col3 := col3formula;
         v_list.col4 := col4formula;
         v_list.col5 := col5formula;
         v_list.col6 := col6formula;
         v_list.POLICY := i.POLICY;
         v_list.v_sum_per_binder :=
              v_list.column1
            + v_list.column2
            + v_list.column3
            + v_list.column4
            + v_list.column5
            + v_list.column6;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.v_not_exist := 'TRUE';
         PIPE ROW (v_list);
      END IF;      
   END get_giacr164q1_record;

   FUNCTION get_giacr164q2_record
      RETURN giacr164q2_record_tab PIPELINED
   IS
      v_list   giacr164q2_record_type;
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
   END get_giacr164q2_record;

   FUNCTION get_giacr164q3_record
      RETURN giacr164q3_record_tab PIPELINED
   IS
      v_exist   BOOLEAN                := FALSE;
      v_list    giacr164q3_record_type;
   BEGIN
      FOR i IN (SELECT c.signatory SIGN, c.designation desig, b.label label
                  FROM giac_documents a,
                       giac_rep_signatory b,
                       giis_signatory_names c
                 WHERE a.report_no = b.report_no
                   AND b.signatory_id = c.signatory_id
                   AND a.report_id = 'GIACR164'
                   AND a.line_cd IS NULL)
      LOOP
         v_list.USERS := i.SIGN;
         v_list.designation := i.desig;
         v_list.text := i.label;
         v_list.company_name := cf_company_nameformula;
         v_exist := TRUE;
         PIPE ROW (v_list);
         EXIT;
      END LOOP;
   END;
END;
/


