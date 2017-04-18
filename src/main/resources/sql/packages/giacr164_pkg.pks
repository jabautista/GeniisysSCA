CREATE OR REPLACE PACKAGE CPI.giacr164_pkg
AS
/*
** Created by   : Paolo J. Santos
** Date Created : 07.24.2013
** Reference By : GIACR164
** Description  : Statement of Accounts/ Facultative Premiums */
   TYPE giacr164q1_record_type IS RECORD (
      ri_name              VARCHAR2 (95),
      ri_cd                NUMBER (5),
      address              VARCHAR2 (155),
      line_name            VARCHAR2 (20),
      incept_date          DATE,
      assd_name            VARCHAR2 (500),
      ri_policy_no         VARCHAR2 (27),
      ri_binder_no         VARCHAR2 (20),
      premseqno            VARCHAR2 (47),
      instno               NUMBER (2),
      acct_ent_date        DATE,
      balancedue           NUMBER (16, 2),
      column_no            NUMBER (2),
      due_date             DATE,
      gross                NUMBER (16, 2),
      p_line_cd            VARCHAR2 (40),
      p_ri_cd              NUMBER (38),
      cf_company_name      GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (100),
      cf_company_addr      GIIS_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (100),
      cf_title             GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (350),
      cf_date_label        GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, --VARCHAR2 (350),
      cf_signatory         VARCHAR2 (350),
      cf_remarks           VARCHAR2 (4000),
      cf_label             giac_rep_signatory.label%TYPE, --VARCHAR2 (20),
      col1                 giac_parameters.param_value_v%TYPE, --VARCHAR2 (20),
      col2                 giac_parameters.param_value_v%TYPE, --VARCHAR2 (20),
      col3                 giac_parameters.param_value_v%TYPE, --VARCHAR2 (20),
      col4                 giac_parameters.param_value_v%TYPE, --VARCHAR2 (20),
      col5                 giac_parameters.param_value_v%TYPE, --VARCHAR2 (20),
      col6                 giac_parameters.param_value_v%TYPE, --VARCHAR2 (20),
      POLICY               VARCHAR2 (50),
      column1g             NUMBER (16, 2),
      column2g             NUMBER (16, 2),
      column3g             NUMBER (16, 2),
      column4g             NUMBER (16, 2),
      column5g             NUMBER (16, 2),
      column6g             NUMBER (16, 2),
      column1              NUMBER (16, 2),
      column2              NUMBER (16, 2),
      column3              NUMBER (16, 2),
      column4              NUMBER (16, 2),
      column5              NUMBER (16, 2),
      column6              NUMBER (16, 2),
      sumcolumn1g          NUMBER (16, 2),
      sumcolumn1           NUMBER (16, 2),
      sumcolumn2g          NUMBER (16, 2),
      sumcolumn2           NUMBER (16, 2),
      sumcolumn3g          NUMBER (16, 2),
      sumcolumn3           NUMBER (16, 2),
      sumcolumn4g          NUMBER (16, 2),
      sumcolumn4           NUMBER (16, 2),
      sumcolumn5g          NUMBER (16, 2),
      sumcolumn5           NUMBER (16, 2),
      sumcolumn6g          NUMBER (16, 2),
      sumcolumn6           NUMBER (16, 2),
      v_sum_per_binder     NUMBER (16, 2),
      multiple_signatory   VARCHAR2 (1),
      ri_soa_header        VARCHAR2 (1),
      giacr121_header      VARCHAR (1),
      v_not_exist          VARCHAR2 (8)
   );

   TYPE giacr164q1_record_tab IS TABLE OF giacr164q1_record_type;

   FUNCTION get_giacr164q1_record (p_line_cd VARCHAR2, p_ri_cd NUMBER, p_user_id VARCHAR2)
      RETURN giacr164q1_record_tab PIPELINED;

   TYPE giacr164q2_record_type IS RECORD (
      signatory     VARCHAR2 (50),
      designation   VARCHAR2 (50),
      label         VARCHAR2 (200)
   );

   TYPE giacr164q2_record_tab IS TABLE OF giacr164q2_record_type;

   FUNCTION get_giacr164q2_record
      RETURN giacr164q2_record_tab PIPELINED;

   TYPE giacr164q3_record_type IS RECORD (
      USERS         giis_signatory_names.signatory%TYPE,
      designation   giis_signatory_names.designation%TYPE,
      text          giac_rep_signatory.label%TYPE,
      company_name  giac_parameters.param_value_v%TYPE-- VARCHAR2 (100)
   );

   TYPE giacr164q3_record_tab IS TABLE OF giacr164q3_record_type;

   FUNCTION get_giacr164q3_record
      RETURN giacr164q3_record_tab PIPELINED;
END;
/


