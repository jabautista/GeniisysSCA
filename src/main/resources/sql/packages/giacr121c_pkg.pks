CREATE OR REPLACE PACKAGE CPI.giacr121c_pkg
AS
   TYPE giacr121c_type IS RECORD (
      company_name      VARCHAR2 (100),
      company_address   VARCHAR2 (200),
      title             VARCHAR2 (100),
      date_label        VARCHAR2 (100),
      date_from         VARCHAR2 (100),
      date_to           VARCHAR2 (100),
      cut_off           VARCHAR2 (100),
      v_not_exist       VARCHAR2 (2),
      ri_name           giac_ri_stmt_ext.ri_name%TYPE,
      address           giac_ri_stmt_ext.bill_address%TYPE,
      currency_desc     giis_currency.currency_desc%TYPE,
      currency_rt       giac_ri_stmt_ext.currency_rt%TYPE,
      line_name         giac_ri_stmt_ext.line_name%TYPE,
      POLICY            giac_ri_stmt_ext.policy_no%TYPE,
      incept_date       giac_ri_stmt_ext.incept_date%TYPE,
      invoice_no        VARCHAR2 (50),
      assd_name         giac_ri_stmt_ext.assd_name%TYPE,
      ri_policy_no      giac_ri_stmt_ext.ri_policy_no%TYPE,
      ri_binder_no      giac_ri_stmt_ext.ri_binder_no%TYPE,
      net_premium       NUMBER,
      prem_warr_tag     VARCHAR2 (5),
      ri_soa_text       giac_parameters.param_value_v%TYPE,
      multiple_sign     giac_parameters.param_value_v%TYPE
   );

   TYPE giacr121c_tab IS TABLE OF giacr121c_type;

   FUNCTION populate_giacr121c (
      p_date_from   VARCHAR2,
      p_date_to     VARCHAR2,
      p_cut_off     VARCHAR2,
      p_line_cd     VARCHAR2,
      p_ri_cd       VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr121c_tab PIPELINED;

   TYPE giacr121c_signatory_type IS RECORD (
      signatory     giis_signatory_names.signatory%TYPE,
      designation   giis_signatory_names.designation%TYPE,
      label         giac_rep_signatory.label%TYPE
   );

   TYPE giacr121c_signatory_tab IS TABLE OF giacr121c_signatory_type;

   FUNCTION populate_giacr121c_signatory
      RETURN giacr121c_signatory_tab PIPELINED;

   TYPE giacr121c_variables_type IS RECORD (
      signatory     giis_signatory_names.signatory%TYPE,
      designation   giis_signatory_names.designation%TYPE,
      label         giac_rep_signatory.label%TYPE
   );

   TYPE giacr121c_variables_tab IS TABLE OF giacr121c_variables_type;

   FUNCTION populate_giacr121c_variables
      RETURN giacr121c_variables_tab PIPELINED;
END giacr121c_pkg;
/


