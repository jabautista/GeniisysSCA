CREATE OR REPLACE PACKAGE CPI.giac_cash_dep_dtl_pkg
AS
   TYPE gcdd_list_type IS RECORD (
      gacc_tran_id          giac_cash_dep_dtl.gacc_tran_id%TYPE,
      fund_cd               giac_cash_dep_dtl.fund_cd%TYPE,
      branch_cd             giac_cash_dep_dtl.branch_cd%TYPE,
      dcb_year              giac_cash_dep_dtl.dcb_year%TYPE,
      dcb_no                giac_cash_dep_dtl.dcb_no%TYPE,
      item_no               giac_cash_dep_dtl.item_no%TYPE,
      currency_cd           giac_cash_dep_dtl.currency_cd%TYPE,
      amount                giac_cash_dep_dtl.amount%TYPE,
      currency_short_name   giis_currency.short_name%TYPE,
      foreign_curr_amt      giac_cash_dep_dtl.foreign_curr_amt%TYPE,
      currency_rt           giac_cash_dep_dtl.currency_rt%TYPE,
      net_deposit           giac_cash_dep_dtl.net_deposit%TYPE,
      short_over            giac_cash_dep_dtl.short_over%TYPE,
      book_tag              giac_cash_dep_dtl.book_tag%TYPE,
      remarks               giac_cash_dep_dtl.remarks%TYPE,
      user_id               giac_cash_dep_dtl.user_id%TYPE,
      last_update           VARCHAR2(15)
   );

   TYPE gcdd_list_tab IS TABLE OF gcdd_list_type;

   FUNCTION get_gcdd_list (
      p_gacc_tran_id   giac_cash_dep_dtl.gacc_tran_id%TYPE,
      p_item_no        giac_cash_dep_dtl.item_no%TYPE
   )
      RETURN gcdd_list_tab PIPELINED;

   PROCEDURE get_col_and_dep (
      p_gacc_tran_id   IN       giac_cash_dep_dtl.gacc_tran_id%TYPE,
      p_fund_cd        IN       giac_cash_dep_dtl.fund_cd%TYPE,
      p_branch_cd      IN       giac_cash_dep_dtl.branch_cd%TYPE,
      p_dcb_year       IN       giac_cash_dep_dtl.dcb_year%TYPE,
      p_dcb_no         IN       giac_cash_dep_dtl.dcb_no%TYPE,
      p_item_no        IN       giac_cash_dep_dtl.item_no%TYPE,
      p_deposit_dtl    OUT      NUMBER,
      p_collection     OUT      NUMBER
   );

   PROCEDURE set_giac_cash_dep_dtl (
      p_gacc_tran_id       giac_cash_dep_dtl.gacc_tran_id%TYPE,
      p_fund_cd            giac_cash_dep_dtl.fund_cd%TYPE,
      p_branch_cd          giac_cash_dep_dtl.branch_cd%TYPE,
      p_dcb_year           giac_cash_dep_dtl.dcb_year%TYPE,
      p_dcb_no             giac_cash_dep_dtl.dcb_no%TYPE,
      p_item_no            giac_cash_dep_dtl.item_no%TYPE,
      p_currency_cd        giac_cash_dep_dtl.currency_cd%TYPE,
      p_amount             giac_cash_dep_dtl.amount%TYPE,
      p_foreign_curr_amt   giac_cash_dep_dtl.foreign_curr_amt%TYPE,
      p_currency_rt        giac_cash_dep_dtl.currency_rt%TYPE,
      p_net_deposit        giac_cash_dep_dtl.net_deposit%TYPE,
      p_short_over         giac_cash_dep_dtl.short_over%TYPE,
      p_remarks            giac_cash_dep_dtl.remarks%TYPE,
      p_book_tag           giac_cash_dep_dtl.book_tag%TYPE,
      p_user_id            giac_cash_dep_dtl.user_id%TYPE,
      p_last_update        giac_cash_dep_dtl.last_update%TYPE
   );

   PROCEDURE del_giac_cash_dep_dtl (
      p_gacc_tran_id   giac_cash_dep_dtl.gacc_tran_id%TYPE,
      p_item_no        giac_cash_dep_dtl.item_no%TYPE
   );
END giac_cash_dep_dtl_pkg;
/


