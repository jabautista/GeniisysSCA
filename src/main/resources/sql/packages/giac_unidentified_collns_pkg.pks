CREATE OR REPLACE PACKAGE CPI.giac_unidentified_collns_pkg
AS
   TYPE giac_unidentified_collns_type IS RECORD (
      tran_year          giac_acctrans.tran_year%TYPE,
      tran_month         giac_acctrans.tran_month%TYPE,
      tran_seq_no        giac_acctrans.tran_seq_no%TYPE,
      item_no            giac_unidentified_collns.item_no%TYPE,
      collection_amt     giac_unidentified_collns.collection_amt%TYPE,
      collection_amt2    giac_unidentified_collns.collection_amt%TYPE,
      particulars        giac_unidentified_collns.particulars%TYPE,
      gacc_tran_id       giac_unidentified_collns.gacc_tran_id%TYPE,
      gunc_tran_id       giac_unidentified_collns.gunc_gacc_tran_id%TYPE,
      gunc_item_no       giac_unidentified_collns.gunc_item_no%TYPE,
      gl_acct_id         giac_unidentified_collns.gl_acct_id%TYPE,
      gl_acct_category   giac_unidentified_collns.gl_acct_category%TYPE,
      gl_control_acct    giac_unidentified_collns.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_unidentified_collns.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_unidentified_collns.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_unidentified_collns.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_unidentified_collns.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_unidentified_collns.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_unidentified_collns.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_unidentified_collns.gl_sub_acct_7%TYPE,
      or_print_tag       giac_unidentified_collns.or_print_tag%TYPE,
      sl_cd              giac_unidentified_collns.sl_cd%TYPE,
      sl_name			 giac_sl_lists.SL_NAME%TYPE,
	  gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
	  transaction_type	 giac_unidentified_collns.transaction_type%TYPE, --added by christian 05.04.2012
	  gslt_sl_type_cd	 giac_chart_of_accts.gslt_sl_type_cd%TYPE
   );

   TYPE giac_unidentified_collns_tab IS TABLE OF giac_unidentified_collns_type;

   TYPE giac_unidentified_collns_type2 IS RECORD (
      gacc_tran_id        giac_unidentified_collns.gacc_tran_id%TYPE,
      item_no             giac_unidentified_collns.item_no%TYPE,
      transaction_type    giac_unidentified_collns.transaction_type%TYPE,
      collection_amt      giac_unidentified_collns.collection_amt%TYPE,
      particulars         giac_unidentified_collns.particulars%TYPE,
      gl_acct_id          giac_unidentified_collns.gl_acct_id%TYPE,
      gl_acct_category    giac_unidentified_collns.gl_acct_category%TYPE,
      gl_control_acct     giac_unidentified_collns.gl_control_acct%TYPE,
      gl_sub_acct_1       giac_unidentified_collns.gl_sub_acct_1%TYPE,
      gl_sub_acct_2       giac_unidentified_collns.gl_sub_acct_2%TYPE,
      gl_sub_acct_3       giac_unidentified_collns.gl_sub_acct_3%TYPE,
      gl_sub_acct_4       giac_unidentified_collns.gl_sub_acct_4%TYPE,
      gl_sub_acct_5       giac_unidentified_collns.gl_sub_acct_5%TYPE,
      gl_sub_acct_6       giac_unidentified_collns.gl_sub_acct_6%TYPE,
      gl_sub_acct_7       giac_unidentified_collns.gl_sub_acct_7%TYPE,
      or_print_tag        giac_unidentified_collns.or_print_tag%TYPE,
      sl_cd               giac_unidentified_collns.sl_cd%TYPE,
      gunc_gacc_tran_id   giac_unidentified_collns.gunc_gacc_tran_id%TYPE,
      gunc_item_no        giac_unidentified_collns.gunc_item_no%TYPE,
      gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE,
	  sl_name			  giac_sl_lists.SL_NAME%TYPE,
	  gslt_sl_type_cd     giac_chart_of_accts.gslt_sl_type_cd%TYPE,
	  transaction_type_desc cg_ref_codes.rv_meaning%TYPE,
	  old_tran_no		  VARCHAR2(100),
	  old_tran_no2        VARCHAR2(50),
	  fund_cd			  giac_acctrans.gfun_fund_cd%TYPE,
	  tran_year			  giac_acctrans.tran_year%type,
	  tran_month		  giac_acctrans.tran_month%type,
	  tran_seq_no		  giac_acctrans.tran_seq_no%type
   );

   TYPE giac_unidentified_collns_tab2 IS TABLE OF giac_unidentified_collns_type2;

   FUNCTION get_old_item_dtls (
      p_gacc_tran_id   giac_unidentified_collns.gacc_tran_id%TYPE,
      p_tran_year      giac_acctrans.tran_year%TYPE,
      p_tran_month     giac_acctrans.tran_month%TYPE,
      p_tran_seq_no    giac_acctrans.tran_seq_no%TYPE,
	  p_old_item_no	   giac_unidentified_collns.gunc_item_no%TYPE,
	  p_item_no		   VARCHAR2
   )
      RETURN giac_unidentified_collns_tab PIPELINED;

   FUNCTION get_unidentified_colls_list (
      p_gacc_tran_id   giac_unidentified_collns.gacc_tran_id%TYPE,
	  p_fund_cd 	   varchar2
   )
      RETURN giac_unidentified_collns_tab2 PIPELINED;

   FUNCTION get_old_tran_nos_list (
      p_gacc_tran_id   giac_unidentified_collns.gacc_tran_id%TYPE,
      p_gunc_tran_id   giac_unidentified_collns.gunc_gacc_tran_id%TYPE
   )
      RETURN giac_unidentified_collns_tab PIPELINED;

   PROCEDURE set_unidentified_collns_dtls (
      p_gacc_tran_id        giac_unidentified_collns.gacc_tran_id%TYPE,
      p_item_no             giac_unidentified_collns.item_no%TYPE,
      p_transaction_type    giac_unidentified_collns.transaction_type%TYPE,
      p_collection_amt      giac_unidentified_collns.collection_amt%TYPE,
      p_gl_acct_id          giac_unidentified_collns.gl_acct_id%TYPE,
      p_gl_acct_category    giac_unidentified_collns.gl_acct_category%TYPE,
      p_gl_control_acct     giac_unidentified_collns.gl_control_acct%TYPE,
      p_gl_sub_acct_1       giac_unidentified_collns.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2       giac_unidentified_collns.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3       giac_unidentified_collns.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4       giac_unidentified_collns.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5       giac_unidentified_collns.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6       giac_unidentified_collns.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7       giac_unidentified_collns.gl_sub_acct_7%TYPE,
      p_or_print_tag        giac_unidentified_collns.or_print_tag%TYPE,
      p_sl_cd               giac_unidentified_collns.sl_cd%TYPE,
      p_gunc_gacc_tran_id   giac_unidentified_collns.gunc_gacc_tran_id%TYPE,
      p_gunc_item_no        giac_unidentified_collns.gunc_item_no%TYPE,
      p_particulars         giac_unidentified_collns.particulars%TYPE
   );

   PROCEDURE delete_collns_dtls (
      p_gacc_tran_id   giac_unidentified_collns.gacc_tran_id%TYPE,
      p_item_no        giac_unidentified_collns.item_no%TYPE
   );

   FUNCTION validate_old_tran_no (
      p_gacc_fund_cd   giac_acctrans.GFUN_FUND_CD%type,     -- added by shan 10.29.2013
      p_gibr_branch_cd giac_acctrans.GIBR_BRANCH_CD%type,   -- added by shan 10.29.2013
   	  p_gacc_tran_id   giac_unidentified_collns.gacc_tran_id%TYPE,
      p_tran_year      giac_acctrans.tran_year%TYPE,
      p_tran_month     giac_acctrans.tran_month%TYPE,
      p_tran_seq_no    giac_acctrans.tran_seq_no%TYPE,
	  p_item_no		   giac_unidentified_collns.item_no%TYPE
   )
      RETURN VARCHAR2;
	  
  FUNCTION validate_old_item_no(
    p_gacc_tran_id    giac_unidentified_collns.gacc_tran_id%TYPE,
	p_item_no         giac_unidentified_collns.item_no%TYPE
  )
	RETURN VARCHAR2;
	  
   PROCEDURE post_forms_commit_giacs014(
   	  p_gacc_tran_id   giac_unidentified_collns.gacc_tran_id%TYPE,
      p_fund_cd        giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      p_user           VARCHAR2,
	  p_mod_name	   GIAC_MODULES.module_name%type,
	  p_or_flag		   giac_order_of_payts.or_flag%TYPE,
	  p_tran_source	   varchar2
   );	  
   
    FUNCTION search_old_item_dtls (
      p_gacc_tran_id   giac_unidentified_collns.gacc_tran_id%TYPE,
      p_keyword      varchar2
   )
      RETURN giac_unidentified_collns_tab PIPELINED;   
      
   
    /* Validate that the deletion of the record is permitted    */
    /* by checking for the existence of rows in related tables. */
    /* added by shan 10.30.2013 */
    PROCEDURE validate_del_rec(
        P_GACC_TRAN_ID  IN  NUMBER,       
        P_ITEM_NO       IN  NUMBER
    );
   
END giac_unidentified_collns_pkg;
/


