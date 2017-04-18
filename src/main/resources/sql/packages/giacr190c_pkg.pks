CREATE OR REPLACE PACKAGE CPI.GIACR190C_PKG
AS

    TYPE report_details_type IS RECORD(
        cf_beginning_text   varchar2(500),
        cf_end_text         varchar2(500),
        cf_designation      varchar2(100),
        cf_signatory        varchar2(100),
        assd_no             number,
        cf_assd_address1    varchar2(100),
        cf_assd_address2    varchar2(100),
        cf_assd_address3    varchar2(100),
        assd_name           giac_soa_rep_ext.ASSD_NAME%type,
        cf_property         gipi_invoice.property%TYPE,
        cf_intm_name        giac_soa_rep_ext.INTM_NAME%type,
        cf_policy_no        varchar2(50),
        policy_no           varchar2(50),
        cf_expiry_date      gipi_polbasic.EXPIRY_DATE%type,
        cf_inv_date         gipi_polbasic.ISSUE_DATE%type,
        cf_endt             varchar2(20),
        print_cf_endt       varchar2(1),
        cf_incept_date      gipi_polbasic.INCEPT_DATE%type,
        intm_name           giac_soa_rep_ext.INTM_NAME%type,
        cf_invoice_no       varchar2(40),  
        prem_seq_no         giac_soa_rep_ext.PREM_SEQ_NO%type,
        prem_bal_due        giac_soa_rep_ext.PREM_BAL_DUE%type,
        tax_bal_due         giac_soa_rep_ext.TAX_BAL_DUE%type,
        balance_amt_due     giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        intm_no             giac_soa_rep_ext.INTM_NO%type,
        iss_cd              giac_soa_rep_ext.ISS_CD%type,
        inst_no             giac_soa_rep_ext.INST_NO%type,
        cf_aging_id         varchar2(40), --CF_1 in RDF
        endt_no             varchar2(30),
        policy              varchar2(50)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    PROCEDURE CF_TEXT (
        p_beginning_text    OUT VARCHAR2,
        p_end_text          OUT VARCHAR2
    );
    
    
    FUNCTION CF_DESIGNATION(
        p_policy_no     VARCHAR2
    ) RETURN VARCHAR2;
        
       
    FUNCTION CF_SIGNATORY (
        p_policy_no     VARCHAR2
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_ASSD_ADDRESS1(
        p_assd_no   NUMBER
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_ASSD_ADDRESS2(
        p_assd_no   NUMBER
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_ASSD_ADDRESS3(
        p_assd_no   NUMBER
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_PROPERTY(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_INTM_NAME(
        p_assd_no   NUMBER,
        p_policy_no VARCHAR2
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_POLICY_NO(
        p_policy_no VARCHAR2
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_EXPIRY_DATE(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER
    ) RETURN DATE;
    
    
    FUNCTION CF_INV_DATE(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER
    ) RETURN DATE;
    
    
    FUNCTION CF_ENDT(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_INCEPT_DATE(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER
    ) RETURN DATE;
    
    
    FUNCTION CF_INVOICE_NO(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_inst_no       NUMBER,
        p_assd_no       NUMBER
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_AGING_ID(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_assd_no       NUMBER
    ) RETURN VARCHAR2;
    
        
    FUNCTION get_report_details(
        p_selected_intm_no  VARCHAR2, 
        p_selected_assd_no  VARCHAR2,
        p_selected_aging_id VARCHAR2, -- giac_soa_rep_ext.AGING_ID%type,
        p_user              giac_soa_rep_ext.USER_ID%type,
        p_print_btn_no      NUMBER
    ) RETURN report_details_tab PIPELINED;

END GIACR190C_PKG;
/


