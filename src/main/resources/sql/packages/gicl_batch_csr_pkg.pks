CREATE OR REPLACE PACKAGE CPI.GICL_BATCH_CSR_PKG
AS

    TYPE gicl_batch_csr_type IS RECORD (
        batch_csr_id        GICL_BATCH_CSR.batch_csr_id%TYPE,
        fund_cd             GICL_BATCH_CSR.fund_cd%TYPE,
        iss_cd              GICL_BATCH_CSR.iss_cd%TYPE,
        batch_year          GICL_BATCH_CSR.batch_year%TYPE,
        batch_seq_no        GICL_BATCH_CSR.batch_seq_no%TYPE,
        particulars         GICL_BATCH_CSR.particulars%TYPE,
        payee_class_cd      GICL_BATCH_CSR.payee_class_cd%TYPE,
        payee_class_desc    GIIS_PAYEE_CLASS.class_desc%TYPE,
        payee_cd            GICL_BATCH_CSR.payee_cd%TYPE,
        payee_name          VARCHAR2(600), --Lara 10/21/2013 - modified max length
        paid_amt            GICL_BATCH_CSR.paid_amt%TYPE,
        net_amt             GICL_BATCH_CSR.net_amt%TYPE,
        advise_amt          GICL_BATCH_CSR.advise_amt%TYPE,
        currency_cd         GICL_BATCH_CSR.currency_cd%TYPE,
        currency_desc       GIIS_CURRENCY.currency_desc%TYPE,
        convert_rate        GICL_BATCH_CSR.convert_rate%TYPE,
        clm_dtl_sw          GICL_BATCH_CSR.clm_dtl_sw%TYPE,
        user_id             GICL_BATCH_CSR.user_id%TYPE,
        last_update         GICL_BATCH_CSR.last_update%TYPE,
        batch_flag          GICL_BATCH_CSR.batch_flag%TYPE,
        ref_id              GICL_BATCH_CSR.ref_id%TYPE,
        req_dtl_no          GICL_BATCH_CSR.req_dtl_no%TYPE,
        tran_id             GICL_BATCH_CSR.tran_id%TYPE,
        net_fcurr_amt       GICL_BATCH_CSR.net_fcurr_amt%TYPE,
        paid_fcurr_amt      GICL_BATCH_CSR.paid_fcurr_amt%TYPE,
        adv_fcurr_amt       GICL_BATCH_CSR.adv_fcurr_amt%TYPE,
        batch_csr_no        VARCHAR2(500),
        loss_amt            NUMBER
    );
    
    TYPE gicl_batch_csr_tab IS TABLE OF gicl_batch_csr_type;
    
    FUNCTION get_gicl_batch_csr_list(p_module_id        VARCHAR2,
                                     p_user_id          GIIS_USERS.user_id%TYPE,
                                     p_fund_cd          GICL_BATCH_CSR.fund_cd%TYPE,
                                     p_iss_cd           GICL_BATCH_CSR.iss_cd%TYPE,
                                     p_batch_year       GICL_BATCH_CSR.batch_year%TYPE,
                                     p_batch_seq_no     GICL_BATCH_CSR.batch_seq_no%TYPE,
                                     p_particulars      GICL_BATCH_CSR.particulars%TYPE,
                                     p_payee_class      VARCHAR2,
                                     p_payee_cd         GICL_BATCH_CSR.payee_cd%TYPE,
                                     p_payee_name       VARCHAR2,
                                     p_paid_amt         GICL_BATCH_CSR.paid_amt%TYPE,
                                     p_net_amt          GICL_BATCH_CSR.net_amt%TYPE,
                                     p_advise_amt       GICL_BATCH_CSR.advise_amt%TYPE,
                                     p_currency_desc    GIIS_CURRENCY.currency_desc%TYPE,
                                     p_convert_rate     GICL_BATCH_CSR.convert_rate%TYPE,
                                     p_processor        GICL_BATCH_CSR.user_id%TYPE)
                                     
    RETURN gicl_batch_csr_tab PIPELINED;
    
    PROCEDURE set_gicl_batch_csr(p_batch_csr_id     IN     GICL_BATCH_CSR.batch_csr_id%TYPE,
                                 p_fund_cd          IN     GICL_BATCH_CSR.fund_cd%TYPE,
                                 p_iss_cd           IN     GICL_BATCH_CSR.iss_cd%TYPE,
                                 p_batch_year       IN     GICL_BATCH_CSR.batch_year%TYPE,
                                 p_batch_seq_no     IN     GICL_BATCH_CSR.batch_seq_no%TYPE,
                                 p_particulars      IN     GICL_BATCH_CSR.particulars%TYPE,
                                 p_payee_class_cd   IN     GICL_BATCH_CSR.payee_class_cd%TYPE,
                                 p_payee_cd         IN     GICL_BATCH_CSR.payee_cd%TYPE,
                                 p_paid_amt         IN     GICL_BATCH_CSR.paid_amt%TYPE,
                                 p_net_amt          IN     GICL_BATCH_CSR.net_amt%TYPE,
                                 p_advise_amt       IN     GICL_BATCH_CSR.advise_amt%TYPE,
                                 p_currency_cd      IN     GICL_BATCH_CSR.currency_cd%TYPE,
                                 p_convert_rate     IN     GICL_BATCH_CSR.convert_rate%TYPE,
                                 p_user_id          IN     GICL_BATCH_CSR.user_id%TYPE,
                                 p_batch_flag       IN     GICL_BATCH_CSR.batch_flag%TYPE,
                                 p_net_fcurr_amt    IN     GICL_BATCH_CSR.net_fcurr_amt%TYPE,
                                 p_paid_fcurr_amt   IN     GICL_BATCH_CSR.paid_fcurr_amt%TYPE,
                                 p_adv_fcurr_amt    IN     GICL_BATCH_CSR.adv_fcurr_amt%TYPE);
    
    FUNCTION get_gicl_batch_csr (p_batch_csr_id GICL_BATCH_CSR.batch_csr_id%TYPE,
                                 p_module_id    VARCHAR2,
                                 p_user_id      GIIS_USERS.user_id%TYPE)
                                     
    RETURN gicl_batch_csr_tab PIPELINED;
    
    
    PROCEDURE generate_batch_number_a(p_iss_cd        IN      GICL_BATCH_CSR.iss_cd%TYPE,
                                      p_user_id       IN      GIIS_USERS.user_id%TYPE,
                                      p_fund_cd       IN OUT  GICL_BATCH_CSR.fund_cd%TYPE,
                                      p_batch_year    IN OUT  GICL_BATCH_CSR.batch_year%TYPE,
                                      p_batch_seq_no  IN OUT  GICL_BATCH_CSR.batch_seq_no%TYPE,
                                      p_batch_csr_id  IN OUT  GICL_BATCH_CSR.batch_csr_id%TYPE);
                                      
    PROCEDURE generate_batch_number_b(p_batch_csr_id    IN  GICL_BATCH_CSR.batch_csr_id%TYPE,
                                      p_claim_id        IN  GICL_CLAIMS.claim_id%TYPE,
                                      p_advice_id       IN  GICL_ADVICE.advice_id%TYPE,
                                      p_line_cd         IN  GICL_ADVICE.line_cd%TYPE,
                                      p_iss_cd          IN  GICL_ADVICE.iss_cd%TYPE,
                                      p_advice_year     IN  GICL_ADVICE.advice_year%TYPE,
                                      p_advice_seq_no   IN  GICL_ADVICE.advice_seq_no%TYPE,
                                      p_user_id         IN  GIIS_USERS.user_id%TYPE,
                                      p_msg_alert       OUT VARCHAR2, 
                                      p_workflow_msgr   OUT VARCHAR2);
    
    PROCEDURE cancel_batch_csr(p_batch_csr_id      GICL_BATCH_CSR.batch_csr_id%TYPE,
                               p_advice_id         GICL_ADVICE.advice_id%TYPE,
                               p_claim_id          GICL_ADVICE.claim_id%TYPE,
                               p_user_id           GIIS_USERS.user_id%TYPE);
                               
    PROCEDURE gicls043_c027_post_query(p_ref_id       IN    GICL_BATCH_CSR.ref_id%TYPE,
                                       p_advice_id    IN    GICL_ADVICE.advice_id%TYPE,
                                       p_claim_id     IN    GICL_ADVICE.claim_id%TYPE,
                                       p_claim_no     OUT   VARCHAR2,
                                       p_advice_no    OUT   VARCHAR2,
                                       p_request_no   OUT   VARCHAR2,
                                       p_total_debit  OUT   NUMBER,
                                       p_total_credit OUT   NUMBER);
                                       
    PROCEDURE update_approved_batch_csr(p_batch_csr_id     IN     GICL_BATCH_CSR.batch_csr_id%TYPE,
                                        p_payee_class_cd   IN     GICL_BATCH_CSR.payee_class_cd%TYPE,
                                        p_payee_cd         IN     GICL_BATCH_CSR.payee_cd%TYPE,
                                        p_particulars      IN     GICL_BATCH_CSR.particulars%TYPE,
                                        p_user_id          IN     GICL_BATCH_CSR.user_id%TYPE,
                                        p_tran_id          IN     GICL_BATCH_CSR.tran_id%TYPE,
                                        p_req_dtl_no       IN     GICL_BATCH_CSR.req_dtl_no%TYPE,
                                        p_batch_tag        IN     GICL_BATCH_CSR.batch_flag%TYPE,
                                        p_ref_id           IN     GICL_BATCH_CSR.ref_id%TYPE
                                        );
    FUNCTION get_bcsr_report_id(p_batch_csr_id IN  GICL_BATCH_CSR.batch_csr_id%TYPE,
                                p_iss_cd       IN  GICL_BATCH_CSR.iss_cd%TYPE
                                )
     RETURN VARCHAR2;
     
    FUNCTION get_bcsr_no(p_batch_csr_id GICL_BATCH_CSR.batch_csr_id%TYPE)
      RETURN VARCHAR2; 
    
    TYPE batch_claim_list_type IS RECORD (
        batch_iss_cd            GICL_BATCH_CSR.iss_cd%TYPE,
        batch_year              GICL_BATCH_CSR.batch_year%TYPE,
        batch_fund_cd           GICL_BATCH_CSR.fund_cd%TYPE,
        batch_seq_no            GICL_BATCH_CSR.batch_seq_no%TYPE,
        batch_paid_amt          GICL_BATCH_CSR.paid_amt%TYPE,
        dsp_batch_payee         VARCHAR2(600), --Lara 10/21/2013 - modified max length
        dsp_payee_class_cd      GICL_BATCH_CSR.payee_class_cd%TYPE,
        dsp_payee_cd            GICL_BATCH_CSR.payee_cd%TYPE,
        batch_csr_id            GICL_BATCH_CSR.batch_csr_id%TYPE,
        batch_number            VARCHAR2(50)
    );
       
    TYPE batch_claim_list_tab IS TABLE OF batch_claim_list_type;
   
    FUNCTION get_batch_claim_list (
        p_tran_type            GIAC_DIRECT_CLAIM_PAYTS.transaction_type%TYPE,
        p_line_cd              GICL_ADVICE.line_cd%TYPE,
        p_iss_cd               GICL_ADVICE.iss_cd%TYPE,
        p_advice_year          GICL_ADVICE.advice_year%TYPE,
        p_advice_seq_no        GICL_ADVICE.advice_seq_no%TYPE,
        p_ri_iss_cd            GICL_ADVICE.iss_cd%TYPE,
        p_module_id            GIIS_MODULES.module_id%TYPE,
        p_user_id              GIIS_USERS.user_id%TYPE  
    ) RETURN batch_claim_list_tab PIPELINED;
END gicl_batch_csr_pkg;
/


