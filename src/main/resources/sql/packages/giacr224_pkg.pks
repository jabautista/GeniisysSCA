CREATE OR REPLACE PACKAGE CPI.giacr224_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company        VARCHAR2 (50),
      cf_com_address    VARCHAR2 (200),
      report_title      VARCHAR2 (350),
      report_subtitle   VARCHAR2 (350),
      ri_cd             giac_ri_stmt_ext.ri_cd%TYPE,
      ri_name           giac_ri_stmt_ext.ri_name%TYPE,
      address           giac_ri_stmt_ext.bill_address%TYPE,
      line_cd           giac_ri_stmt_ext.line_cd%TYPE,
      line_name         VARCHAR2 (21),
      assd_no           giac_ri_stmt_ext.assd_no%TYPE, -- added by Daniel Marasigan SR 5347 07.05.2016
      assd_name         giac_ri_stmt_ext.assd_name%TYPE,
      ri_binder_no      giac_ri_stmt_ext.ri_binder_no%TYPE,
      POLICY            giac_ri_stmt_ext.policy_no%TYPE,
      ri_policy_no      giac_ri_stmt_ext.ri_policy_no%TYPE,
      prem_amt          NUMBER (38, 2),
      tax_amt           NUMBER (38, 2),
      ri_comm_amt       NUMBER (38, 2),
      ri_comm_vat       NUMBER (38, 2),
      net_premium       NUMBER (38, 2),
      collection_amt    NUMBER (38, 2),
      balance           NUMBER (38, 2),
      mult_signatory    giac_parameters.param_value_v%TYPE,
      signatory         giis_signatory_names.signatory%TYPE,
      designation       giis_signatory_names.designation%TYPE,
      label             giac_rep_signatory.label%TYPE,
      v_not_exist       VARCHAR2 (8)
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   TYPE get_multiple_signatory_type IS RECORD (
      mult_signatory   giac_parameters.param_value_v%TYPE,
      signatory        giis_signatory_names.signatory%TYPE,
      designation      giis_signatory_names.designation%TYPE,
      label            giac_rep_signatory.label%TYPE
   );

   TYPE get_multiple_signatory_tab IS TABLE OF get_multiple_signatory_type;

   FUNCTION get_details (p_user VARCHAR2, p_ri_cd NUMBER, p_line_cd VARCHAR2)
      RETURN get_details_tab PIPELINED;

   FUNCTION get_multiple_signatory
      RETURN get_multiple_signatory_tab PIPELINED;
END;
/
