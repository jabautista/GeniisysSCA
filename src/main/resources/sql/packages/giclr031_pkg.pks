CREATE OR REPLACE PACKAGE CPI.GICLR031_PKG
IS 
    TYPE giclr031_type IS RECORD(
        claim_id            GICL_CLAIMS.claim_id%TYPE,
        advice_id           GICL_ADVICE.advice_id%TYPE,
        policy_no           VARCHAR2(50),
        claim_no            VARCHAR2(50),
        advice_no           VARCHAR2(50),
        assd_no             GICL_CLAIMS.assd_no%TYPE,
        assured_name        GICL_CLAIMS.assured_name%TYPE,
        assd_name2          GICL_CLAIMS.assd_name2%TYPE,
        name                VARCHAR2(600), --changed by robert from varchar2(200) 10.04.2013
        payee_class_cd      GIIS_PAYEES.payee_class_cd%TYPE,
        payee_cd            GICL_CLM_LOSS_EXP.payee_cd%TYPE,
        acct_of_cd          GICL_CLAIMS.acct_of_cd%TYPE,
        line_cd             GICL_CLAIMS.line_cd%TYPE,
        iss_cd              GICL_CLAIMS.iss_cd%TYPE,
        dsp_loss_date       VARCHAR2(50),
        currency_cd         GICL_ADVICE.currency_cd%TYPE,
        convert_rate        GICL_ADVICE.convert_rate%TYPE,
        final_tag           GICL_CLM_LOSS_EXP.final_tag%TYPE,
        ex_gratia_sw        GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,
        loss_amt            GICL_CLM_LOSS_EXP.net_amt%TYPE,
        exp_amt             GICL_CLM_LOSS_EXP.net_amt%TYPE,
        advise_amt          GICL_CLM_LOSS_EXP.advise_amt%TYPE,
        net_amt             GICL_CLM_LOSS_EXP.net_amt%TYPE,
        paid_amt            GICL_CLM_LOSS_EXP.paid_amt%TYPE,
        net_ret             GICL_LOSS_EXP_DS.shr_le_adv_amt%TYPE,
        facul               GICL_LOSS_EXP_DS.shr_le_adv_amt%TYPE,
        treaty              GICL_LOSS_EXP_DS.shr_le_adv_amt%TYPE,
        remarks             GICL_ADVICE.remarks%TYPE,
     
        title               VARCHAR2(500),
        attention           VARCHAR2(500),
        
        cf_v_sp             VARCHAR2(2000),
        acct_of             VARCHAR2(100),
        term                VARCHAR2(100),
        intm                VARCHAR2(250),
        loss_ctgry          VARCHAR2(250),
        
        loss_exp_cd         GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
        loss_exp_desc       GIIS_LOSS_EXP.loss_exp_desc%TYPE,
        sum_b_dtl_amt       GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
        clm_clmnt_no        GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
        
        vat_label           VARCHAR2(200),
        tax_input           gicl_loss_exp_tax.tax_amt%TYPE,
        tax_others          gicl_loss_exp_tax.tax_amt%TYPE,
        cf_curr             VARCHAR2(50),
        tax_in_adv          gicl_loss_exp_tax.tax_amt%TYPE,
        tax_oth_adv         gicl_loss_exp_tax.tax_amt%TYPE,
        cf_final            VARCHAR(200),
        peril_sname         giis_peril.peril_sname%TYPE,
        peril_paid_amt      gicl_clm_loss_exp.paid_amt%TYPE,
        doc_type_desc       VARCHAR2(200),
        payment_for         VARCHAR2(200),
        doc_no              gicl_loss_exp_bill.doc_number%TYPE,
        label               VARCHAR2(200),
        designation         VARCHAR2(200),
        signatory           VARCHAR2(200),
        show_dist           VARCHAR2(1),
        show_peril          VARCHAR2(1),
        signatory_sw        VARCHAR2(1), -- andrew - 04.18.2012   
		sum_loss			gicl_loss_exp_tax.tax_amt%TYPE -- bonok :: 01.04.2013       
    );
    TYPE giclr031_tab IS TABLE OF giclr031_type;
FUNCTION populate_giclr031(
    p_claim_id      GICL_CLAIMS.claim_id%TYPE,
    p_advice_id     GICL_ADVICE.advice_id%TYPE
    )
    RETURN giclr031_tab PIPELINED;
    
FUNCTION CF_v_spFormula (
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_advice_id        GICL_ADVICE.advice_id%TYPE,
     p_name             VARCHAR2,
     p_ex_gratia_sw     GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,
     p_currency_cd      GICL_CLM_LOSS_EXP.currency_cd%TYPE,
     p_paid_amt         GICL_CLM_LOSS_EXP.paid_amt%TYPE,    
     p_final_tag        GICL_CLM_LOSS_EXP.final_tag%TYPE,
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_payee_cd         GICL_CLM_LOSS_EXP.payee_cd%TYPE
    )
   RETURN VARCHAR2;
   
FUNCTION CF_termFormula ( p_claim_id      GICL_CLAIMS.claim_id%TYPE)
    RETURN VARCHAR2;   
    
FUNCTION CF_intmFormula (p_claim_id     GICL_CLAIMS.claim_id%TYPE)
    RETURN VARCHAR2;    
    
FUNCTION CF_loss_ctgryFormula(
    p_claim_id    GICL_CLAIMS.claim_id%TYPE,
    p_advice_id   GICL_ADVICE.advice_id%TYPE
) 
    RETURN VARCHAR2;  
    
FUNCTION get_clm_loss_exp_desc(
    p_claim_id          GICL_CLAIMS.claim_id%TYPE,
    p_advice_id         GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd    GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE
)
 RETURN  giclr031_tab PIPELINED;  
 
FUNCTION get_clm_loss_exp_desc2( -- bonok :: 01.04.2013
    p_claim_id          GICL_CLAIMS.claim_id%TYPE,
    p_advice_id         GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd    GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE
)
 RETURN  giclr031_tab PIPELINED;    

FUNCTION get_clm_deductibles(
    p_claim_id          GICL_CLAIMS.claim_id%TYPE,
    p_advice_id         GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd    GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE
)
 RETURN  giclr031_tab PIPELINED;

FUNCTION get_tax_input(
    p_claim_id      GICL_CLAIMS.claim_id%TYPE,
    p_advice_id     GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
    p_payee_cd         GICL_CLM_LOSS_EXP.payee_cd%TYPE)
 RETURN NUMBER; 

FUNCTION get_tax_others(
    p_claim_id      GICL_CLAIMS.claim_id%TYPE,
    p_advice_id     GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
    p_payee_cd         GICL_CLM_LOSS_EXP.payee_cd%TYPE)
 RETURN NUMBER;

FUNCTION get_tax_oth_adv(
    p_claim_id         GICL_CLAIMS.claim_id%TYPE,
    p_advice_id        GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
    p_payee_cd         GICL_CLM_LOSS_EXP.payee_cd%TYPE)
 RETURN NUMBER;
 
FUNCTION get_tax_in_adv(
    p_claim_id         GICL_CLAIMS.claim_id%TYPE,
    p_advice_id        GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
    p_payee_cd         GICL_CLM_LOSS_EXP.payee_cd%TYPE)
 RETURN NUMBER;

FUNCTION CF_finalFormula (
    p_claim_id      GICL_CLAIMS.claim_id%TYPE,
    p_advice_id     GICL_ADVICE.advice_id%TYPE,
    p_name          VARCHAR2,
    p_ex_gratia_sw  GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,
    p_final_tag        GICL_CLM_LOSS_EXP.final_tag%TYPE
)
 RETURN VARCHAR2;   
 
FUNCTION get_clm_perils(
    p_claim_id      GICL_CLAIMS.claim_id%TYPE,
    p_advice_id     GICL_ADVICE.advice_id%TYPE,
    p_line_cd       GICL_ADVICE.line_cd%TYPE
)
  RETURN giclr031_tab PIPELINED;  
  
FUNCTION get_payment_dtls(
    p_claim_id           GICL_CLAIMS.claim_id%TYPE,
    p_advice_id          GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd     GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_cd           GICL_CLM_LOSS_EXP.payee_cd%TYPE
)
  RETURN giclr031_tab PIPELINED;
  
FUNCTION get_g_report_no2(
    p_line_cd       GIIS_LINE.line_cd%TYPE,
    p_branch_cd     GICL_CLAIMS.iss_cd%TYPE,
    p_user          GIIS_USERS.user_id%TYPE
)
  RETURN giclr031_tab PIPELINED;  
  
FUNCTION get_g_label(
    p_line_cd       GIIS_LINE.line_cd%TYPE,
    p_branch_cd     GICL_CLAIMS.iss_cd%TYPE
)
  RETURN giclr031_tab PIPELINED;  
  
FUNCTION get_g_report_no1(
    p_line_cd       GIIS_LINE.line_cd%TYPE,
    p_branch_cd     GICL_CLAIMS.iss_cd%TYPE,
    p_user          GIIS_USERS.user_id%TYPE
)
  RETURN giclr031_tab PIPELINED;

FUNCTION show_dist(p_line_cd     GICL_CLAIMS.line_cd%TYPE)
  RETURN VARCHAR2;

FUNCTION show_peril(p_line_cd     GICL_CLAIMS.line_cd%TYPE)
  RETURN VARCHAR2;    
  
END;
/


