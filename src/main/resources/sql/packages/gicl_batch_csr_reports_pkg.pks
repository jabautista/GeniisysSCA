CREATE OR REPLACE PACKAGE CPI.GICL_BATCH_CSR_REPORTS_PKG AS

    TYPE giclr043_report_type IS RECORD(
     f_title              VARCHAR2(100),
     f_csr_attn           VARCHAR2(100),
     f_batch_csr_id       GICL_BATCH_CSR.batch_csr_id%TYPE,
     f_v_sp               VARCHAR2(2000),
     f_settlement_remarks VARCHAR2(200),
     f_net_amt            NUMBER,
	 f_gross_amt          NUMBER, -- added by: Nica 02.13.2013
     f_sum_paid_amt       NUMBER,
     f_sum_net_ret        NUMBER,
     f_sum_treaty         NUMBER,
     f_sum_facul          NUMBER,
     f_currency_cd        GIIS_CURRENCY.main_currency_cd%TYPE,
     f_short_name         GIIS_CURRENCY.short_name%TYPE,
     rv_print_logo        VARCHAR2(1) := 'N',
     rv_print_payees      VARCHAR2(1) := 'Y',
     rv_print_signatory   VARCHAR2(1) := 'Y'
    );
    
    TYPE giclr043_report_tab IS TABLE OF giclr043_report_type;
    
    TYPE giclr044_report_type IS RECORD(
     f_title              VARCHAR2(100),
     f_csr_attn           VARCHAR2(100),
     f_batch_csr_id       GICL_BATCH_CSR.batch_csr_id%TYPE,
     f_bcsr_no            VARCHAR2(50),
     f_v_sp               VARCHAR2(2000),
     f_settlement_remarks VARCHAR2(200),
     f_net_amt            NUMBER,
	 f_gross_amt          NUMBER, -- added by: Nica 02.13.2013
     f_sum_paid_amt       NUMBER,
     f_sum_net_ret        NUMBER,
     f_sum_treaty         NUMBER,
     f_sum_facul          NUMBER,
     f_currency_cd        GIIS_CURRENCY.main_currency_cd%TYPE,
     f_short_name         GIIS_CURRENCY.short_name%TYPE,
     rv_print_logo        VARCHAR2(1) := 'N',
     rv_print_payees      VARCHAR2(1) := 'Y',
     rv_print_signatory   VARCHAR2(1) := 'Y'
    );
    
    TYPE giclr044_report_tab IS TABLE OF giclr044_report_type;
    
    TYPE giclr044B_report_type IS RECORD(
     claim_id            GICL_CLAIMS.claim_id%TYPE,
     tran_id             GICL_BATCH_CSR.tran_id%TYPE,
     line_cd             GICL_CLAIMS.line_cd%TYPE,
     claim_no            VARCHAR2(40),
     policy_no           VARCHAR2(40),
     assured_name        GICL_CLAIMS.assured_name%TYPE,
     intermdiary       	 VARCHAR2(250),
     peril_cd            GICL_CLM_LOSS_EXP.peril_cd%TYPE,
     peril_sname         GIIS_PERIL.peril_sname%TYPE,
     paid_amt            GICL_CLM_LOSS_EXP.paid_amt%TYPE,
     bcsr_no             VARCHAR2(50),
     particulars         GIAC_PAYT_REQUESTS_DTL.particulars%TYPE
    );
    
    TYPE giclr044B_report_tab IS TABLE OF giclr044B_report_type;
    
    TYPE batch_csr_dtl_type IS RECORD(
     policy_no           VARCHAR2(40),
     assured_name        GICL_CLAIMS.assured_name%TYPE,
     dsp_loss_date       GICL_CLAIMS.dsp_loss_date%TYPE,
     claim_no            VARCHAR2(40),
     payee_class_cd      GICL_BATCH_CSR.payee_class_cd%TYPE,
     payee_cd            GICL_BATCH_CSR.payee_cd%TYPE,
     advise_amt          NUMBER,
     net_amt             NUMBER,
     paid_amt            NUMBER,
     batch_csr_id        GICL_BATCH_CSR.batch_csr_id%TYPE,
     convert_rate        GICL_BATCH_CSR.convert_rate%TYPE,
     currency_cd         GICL_BATCH_CSR.currency_cd%TYPE,
     claim_id            GICL_CLAIMS.claim_id%TYPE,
     advice_id           GICL_ADVICE.advice_id%TYPE,
     clm_loss_id         GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     clm_clmnt_no        GICL_CLM_LOSS_EXP.clm_clmnt_no%TYPE              
    );
    
    TYPE batch_csr_dtl_tab IS TABLE OF batch_csr_dtl_type;
    
    TYPE batch_csr_claim_type IS RECORD(
     advice_id           GICL_ADVICE.advice_id%TYPE,
     claim_id            GICL_CLAIMS.claim_id%TYPE,
     line_cd             GICL_CLAIMS.line_cd%TYPE,
     subline_cd          GICL_CLAIMS.subline_cd%TYPE,
     pol_iss_cd          GICL_CLAIMS.pol_iss_cd%TYPE,
     issue_yy            GICL_CLAIMS.issue_yy%TYPE,
     pol_seq_no          GICL_CLAIMS.pol_seq_no%TYPE,
     renew_no            GICL_CLAIMS.renew_no%TYPE,
     iss_cd              GICL_CLAIMS.iss_cd%TYPE,
     clm_yy              GICL_CLAIMS.clm_yy%TYPE,
     clm_seq_no          GICL_CLAIMS.clm_seq_no%TYPE,
     batch_csr_id        GICL_ADVICE.batch_csr_id%TYPE,
     assured_name        GICL_CLAIMS.assured_name%TYPE,
     dsp_loss_date       GICL_CLAIMS.dsp_loss_date%TYPE,
     paid_amt            NUMBER,
     policy_no           VARCHAR2(40),
     claim_no            VARCHAR2(40),
     intermdiary       	 VARCHAR2(250),
     loss_cat_des	     VARCHAR2(500) --from 100 to 500 to fix ORA-06502 - Halley 11.06.13
    );
    
    TYPE batch_csr_claim_tab IS TABLE OF batch_csr_claim_type;
    
    TYPE batch_csr_payee_type IS RECORD (
     class_desc          GIIS_PAYEE_CLASS.class_desc%TYPE,
     payee_last_name     GIIS_PAYEES.payee_last_name%TYPE,
     doc_number          GICL_LOSS_EXP_BILL.doc_number%TYPE,
     doc_type            GICL_LOSS_EXP_BILL.doc_type%TYPE,
     claim_id            GICL_LOSS_EXP_BILL.claim_id%TYPE,
     payee_cd            GICL_LOSS_EXP_BILL.payee_cd%TYPE,
     payee_class_cd      GICL_LOSS_EXP_BILL.payee_class_cd%TYPE,
     claim_loss_id       GICL_LOSS_EXP_BILL.claim_loss_id%TYPE,
     bill_title          VARCHAR2(50)
    );
    
    TYPE batch_csr_payee_tab IS TABLE OF batch_csr_payee_type;
    
    TYPE batch_csr_signatory_type IS RECORD(
     report_no          GIAC_DOCUMENTS.report_no%TYPE,
     item_no            GIAC_REP_SIGNATORY.item_no%TYPE,
     label              GIAC_REP_SIGNATORY.label%TYPE,
     signatory          GIIS_SIGNATORY_NAMES.signatory%TYPE,
     designation        GIIS_SIGNATORY_NAMES.designation%TYPE
    );
    
    TYPE batch_csr_signatory_tab IS TABLE OF batch_csr_signatory_type;
	
	TYPE batch_csr_tax_type IS RECORD(
     batch_csr_id       GICL_BATCH_CSR.batch_csr_id%TYPE,
	 b_tax_amt			NUMBER,
	 w_tax				GICL_LOSS_EXP_TAX.w_tax%TYPE
    );
	
	TYPE batch_csr_tax_tab IS TABLE OF batch_csr_tax_type;
    
    FUNCTION get_giclr043_rep_dtls (p_batch_csr_id  GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN giclr043_report_tab PIPELINED;
    
    FUNCTION get_giclr043_claim_list (p_batch_csr_id  GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN batch_csr_claim_tab PIPELINED;
     
    FUNCTION get_batch_csr_dtl (p_batch_csr_id   GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN batch_csr_dtl_tab PIPELINED;
	 
	FUNCTION get_batch_csr_vat (p_batch_csr_id   GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN batch_csr_tax_tab PIPELINED;
     
    FUNCTION get_batch_csr_payees(p_claim_id    GICL_LOSS_EXP_BILL.claim_id%TYPE)
     RETURN batch_csr_payee_tab PIPELINED;
     
    FUNCTION get_batch_csr_intm(p_claim_id   GICL_CLAIMS.claim_id%TYPE)
     RETURN VARCHAR2;
     
    FUNCTION get_batch_csr_loss_ctgry(p_line_cd      GICL_CLAIMS.line_cd%TYPE,
                                     p_claim_id     GICL_CLAIMS.claim_id%TYPE,
                                     p_advice_id    GICL_ADVICE.advice_id%TYPE) 
     RETURN VARCHAR2;
     
     FUNCTION get_v_sp (p_batch_csr_id IN  GICL_BATCH_CSR.batch_csr_id%TYPE,
                        p_currency_cd  IN  GIIS_CURRENCY.main_currency_cd%TYPE,
                        p_sum_paid_amt IN  NUMBER,
                        p_sum_net_ret  IN  NUMBER ) 
     RETURN VARCHAR2;
     
     FUNCTION get_giclr043_signatory(p_report_id    IN  GIAC_DOCUMENTS.report_id%TYPE,
                                     p_line_cd      IN  GIAC_DOCUMENTS.line_cd%TYPE,
                                     p_branch_cd    IN  GIAC_DOCUMENTS.branch_cd%TYPE,
                                     p_user_id      IN  GIIS_USERS.user_id%TYPE,
                                     p_batch_csr_id IN  GICL_BATCH_CSR.batch_csr_id%TYPE)   -- added by nante 12/18/2013
      RETURN batch_csr_signatory_tab PIPELINED;
    
    FUNCTION spell_amount(v_payt_amt NUMBER)
     RETURN VARCHAR2;
     
    FUNCTION get_giclr044_rep_dtls (p_batch_csr_id  GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN giclr044_report_tab PIPELINED;
     
    FUNCTION get_giclr044_claim_list (p_batch_csr_id  GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN batch_csr_claim_tab PIPELINED;
     
    FUNCTION get_giclr044B_rep_dtls (p_batch_csr_id  GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN giclr044B_report_tab PIPELINED;

END GICL_BATCH_CSR_REPORTS_PKG;
/


