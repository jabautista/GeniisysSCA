CREATE OR REPLACE PACKAGE CPI.GIACS149_PKG
AS
    
    PROCEDURE when_new_form_instance(
        p_update        IN      VARCHAR2,
        p_fund_cd       OUT     giac_parameters.PARAM_VALUE_V%type
    );
        
    
    TYPE intm_lov_type IS RECORD(
        intm_no         GIIS_INTERMEDIARY.INTM_NO%type,
        intm_name       GIIS_INTERMEDIARY.INTM_NAME%type,
        co_intm_type    GIIS_INTERMEDIARY.CO_INTM_TYPE%type,
        iss_cd          GIIS_INTERMEDIARY.ISS_CD%type,
        iss_name        GIIS_ISSOURCE.ISS_NAME%type
    );
    
    TYPE intm_lov_tab IS TABLE OF intm_lov_type;
    
    
    FUNCTION get_intm_lov(
        p_workflow_col_val  VARCHAR2,
        p_user_id           VARCHAR2,
        p_keyword           NUMBER
    ) RETURN intm_lov_tab PIPELINED;
        
    
    TYPE fund_lov_type IS RECORD(
        fund_cd         GIIS_FUNDS.FUND_CD%type,
        fund_desc       GIIS_FUNDS.FUND_DESC%type
        /*branch_cd       GIAC_BRANCHES.BRANCH_CD%type,
        branch_name     GIAC_BRANCHES.BRANCH_NAME%type*/
    );
    
    TYPE fund_lov_tab IS TABLE OF fund_lov_type;
    
    
    FUNCTION get_fund_lov(
        p_keyword   VARCHAR2,
        p_user_id   VARCHAR2
    )  RETURN fund_lov_tab PIPELINED;
        
    
    TYPE branch_lov_type IS RECORD(
        branch_cd       GIAC_BRANCHES.BRANCH_CD%type,
        branch_name     GIAC_BRANCHES.BRANCH_NAME%type
    );
    
    TYPE branch_lov_tab IS TABLE OF branch_lov_type;
    
    
    FUNCTION get_branch_lov (
        p_user_id       VARCHAR2,
        p_keyword       VARCHAR2
    ) RETURN branch_lov_tab PIPELINED;
        
        
    FUNCTION compute_var_advances(
        p_intm_no       GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_iss_cd        GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no   GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type
    ) RETURN NUMBER;
    
    
    PROCEDURE giac_p_comm_voucher_post_query(
        p_gfun_fund_cd      IN  GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN  GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_assd_no           IN  GIAC_PARENT_COMM_VOUCHER.ASSD_NO%type,
        p_chld_intm_no      IN  GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_advances          IN  GIAC_PARENT_COMM_VOUCHER.ADVANCES%type,
        p_commission_due    IN  GIAC_PARENT_COMM_VOUCHER.COMMISSION_DUE%type,
        p_input_vat         IN  GIAC_PARENT_COMM_VOUCHER.INPUT_VAT%type,
        p_withholding_tax   IN  GIAC_PARENT_COMM_VOUCHER.WITHHOLDING_TAX%type,
        p_premium_amt       IN  GIAC_PARENT_COMM_VOUCHER.PREMIUM_AMT%type,
        p_notarial_fee      IN  GIAC_PARENT_COMM_VOUCHER.NOTARIAL_FEE%type,
        p_other_charges     IN  GIAC_PARENT_COMM_VOUCHER.OTHER_CHARGES%type,
        p_var_advances      IN  GIAC_PARENT_COMM_VOUCHER.ADVANCES%type,
        p_tran_class        IN  GIAC_PARENT_COMM_VOUCHER.TRAN_CLASS%type,
        p_tran_class_no     IN  GIAC_PARENT_COMM_VOUCHER.TRAN_CLASS_NO%type,
        p_dsp_ref_no        OUT VARCHAR2,
        p_net_comm_due      OUT NUMBER,
        p_net_comm_amt_due  OUT NUMBER,
        p_prem_minus_others OUT NUMBER,
        p_assd_name         OUT GIIS_ASSURED.ASSD_NAME%type,
        p_chld_intm_name    OUT GIIS_INTERMEDIARY.INTM_NAME%type
        --p_assd_msg          OUT VARCHAR2,
        --p_intm_msg          OUT VARCHAR2
    );
    
    
    TYPE comm_voucher_type IS RECORD(
        gfun_fund_cd        GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        fund_desc           GIIS_FUNDS.FUND_DESC%type,
        gibr_branch_cd      GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        branch_name         GIAC_BRANCHES.BRANCH_NAME%type,
        gacc_tran_id        GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        policy_id           GIAC_PARENT_COMM_VOUCHER.POLICY_ID%type,
        policy_no           GIAC_PARENT_COMM_VOUCHER.POLICY_NO%type,
        iss_cd              GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        prem_seq_no         GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        inst_no             GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        transaction_type    GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        collection_amt      GIAC_PARENT_COMM_VOUCHER.COLLECTION_AMT%type,
        premium_amt         GIAC_PARENT_COMM_VOUCHER.PREMIUM_AMT%type,
        tax_amt             GIAC_PARENT_COMM_VOUCHER.TAX_AMT%type,
        tran_date           GIAC_PARENT_COMM_VOUCHER.TRAN_DATE%type,
        tran_class          GIAC_PARENT_COMM_VOUCHER.TRAN_CLASS%type,
        --tran_class_no       GIAC_PARENT_COMM_VOUCHER.TRAN_CLASS_NO%type,
        intm_no             GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        chld_intm_no        GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        chld_intm_name      GIIS_INTERMEDIARY.INTM_NAME%type,
        assd_no             GIAC_PARENT_COMM_VOUCHER.ASSD_NO%type,
        assd_name           GIIS_ASSURED.ASSD_NAME%type,
        ref_no              GIAC_PARENT_COMM_VOUCHER.REF_NO%type,
        dsp_ref_no          GIAC_PARENT_COMM_VOUCHER.REF_NO%type,
        --total_prem          GIAC_PARENT_COMM_VOUCHER.TOTAL_PREM%type,
        --ratio               GIAC_PARENT_COMM_VOUCHER.RATIO%type,
        commission_due      GIAC_PARENT_COMM_VOUCHER.COMMISSION_DUE%type,
        commission_amt      GIAC_PARENT_COMM_VOUCHER.COMMISSION_AMT%type,
        net_comm_due        GIAC_PARENT_COMM_VOUCHER.COMMISSION_DUE%type,
        net_comm_amt_due    GIAC_PARENT_COMM_VOUCHER.COMMISSION_DUE%type,
        prem_minus_others   GIAC_PARENT_COMM_VOUCHER.PREMIUM_AMT%type,
        print_tag           GIAC_PARENT_COMM_VOUCHER.PRINT_TAG%type,
        dsp_print_tag       GIAC_PARENT_COMM_VOUCHER.PRINT_TAG%type,
        print_date          VARCHAR2(50), --GIAC_PARENT_COMM_VOUCHER.PRINT_DATE%type,
        input_vat           GIAC_PARENT_COMM_VOUCHER.INPUT_VAT%type,
        advances            GIAC_PARENT_COMM_VOUCHER.ADVANCES%type,
        var_advances        GIAC_PARENT_COMM_VOUCHER.ADVANCES%type,
        withholding_tax     GIAC_PARENT_COMM_VOUCHER.WITHHOLDING_TAX%type,
        ocv_no              GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        ocv_pref_suf        GIAC_PARENT_COMM_VOUCHER.OCV_PREF_SUF%type,
        last_update         VARCHAR2(50), --GIAC_PARENT_COMM_VOUCHER.LAST_UPDATE%type,
        notarial_fee        GIAC_PARENT_COMM_VOUCHER.NOTARIAL_FEE%type,
        other_charges       GIAC_PARENT_COMM_VOUCHER.OTHER_CHARGES%type,
        user_id             GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        cancel_tag          GIAC_PARENT_COMM_VOUCHER.CANCEL_TAG%type
        --cpi_rec_no          GIAC_PARENT_COMM_VOUCHER.CPI_REC_NO%type,
        --cpi_branch_cd       GIAC_PARENT_COMM_VOUCHER.CPI_BRANCH_CD%type
    );
    
    TYPE comm_voucher_tab IS TABLE OF comm_voucher_type;
    
    FUNCTION get_comm_voucher_list(
        p_intm_no               GIIS_INTERMEDIARY.INTM_NO%type,
        p_gfun_fund_cd          GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd        GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_from_date             VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.TRAN_DATE%type,
        p_to_date               VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.TRAN_DATE%type,
        p_workflow_col_value    VARCHAR2,
        p_user_id               GIAC_PARENT_COMM_VOUCHER.USER_ID%type
    ) RETURN comm_voucher_tab PIPELINED;


    PROCEDURE update_input_vat_advances(
        p_gfun_fund_cd      IN  GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN  GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN  GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN  GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN  GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN  GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN  GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN  GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_input_vat         IN  GIAC_PARENT_COMM_VOUCHER.INPUT_VAT%type,
        p_advances          IN  GIAC_PARENT_COMM_VOUCHER.ADVANCES%type,
        p_user_id           IN  GIAC_PARENT_COMM_VOUCHER.USER_ID%type
    );
    
    
    /* added p_from_date and p_to_date to handle queries with date parameters.
       pol cruz 02.02.2014 SR#661 */
    PROCEDURE compute_totals(
        p_intm_no       IN      GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_user_id       IN      GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        p_tagged_prem   OUT     NUMBER,
        p_tagged_comm   OUT     NUMBER,
        p_grand_prem    OUT     NUMBER,
        p_grand_comm    OUT     NUMBER,
        p_from_date     IN      VARCHAR2,
        p_to_date       IN      VARCHAR2 
    );
    
    PROCEDURE check_cv_seq(
        p_gfun_fund_cd      IN   GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        /*p_gibr_branch_cd    IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN  GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN  GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN  GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN  GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN  GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN  GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN  GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_cv_no             IN  NUMBER,
        p_cv_pref           IN  VARCHAR2, */
        p_doc_name          IN  giac_doc_sequence.DOC_NAME%type,
        p_user              IN  GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        /*p_voucher_no        OUT GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        p_voucher_pref_suf  OUT giac_doc_sequence.DOC_PREF_SUF%type,
        p_voucher_date      OUT GIAC_PARENT_COMM_VOUCHER.PRINT_DATE%type,*/
        p_found             OUT VARCHAR2,
        p_max_no            OUT NUMBER
    );
        
    PROCEDURE update_vat(
        p_gfun_fund_cd      IN  GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN  GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN  GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN  GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN  GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN  GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN  GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN  GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_commission_due    IN  GIAC_PARENT_COMM_VOUCHER.COMMISSION_DUE%type
    );
    
    PROCEDURE populate_cv_seq(
        p_gfun_fund_cd      IN      GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN      GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN      GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN      GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN      GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN      GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN      GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN      GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN      GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_cv_no             IN      GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        p_cv_pref           IN      VARCHAR2,
        p_doc_name          IN      GIAC_DOC_SEQUENCE.DOC_NAME%type,
        p_user_id           IN      GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        p_voucher_no        IN OUT  NUMBER,
        p_voucher_date      OUT     GIAC_PARENT_COMM_VOUCHER.PRINT_DATE%type,
        p_reprint           OUT     VARCHAR2
    );
    
     TYPE gpcv_type IS RECORD(
        gfun_fund_cd        GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        gibr_branch_cd      GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        gacc_tran_id        GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        transaction_type    GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        iss_cd              GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        prem_seq_no         GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        inst_no             GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        intm_no             GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        chld_intm_no        GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        ref_no              GIAC_PARENT_COMM_VOUCHER.REF_NO%type,
        ocv_no              GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        ocv_pref_suf        GIAC_PARENT_COMM_VOUCHER.OCV_PREF_SUF%type,
        last_update         VARCHAR2(30), --GIAC_PARENT_COMM_VOUCHER.LAST_UPDATE%type,
        user_id             GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        print_date          VARCHAR2(30) --GIAC_PARENT_COMM_VOUCHER.PRINT_DATE%type
    );
    
    TYPE gpcv_tab IS TABLE OF gpcv_type;
    
    FUNCTION gpcv_get(
        p_intm_no       GIAC_PARENT_COMM_VOUCHER.INTM_NO%type
    ) RETURN gpcv_tab PIPELINED;
    
    
    PROCEDURE update_gpcv(
        p_gfun_fund_cd      IN      GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN      GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN      GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN      GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN      GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN      GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN      GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN      GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN      GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_voucher_no        IN      GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        p_cv_pref           IN      VARCHAR2,
        p_user_id           IN      GIAC_PARENT_COMM_VOUCHER.USER_ID%type
    );
    
    
    PROCEDURE delete_workflow_rec(
        p_event_desc    IN VARCHAR2,
        p_module_id     IN VARCHAR2,
        p_user          IN VARCHAR2,
        p_col_value     IN VARCHAR2
    );
    
    
    PROCEDURE gpcv_restore(
        p_gfun_fund_cd      IN      GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN      GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN      GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN      GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN      GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN      GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN      GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN      GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN      GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_print_date        IN      VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.PRINT_DATE%type,
        p_ocv_no            IN      GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        p_ocv_pref_suf      IN      GIAC_PARENT_COMM_VOUCHER.OCV_PREF_SUF%type,
        p_ref_no            IN      GIAC_PARENT_COMM_VOUCHER.REF_NO%type,
        p_last_update       IN      VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.LAST_UPDATE%type,
        p_user_id           IN      GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        p_app_user          IN      VARCHAR2,                   
        p_stat              IN      NUMBER
    );
    
    PROCEDURE update_print_tag (
        p_intm_no               IN  GIIS_INTERMEDIARY.INTM_NO%type,
        p_gfun_fund_cd          IN  GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd        IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_from_date             IN  VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.TRAN_DATE%type,
        p_to_date               IN  VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.TRAN_DATE%type,
        p_workflow_col_value    IN  VARCHAR2,
        p_user_id               IN  GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        p_dsp_print_tag         IN  VARCHAR2,
        p_ocv_no                IN  GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        p_ocv_pref_suf          IN  GIAC_PARENT_COMM_VOUCHER.OCV_PREF_SUF%type,
        p_gacc_tran_id          IN  GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type      IN  GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd                IN  GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no           IN  GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no               IN  GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_chld_intm_no          IN  GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type
    );
    
    
    PROCEDURE insert_spoiled_ocv(
        p_intm_no               IN  GIIS_INTERMEDIARY.INTM_NO%type,
        p_gfun_fund_cd          IN  GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd        IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_user_id               IN  GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        p_voucher_no            IN  NUMBER,                                         
        p_doc_name              IN  VARCHAR2,
        p_commission_due        IN  NUMBER,
        p_net_comm_amt_due      IN  NUMBER
    );
    
    
    PROCEDURE update_doc_seq_no(
        p_gfun_fund_cd      IN  VARCHAR2,
        p_doc_name          IN  VARCHAR2,
        p_ocv_pref_suf      IN  VARCHAR2,
        p_user_id           IN  VARCHAR2
    );
    
END GIACS149_PKG;
/


