CREATE OR REPLACE PACKAGE CPI.giac_bank_dep_slips_pkg
AS
  
  TYPE gbds_list_type IS RECORD (
         dep_id                          GIAC_BANK_DEP_SLIPS.dep_id%TYPE,
       dep_no                     GIAC_BANK_DEP_SLIPS.dep_no%TYPE,
       gacc_tran_id                 GIAC_BANK_DEP_SLIPS.gacc_tran_id%TYPE,
       fund_cd                     GIAC_BANK_DEP_SLIPS.fund_cd%TYPE,
       branch_cd                 GIAC_BANK_DEP_SLIPS.branch_cd%TYPE,
       dcb_no                     GIAC_BANK_DEP_SLIPS.dcb_no%TYPE,
       dcb_year                     GIAC_BANK_DEP_SLIPS.dcb_year%TYPE,
       item_no                     GIAC_BANK_DEP_SLIPS.item_no%TYPE,
       check_class                 GIAC_BANK_DEP_SLIPS.check_class%TYPE,
       validation_dt             GIAC_BANK_DEP_SLIPS.validation_dt%TYPE,
       currency_short_name         GIIS_CURRENCY.short_name%TYPE,
       amount                     GIAC_BANK_DEP_SLIPS.amount%TYPE,
       foreign_curr_amt             GIAC_BANK_DEP_SLIPS.foreign_curr_amt%TYPE,
       currency_rt                 GIAC_BANK_DEP_SLIPS.currency_rt%TYPE,
       currency_cd                 GIAC_BANK_DEP_SLIPS.currency_cd%TYPE
  );
  
  TYPE gbds_list_tab IS TABLE OF gbds_list_type;
  
  FUNCTION get_gbds_list (p_gacc_tran_id          GIAC_BANK_DEP_SLIPS.gacc_tran_id%TYPE,
                               p_item_no                  GIAC_BANK_DEP_SLIPS.item_no%TYPE)
    RETURN gbds_list_tab PIPELINED;
    
  PROCEDURE set_giac_bank_dep_slips(p_dep_id             GIAC_BANK_DEP_SLIPS.dep_id%TYPE,
                                      p_dep_no            GIAC_BANK_DEP_SLIPS.dep_no%TYPE,
                                      p_gacc_tran_id         GIAC_BANK_DEP_SLIPS.gacc_tran_id%TYPE,
                                    p_item_no             GIAC_BANK_DEP_SLIPS.item_no%TYPE,
                                    p_fund_cd             GIAC_BANK_DEP_SLIPS.fund_cd%TYPE,
                                    p_branch_cd             GIAC_BANK_DEP_SLIPS.branch_cd%TYPE,
                                       p_dcb_no             GIAC_BANK_DEP_SLIPS.dcb_no%TYPE,
                                    p_dcb_year             GIAC_BANK_DEP_SLIPS.dcb_year%TYPE,
                                    p_check_class         GIAC_BANK_DEP_SLIPS.check_class%TYPE,
                                    p_validation_dt         GIAC_BANK_DEP_SLIPS.validation_dt%TYPE,
                                       p_amount             GIAC_BANK_DEP_SLIPS.amount%TYPE,
                                    p_foreign_curr_amt  GIAC_BANK_DEP_SLIPS.foreign_curr_amt%TYPE,
                                    p_currency_rt        GIAC_BANK_DEP_SLIPS.currency_rt%TYPE,
                                    p_currency_cd        GIAC_BANK_DEP_SLIPS.currency_cd%TYPE);
                                    
  PROCEDURE del_giac_bank_dep_slips(p_dep_id             GIAC_BANK_DEP_SLIPS.dep_id%TYPE,
                                      p_gacc_tran_id         GIAC_BANK_DEP_SLIPS.gacc_tran_id%TYPE,
                                    p_item_no             GIAC_BANK_DEP_SLIPS.item_no%TYPE);
  
END giac_bank_dep_slips_pkg;
/


