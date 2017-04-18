CREATE OR REPLACE PACKAGE CPI.giacs092_pkg
AS
   TYPE branch_lov_type IS RECORD (
      branch_cd     giac_branches.branch_cd%TYPE,
      branch_name   giac_branches.branch_name%TYPE
   );

   TYPE branch_lov_tab IS TABLE OF branch_lov_type;

   FUNCTION get_branch_lov (p_gfun_fund_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN branch_lov_tab PIPELINED;

   TYPE pdc_payment_type IS RECORD (
      pdc_id           giac_apdc_payt_dtl.pdc_id%TYPE,
      apdc_no          giac_apdc_payt.apdc_no%TYPE,
      apdc_date        giac_apdc_payt.apdc_date%TYPE,
      bank_sname       giac_banks.bank_sname%TYPE,
      check_no         giac_apdc_payt_dtl.check_no%TYPE,
      check_date       giac_apdc_payt_dtl.check_date%TYPE,
      check_amt        giac_apdc_payt_dtl.check_amt%TYPE,
      short_name       giis_currency.short_name%TYPE,
      payor            giac_apdc_payt_dtl.payor%TYPE,
      address_1        giac_apdc_payt_dtl.address_1%TYPE,
      address_2        giac_apdc_payt_dtl.address_2%TYPE,
      address_3        giac_apdc_payt_dtl.address_3%TYPE,
      tin              giac_apdc_payt_dtl.tin%TYPE,
      or_no            giac_order_of_payts.or_no%TYPE,
      or_date          giac_order_of_payts.or_date%TYPE,
      particulars      giac_apdc_payt_dtl.particulars%TYPE,
      gross_amt        giac_apdc_payt_dtl.gross_amt%TYPE,
      commission_amt   giac_apdc_payt_dtl.commission_amt%TYPE,
      vat_amt          giac_apdc_payt_dtl.vat_amt%TYPE,
      currency_desc    giis_currency.currency_desc%TYPE,
      currency_rt      giac_apdc_payt_dtl.currency_rt%TYPE,
      fcurrency_amt    giac_apdc_payt_dtl.fcurrency_amt%TYPE,
      replace_count    NUMBER (10),
      detail_count     NUMBER (10)
   );

   TYPE pdc_payment_tab IS TABLE OF pdc_payment_type;

   FUNCTION get_pdc_payments (
      p_fund_cd      VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_check_flag   VARCHAR2,
      p_apdc_no      NUMBER,
      p_apdc_date    VARCHAR2,
      p_bank_sname   VARCHAR2,
      p_check_no     VARCHAR2,
      p_check_date   VARCHAR2,
      p_check_amt    NUMBER,
      p_short_name   VARCHAR2
   )
      RETURN pdc_payment_tab PIPELINED;

   TYPE details_type IS RECORD (
      pdc_id               giac_pdc_prem_colln.pdc_id%TYPE,
      transaction_type     giac_pdc_prem_colln.transaction_type%TYPE,
      iss_cd               giac_pdc_prem_colln.iss_cd%TYPE,
      prem_seq_no          giac_pdc_prem_colln.prem_seq_no%TYPE,
      inst_no              giac_pdc_prem_colln.inst_no%TYPE,
      collection_amt       giac_pdc_prem_colln.collection_amt%TYPE,
      premium_amt          giac_pdc_prem_colln.premium_amt%TYPE,
      tax_amt              giac_pdc_prem_colln.tax_amt%TYPE,
      tot_collection_amt   giac_pdc_prem_colln.collection_amt%TYPE,
      tot_premium_amt      giac_pdc_prem_colln.premium_amt%TYPE,
      tot_tax_amt          giac_pdc_prem_colln.tax_amt%TYPE,
      assd_name            giis_assured.assd_name%TYPE,
      policy_no            VARCHAR2 (500),
      user_id              giac_pdc_prem_colln.user_id%TYPE,
      last_update          VARCHAR2 (500),
      currency_desc        giis_currency.currency_desc%TYPE,
      currency_rt          giac_pdc_prem_colln.currency_rt%TYPE,
      fcurrency_amt        giac_pdc_prem_colln.fcurrency_amt%TYPE
   );

   TYPE details_tab IS TABLE OF details_type;

   FUNCTION get_details (p_pdc_id NUMBER)
      RETURN details_tab PIPELINED;

   TYPE replacement_type IS RECORD (
      bank_sname       giac_banks.bank_sname%TYPE,
      check_no         giac_apdc_payt_dtl.check_no%TYPE,
      check_amt        giac_apdc_payt_dtl.check_amt%TYPE,
      replace_date     giac_apdc_payt_dtl.replace_date%TYPE,
      item_no          giac_pdc_replace.item_no%TYPE,
      pay_mode         giac_pdc_replace.pay_mode%TYPE,
      bank_sname2      giac_banks.bank_sname%TYPE,
      check_class      giac_pdc_replace.check_class%TYPE,
      check_no2        giac_pdc_replace.check_no%TYPE,
      check_date       giac_pdc_replace.check_date%TYPE,
      amount           giac_pdc_replace.amount%TYPE,
      gross_amt        giac_pdc_replace.gross_amt%TYPE,
      commission_amt   giac_pdc_replace.commission_amt%TYPE,
      vat_amt          giac_pdc_replace.vat_amt%TYPE,
      currency_desc    giis_currency.currency_desc%TYPE,
      apdc_no          giac_apdc_payt.apdc_no%TYPE,
      tot_amount       giac_pdc_replace.amount%TYPE
   );

   TYPE replacement_tab IS TABLE OF replacement_type;

   FUNCTION get_replacement (p_pdc_id NUMBER)
      RETURN replacement_tab PIPELINED;
END;
/


