CREATE OR REPLACE PACKAGE CPI.giacr050_cpi_pkg
AS
   TYPE giac_or_type IS RECORD (
      gacc_tran_id        giac_order_of_payts.gacc_tran_id%TYPE,
      gibr_gfun_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      payor               giac_order_of_payts.payor%TYPE,
      or_date             giac_order_of_payts.or_date%TYPE,
      op_collection_amt   giac_order_of_payts.gross_amt%TYPE,
      currency_cd         giac_order_of_payts.currency_cd%TYPE,
      gross_tag           giac_order_of_payts.gross_tag%TYPE,
      intm_no             giac_order_of_payts.intm_no%TYPE,
      prov_receipt_no     giac_order_of_payts.prov_receipt_no%TYPE,
      or_no               VARCHAR2 (100),
      cashier_cd          giac_order_of_payts.cashier_cd%TYPE,
      particulars         giac_order_of_payts.particulars%TYPE,
      dcb_no              giac_order_of_payts.dcb_no%TYPE,
      address             VARCHAR2 (200),
      with_pdc            giac_order_of_payts.with_pdc%TYPE,
      tin                 giac_order_of_payts.tin%TYPE,
      short_name          giis_currency.short_name%TYPE,
      claim_no            VARCHAR2 (100),
      assured_name        gicl_claims.assured_name%TYPE,
      loss_date           VARCHAR2 (20),
      recovery_no         VARCHAR2 (100),
      or_flag             giac_order_of_payts.or_flag%TYPE,
      or_pref_suf         giac_order_of_payts.or_pref_suf%TYPE,
      or_print_tag        giac_op_text.or_print_tag%TYPE,
      cf_giot_others      NUMBER (12, 2),
      cf_giot_prem        NUMBER (12, 2),
      cf_giot_doc         NUMBER (12, 2),
      cf_giot_lgt         NUMBER (12, 2),
      cf_giot_ri_comm     NUMBER (12, 2),
      cf_giot_vat_comm    NUMBER (12, 2),
      cf_giot_prem_tax    NUMBER (12, 2),
      cf_giot_evat        NUMBER (12, 2),
      cf_tot_collns       NUMBER (12, 2),
      cf_giot_fst         NUMBER (12, 2),
      cf_or_type          VARCHAR2 (100),
      check_ri_comm       VARCHAR2 (100),
      check_item_text     VARCHAR2 (100)
   );

   TYPE giac_or_tab IS TABLE OF giac_or_type;

   FUNCTION get_giac_or_rep (                     --Added by Alfred 03/04/2011
      p_or_pref   VARCHAR2,
      p_or_no     VARCHAR2,
      p_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
   )
      RETURN giac_or_tab PIPELINED;

   TYPE giac_colln_dtl_rep_type IS RECORD (
      gacc_tran_id        giac_collection_dtl.gacc_tran_id%TYPE,
      pay_mode            giac_collection_dtl.pay_mode%TYPE,
      amount              giac_collection_dtl.amount%TYPE,
      check_date          giac_collection_dtl.check_date%TYPE,
      check_no            giac_collection_dtl.check_no%TYPE,
      bank_cd             giac_collection_dtl.bank_cd%TYPE,
      gross_amt           giac_collection_dtl.gross_amt%TYPE,
      commission_amt      giac_collection_dtl.commission_amt%TYPE,
      bank_name           giac_banks.bank_name%TYPE,
      count_paymode_chk   VARCHAR2 (1)
   );

   TYPE giac_colln_dtl_rep_tab IS TABLE OF giac_colln_dtl_rep_type;

   FUNCTION get_giac_collection_dtl_rep (         --Added by Alfred 03/04/2011
      p_cp_check_title    giac_collection_dtl.check_no%TYPE,
      p_cp_credit_title   giac_collection_dtl.check_no%TYPE,
      p_gross_tag         giac_order_of_payts.gross_tag%TYPE,
      p_cp_sum            VARCHAR2,
      p_tran_id           giac_collection_dtl.gacc_tran_id%TYPE
   )
      RETURN giac_colln_dtl_rep_tab PIPELINED;
END;
/

DROP PACKAGE CPI.GIACR050_CPI_PKG;

