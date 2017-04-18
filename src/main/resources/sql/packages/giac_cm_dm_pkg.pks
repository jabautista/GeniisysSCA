CREATE OR REPLACE PACKAGE CPI.GIAC_CM_DM_PKG 
AS
    -- added by Kris 03.20.2013 for GIACS071
    TYPE giac_cm_dm_type IS RECORD (
        gacc_tran_id    giac_cm_dm.gacc_tran_id%TYPE,
        fund_cd         giac_cm_dm.fund_cd%TYPE,
        branch_cd       giac_cm_dm.branch_cd%TYPE,
        memo_type       giac_cm_dm.memo_type%TYPE,
        memo_date       giac_cm_dm.memo_date%TYPE,
        memo_year       giac_cm_dm.memo_year%TYPE,
        memo_seq_no     giac_cm_dm.memo_seq_no%TYPE,
        recipient       giac_cm_dm.recipient%TYPE, 
        amount          giac_cm_dm.amount%TYPE,     --foreign_amount
        currency_cd     giac_cm_dm.currency_cd%TYPE,
        currency_rt     giac_cm_dm.currency_rt%TYPE,    
        local_amt       giac_cm_dm.local_amt%TYPE,  --local_amount
        particulars     giac_cm_dm.particulars%TYPE,    
        memo_status     giac_cm_dm.memo_status%TYPE,
        user_id         giac_cm_dm.user_id%TYPE,
        last_update     giac_cm_dm.last_update%TYPE,
        last_update_str VARCHAR2(100),
        dv_no           VARCHAR2(100), --Added by Jerome Bautista 11.16.2015 SR 3467
        ri_comm_vat		giac_cm_dm.ri_comm_vat%TYPE, -- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
        ri_comm_amt		giac_cm_dm.ri_comm_amt%TYPE, -- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
        
        memo_number     VARCHAR2(20),
        mean_memo_type  VARCHAR2(100),
        mean_memo_status    VARCHAR2(100),
        foreign_curr_sname  giis_currency.short_name%TYPE,
        local_curr_sname    giis_currency.short_name%TYPE,
        local_curr_rt       giis_currency.currency_rt%TYPE,
        local_curr_cd   giis_currency.main_currency_cd%TYPE,
        branch_name     giac_branches.branch_name%TYPE,
        fund_desc       giis_funds.fund_desc%TYPE,
        grac_rac_cd     giis_funds.grac_rac_cd%TYPE,
        dsp_memo_date   giac_cm_dm.memo_date%TYPE,
        cancel_flag             VARCHAR2(1),-- param from controller
        check_applied_cm_tag    NUMBER(1),  -- check_applied_cm
        check_user_tag          NUMBER(1),  --check_user_per_iss_cd_acctg
        
        closed_tag              giac_tran_mm.closed_tag%TYPE,
        tran_flag               giac_acctrans.tran_flag%TYPE,
        allow_tran_tag          giac_parameters.param_value_v%TYPE,   --ALLOW_TRAN_FOR_CLOSED_MONTH
        allow_print_tag         giac_parameters.param_value_v%TYPE,   --ALLOW_PRINT_FOR_OPEN_CMDM
        allow_cancel_tag        giac_parameters.param_value_v%TYPE    --ALLOW_CANCEL_TRAN_FOR_CLOSED_MONTH
    );
    
    TYPE giac_cm_dm_tab IS TABLE OF giac_cm_dm_type;
    
    TYPE recipient_type IS RECORD (
        recipient_name      giac_cm_dm.recipient%TYPE,
        recipient_type      VARCHAR2(20)
    );
    
    TYPE recipient_tab IS TABLE OF recipient_type;
    
    PROCEDURE set_cm_dm_info(
        p_memo  IN OUT      giac_cm_dm%ROWTYPE
    ); 
    
    PROCEDURE insert_memo_into_acctrans(
        p_gacc_tran_id      IN OUT  GIAC_CM_DM.GACC_TRAN_ID%TYPE,
        p_fund_cd           IN   giac_cm_dm.fund_cd%TYPE,
        p_branch_cd         IN   giac_cm_dm.branch_cd%TYPE,
        p_memo_type         IN   giac_cm_dm.memo_type%TYPE,
        p_memo_year         IN   giac_cm_dm.memo_year%TYPE,
        p_memo_date         IN   giac_cm_dm.memo_date%TYPE,
        p_particulars       IN   giac_cm_dm.particulars%TYPE,
        p_user_id           IN OUT  giac_cm_dm.user_id%TYPE,
        p_last_update       IN OUT  giac_cm_dm.last_update%TYPE,
        p_memo_seq_no       IN OUT  giac_cm_dm.memo_seq_no%TYPE,
        p_last_update_str   IN OUT  VARCHAR2 
    ); 
   
    FUNCTION get_memo_seq_no(p_gacc_tran_id    giac_cm_dm.gacc_tran_id%TYPE ) RETURN NUMBER;
    
    
--    FUNCTION get_memo_info(
--        p_branch_cd            IN  giac_cm_dm.branch_cd%TYPE,
--        p_fund_cd              IN  giac_cm_dm.fund_cd%TYPE,
--        p_gacc_tran_id         IN  giac_cm_dm.gacc_tran_id%TYPE,
--        p_module               IN  giac_modules.module_name%TYPE,
--        p_user_id              IN  giac_cm_dm.user_id%TYPE
--    ) RETURN giac_cm_dm_tab PIPELINED;
    
    FUNCTION get_memo_list(
        p_branch_cd            IN  giac_cm_dm.branch_cd%TYPE,
        p_fund_cd              IN  giac_cm_dm.fund_cd%TYPE,
        p_gacc_tran_id         IN  giac_cm_dm.gacc_tran_id%TYPE,
        p_module               IN  giac_modules.module_name%TYPE,
        p_tran_status          IN  giac_acctrans.tran_flag%TYPE, --Added by Jerome Bautista 11.16.2015 SR 3467
        p_user_id              IN  giac_cm_dm.user_id%TYPE
    ) RETURN giac_cm_dm_tab PIPELINED;
    
    FUNCTION get_default_memo_info RETURN giac_cm_dm_tab PIPELINED;
    
    FUNCTION get_recipient_list RETURN recipient_tab PIPELINED;

    PROCEDURE cancel_cm_dm(
        p_gacc_tran_id      giac_cm_dm.gacc_tran_id%TYPE,
        p_fund_cd           giac_cm_dm.fund_cd%TYPE,
        p_branch_cd         giac_cm_dm.branch_cd%TYPE,
        p_memo_type         giac_cm_dm.memo_type%TYPE,
        p_memo_year         giac_cm_dm.memo_year%TYPE,
        p_memo_seq_no       giac_cm_dm.memo_seq_no%TYPE,
        p_memo_date         giac_cm_dm.memo_date%TYPE,
        p_user_id           giac_cm_dm.user_id%TYPE,
        p_tran_flag         giac_acctrans.tran_flag%TYPE,
        p_message           OUT VARCHAR2
    );
    
    FUNCTION validate_curr_sname(
        p_curr_sname        giis_currency.short_name%TYPE
    ) RETURN VARCHAR2;
    
--    PROCEDURE cgdv$chk_char_ref_codes(
--        p_value		IN OUT VARCHAR2      /* Value to be validated  */
--        , p_meaning	IN OUT VARCHAR2      /* Domain meaning         */
--        , p_domain	IN     VARCHAR2      /* Reference codes domain */
--    ) ;
    
    PROCEDURE CGFK$CHK_GACC_GACC_GIBR_FK (
        p_branch_cd     IN OUT      giac_cm_dm.branch_cd%TYPE,
        p_branch_name   IN OUT      giac_branches.branch_name%TYPE,
        p_fund_desc     IN OUT      giis_funds.fund_desc%TYPE,
        p_grac_rac_cd   IN OUT      giis_funds.grac_rac_cd%TYPE      
    );   

    FUNCTION get_closed_tag(
        p_fund_cd   IN  giac_tran_mm.fund_cd%TYPE,
        p_branch_cd IN  giac_tran_mm.branch_cd%TYPE,
        p_date      IN  giac_acctrans.tran_date%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION check_applied_cm(
        p_gacc_tran_id  IN  giac_cm_dm.gacc_tran_id%TYPE
    ) RETURN NUMBER;
    
    PROCEDURE update_memo_status(
        p_gacc_tran_id      giac_cm_dm.gacc_tran_id%TYPE,
        p_memo_status       giac_cm_dm.memo_status%TYPE,
        p_user_id           giac_cm_dm.user_id%TYPE
    );


 /*    
 **    -- ACCOUNTING ENTRIES GENERATION PROCEDURES --
 **
 */   
    PROCEDURE aeg_parameters_071 (
        p_aeg_tran_id       giac_acctrans.tran_id%TYPE,   
        p_aeg_module_name   giac_modules.module_name%TYPE,
        p_branch_cd            IN  giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_fund_cd         IN  giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_user_id         IN  giac_acct_entries.user_id%TYPE
    );
    
    PROCEDURE aeg_create_acct_entries_071 (
        aeg_module_id          giac_module_entries.module_id%TYPE,
        aeg_item_no            giac_module_entries.item_no%TYPE,
        aeg_acct_amt           giac_cm_dm.local_amt%TYPE,
        aeg_gen_type           giac_acct_entries.generation_type%TYPE,
        p_branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_gacc_tran_id         giac_acct_entries.gacc_tran_id%TYPE,
        p_user_id              giac_acct_entries.user_id%TYPE
    );
    
    PROCEDURE aeg_set_acct_entries_071 (
         iuae_gl_acct_category  giac_acct_entries.gl_acct_category%TYPE,
         iuae_gl_control_acct   giac_acct_entries.gl_control_acct%TYPE,
         iuae_gl_sub_acct_1     giac_acct_entries.gl_sub_acct_1%TYPE,
         iuae_gl_sub_acct_2     giac_acct_entries.gl_sub_acct_2%TYPE,
         iuae_gl_sub_acct_3     giac_acct_entries.gl_sub_acct_3%TYPE,
         iuae_gl_sub_acct_4     giac_acct_entries.gl_sub_acct_4%TYPE,
         iuae_gl_sub_acct_5     giac_acct_entries.gl_sub_acct_5%TYPE,
         iuae_gl_sub_acct_6     giac_acct_entries.gl_sub_acct_6%TYPE,
         iuae_gl_sub_acct_7     giac_acct_entries.gl_sub_acct_7%TYPE,
         iuae_generation_type   giac_acct_entries.generation_type%TYPE,
         iuae_gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE,
         iuae_debit_amt         giac_acct_entries.debit_amt%TYPE,
         iuae_credit_amt        giac_acct_entries.credit_amt%TYPE,
         
         p_branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE,
         p_fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE,
         p_gacc_tran_id         giac_acct_entries.gacc_tran_id%TYPE,
         p_user_id              giac_acct_entries.user_id%TYPE
    );
    
--    PROCEDURE aeg_check_chart_of_accts_071(
--         cca_gl_acct_category    giac_acct_entries.gl_acct_category%TYPE,
--         cca_gl_control_acct     giac_acct_entries.gl_control_acct%TYPE,
--         cca_gl_sub_acct_1       giac_acct_entries.gl_sub_acct_1%TYPE,
--         cca_gl_sub_acct_2       giac_acct_entries.gl_sub_acct_2%TYPE,
--         cca_gl_sub_acct_3       giac_acct_entries.gl_sub_acct_3%TYPE,
--         cca_gl_sub_acct_4       giac_acct_entries.gl_sub_acct_4%TYPE,
--         cca_gl_sub_acct_5       giac_acct_entries.gl_sub_acct_5%TYPE,
--         cca_gl_sub_acct_6       giac_acct_entries.gl_sub_acct_6%TYPE,
--         cca_gl_sub_acct_7       giac_acct_entries.gl_sub_acct_7%TYPE,
--         cca_gl_acct_id   IN OUT giac_chart_of_accts.gl_acct_id%TYPE
--    );
    
    
    PROCEDURE aeg_parameters_rev_071 (
          p_aeg_tran_id               giac_acctrans.tran_id%TYPE,
          p_aeg_module_nm             giac_modules.module_name%TYPE,
          p_acc_tran_id               giac_acctrans.tran_id%TYPE,
          p_gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
          p_gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
          p_message             OUT   VARCHAR2
   );
   
   PROCEDURE create_rev_entries_071 (
          p_assd_no                      gipi_polbasic.assd_no%TYPE,
          p_coll_amt                     giac_comm_payts.comm_amt%TYPE,
          p_line_cd                      giis_line.line_cd%TYPE,
          p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
          p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
          p_acc_tran_id                  giac_acctrans.tran_id%TYPE,
          p_message             OUT      VARCHAR2
   );
   
   PROCEDURE insert_acctrans_071 (
        p_fund_cd               giac_cm_dm.fund_cd%TYPE,
  		p_branch_cd             giac_cm_dm.branch_cd%TYPE,
        p_rev_tran_date         giac_acctrans.tran_date%TYPE,
        p_memo_type             giac_cm_dm.memo_type%TYPE,
        p_memo_year             giac_cm_dm.memo_year%TYPE,
        p_memo_seq_no           giac_cm_dm.memo_seq_no%TYPE,
        p_memo_date             giac_cm_dm.memo_date%TYPE,
        p_tran_class            giac_acctrans.tran_class%TYPE,
        p_acc_tran_id      OUT  giac_acctrans.tran_id%TYPE,
        p_user_id               giac_cm_dm.user_id%TYPE,
        p_message          OUT  VARCHAR2
   );
   
   PROCEDURE insert_into_reversals_071(
        p_gacc_tran_id              giac_cm_dm.gacc_tran_id%TYPE,
        p_acc_tran_id      IN OUT   giac_acctrans.tran_id%TYPE,
        p_message          OUT      VARCHAR
   );
   -- end 03.20.2013 for GIACS071
    
END GIAC_CM_DM_PKG;
/


