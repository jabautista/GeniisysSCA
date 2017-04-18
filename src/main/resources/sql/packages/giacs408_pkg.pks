CREATE OR REPLACE PACKAGE CPI.giacs408_pkg 
AS
   TYPE bill_info_list_type IS RECORD (
      nbt_line_cd      gipi_polbasic.line_cd%TYPE,
      nbt_subline_cd   gipi_polbasic.subline_cd%TYPE,
      nbt_assd_no      gipi_polbasic.assd_no%TYPE,
      dsp_assd_name    giis_assured.assd_name%TYPE,
      dsp_policy_no    VARCHAR2 (50),
      v_comm_amt       giac_comm_payts.comm_amt%TYPE,
      banca_dtls_btn   VARCHAR2 (50),
      tran_date        VARCHAR2(25),
      tran_no          giac_new_comm_inv_peril.tran_no%TYPE,
      tran_flag        giac_new_comm_inv_peril.tran_flag%TYPE,
      dsp_tran_flag    VARCHAR2 (100)
   );
  
   TYPE bill_info_list_tab IS TABLE OF bill_info_list_type;

   FUNCTION populate_bill_information (
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_user_id       giis_users.user_id%TYPE
   )
      RETURN bill_info_list_tab PIPELINED;

--GNCI
   TYPE invoice_comm_list_type IS RECORD (
      intm_no              giac_new_comm_inv.intm_no%TYPE,
      dsp_intm_name        giis_intermediary.intm_name%TYPE,
      prnt_intmdry         giis_intermediary.intm_name%TYPE,
      share_percentage     giac_new_comm_inv.share_percentage%TYPE,
      premium_amt          giac_new_comm_inv.premium_amt%TYPE,
      commission_amt       giac_new_comm_inv.commission_amt%TYPE,
      wholding_tax         giac_new_comm_inv.wholding_tax%TYPE,
      nbt_netcomm_amt      NUMBER (12, 2),
      tran_no              giac_new_comm_inv.tran_no%TYPE,
      remarks              giac_new_comm_inv.remarks%TYPE,
      dsp_tran_flag        VARCHAR2 (100),
      tran_date            giac_new_comm_inv.tran_date%TYPE,
      delete_sw            giac_new_comm_inv.delete_sw%TYPE,
      nbt_wtax_rate        NUMBER(7,5), --change by steven 10.21.2014--giis_intermediary.wtax_rate%TYPE,
      nbt_original_share   giac_new_comm_inv.share_percentage%TYPE,
      comm_rec_id          giac_new_comm_inv.comm_rec_id%TYPE,
      iss_cd               giac_new_comm_inv.iss_cd%TYPE,
      prem_seq_no          giac_new_comm_inv.prem_seq_no%TYPE,
      user_id              giac_new_comm_inv.user_id%TYPE,
      post_date            giac_new_comm_inv.post_date%TYPE,
      tran_flag            giac_new_comm_inv.tran_flag%TYPE,
      posted_by            giac_new_comm_inv.posted_by%TYPE,
      fund_cd              giac_new_comm_inv.fund_cd%TYPE,
      branch_cd            giac_new_comm_inv.branch_cd%TYPE,
      policy_id            giac_new_comm_inv.policy_id%TYPE
   );

   TYPE invoice_comm_list_tab IS TABLE OF invoice_comm_list_type;

   FUNCTION populate_invoice_comm_info (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN invoice_comm_list_tab PIPELINED;

--GNCP
   TYPE peril_list_type IS RECORD (
      dsp_peril_name    giis_peril.peril_name%TYPE,
      premium_amt       giac_new_comm_inv_peril.premium_amt%TYPE,
      commission_rt     VARCHAR2(12), 
      commission_amt    giac_new_comm_inv_peril.commission_amt%TYPE,
      wholding_tax      giac_new_comm_inv_peril.wholding_tax%TYPE,
      dsp_netcomm_amt   giac_new_comm_inv_peril.commission_amt%TYPE,
      comm_rec_id       giac_new_comm_inv_peril.comm_rec_id%TYPE,
      intm_no           giac_new_comm_inv_peril.intm_no%TYPE,
      iss_cd            giac_new_comm_inv_peril.iss_cd%TYPE,
      prem_seq_no       giac_new_comm_inv_peril.prem_seq_no%TYPE,
      peril_cd          giac_new_comm_inv_peril.peril_cd%TYPE,
      tran_date         giac_new_comm_inv_peril.tran_date%TYPE,
      tran_no           giac_new_comm_inv_peril.tran_no%TYPE,
      tran_flag         giac_new_comm_inv_peril.tran_flag%TYPE,
      comm_peril_id     giac_new_comm_inv_peril.comm_peril_id%TYPE,
      delete_sw         giac_new_comm_inv_peril.delete_sw%TYPE,
      fund_cd           giac_new_comm_inv_peril.fund_cd%TYPE,
      branch_cd         giac_new_comm_inv_peril.branch_cd%TYPE,
      PERCENT           NUMBER (10, 7),
      record_status     VARCHAR2(2)
   );

   TYPE peril_list_tab IS TABLE OF peril_list_type;

   FUNCTION populate_peril_info (
      p_fund_cd       giac_new_comm_inv_peril.fund_cd%TYPE,
      p_branch_cd     giac_new_comm_inv_peril.branch_cd%TYPE,
      p_comm_rec_id   giac_new_comm_inv_peril.comm_rec_id%TYPE,
      p_intm_no       giac_new_comm_inv_peril.intm_no%TYPE,
      p_line_cd       giis_line.line_cd%TYPE
   )
      RETURN peril_list_tab PIPELINED;

   TYPE bill_no_list_type IS RECORD (
      iss_cd        gipi_invoice.iss_cd%TYPE,
      prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      policy_id     gipi_invoice.policy_id%TYPE,
      prem_amt      gipi_invoice.prem_amt%TYPE
   );

   TYPE bill_no_list_tab IS TABLE OF bill_no_list_type;

   FUNCTION validate_giacs408_bill_no (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_user_id       giis_users.user_id%TYPE
   )
      RETURN bill_no_list_tab PIPELINED;

   PROCEDURE chk_bill_no_onselect (
      p_iss_cd        IN       gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   IN       gipi_invoice.prem_seq_no%TYPE,
      v_pol_flag      OUT      gipi_polbasic.pol_flag%TYPE,
      v_prem_amt      OUT      gipi_invoice.prem_amt%TYPE,
      v_comm_amt      OUT      giac_comm_payts.comm_amt%TYPE,
      v_exist1        OUT      VARCHAR2
   );

   PROCEDURE query_gnci_gncp (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_fund_cd       VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_user_id       giis_users.user_id%TYPE
   );

   PROCEDURE check_bancassurance (
      p_iss_cd        IN       gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   IN       gipi_invoice.prem_seq_no%TYPE,
      p_intm_no       IN       giis_intermediary.intm_no%TYPE,
      v_banc_sw       IN OUT   gipi_polbasic.bancassurance_sw%TYPE,
      v_banc_type     IN OUT   gipi_polbasic.banc_type_cd%TYPE,
      v_fixed_tag     IN OUT   giis_banc_type_dtl.fixed_tag%TYPE,
      v_intm_type     IN OUT   giis_banc_type_dtl.intm_type%TYPE,
      v_intm_cnt      OUT      NUMBER
   );

   PROCEDURE validate_inv_comm_share (
      p_fund_cd            IN       giac_new_comm_inv.fund_cd%TYPE,
      p_branch_cd          IN       giac_new_comm_inv.branch_cd%TYPE,
      p_comm_rec_id        IN       giac_new_comm_inv.comm_rec_id%TYPE,
      p_intm_no            IN       giac_new_comm_inv.intm_no%TYPE,
      p_prem_seq_no        IN       giac_new_comm_inv.prem_seq_no%TYPE,
      p_iss_cd             IN       giac_new_comm_inv.iss_cd%TYPE,
      p_current_tot_share  IN       NUMBER,
      p_share_percentage   IN OUT   giac_new_comm_inv.share_percentage%TYPE,
      v_message            OUT      VARCHAR2
   );
   
   TYPE inv_comm_history_list_type IS RECORD (
      iss_cd           giac_new_comm_inv.iss_cd%TYPE,
      prem_seq_no      giac_new_comm_inv.prem_seq_no%TYPE,
      intm_no          giac_prev_comm_inv.intm_no%TYPE,
      intm_name        giis_intermediary.intm_name%TYPE,
      commission_amt   giac_prev_comm_inv.commission_amt%TYPE,
      wholding_tax     giac_prev_comm_inv.wholding_tax%TYPE,
      intm_no2         giac_new_comm_inv.intm_no%TYPE,
      intm_name2       giis_intermediary.intm_name%TYPE,
      commission_amt2  giac_new_comm_inv.commission_amt%TYPE,
      wholding_tax2    giac_new_comm_inv.wholding_tax%TYPE,
      tran_flag2       giac_new_comm_inv.tran_flag%TYPE,
      delete_sw2       giac_new_comm_inv.delete_sw%TYPE,
      post_date2       giac_new_comm_inv.post_date%TYPE,
      posted_by2       giac_new_comm_inv.posted_by%TYPE,
      user_id2         giac_new_comm_inv.user_id%TYPE
   );
   
   TYPE inv_comm_history_list_tab IS TABLE OF inv_comm_history_list_type;
   
   FUNCTION get_invoice_comm_history (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN inv_comm_history_list_tab PIPELINED;
      
   TYPE obj_insert_update_invperl_type IS RECORD (
      peril_cd        gipi_invperil.peril_cd%TYPE,
      dsp_peril_name  giis_peril.peril_name%TYPE,       
      --percent         
      premium_amt     GIAC_NEW_COMM_INV_PERIL.PREMIUM_AMT%TYPE,
      commission_rt   GIAC_NEW_COMM_INV_PERIL.commission_rt%TYPE,
      --commission_amt  GIAC_NEW_COMM_INV_PERIL.commission_amt%TYPE,
      --wholding_tax    GIAC_NEW_COMM_INV_PERIL.wholding_tax%TYPE, --gnci.nbt_wtax_rate
     -- dsp_netcomm_amt GIAC_NEW_COMM_INV_PERIL.commission_amt%TYPE,
      comm_peril_id    NUMBER(30)
   );
   
   TYPE obj_insert_update_invperl_tab IS TABLE OF obj_insert_update_invperl_type; 
     
   FUNCTION get_obj_insert_update_invperl (
      p_record_status  VARCHAR2,
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no    gipi_invoice.prem_seq_no%TYPE,
      p_prem_amt       gipi_invoice.prem_amt%TYPE,  --b140.prem_amt
      p_premium_amt    giac_new_comm_inv.PREMIUM_AMT%TYPE, --gnci.premium_amt
      --p_wtax_rate      giis_intermediary.wtax_rate%TYPE, --gnci.nbt_wtax_rate
      p_intm_no        giac_new_comm_inv.INTM_NO%TYPE,
      --p_commission_rt  giac_new_comm_inv_peril.commission_rt%TYPE    
      p_policy_id      gipi_polbasic.policy_id%TYPE
   )
      RETURN obj_insert_update_invperl_tab PIPELINED;
   
   TYPE giacs408_intm_lov_type IS RECORD (
      intm_no          giis_intermediary.intm_no%TYPE,
      dsp_intm_name    giis_intermediary.intm_name%TYPE,
      dsp_intm_type    giis_intermediary.intm_type%TYPE,
      nbt_wtax_rate    giis_intermediary.wtax_rate%TYPE,
      prnt_intmdry     giis_intermediary.intm_name%TYPE
   );
   
   TYPE giacs408_intm_lov_tab IS TABLE OF giacs408_intm_lov_type; 
   
   FUNCTION get_giacs408_intm_lov(
      p_iss_cd         gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no    gipi_invoice.prem_seq_no%TYPE,
      p_fund_cd        giac_new_comm_inv.fund_cd%TYPE,
      p_branch_cd      giac_new_comm_inv.branch_cd%TYPE
   )
      RETURN giacs408_intm_lov_tab PIPELINED;
   
   PROCEDURE validate_peril_commission_rt(
      p_fund_cd         IN      GIAC_NEW_COMM_INV_PERIL.fund_cd%TYPE,
      p_branch_cd       IN      GIAC_NEW_COMM_INV_PERIL.branch_cd%TYPE,
      p_comm_rec_id     IN      GIAC_NEW_COMM_INV_PERIL.comm_rec_id%TYPE,
      p_intm_no         IN      GIAC_NEW_COMM_INV_PERIL.intm_no%TYPE,
      p_comm_peril_id   IN      GIAC_NEW_COMM_INV_PERIL.comm_peril_id%TYPE,
      p_comm_paid       IN      VARCHAR2,
      p_commission_rt   IN OUT  GIAC_NEW_COMM_INV_PERIL.commission_rt%TYPE,
      p_message         OUT     VARCHAR2,
      p_line_cd         IN      giis_line.line_cd%TYPE,   --Deo [03.07.2017]: add start (SR-5944)
      p_subline_cd      IN      giis_subline.subline_cd%TYPE,
      p_iss_cd          IN      giis_issource.iss_cd%TYPE,
      p_peril_cd        IN      giis_peril.peril_cd%TYPE  --Deo [03.07.2017]: add ends (SR-5944)
   );
    
   FUNCTION RECOMPUTE_COMM_RATE(
      p_iss_cd          gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no     gipi_invoice.prem_seq_no%TYPE,
      p_policy_id       gipi_invoice.policy_id%TYPE,
      p_intm_no         giac_new_comm_inv_peril.intm_no%TYPE, 
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_peril_cd        giac_new_comm_inv_peril.peril_cd%TYPE     
   )
      RETURN NUMBER;
   
   FUNCTION RECOMPUTE_WTAX_RATE(
      p_intm_no       GIAC_NEW_COMM_INV_PERIL.intm_no%TYPE
   )
      RETURN NUMBER;
      
   PROCEDURE CANCEL_INVOICE_COMMISSION(
      p_comm_rec_id           giac_new_comm_inv.comm_rec_id%TYPE,
      p_fund_cd               giac_new_comm_inv.fund_cd%TYPE,
      p_branch_cd             giac_new_comm_inv.branch_cd%TYPE
   );
  
   PROCEDURE UPDATE_COMM_INVOICE(
    p_fund_cd               giac_new_comm_inv.fund_cd%TYPE,
    p_branch_cd             giac_new_comm_inv.branch_cd%TYPE,
    p_comm_rec_id           giac_new_comm_inv.comm_rec_id%TYPE,
    p_intm_no               giac_new_comm_inv.intm_no%TYPE,
    p_iss_cd                giac_new_comm_inv.iss_cd%TYPE,
    p_prem_seq_no           giac_new_comm_inv.prem_seq_no%TYPE,
    p_policy_id             giac_new_comm_inv.policy_id%TYPE,
    p_share_percentage      giac_new_comm_inv.share_percentage%TYPE,
    p_premium_amt           giac_new_comm_inv.premium_amt%TYPE,
    p_commission_amt        giac_new_comm_inv.commission_amt%TYPE,
    p_wholding_tax          giac_new_comm_inv.wholding_tax%TYPE,
    p_tran_date             giac_new_comm_inv.tran_date%TYPE,
    p_tran_flag             giac_new_comm_inv.tran_flag%TYPE,
    p_tran_no               giac_new_comm_inv.tran_no%TYPE,
    p_delete_sw             giac_new_comm_inv.delete_sw%TYPE,
    p_remarks               giac_new_comm_inv.remarks%TYPE,
    p_user_id               giac_new_comm_inv.user_id%TYPE
  );
  
  PROCEDURE UPDATE_COMM_INVOICE_PERIL(
    p_fund_cd               giac_new_comm_inv_peril.fund_cd%TYPE,
    p_branch_cd             giac_new_comm_inv_peril.branch_cd%TYPE,
    p_comm_rec_id           giac_new_comm_inv_peril.comm_rec_id%TYPE,
    p_intm_no               giac_new_comm_inv_peril.intm_no%TYPE,
    p_comm_peril_id         giac_new_comm_inv_peril.comm_peril_id%TYPE,
    p_premium_amt           giac_new_comm_inv_peril.premium_amt%TYPE,
    p_commission_rt         giac_new_comm_inv_peril.commission_rt%TYPE,
    p_commission_amt        giac_new_comm_inv_peril.commission_amt%TYPE,
    p_wholding_tax          giac_new_comm_inv_peril.wholding_tax%TYPE,
    p_delete_sw             giac_new_comm_inv_peril.delete_sw%TYPE,
    p_tran_no               giac_new_comm_inv_peril.tran_no%TYPE,
    p_tran_flag             giac_new_comm_inv_peril.tran_flag%TYPE,
    p_peril_cd              giac_new_comm_inv_peril.peril_cd%TYPE,
    p_prem_seq_no           giac_new_comm_inv_peril.prem_seq_no%TYPE,
    p_iss_cd                giac_new_comm_inv_peril.iss_cd%TYPE
  );
  
  PROCEDURE KEY_COMMIT_GIACS408(
    p_iss_cd                gipi_invoice.iss_cd%TYPE,
    p_prem_seq_no           gipi_invoice.prem_seq_no%TYPE,
    p_fund_cd               giac_prev_comm_inv.fund_cd%TYPE,
    p_branch_cd             giac_prev_comm_inv.branch_cd%TYPE
  );
  
  PROCEDURE CHECK_INV_PAYT(
    p_iss_cd         IN     giac_comm_payts.iss_cd%TYPE,   
    p_prem_seq_no    IN     giac_comm_payts.prem_seq_no%TYPE,
    p_intm_no        IN     giac_comm_payts.intm_no%TYPE,
    p_message        OUT    VARCHAR2
  );
  
  PROCEDURE CHECK_RECORD(
    p_iss_cd        IN      GIPI_INVOICE.iss_cd%TYPE,    
    p_prem_seq_no   IN      GIPI_INVOICE.prem_seq_no%TYPE,
    v_allow_coi     OUT     VARCHAR2,
    v_record        OUT     VARCHAR2
  );
  
  PROCEDURE KEY_DEL_REC_GIACS408(
    p_iss_cd             IN       giac_new_comm_inv.iss_cd%TYPE,
    p_prem_seq_no        IN       giac_new_comm_inv.prem_seq_no%TYPE,
    p_intm_no            IN       giac_new_comm_inv.intm_no%TYPE,
    v_message            OUT      VARCHAR2
  );
  
  TYPE giis_banc_type_type IS RECORD (
    banc_type_cd          GIIS_BANC_TYPE.banc_type_cd%TYPE,
    banc_type_desc        GIIS_BANC_TYPE.banc_type_desc%TYPE,
    rate                  GIIS_BANC_TYPE.rate%TYPE,
    user_id               GIIS_BANC_TYPE.user_id%TYPE,
    last_update           GIIS_BANC_TYPE.last_update%TYPE
  );
   
  TYPE giis_banc_type_tab IS TABLE OF giis_banc_type_type; 
   
  FUNCTION get_giis_banc_type(
    p_policy_id            gipi_polbasic.policy_id%TYPE
  )
  RETURN giis_banc_type_tab PIPELINED;
  
  TYPE giis_banc_type_dtl_type IS RECORD (
    banc_type_cd        giis_banc_type_dtl.banc_type_cd%TYPE,
    item_no             giis_banc_type_dtl.item_no%TYPE,
    intm_no             giis_banc_type_dtl.intm_no%TYPE,
    intm_type           giis_banc_type_dtl.intm_type%TYPE,
    nbt_intm_name       giis_intermediary.intm_name%TYPE,
    share_percentage    giis_banc_type_dtl.share_percentage%TYPE,
    remarks             giis_banc_type_dtl.remarks%TYPE,
    user_id             giis_banc_type_dtl.user_id%TYPE,
    last_update         giis_banc_type_dtl.last_update%TYPE,
    fixed_tag           giis_banc_type_dtl.fixed_tag%TYPE
  );
   
  TYPE giis_banc_type_dtl_tab IS TABLE OF giis_banc_type_dtl_type; 
  
  FUNCTION get_giis_banc_type_dtl(
    p_policy_id         gipi_polbasic.policy_id%TYPE,
    p_v_mod_btyp        VARCHAR2,
    p_iss_cd            giac_new_comm_inv.iss_cd%TYPE,
    p_prem_seq_no       giac_new_comm_inv.prem_seq_no%TYPE
  )
    RETURN giis_banc_type_dtl_tab PIPELINED;
    
  FUNCTION get_giis_banc_type_dtl2(
    p_banc_type_cd      giis_banc_type_dtl.banc_type_cd%TYPE,
    p_v_mod_btyp        VARCHAR2,
    p_iss_cd            giac_new_comm_inv.iss_cd%TYPE,
    p_prem_seq_no       giac_new_comm_inv.prem_seq_no%TYPE
  )
    RETURN giis_banc_type_dtl_tab PIPELINED;
    
  PROCEDURE GIACS408_POST_CHANGES(
    p_fund_cd       giac_new_comm_inv.fund_cd%TYPE,
    p_branch_cd     giac_new_comm_inv.branch_cd%TYPE,
    p_iss_cd        giac_new_comm_inv.iss_cd%TYPE,
    p_prem_seq_no   giac_new_comm_inv.prem_seq_no%TYPE,
    p_comm_rec_id   giac_new_comm_inv.comm_rec_id%TYPE,
    p_user_id       giac_new_comm_inv.posted_by%TYPE,
    p_intm_no       giis_intermediary.intm_no%TYPE
  );
  
    PROCEDURE reversal_gl_accts (
      p_iss_cd             gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no        gipi_invoice.prem_seq_no%TYPE,
      p_fund_cd            giac_prev_comm_inv.fund_cd%TYPE,
      p_branch_cd          giac_prev_comm_inv.branch_cd%TYPE, 
      v_comm_acct_gen      IN OUT VARCHAR2,
      v_rev_gacc_tran_id   OUT  giac_acctrans.tran_id%TYPE
    );
  
  PROCEDURE bae_gross_premiums (
    bgp_iss_cd            IN   gipi_invoice.iss_cd%TYPE,
    bgp_prem_seq_no       IN   gipi_invoice.prem_seq_no%TYPE,
    bgp_branch_cd         IN   giac_branches.branch_cd%TYPE,
    bgp_acct_line_cd      IN   giis_subline.acct_subline_cd%TYPE,
    bgp_acct_subline_cd   IN   giis_line.acct_line_cd%TYPE,
    bgp_acct_intm_cd      IN   giis_intm_type.acct_intm_cd%TYPE,
    v_is_it_reversal      IN   BOOLEAN,
    v_gacc_tran_id        IN   giac_acctrans.tran_id%TYPE,
    p_fund_cd             IN   giac_prev_comm_inv.fund_cd%TYPE
  );
  
  PROCEDURE BAE_PREMIUMS_RECEIVABLE (
    bgr_iss_cd              IN GIPI_INVOICE.iss_cd%type,
    bgr_prem_seq_no          IN GIPI_INVOICE.prem_seq_no%type,
    bpr_branch_cd          IN GIAC_BRANCHES.branch_cd%type     ,
    bpr_acct_line_cd        IN giis_subline.acct_subline_cd%type,    
    bpr_acct_subline_cd   IN GIIS_LINE.acct_line_cd%type      ,
    bpr_acct_intm_cd      IN giis_intm_type.acct_intm_cd%type,
    v_is_it_reversal      IN BOOLEAN,
    v_gacc_tran_id        IN giac_acctrans.tran_id%TYPE,
    p_fund_cd             IN giac_prev_comm_inv.fund_cd%TYPE
  );

  PROCEDURE bae_commissions_payable (
      bcp_iss_cd            IN   gipi_invoice.iss_cd%TYPE,
      bcp_prem_seq_no       IN   gipi_invoice.prem_seq_no%TYPE,
      bcp_branch_cd         IN   giac_branches.branch_cd%TYPE,
      bcp_acct_line_cd      IN   giis_subline.acct_subline_cd%TYPE,
      bcp_acct_subline_cd   IN   giis_line.acct_line_cd%TYPE,
      bcp_acct_intm_cd      IN   giis_intm_type.acct_intm_cd%TYPE,
      v_is_it_reversal      IN   BOOLEAN,
      v_gacc_tran_id        IN   GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
      p_fund_cd             IN   GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
  );
  
  PROCEDURE BAE_COMMISSIONS_EXPENSE  (
        bce_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        bce_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        bce_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        bce_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        bce_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        bce_acct_intm_cd        IN  giis_intm_type.acct_intm_cd%type,
        v_is_it_reversal        IN BOOLEAN,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
        p_branch_cd             IN giac_new_comm_inv.branch_cd%TYPE
    );
  
  PROCEDURE BAE_MISCELLANEOUS_INCOME(
    bce_iss_cd                IN GIPI_INVOICE.iss_cd%type,
    bce_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
    bce_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
    bce_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
    bce_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
    bce_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
    v_is_it_reversal        IN BOOLEAN,
    v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
  );
  
  PROCEDURE BAE_TAXES_PAYABLE (
    bpr_iss_cd            IN GIPI_INVOICE.iss_cd%type,
    bpr_prem_seq_no        IN GIPI_INVOICE.prem_seq_no%type,
    bpr_branch_cd        IN GIAC_BRANCHES.branch_cd%type     ,
    bpr_acct_line_cd      IN giis_subline.acct_subline_cd%type,    
    bpr_acct_subline_cd IN GIIS_LINE.acct_line_cd%type      ,
    bpr_acct_intm_cd    IN giis_intm_type.acct_intm_cd%type,
    v_is_it_reversal    IN BOOLEAN,
    v_gacc_tran_id      IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_fund_cd           IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
  );
 ---------endbae 
  PROCEDURE ENTRIES_FOR_GROSS_PREMIUMS(
    efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
    efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
    efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
    efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
    efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
    efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
    efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
    efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
    efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
    efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
    efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
    efg_drcr_tag            IN giac_module_entries.dr_cr_tag%type        ,
    efg_iss_cd                IN GIPI_INVOICE.iss_cd%type,
    efg_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
    efg_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
    efg_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
    efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
    efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
    v_gacc_tran_id          IN giac_acctrans.tran_id%TYPE,
    p_fund_cd               IN giac_prev_comm_inv.fund_cd%TYPE
  );
  
  PROCEDURE REV_ENTRIES_FOR_GROSS_PREMIUMS(
    efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
    efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
    efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
    efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
    efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
    efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
    efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
    efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
    efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
    efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
    efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
    efg_drcr_tag            IN giac_module_entries.dr_cr_tag%type        ,
    efg_iss_cd                IN GIPI_INVOICE.iss_cd%type,
    efg_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
    efg_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
    efg_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
    efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
    efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
    v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
  );
  
  PROCEDURE ENTRIES_FOR_PREMIUM_RECEIVABLE (
    efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
    efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
    efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
    efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
    efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
    efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
    efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
    efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
    efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
    efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
    efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
    efg_drcr_tag		IN giac_module_entries.dr_cr_tag%type       ,
    efg_iss_cd		IN GIPI_INVOICE.iss_cd%type,
    efg_prem_seq_no		IN GIPI_INVOICE.prem_seq_no%type,
    efg_branch_cd		IN GIAC_BRANCHES.branch_cd%type     ,
    efg_acct_line_cd  	IN giis_subline.acct_subline_cd%type,	
    efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
    efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
    v_prem_rec_gross_tag    IN GIAC_PARAMETERS.param_value_v%type,
    v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
  );
  
  PROCEDURE REV_ENTRIES_FOR_PREMIUM_RECEIV (
	efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
	efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
	efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
	efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
	efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
	efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
	efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
	efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
	efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
	efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
	efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
	efg_drcr_tag		    IN giac_module_entries.dr_cr_tag%type       ,
	efg_iss_cd		        IN GIPI_INVOICE.iss_cd%type,
	efg_prem_seq_no		    IN GIPI_INVOICE.prem_seq_no%type,
	efg_branch_cd		    IN GIAC_BRANCHES.branch_cd%type     ,
	efg_acct_line_cd  	    IN giis_subline.acct_subline_cd%type,	
	efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
	efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
    v_prem_rec_gross_tag    IN GIAC_PARAMETERS.param_value_v%type,
    v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
  );
  
  PROCEDURE entries_for_commission_payable (
      ecp_gl_acct_category        IN   giac_module_entries.gl_acct_category%TYPE,
      ecp_gl_control_acct         IN   giac_module_entries.gl_control_acct%TYPE,
      ecp_gl_sub_acct_1           IN   giac_module_entries.gl_sub_acct_1%TYPE,
      ecp_gl_sub_acct_2           IN   giac_module_entries.gl_sub_acct_2%TYPE,
      ecp_gl_sub_acct_3           IN   giac_module_entries.gl_sub_acct_3%TYPE,
      ecp_gl_sub_acct_4           IN   giac_module_entries.gl_sub_acct_4%TYPE,
      ecp_gl_sub_acct_5           IN   giac_module_entries.gl_sub_acct_5%TYPE,
      ecp_gl_sub_acct_6           IN   giac_module_entries.gl_sub_acct_6%TYPE,
      ecp_gl_sub_acct_7           IN   giac_module_entries.gl_sub_acct_7%TYPE,
      ecp_intm_type_level         IN   giac_module_entries.intm_type_level%TYPE,
      ecp_line_dependency_level   IN   giac_module_entries.line_dependency_level%TYPE,
      ecp_drcr_tag                IN   giac_module_entries.dr_cr_tag%TYPE,
      ecp_iss_cd                  IN   gipi_invoice.iss_cd%TYPE,
      ecp_prem_seq_no             IN   gipi_invoice.prem_seq_no%TYPE,
      ecp_branch_cd               IN   giac_branches.branch_cd%TYPE,
      ecp_acct_line_cd            IN   giis_subline.acct_subline_cd%TYPE,
      ecp_acct_subline_cd         IN   giis_line.acct_line_cd%TYPE,
      ecp_acct_intm_cd            IN   giis_intm_type.acct_intm_cd%TYPE,
      v_gacc_tran_id              IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
      p_fund_cd                   IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
  );
  
  PROCEDURE REV_ENTRIES_FOR_COMMISSION_PAY(
        ecp_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        ecp_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        ecp_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        ecp_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        ecp_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        ecp_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        ecp_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        ecp_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        ecp_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        ecp_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        ecp_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        ecp_drcr_tag		    IN giac_module_entries.dr_cr_tag%type       ,
        ecp_iss_cd		        IN GIPI_INVOICE.iss_cd%type,
        ecp_prem_seq_no		    IN GIPI_INVOICE.prem_seq_no%type,
        ecp_branch_cd		    IN GIAC_BRANCHES.branch_cd%type     ,
        ecp_acct_line_cd  	    IN giis_subline.acct_subline_cd%type,	
        ecp_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        ecp_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
  );
    
  PROCEDURE ENTRIES_FOR_COMMISSION_EXPENSE(
        ece_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        ece_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        ece_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        ece_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        ece_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        ece_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        ece_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        ece_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        ece_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        ece_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        ece_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        ece_drcr_tag		    IN giac_module_entries.dr_cr_tag%type        ,
        ece_iss_cd		        IN GIPI_INVOICE.iss_cd%type,
        ece_prem_seq_no		    IN GIPI_INVOICE.prem_seq_no%type,
        ece_branch_cd		    IN GIAC_BRANCHES.branch_cd%type     ,
        ece_acct_line_cd  	    IN giis_subline.acct_subline_cd%type,	
        ece_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        ece_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
        p_branch_cd             IN giac_new_comm_inv.branch_cd%TYPE
  );
  
  PROCEDURE REV_ENTRIES_FOR_COMMISSION_EXP(
        ece_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        ece_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        ece_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        ece_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        ece_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        ece_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        ece_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        ece_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        ece_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        ece_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        ece_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        ece_drcr_tag		    IN giac_module_entries.dr_cr_tag%type        ,
        ece_iss_cd		        IN GIPI_INVOICE.iss_cd%type,
        ece_prem_seq_no		    IN GIPI_INVOICE.prem_seq_no%type,
        ece_branch_cd		    IN GIAC_BRANCHES.branch_cd%type     ,
        ece_acct_line_cd  	    IN giis_subline.acct_subline_cd%type,	
        ece_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        ece_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE   
    );
  
  PROCEDURE ENTRIES_FOR_MISC_INC (
        efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        efg_drcr_tag		    IN giac_module_entries.dr_cr_tag%type        ,
        efg_iss_cd		        IN GIPI_INVOICE.iss_cd%type,
        efg_prem_seq_no		    IN GIPI_INVOICE.prem_seq_no%type,
        efg_branch_cd		    IN GIAC_BRANCHES.branch_cd%type     ,
        efg_acct_line_cd  	    IN giis_subline.acct_subline_cd%type,	
        efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_intm_sl_type_cd       OUT GIAC_ACCT_ENTRIES.sl_cd%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
    );
    
  PROCEDURE REV_ENTRIES_FOR_MISC_INC (
    efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
    efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
    efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
    efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
    efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
    efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
    efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
    efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
    efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
    efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
    efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
    efg_drcr_tag		    IN giac_module_entries.dr_cr_tag%type        ,
    efg_iss_cd		        IN GIPI_INVOICE.iss_cd%type,
    efg_prem_seq_no		    IN GIPI_INVOICE.prem_seq_no%type,
    efg_branch_cd		    IN GIAC_BRANCHES.branch_cd%type     ,
    efg_acct_line_cd  	    IN giis_subline.acct_subline_cd%type,	
    efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
    efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
    v_intm_sl_type_cd       OUT GIAC_ACCT_ENTRIES.sl_cd%type,
    v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
  );
----------------------------------------------------  endtries
  FUNCTION get_rev_acct_intm_cd(
    p_iss_cd             gipi_invoice.iss_cd%TYPE,
    p_prem_seq_no        gipi_invoice.prem_seq_no%TYPE
  ) 
    RETURN NUMBER;
    
  PROCEDURE get_br_ln_subln (
    p_fund_cd              IN        giac_branches.gfun_fund_cd%TYPE,
    p_gbls_iss_cd          IN  	     gipi_polbasic.iss_cd%TYPE,
    p_gbls_line_cd         IN  	     gipi_polbasic.line_cd%TYPE,
    p_gbls_subline_cd      IN  	     gipi_polbasic.subline_cd%TYPE,
    p_gbls_assd_no	       IN  	     gipi_polbasic.assd_no%TYPE,
    p_branch_cd            IN OUT    giac_acct_entries.gacc_gibr_branch_cd%TYPE,
    p_acct_line_cd         IN OUT    giis_line.acct_line_cd%TYPE,
    p_acct_subline_cd      IN OUT    giis_subline.acct_subline_cd%TYPE
  );
  
  PROCEDURE insert_giac_acctrans (
      p_fund_cd            IN      giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd          IN      giac_acctrans.gibr_branch_cd%TYPE,
      v_gacc_tran_id       IN OUT  giac_acctrans.tran_id%TYPE,
      v_tran_class         IN      giac_acctrans.tran_class%TYPE,
      v_particulars        IN      giac_acctrans.particulars%type
    );
  
  PROCEDURE BAE_Insert_Update_Acct_Entries(
    iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
    iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
    iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
    iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
    iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
    iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
    iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
    iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
    iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
    iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE        ,
    iuae_gl_acct_id        GIAC_ACCT_ENTRIES.gl_acct_id%TYPE ,
    iuae_branch_cd	       GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%type,
    iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%type,
    iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%type,
    iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%type,     
    iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%type,
    v_gacc_tran_id         GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_fund_cd              GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
  );
     
  PROCEDURE process_unbalance_accts (
      p_iss_cd             gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no        gipi_invoice.prem_seq_no%TYPE,
      v_gacc_tran_id  IN   GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
      p_fund_cd       IN   giac_acctrans.gfun_fund_cd%TYPE  
    );
  
  PROCEDURE POPULATE_GIPI_COMM_INV_DTL(
    p_fund_cd           gipi_invoice.iss_cd%TYPE,
    p_branch_cd         giac_new_comm_inv_peril.branch_cd%TYPE,
    p_intm_no           gipi_comm_invoice.intrmdry_intm_no%TYPE,          
    p_iss_cd            gipi_comm_invoice.iss_cd%TYPE,      
    p_policy_id         gipi_comm_invoice.policy_id%TYPE,      
    p_prem_seq_no       gipi_comm_invoice.prem_seq_no%TYPE,
    p_share_percentage  gipi_comm_invoice.share_percentage%TYPE, 
    p_parent_intm_no    gipi_comm_invoice.parent_intm_no%TYPE
  );
  
  PROCEDURE get_gl_accts_NOT_reversal(
    p_iss_cd                    gipi_comm_invoice.iss_cd%TYPE,      
    p_prem_seq_no               gipi_comm_invoice.prem_seq_no%TYPE,
    p_fund_cd                   gipi_invoice.iss_cd%TYPE,
    p_branch_cd                 giac_new_comm_inv.branch_cd%TYPE,
    v_comm_acct_gen             VARCHAR2,
    v_new_gacc_tran_id   OUT    giac_acctrans.tran_id%TYPE
  );
  
  FUNCTION GET_acct_intm_cd(
   p_iss_cd     gipi_invoice.iss_cd%TYPE,
   p_prem_seq_no gipi_invoice.prem_seq_no%TYPE
  ) 
  RETURN NUMBER;
  
   FUNCTION recompute_comm_rate_giacs408(
      p_fund_cd       giac_new_comm_inv_peril.fund_cd%TYPE,
      p_branch_cd     giac_new_comm_inv_peril.branch_cd%TYPE,
      p_comm_rec_id   giac_new_comm_inv_peril.comm_rec_id%TYPE,
      p_iss_cd          gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no     gipi_invoice.prem_seq_no%TYPE,
      p_policy_id       gipi_invoice.policy_id%TYPE,
      p_intm_no         giac_new_comm_inv_peril.intm_no%TYPE, 
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_wtax_rate       NUMBER 
   )
      RETURN peril_list_tab PIPELINED;
  
   FUNCTION get_intm_rate_giacs408(
      p_peril_cd            giis_intm_special_rate.peril_cd%TYPE,
      p_intm_no             giis_intm_special_rate.intm_no%TYPE,
      p_nbt_line_cd         giis_intm_special_rate.line_cd%TYPE,
      p_nbt_subline_cd      giis_intm_special_rate.subline_cd%TYPE,
      p_iss_cd              giis_intm_special_rate.iss_cd%TYPE,
      p_policy_id           gipi_polbasic.policy_id%TYPE
   ) RETURN NUMBER;
   
   TYPE giis_banc_type_lov_type IS RECORD (
      banc_type_cd          giis_banc_type.banc_type_cd%TYPE,
      banc_type_desc        giis_banc_type.banc_type_desc%TYPE,
      rate                  giis_banc_type.rate%TYPE
   );
   
   TYPE giis_banc_type_lov_tab IS TABLE OF giis_banc_type_lov_type; 
   
   FUNCTION get_giis_banc_type_lov
   RETURN giis_banc_type_lov_tab PIPELINED;
   
   TYPE banc_intm_lov_type IS RECORD (
      intm_no               giis_intermediary.intm_no%TYPE,
      intm_name             giis_intermediary.intm_name%TYPE,
      intm_type             giis_intermediary.intm_type%TYPE
   );
   
   TYPE banc_intm_lov_tab IS TABLE OF banc_intm_lov_type;
   
   FUNCTION get_banc_intm_lov (
      p_param_intm_type     giis_intermediary.intm_type%TYPE
   ) RETURN banc_intm_lov_tab PIPELINED;
   
   PROCEDURE check_bancassurance (
      p_iss_cd              IN  gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no         IN  gipi_invoice.prem_seq_no%TYPE,
      p_intm_no             IN  giis_intermediary.intm_no%TYPE,
      v_banc_sw             OUT gipi_polbasic.bancassurance_sw%TYPE,
      v_banc_type           OUT gipi_polbasic.banc_type_cd%TYPE,
      v_fixed_tag           OUT giis_banc_type_dtl.fixed_tag%TYPE,
      v_intm_type           OUT giis_banc_type_dtl.intm_type%TYPE,
      v_intm_cnt            OUT NUMBER,
      p_v_mod_btyp          IN  VARCHAR2,
      v_param_intm_type     OUT VARCHAR2,
      v_ityp                OUT VARCHAR2,
      p_comm_rec_id         IN  giac_new_comm_inv.comm_rec_id%TYPE,
      p_intm_type           IN  giis_banc_type_dtl.intm_type%TYPE,
      p_nbt_banc_type_cd    IN  giis_banc_type_dtl.banc_type_cd%TYPE      
   );
   
   PROCEDURE ins_inv_tab (
      p_user_id                     giis_users.user_id%TYPE,
      p_b140_prem_amt               gipi_invoice.prem_amt%TYPE,
      p_banca_b_share_percentage    giis_banc_type_dtl.share_percentage%TYPE,
      p_banca_b_nbt_intm_no         giis_intermediary.intm_no%TYPE,
      p_b140_nbt_line_cd            giis_peril.line_cd%TYPE,
      p_b140_iss_cd                 gipi_invperil.iss_cd%TYPE,
      p_b140_prem_seq_no            gipi_invperil.prem_seq_no%TYPE,
      p_banca_nbt_banc_type_cd      giis_banc_type.banc_type_cd%TYPE,
      p_fund_cd                     giac_new_comm_inv_peril.fund_cd%TYPE,                      
      p_branch_cd                   giac_new_comm_inv_peril.branch_cd%TYPE,
      p_b140_policy_id              giac_new_comm_inv.policy_id%TYPE
   );
   
   PROCEDURE apply_banc_assurance (
      p_v_mod_btyp                  VARCHAR2,
      p_fund_cd                     giac_new_comm_inv_peril.fund_cd%TYPE,                      
      p_branch_cd                   giac_new_comm_inv_peril.branch_cd%TYPE,
      p_banca_nbt_banc_type_cd      gipi_polbasic.banc_type_cd%TYPE,
      p_gnci_policy_id              gipi_polbasic.policy_id%TYPE,
      p_b140_iss_cd                 gipi_invperil.iss_cd%TYPE,
      p_b140_prem_seq_no            gipi_invperil.prem_seq_no%TYPE
   );
   
   PROCEDURE apply_banc_assurance_n (
      p_b140_iss_cd                 giac_new_comm_inv.iss_cd%TYPE,
      p_b140_prem_seq_no            giac_new_comm_inv.prem_seq_no%TYPE,
      p_banca_b_nbt_intm_no         giac_new_comm_inv.intm_no%TYPE,
      p_banca_b_mod_tag             VARCHAR2,
      p_user_id                     giis_users.user_id%TYPE,
      p_b140_prem_amt               gipi_invoice.prem_amt%TYPE,
      p_banca_b_share_percentage    giis_banc_type_dtl.share_percentage%TYPE,      
      p_b140_nbt_line_cd            giis_peril.line_cd%TYPE,
      p_banca_nbt_banc_type_cd      giis_banc_type.banc_type_cd%TYPE,
      p_fund_cd                     giac_new_comm_inv_peril.fund_cd%TYPE,                      
      p_branch_cd                   giac_new_comm_inv_peril.branch_cd%TYPE,
      p_b140_policy_id              giac_new_comm_inv.policy_id%TYPE
   );
   
   PROCEDURE recompute_comm_rate_giacs408(
      p_line_cd                 IN      giis_intm_special_rate.line_cd%TYPE, 
      p_subline_cd              IN      giis_intm_special_rate.subline_cd%TYPE,
      p_b140_iss_cd             IN      gipi_invoice.iss_cd%TYPE,
      p_b140_prem_seq_no        IN      gipi_invoice.prem_seq_no%TYPE,
      p_b140_policy_id          IN      gipi_invoice.policy_id%TYPE,
      p_gncp_peril_cd           IN      giac_new_comm_inv_peril.peril_cd%TYPE,
      p_gncp_intm_no            IN      giac_new_comm_inv_peril.intm_no%TYPE,
      p_gncp_commission_rt      OUT     giis_banc_type.rate%TYPE,
      p_gncp_commission_amt     OUT     giac_new_comm_inv_peril.commission_amt%TYPE,
      p_gncp_premium_amt        IN OUT  giac_new_comm_inv_peril.premium_amt%TYPE,
      p_gncp_wholding_tax       OUT     giac_new_comm_inv_peril.premium_amt%TYPE,
      p_gnci_nbt_wtax_rate      IN      giis_intermediary.wtax_rate%TYPE,
      p_gncp_dsp_netcomm_amt    OUT     giac_new_comm_inv_peril.commission_amt%TYPE
   );
   
   PROCEDURE delete_comm_invoice(
      p_fund_cd               giac_new_comm_inv.fund_cd%TYPE,
      p_branch_cd             giac_new_comm_inv.branch_cd%TYPE,
      p_comm_rec_id           giac_new_comm_inv.comm_rec_id%TYPE,
      p_intm_no               giac_new_comm_inv.intm_no%TYPE
   );
   
   FUNCTION recompute_comm_rate_list (
      p_fund_cd         giac_new_comm_inv_peril.fund_cd%TYPE,
      p_branch_cd       giac_new_comm_inv_peril.branch_cd%TYPE,
      p_comm_rec_id     giac_new_comm_inv_peril.comm_rec_id%TYPE,
      p_intm_no         giac_new_comm_inv_peril.intm_no%TYPE,
      p_line_cd         giis_line.line_cd%TYPE,
      p_iss_cd          gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no     gipi_invoice.prem_seq_no%TYPE           
   )
      RETURN peril_list_tab PIPELINED;
      
   PROCEDURE get_adjusted_prem_amt (
      p_iss_cd                      gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no                 gipi_invoice.prem_seq_no%TYPE,
      p_intm_no                     giac_new_comm_inv.intm_no%TYPE,
      p_share_percentage            giac_new_comm_inv.share_percentage%TYPE,
      p_policy_id                   gipi_polbasic.policy_id%TYPE,
      p_premium_amt        IN OUT   giac_new_comm_inv.premium_amt%TYPE
   );
   
   PROCEDURE update_comm_tables(
      p_iss_cd          gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no     gipi_invoice.prem_seq_no%TYPE,
      p_comm_rec_id     giac_new_comm_inv.COMM_REC_ID%TYPE,
      p_intm_no         giac_new_comm_inv.INTM_NO%TYPE
   );
   
END giacs408_pkg;
/


