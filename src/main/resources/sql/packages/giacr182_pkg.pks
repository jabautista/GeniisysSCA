CREATE OR REPLACE PACKAGE CPI.giacr182_pkg
AS
   TYPE giacr182_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      report_title      VARCHAR2 (100),
      report_title2     VARCHAR2 (100),
      fund_cd           giac_dueto_asof_ext.fund_cd%TYPE,
      branch_cd         giac_dueto_asof_ext.branch_cd%TYPE,
      ri_cd             giac_dueto_asof_ext.ri_cd%TYPE,
      ri_name           giac_dueto_asof_ext.ri_name%TYPE,
      policy_id         giac_dueto_asof_ext.policy_id%TYPE,
      policy_no         giac_dueto_asof_ext.policy_no%TYPE,
      fnl_binder_id     giac_dueto_asof_ext.fnl_binder_id%TYPE,
      line_cd           giac_dueto_asof_ext.line_cd%TYPE,
      binder_yy         giac_dueto_asof_ext.binder_yy%TYPE,
      binder_seq_no     giac_dueto_asof_ext.binder_seq_no%TYPE,
      binder_date       VARCHAR2 (50),
      booking_date      VARCHAR2 (50),
      amt_insured       giac_dueto_asof_ext.amt_insured%TYPE,
      net_premium       giac_dueto_asof_ext.amt_insured%TYPE,
      assd_no           giac_dueto_asof_ext.assd_no%TYPE,
      assd_name         giac_dueto_asof_ext.assd_name%TYPE,
      cut_off_date      VARCHAR2 (50),
      from_date         VARCHAR2 (50),
      TO_DATE           VARCHAR2 (50)
   );

   TYPE giacr182_tab IS TABLE OF giacr182_type;

   TYPE giacr182_sum_per_ri_type IS RECORD (
      ri_cd         giac_dueto_asof_ext.ri_cd%TYPE,
      ri_name       giac_dueto_asof_ext.ri_name%TYPE,
      net_premium   giac_dueto_asof_ext.amt_insured%TYPE
   );

   TYPE giacr182_sum_per_ri_tab IS TABLE OF giacr182_sum_per_ri_type;

   TYPE giacr182_sum_per_line_type IS RECORD (
      ri_cd         giac_dueto_asof_ext.ri_cd%TYPE,
      line_cd       giac_dueto_asof_ext.line_cd%TYPE,
      line_name     giis_line.line_name%TYPE,
      net_premium   giac_dueto_asof_ext.amt_insured%TYPE
   );

   TYPE giacr182_sum_per_line_tab IS TABLE OF giacr182_sum_per_line_type;

   FUNCTION get_giacr182_details (
      p_ri_cd     giac_dueto_asof_ext.ri_cd%TYPE,
      p_line_cd   giac_dueto_asof_ext.line_cd%TYPE,
      p_user_id   giac_dueto_asof_ext.user_id%TYPE
   )
      RETURN giacr182_tab PIPELINED;

   FUNCTION get_giacr182_sum_per_ri (
      p_ri_cd     giac_dueto_asof_ext.ri_cd%TYPE,
      p_user_id   giac_dueto_asof_ext.user_id%TYPE
   )
      RETURN giacr182_sum_per_ri_tab PIPELINED;

   FUNCTION get_giacr182_sum_per_line (
      p_ri_cd     giac_dueto_asof_ext.ri_cd%TYPE,
      p_line_cd   giac_dueto_asof_ext.line_cd%TYPE,
      p_user_id   giac_dueto_asof_ext.user_id%TYPE
   )
      RETURN giacr182_sum_per_line_tab PIPELINED;

   FUNCTION get_giacr182_sum_recap (
      p_ri_cd     giac_dueto_asof_ext.ri_cd%TYPE,
      p_line_cd   giac_dueto_asof_ext.line_cd%TYPE,
      p_user_id   giac_dueto_asof_ext.user_id%TYPE
   )
      RETURN giacr182_sum_per_line_tab PIPELINED;

   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2;

   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2;

   FUNCTION get_cf_line_nameformula (
      p_line_cd   giac_dueto_asof_ext.line_cd%TYPE
   )
      RETURN VARCHAR2;
END;
/


