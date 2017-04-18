CREATE OR REPLACE PACKAGE CPI.giacr121_pkg
AS
   TYPE giacr121_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      title             VARCHAR2 (100),
      date_from         VARCHAR2 (50),
      date_to           VARCHAR2 (50),
      cut_off           VARCHAR2 (50),
      date_label        VARCHAR2 (100),
      v_not_exist       VARCHAR2 (8),
      ri_cd             giac_ri_stmt_ext.ri_cd%TYPE, --CarloR SR-5346 06.28.2016
      ri_name           giac_ri_stmt_ext.ri_name%TYPE,
      ri_address        giac_ri_stmt_ext.bill_address%TYPE,
      line_cd           giac_ri_stmt_ext.line_cd%TYPE, --CarloR SR-5346 06.28.2016
      line_name         VARCHAR2 (100),
      POLICY            giac_ri_stmt_ext.policy_no%TYPE,
      incept_date       giac_ri_stmt_ext.incept_date%TYPE,
      invoice_no        VARCHAR2 (50),
      assd_no           giac_ri_stmt_ext.assd_no%TYPE, --CarloR SR-5346 06.28.2016
      assd_name         giac_ri_stmt_ext.assd_name%TYPE,
      ri_policy_no      giac_ri_stmt_ext.ri_policy_no%TYPE,
      ri_binder_no      giac_ri_stmt_ext.ri_binder_no%TYPE,
      net_premium       NUMBER,
      ri_soa_text       giac_parameters.param_value_v%TYPE
   );

   TYPE giacr121_tab IS TABLE OF giacr121_type;

   FUNCTION populate_giacr121 (
      p_user        VARCHAR2,
      p_ri_cd       VARCHAR2,
      p_line_cd     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_cut_off     VARCHAR2
   )
      RETURN giacr121_tab PIPELINED;

   TYPE giacr121_footer_type1 IS RECORD (
      signatory     giis_signatory_names.signatory%TYPE,
      designation   giis_signatory_names.designation%TYPE,
      v_label       giac_rep_signatory.label%TYPE
   );

   TYPE giacr121_footer_tab1 IS TABLE OF giacr121_footer_type1;

   FUNCTION giacr121_footer1
      RETURN giacr121_footer_tab1 PIPELINED;

   TYPE giacr121_footer_type2 IS RECORD (
      signtry     giis_signatory_names.signatory%TYPE,
      dsgnation   giis_signatory_names.designation%TYPE,
      text        giac_rep_signatory.label%TYPE,
      flag        VARCHAR2 (50)
   );

   TYPE giacr121_footer_tab2 IS TABLE OF giacr121_footer_type2;

   FUNCTION giacr121_footer2
      RETURN giacr121_footer_tab2 PIPELINED;
END giacr121_pkg;
/


