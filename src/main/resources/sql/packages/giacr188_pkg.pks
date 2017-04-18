CREATE OR REPLACE PACKAGE CPI.giacr188_pkg
AS
   TYPE giacr188_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      report_title      VARCHAR2 (100),
      report_title2     VARCHAR2 (100),
      ri_name           giac_dueto_asof_ext.ri_name%TYPE,
      line_name         giis_line.line_name%TYPE,
      booking_date      giac_dueto_asof_ext.booking_date%TYPE,
      binder_no         VARCHAR2 (50),
      policy_no         giac_dueto_asof_ext.policy_no%TYPE,
      incept_date       VARCHAR2 (20),
      binder_date       VARCHAR2 (20),
      ref_pol_no        giac_dueto_asof_ext.ref_pol_no%TYPE,
      assd_name         giac_dueto_asof_ext.assd_name%TYPE,
      amt_insured       giac_dueto_asof_ext.amt_insured%TYPE,
      ri_prem_amt       giac_dueto_asof_ext.ri_prem_amt%TYPE,
      ri_comm_amt           giac_dueto_asof_ext.ri_comm_amt%TYPE,
      net_premium       giac_dueto_asof_ext.amt_insured%TYPE,
      prem_vat          giac_dueto_asof_ext.prem_vat%TYPE,
      comm_vat          giac_dueto_asof_ext.comm_vat%TYPE,
      wholding_vat      giac_dueto_asof_ext.wholding_vat%TYPE,
      from_date         VARCHAR2 (20),
      TO_DATE           VARCHAR2 (20),
      cut_off_date      VARCHAR2 (20)
   );

   TYPE giacr188_tab IS TABLE OF giacr188_type;

   FUNCTION get_giacr188_details (
      p_ri_cd     giac_dueto_asof_ext.ri_cd%TYPE,
      p_line_cd   giac_dueto_asof_ext.line_cd%TYPE,
      p_user_id   giac_dueto_asof_ext.user_id%TYPE
   )
      RETURN giacr188_tab PIPELINED;

   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2;

   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2;
END;
/


