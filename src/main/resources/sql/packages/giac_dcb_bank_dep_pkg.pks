CREATE OR REPLACE PACKAGE CPI.giac_dcb_bank_dep_pkg
AS
  TYPE gdbd_list_type IS RECORD (
         gacc_tran_id                        GIAC_DCB_BANK_DEP.gacc_tran_id%TYPE,
       fund_cd                         GIAC_DCB_BANK_DEP.fund_cd%TYPE,
       branch_cd                     GIAC_DCB_BANK_DEP.branch_cd%TYPE,
       dcb_year                         GIAC_DCB_BANK_DEP.dcb_year%TYPE,
       dcb_no                         GIAC_DCB_BANK_DEP.dcb_no%TYPE,
       dcb_date                         GIAC_DCB_BANK_DEP.dcb_date%TYPE,
       item_no                         GIAC_DCB_BANK_DEP.item_no%TYPE,
       bank_cd                         GIAC_DCB_BANK_DEP.bank_cd%TYPE,
       bank_acct_cd                     GIAC_DCB_BANK_DEP.bank_acct_cd%TYPE,
       bank_acct                     VARCHAR2(10),
       pay_mode                         GIAC_DCB_BANK_DEP.pay_mode%TYPE,
       amount                         GIAC_DCB_BANK_DEP.amount%TYPE,
       currency_cd                     GIAC_DCB_BANK_DEP.currency_cd%TYPE,
       dsp_curr_sname                 GIIS_CURRENCY.short_name%TYPE,
       foreign_curr_amt                 GIAC_DCB_BANK_DEP.foreign_curr_amt%TYPE,
       currency_rt                     GIAC_DCB_BANK_DEP.currency_rt%TYPE,
       old_dep_amt                     GIAC_DCB_BANK_DEP.old_dep_amt%TYPE,
       adj_amt                         GIAC_DCB_BANK_DEP.adj_amt%TYPE,
       dsp_bank_name                 GIAC_BANKS.bank_name%TYPE,
       dsp_bank_acct_no                 GIAC_BANK_ACCOUNTS.bank_acct_no%TYPE,
       remarks                         GIAC_DCB_BANK_DEP.remarks%TYPE
  );
  
  TYPE gdbd_list_tab IS TABLE OF gdbd_list_type;
  
  FUNCTION get_gdbd_list(p_gacc_tran_id            GIAC_DCB_BANK_DEP.gacc_tran_id%TYPE)
    RETURN gdbd_list_tab PIPELINED;
    
  FUNCTION populate_giacs035_gdbd(p_gibr_branch_cd        GIAC_ACCTRANS.gibr_branch_cd%TYPE,
                                   p_gfun_fund_cd            GIAC_ACCTRANS.gfun_fund_cd%TYPE,
                                 p_dcb_year                GIAC_DCB_BANK_DEP.dcb_year%TYPE,
                                 p_dcb_no                GIAC_DCB_BANK_DEP.dcb_no%TYPE,
                                 p_dcb_date                VARCHAR2)
    RETURN gdbd_list_tab PIPELINED;
    
  PROCEDURE set_giac_dcb_bank_dep(p_gacc_tran_id                    GIAC_DCB_BANK_DEP.gacc_tran_id%TYPE,
                                   p_fund_cd                     GIAC_DCB_BANK_DEP.fund_cd%TYPE,
                                   p_branch_cd                     GIAC_DCB_BANK_DEP.branch_cd%TYPE,
                                   p_dcb_year                     GIAC_DCB_BANK_DEP.dcb_year%TYPE,
                                   p_dcb_no                         GIAC_DCB_BANK_DEP.dcb_no%TYPE,
                                   p_dcb_date                     GIAC_DCB_BANK_DEP.dcb_date%TYPE,
                                   p_item_no                     GIAC_DCB_BANK_DEP.item_no%TYPE,
                                   p_bank_cd                     GIAC_DCB_BANK_DEP.bank_cd%TYPE,
                                   p_bank_acct_cd                 GIAC_DCB_BANK_DEP.bank_acct_cd%TYPE,
                                   p_pay_mode                     GIAC_DCB_BANK_DEP.pay_mode%TYPE,
                                   p_amount                         GIAC_DCB_BANK_DEP.amount%TYPE,
                                   p_currency_cd                 GIAC_DCB_BANK_DEP.currency_cd%TYPE,
                                   p_foreign_curr_amt             GIAC_DCB_BANK_DEP.foreign_curr_amt%TYPE,
                                   p_currency_rt                 GIAC_DCB_BANK_DEP.currency_rt%TYPE,
                                   p_old_dep_amt                 GIAC_DCB_BANK_DEP.old_dep_amt%TYPE,
                                   p_adj_amt                     GIAC_DCB_BANK_DEP.adj_amt%TYPE,
                                   p_remarks                     GIAC_DCB_BANK_DEP.remarks%TYPE,
                                   p_user_id                     GIAC_DCB_BANK_DEP.user_id%TYPE,
                                   p_last_update                 GIAC_DCB_BANK_DEP.last_update%TYPE);
                                   
  PROCEDURE del_giac_dcb_bank_dep(p_gacc_tran_id                    GIAC_DCB_BANK_DEP.gacc_tran_id%TYPE,
                                   p_fund_cd                     GIAC_DCB_BANK_DEP.fund_cd%TYPE,
                                   p_branch_cd                     GIAC_DCB_BANK_DEP.branch_cd%TYPE,
                                   p_dcb_year                     GIAC_DCB_BANK_DEP.dcb_year%TYPE,
                                   p_dcb_no                         GIAC_DCB_BANK_DEP.dcb_no%TYPE,
                                   p_item_no                     GIAC_DCB_BANK_DEP.item_no%TYPE);
                                   
  TYPE giacs281_bank_acct_lov_type IS RECORD (
     bank_acct_cd giac_bank_accounts.bank_acct_cd%TYPE,
     bank_sname   giac_banks.bank_sname%TYPE,
     bank_acct    VARCHAR2 (500),
     branch_cd    giac_bank_accounts.branch_cd%TYPE
  );
  
  TYPE giacs281_bank_acct_lov_tab IS TABLE OF giacs281_bank_acct_lov_type;
  
  FUNCTION get_giacs281_bank_acct_lov
     RETURN giacs281_bank_acct_lov_tab PIPELINED;
     
  FUNCTION validate_giacs281_bank_acct (
     p_bank_acct_cd giac_bank_accounts.bank_acct_cd%TYPE
  )
     RETURN VARCHAR2;
     
  TYPE bank_lov_type IS RECORD( --SR#18447; John Dolon; 05.25.2015
    bank_cd             GIAC_BANKS.bank_cd%TYPE,
    bank_name           GIAC_BANKS.bank_name%TYPE,
    count_              NUMBER,
    rownum_             NUMBER
  );
  TYPE bank_lov_tab IS TABLE OF bank_lov_type;
     
  FUNCTION get_giacs035_bank_lov(
    p_find_text         VARCHAR2,
    p_order_by          VARCHAR2,
    p_asc_desc_flag     VARCHAR2,
    p_from              NUMBER,
    p_to                NUMBER
  )
    RETURN bank_lov_tab PIPELINED;
    
    PROCEDURE refresh_dcb(
        p_gacc_tran_id          giac_dcb_bank_dep.gacc_tran_id%TYPE,
        p_gibr_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
        p_gfun_fund_cd            giac_acctrans.gfun_fund_cd%TYPE,
        p_dcb_year                giac_dcb_bank_dep.dcb_year%TYPE,
        p_dcb_no                giac_dcb_bank_dep.dcb_no%TYPE,
        p_dcb_date                VARCHAR2,
        p_user_id               giac_dcb_bank_dep.user_id%TYPE,
        p_module_name           GIAC_MODULES.module_name%TYPE   -- dren 08.03.2015 : SR 0017729 - Additional parameter for Refresh DC        
    );
END giac_dcb_bank_dep_pkg;
/
