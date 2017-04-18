CREATE OR REPLACE PACKAGE CPI.GIACS032_PKG
AS

   TYPE giacs032_fund_lov_type IS RECORD (
      fund_cd           giis_funds.fund_cd%TYPE,
      fund_desc         giis_funds.fund_desc%TYPE
   ); 

   TYPE giacs032_fund_lov_tab IS TABLE OF giacs032_fund_lov_type;

   FUNCTION get_giacs032_fund_lov
   RETURN giacs032_fund_lov_tab PIPELINED;
   
   TYPE giacs032_branch_lov_type IS RECORD (
      branch_cd           giac_branches.branch_cd%TYPE,
      branch_name         giac_branches.branch_name%TYPE
   ); 

   TYPE giacs032_branch_lov_tab IS TABLE OF giacs032_branch_lov_type;

   FUNCTION get_giacs032_branch_lov(
        p_fund_cd       VARCHAR2,
        p_user_id       VARCHAR2
   )
   RETURN giacs032_branch_lov_tab PIPELINED;
   
   TYPE giacs032_rec_type IS RECORD (
      item_id           giac_pdc_checks.item_id%TYPE,         
      gacc_tran_id      giac_pdc_checks.gacc_tran_id%TYPE,   
      bank_cd           giac_pdc_checks.bank_cd%TYPE,         
      check_no          giac_pdc_checks.check_no%TYPE,        
      check_date        giac_pdc_checks.check_date%TYPE,      
      ref_no            giac_pdc_checks.ref_no%TYPE,          
      amount            giac_pdc_checks.amount%TYPE,          
      currency_cd       giac_pdc_checks.currency_cd%TYPE,     
      currency_rt       giac_pdc_checks.currency_rt%TYPE,     
      fcurrency_amt     giac_pdc_checks.fcurrency_amt%TYPE,   
      particulars       giac_pdc_checks.particulars%TYPE,     
      user_id           giac_pdc_checks.user_id%TYPE,         
      last_update       VARCHAR2(30),   
      item_no           giac_pdc_checks.item_no%TYPE,         
      check_flag        giac_pdc_checks.check_flag%TYPE,      
      group_no          giac_pdc_checks.group_no%TYPE,        
      gibr_branch_cd    giac_pdc_checks.gibr_branch_cd%TYPE,  
      gfun_fund_cd      giac_pdc_checks.gfun_fund_cd%TYPE,    
      gacc_tran_id_new  giac_pdc_checks.gacc_tran_id_new%TYPE,
      bank_sname        giac_banks.bank_sname%TYPE,
      status            cg_ref_codes.rv_meaning%TYPE,
      tran_year         giac_acctrans.tran_year%TYPE,  
      tran_month        giac_acctrans.tran_month%TYPE, 
      tran_seq_no       giac_acctrans.tran_seq_no%TYPE,
      dcb_date          giac_collection_dtl.due_dcb_date%TYPE
   ); 

   TYPE giacs032_rec_tab IS TABLE OF giacs032_rec_type;
   
   FUNCTION get_giacs032_list(
        p_fund_cd          VARCHAR2,
        p_branch_cd        VARCHAR2,
        p_check_flag       VARCHAR2
   ) 
   RETURN giacs032_rec_tab PIPELINED;
   
   PROCEDURE get_for_deposit_dtl(
        p_fund_cd         IN     VARCHAR2,
        p_branch_cd       IN     VARCHAR2,
        p_dcb_date        IN     VARCHAR2,
        v_dcb_no             OUT NUMBER,
        v_flag               OUT VARCHAR2,
        v_tran_date          OUT VARCHAR2
   );
   
   PROCEDURE save_for_deposit(
        p_item_id       VARCHAR2,
        p_dcb_no        VARCHAR2,
        p_dcb_date      VARCHAR2,
        p_tran_id       VARCHAR2,
        p_item_no       VARCHAR2
   );
   
   TYPE giacs032_rep_history_type IS RECORD (
       history_id           giac_repl_pay_hist.history_id%TYPE,
       fund_cd              giac_repl_pay_hist.fund_cd%TYPE,
       branch_cd            giac_repl_pay_hist.branch_cd%TYPE,
       gacc_tran_id         giac_repl_pay_hist.gacc_tran_id%TYPE,
       item_no              giac_repl_pay_hist.item_no%TYPE,
       old_pay_mode         giac_repl_pay_hist.old_pay_mode%TYPE,
       new_pay_mode         giac_repl_pay_hist.new_pay_mode%TYPE,
       old_amount           giac_repl_pay_hist.old_amount%TYPE,
       new_amount           giac_repl_pay_hist.new_amount%TYPE,
       user_id              giac_repl_pay_hist.user_id%TYPE,
       last_update          giac_repl_pay_hist.last_update%TYPE,
       override_user        giac_repl_pay_hist.override_user%TYPE
   ); 

   TYPE giacs032_rep_history_tab IS TABLE OF giacs032_rep_history_type;
   
   FUNCTION get_giacs032_rep_history(
        p_fund_cd          VARCHAR2,
        p_branch_cd        VARCHAR2,
        p_tran_id          VARCHAR2,
        p_item_no          VARCHAR2
   ) 
   RETURN giacs032_rep_history_tab PIPELINED;
   
   TYPE giacs032_bank_lov_type IS RECORD (
      bank_cd           giac_banks.bank_cd%TYPE,   
      bank_name         giac_banks.bank_name%TYPE, 
      bank_sname        giac_banks.bank_sname%TYPE
   ); 

   TYPE giacs032_bank_lov_tab IS TABLE OF giacs032_bank_lov_type;

   FUNCTION get_giacs032_bank_lov
   RETURN giacs032_bank_lov_tab PIPELINED;
   
   TYPE giacs032_currency_lov_type IS RECORD (
      main_currency_cd      giis_currency.main_currency_cd%TYPE,  
      currency_desc         giis_currency.currency_desc%TYPE,     
      currency_rt           giis_currency.currency_rt%TYPE,      
      short_name            giis_currency.short_name%TYPE      
   ); 

   TYPE giacs032_currency_lov_tab IS TABLE OF giacs032_currency_lov_type;

   FUNCTION get_giacs032_currency_lov
   RETURN giacs032_currency_lov_tab PIPELINED;
   
   PROCEDURE save_replace_pdc(
      v_rec         GIAC_COLLECTION_DTL%ROWTYPE,
      p_fund_cd     VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_old_amt     NUMBER,
      p_item_id     NUMBER
   );
   
   PROCEDURE apply_pdc_payts(
      p_item_id       NUMBER,
      p_gacc_tran_id  NUMBER,
      p_fund_cd       VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_new_tran_id   OUT NUMBER,
      p_group_no      OUT NUMBER
   );
   
   PROCEDURE create_records_in_acctrans(
      p_fund_cd            GIAC_PDC_CHECKS.gfun_fund_cd%TYPE,
      p_branch_cd          GIAC_PDC_CHECKS.gibr_branch_cd%TYPE,
      p_rev_tran_date      GIAC_ACCTRANS.tran_date%TYPE,
      p_rev_tran_class_no  GIAC_ACCTRANS.tran_class_no%TYPE,
      p_gacc_tran_id       OUT NUMBER
   );
   
END;
/


