CREATE OR REPLACE PACKAGE CPI.giac_order_of_payts_pkg
AS
   PROCEDURE set_giac_order_of_payts (
      v_gacc_tran_id        IN OUT   giac_order_of_payts.gacc_tran_id%TYPE,
      v_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      v_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      v_payor                        giac_order_of_payts.payor%TYPE,
      v_collection_amt               giac_order_of_payts.collection_amt%TYPE,
      v_cashier_cd                   giac_order_of_payts.cashier_cd%TYPE, 
      v_address_1                    giac_order_of_payts.address_1%TYPE, 
      v_address_2                    giac_order_of_payts.address_2%TYPE,  
      v_address_3                    giac_order_of_payts.address_3%TYPE,
      v_particulars                  giac_order_of_payts.particulars%TYPE, 
      v_or_tag                       giac_order_of_payts.or_tag%TYPE,
      v_or_date                      giac_order_of_payts.or_date%TYPE,
      v_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
      v_gross_amt                    giac_order_of_payts.gross_amt%TYPE,
      v_gross_tag                    giac_order_of_payts.gross_tag%TYPE,
      v_or_flag                      giac_order_of_payts.or_flag%TYPE,
      v_op_flag                      giac_order_of_payts.op_flag%TYPE,
      v_currcd                       giac_order_of_payts.currency_cd%TYPE,
      v_intmno                       giac_order_of_payts.intm_no%TYPE,
      v_tinno                        giac_order_of_payts.tin%TYPE,
      v_uploadtag                    giac_order_of_payts.upload_tag%TYPE,
      v_remitdate                    giac_order_of_payts.remit_date%TYPE,
      v_provreceiptno                giac_order_of_payts.prov_receipt_no%TYPE,
      v_or_no                        giac_order_of_payts.or_no%TYPE,
      v_or_pref_suf                  giac_order_of_payts.or_pref_suf%TYPE,
      v_ri_comm_tag                  giac_order_of_payts.ri_comm_tag%TYPE -- added by: Nica 06.14.2013 AC-SPECS-2012-155
   );

   TYPE giac_order_of_payts_dtl_type IS RECORD (
      gacc_tran_id        giac_order_of_payts.gacc_tran_id%TYPE,
      tran_no             VARCHAR2 (50),
      gibr_gfun_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      op_no               giac_order_of_payts.op_no%TYPE,
      op_date             giac_order_of_payts.op_date%TYPE,
      op_flag             giac_order_of_payts.op_flag%TYPE,
      op_tag              giac_order_of_payts.op_tag%TYPE,
      or_no               giac_order_of_payts.or_no%TYPE,
      or_date             giac_order_of_payts.or_date%TYPE,
      or_flag             giac_order_of_payts.or_flag%TYPE,
      payor               giac_order_of_payts.payor%TYPE,
      collection_amt      giac_order_of_payts.collection_amt%TYPE,
      gross_amt           giac_order_of_payts.gross_amt%TYPE,
      currency_cd         giac_order_of_payts.currency_cd%TYPE,
      gross_tag           giac_order_of_payts.gross_tag%TYPE,
      address_1           giac_order_of_payts.address_1%TYPE,
      address_2           giac_order_of_payts.address_2%TYPE,
      address_3           giac_order_of_payts.address_3%TYPE,
      particulars         giac_order_of_payts.particulars%TYPE,
      ri_comm_tag         giac_order_of_payts.ri_comm_tag%TYPE  --Nica 06.14.2013 AC-SPECS-2012-155
   --currency_sname           VARCHAR2(3),
   --f_currency_sname         VARCHAR2(10)
   );

   TYPE giac_order_of_payts_type IS RECORD (
      payor          giac_order_of_payts.payor%TYPE,
      address_1      giac_order_of_payts.address_1%TYPE,
      address_2      giac_order_of_payts.address_2%TYPE,
      address_3      giac_order_of_payts.address_3%TYPE,
      or_tag         giac_order_of_payts.or_tag%TYPE,
      or_date        giac_order_of_payts.or_date%TYPE,
      particulars    giac_order_of_payts.particulars%TYPE,
      tin            giac_order_of_payts.tin%TYPE,
      gacc_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
   );

   TYPE giac_order_of_payts_dtl_tab IS TABLE OF giac_order_of_payts_dtl_type;

   TYPE giac_order_of_payts_tab IS TABLE OF giac_order_of_payts_type;

   FUNCTION get_cancelled_or_details (
      p_or_pref_suf   giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no         giac_order_of_payts.or_no%TYPE
   )
      RETURN giac_order_of_payts_tab PIPELINED;

   FUNCTION get_giac_order_of_payts_dtl (
      p_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
   )
      RETURN giac_order_of_payts_dtl_tab PIPELINED;

   FUNCTION get_or_tag (p_workf_col_value NUMBER)
      RETURN VARCHAR2;

   /*************** OR LISTING *****************/
   TYPE or_list_type IS RECORD (
      dcb_no              VARCHAR2 (100),
      or_no               VARCHAR2 (100),
      or_date             giac_order_of_payts.or_date%TYPE,
      status              VARCHAR2 (100),
      payor               giac_order_of_payts.payor%TYPE,
      dcb_bank_acct       VARCHAR2 (100),
      gacc_tran_id        giac_order_of_payts.gacc_tran_id%TYPE,
      gibr_gfun_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      item_no             giac_collection_dtl.item_no%TYPE,
      or_tag              giac_order_of_payts.or_tag%TYPE,
      or_flag             giac_order_of_payts.or_flag%TYPE,
      op_tag              giac_order_of_payts.op_tag%TYPE,
      with_pdc            giac_order_of_payts.with_pdc%TYPE,
      or_tag_lbl          VARCHAR2 (1),
	  dcb_user_id         giac_dcb_users.dcb_user_id%TYPE, -- added by Nica 06.15.2012
      user_id             giac_order_of_payts.user_id%TYPE,
	  last_update         giac_order_of_payts.last_update%TYPE, -- added by Nica 06.15.2012
-- label for tag (displays asterisk if manual, otherwise none) emman (03.15.2011)
      count_              NUMBER, --mikel 01.22.2015
      rownum_             NUMBER --added by pjsantos 09/26/2016, for optimization 09/26/2016
   );

   TYPE or_list_tab IS TABLE OF or_list_type;

   FUNCTION get_or_list (
      p_search_key   VARCHAR2,
      p_fund_cd      giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd    giac_order_of_payts.gibr_branch_cd%TYPE
   )
      RETURN or_list_tab PIPELINED;

   /*************** GET ORDER OF PAYMENT *****************/
   TYPE giac_or_dtl_type IS RECORD (
      gacc_tran_id        giac_order_of_payts.gacc_tran_id%TYPE,
      gibr_gfun_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      op_no               giac_order_of_payts.op_no%TYPE,
      op_date             giac_order_of_payts.op_date%TYPE,
      op_flag             giac_order_of_payts.op_flag%TYPE,
      or_no               giac_order_of_payts.or_no%TYPE,
      or_date             giac_order_of_payts.or_date%TYPE,
      or_flag             giac_order_of_payts.or_flag%TYPE,
      or_tag              giac_order_of_payts.or_tag%TYPE,
      dcb_no              giac_order_of_payts.dcb_no%TYPE,
      payor               giac_order_of_payts.payor%TYPE,
      collection_amt      giac_order_of_payts.collection_amt%TYPE,
      gross_amt           giac_order_of_payts.gross_amt%TYPE,
      cashier_cd          giac_order_of_payts.cashier_cd%TYPE,
      currency_cd         giac_order_of_payts.currency_cd%TYPE,
      or_pref_suf         giac_order_of_payts.or_pref_suf%TYPE,
      gross_tag           giac_order_of_payts.gross_tag%TYPE,
      address_1           giac_order_of_payts.address_1%TYPE,
      address_2           giac_order_of_payts.address_2%TYPE,
      address_3           giac_order_of_payts.address_3%TYPE,
      particulars         giac_order_of_payts.particulars%TYPE,
      remit_date          giac_order_of_payts.remit_date%TYPE,
      prov_receipt_no     giac_order_of_payts.prov_receipt_no%TYPE,
      intm_no             giac_order_of_payts.intm_no%TYPE,
      upload_tag          giac_order_of_payts.upload_tag%TYPE,
      cancel_date         giac_order_of_payts.cancel_date%TYPE,
      cancel_dcb_no       giac_order_of_payts.cancel_dcb_no%TYPE,
      or_cancel_tag       giac_order_of_payts.or_cancel_tag%TYPE,
      with_pdc            giac_order_of_payts.with_pdc%TYPE,
      tin                 giac_order_of_payts.tin%TYPE,
      ri_comm_tag         giac_order_of_payts.ri_comm_tag%TYPE
   );

   TYPE giac_or_dtl_tab IS TABLE OF giac_or_dtl_type;

   FUNCTION get_giac_or_dtl (p_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
      RETURN giac_or_dtl_tab PIPELINED;

   PROCEDURE check_or_flag (
      p_gacc_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
   );

   PROCEDURE update_giac_order_of_payts (
        p_gacc_tran_id            giac_acctrans.tran_id%TYPE,
        p_prem_seq_no             giac_aging_soa_details.prem_seq_no%TYPE,
        p_iss_cd                  giac_aging_soa_details.iss_cd%TYPE,
        p_transaction_type		  giac_direct_prem_collns.transaction_type%TYPE,
        p_inst_no			      giac_direct_prem_collns.inst_no%TYPE,
        p_premium_amt	    	  giac_direct_prem_collns.premium_amt%TYPE,
        p_tax_amt		          giac_direct_prem_collns.tax_amt%TYPE,
        p_tran_source             VARCHAR2,
        p_module_name             giac_modules.module_name%TYPE,
        p_msg_alert      OUT      VARCHAR2,
        p_workflow_msg   OUT      VARCHAR2,
        --p_user_id                 VARCHAR2, alfie 04/26/2011
        p_or_part_sw     IN OUT   VARCHAR2
   );

   FUNCTION get_or_list2 (
      p_fund_cd             giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd           giac_order_of_payts.gibr_branch_cd%TYPE,
      p_dcb_no              VARCHAR2,   
      p_or_no               VARCHAR2,
      p_payor               giac_order_of_payts.payor%TYPE,
      p_status              VARCHAR2,
      p_or_date             VARCHAR2,
      p_last_update         VARCHAR2,       -- Added by Jerome Bautista 11.03.2015 SR 20144
      p_cashier             giac_order_of_payts.user_id%TYPE,
      p_user_id             giac_order_of_payts.user_id%TYPE,
      p_cancel_or           VARCHAR2, 
      p_or_tag              VARCHAR2,       --added by pjsantos @pcic 09/26/2016, for optimization GENQA 5687
      p_order_by            VARCHAR2,       --added by pjsantos @pcic 09/26/2016, for optimization GENQA 5687
      p_asc_desc_flag       VARCHAR2,       --added by pjsantos @pcic 09/26/2016,for optimization GENQA 5687
      p_first_row           NUMBER,         --mikel 01.22.2015
      p_last_row            NUMBER          --mikel 11.05.2014
   )
      RETURN or_list_tab PIPELINED;
	  
   FUNCTION get_or_list3 (
      p_fund_cd     giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE,
      p_dcb_no      VARCHAR2,
      p_or_no       VARCHAR2,
      p_payor       giac_order_of_payts.payor%TYPE,
      p_status      VARCHAR2,
      p_or_date     VARCHAR2,
   	  p_cashier     giac_dcb_users.dcb_user_id%TYPE,
	  p_last_user   giac_order_of_payts.user_id%TYPE,
      p_app_user_id	giis_users.user_id%TYPE,    
      p_cancel_or   VARCHAR2
   )
      RETURN or_list_tab PIPELINED;

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

   PROCEDURE ins_upd_giop_giacs050 (
      p_gacc_tran_id   IN       giac_op_text.gacc_tran_id%TYPE,
      p_branch_cd      IN       giac_or_pref.branch_cd%TYPE,
      p_fund_cd        IN       giac_or_pref.fund_cd%TYPE,
      p_or_pref        IN       giac_doc_sequence.doc_pref_suf%TYPE,
      p_or_no          IN       giac_doc_sequence.doc_seq_no%TYPE,
      p_user_id        IN       giac_dcb_users.user_id%TYPE,
      p_result         OUT      VARCHAR2
   );

   PROCEDURE insert_into_order_of_payts (
      p_fund_cd          giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd        giac_order_of_payts.gibr_branch_cd%TYPE,
      p_dcb_no           giac_order_of_payts.dcb_no%TYPE,
      p_or_pref_suf      giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no            giac_order_of_payts.or_no%TYPE,
      p_acc_tran_id      giac_acctrans.tran_id%TYPE,
      p_payor            giac_order_of_payts.payor%TYPE,
      p_collection_amt   giac_order_of_payts.collection_amt%TYPE,
      p_cashier_cd       giac_order_of_payts.cashier_cd%TYPE,
      p_or_tag           giac_order_of_payts.or_tag%TYPE,
      p_gross_amt        giac_order_of_payts.gross_amt%TYPE,
      p_gross_tag        giac_order_of_payts.gross_tag%TYPE
   );

   PROCEDURE update_gacc_giop_tables (
      p_gacc_tran_id        giac_order_of_payts.gacc_tran_id%TYPE,
      p_dcb_no              giac_order_of_payts.dcb_no%TYPE,
      p_gibr_gfun_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      p_or_date             VARCHAR2
   );

   PROCEDURE process_spoil_or (
      p_gacc_tran_id        IN       giac_order_of_payts.gacc_tran_id%TYPE,
      p_but_label           IN       VARCHAR2,
      p_or_flag             IN OUT   giac_order_of_payts.or_flag%TYPE,
      p_or_tag              IN       giac_order_of_payts.or_tag%TYPE,
      p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
      p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      p_or_date                      VARCHAR2,
      p_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
      p_calling_form                 VARCHAR2,
      p_module_name                  VARCHAR2,
      p_or_cancellation              VARCHAR2,
      p_payor                        giac_order_of_payts.payor%TYPE,
      p_collection_amt               giac_order_of_payts.collection_amt%TYPE,
      p_cashier_cd                   giac_order_of_payts.cashier_cd%TYPE,
      p_gross_amt                    giac_order_of_payts.gross_amt%TYPE,
      p_gross_tag                    giac_order_of_payts.gross_tag%TYPE,
      p_item_no                      giac_module_entries.item_no%TYPE,
      p_message             OUT      VARCHAR2
   );

   PROCEDURE spoil_or (
      p_gacc_tran_id                 giac_order_of_payts.gacc_tran_id%TYPE,
      p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
      p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      p_or_date                      VARCHAR2,
      p_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
      p_or_flag             IN OUT   giac_order_of_payts.or_flag%TYPE,
      p_message             OUT      VARCHAR2
   );

   PROCEDURE cancel_or (
      p_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
      p_gacc_tran_id                 giac_order_of_payts.gacc_tran_id%TYPE,
      p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
      p_or_date                      VARCHAR2,
      p_message             OUT      VARCHAR2,
      p_calling_form                 VARCHAR2,
      p_module_name                  VARCHAR2,
      p_or_cancellation              VARCHAR2,
      p_payor                        giac_order_of_payts.payor%TYPE,
      p_collection_amt               giac_order_of_payts.collection_amt%TYPE,
      p_cashier_cd                   giac_order_of_payts.cashier_cd%TYPE,
      p_or_tag                       giac_order_of_payts.or_tag%TYPE,
      p_gross_amt                    giac_order_of_payts.gross_amt%TYPE,
      p_gross_tag                    giac_order_of_payts.gross_tag%TYPE,
      p_item_no                      giac_module_entries.item_no%TYPE,
      p_or_flag             IN OUT   giac_order_of_payts.or_flag%TYPE
   );

   TYPE giac_credit_memo_type IS RECORD (
      cm_no         VARCHAR2 (1000),
      memo_date     giac_cm_dm.memo_date%TYPE,
      amount        giac_cm_dm.amount%TYPE,
      currency_cd   giac_cm_dm.currency_cd%TYPE,
      currency_rt   giac_cm_dm.currency_rt%TYPE,
      local_amt     giac_cm_dm.local_amt%TYPE,
      short_name    giis_currency.short_name%TYPE,
      cm_tran_id    giac_cm_dm.gacc_tran_id%TYPE,
      fc_amount     giac_cm_dm.amount%TYPE
   );

   TYPE giac_credit_memo_tab IS TABLE OF giac_credit_memo_type;

   FUNCTION get_credit_memo_dtls (
      p_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE
   )
      RETURN giac_credit_memo_tab PIPELINED;
   
   FUNCTION get_credit_memo_dtls_list (
      p_fund_cd     giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_memo_type   giac_cm_dm.memo_type%TYPE,
      p_pay_mode    giac_collection_dtl.pay_mode%TYPE
   )
      RETURN giac_credit_memo_tab PIPELINED;
      
   FUNCTION check_attached_OR(
       p_dcb_no     GIAC_ORDER_OF_PAYTS.dcb_no%TYPE,
       p_fund_cd    GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
       p_branch_cd  GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
       p_tran_date  GIAC_ORDER_OF_PAYTS.or_date%TYPE     
   ) RETURN VARCHAR2;
   
    TYPE giac_or_ucpbgen_type IS RECORD (
      or_date           varchar2(50),
      op_collection_amt giac_order_of_payts.collection_amt%TYPE,
      payor             giac_order_of_payts.payor%TYPE,
      address           varchar2(175),
      tin               giac_order_of_payts.tin%TYPE,
      particulars       giac_order_of_payts.particulars%TYPE,
      intm_name         giis_intermediary.intm_name%TYPE,
      intm_no           giac_order_of_payts.intm_no%TYPE,
      prov_receipt_no   giac_order_of_payts.prov_receipt_no%TYPE,
      short_name        giis_currency.short_name%TYPE,
      currency_cd       giac_parameters.param_name%TYPE,
      payment_no        giac_collection_dtl.pay_mode%TYPE,
      print_name        giac_dcb_users.print_name%TYPE,
      vat_type          varchar2(50),
      total_premium     number,
      grand_total       number,
      bir_permit_no     varchar2(50) --belle 10042012
   );

   TYPE giac_or_ucpbgen_tab IS TABLE OF giac_or_ucpbgen_type;

   FUNCTION get_or_ucpbgen (
      p_tran_id    giac_order_of_payts.gacc_tran_id%TYPE
   )
      RETURN giac_or_ucpbgen_tab PIPELINED;
      

   FUNCTION validate_or_no(
      p_or_pref  giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no    giac_order_of_payts.or_no%TYPE,
   p_fund_cd giac_order_of_payts.GIBR_GFUN_FUND_CD%type,
   p_branch_cd giac_order_of_payts.GIBR_BRANCH_CD%type
   
   ) 
   RETURN VARCHAR2;
   
    PROCEDURE giacs050_ins_upd_GIOP(
        p_gacc_tran_id  IN  GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_branch_cd     IN  giac_order_of_payts.gibr_branch_cd%TYPE,
        p_fund_cd       IN  giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
        p_or_pref  		IN  giac_doc_sequence.doc_pref_suf%TYPE,
        p_or_no    		IN  giac_doc_sequence.doc_seq_no%TYPE,
        p_edit_or_no	IN  VARCHAR2
    );
    
    PROCEDURE upd_gorr_giacs050 (
        p_gacc_tran_id  IN  GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_or_pref  		IN  giac_doc_sequence.doc_pref_suf%TYPE,
        p_or_no    		IN  giac_doc_sequence.doc_seq_no%TYPE
    );
   
    PROCEDURE update_colln_amt_gross_amt(p_gacc_tran_id giac_order_of_payts.gacc_tran_id%TYPE);
    
    TYPE batch_or_type IS RECORD(
        gacc_tran_id         GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        gibr_gfun_fund_cd    GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        gibr_branch_cd       GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        or_flag              GIAC_ORDER_OF_PAYTS.or_flag%TYPE,
        or_pref_suf          GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,
        or_no                GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        or_date              GIAC_ORDER_OF_PAYTS.or_date%TYPE,
        dsp_or_date          VARCHAR2(30),
        dsp_or_pref          VARCHAR2(20),
        dsp_or_no            VARCHAR2(20),
        payor                GIAC_ORDER_OF_PAYTS.payor%TYPE,
        particulars          GIAC_ORDER_OF_PAYTS.particulars%TYPE,
        nbt_repl_or_tag      VARCHAR2(1),
        nbt_tran_flag        VARCHAR2(1)
    );
    TYPE batch_or_tab IS TABLE OF batch_or_type;
    
    FUNCTION get_batch_or_list(
        p_fund_cd            GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd          GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_called_by_upload   VARCHAR2,
        p_upload_query       VARCHAR2
    )
      RETURN batch_or_tab PIPELINED;
      
    FUNCTION check_or(
        p_gacc_tran_id      GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    )
      RETURN VARCHAR2;
      
    PROCEDURE get_default_vat_or(
        p_fund_cd       IN  GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd     IN  GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_user_id       IN  GIIS_USERS.user_id%TYPE,
        p_vat_seq       OUT GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_vat_or_pref   OUT GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE
    );
    
    PROCEDURE get_default_non_vat_or(
        p_fund_cd       IN  GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd     IN  GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_user_id       IN  GIIS_USERS.user_id%TYPE,
        p_nvat_seq      OUT GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_nvat_or_pref  OUT GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE
    );
    
    PROCEDURE get_default_other_or(
        p_fund_cd       IN  GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd     IN  GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_user_id       IN  GIIS_USERS.user_id%TYPE,
        p_other_seq     OUT GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_other_or_pref OUT GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE
    );
    
    FUNCTION check_apdc_payt_dtl(
      p_gacc_tran_id       GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    )
      RETURN VARCHAR2;
      
    TYPE cancelled_or_type IS RECORD(
        or_pref_suf     GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,
        or_no           GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        payor           GIAC_ORDER_OF_PAYTS.payor%TYPE,
        particulars     GIAC_ORDER_OF_PAYTS.particulars%TYPE,
        address_1       GIAC_ORDER_OF_PAYTS.address_1%TYPE,
        address_2       GIAC_ORDER_OF_PAYTS.address_2%TYPE,
        address_3       GIAC_ORDER_OF_PAYTS.address_3%TYPE,
        or_date         GIAC_ORDER_OF_PAYTS.or_date%TYPE,
        or_tag          GIAC_ORDER_OF_PAYTS.or_tag%TYPE,
        tin             GIAC_ORDER_OF_PAYTS.tin%TYPE,
        gacc_tran_id    GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    );
    TYPE cancelled_or_tab IS TABLE OF cancelled_or_type;
    
    FUNCTION get_cancelled_or_list(
        p_user_id            VARCHAR2
    )
      RETURN cancelled_or_tab PIPELINED;
      
    TYPE cncl_colln_breakdown_type IS RECORD(
        item_no             giac_collection_dtl.item_no%TYPE,         
        pay_mode            giac_collection_dtl.pay_mode%TYPE,        
        bank_cd             giac_collection_dtl.bank_cd%TYPE,         
        check_class         giac_collection_dtl.check_class%TYPE,     
        check_no            giac_collection_dtl.check_no%TYPE,        
        check_date          giac_collection_dtl.check_date%TYPE,      
        amount              giac_collection_dtl.amount%TYPE,          
        currency_cd         giac_collection_dtl.currency_cd%TYPE,     
        currency_rt         giac_collection_dtl.currency_rt%TYPE,     
        fcurrency_amt       giac_collection_dtl.fcurrency_amt%TYPE,   
        dcb_bank_cd         giac_collection_dtl.dcb_bank_cd%TYPE,     
        dcb_bank_acct_cd    giac_collection_dtl.dcb_bank_acct_cd%TYPE,
        bank_sname          giac_banks.bank_sname%TYPE,
        short_name          giis_currency.short_name%TYPE,
        gross_amt           giac_collection_dtl.gross_amt%TYPE,      
        commission_amt      giac_collection_dtl.commission_amt%TYPE, 
        vat_amt             giac_collection_dtl.vat_amt%TYPE,        
        fc_gross_amt        giac_collection_dtl.fc_gross_amt%TYPE,   
        fc_comm_amt         giac_collection_dtl.fc_comm_amt%TYPE,    
        fc_tax_amt          giac_collection_dtl.fc_tax_amt%TYPE
    );
    TYPE cncl_colln_breakdown_tab IS TABLE OF cncl_colln_breakdown_type;
    
    FUNCTION get_cncl_colln_breakdown(
        p_gacc_tran_id      VARCHAR2
    )
    RETURN cncl_colln_breakdown_tab PIPELINED;
    
    TYPE giac_or_rel_tab IS TABLE OF giac_or_rel%ROWTYPE;
    
    FUNCTION get_giac_or_rel(
        p_gacc_tran_id      VARCHAR2
    )
    RETURN giac_or_rel_tab PIPELINED;
    
    PROCEDURE save_giac_or_rel(
        p_tran_id           giac_or_rel.tran_id%TYPE,       
        p_new_or_tag        giac_or_rel.new_or_tag%TYPE,     
        p_old_tran_id       giac_or_rel.old_tran_id%TYPE,   
        p_old_or_date       giac_or_rel.old_or_date%TYPE,    
        p_old_or_pref_suf   giac_or_rel.old_or_pref_suf%TYPE,
        p_old_or_no         giac_or_rel.old_or_no%TYPE,      
        p_old_or_tag        giac_or_rel.old_or_tag%TYPE,     
        p_user_id           giac_or_rel.user_id%TYPE        
    );
    
END giac_order_of_payts_pkg;
/


