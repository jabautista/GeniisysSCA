CREATE OR REPLACE PACKAGE CPI.giac_chk_disbursement_pkg
AS
/******************************************************************************
   NAME:       giac_chk_disbursement_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/19/2012   Irwin tabisora  1. Created this package.
   2.0        4/22/2013   Kris Felipe     2. Added procedures for GIACS002
******************************************************************************/
   TYPE giacs016_chk_disbursement_type IS RECORD (
      check_stat            giac_chk_disbursement.check_stat%TYPE,
      dsp_check_flag_mean   VARCHAR2 (100),
      check_date            giac_chk_disbursement.check_date%TYPE,
      check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE,
      check_no              giac_chk_disbursement.check_no%TYPE,
      gacc_tran_id          giac_chk_disbursement.gacc_tran_id%TYPE,
      item_no               giac_chk_disbursement.item_no%TYPE
   );

   TYPE giacs016_chk_disbursement_tab IS TABLE OF giacs016_chk_disbursement_type;

   FUNCTION get_giacs016_chk_disbursement (
      p_gacc_tran_id   giac_chk_disbursement.gacc_tran_id%TYPE
   )
      RETURN giacs016_chk_disbursement_tab PIPELINED;
      
      
   TYPE giacs002_chk_disb_type IS RECORD (
        gacc_tran_id            giac_chk_disbursement.gacc_tran_id%TYPE,  
        item_no                 giac_chk_disbursement.item_no%TYPE,
        bank_cd                 giac_chk_disbursement.bank_cd%TYPE,
        bank_acct_cd            giac_chk_disbursement.bank_acct_cd%TYPE,
        bank_acct_no            giac_bank_accounts.bank_acct_no%TYPE,
        bank_sname              GIAC_BANKS.BANK_SNAME%TYPE,
        
        fcurrency_amt           giac_chk_disbursement.fcurrency_amt%TYPE,   -- foreign amount
        amount                  giac_chk_disbursement.amount%TYPE,         -- local amount
        total_amount            giac_chk_disbursement.fcurrency_amt%TYPE,
        currency_cd             giac_chk_disbursement.currency_cd%TYPE,
        currency_rt             giac_chk_disbursement.currency_rt%TYPE,
        dsp_short_name          giis_currency.short_name%TYPE,
        
        payee_class_cd          giac_chk_disbursement.payee_class_cd%TYPE,
        payee_no                giac_chk_disbursement.payee_no%TYPE,
        payee                   giac_chk_disbursement.payee%TYPE,
        
        check_pref_suf          giac_chk_disbursement.check_pref_suf%TYPE,
        check_no                giac_chk_disbursement.check_no%TYPE,
        check_class             giac_chk_disbursement.check_class%TYPE,
        check_class_mean        cg_ref_codes.rv_meaning%TYPE,
        check_stat              giac_chk_disbursement.check_stat%TYPE,
        check_stat_mean         cg_ref_codes.rv_meaning%TYPE,
        check_date              giac_chk_disbursement.check_date%TYPE,
        str_check_date          VARCHAR2(50),
        check_print_date        giac_chk_disbursement.check_print_date%TYPE,
        str_check_print_date    VARCHAR2(50),
        
        particulars             giac_chk_disbursement.particulars%TYPE,
        disb_mode               giac_chk_disbursement.disb_mode%TYPE,
        
        user_id                 giac_chk_disbursement.user_id%TYPE,
        last_update             giac_chk_disbursement.last_update%TYPE,
        str_last_update         VARCHAR2(50),
        
        check_received_by       giac_chk_disbursement.check_received_by%TYPE,
        check_released_by       giac_chk_disbursement.check_released_by%TYPE,
        check_release_date      giac_chk_disbursement.check_release_date%TYPE,
        batch_tag               giac_chk_disbursement.batch_tag%TYPE,
        
        check_user_tag          NUMBER(1)      --check_user_per_iss_cd_acctg
   );
      
   TYPE giacs002_chk_disb_tab IS TABLE OF giacs002_chk_disb_type;
        
   FUNCTION get_giacs002_chk_disbursement /*(
        gacc_tran_id            giac_chk_disbursement.gacc_tran_id%TYPE          
   )*/ RETURN giacs002_chk_disb_tab PIPELINED;
   
   FUNCTION get_giacs002_chk_disb_info(
        p_gacc_tran_id         giac_chk_disbursement.gacc_tran_id%TYPE 
   ) RETURN giacs002_chk_disb_tab PIPELINED; 
      
  /* PROCEDURE set_chk_disb(
        p_check             giac_chk_disbursement%ROWTYPE
   );*/
   
   PROCEDURE del_chk_disb(
        p_gacc_tran_id          giac_chk_disbursement.gacc_tran_id%TYPE,
        p_item_no               giac_chk_disbursement.item_no%TYPE
   );
   
   PROCEDURE update_giac_check_no(
        p_check_no                  GIAC_CHECK_NO.check_seq_no%TYPE,
        p_gibr_gfun_fund_cd         GIAC_CHECK_NO.fund_cd%TYPE,
        p_gibr_branch_cd            GIAC_CHECK_NO.branch_cd%TYPE,
        p_bank_cd                   GIAC_CHECK_NO.bank_cd%TYPE,
        p_bank_acct_cd              GIAC_CHECK_NO.bank_acct_cd%TYPE,
        p_check_pref_suf            GIAC_CHECK_NO.chk_prefix%TYPE
   );
   
   PROCEDURE set_chk_disb(
        p_gacc_tran_id             GIAC_CHK_DISBURSEMENT.gacc_tran_id%TYPE ,        
        p_item_no   GIAC_CHK_DISBURSEMENT.item_no%TYPE,           
        p_bank_cd   GIAC_CHK_DISBURSEMENT.bank_cd%TYPE,             
        p_bank_acct_cd  GIAC_CHK_DISBURSEMENT.bank_acct_cd%TYPE,
                       p_currency_cd    GIAC_CHK_DISBURSEMENT.currency_cd%TYPE,         
                       p_currency_rt    GIAC_CHK_DISBURSEMENT.currency_rt%TYPE,       
                       p_amount GIAC_CHK_DISBURSEMENT.amount%TYPE,              
                       p_check_date GIAC_CHK_DISBURSEMENT.check_date%TYPE,
                       p_check_pref_suf GIAC_CHK_DISBURSEMENT.check_pref_suf%TYPE,      
                       p_check_no GIAC_CHK_DISBURSEMENT.check_no%TYPE,          
                       p_check_stat GIAC_CHK_DISBURSEMENT.check_stat%TYPE,          
                       p_check_class GIAC_CHK_DISBURSEMENT.check_class%TYPE,
                       p_fcurrency_amt GIAC_CHK_DISBURSEMENT.fcurrency_amt%TYPE,       
                       p_payee_class_cd GIAC_CHK_DISBURSEMENT.payee_class_cd%TYPE,    
                       p_payee_no GIAC_CHK_DISBURSEMENT.payee_no%TYPE,            
                       p_payee GIAC_CHK_DISBURSEMENT.payee%TYPE,
                       p_user_id GIAC_CHK_DISBURSEMENT.user_id%TYPE,             
                       p_last_update GIAC_CHK_DISBURSEMENT.last_update%TYPE,       
                       p_particulars GIAC_CHK_DISBURSEMENT.particulars%TYPE,         
                       p_check_release_date GIAC_CHK_DISBURSEMENT.check_release_date%TYPE,    
                       p_check_released_by GIAC_CHK_DISBURSEMENT.check_released_by%TYPE,   
                       p_check_received_by GIAC_CHK_DISBURSEMENT.check_received_by%TYPE, 
                       p_check_print_date GIAC_CHK_DISBURSEMENT.check_print_date%TYPE,    
                       p_disb_mode GIAC_CHK_DISBURSEMENT.disb_mode%TYPE
   ) ;
   
   PROCEDURE spoil_check(
        p_gacc_tran_id      IN          giac_spoiled_check.gacc_tran_id%TYPE,
        p_item_no           IN          giac_spoiled_check.item_no%TYPE,
        p_bank_cd           IN          giac_spoiled_check.bank_cd%TYPE,
        p_bank_acct_cd      IN          giac_spoiled_check.bank_acct_cd%TYPE,
        p_check_date        IN          VARCHAR2, --giac_spoiled_check.check_date%TYPE,
        p_check_pref_suf    IN          giac_spoiled_check.check_pref_suf%TYPE,
        p_check_no          IN          giac_spoiled_check.check_no%TYPE,
        p_check_stat        IN          giac_spoiled_check.check_stat%TYPE,
        p_check_class       IN          giac_spoiled_check.check_class%TYPE,
        p_currency_cd       IN          giac_spoiled_check.currency_cd%TYPE,
        p_fcurrency_amt     IN          giac_spoiled_check.fcurrency_amt%TYPE,
        p_currency_rt       IN          giac_spoiled_check.currency_rt%TYPE,
        p_amount            IN          giac_spoiled_check.amount%TYPE,
        p_print_dt          IN          VARCHAR2,  --giac_spoiled_check.print_dt%TYPE,
        p_user_id           IN OUT      giac_chk_disbursement.user_id%TYPE,        
        p_batch_tag         IN          giac_chk_disbursement.batch_tag%TYPE,
        p_check_dv_print    IN          cg_ref_codes.rv_meaning%TYPE,
        p_tran_flag         IN          giac_acctrans.tran_flag%TYPE,
        p_dv_flag           IN          giac_disb_vouchers.dv_flag%TYPE,
        p_str_last_update   OUT         VARCHAR2,--giac_chk_disbursement.last_update%TYPE,
        p_dv_print_tag      OUT         giac_disb_vouchers.print_tag%TYPE,
        p_dv_print_tag_mean OUT         cg_ref_codes.rv_meaning%TYPE
  
  );
  
  PROCEDURE bef_delete_manual_check (
        p_fund_cd           GIAC_DISB_VOUCHERS.GIBR_GFUN_FUND_CD%TYPE,
        p_branch_cd         GIAC_DISB_VOUCHERS.gibr_branch_cd%TYPE,
        p_bank_cd           giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd      giac_chk_disbursement.bank_acct_cd%TYPE,
        p_check_pref_suf    giac_chk_disbursement.check_pref_suf%TYPE
   );
   
  PROCEDURE validate_check_no(
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE,
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE    
   ); 
   
  PROCEDURE validate_bank_cd(
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE,
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE  
   ); 
   
   TYPE check_batch_printing_type IS RECORD(
        gacc_tran_id            giac_disb_vouchers.gacc_tran_id%TYPE,
        check_stat              giac_chk_disbursement.check_stat%TYPE,
        check_class             giac_chk_disbursement.check_class%TYPE,
        currency_cd             giac_chk_disbursement.currency_cd%TYPE,
        last_update             giac_chk_disbursement.last_update%TYPE,
        currency_rt             giac_chk_disbursement.currency_rt%TYPE,
        amount                  giac_chk_disbursement.amount%TYPE,
        fcurrency_amt           giac_chk_disbursement.fcurrency_amt%TYPE,
        item_no                 giac_chk_disbursement.item_no%TYPE,
        bank_cd                 giac_chk_disbursement.bank_cd%TYPE,
        bank_acct_cd            giac_chk_disbursement.bank_acct_cd%TYPE,
        dsp_check_date          giac_chk_disbursement.check_date%TYPE,
        check_pref_suf          giac_chk_disbursement.check_pref_suf%TYPE,
        check_no                giac_chk_disbursement.check_no%TYPE,
        batch_tag               giac_chk_disbursement.batch_tag%TYPE,
        dv_date                 giac_disb_vouchers.dv_date%TYPE,
        dv_pref                 giac_disb_vouchers.dv_pref%TYPE,
        dv_no                   giac_disb_vouchers.dv_no%TYPE,
        payee                   giac_disb_vouchers.payee%TYPE,
        particulars             giac_disb_vouchers.particulars%TYPE,
        print_tag               giac_disb_vouchers.print_tag%TYPE,
        document_cd             giac_payt_requests.document_cd%TYPE,
        payt_branch_cd          giac_payt_requests.branch_cd%TYPE,
        line_cd                 giac_payt_requests.line_cd%TYPE,
        doc_year                giac_payt_requests.doc_year%TYPE,
        doc_mm                  giac_payt_requests.doc_mm%TYPE,
        doc_seq_no              giac_payt_requests.doc_seq_no%TYPE,
        check_number            VARCHAR2(50),
        dv_number               VARCHAR2(50),
        request_number          VARCHAR2(50)
   );
   TYPE check_batch_printing_tab IS TABLE OF check_batch_printing_type;
   
   FUNCTION get_check_batch_printing_list(
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE,
        p_checking              VARCHAR2,
        p_check_tag             VARCHAR2,
        p_tran_id_group         VARCHAR2,
        p_branch_cd             VARCHAR2            -- shan 10.07.2014
   )
     RETURN check_batch_printing_tab PIPELINED;
   
   PROCEDURE generate_check(
        p_fund_cd       IN      giis_funds.fund_cd%TYPE,
        p_branch_cd     IN      giac_bank_accounts.branch_cd%TYPE,
        p_bank_sname    IN      giac_banks.bank_sname%TYPE,
        p_bank_cd       IN      giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd  IN      giac_chk_disbursement.bank_acct_cd%TYPE,
        p_chk_prefix    OUT     VARCHAR2,
        p_check_seq_no  OUT     giac_check_no.check_seq_no%TYPE
   );
   
   PROCEDURE validate_spoil(
        p_gacc_tran_id          giac_chk_disbursement.gacc_tran_id%TYPE,
        p_item_no               giac_chk_disbursement.item_no%TYPE,
        p_check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_no              giac_chk_disbursement.check_no%TYPE
   );
   
   PROCEDURE spoil_check_giacs054(
        p_gacc_tran_id          giac_chk_disbursement.gacc_tran_id%TYPE,
        p_item_no               giac_chk_disbursement.item_no%TYPE,
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE,
        p_check_date            giac_chk_disbursement.check_date%TYPE,
        p_check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_check_stat            giac_chk_disbursement.check_stat%TYPE,
        p_check_class           giac_chk_disbursement.check_class%TYPE,
        p_currency_cd           giac_chk_disbursement.currency_cd%TYPE,
        p_fcurrency_amt         giac_chk_disbursement.fcurrency_amt%TYPE,
        p_currency_rt           giac_chk_disbursement.currency_rt%TYPE,
        p_amount                giac_chk_disbursement.amount%TYPE,
        p_last_update           giac_chk_disbursement.last_update%TYPE,
        p_user_id               giac_chk_disbursement.user_id%TYPE,
        p_check_dv_print        VARCHAR2                -- shan 10.01.2014
   );
   
   FUNCTION get_check_seq_no(
        p_fund_cd               giis_funds.fund_cd%TYPE,
        p_branch_cd             giac_bank_accounts.branch_cd%TYPE,
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE,
        p_chk_prefix            giac_chk_disbursement.check_pref_suf%TYPE
   )
     RETURN NUMBER;
     
    PROCEDURE process_printed_checks(
        p_tran_id               giac_chk_disbursement.gacc_tran_id%TYPE,
        p_item_no               giac_chk_disbursement.item_no%TYPE,
        p_check_date            giac_chk_disbursement.check_date%TYPE,
        p_check_pref            giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_user_id               giis_users.user_id%TYPE,
        p_check_dv_print        VARCHAR2                    -- shan 09.30.2014
    );
    
    PROCEDURE update_giac_check_no2(
        p_fund_cd               giis_funds.fund_cd%TYPE,
        p_branch_cd             giac_bank_accounts.branch_cd%TYPE,
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE,
        p_check_pref            giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_user_id               giis_users.user_id%TYPE
    );
    
    PROCEDURE update_printed_checks(
        p_gacc_tran_id          giac_chk_disbursement.gacc_tran_id%TYPE,
        p_item_no               giac_chk_disbursement.item_no%TYPE,
        p_check_date            giac_chk_disbursement.check_date%TYPE,
        p_check_pref_suf        giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_no              giac_chk_disbursement.check_no%TYPE,
        p_check_dv_print        VARCHAR2                    -- shan 10.07.2014
    );
    
    PROCEDURE validate_check_seq_no(
        p_bank_cd               giac_chk_disbursement.bank_cd%TYPE,
        p_bank_acct_cd          giac_chk_disbursement.bank_acct_cd%TYPE,
        p_chk_prefix            giac_chk_disbursement.check_pref_suf%TYPE,
        p_check_seq_no          giac_chk_disbursement.check_no%TYPE,
        p_branch_cd             giac_bank_accounts.branch_cd%TYPE
    );
   
END giac_chk_disbursement_pkg;
/


