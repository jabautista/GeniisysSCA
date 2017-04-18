CREATE OR REPLACE PACKAGE CPI.giacr164c_pkg
AS
   TYPE giacr164c_q1_record_type IS RECORD (
      ri_name                  VARCHAR2 (100),
      address                  VARCHAR2 (155),
      line_name                VARCHAR2 (25),
      incept_date              DATE,
      POLICY                   VARCHAR2 (50),
      assd_name                VARCHAR2 (500),
      ri_policy_no             VARCHAR2 (27),
      ri_binder_no             VARCHAR2 (20),
      premseqno                VARCHAR2 (43),
      instno                   NUMBER (2),
      acct_ent_date            DATE,
      balancedue               NUMBER (16, 2),
      column_no                NUMBER (2),
      due_date                 DATE,
      gross                    NUMBER (16, 2),
      currency_rt              NUMBER (12, 9),
      currency_desc            VARCHAR2 (20),
      cf_company_nameformula   GIIS_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (100),
      cf_company_addrformula   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (100),
      cf_1formula              GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (100),
      cf_1formula0010          GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (100),
      cf_labelformula          GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (100),
      cf_1formula0016          VARCHAR2 (100),
      cf_remarksformula        GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (100),
      v_test                   VARCHAR2 (1),
      p_ri_cd                  NUMBER (5),
      p_line_cd                VARCHAR2 (2),
      p_column_no              NUMBER (2),
      p_value                  NUMBER (16, 2),
      col1formula              GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (20),
      col2formula              GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (20),
      col3formula              GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (20),
      col4formula              GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (20),
      col5formula              GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (20),
      col6formula              GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (20),
      cf_1formula0005          NUMBER (16, 2),
      cf_column2gformula       NUMBER (16, 2),
      cf_column3gformula       NUMBER (16, 2),
      cf_column4gformula       NUMBER (16, 2),
      cf_column5gformula       NUMBER (16, 2),
      cf_column6gformula       NUMBER (16, 2),
      cf_column1g              NUMBER (16, 2),
      cf_column2g              NUMBER (16, 2),
      cf_column3g              NUMBER (16, 2),
      cf_column4g              NUMBER (16, 2),
      cf_column5g              NUMBER (16, 2),
      cf_column6g              NUMBER (16, 2),
      column1                  NUMBER (16, 2),
      column2                  NUMBER (16, 2),
      column3                  NUMBER (16, 2),
      column4                  NUMBER (16, 2),
      column5                  NUMBER (16, 2),
      column6                  NUMBER (16, 2),
      sum_gross                NUMBER (16, 2),
      sum_per_binder           NUMBER (16, 2),
      multiple_signatory       VARCHAR2 (1),
      ri_soa_header            GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (1),
      giacr121_header          GIAC_PARAMETERS.PARAM_VALUE_V%TYPE --VARCHAR2 (1)
   );

   TYPE giacr164c_q1_record_tab IS TABLE OF giacr164c_q1_record_type;

   FUNCTION get_giacr164c_q1_record (p_ri_cd NUMBER, p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN giacr164c_q1_record_tab PIPELINED;

   TYPE giacr164c_q2_record_type IS RECORD (
      signatory     VARCHAR2 (50),
      designation   VARCHAR2 (50),
      label         VARCHAR2 (200)
   );

   TYPE giacr164c_q2_record_tab IS TABLE OF giacr164c_q2_record_type;

   FUNCTION get_giacr164c_q2_record
      RETURN giacr164c_q2_record_tab PIPELINED;

   TYPE giacr164c_q3_record_type IS RECORD (
      users         giis_signatory_names.signatory%TYPE,
      designation   giis_signatory_names.designation%TYPE,
      text          giac_rep_signatory.label%TYPE
   );

   TYPE giacr164c_q3_record_tab IS TABLE OF giacr164c_q3_record_type;

   FUNCTION get_giacr164c_q3_record
      RETURN giacr164c_q3_record_tab PIPELINED;
END;
/


