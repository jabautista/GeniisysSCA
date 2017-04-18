CREATE OR REPLACE PACKAGE CPI.giacr408_pkg AS
   TYPE giacr408_detail_type IS RECORD (
      iss_cd                gipi_comm_invoice.iss_cd%TYPE,
      prem_seq_no           gipi_comm_invoice.prem_seq_no%TYPE,
      intm_no               gipi_comm_invoice.intrmdry_intm_no%TYPE,
      intm_name             giis_intermediary.intm_name%TYPE,
      prnt_intm_name        giis_intermediary.intm_name%TYPE,
      share_percentage      gipi_comm_invoice.share_percentage%TYPE,
      premium_amt           gipi_comm_invoice.premium_amt%TYPE,
      commission_amt        gipi_comm_invoice.commission_amt%TYPE,
      wholding_tax          gipi_comm_invoice.wholding_tax%TYPE,
      policy_id             gipi_comm_invoice.policy_id%TYPE,
      policy_no             VARCHAR2(100),
      assd_name             giis_assured.assd_name%TYPE,
      post_date             giac_new_comm_inv.post_date%TYPE,
      posted_by             giac_new_comm_inv.posted_by%TYPE,
      tran_no               giac_new_comm_inv.tran_no%TYPE,
      jv_no                 VARCHAR2(10),
      print_acct_entries    VARCHAR2(1)
   );

   TYPE giacr408_detail_tab IS TABLE OF giacr408_detail_type;
   
   FUNCTION get_giacr408_detail(
      p_comm_rec_id     giac_new_comm_inv.comm_rec_id%TYPE,
      p_iss_cd          gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no     gipi_comm_invoice.prem_seq_no%TYPE,
      p_fund_cd         giac_new_comm_inv.fund_cd%TYPE,
      p_branch_cd       giac_new_comm_inv.branch_cd%TYPE
   ) RETURN giacr408_detail_tab PIPELINED;

   TYPE giacr408_peril_type IS RECORD(
      iss_cd            gipi_comm_inv_peril.iss_cd%TYPE,
      prem_seq_no       gipi_comm_inv_peril.prem_seq_no%TYPE,
      intm_no           gipi_comm_inv_peril.intrmdry_intm_no%TYPE,
      prem_prl          gipi_comm_inv_peril.premium_amt%TYPE,
      peril_cd          gipi_comm_inv_peril.peril_cd%TYPE,
      comm_prl          gipi_comm_inv_peril.commission_amt%TYPE,
      commission_rt     gipi_comm_inv_peril.commission_rt%TYPE,
      wtax_prl          gipi_comm_inv_peril.wholding_tax%TYPE,
      peril_name        giis_peril.peril_name%TYPE
   );
   
   TYPE giacr408_peril_tab IS TABLE OF giacr408_peril_type;
   
   FUNCTION get_giacr408_peril(
      p_iss_cd          gipi_comm_inv_peril.iss_cd%TYPE,
      p_prem_seq_no     gipi_comm_inv_peril.prem_seq_no%TYPE,
      p_policy_id       gipi_polbasic.policy_id%TYPE
   ) RETURN giacr408_peril_tab PIPELINED;
   
   TYPE giacr408_prev_comm_inv_type IS RECORD(
      iss_cd            giac_new_comm_inv.iss_cd%TYPE,                                         
      prem_seq_no       giac_new_comm_inv.prem_seq_no%TYPE,
      intm_no           giac_prev_comm_inv.intm_no%TYPE,
      intm_name         giis_intermediary.intm_name%TYPE,
      prnt_intm_name    giis_intermediary.intm_name%TYPE,
      comm_rec_id       giac_prev_comm_inv.comm_rec_id%TYPE,
      tran_no           giac_prev_comm_inv.tran_no%TYPE,
      share_percentage  giac_prev_comm_inv.share_percentage%TYPE,
      premium_amt       giac_prev_comm_inv.premium_amt%TYPE,
      commission_amt    giac_prev_comm_inv.commission_amt%TYPE,
      wholding_tax      giac_prev_comm_inv.wholding_tax%TYPE,
      policy_id         giac_new_comm_inv.policy_id%TYPE
   );
   
   TYPE giacr408_prev_comm_inv_tab IS TABLE OF giacr408_prev_comm_inv_type;
   
   FUNCTION get_giacr408_prev_comm_inv(
      p_iss_cd          giac_new_comm_inv.iss_cd%TYPE,
      p_prem_seq_no     giac_new_comm_inv.prem_seq_no%TYPE,
      p_comm_rec_id     giac_new_comm_inv.comm_rec_id%TYPE
   ) RETURN giacr408_prev_comm_inv_tab PIPELINED;
   
   TYPE giacr408_prev_peril_type IS RECORD(
      iss_cd            giac_new_comm_inv.iss_cd%TYPE,
      prem_seq_no       giac_new_comm_inv.prem_seq_no%TYPE,
      intm_no           giac_prev_comm_inv_peril.intm_no%TYPE,
      comm_rec_id       giac_prev_comm_inv_peril.comm_rec_id%TYPE,
      tran_no           giac_prev_comm_inv_peril.tran_no%TYPE,
      prem_prl          giac_prev_comm_inv_peril.premium_amt%TYPE,
      peril_cd          giac_prev_comm_inv_peril.peril_cd%TYPE,
      comm_prl          giac_prev_comm_inv_peril.commission_amt%TYPE,
      commission_rt     giac_prev_comm_inv_peril.commission_rt%TYPE,
      wtax_prl          giac_prev_comm_inv_peril.wholding_tax%TYPE,
      peril_name        giis_peril.peril_name%TYPE
   );
   
   TYPE giacr408_prev_peril_tab IS TABLE OF giacr408_prev_peril_type;
   
   FUNCTION get_giacr408_prev_peril(
      p_iss_cd          giac_new_comm_inv.iss_cd%TYPE,
      p_prem_seq_no     giac_new_comm_inv.prem_seq_no%TYPE,
      p_comm_rec_id     giac_prev_comm_inv_peril.comm_rec_id%TYPE,
      p_policy_id       gipi_polbasic.policy_id%TYPE
   ) RETURN giacr408_prev_peril_tab PIPELINED;

   TYPE giacr408_new_acct_entries_type IS RECORD(
      account_no        VARCHAR2(30),
      sname             giac_chart_of_accts.gl_acct_sname%TYPE,
      sl_code           giac_acct_entries.sl_cd%TYPE,
      debit_amt         giac_acct_entries.debit_amt%TYPE,
      credit_amt        giac_acct_entries.credit_amt%TYPE
   );

   TYPE giacr408_new_acct_entries_tab IS TABLE OF giacr408_new_acct_entries_type;
   
   FUNCTION get_giacr408_new_acct_entries(
      p_prem_seq_no     giac_new_comm_inv.prem_seq_no%TYPE,  
      p_iss_cd          giac_new_comm_inv.iss_cd%TYPE,
      p_comm_rec_id     giac_new_comm_inv.comm_rec_id%TYPE
   ) RETURN giacr408_new_acct_entries_tab PIPELINED;
   
   TYPE giacr408_rev_acct_entries_type IS RECORD(
      account_no        VARCHAR2(30),
      sname             giac_chart_of_accts.gl_acct_sname%TYPE,
      sl_code           giac_acct_entries.sl_cd%TYPE,
      debit_amt         giac_acct_entries.debit_amt%TYPE,
      credit_amt        giac_acct_entries.credit_amt%TYPE
   );

   TYPE giacr408_rev_acct_entries_tab IS TABLE OF giacr408_rev_acct_entries_type;
   
   FUNCTION get_giacr408_rev_acct_entries(
      p_prem_seq_no     giac_new_comm_inv.prem_seq_no%TYPE,  
      p_iss_cd          giac_new_comm_inv.iss_cd%TYPE,
      p_comm_rec_id     giac_new_comm_inv.comm_rec_id%TYPE
   ) RETURN giacr408_rev_acct_entries_tab PIPELINED;
   
   TYPE giacr408_header_type IS RECORD(
      company           giis_parameters.param_value_v%TYPE,
      address           giac_parameters.param_value_v%TYPE
   );

   TYPE giacr408_header_tab IS TABLE OF giacr408_header_type;
   
   FUNCTION get_giacr408_header
   RETURN giacr408_header_tab PIPELINED;
   
END giacr408_pkg;
/


