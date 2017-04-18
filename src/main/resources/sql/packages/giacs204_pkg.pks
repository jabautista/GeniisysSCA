CREATE OR REPLACE PACKAGE CPI.giacs204_pkg
AS
   TYPE giacs204_dtls_type IS RECORD (
      column_heading        giac_aging_parameters.column_heading%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      iss_cd                giac_aging_soa_details.iss_cd%TYPE,
      prem_seq_no           giac_aging_soa_details.prem_seq_no%TYPE,
      bill_no               VARCHAR2 (100),
      total_amount_due      giac_aging_soa_details.total_amount_due%TYPE,
      total_payments        giac_aging_soa_details.total_payments%TYPE,
      balance_amt_due       giac_aging_soa_details.balance_amt_due%TYPE,
      sum_balance_amt_due   giac_aging_soa_details.balance_amt_due%TYPE
   );

   TYPE giacs204_dtls_tab IS TABLE OF giacs204_dtls_type;

   FUNCTION get_giacs204_dtls (
      p_aging_id           giac_aging_parameters.aging_id%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_branch_cd          giac_aging_parameters.gibr_branch_cd%TYPE,
      p_bill_no            VARCHAR2,
      p_total_amount_due   giac_aging_soa_details.total_amount_due%TYPE,
      p_total_payments     giac_aging_soa_details.total_payments%TYPE,
      p_balance_amt_due    giac_aging_soa_details.balance_amt_due%TYPE
   )
      RETURN giacs204_dtls_tab PIPELINED;
END;
/


