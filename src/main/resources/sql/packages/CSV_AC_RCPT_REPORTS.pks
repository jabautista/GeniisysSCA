CREATE OR REPLACE PACKAGE CPI.CSV_AC_RCPT_REPORTS
AS

   TYPE giacr170_details_type IS RECORD (
      branch_code             VARCHAR2 (5),
      branch_name             VARCHAR2(50),
      or_no                   VARCHAR(50),
      transaction_date        giac_acctrans.tran_date%TYPE,
      policy_no               VARCHAR2 (45),
      reference_policy_no     VARCHAR2 (30),
      assured_no              giis_assured.assd_no%TYPE,
      assured_name            giis_assured.assd_name%TYPE,
      inception_date          gipi_polbasic.incept_date%TYPE,
      expiry_date             gipi_polbasic.expiry_date%TYPE,
      issue_code              giac_advanced_payt.iss_cd%TYPE,
      premium_sequence_no     giac_advanced_payt.prem_seq_no%TYPE,
      booking_month           giac_advanced_payt.booking_mth%TYPE,
      booking_year            giac_advanced_payt.booking_year%TYPE,   
      collection_amount       giac_direct_prem_collns.collection_amt%TYPE,
      premium_amount          giac_direct_prem_collns.premium_amt%TYPE,
      tax_amount              giac_direct_prem_collns.tax_amt%TYPE
      
   );

   TYPE giacr170_details_tab IS TABLE OF giacr170_details_type;
   --Added by MarkS 02/15/2017 SR23838
   TYPE giacr170a_details_type IS RECORD (
      branch_name    VARCHAR2 (50),
      policy_no      VARCHAR2 (50),
      assd_name      giis_assured.assd_name%TYPE,
      incept_date    gipi_polbasic.incept_date%TYPE,
      expiry_date    gipi_polbasic.expiry_date%TYPE,
      booking_date   VARCHAR2 (50),
      bill_no        VARCHAR2 (50),
      payment_date   DATE,
      ref_no         VARCHAR2 (50),
      premium_amt    giac_direct_prem_collns.premium_amt%TYPE,
      tax_amt        giac_direct_prem_collns.tax_amt%TYPE,
      evat           NUMBER,
      cred_branch    gipi_polbasic.cred_branch%TYPE,
      date_decode    DATE
   );
   --end SR23838
   

   TYPE giacr170a_details_tab IS TABLE OF giacr170a_details_type;

   FUNCTION csv_giacr170(
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_date_type   VARCHAR2,
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_module_id   VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr170_details_tab PIPELINED;

   TYPE tran_id_type IS RECORD (
      tran_id   VARCHAR2 (50)
   );

   TYPE tran_id_tab IS TABLE OF tran_id_type;
   FUNCTION csv_giacr170a (
      p_date_type   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2
   )
      RETURN giacr170a_details_tab PIPELINED;
   FUNCTION cf_1formula (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN tran_id_tab PIPELINED;

   TYPE branch_type IS RECORD (
      branch   VARCHAR2 (50)
   );

   TYPE branch_tab IS TABLE OF branch_type;
   
   --Added by Carlo Rubenecia SR-5354 04.29.2016 -start
   TYPE giacr414_type IS RECORD (  
      assured_no              giis_assured.assd_no%TYPE,
      assured_name            giis_assured.assd_name%TYPE,
      issue_code              giac_comm_payts.iss_cd%TYPE,
      premium_sequence_no     giac_comm_payts.prem_seq_no%TYPE,
      policy_no               VARCHAR2 (50),
      or_no                   VARCHAR2 (100),
      or_date                 VARCHAR2 (100), 
      premium_amount          VARCHAR2 (50),
      peril_code              giis_peril.peril_cd%TYPE,
      peril_short_name        giis_peril.peril_sname%TYPE,
      commission_amount       VARCHAR2 (50),
      input_vat_amount        VARCHAR2 (50),
      commission_slip_number  VARCHAR2 (50),
      commission_slip_date    VARCHAR2 (50),
      commission_slip_amount  VARCHAR2 (50), 
      intermediary_type       giis_intermediary.intm_type%TYPE,
      intermediary_no         giis_intermediary.intm_no%TYPE,
      intermediary_name       giis_intermediary.intm_name%TYPE

   );

   TYPE giacr414_tab IS TABLE OF giacr414_type;

   FUNCTION csv_giacr414 (
      p_branch_cd      VARCHAR2,
      p_module_id      VARCHAR2,
      p_post_tran_sw   VARCHAR2,
      p_report_id      VARCHAR2,
      p_from           VARCHAR2,
      p_to             VARCHAR2,
      p_user_id        GIIS_USERS.user_id%TYPE
   )
      RETURN giacr414_tab PIPELINED;
  --Added by Carlo Rubenecia SR-5354 04.29.2016 -end
  
  --Added by MarkS 02/15/2017 SR5918
  FUNCTION cf_evatformula (
      p_branch_cd   VARCHAR2,
      p_policy_no   VARCHAR2,
      p_date_type   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_ref_no      VARCHAR2
   )
      RETURN NUMBER;
  --end SR5918
  
  
END CSV_AC_RCPT_REPORTS;
/
