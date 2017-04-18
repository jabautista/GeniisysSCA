CREATE OR REPLACE PACKAGE CPI.GIACS091_PKG
AS

   TYPE giacs091_branch_lov_type IS RECORD (
      branch_cd         giac_branches.branch_cd%TYPE,
      branch_name       giac_branches.branch_name%TYPE
   ); 

   TYPE giacs091_branch_lov_tab IS TABLE OF giacs091_branch_lov_type;

   FUNCTION get_giacs091_branch_lov(
        p_search        VARCHAR2,
        p_user          VARCHAR2,
        p_fund_cd       VARCHAR2 -- apollo cruz 09.16.2015 sr#20107
   ) 
   RETURN giacs091_branch_lov_tab PIPELINED;
   
   TYPE giacs091_rec_type IS RECORD (
      apdc_id           giac_apdc_payt_dtl.apdc_id%TYPE,       
      pdc_id            giac_apdc_payt_dtl.pdc_id%TYPE,        
      bank_cd           giac_apdc_payt_dtl.bank_cd%TYPE,       
      bank_branch       giac_apdc_payt_dtl.bank_branch%TYPE,   
      item_no           giac_apdc_payt_dtl.item_no%TYPE,       
      check_class       giac_apdc_payt_dtl.check_class%TYPE,   
      check_no          giac_apdc_payt_dtl.check_no%TYPE,      
      check_date        giac_apdc_payt_dtl.check_date%TYPE,    
      check_amt         giac_apdc_payt_dtl.check_amt%TYPE,     
      currency_cd       giac_apdc_payt_dtl.currency_cd%TYPE,   
      currency_rt       giac_apdc_payt_dtl.currency_rt%TYPE,   
      check_flag        giac_apdc_payt_dtl.check_flag%TYPE,    
      gross_amt         giac_apdc_payt_dtl.gross_amt%TYPE,    
      commission_amt    giac_apdc_payt_dtl.commission_amt%TYPE,
      vat_amt           giac_apdc_payt_dtl.vat_amt%TYPE,       
      gacc_tran_id      giac_apdc_payt_dtl.gacc_tran_id%TYPE,  
      payor             giac_apdc_payt_dtl.payor%TYPE,         
      address_1         giac_apdc_payt_dtl.address_1%TYPE,     
      address_2         giac_apdc_payt_dtl.address_2%TYPE,    
      address_3         giac_apdc_payt_dtl.address_3%TYPE,
      tin               giac_apdc_payt_dtl.tin%TYPE,           
      particulars       giac_apdc_payt_dtl.particulars%TYPE,   
      pay_mode          giac_apdc_payt_dtl.pay_mode%TYPE,      
      intm_no           giac_apdc_payt_dtl.intm_no%TYPE,       
      fc_comm_amt       giac_apdc_payt_dtl.fc_comm_amt%TYPE,   
      fc_gross_amt      giac_apdc_payt_dtl.fc_gross_amt%TYPE,
      fc_tax_amt        giac_apdc_payt_dtl.fc_tax_amt%TYPE,    
      remarks           giac_apdc_payt_dtl.remarks%TYPE,
      bank_sname        giac_banks.bank_sname%TYPE,  
      short_name        giis_currency.short_name%TYPE,   
      currency_desc     giis_currency.currency_desc%TYPE,
      convert_rt        giis_currency.currency_rt%TYPE,
      nbt_status        cg_ref_codes.rv_meaning%TYPE, 
      nbt_apdc_no       VARCHAR2(15),
      fcurrency_amt     giac_apdc_payt_dtl.fcurrency_amt%TYPE
   ); 

   TYPE giacs091_rec_tab IS TABLE OF giacs091_rec_type;
   
   FUNCTION get_giacs091_list(
        p_date          VARCHAR2,
        p_fund_cd       VARCHAR2, -- apollo cruz 09.17.2015 sr#20107
        p_branch        VARCHAR2
   ) 
   RETURN giacs091_rec_tab PIPELINED;
   
   PROCEDURE set_giacs091_rec(
        p_pdc_id        giac_apdc_payt_dtl.pdc_id%TYPE,
        p_remarks       giac_apdc_payt_dtl.remarks%TYPE,
        p_user_id       giac_apdc_payt_dtl.user_id%TYPE
   );
   
   PROCEDURE set_or_particulars(
        p_pdc_id        giac_apdc_payt_dtl.pdc_id%TYPE,     
        p_payor         giac_apdc_payt_dtl.payor%TYPE,      
        p_address_1     giac_apdc_payt_dtl.address_1%TYPE,  
        p_address_2     giac_apdc_payt_dtl.address_2%TYPE,  
        p_address_3     giac_apdc_payt_dtl.address_3%TYPE,  
        p_tin           giac_apdc_payt_dtl.tin%TYPE,        
        p_intm_no       giac_apdc_payt_dtl.intm_no%TYPE,    
        p_particulars   giac_apdc_payt_dtl.particulars%TYPE,
        p_user_id       giac_apdc_payt_dtl.user_id%TYPE    
   );
   
   TYPE giacs091_rec_details_type IS RECORD (
      pdc_id            giac_pdc_prem_colln.pdc_id%TYPE,             
      transaction_type  giac_pdc_prem_colln.transaction_type%TYPE,   
      iss_cd            giac_pdc_prem_colln.iss_cd%TYPE,             
      prem_seq_no       giac_pdc_prem_colln.prem_seq_no%TYPE,        
      inst_no           giac_pdc_prem_colln.inst_no%TYPE,            
      collection_amt    giac_pdc_prem_colln.collection_amt%TYPE,     
      user_id           giac_pdc_prem_colln.user_id%TYPE,            
      last_update       VARCHAR2(100),        
      currency_cd       giac_pdc_prem_colln.currency_cd%TYPE,        
      currency_rt       giac_pdc_prem_colln.currency_rt%TYPE,        
      premium_amt       giac_pdc_prem_colln.premium_amt%TYPE,        
      tax_amt           giac_pdc_prem_colln.tax_amt%TYPE,
      fcurrency_amt     giac_pdc_prem_colln.fcurrency_amt%TYPE,
      dsp_assured       VARCHAR2(500),
      dsp_policy_no     VARCHAR2(100),
      dsp_currency_desc giis_currency.currency_desc%TYPE      
   ); 

   TYPE giacs091_rec_details_tab IS TABLE OF giacs091_rec_details_type;
   
   FUNCTION get_giacs091_details_list(
        p_pdc_id        VARCHAR2
   ) 
   RETURN giacs091_rec_details_tab PIPELINED;
   
   TYPE giacs091_bank_lov_type IS RECORD (
      bank_cd         giac_bank_accounts.bank_cd%TYPE,
      bank_name       giac_banks.bank_name%TYPE
   ); 

   TYPE giacs091_bank_lov_tab IS TABLE OF giacs091_bank_lov_type;

   FUNCTION get_giacs091_bank_lov(
        p_search        VARCHAR2
   ) 
   RETURN giacs091_bank_lov_tab PIPELINED;
   
   TYPE giacs091_bank_acct_lov_type IS RECORD (
      bank_acct_cd      giac_bank_accounts.bank_acct_cd%TYPE,  
      bank_acct_no      giac_bank_accounts.bank_acct_no%TYPE,  
      bank_acct_type    giac_bank_accounts.bank_acct_type%TYPE,
      branch_cd         giac_bank_accounts.branch_cd%TYPE     
   ); 

   TYPE giacs091_bank_acct_lov_tab IS TABLE OF giacs091_bank_acct_lov_type;

   FUNCTION get_giacs091_bank_acct_lov(
        p_search        VARCHAR2,
        p_bank_cd       VARCHAR2
   ) 
   RETURN giacs091_bank_acct_lov_tab PIPELINED;
   
   PROCEDURE multiple_OR (
      p_check_date          VARCHAR2,
      p_pdc_id              NUMBER,
      p_bank_cd             VARCHAR2,
      p_bank_acct_cd        VARCHAR2,
      p_message         OUT VARCHAR2,
      p_user_id             VARCHAR2
   );
   
   PROCEDURE aeg_parameters(
            aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE,
            aeg_module_nm   GIAC_MODULES.module_name%TYPE,
            aeg_fund_cd     GIAC_APDC_PAYT.fund_cd%TYPE,
            aeg_branch_cd   GIAC_APDC_PAYT.branch_cd%TYPE,
            p_message       OUT VARCHAR2,
            p_user_id       VARCHAR2
    );
   
   PROCEDURE aeg_create_cib_acct_entries(
        aeg_bank_cd         giac_banks.bank_cd%TYPE,
        aeg_bank_acct_cd    giac_bank_accounts.bank_acct_cd%TYPE,
        aeg_acct_amt        giac_collection_dtl.amount%TYPE,
        aeg_gen_type        giac_acct_entries.generation_type%TYPE,
        aeg_tran_id         giac_acctrans.tran_id%TYPE,
        aeg_fund_cd         GIAC_APDC_PAYT.fund_cd%TYPE, 
        aeg_branch_cd       GIAC_APDC_PAYT.branch_cd%TYPE,
        p_message           VARCHAR2,
        p_user_id           VARCHAR2
    );
    
    PROCEDURE group_or (
      p_check_date          VARCHAR2,
      p_pdc_id              NUMBER,
      p_bank_cd             VARCHAR2,
      p_bank_acct_cd        VARCHAR2,
      p_user_id             VARCHAR2,
      p_tran_id         OUT giac_acctrans.tran_id%TYPE,
      p_particulars     OUT VARCHAR2,
      p_message         OUT VARCHAR2
   );
   
   PROCEDURE process_group_or(
          p_pdc_id          NUMBER,
          p_bank_cd         VARCHAR2,
          p_bank_acct_cd    VARCHAR2,
          p_user_id         VARCHAR2,
          p_tran_id         giac_acctrans.tran_id%TYPE,
          p_particulars     VARCHAR2,
          p_item_no         NUMBER
   );
   
   PROCEDURE validate_dcb_no(
       p_pdc_id            NUMBER,
       p_check_date        VARCHAR2, -- apollo cruz 09.09.2015 sr#20107 - check_date must be considered when validating dcb_no
       p_message     OUT   VARCHAR2
   );
   
   PROCEDURE create_dcb_no(
       p_pdc_id            NUMBER,
       p_check_date        VARCHAR2,
       p_user_id           VARCHAR2
   );
   
   PROCEDURE default_deposit_bank(
       p_pdc_id            NUMBER,
       p_user_id           VARCHAR2,
       p_bank_cd       OUT VARCHAR2,
       p_bank_acct_cd  OUT VARCHAR2,
       P_bank_name     OUT VARCHAR2,
       p_acct_no       OUT VARCHAR2
   );
   
   PROCEDURE group_final_update(
       p_pdc_id          NUMBER,
       p_tran_id         giac_acctrans.tran_id%TYPE,
       p_check_date      VARCHAR2, -- apollo cruz 09.09.2015 sr#20107
       p_user_id         VARCHAR2,
       p_message     OUT VARCHAR2
   );
   
   TYPE fund_lov_type IS RECORD (
      fund_cd     giis_funds.fund_cd%TYPE,
      fund_desc   giis_funds.fund_desc%TYPE
   );
   
   TYPE fund_lov_tab IS TABLE OF fund_lov_type;
   
   -- added by apollo cruz 09.16.2015 sr#20107
   FUNCTION get_fund_lov (
      p_user_id   VARCHAR2,
      p_keyword   VARCHAR2
   )
      RETURN fund_lov_tab PIPELINED;
   
   -- added by apollo cruz 09.17.2015 sr#20107
   FUNCTION validate_transaction_date (
      p_fund_cd      VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_check_date   VARCHAR2
   )
      RETURN VARCHAR2;   
   -- added by MarkS SR5881 12.13.2016 
   FUNCTION check_soa_balance_due (
      p_pdc_id        VARCHAR2
   )
      RETURN VARCHAR2;
END;
/
