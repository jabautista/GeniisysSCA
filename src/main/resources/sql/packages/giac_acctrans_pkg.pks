CREATE OR REPLACE PACKAGE CPI.giac_acctrans_pkg
AS
   TYPE giac_acctrans_type IS RECORD (
      tran_id          giac_acctrans.tran_id%TYPE,
      gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      tran_date        giac_acctrans.tran_date%TYPE,
      tran_flag        giac_acctrans.tran_flag%TYPE,
      tran_class       giac_acctrans.tran_class%TYPE,
      tran_class_no    giac_acctrans.tran_class_no%TYPE,
      particulars      giac_acctrans.particulars%TYPE,
      tran_year        giac_acctrans.tran_year%TYPE,
      tran_month       giac_acctrans.tran_month%TYPE,
      tran_seq_no      giac_acctrans.tran_seq_no%TYPE
   );

   TYPE giac_acctrans_dtl_type IS RECORD (
      tran_id          giac_acctrans.tran_id%TYPE,
      gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      fund_desc        giis_funds.fund_desc%TYPE,
      gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      branch_name      giac_branches.branch_name%TYPE,
      tran_date        giac_acctrans.tran_date%TYPE,
      tran_flag        giac_acctrans.tran_flag%TYPE,
      mean_tran_flag   cg_ref_codes.rv_meaning%TYPE,
      tran_class       giac_acctrans.tran_class%TYPE,
      tran_class_no    giac_acctrans.tran_class_no%TYPE,
      particulars      giac_acctrans.particulars%TYPE,
      tran_year        giac_acctrans.tran_year%TYPE,
      tran_month       giac_acctrans.tran_month%TYPE,
      tran_seq_no      giac_acctrans.tran_seq_no%TYPE,
      dcb_flag         giac_colln_batch.dcb_flag%TYPE,
      mean_dcb_flag    cg_ref_codes.rv_meaning%TYPE,
	  dv_flag    	   giac_disb_vouchers.dv_flag%TYPE, --added by c.santos 06.05.2012
	  dcb_date         giac_colln_batch.tran_date%TYPE --Deo [09.01.2016]: SR-5631
   );

   TYPE dcb_list_type IS RECORD (
      count_            NUMBER, --SR#18447; John Dolon; 05.25.2015
      rownum_           NUMBER,
      tran_id           giac_acctrans.tran_id%TYPE,
      gibr_branch_cd    giac_acctrans.gibr_branch_cd%TYPE,
      gfun_fund_cd      giac_acctrans.gfun_fund_cd%TYPE,
      dsp_branch_name   giac_branches.branch_name%TYPE,
      tran_date         giac_acctrans.tran_date%TYPE,
      dcb_flag          VARCHAR2(1),
      dsp_dcb_flag      VARCHAR2(100),
      dcb_no            VARCHAR2 (20)
   );

   TYPE gicd_sum_list_type IS RECORD (
      pay_mode        giac_collection_dtl.pay_mode%TYPE,
      sum_amount      giac_collection_dtl.amount%TYPE,
      short_name      giis_currency.short_name%TYPE,
      currency_desc   giis_currency.currency_desc%TYPE,
      sum_fc_amount   giac_collection_dtl.fcurrency_amt%TYPE,
      currency_rt     giac_collection_dtl.currency_rt%TYPE
   );

   TYPE gbdsd_lov_type IS RECORD (
      gacc_tran_id       giac_order_of_payts.gacc_tran_id%TYPE,
      payor              giac_order_of_payts.payor%TYPE,
      or_no              giac_order_of_payts.or_no%TYPE,
      or_pref_suf        giac_order_of_payts.or_pref_suf%TYPE,
      dcb_no             giac_order_of_payts.dcb_no%TYPE,
      check_no           giac_collection_dtl.check_no%TYPE,
      item_no            giac_collection_dtl.item_no%TYPE,
      amount             giac_collection_dtl.amount%TYPE,
      fcurrency_amt      giac_collection_dtl.fcurrency_amt%TYPE,
      currency_rt        giac_collection_dtl.currency_rt%TYPE,
      bank_cd            giac_collection_dtl.bank_cd%TYPE,
      bank_sname         giac_banks.bank_sname%TYPE,
      short_name         giis_currency.short_name%TYPE,
      main_currency_cd   giis_currency.main_currency_cd%TYPE,
      dsp_check_no       VARCHAR2 (40),
      dsp_or_pref_suf    VARCHAR2 (20)
   );

   TYPE giac_acctrans_tab IS TABLE OF giac_acctrans_type;

   TYPE giac_acctrans_cur IS REF CURSOR
      RETURN giac_acctrans_type;

   TYPE dcb_list_tab IS TABLE OF dcb_list_type;

   TYPE giac_acctrans_dtl_tab IS TABLE OF giac_acctrans_dtl_type;

   TYPE gicd_sum_list_tab IS TABLE OF gicd_sum_list_type;

   TYPE gbdsd_lov_tab IS TABLE OF gbdsd_lov_type;

   PROCEDURE set_giac_acctrans_dtl (
      p_tran_id          giac_acctrans.tran_id%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_tran_date        giac_acctrans.tran_date%TYPE,
      p_tran_flag        giac_acctrans.tran_flag%TYPE,
      p_tran_class       giac_acctrans.tran_class%TYPE,
      p_tran_class_no    giac_acctrans.tran_class_no%TYPE,
      p_particulars      giac_acctrans.particulars%TYPE,
      p_tran_year        giac_acctrans.tran_year%TYPE,
      p_tran_month       giac_acctrans.tran_month%TYPE,
      p_tran_seq_no      giac_acctrans.tran_seq_no%TYPE
   );

   FUNCTION get_giac_acctrans (
      p_tran_id          giac_acctrans.tran_id%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE
   )
      RETURN giac_acctrans_tab PIPELINED;

   FUNCTION get_validation_params (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN giac_acctrans_tab PIPELINED;

   FUNCTION get_tran_flag (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN VARCHAR2;

   PROCEDURE upd_acc_giacs050 (
      p_tran_id     giac_acctrans.tran_id%TYPE,
      p_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd   giac_acctrans.gibr_branch_cd%TYPE
   );

   PROCEDURE del_acc_giacs050 (
      p_tran_id     giac_order_of_payts.gacc_tran_id%TYPE,
      p_fund_cd     giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE
   );
   
   FUNCTION get_dcb_list (
      p_branch_name   giac_branches.branch_name%TYPE,
      p_tran_date     VARCHAR2,
      p_dcb_no        VARCHAR2,
      p_dcb_flag      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN dcb_list_tab PIPELINED;

   FUNCTION get_giac_acctrans_dtl (p_gacc_tran_id giac_acctrans.tran_id%TYPE)
      RETURN giac_acctrans_dtl_tab PIPELINED;

   FUNCTION get_gicd_sum_list (
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_dcb_no           giac_acctrans.tran_class_no%TYPE,
      p_dcb_date         VARCHAR2
   )
      RETURN gicd_sum_list_tab PIPELINED;

   PROCEDURE create_records_in_acctrans (
      p_gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
      p_rev_tran_date             giac_acctrans.tran_date%TYPE,
      p_rev_tran_class_no         giac_acctrans.tran_class_no%TYPE,
      p_or_cancellation           VARCHAR2,
      p_or_date                   VARCHAR2,
      p_dcb_no                    giac_order_of_payts.dcb_no%TYPE,
      p_or_no                     giac_order_of_payts.or_no%TYPE,
      p_or_pref_suf               giac_order_of_payts.or_pref_suf%TYPE,
      p_acc_tran_id         OUT   giac_acctrans.tran_id%TYPE,
      p_calling_form              VARCHAR2,
      p_message             OUT   VARCHAR2
   );

   PROCEDURE get_dcb_flag (
      p_gfun_fund_cd     IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_dcb_year         IN       giac_acctrans.tran_year%TYPE,
      p_dcb_no           IN       NUMBER,
      p_dsp_dcb_flag     IN OUT   VARCHAR2,
      p_mean_dcb_flag    IN OUT   VARCHAR2
   );

   PROCEDURE validate_giacs035_dcb_no_1 (
      p_gfun_fund_cd              IN       giac_colln_batch.fund_cd%TYPE,
      p_gibr_branch_cd            IN       giac_colln_batch.branch_cd%TYPE,
      p_dcb_date                  IN       VARCHAR2,
      p_dcb_year                  IN       giac_colln_batch.dcb_year%TYPE,
      p_dcb_no                    IN       giac_colln_batch.dcb_no%TYPE,
      p_var_all_ors_r_cancelled   IN OUT   VARCHAR2,
      p_invalid_dcb_no            OUT      VARCHAR2
   );

   PROCEDURE validate_giacs035_dcb_no_2 (
      p_gfun_fund_cd              IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd            IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_dcb_date                  IN       VARCHAR2,
      p_dcb_year                  IN       giac_acctrans.tran_year%TYPE,
      p_dcb_no                    IN       NUMBER,
      p_dsp_dcb_flag              IN OUT   VARCHAR2,
      p_mean_dcb_flag             IN OUT   VARCHAR2,
      p_var_all_ors_r_cancelled   IN       VARCHAR2,
      p_one_unprinted_or          OUT      VARCHAR2,
      p_one_open_or               OUT      VARCHAR2,
      p_no_collection_amt         OUT      VARCHAR2,
      p_one_manual_or             OUT      VARCHAR2
   );

   FUNCTION check_bank_in_or (
      p_gfun_fund_cd     IN   giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   IN   giac_acctrans.gibr_branch_cd%TYPE,
      p_dcb_year         IN   giac_acctrans.tran_year%TYPE,
      p_dcb_no           IN   NUMBER
   )
      RETURN VARCHAR2;

   FUNCTION get_gdbd_amt_pre_text_val (
      p_dcb_date   VARCHAR2,
      p_dcb_no     NUMBER,
      p_pay_mode   giac_dcb_bank_dep.pay_mode%TYPE
   )
      RETURN giac_dcb_bank_dep.amount%TYPE;

   FUNCTION get_gdbd_amt_when_validate (
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_dcb_no           giac_acctrans.tran_class_no%TYPE,
      p_dcb_date         VARCHAR2,
      p_dcb_year         NUMBER,
      p_pay_mode         giac_dcb_bank_dep.pay_mode%TYPE,
      p_currency_cd      giac_dcb_bank_dep.currency_cd%TYPE,
      p_currency_rt      giac_dcb_bank_dep.currency_rt%TYPE
   )
      RETURN giac_dcb_bank_dep.amount%TYPE;

   FUNCTION get_curr_sname_gicd_sum_rec (
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_dcb_no           giac_acctrans.tran_class_no%TYPE,
      p_dcb_date         VARCHAR2,
      p_dcb_year         NUMBER,
      p_pay_mode         giac_dcb_bank_dep.pay_mode%TYPE,
      p_currency_cd      giac_dcb_bank_dep.currency_cd%TYPE,
      p_currency_rt      giac_dcb_bank_dep.currency_rt%TYPE
   )
      RETURN giac_dcb_bank_dep.amount%TYPE;

   PROCEDURE get_tot_fc_amt_gicd_sum_rec (
      p_gibr_branch_cd                IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_gfun_fund_cd                  IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_dcb_no                        IN       giac_acctrans.tran_class_no%TYPE,
      p_dcb_date                      IN       VARCHAR2,
      p_dcb_year                      IN       NUMBER,
      p_pay_mode                      IN       giac_dcb_bank_dep.pay_mode%TYPE,
      p_currency_cd                   IN       giac_dcb_bank_dep.currency_cd%TYPE,
      p_currency_rt                   IN       giac_dcb_bank_dep.currency_rt%TYPE,
      p_tot_amt_for_gicd_sum_rec      IN OUT   giac_dcb_bank_dep.amount%TYPE,
      p_tot_fc_amt_for_gicd_sum_rec   IN OUT   giac_dcb_bank_dep.amount%TYPE
   );

   FUNCTION get_giacs035_gbdsd_lov (
      p_dcb_no      giac_dcb_bank_dep.dcb_no%TYPE,
      p_dcb_date    VARCHAR2,
      p_branch_cd   giac_dcb_bank_dep.branch_cd%TYPE,
      p_pay_mode    giac_dcb_bank_dep.pay_mode%TYPE
   )
      RETURN gbdsd_lov_tab PIPELINED;

   PROCEDURE set_giac_acctrans (
      p_tran_id          giac_acctrans.tran_id%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_tran_date        giac_acctrans.tran_date%TYPE,
      p_tran_flag        giac_acctrans.tran_flag%TYPE,
      p_tran_class       giac_acctrans.tran_class%TYPE,
      p_tran_class_no    giac_acctrans.tran_class_no%TYPE,
      p_particulars      giac_acctrans.particulars%TYPE,
      p_tran_year        giac_acctrans.tran_year%TYPE,
      p_tran_month       giac_acctrans.tran_month%TYPE,
      p_tran_seq_no      giac_acctrans.tran_seq_no%TYPE,
      p_user_id          giac_acctrans.user_id%TYPE,
      p_last_update      giac_acctrans.last_update%TYPE
   );

   PROCEDURE del_giac_acctrans (p_tran_id giac_acctrans.tran_id%TYPE);

   PROCEDURE set_acctrans_dcb_closing (
      p_tran_id         IN OUT   giac_acctrans.tran_id%TYPE,
      p_fund_cd         IN OUT   giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd       IN OUT   giac_acctrans.gibr_branch_cd%TYPE,
      p_tran_year       IN OUT   giac_acctrans.tran_year%TYPE,
      p_tran_month      IN       giac_acctrans.tran_month%TYPE,
      p_tran_class_no   IN       giac_acctrans.tran_class_no%TYPE,
      p_particulars     IN       giac_acctrans.particulars%TYPE,
      p_tran_flag       IN OUT   giac_acctrans.tran_flag%TYPE,
      p_tran_class      IN       giac_acctrans.tran_class%TYPE,
      p_user_id         IN       giac_acctrans.user_id%TYPE,
      p_tran_date       IN OUT   VARCHAR2,
      p_mesg            OUT      VARCHAR2
   );

   TYPE giacs086_acct_trans_type IS RECORD (
      batch_dv_id   giac_batch_dv.batch_dv_id%TYPE,
      tran_id       giac_batch_dv.tran_id%TYPE,
      branch_cd     giac_acctrans.gibr_branch_cd%TYPE,
      ref_no        VARCHAR (100),
      particulars   giac_acctrans.particulars%TYPE
   );

   TYPE giacs086_acct_trans_tab IS TABLE OF giacs086_acct_trans_type;

   FUNCTION get_giacs086_acct_trans (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE,
      p_branch_cd     giac_acctrans.gibr_branch_cd%TYPE,
      p_ref_no        VARCHAR,
      p_particulars   giac_acctrans.particulars%TYPE
   )
      RETURN giacs086_acct_trans_tab PIPELINED;
      
   FUNCTION get_tran_flag2 (
      p_acct_tran_id    GIAC_ACCTRANS.tran_id%TYPE
   ) RETURN VARCHAR2;
   
   PROCEDURE update_tran_flag (
      p_tran_id    GIAC_ACCTRANS.tran_id%TYPE,
      p_tran_flag  GIAC_ACCTRANS.tran_flag%TYPE
   );
   
   PROCEDURE insert_into_acctrans_gicls055(
		p_fund_cd    IN  giac_acctrans.gfun_fund_cd%TYPE,
		p_branch_cd  IN  giac_acctrans.gibr_branch_cd%TYPE,
        p_user_id    IN  giis_users.user_id%TYPE,
		p_tran_id	 OUT giac_acctrans.tran_id%TYPE,
		p_message    OUT VARCHAR2);
        
   PROCEDURE insert_into_acctrans_giclb001(
      p_fund_cd    IN  giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd  IN  giac_acctrans.gibr_branch_cd%TYPE,
      p_dsp_date   IN  giac_acctrans.tran_date%TYPE,
      p_user_id    IN  giac_acctrans.user_id%TYPE,
      p_tran_id   OUT  giac_acctrans.tran_id%TYPE
    ); 
    
   FUNCTION get_tran_ids_for_printing (p_dsp_date     DATE)
   RETURN giac_acctrans_tab PIPELINED;
   
   PROCEDURE update_acctrans_giacs002(
        p_dv_date           giac_acctrans.tran_date%TYPE,
        p_dv_no             giac_acctrans.tran_class_no%TYPE,
        p_gacc_tran_id      giac_acctrans.tran_id%TYPE
   );
   
    TYPE gicls055_tran_dtl_type IS RECORD (
        tran_no VARCHAR2(20),
        tran_date giac_acctrans.tran_date%TYPE
    );

    TYPE gicls055_tran_dtl_tab IS TABLE OF gicls055_tran_dtl_type;
    
    FUNCTION get_gicls055_tran_dtl (
        p_acc_tran_id giac_acctrans.tran_id%TYPE
    ) RETURN gicls055_tran_dtl_tab PIPELINED;
    
    FUNCTION get_dcb_list2 ( --SR#18447; John Dolon; 05.25.2015
      p_branch_name   giac_branches.branch_name%TYPE,
      p_tran_date     VARCHAR2,
      p_dcb_no        VARCHAR2,
      p_dcb_flag      VARCHAR2,
      p_user_id       VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER
   )
      RETURN dcb_list_tab PIPELINED;

   FUNCTION check_dcb_flag (  --Deo [03.03.2017]: SR-5939
      p_fund_cd     giac_colln_batch.fund_cd%TYPE,
      p_branch_cd   giac_colln_batch.branch_cd%TYPE,
      p_tran_year   giac_colln_batch.dcb_year%TYPE,
      p_dcb_no      giac_colln_batch.dcb_no%TYPE,
      p_type        VARCHAR2
   )
      RETURN VARCHAR2;
   
END giac_acctrans_pkg;
/


DROP PUBLIC SYNONYM GIAC_ACCTRANS_PKG;

CREATE PUBLIC SYNONYM GIAC_ACCTRANS_PKG FOR CPI.GIAC_ACCTRANS_PKG;


