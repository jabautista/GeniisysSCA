CREATE OR REPLACE PACKAGE CPI.giacs203_pkg
AS
   /*
   ** Created by : J. Diago
   ** Date Created " 08.02.2013
   ** Reference by : GIACS203 List of Bills Under an Age Level
   */
   TYPE giacs203_dtls_type IS RECORD (
      aging_id              giac_aging_parameters.aging_id%TYPE,
      gibr_gfun_fund_cd     giac_aging_parameters.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd        giac_aging_parameters.gibr_branch_cd%TYPE,
      column_heading        giac_aging_parameters.column_heading%TYPE,
      sum_balance_amt_due   giac_aging_soa_details.balance_amt_due%TYPE,
      a020_assd_no          giac_aging_soa_details.a020_assd_no%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      bill_no               VARCHAR2 (50),
      inst_no               giac_aging_soa_details.inst_no%TYPE,
      total_amount_due      giac_aging_soa_details.total_amount_due%TYPE,
      total_payments        giac_aging_soa_details.total_payments%TYPE,
      temp_payments         giac_aging_soa_details.temp_payments%TYPE,
      balance_amt_due       giac_aging_soa_details.balance_amt_due%TYPE,
      prem_balance_due      giac_aging_soa_details.prem_balance_due%TYPE,
      tax_balance_due       giac_aging_soa_details.tax_balance_due%TYPE
   );

   TYPE giacs203_dtls_tab IS TABLE OF giacs203_dtls_type;

   FUNCTION get_giacs203_dtls (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_aging_id    giac_aging_parameters.aging_id%TYPE,
      p_assd_no     giac_aging_soa_details.a020_assd_no%TYPE
   )
      RETURN giacs203_dtls_tab PIPELINED;
END;
/


