CREATE OR REPLACE PACKAGE CPI.giacs206_pkg
AS
   /*
   ** Created by : J. Diago
   ** Date Created : 08.02.2013
   ** Reference by : Aging by Age Level (For a Given Assured)
   */
   TYPE giacs206_dtls_type IS RECORD (
      aging_id                giac_aging_parameters.aging_id%TYPE,
      assd_no                 giis_assured.assd_no%TYPE,
      assd_name               giis_assured.assd_name%TYPE,
      dsp_gibr_gfun_fund_cd   giac_aging_parameters.gibr_gfun_fund_cd%TYPE,
      dsp_gibr_branch_cd      giac_aging_parameters.gibr_branch_cd%TYPE,
      dsp_column_heading      giac_aging_parameters.column_heading%TYPE,
      balance_amt_due         giac_aging_summaries_v.balance_amt_due%TYPE,
      sum_balance_amt_due     giac_aging_summaries_v.balance_amt_due%TYPE
   );

   TYPE giacs206_dtls_tab IS TABLE OF giacs206_dtls_type;

   FUNCTION get_giacs206_dtls (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_aging_id    giac_aging_parameters.aging_id%TYPE,
      p_assd_no     giac_aging_soa_details.a020_assd_no%TYPE
   )
      RETURN giacs206_dtls_tab PIPELINED;
END;
/


