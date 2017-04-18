CREATE OR REPLACE PACKAGE CPI.giac_direct_claim_payts_pkg AS
 
/****************************************************************
 * PACKAGE NAME : GIAC_DIRECT_CLAIM_PAYTS_PKG
 * MODULE NAME  : GIACS017
 * CREATED BY   : RENCELA
 * DATE CREATED : 2010-09-16
 * MODIFICATIONS-------------------------------------------------
 * MODIFIED BY  | DATE      | REMARKS 
 * RENCELA        20100916    MODULE CREATED 
 * RENCELA          20101006      ADDED ADVICE_SEQ TYPE AND GETTERS
*****************************************************************/
                                                                  


   TYPE clm_loss_id_type IS RECORD (
        claim_loss_id        gicl_clm_loss_exp.clm_loss_id%TYPE,
        payee_type            gicl_clm_loss_exp.payee_type%TYPE,
        payee_type_desc        VARCHAR2(20),
        payee_class_cd        gicl_clm_loss_exp.payee_class_cd%TYPE,
        payee_cd            gicl_clm_loss_exp.payee_cd%TYPE,
        payee                VARCHAR2(1000),--changed from 150 to 1000 reymon 04242013
        peril_cd            gicl_clm_loss_exp.peril_cd%TYPE,
        peril_sname            giis_peril.peril_sname%TYPE,
        net_amt                NUMBER(12,2),
        paid_amt             gicl_clm_loss_exp.paid_amt%TYPE,
        advice_amt            gicl_clm_loss_exp.advise_amt%TYPE
   );

   TYPE clm_loss_id_tab IS TABLE OF clm_loss_id_type;

   FUNCTION get_clm_loss_id(
            p_line_cd        giis_peril.line_cd%TYPE,
            p_advice_id        VARCHAR2,
            p_claim_id        VARCHAR2,
            p_tran_type      VARCHAR2
   )RETURN clm_loss_id_tab PIPELINED; 
   
   TYPE advice_iss_cd_type IS RECORD (
       iss_cd                   gicl_advice.iss_cd%TYPE,
    iss_name               giis_issource.iss_name%TYPE
   );
   
   TYPE advice_iss_cd_tab IS TABLE OF advice_iss_cd_type;
   
   FUNCTION get_advice_isscd(
               p_module           VARCHAR2
            --,p_iss_cd           GIIS_ISSOURCE.iss_cd%TYPE
   )RETURN advice_iss_cd_tab PIPELINED;
   
   FUNCTION get_advice_isscd2(
               p_module           VARCHAR2
            --,p_iss_cd           GIIS_ISSOURCE.iss_cd%TYPE
   )RETURN advice_iss_cd_tab PIPELINED;
   
   TYPE advice_seq_type IS RECORD(
        advice_seq_no       gicl_advice.advice_seq_no%TYPE,
        advice_no           VARCHAR2(50),
        line_cd               gicl_advice.line_cd%TYPE,
        iss_cd               gicl_advice.iss_cd%TYPE,
        advice_year           gicl_advice.advice_year%TYPE,
        advice_id           gicl_advice.advice_id%TYPE,
        claim_id           gicl_advice.claim_id%TYPE,
        convert_rate       gicl_advice.convert_rate%TYPE,
        cpi_branch_cd       gicl_advice.cpi_branch_cd%TYPE,
        cpi_rec_no           gicl_advice.cpi_rec_no%TYPE,
        currency_cd           gicl_advice.currency_cd%TYPE,
        currency_desc       giis_currency.currency_desc%TYPE
   );
    
   TYPE advice_seq_tab IS TABLE OF advice_seq_type;        
   
   FUNCTION get_advice_seq(
           p_module           VARCHAR2,    
           p_line_cd           giis_peril.line_cd%TYPE,
        p_iss_cd           giis_issource.iss_cd%TYPE,
        p_advice_year       VARCHAR2       
   ) RETURN advice_seq_tab PIPELINED;
   
   FUNCTION get_advice_seq2(
           p_module           VARCHAR2,    
           p_line_cd           giis_peril.line_cd%TYPE,
        p_iss_cd           giis_issource.iss_cd%TYPE,
        p_advice_year       VARCHAR2   
   ) RETURN advice_seq_tab PIPELINED;
   
   FUNCTION get_advice_sequence_listing(
           p_module           VARCHAR2,
        p_keyword           VARCHAR2
   ) RETURN advice_seq_tab PIPELINED;

   PROCEDURE compute_advice_default_amount(
           p_v_check            IN OUT NUMBER,
        p_trans_type        IN NUMBER,
        p_gioc_gacc_tran_id IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_claim_id            IN giac_direct_claim_payts.claim_id%TYPE,
        p_clm_loss_id        IN giac_direct_claim_payts.clm_loss_id%TYPE,
        p_advice_id            IN giac_direct_claim_payts.advice_id%TYPE,
        p_input_vat_amt        OUT giac_direct_claim_payts.input_vat_amt%TYPE,
        p_wholding_tax_amt  OUT gicl_loss_exp_tax.tax_amt%TYPE,
        p_net_disb_amt        OUT gicl_clm_loss_exp.paid_amt%TYPE
   );
   
   PROCEDURE save_direct_claim_payt(
        p_advice_id         IN giac_direct_claim_payts.advice_id%TYPE,
        p_claim_id          IN giac_direct_claim_payts.claim_id%TYPE,
        p_clm_loss_id       IN giac_direct_claim_payts.clm_loss_id%TYPE,             
        p_convert_rate      IN giac_direct_claim_payts.convert_rate%TYPE,
        p_cpi_branch_cd     IN giac_direct_claim_payts.cpi_branch_cd%TYPE,
        p_cpi_rec_no        IN giac_direct_claim_payts.cpi_rec_no%TYPE,
        p_currency_cd       IN giac_direct_claim_payts.currency_cd%TYPE,
        p_disbursement_amt  IN giac_direct_claim_payts.disbursement_amt%TYPE,
        p_foreign_curr_amt  IN giac_direct_claim_payts.foreign_curr_amt%TYPE,
        p_gacc_tran_id      IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_input_vat_amt     IN giac_direct_claim_payts.input_vat_amt%TYPE,
        p_net_disb_amt      IN giac_direct_claim_payts.net_disb_amt%TYPE,
        p_orig_curr_cd      IN giac_direct_claim_payts.orig_curr_cd%TYPE,
        p_orig_curr_rate    IN giac_direct_claim_payts.orig_curr_rate%TYPE,
        p_or_print_tag      IN giac_direct_claim_payts.or_print_tag%TYPE,
        p_payee_cd          IN giac_direct_claim_payts.payee_cd%TYPE,
        p_payee_class_cd    IN giac_direct_claim_payts.payee_class_cd%TYPE,
        p_payee_type        IN giac_direct_claim_payts.payee_type%TYPE,
    --    p_peril_cd          IN giac_direct_claim_payts.peril_cd%TYPE,
        p_remarks           IN giac_direct_claim_payts.remarks%TYPE,
        p_transaction_type  IN giac_direct_claim_payts.transaction_type%TYPE,
        p_user_id           IN giac_direct_claim_payts.user_id%TYPE,
        p_wholding_tax_amt  IN giac_direct_claim_payts.wholding_tax_amt%TYPE
   );
   
   PROCEDURE set_direct_claim_payt(
        p_dcp   IN giac_direct_claim_payts%ROWTYPE
   );
   
   PROCEDURE aeg_delete_acct_entries(
        p_gacc_tran_id       IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_generation_type IN giac_acct_entries.generation_type%TYPE
    );
   
   PROCEDURE aeg_insert_update_acct_entries(
        p_gacc_tran_id          IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_gacc_fund_cd          IN giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_gacc_branch_cd        IN giac_acct_entries.gacc_gibr_branch_cd%TYPE,     
         iuae_gl_acct_category  IN giac_acct_entries.gl_acct_category%TYPE,
         iuae_gl_control_acct   IN giac_acct_entries.gl_control_acct%TYPE,
         iuae_gl_sub_acct_1     IN giac_acct_entries.gl_sub_acct_1%TYPE,
         iuae_gl_sub_acct_2     IN giac_acct_entries.gl_sub_acct_2%TYPE,
         iuae_gl_sub_acct_3     IN giac_acct_entries.gl_sub_acct_3%TYPE,
         iuae_gl_sub_acct_4     IN giac_acct_entries.gl_sub_acct_4%TYPE,
         iuae_gl_sub_acct_5     IN giac_acct_entries.gl_sub_acct_5%TYPE,
         iuae_gl_sub_acct_6     IN giac_acct_entries.gl_sub_acct_6%TYPE,
         iuae_gl_sub_acct_7     IN giac_acct_entries.gl_sub_acct_7%TYPE,
         iuae_sl_cd             IN giac_acct_entries.sl_cd%TYPE,
         iuae_generation_type   IN giac_acct_entries.generation_type%TYPE,
         iuae_gl_acct_id        IN giac_chart_of_accts.gl_acct_id%TYPE,
         iuae_debit_amt         IN giac_acct_entries.debit_amt%TYPE,
         iuae_credit_amt        IN giac_acct_entries.credit_amt%TYPE,
         iuae_sl_type_cd        IN giac_sl_types.sl_type_cd%TYPE,
         iuae_clm_loss_id       IN gicl_acct_entries.clm_loss_id%TYPE
   );
   
   PROCEDURE aeg_ins_upd_giac_acct_entries(
        p_gacc_tran_id    IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_gacc_fund_cd    IN giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_gacc_branch_cd  IN giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_generation_type IN giac_acct_entries.generation_type%TYPE,
        p_claim_id        IN giac_direct_claim_payts.claim_id%TYPE,
        p_advice_id       IN giac_direct_claim_payts.advice_id%TYPE,
        p_payee_class_cd  IN giac_direct_claim_payts.payee_class_cd%TYPE,
        p_payee_cd        IN giac_direct_claim_payts.payee_cd%TYPE
   );
    
   PROCEDURE chk_gdcp_a1280_fk( 
           p_field_level IN BOOLEAN,
        p_payee_class_cd IN giis_payees.payee_class_cd%TYPE,
        p_payee_no       IN giis_payees.payee_no%TYPE, 
        p_dummy          OUT VARCHAR2
   );
    
    PROCEDURE insert_into_giac_taxes_wheld(
        p_gacc_tran_id    IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_convert_rate    IN NUMBER,
        p_item_no         IN OUT giac_module_entries.item_no%TYPE, -- := 1;
        p_claim_id        IN giac_direct_claim_payts.claim_id%TYPE,
        p_advice_id       IN giac_direct_claim_payts.advice_id%TYPE,
        p_iss_cd          IN giis_issource.iss_cd%TYPE,     
        p_payee_class_cd  IN giac_taxes_wheld.payee_class_cd%TYPE,
        p_payee_cd        IN giac_taxes_wheld.payee_cd%TYPE
   );
 
   PROCEDURE update_giac_op_text(
        p_gacc_tran_id     IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_module_name      IN giac_modules.module_name%TYPE
   );
   
   PROCEDURE update_workflow_switch(
           p_event_desc     IN VARCHAR2,
        p_module_id      IN VARCHAR2,
        p_user           IN VARCHAR2
   );
   
   PROCEDURE dcp_post_forms_commit(
           p_gacc_tran_id       IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_trans_source      IN VARCHAR2,
        p_or_flag          IN VARCHAR2,
        p_gacc_fund_cd      IN giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_gacc_branch_cd  IN giac_acct_entries.gacc_gibr_branch_cd%TYPE,
           p_claim_id        IN giac_direct_claim_payts.claim_id%TYPE,
        p_advice_id       IN giac_direct_claim_payts.advice_id%TYPE,
        p_payee_class_cd  IN giac_direct_claim_payts.payee_class_cd%TYPE,
        p_payee_cd        IN giac_direct_claim_payts.payee_cd%TYPE,
        p_convert_rate      IN NUMBER,
        p_iss_cd          IN giis_issource.iss_cd%TYPE,
        p_module_name      IN giac_modules.module_name%TYPE,
        p_generation_type IN OUT giac_acct_entries.generation_type%TYPE,
        p_item_no         IN OUT giac_module_entries.item_no%TYPE,
        p_module_id            IN OUT giac_modules.module_id%TYPE
   );
   
   PROCEDURE dcp_post_insert(
           p_trans_type      IN NUMBER,
           p_claim_id        IN giac_direct_claim_payts.claim_id%TYPE,
        p_advice_id       IN giac_direct_claim_payts.advice_id%TYPE
   );
   
   TYPE adv_seq_listing_type IS RECORD(
        advice_seq_no       gicl_advice.advice_seq_no%TYPE,
        advice_no           VARCHAR2(50),
        line_cd             gicl_advice.line_cd%TYPE,
        iss_cd              gicl_advice.iss_cd%TYPE,
        advice_year         gicl_advice.advice_year%TYPE,
        advice_id           gicl_advice.advice_id%TYPE,
        claim_id            gicl_advice.claim_id%TYPE,
        convert_rate        gicl_advice.convert_rate%TYPE,
        currency_cd         gicl_advice.currency_cd%TYPE,
        currency_desc       giis_currency.currency_desc%TYPE,
        dsp_claim_no        VARCHAR2(50),
        dsp_policy_no       VARCHAR2(50),
        assured_name        gicl_claims.assured_name%TYPE
   );
    
   TYPE adv_seq_listing_tab IS TABLE OF adv_seq_listing_type;     
   
   FUNCTION get_advice_seq_listing(
        p_module_id        VARCHAR2,
        p_user_id          VARCHAR2,
        p_viss_cd          gicl_advice.iss_cd%TYPE, 
        p_tran_type        GIAC_DIRECT_CLAIM_PAYTS.transaction_type%TYPE, 
        p_line_cd          gicl_advice.line_cd%TYPE,
        p_iss_cd           gicl_advice.iss_cd%TYPE,
        p_advice_year      gicl_advice.advice_year%TYPE,
        p_advice_seq_no    gicl_advice.advice_seq_no%TYPE
   ) RETURN adv_seq_listing_tab PIPELINED;
   
  /* PROCEDURE GDCP_pre_insert(
           p_or_print_tag              IN OUT VARCHAR2,
        p_gdcp_gacc_tran_id        IN OUT NUMBER,
        p_global_gacc_tran_id    IN OUT NUMBER,
          
   );*/
   
   TYPE gdcp_list_type IS RECORD (
        gacc_tran_id            GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
        transaction_type        GIAC_DIRECT_CLAIM_PAYTS.transaction_type%TYPE,
        claim_id                GIAC_DIRECT_CLAIM_PAYTS.claim_id%TYPE,
        clm_loss_id             GIAC_DIRECT_CLAIM_PAYTS.clm_loss_id%TYPE,
        advice_id               GIAC_DIRECT_CLAIM_PAYTS.advice_id%TYPE,
        payee_cd                GIAC_DIRECT_CLAIM_PAYTS.payee_cd%TYPE,
        payee_class_cd          GIAC_DIRECT_CLAIM_PAYTS.payee_class_cd%TYPE,
        payee_type              GIAC_DIRECT_CLAIM_PAYTS.payee_type%TYPE,
        disbursement_amt        GIAC_DIRECT_CLAIM_PAYTS.disbursement_amt%TYPE,
        currency_cd             GIAC_DIRECT_CLAIM_PAYTS.currency_cd%TYPE,
        convert_rate            GIAC_DIRECT_CLAIM_PAYTS.convert_rate%TYPE,
        foreign_curr_amt        GIAC_DIRECT_CLAIM_PAYTS.foreign_curr_amt%TYPE,
        or_print_tag            GIAC_DIRECT_CLAIM_PAYTS.or_print_tag%TYPE,
        remarks                 GIAC_DIRECT_CLAIM_PAYTS.remarks%TYPE,
        input_vat_amt           GIAC_DIRECT_CLAIM_PAYTS.input_vat_amt%TYPE,
        wholding_tax_amt        GIAC_DIRECT_CLAIM_PAYTS.wholding_tax_amt%TYPE,
        net_disb_amt            GIAC_DIRECT_CLAIM_PAYTS.net_disb_amt%TYPE,
        orig_curr_cd            GIAC_DIRECT_CLAIM_PAYTS.orig_curr_cd%TYPE,
        orig_curr_rate          GIAC_DIRECT_CLAIM_PAYTS.orig_curr_rate%TYPE,
        --peril_cd                GIAC_DIRECT_CLAIM_PAYTS.peril_cd%TYPE,
        
        dsp_advice_no           VARCHAR2(100),
        currency_desc           GIIS_CURRENCY.currency_desc%TYPE,
        dsp_iss_cd              GICL_ADVICE.iss_cd%TYPE,
        dsp_line_cd             GICL_ADVICE.line_cd%TYPE,
        dsp_advice_year         GICL_ADVICE.advice_year%TYPE,
        dsp_advice_seq_no       GICL_ADVICE.advice_seq_no%TYPE,
        dsp_payee_desc          VARCHAR2(10),
        dsp_peril_name          GIIS_PERIL.peril_sname%TYPE,
        dsp_payee_name          VARCHAR2(1000)   ,--changed 300 to 1000 reymon 04242013
        
        dsp_line_cd2            GICL_CLAIMS.line_cd%TYPE,
        dsp_subline_cd          GICL_CLAIMS.subline_cd%TYPE,
        dsp_iss_cd3             GICL_CLAIMS.pol_iss_cd%TYPE,
        dsp_issue_yy            GICL_CLAIMS.issue_yy%TYPE,
        dsp_pol_seq_no          GICL_CLAIMS.pol_seq_no%TYPE,
        dsp_renew_no            GICL_CLAIMS.renew_no%TYPE,
        dsp_iss_cd2             GICL_CLAIMS.iss_cd%TYPE,
        dsp_clm_yy              GICL_CLAIMS.clm_yy%TYPE,
        dsp_clm_seq_no          GICL_CLAIMS.clm_seq_no%TYPE,
        dsp_assured_name        GICL_CLAIMS.assured_name%TYPE,
        batch_csr_id            GICL_ADVICE.batch_csr_id%TYPE--added by reymon 04262013
        
   );
   
   TYPE gdcp_list_tab IS TABLE OF gdcp_list_type;  
   
   FUNCTION get_direct_claim_payts_list (
       p_gacc_tran_id           GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE
   ) RETURN gdcp_list_tab PIPELINED;
   
   PROCEDURE get_gdcp_amount_sums (
      p_gacc_tran_id    IN  GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
      p_sum_disbmt_amt  OUT NUMBER,
      p_sum_input_vat   OUT NUMBER,
      p_sum_wholding    OUT NUMBER,
      p_sum_dsp_net_amt OUT NUMBER
   );
   
   FUNCTION get_dcp_from_advice(
        p_gacc_tran_id          GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
        p_tran_type             GIAC_DIRECT_CLAIM_PAYTS.transaction_type%TYPE,
        p_line_cd               GICL_ADVICE.iss_cd%TYPE,
        p_iss_cd                GICL_ADVICE.line_cd%TYPE,
        p_advice_year           GICL_ADVICE.advice_year%TYPE,
        p_advice_seq_no         GICL_ADVICE.advice_seq_no%TYPE,
        p_payee_cd              GIAC_DIRECT_CLAIM_PAYTS.payee_cd%TYPE,
        p_claim_id              GIAC_DIRECT_CLAIM_PAYTS.claim_id%TYPE,
        p_clm_loss_id           GIAC_DIRECT_CLAIM_PAYTS.clm_loss_id%TYPE,
        p_ri_iss_cd             GICL_ADVICE.iss_cd%TYPE,
        p_module_id             GIIS_MODULES.module_id%TYPE,
        p_user_id               GIIS_USERS.user_id%TYPE
   ) RETURN gdcp_list_tab PIPELINED;
   
   FUNCTION get_dcp_from_batch (
        p_gacc_tran_id          GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
        p_tran_type             GIAC_DIRECT_CLAIM_PAYTS.transaction_type%TYPE,       
        p_batch_csr_id          GICL_BATCH_CSR.batch_csr_id%TYPE,
        p_ri_iss_cd             GICL_ADVICE.iss_cd%TYPE,
        p_module_id             GIIS_MODULES.module_id%TYPE,
        p_user_id               GIIS_USERS.user_id%TYPE
    ) RETURN gdcp_list_tab PIPELINED;
   
   PROCEDURE giacs017_post_forms_commit (
        p_gacc_tran_id          IN      GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
        p_gacc_branch_cd        IN      GIAC_ACCTRANS.gibr_branch_cd%TYPE,
        p_gacc_fund_cd          IN      GIAC_ACCTRANS.gfun_fund_cd%TYPE,
        p_tran_source           IN      VARCHAR2,
        p_or_flag               IN      VARCHAR2,
        p_module_name           IN OUT  GIAC_MODULES.module_name%TYPE, --module_id
        p_user_id               IN      GIIS_USERS.user_id%TYPE,
        p_var_gen_type          IN OUT  GIAC_MODULES.generation_type%TYPE,
        p_message               OUT     VARCHAR2
    );
END;
/


