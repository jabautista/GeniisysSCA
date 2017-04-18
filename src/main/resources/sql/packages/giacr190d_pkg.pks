CREATE OR REPLACE PACKAGE CPI.GIACR190D_PKG
AS

    TYPE report_details_type IS RECORD(
        assd_no             giac_soa_rep_ext.ASSD_NO%type,
        assd_name           giac_soa_rep_ext.ASSD_NAME%type, 
        cf_assd_address1    varchar2(100),
        cf_assd_address2    varchar2(100),
        cf_assd_address3    varchar2(100),
        cf_cutoff_date      date,
        cf_cutoff_date2     varchar2(30),
        intm_no             giac_soa_rep_ext.INTM_NO%type,
        intm_name           giac_soa_rep_ext.INTM_NAME%type,
        cf_intm_no          giac_soa_rep_ext.INTM_NO%type,
        cf_intm_name        giac_soa_rep_ext.INTM_NAME%type,
        cf_property         gipi_invoice.property%TYPE,
        cf_incept_date      gipi_polbasic.INCEPT_DATE%type,
        cf_expiry_date      gipi_polbasic.EXPIRY_DATE%type,
        policy              giac_soa_rep_ext.POLICY_NO%type,
        policy_no           varchar2(50),
        cf_policy_no        varchar2(30), --varchar2(20),
        endt_no             varchar2(30), --varchar2(20),
        cf_inv_date         gipi_polbasic.ISSUE_DATE%type,
        cf_endt             varchar2(20),
        cf_invoice_no       varchar2(40),
        iss_cd              giac_soa_rep_ext.ISS_CD%type,
        inst_no             giac_soa_rep_ext.INST_NO%type,
        cf_aging_id         varchar2(40),
        prem_seq_no         giac_soa_rep_ext.PREM_SEQ_NO%type,
        prem_bal_due        giac_soa_rep_ext.PREM_BAL_DUE%type,
        tax_bal_due         giac_soa_rep_ext.TAX_BAL_DUE%type,
        balance_amt_due     giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        cf_designation      varchar2(100),
        cf_signatory        varchar2(100)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_ASSD_ADDRESS1(
        p_assd_no       GIIS_ASSURED.ASSD_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_ASSD_ADDRESS2(
        p_assd_no       GIIS_ASSURED.ASSD_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_ASSD_ADDRESS3(
        p_assd_no       GIIS_ASSURED.ASSD_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_CUTOFF_DATE(
        p_assd_no   GIAC_SOA_REP_EXT.ASSD_NO%TYPE,
        p_user      GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN DATE;
    
    
    FUNCTION CF_INTM_NO(
        p_assd_no       giac_soa_rep_ext.ASSD_NO%TYPE,
        p_policy_no     giac_soa_rep_ext.POLICY_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_INTM_NAME(
        p_assd_no       giac_soa_rep_ext.ASSD_NO%TYPE,
        p_policy_no     giac_soa_rep_ext.POLICY_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_PROPERTY(
        p_iss_cd        GIPI_INVOICE.ISS_CD%TYPE,
        p_prem_seq_no   GIPI_INVOICE.PREM_SEQ_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_INCEPT_DATE(
        p_iss_cd        GIPI_INVOICE.ISS_CD%TYPE,
        p_prem_seq_no   GIPI_INVOICE.PREM_SEQ_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_EXPIRY_DATE(
        p_iss_cd        GIPI_INVOICE.ISS_CD%TYPE,
        p_prem_seq_no   GIPI_INVOICE.PREM_SEQ_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_POLICY_NO(
        p_policy_no     VARCHAR2
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_INV_DATE(
        p_iss_cd        GIPI_INVOICE.ISS_CD%TYPE,
        p_prem_seq_no   GIPI_INVOICE.PREM_SEQ_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_ENDT(
        p_iss_cd        GIPI_INVOICE.ISS_CD%TYPE,
        p_prem_seq_no   GIPI_INVOICE.PREM_SEQ_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_INVOICE_NO(
        p_iss_cd        giac_soa_rep_ext.ISS_CD%type,
        p_prem_seq_no   giac_soa_rep_ext.PREM_SEQ_NO%type,
        p_inst_no       giac_soa_rep_ext.INST_NO%type,
        p_assd_no       giac_soa_rep_ext.ASSD_NO%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_AGING_ID(
        p_assd_no       GIAC_SOA_REP_EXT.ASSD_NO%TYPE,
        p_iss_cd        GIAC_SOA_REP_EXT.ISS_CD%TYPE,
        p_prem_seq_no   GIAC_SOA_REP_EXT.PREM_SEQ_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_DESIGNATION(
        p_policy_no     VARCHAR2
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_SIGNATORY(
        p_policy_no     VARCHAR2
    ) RETURN VARCHAR2;
    
    
    FUNCTION GET_REPORT_DETAILS(
        p_assd_no               giac_soa_rep_ext.ASSD_NO%type,
        p_selected_aging_id     VARCHAR2,
        p_user                  VARCHAR2
    ) RETURN report_details_tab PIPELINED;


END GIACR190D_PKG;
/


