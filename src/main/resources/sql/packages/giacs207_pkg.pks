CREATE OR REPLACE PACKAGE CPI.giacs207_pkg
AS
   TYPE giacs207_dtls_type IS RECORD (
      assd_no                giis_assured.assd_no%TYPE,
      assd_name              giis_assured.assd_name%TYPE,
      aging_id               giac_aging_parameters.aging_id%TYPE,
      column_heading         giac_aging_parameters.column_heading%TYPE,
      iss_cd                 giac_aging_soa_details.iss_cd%TYPE,
      prem_seq_no            giac_aging_soa_details.prem_seq_no%TYPE,
      bill_no                VARCHAR2 (100),
      balance_amt_due        giac_aging_soa_details.balance_amt_due%TYPE,
      total_payments         giac_aging_soa_details.total_payments%TYPE,
      total_amount_due       giac_aging_soa_details.total_amount_due%TYPE,
      sum_balance_amt_due    giac_aging_soa_details.balance_amt_due%TYPE,
      sum_total_payments     giac_aging_soa_details.total_payments%TYPE,
      sum_total_amount_due   giac_aging_soa_details.total_amount_due%TYPE
   );

   TYPE giacs207_dtls_tab IS TABLE OF giacs207_dtls_type;

   FUNCTION get_giacs207_dtls (
      p_assd_no           giis_assured.assd_no%TYPE,
      p_aging_id          giac_aging_parameters.aging_id%TYPE,
      p_branch_cd         giis_issource.iss_cd%TYPE,
      p_column_heading    giac_aging_parameters.column_heading%TYPE,
      p_iss_cd            giis_issource.iss_cd%TYPE,
      p_bill_no           VARCHAR2,
      p_balance_amt_due   giac_aging_soa_details.balance_amt_due%TYPE,
      p_total_payments    giac_aging_soa_details.total_payments%TYPE,
      p_total_amt_due     giac_aging_soa_details.total_amount_due%TYPE
   )
      RETURN giacs207_dtls_tab PIPELINED;

   TYPE giacs207_assd_list_type IS RECORD (
      assd_no           giis_assured.assd_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      balance_amt_due   giac_soa_summaries_v.balance_amt_due%TYPE
   );

   TYPE giacs207_assd_list_tab IS TABLE OF giacs207_assd_list_type;

   FUNCTION get_assured_list_dtls(
      p_assd_no           giis_assured.assd_no%TYPE,
      p_assd_name         giis_assured.assd_name%TYPE,
      p_balance_amt_due   giac_soa_summaries_v.balance_amt_due%TYPE
   )
      RETURN giacs207_assd_list_tab PIPELINED;
END;
/


