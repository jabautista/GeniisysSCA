CREATE OR REPLACE PACKAGE CPI.giacs155_pkg
AS
   TYPE intm_lov_type IS RECORD (
      ref_intm_cd   giis_intermediary.ref_intm_cd%TYPE,
      intm_name     giis_intermediary.intm_name%TYPE,
      intm_no       giis_intermediary.intm_no%TYPE
   );

   TYPE intm_lov_tab IS TABLE OF intm_lov_type;

   FUNCTION get_intm_lov
      RETURN intm_lov_tab PIPELINED;
      
   TYPE fund_lov_type IS RECORD (
      fund_cd       giac_comm_v.fund_cd%TYPE,
      fund_desc     giis_funds.fund_desc%TYPE
   );
   
   TYPE fund_lov_tab IS TABLE OF fund_lov_type;
   
   FUNCTION get_fund_lov (
      p_user_id     VARCHAR2,
      p_intm_no     VARCHAR2
   )
      RETURN fund_lov_tab PIPELINED;
      
   TYPE branch_lov_type IS RECORD (
      branch_cd     giac_comm_v.branch_cd%TYPE,
      branch_name   giac_comm_v.branch_name%TYPE
   );
   
   TYPE branch_lov_tab IS TABLE OF branch_lov_type;
   
   FUNCTION get_branch_lov (
      p_user_id     VARCHAR2,
      p_intm_no     VARCHAR2,
      p_fund_cd     VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED;
      
   TYPE comm_voucher_type IS RECORD (
      count_            NUMBER,
      rownum_           NUMBER,
      iss_cd            giac_comm_voucher_v.iss_cd%TYPE,
      prem_seq_no       giac_comm_voucher_v.prem_seq_no%TYPE,
      cv_pref           giac_comm_voucher_ext.cv_pref%TYPE,
      cv_no             giac_comm_voucher_ext.cv_no%TYPE,
      cv_date           giac_comm_voucher_ext.cv_date%TYPE,
      policy_id         giac_comm_voucher_v.policy_id%TYPE,
      policy_no         VARCHAR2(100),
      actual_comm       giac_comm_voucher_v.actual_comm%TYPE,
      comm_payable      giac_comm_voucher_v.comm_payable%TYPE,
      comm_paid         giac_comm_voucher_v.comm_payable%TYPE,
      net_due           giac_comm_voucher_v.comm_payable%TYPE,
      assd_no           giis_assured.assd_no%TYPE,
      wtax_amt          NUMBER(16, 2),
      prem_amt          NUMBER(16, 2),
      comm_amt          NUMBER(16, 2),
      input_vat         giac_comm_voucher_v.input_vat%TYPE,
      pol_flag          gipi_polbasic.pol_flag%TYPE,
      override_tag      VARCHAR2(1),
      tot_actual_comm   NUMBER(16, 2),
      tot_comm_payable  NUMBER(16, 2),
      tot_comm_paid     NUMBER(16, 2),
      tot_net_due       NUMBER(16, 2)
   );
   
   TYPE comm_voucher_tab IS TABLE OF comm_voucher_type;
   
   FUNCTION populate_comm_voucher (
      p_user_id         VARCHAR2,
      p_intm_no         VARCHAR2,
      p_fund_cd         VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_prem_seq_no     NUMBER, --marco - SR-5745 - 11.07.2016
      p_cv_pref         VARCHAR2,
      p_cv_no           VARCHAR2,
      p_cv_date         VARCHAR2,
      p_policy_no       VARCHAR2,
      p_actual_comm     VARCHAR2,
      p_comm_payable    VARCHAR2,
      p_comm_paid       VARCHAR2,
      p_net_due         VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN comm_voucher_tab PIPELINED;
      
   TYPE comm_invoice_type IS RECORD (
      iss_cd                gipi_comm_invoice.iss_cd%TYPE,
      prem_seq_no           gipi_comm_invoice.prem_seq_no%TYPE,
      assd_no               giis_assured.assd_no%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      premium_amt           gipi_comm_invoice.premium_amt%TYPE,
      commission_amt        gipi_comm_invoice.commission_amt%TYPE,
      share_percentage      gipi_comm_invoice.share_percentage%TYPE,
      wholding_tax          gipi_comm_invoice.wholding_tax%TYPE,
      input_vat_rate        NUMBER(16, 2)
   );
   
   TYPE comm_invoice_tab IS TABLE OF comm_invoice_type;
   
   FUNCTION populate_comm_invoice (
      p_user_id     VARCHAR2,
      p_intm_no     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_prem_seq_no VARCHAR2,
      p_policy_id   VARCHAR2
   )
      RETURN comm_invoice_tab PIPELINED;
      
   TYPE comm_invoice_tg_type IS RECORD (
      intrmdry_intm_no  gipi_comm_inv_peril.intrmdry_intm_no%TYPE,
      iss_cd            gipi_comm_inv_peril.iss_cd%TYPE,
      prem_seq_no       gipi_comm_inv_peril.prem_seq_no%TYPE,
      policy_id         gipi_comm_inv_peril.policy_id%TYPE,
      peril_cd          gipi_comm_inv_peril.peril_cd%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      premium_amt       gipi_comm_inv_peril.premium_amt%TYPE,
      commission_rt     gipi_comm_inv_peril.commission_rt%TYPE,
      commission_amt    gipi_comm_inv_peril.commission_amt%TYPE,
      wholding_tax      gipi_comm_inv_peril.wholding_tax%TYPE,
      input_vat_rate    NUMBER(16, 2)
   );   
   
   TYPE comm_invoice_tg_tab IS TABLE OF comm_invoice_tg_type;
   
   FUNCTION populate_comm_invoice_tg (
      p_user_id         VARCHAR2,
      p_intm_no         VARCHAR2,
      p_iss_cd          VARCHAR2,
      p_prem_seq_no     VARCHAR2
      
   )
      RETURN comm_invoice_tg_tab PIPELINED;
      
   TYPE comm_payable_type IS RECORD (
      assd_no           giis_assured.assd_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      collection_amt    giac_direct_prem_collns.collection_amt%TYPE,
      premium_amt       giac_direct_prem_collns.premium_amt%TYPE,
      tax_amt           giac_direct_prem_collns.tax_amt%TYPE,
      commission_amt    gipi_comm_invoice.commission_amt%TYPE,
      wholding_tax      gipi_comm_inv_peril.wholding_tax%TYPE,
      vat_amt           NUMBER(16, 2),
      net_amt           NUMBER(16, 2)
   );
   
   TYPE comm_payable_tab IS TABLE OF comm_payable_type;
   
   FUNCTION populate_comm_payables (
      p_intm_no         VARCHAR2,
      p_iss_cd          VARCHAR2,
      p_prem_seq_no     VARCHAR2,
      p_policy_id       VARCHAR2
   )
      RETURN comm_payable_tab PIPELINED;
      
   TYPE comm_payments_type IS RECORD (
      agent_no          VARCHAR2(500),
      or_no             VARCHAR2(200),
      tran_date         giac_acctrans.tran_date%TYPE,
      comm_amt          giac_comm_payts.comm_amt%TYPE,
      input_vat_amt     giac_comm_payts.input_vat_amt%TYPE,
      wtax_amt          giac_comm_payts.wtax_amt%TYPE
   );
   
   TYPE comm_payments_tab IS TABLE OF comm_payments_type;   
   
   FUNCTION populate_comm_payments (
      p_intm_no         VARCHAR2,
      p_iss_cd          VARCHAR2,
      p_prem_seq_no     VARCHAR2
   )
      RETURN comm_payments_tab PIPELINED;
      
   PROCEDURE update_comm_voucher_ext(
      p_fund_cd         giac_comm_voucher_ext.fund_cd%TYPE,
      p_intm_no         giac_comm_voucher_ext.intm_no%TYPE,
      p_policy_no       giac_comm_voucher_ext.policy_no%TYPE,
      p_iss_cd          giac_comm_voucher_ext.iss_cd%TYPE,
      p_prem_seq_no     giac_comm_voucher_ext.prem_seq_no%TYPE,
      p_comm_amt        giac_comm_voucher_ext.commission_amt%TYPE,
      p_wtax            giac_comm_voucher_ext.wholding_tax%TYPE,
      p_comm_paid       giac_comm_voucher_ext.advances%TYPE,
      p_assd_no         giac_comm_voucher_ext.assd_no%TYPE,
      p_prem_amt        giac_comm_voucher_ext.prem_amt%TYPE,
      p_input_vat       giac_comm_voucher_ext.input_vat%TYPE,
      p_user_id         VARCHAR2,
      p_cv_pref         giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no           giac_comm_voucher_ext.cv_no%TYPE
   );
   
   PROCEDURE update_override_hist (
      p_fund_cd         giac_commvouch_override_hist.fund_cd%TYPE,
      p_intm_no         giac_commvouch_override_hist.intm_no%TYPE,
      p_iss_cd          giac_commvouch_override_hist.iss_cd%TYPE,
      p_prem_seq_no     giac_commvouch_override_hist.prem_seq_no%TYPE,
      p_net_due         giac_commvouch_override_hist.amount%TYPE,
      p_overriding_user giac_commvouch_override_hist.overriding_user%TYPE,
      p_user_id           giac_commvouch_override_hist.user_id%TYPE
   );
   
   PROCEDURE check_tagged_records (
      p_user_id     giis_users.user_id%TYPE,
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_message     OUT VARCHAR2,
      p_cv_pref     OUT VARCHAR2,
      p_cv_no       OUT VARCHAR2,
      p_cv_date     OUT DATE,
      p_grp_iss_cd  OUT VARCHAR2
   );
   
   FUNCTION get_grp_iss_cd (
      p_user_id VARCHAR2,
      p_rep_id  VARCHAR2
   )
      RETURN VARCHAR2;
      
   PROCEDURE save_cv_no(
      p_fund_cd         giac_comm_voucher_ext.fund_cd%TYPE,
      p_intm_no         giac_comm_voucher_ext.intm_no%TYPE,
      p_policy_no       giac_comm_voucher_ext.policy_no%TYPE,
      p_iss_cd          giac_comm_voucher_ext.iss_cd%TYPE,
      p_prem_seq_no     giac_comm_voucher_ext.prem_seq_no%TYPE,
      p_comm_amt        giac_comm_voucher_ext.commission_amt%TYPE,
      p_wtax            giac_comm_voucher_ext.wholding_tax%TYPE,
      p_comm_paid       giac_comm_voucher_ext.advances%TYPE,
      p_assd_no         giac_comm_voucher_ext.assd_no%TYPE,
      p_prem_amt        giac_comm_voucher_ext.prem_amt%TYPE,
      p_input_vat       giac_comm_voucher_ext.input_vat%TYPE,
      p_user_id         VARCHAR2,
      p_cv_pref         giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no           giac_comm_voucher_ext.cv_no%TYPE,
      p_cv_date           giac_comm_voucher_ext.cv_date%TYPE
   );
   
   PROCEDURE remove_include_tag(
      p_user_id VARCHAR2
   );      
END;
/


