CREATE OR REPLACE PACKAGE CPI.GIACS015_PKG
AS
   TYPE other_payments_type IS RECORD (
      or_print_tag        giac_other_collections.or_print_tag%TYPE,
      gacc_tran_id        giac_other_collections.gacc_tran_id%TYPE,
      item_no             giac_other_collections.item_no%TYPE,
      transaction_type    giac_other_collections.transaction_type%TYPE,
      tran_type_meaning   VARCHAR2 (100),
      tran_type_desc      VARCHAR2 (110),
      collection_amt      giac_other_collections.collection_amt%TYPE,
      gl_acct_category    giac_other_collections.gl_acct_category%TYPE,
      gl_control_acct     giac_other_collections.gl_control_acct%TYPE,
      gl_sub_acct_1       giac_other_collections.gl_sub_acct_1%TYPE,
      gl_sub_acct_2       giac_other_collections.gl_sub_acct_2%TYPE,
      gl_sub_acct_3       giac_other_collections.gl_sub_acct_3%TYPE,
      gl_sub_acct_4       giac_other_collections.gl_sub_acct_4%TYPE,
      gl_sub_acct_5       giac_other_collections.gl_sub_acct_5%TYPE,
      gl_sub_acct_6       giac_other_collections.gl_sub_acct_6%TYPE,
      gl_sub_acct_7       giac_other_collections.gl_sub_acct_7%TYPE,
      gl_acct_id          giac_other_collections.gl_acct_id%TYPE,
      dsp_account_name    giac_chart_of_accts.gl_acct_name%TYPE,
      sl_type_cd          giac_chart_of_accts.gslt_sl_type_cd%TYPE,
      sl_cd               giac_other_collections.sl_cd%TYPE,
      dsp_sl_name         giac_sl_lists.sl_name%TYPE,
      old_trans_no        VARCHAR2 (100),
      old_item_no         VARCHAR2 (100),
      gotc_item_no        giac_other_collections.gotc_item_no%TYPE,
      particulars         giac_other_collections.particulars%TYPE,
      gotc_gacc_tran_id   giac_other_collections.gotc_gacc_tran_id%TYPE,
      dsp_tran_year       giac_acctrans.tran_year%TYPE,   --        DRV_GUNC_GACC_TRAN_ID
      dsp_tran_month      giac_acctrans.tran_month%TYPE,  --        DRV_GUNC_GACC_TRAN_ID2
      dsp_tran_seq_no     giac_acctrans.tran_seq_no%TYPE, --        DRV_GUNC_GACC_TRAN_ID3
      user_id             giac_other_collections.user_id%TYPE,
      last_update         giac_other_collections.last_update%TYPE,
      max_item            NUMBER (2),
      total_amounts       giac_other_collections.collection_amt%TYPE
   );

   TYPE other_payments_tab IS TABLE OF other_payments_type;

   TYPE gl_acct_list_type IS RECORD (
      gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE,
      gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      gslt_sl_type_cd    giac_chart_of_accts.gslt_sl_type_cd%TYPE,
      gl_acct_code       VARCHAR2 (150)
   );

   TYPE gl_acct_list_tab IS TABLE OF gl_acct_list_type;

   TYPE sl_lists_type IS RECORD (
      sl_cd     giac_sl_lists.sl_cd%TYPE,
      sl_name   giac_sl_lists.sl_name%TYPE
   );

   TYPE sl_lists_tab IS TABLE OF sl_lists_type;

   TYPE transaction_type IS RECORD (
      transaction_type    giac_other_collections.transaction_type%TYPE,
      tran_type_meaning   VARCHAR2 (100)
   );

   TYPE transaction_tab IS TABLE OF transaction_type;

   TYPE old_tran_no_type IS RECORD (
      tran_year          giac_acctrans.tran_year%TYPE,
      tran_month         giac_acctrans.tran_month%TYPE,
      tran_seq_no        giac_acctrans.tran_seq_no%TYPE,
      old_item_no        VARCHAR2 (100),
      collection_amt     giac_other_collections.collection_amt%TYPE,
      collection_amt2    giac_other_collections.collection_amt%TYPE,
      gacc_tran_id       giac_other_collections.gacc_tran_id%TYPE,
      particulars        giac_other_collections.particulars%TYPE,
      transaction_type   giac_other_collections.transaction_type%TYPE,
      gl_acct_category   giac_other_collections.gl_acct_category%TYPE, --Kenneth L. 10.25.2013
      gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE,
      dsp_account_name   giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE
   );

   TYPE old_tran_no_tab IS TABLE OF old_tran_no_type;

   FUNCTION get_other_payments (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_fund_cd        giac_sl_lists.fund_cd%TYPE
   )
      RETURN other_payments_tab PIPELINED;

   FUNCTION get_gl_acct_list (
      p_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      p_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
   )
      RETURN gl_acct_list_tab PIPELINED;

   FUNCTION get_sl_lists (
      p_fund_cd      giac_sl_lists.fund_cd%TYPE,
      p_sl_type_cd   giac_sl_lists.sl_type_cd%TYPE,
      p_sl_cd        giac_other_collections.sl_cd%TYPE
   )
      RETURN sl_lists_tab PIPELINED;

   FUNCTION get_transaction_type (
      p_transaction_type   giac_other_collections.transaction_type%TYPE
   )
      RETURN transaction_tab PIPELINED;

   FUNCTION get_old_tran_no (
      p_tran_year      giac_acctrans.tran_year%TYPE,
      p_tran_month     giac_acctrans.tran_month%TYPE,
      p_tran_seq_no    giac_acctrans.tran_seq_no%TYPE,
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE
   )
      RETURN old_tran_no_tab PIPELINED;

   PROCEDURE update_op_text_giacs015 (
      p_gacc_tran_id    giac_other_collections.gacc_tran_id%TYPE,
      p_item_gen_type   giac_modules.generation_type%TYPE
   );

   PROCEDURE post_forms_commit_giacs015 (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_fund_cd        giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      p_user           VARCHAR2,
      p_mod_name       giac_modules.module_name%TYPE,
      p_or_flag        giac_order_of_payts.or_flag%TYPE,
      p_tran_source    VARCHAR2
   );

   PROCEDURE set_other_collns_dtls (
      p_other_collns   giac_other_collections%ROWTYPE
   );

   FUNCTION validate_old_tran_no_giacs015 (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_tran_year      giac_acctrans.tran_year%TYPE,
      p_tran_month     giac_acctrans.tran_month%TYPE,
      p_tran_seq_no    giac_acctrans.tran_seq_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION validate_old_item_no_giacs015 (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_item_no        giac_other_collections.item_no%TYPE
   )
      RETURN VARCHAR2;

   PROCEDURE delete_other_collns_dtls (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_item_no        giac_other_collections.item_no%TYPE
   );

   FUNCTION validate_delete_giacs015 (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_item_no        giac_other_collections.item_no%TYPE
   )
      RETURN VARCHAR2;
END GIACS015_PKG;
/


