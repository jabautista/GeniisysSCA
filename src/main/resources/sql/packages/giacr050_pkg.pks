CREATE OR REPLACE PACKAGE CPI.GIACR050_PKG
AS
   TYPE or_details_type IS RECORD (
      gacc_tran_id              giac_order_of_payts.gacc_tran_id%TYPE,
      gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
      payor                     VARCHAR2 (500),
      or_date                   VARCHAR2 (50),
      op_collection_amt         giac_order_of_payts.gross_amt%TYPE,
      currency_cd               giac_order_of_payts.currency_cd%TYPE,
      gross_tag                 giac_order_of_payts.gross_tag%TYPE,
      intm_no                   giac_order_of_payts.intm_no%TYPE,
      prov_receipt_no           giac_order_of_payts.prov_receipt_no%TYPE,
      or_no                     VARCHAR2 (100),
      cashier_cd                giac_order_of_payts.cashier_cd%TYPE,
      particulars               giac_order_of_payts.particulars%TYPE,
      dcb_no                    giac_order_of_payts.dcb_no%TYPE,
      address                   VARCHAR2 (200),
      with_pdc                  giac_order_of_payts.with_pdc%TYPE,
      tin                       giac_order_of_payts.tin%TYPE,
      short_name                giis_currency.short_name%TYPE,
      branch_tin_cd             giis_issource.branch_tin_cd%TYPE,
      branch_remarks            giis_issource.remarks%TYPE,
      branch_add                VARCHAR2 (250),
      bir_permit_no             VARCHAR2 (4000),
      cashier_name              giac_dcb_users.print_name%TYPE,
      cp_gcd_curr_sname         VARCHAR2 (5),
      cf_gcd_curr_rt            NUMBER,
      prem_title                VARCHAR2 (50),
      cf_giot_prem_amt          NUMBER (12, 2),
      cp_ri_comm_amt            NUMBER (12, 2),
      cp_ri_comm_vat            NUMBER (12, 2),
      cp_doc_stamps             NUMBER (12, 2),
      cf_vat                    NUMBER (12, 2),
      cf_vat_exempt             NUMBER (12, 2),
      cs_grand_total            NUMBER (12, 2),
      cp_vat_sale               NUMBER (12, 2),
      cp_vat_exempt_sale        NUMBER (12, 2),
      cp_vat_zero_rated_sale    NUMBER (12, 2),
      cp_payment_forms          VARCHAR2 (500)
   );

   TYPE or_details_tab IS TABLE OF or_details_type;
   
   TYPE tax_collections_type IS RECORD (
      tax_name                  giac_taxes.tax_name%TYPE,
      tax_amount_collections    NUMBER (12, 2)
   );

   TYPE tax_collections_tab IS TABLE OF tax_collections_type;
   
   TYPE item_details_type IS RECORD (
      item_text                 giac_op_text.item_text%TYPE,
      item_amount               NUMBER (12, 2)
   );

   TYPE item_details_tab IS TABLE OF item_details_type;
   
   TYPE bank_details_type IS RECORD (
      cf_bank_sname             giac_banks.bank_sname%TYPE,
      check_no                  giac_collection_dtl.check_no%TYPE,
      check_date1               giac_collection_dtl.check_date%TYPE,
      bank_cd                   giac_collection_dtl.bank_cd%TYPE,             
      gross_tag                 giac_order_of_payts.gross_tag%TYPE
   );

   TYPE bank_details_tab IS TABLE OF bank_details_type;
   
   FUNCTION get_or_details (
      P_OR_PREF                 VARCHAR2,
      P_OR_NO                   VARCHAR2,
      P_TRAN_ID                 giac_or_stat_hist.gacc_tran_id%TYPE
   )
      RETURN or_details_tab PIPELINED;
      
   FUNCTION get_tax_collections (
      P_OR_PREF                 VARCHAR2,
      P_OR_NO                   VARCHAR2,
      P_TRAN_ID                 giac_or_stat_hist.gacc_tran_id%TYPE
   )
      RETURN tax_collections_tab PIPELINED;
      
   FUNCTION get_item_details (
      P_OR_PREF                 VARCHAR2,
      P_OR_NO                   VARCHAR2,
      P_TRAN_ID                 giac_or_stat_hist.gacc_tran_id%TYPE
   )
      RETURN item_details_tab PIPELINED;
      
   FUNCTION get_bank_details (
      P_CP_CHECK_TITLE          giac_collection_dtl.check_no%TYPE,
      P_CP_CREDIT_TITLE         giac_collection_dtl.check_no%TYPE,
      P_GROSS_TAG               giac_order_of_payts.gross_tag%TYPE,
      P_CP_SUM                  VARCHAR2,
      P_TRAN_ID                 giac_collection_dtl.gacc_tran_id%TYPE
   )
      RETURN bank_details_tab PIPELINED;
END;
/


