CREATE OR REPLACE PACKAGE CPI.giac_disb_vouchers_pkg
AS
/******************************************************************************
   NAME:       GIAC_DISB_VOUCHERS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/19/2012   Irwin Tabisora   1. Created this package.
   2.0        4/11/2013   Kris Felipe      2. Added types/functions/procedures for GIACS002
   2.1        5/23/2016   John Daniel      3. Modified validation when cancelling a DV (see package body) 
                          Marasigan
******************************************************************************/

   TYPE giac_disb_vouchers_type IS RECORD ( 
      gacc_tran_id        giac_disb_vouchers.gacc_tran_id%TYPE,
      gibr_gfun_fund_cd   giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd      giac_disb_vouchers.gibr_branch_cd%TYPE,
      gouc_ouc_id         giac_disb_vouchers.gouc_ouc_id%TYPE,
      gprq_ref_id         giac_disb_vouchers.gprq_ref_id%TYPE,
      req_dtl_no          giac_disb_vouchers.req_dtl_no%TYPE,
      particulars         giac_disb_vouchers.particulars%TYPE,
      dv_amt              giac_disb_vouchers.dv_amt%TYPE,
      dv_created_by       giac_disb_vouchers.dv_created_by%TYPE,
      dv_create_date      giac_disb_vouchers.dv_create_date%TYPE,
      dv_flag             giac_disb_vouchers.dv_flag%TYPE,
      payee               giac_disb_vouchers.payee%TYPE,
      currency_cd         giac_disb_vouchers.currency_cd%TYPE,
      dv_date             giac_disb_vouchers.dv_date%TYPE,
      dv_no               giac_disb_vouchers.dv_no%TYPE,
      dv_print_date       giac_disb_vouchers.dv_print_date%TYPE,
      dv_approved_by      giac_disb_vouchers.dv_approved_by%TYPE,
      dv_tag              giac_disb_vouchers.dv_tag%TYPE,
      dv_pref             giac_disb_vouchers.dv_pref%TYPE,
      print_tag           giac_disb_vouchers.print_tag%TYPE,
      dv_approve_date     giac_disb_vouchers.dv_approve_date%TYPE,
      ref_no              giac_disb_vouchers.ref_no%TYPE,
      cpi_rec_no          giac_disb_vouchers.cpi_rec_no%TYPE,
      cpi_branch_cd       giac_disb_vouchers.cpi_branch_cd%TYPE,
      user_id             giac_disb_vouchers.user_id%TYPE,
      last_update         giac_disb_vouchers.last_update%TYPE,
      payee_no            giac_disb_vouchers.payee_no%TYPE,
      payee_class_cd      giac_disb_vouchers.payee_class_cd%TYPE,
      dv_fcurrency_amt    giac_disb_vouchers.dv_fcurrency_amt%TYPE,
      currency_rt         giac_disb_vouchers.currency_rt%TYPE,
      replenished_tag     giac_disb_vouchers.replenished_tag%TYPE
   );

   TYPE giac_disb_vouchers_tab IS TABLE OF giac_disb_vouchers_type;

   TYPE giacs016_giac_disb_type IS RECORD (
      dv_pref            giac_disb_vouchers.dv_pref%TYPE,
      dv_no              giac_disb_vouchers.dv_no%TYPE,
      dv_print_date      giac_disb_vouchers.dv_print_date%TYPE,
      dv_approved_by     giac_disb_vouchers.dv_approved_by%TYPE,
      dv_flag            giac_disb_vouchers.dv_flag%TYPE,
      dsp_dv_flag_mean   VARCHAR2 (100),
      dv_created_by      giac_disb_vouchers.dv_created_by%TYPE,
      dv_create_date     giac_disb_vouchers.dv_create_date%TYPE,
      gacc_tran_id       giac_disb_vouchers.gacc_tran_id%TYPE,
      gprq_ref_id        giac_disb_vouchers.gprq_ref_id%TYPE
   );

   TYPE giacs016_giac_disb_tab IS TABLE OF giacs016_giac_disb_type;

   FUNCTION get_giacs016_giac_disb (
      p_gprq_ref_id   giac_disb_vouchers.gprq_ref_id%TYPE
   )
   RETURN giacs016_giac_disb_tab PIPELINED;
      
      
   -- added by Kris 04.11.2013 for GIACS002 - Generate Disbursement Voucher
   TYPE giac_disb_vouchers_type2 IS RECORD (
      gacc_tran_id        giac_disb_vouchers.gacc_tran_id%TYPE,
      gibr_gfun_fund_cd   giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd      giac_disb_vouchers.gibr_branch_cd%TYPE,
      gouc_ouc_id         giac_disb_vouchers.gouc_ouc_id%TYPE,
      gprq_ref_id         giac_disb_vouchers.gprq_ref_id%TYPE,
      req_dtl_no          giac_disb_vouchers.req_dtl_no%TYPE,
      particulars         giac_disb_vouchers.particulars%TYPE,
      dv_created_by       giac_disb_vouchers.dv_created_by%TYPE,
      dv_create_date      giac_disb_vouchers.dv_create_date%TYPE,
      dv_flag             giac_disb_vouchers.dv_flag%TYPE,
      payee               giac_disb_vouchers.payee%TYPE,
      dv_date             giac_disb_vouchers.dv_date%TYPE,
      dv_date_str_sp      VARCHAR2(50),
      dv_date_str         VARCHAR2(50),
      dv_no               giac_disb_vouchers.dv_no%TYPE,
      tran_no             VARCHAR2(50),
      dv_print_date       giac_disb_vouchers.dv_print_date%TYPE,
      dv_approved_by      giac_disb_vouchers.dv_approved_by%TYPE,
      dv_tag              giac_disb_vouchers.dv_tag%TYPE,
      dv_pref             giac_disb_vouchers.dv_pref%TYPE,
      print_tag           giac_disb_vouchers.print_tag%TYPE,
      dv_approve_date     giac_disb_vouchers.dv_approve_date%TYPE,
      ref_no              giac_disb_vouchers.ref_no%TYPE,
      cpi_rec_no          giac_disb_vouchers.cpi_rec_no%TYPE,
      cpi_branch_cd       giac_disb_vouchers.cpi_branch_cd%TYPE,
      user_id             giac_disb_vouchers.user_id%TYPE,
      last_update         giac_disb_vouchers.last_update%TYPE,
      payee_no            giac_disb_vouchers.payee_no%TYPE,
      payee_class_cd      giac_disb_vouchers.payee_class_cd%TYPE,
      replenished_tag     giac_disb_vouchers.replenished_tag%TYPE,
      
      dv_amt              giac_disb_vouchers.dv_amt%TYPE,           -- local amount
      
      currency_cd         giac_disb_vouchers.currency_cd%TYPE,      -- foreign currency code
      dv_fcurrency_amt    giac_disb_vouchers.dv_fcurrency_amt%TYPE, -- foreign amount
      currency_rt         giac_disb_vouchers.currency_rt%TYPE,      -- foreign currency rate
      
      dv_flag_mean        cg_ref_codes.rv_meaning%TYPE, 
      foreign_currency    giis_currency.short_name%TYPE,            -- foreign currency shortname
      local_currency      giac_parameters.param_value_v%TYPE,       -- local currency shortname
      payee_class_desc    giis_payee_class.class_desc%TYPE,
      fund_desc           giis_funds.fund_desc%TYPE,
      branch_name         giac_branches.branch_name%TYPE,
      
      dsp_print_date      VARCHAR2(100),
      dsp_print_time      VARCHAR2(100),
      
      gprq_document_cd    giac_payt_requests.document_cd%TYPE,      -- dsp replaced with gprq
      gprq_branch_cd      giac_payt_requests.branch_cd%TYPE,
      gprq_line_cd        giac_payt_requests.line_cd%TYPE,
      gprq_doc_year       giac_payt_requests.doc_year%TYPE,
      gprq_doc_mm         giac_payt_requests.doc_mm%TYPE,
      gprq_doc_seq_no     giac_payt_requests.doc_seq_no%TYPE,
      
      nbt_line_cd_tag     giac_payt_req_docs.line_cd_tag%TYPE,
      nbt_yy_tag          giac_payt_req_docs.yy_tag%TYPE,
      nbt_mm_tag          giac_payt_req_docs.mm_tag%TYPE,
      
      print_tag_mean      cg_ref_codes.rv_meaning%TYPE,
      --
      check_dv_print      giac_parameters.param_value_v%TYPE,
      allow_multi_check   giac_parameters.param_value_v%TYPE,
      dv_approval         giac_parameters.param_value_v%TYPE,
      update_payee_name   giac_parameters.param_value_v%TYPE,
--      dv_approval         VARCHAR2(5),  -- //when-new-form-instance: CG$CTRL.dv_approval
      clm_doc_cd          giac_parameters.param_value_v%TYPE,       -- CLM_PAYT_REQ_DOC
      ri_doc_cd           giac_parameters.param_value_v%TYPE,       -- FACUL_RI_PREM_PAYT_DOC
      comm_doc_cd         giac_parameters.param_value_v%TYPE,       -- COMM_PAYT_DOC
      bcsr_doc_cd         giac_parameters.param_value_v%TYPE,       -- BATCH_CSR_DOC
      approve_dv_tag      NUMBER(1),                                -- if == 1 - enables approve_dv button
      grp_iss_cd          giac_branches.branch_name%TYPE,           -- use this GLOBAL.p_branch_cd if workflow_event_desc is NOT NULL (pre-from)  
      
      ouc_cd              giac_oucs.ouc_cd%TYPE,
      ouc_name            giac_oucs.ouc_name%TYPE,
--      ouc_id              giac_oucs.ouc_id%TYPE,                    -- GIDV.GOUC_OUC_ID
      fund_cd2            giac_oucs.gibr_gfun_fund_cd%TYPE,         -- GIDV.DSP_GIBR_GFUN_FUND_CD2
      branch_cd2          giac_oucs.gibr_branch_cd%TYPE,            -- GIDV.DSP_GIBR_BRANCH_CD2
      
      --Vincent 053105: variables used in proc generate_dv_no and post-insert trigger of block GIDV
      seq_fund_cd         giis_funds.fund_cd%TYPE,
      seq_branch_cd       giac_branches.branch_cd%TYPE,
      
      str_last_update     VARCHAR2(100),
      str_create_date     VARCHAR2(100),
      str_approve_date    VARCHAR2(100),      
      str_print_date      VARCHAR2(100),
      str_print_time      VARCHAR2(100),
      payt_req_no         VARCHAR2(100), --added by robert SR 5190 12.02.15
      check_user_tag      NUMBER(1),                             --check_user_per_iss_cd_acctg
      allow_tran_tag      giac_parameters.param_value_v%TYPE     --ALLOW_TRAN_FOR_CLOSED_MONTH
   );

   TYPE giac_disb_vouchers_tab2 IS TABLE OF giac_disb_vouchers_type2;
   
   FUNCTION get_disb_vouchers_list(
       p_fund_cd               GIAC_DISB_VOUCHERS.GIBR_GFUN_FUND_CD%TYPE,
       p_branch_cd             GIAC_DISB_VOUCHERS.GIBR_BRANCH_CD%TYPE,
       p_user_id               giis_users.user_id%TYPE,
       p_dv_flag               GIAC_DISB_VOUCHERS.DV_FLAG%TYPE      -- shan 11.04.2014
   ) RETURN giac_disb_vouchers_tab2 PIPELINED;
    
   FUNCTION get_disb_voucher_info(
        p_gacc_tran_id      giac_disb_vouchers.gacc_tran_id%TYPE,
        p_item_no           giac_chk_disbursement.item_no%TYPE,
        p_user_id           giac_disb_vouchers.user_id%TYPE
   ) RETURN giac_disb_vouchers_tab2 PIPELINED;
   
   FUNCTION get_default_disb_info(
        p_fund_cd               GIAC_DISB_VOUCHERS.GIBR_GFUN_FUND_CD%TYPE,
        p_branch_cd             GIAC_DISB_VOUCHERS.GIBR_BRANCH_CD%TYPE,
        p_user_id               giis_users.user_id%TYPE
--        p_user_id               giis_users.user_id%TYPE,
--        p_workflow_event_desc   VARCHAR2(2000);
   ) RETURN giac_disb_vouchers_tab2 PIPELINED;
   
   PROCEDURE chk_gacc_gacc_gibr_fk(
        p_fund_cd       IN OUT     giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd     IN OUT     giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_fund_desc     OUT        giis_funds.fund_desc%TYPE,
        p_branch_name   OUT        giac_branches.branch_name%TYPE
   );
   
   FUNCTION get_print_tag_mean(
        p_print_tag     IN      cg_ref_codes.rv_low_value%TYPE
   ) RETURN VARCHAR2;
   
--   PROCEDURE get_payt_req_numbering_scheme(  /* moved to GIAC_PAYT_REQ_DOCS_PKG */
--        p_fund_cd           IN OUT     giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
--        p_branch_cd         IN OUT     giac_disb_vouchers.gibr_branch_cd%TYPE,
--        p_document_cd       IN OUT     giac_payt_requests.document_cd%TYPE,
--        p_nbt_line_cd_tag   OUT        giac_payt_req_docs.line_cd_tag%TYPE,
--        p_nbt_yy_tag        OUT        giac_payt_req_docs.yy_tag%TYPE,
--        p_nbt_mm_tag        OUT        giac_payt_req_docs.mm_tag%TYPE
--   );

   PROCEDURE LKP_GIDV_GIDV_GOUC_FK(
        p_ouc_cd            IN        giac_oucs.ouc_cd%TYPE,
        p_ouc_name          IN        giac_oucs.ouc_name%TYPE,
        p_ouc_id            OUT       giac_oucs.ouc_id%TYPE--,
        --p_fund_cd           OUT       giac_oucs.gibr_gfun_fund_cd%TYPE,
        --p_branch_cd         OUT       giac_oucs.gibr_branch_cd%TYPE
   );
   
   PROCEDURE generate_dv_no(
        p_fund_cd       IN      giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd     IN      giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_doc_name      IN      giac_doc_sequence.doc_name%TYPE,
        p_seq_fund_cd   OUT     giis_funds.fund_cd%TYPE,
        p_seq_branch_cd OUT     giac_branches.branch_cd%TYPE,
        p_dv_pref       OUT     giac_doc_sequence.doc_pref_suf%TYPE,
        p_dv_no         OUT     GIAC_DOC_SEQUENCE.DOC_SEQ_NO%TYPE,
        p_message       OUT     VARCHAR2
   );-- RETURN NUMBER;
   
   PROCEDURE validate_dv_no (
        p_dv_no             IN OUT        giac_disb_vouchers.dv_no%TYPE,
        p_dv_pref           IN OUT        giac_disb_vouchers.dv_pref%TYPE,
        p_fund_cd           IN OUT        giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd         IN OUT        giac_disb_vouchers.gibr_branch_cd%TYPE
   );
   
   PROCEDURE val_acc_entr_bef_approving(
        p_gacc_tran_id              giac_acct_entries.gacc_tran_id%TYPE,
        p_total_amt         OUT     giac_disb_vouchers.dv_amt%TYPE
   );
   
  /* PROCEDURE approve_validated_dv(
        p_user_id       giac_disb_vouchers.user_id%TYPE,
        p_gacc_tran_id  giac_disb_vouchers.gacc_tran_id%TYPE,
        p_dv_flag       giac_disb_vouchers.dv_flag%TYPE
   );*/
   PROCEDURE approve_validated_dv(
        p_user_id                   IN      giac_disb_vouchers.user_id%TYPE,
        p_gacc_tran_id              IN      giac_disb_vouchers.gacc_tran_id%TYPE,
        p_dv_flag                   IN OUT  giac_disb_vouchers.dv_flag%TYPE,
        p_dv_flag_mean              OUT     VARCHAR2,
        p_dv_approved_by            OUT     giac_disb_vouchers.dv_approved_by%TYPE,
        p_dv_approve_date           OUT     giac_disb_vouchers.dv_approve_date%TYPE,
        p_dv_approve_date_str       OUT     VARCHAR2
   );
   
    PROCEDURE validate_insert(
       p_fund_cd            IN OUT  GIAC_DISB_VOUCHERS.gibr_gfun_fund_cd%TYPE,
       p_branch_cd          IN OUT  GIAC_DISB_VOUCHERS.gibr_branch_cd%TYPE,
       p_gacc_tran_id       IN OUT  GIAC_DISB_VOUCHERS.gacc_tran_id%TYPE,
       p_ouc_cd             IN OUT  GIAC_OUCS.ouc_cd%TYPE,
       p_ouc_name           IN OUT  GIAC_OUCS.ouc_name%TYPE,
       p_ouc_id             IN OUT  GIAC_OUCS.ouc_id%TYPE,
       p_global_dv_tag      IN      GIAC_DISB_VOUCHERS.dv_tag%TYPE,
       p_print_date         IN OUT  GIAC_DISB_VOUCHERS.dv_print_date%TYPE,
       --p_dsp_print_time     IN OUT  GIAC_DISB_VOUCHERS.dv_print_date%TYPE,
       p_check_dv_print     IN      giac_parameters.param_value_v%TYPE,
       p_calling_form       IN      VARCHAR2,
       -- p_print_date         OUT     GIAC_DISB_VOUCHERS.dv_print_date%TYPE,
       p_str_print_date     OUT     VARCHAR2, --GIAC_DISB_VOUCHERS.dv_print_date%TYPE,
       p_dv_tag             OUT     GIAC_DISB_VOUCHERS.dv_tag%TYPE,
       p_seq_fund_cd        OUT     GIAC_PARAMETERS.param_value_v%TYPE,
       p_seq_branch_cd      OUT     GIAC_PARAMETERS.param_value_v%TYPE,
       p_dv_pref            OUT     giac_doc_sequence.doc_pref_suf%TYPE,
       p_dv_no              IN OUT     GIAC_DISB_VOUCHERS.dv_no%TYPE,
       p_message            OUT     VARCHAR2
   );
   
   PROCEDURE set_disb_voucher(p_voucher       IN  OUT      giac_disb_vouchers%ROWTYPE);
   
   PROCEDURE post_insert(
        p_fund_cd           IN          giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd         IN          giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_gacc_tran_id      IN          giac_disb_vouchers.gacc_tran_id%TYPE,
        p_dv_no             IN          giac_disb_vouchers.dv_no%TYPE,
        p_dv_pref           IN          giac_disb_vouchers.dv_pref%TYPE,
        p_dv_date           IN          giac_disb_vouchers.dv_date%TYPE,
        p_print_tag         IN          giac_disb_vouchers.print_tag%TYPE,
        p_ref_id            IN          giac_disb_vouchers.gprq_ref_id%TYPE,
        p_document_cd       IN          giac_payt_requests.document_cd%TYPE,
        p_line_cd           IN          giac_payt_requests.line_cd%TYPE,
        p_doc_year          IN          giac_payt_requests.doc_year%TYPE,
        p_doc_mm            IN          giac_payt_requests.doc_mm%TYPE,
        p_doc_seq_no        IN          giac_payt_requests.doc_seq_no%TYPE,
        p_message           OUT         VARCHAR2,
        p_workflow_msgr     OUT         VARCHAR2
   );
   
   PROCEDURE update_giac_doc_sequence(
        p_fund_cd    giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,  
        p_branch_cd  giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_doc_name   giac_doc_sequence.doc_name%TYPE,
        p_dv_pref    giac_doc_sequence.doc_pref_suf%TYPE,
        p_dv_no      giac_doc_sequence.doc_seq_no%TYPE
   );
      
   /*    
   **    -- ACCOUNTING ENTRIES GENERATION PROCEDURES/FUNCTIONS --
   **
   */    
   PROCEDURE aeg_parameters_002(
        p_aeg_tran_id           GIAC_ACCTRANS.tran_id%TYPE,
        p_aeg_module_nm         GIAC_MODULES.module_name%TYPE,
        p_fund_cd               GIAC_ACCT_ENTRIES.GACC_GFUN_FUND_CD%TYPE,
        p_branch_cd             GIAC_ACCT_ENTRIES.GACC_GIBR_BRANCH_CD%TYPE
   );
    
   PROCEDURE aeg_create_acct_entries_002(
        p_aeg_bank_cd           giac_chk_disbursement.bank_cd%TYPE,
        p_aeg_bank_acct_cd      giac_chk_disbursement.bank_acct_cd%TYPE,
        p_aeg_amount            giac_chk_disbursement.amount%TYPE,
        p_aeg_gen_type          giac_acct_entries.generation_type%TYPE,
        p_gacc_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
        p_gacc_fund_cd          giac_acctrans.gfun_fund_cd%TYPE,
        p_gacc_tran_id          giac_acctrans.tran_id%TYPE
   );
    
   PROCEDURE check_chart_of_accts_002(
        cca_gl_acct_id       IN     GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
        cca_gl_acct_category IN OUT GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
        cca_gl_control_acct  IN OUT GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
        cca_gl_sub_acct_1    IN OUT giac_acct_entries.gl_sub_acct_1%TYPE,
        cca_gl_sub_acct_2    IN OUT GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        cca_gl_sub_acct_3    IN OUT giac_acct_entries.gl_sub_acct_3%TYPE,
        cca_gl_sub_acct_4    IN OUT GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        cca_gl_sub_acct_5    IN OUT GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        cca_gl_sub_acct_6    IN OUT GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        cca_gl_sub_acct_7    IN OUT GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
   );
   
   FUNCTION get_generation_type(p_module_name    giac_modules.module_name%TYPE)  
    RETURN VARCHAR ;
   
   FUNCTION is_ofppr(
        p_tran_id           giac_acctrans.tran_id%TYPE
   ) RETURN VARCHAR2;
  
   PROCEDURE verify_ofppr_trans (
        p_gacc_tran_id      IN      giac_disb_vouchers.gacc_tran_id%TYPE,
        p_memo_type         OUT     giac_cm_dm.memo_type%TYPE,
        p_memo_year         OUT     giac_cm_dm.memo_year%TYPE,
        p_memo_seq_no       OUT     giac_cm_dm.memo_seq_no%TYPE,
        p_exists            OUT     giac_cm_dm.dv_tran_id%TYPE
  ); 
    
  PROCEDURE check_collection_dtl(
        p_tran_id       IN      giac_cm_dm.dv_tran_id%TYPE,
        p_memo_type     OUT     giac_cm_dm.memo_type%TYPE,
        p_memo_year     OUT     giac_cm_dm.memo_year%TYPE,
        p_memo_seq_no   OUT     giac_cm_dm.memo_seq_no%TYPE,
        p_or_found      OUT     VARCHAR2,
        p_message       OUT     VARCHAR2
  );
  
  PROCEDURE pre_cancel_dv(
        p_tran_id       IN     giac_cm_dm.dv_tran_id%TYPE,
        p_memo_type     IN     giac_cm_dm.memo_type%TYPE,
        p_memo_year     IN     giac_cm_dm.memo_year%TYPE,
        p_memo_seq_no   IN     giac_cm_dm.memo_seq_no%TYPE
  );
  
  PROCEDURE cancel_dv(
        p_fund_cd       IN     giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd     IN     giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_dv_date       IN     giac_disb_vouchers.dv_date%TYPE,
        p_dv_flag       IN     giac_disb_vouchers.dv_flag%TYPE,
        p_dv_pref       IN     giac_disb_vouchers.dv_pref%TYPE,
        p_dv_no         IN     giac_disb_vouchers.dv_no%TYPE,
        p_tran_id       IN     giac_cm_dm.dv_tran_id%TYPE,
        p_dv_status     OUT    giac_disb_vouchers.dv_flag%TYPE,
        p_dv_status_mean    OUT VARCHAR2,
        p_last_update       OUT DATE,
        p_last_update_str   OUT VARCHAR2
       /* p_memo_type     IN     giac_cm_dm.memo_type%TYPE,
        p_memo_year     IN     giac_cm_dm.memo_year%TYPE,
        p_memo_seq_no   IN     giac_cm_dm.memo_seq_no%TYPE*/
  );
  
  PROCEDURE cancel_dv1(
         p_fund_cd                  IN      giac_acctrans.gfun_fund_cd%TYPE,
         p_branch_cd                IN      giac_acctrans.gibr_branch_cd%TYPE,
         p_dv_pref                  IN      giac_disb_vouchers.dv_pref%TYPE,
         p_dv_no                    IN      giac_disb_vouchers.dv_no%TYPE,
         p_tran_id                  IN      giac_disb_vouchers.gacc_tran_id%TYPE
         --v_variables_rev_tran_id    OUT     giac_acctrans.tran_id%TYPE
  );
  
  PROCEDURE cancel_dv2(
         p_tran_id                  IN      giac_disb_vouchers.gacc_tran_id%TYPE      
  );
  
  PROCEDURE insert_acctrans_cap_002 (
        p_fund_cd           GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,    -- vfund_cd
        p_branch_cd         GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,       -- vbranch_cd
        p_rev_tran_date     GIAC_ACCTRANS.tran_date%TYPE,
        p_tran_class		giac_acctrans.tran_class%TYPE,
        p_dv_pref           giac_disb_vouchers.dv_pref%TYPE,
        p_dv_no             giac_disb_vouchers.dv_no%TYPE,
        p_variable_tran_id  OUT     giac_acctrans.tran_id%TYPE
  );
  
  PROCEDURE AEG_Parameters_Rev_002(
        p_aeg_tran_id      GIAC_ACCTRANS.tran_id%TYPE,
        p_aeg_module_nm    GIAC_MODULES.module_name%TYPE,
        p_fund_cd          giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd        giac_disb_vouchers.gibr_branch_cd%TYPE
  );
  
  PROCEDURE create_rev_entries_002(
        p_assd_no     IN GIPI_POLBASIC.assd_no%TYPE,
        p_coll_amt    IN GIAC_COMM_PAYTS.comm_amt%TYPE,
        p_line_cd     IN giis_line.line_cd%TYPE,
        p_module_name IN giac_modules.module_name%TYPE,
        p_fund_cd     IN giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,   
        p_branch_cd   IN giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_tran_id     IN giac_disb_vouchers.gacc_tran_id%TYPE
  );  
  
  PROCEDURE val_acc_entr_bef_printing(
        p_gacc_tran_id          giac_disb_vouchers.gacc_tran_id%TYPE
  );
  
  PROCEDURE delete_wf_records(
        p_gacc_tran_id          giac_disb_vouchers.gacc_tran_id%TYPE
  );
  
  FUNCTION get_default_branch(p_user_id         giis_users.user_id%TYPE) RETURN VARCHAR2;
  
  TYPE fund_cd_type IS RECORD (
    fund_cd     GIIS_FUNDS.FUND_CD%TYPE,
    fund_desc   GIIS_FUNDS.fund_desc%TYPE
  );
  
  TYPE fund_cd_tab IS TABLE OF fund_cd_type;
  
  FUNCTION get_def_fund_lov 
        RETURN fund_Cd_tab PIPELINED;
  
   -- end 04.11.2013 for GIACS002      
END giac_disb_vouchers_pkg;
/