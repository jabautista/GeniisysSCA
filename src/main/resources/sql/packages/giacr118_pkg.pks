CREATE OR REPLACE PACKAGE CPI.giacr118_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company          giis_parameters.param_value_v%TYPE,
      cf_com_address      giis_parameters.param_value_v%TYPE,
      cf_top_date         VARCHAR2 (70),
      company_tin         giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      gen_version			  giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      post_tran           VARCHAR2 (200),
      top_date            VARCHAR2 (70),
      gibr_gfun_fund_cd   giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd      giac_disb_vouchers.gibr_branch_cd%TYPE,
      branch_name         giac_branches.branch_name%TYPE,
      ref_no              giac_disb_vouchers.ref_no%TYPE,
      posting_date        giac_acctrans.posting_date%TYPE,
      dv_no               VARCHAR2 (16),--(14),  --Deo [03.13.2017]: increase (SR-23914)
      gacc_tran_id        VARCHAR2 (12),
      dv_check_order      NUMBER (10),
      dv_check_order2     VARCHAR2 (50),
      check_no            VARCHAR2 (4000),--(16),  --Deo [03.13.2017]: increase (SR-23914)
      chk_date            VARCHAR2 (4000),--(10),  --Deo [03.13.2017]: increase (SR-23914)
      chk_amt             VARCHAR2 (4000),--giac_chk_disbursement.amount%TYPE,  --Deo [03.13.2017]: change type (SR-23914)
      particulars         giac_disb_vouchers.particulars%TYPE,
      payee               VARCHAR2 (500),
      tin                 giis_payees.tin%TYPE,
      dv_amt              NUMBER (38, 2),
      cancelled           VARCHAR (20),
      dv_flag             giac_disb_vouchers.dv_flag%TYPE,
      tran_flag           giac_acctrans.tran_flag%TYPE,
      gl_control_acct     giac_acct_entries.gl_control_acct%TYPE,
      gl_account          VARCHAR2 (368),
      gl_account_name     VARCHAR2 (100),
      sl_cd               giac_acct_entries.sl_cd%TYPE,
      debit_amt           NUMBER (38, 2),
      credit_amt          NUMBER (38, 2)
   );

   TYPE get_details_tab IS TABLE OF get_details_type;
/*Added by pjsantos 11/14/2016, for optimization GENQA 5765*/
 TYPE get_gl_rec IS RECORD (     
      gl_account          VARCHAR2 (368),
      gl_account_name     VARCHAR2 (100),
      sl_cd               giac_acct_entries.sl_cd%TYPE,
      debit_amt           NUMBER (38, 2),
      credit_amt          NUMBER (38, 2)
   );

   TYPE get_gl_tab IS TABLE OF get_gl_rec;
 --pjsantos end  
   TYPE get_gl_summary_type IS RECORD (
      cf_company               VARCHAR2 (50),
      cf_com_address           VARCHAR2 (200),
      cf_top_date              VARCHAR2 (70),
      post_tran                VARCHAR2 (200),
      top_date                 VARCHAR2 (70),
      acct_gibr_gfun_fund_cd   giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
      acct_gibr_branch_cd      giac_disb_vouchers.gibr_branch_cd%TYPE,
      acct_branch_name         giac_branches.branch_name%TYPE,
      bal_amt                  NUMBER (38, 2),
      acct_name                VARCHAR2 (100),
      db_amt                   NUMBER (38, 2),
      cd_amt                   NUMBER (38, 2),
      gl_acct_no               VARCHAR2 (72)
   );

   TYPE get_gl_summary_tab IS TABLE OF get_gl_summary_type;

   FUNCTION get_details (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_dv_check           VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_user_id            VARCHAR2  
   )
      RETURN get_details_tab PIPELINED;
/*Modified by pjsantos 11/14/2016,for optimization GENQA 5765*/
   FUNCTION get_gl (P_GACC_TRAN_ID VARCHAR2
      /*p_post_tran_toggle    VARCHAR2,
      p_dv_check_toggle     VARCHAR2,
      p_date                VARCHAR2,
      p_date2               VARCHAR2,
      p_dv_check            VARCHAR2,
      p_branch              VARCHAR2,
      p_module_id           VARCHAR2,
      p_gibr_gfun_fund_cd   VARCHAR2,
      p_gibr_branch_cd      VARCHAR2,
      p_dv_no               VARCHAR2,
      p_check_no            VARCHAR2,
      p_user_id             VARCHAR2*/
   )
      RETURN get_gl_tab PIPELINED;

   FUNCTION get_gl_summary (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_branch_chk         VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN get_gl_summary_tab PIPELINED;

   FUNCTION get_gl_all_branches (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_branch_chk         VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN get_gl_summary_tab PIPELINED;
END;
/


