CREATE OR REPLACE PACKAGE CPI.GIACS214_PKG
AS
    TYPE polbasic_type IS RECORD(
        policy_id           GIPI_POLBASIC.POLICY_ID%type,
        line_cd             GIPI_POLBASIC.LINE_CD%type,
        subline_cd          GIPI_POLBASIC.SUBLINE_CD%type,
        iss_cd              GIPI_POLBASIC.ISS_CD%type,
        issue_yy            GIPI_POLBASIC.ISSUE_YY%type,
        pol_seq_no          GIPI_POLBASIC.POL_SEQ_NO%type,
        endt_iss_cd         GIPI_POLBASIC.ENDT_ISS_CD%type,
        endt_yy             GIPI_POLBASIC.ENDT_YY%type,
        endt_seq_no         GIPI_POLBASIC.ENDT_SEQ_NO%type,
        endt_type           GIPI_POLBASIC.ENDT_TYPE%type,
        ref_pol_no          GIPI_POLBASIC.REF_POL_NO%type,
        assd_no             GIPI_POLBASIC.ASSD_NO%type,
        assd_name           GIIS_ASSURED.ASSD_NAME%type
    );
    
    TYPE polbasic_tab IS TABLE OF polbasic_type;
    
    FUNCTION get_polbasic_list(
        p_assd_no       GIPI_POLBASIC.ASSD_NO%type,
        p_user_id       VARCHAR2
    ) RETURN polbasic_tab PIPELINED;
    
    
    TYPE invoice_type IS RECORD(
        policy_id               GIPI_INVOICE.POLICY_ID%type,
        iss_cd                  GIPI_INVOICE.ISS_CD%type,
        prem_seq_no             GIPI_INVOICE.PREM_SEQ_NO%type,
        nbt_policy_no           VARCHAR2(70),
        dsp_assd_name           GIIS_ASSURED.ASSD_NAME%type,
        dsp_iss_prem_seq        VARCHAR2(30),
        dsp_balance_amt_due     giac_aging_soa_details.BALANCE_AMT_DUE%type,
        dsp_prem_balance_due    giac_aging_soa_details.PREM_BALANCE_DUE%type,
        dsp_tax_balance_due     giac_aging_soa_details.TAX_BALANCE_DUE%type,
        dsp_currency            GIIS_CURRENCY.CURRENCY_DESC%type,
        dsp_currency_rt         GIIS_CURRENCY.CURRENCY_RT%type
    );
    
    TYPE invoice_tab IS TABLE OF invoice_type;
    
    FUNCTION get_invoice_list(
        p_policy_id     GIPI_INVOICE.POLICY_ID%type
    ) RETURN invoice_tab PIPELINED;
    
    
    TYPE aging_soa_type IS RECORD(
        a020_assd_no        GIAC_AGING_SOA_DETAILS.A020_ASSD_NO%type,
        iss_cd              GIAC_AGING_SOA_DETAILS.ISS_CD%type,
        prem_seq_no         GIAC_AGING_SOA_DETAILS.PREM_SEQ_NO%type,
        dsp_iss_prem_seq    VARCHAR2(30),
        dsp_currency        GIIS_CURRENCY.CURRENCY_DESC%type,
        dsp_currency_rt     GIIS_CURRENCY.CURRENCY_RT%type,
        inst_no             GIAC_AGING_SOA_DETAILS.INST_NO%type,
        total_amount_due    GIAC_AGING_SOA_DETAILS.TOTAL_AMOUNT_DUE%type,
        total_payments      GIAC_AGING_SOA_DETAILS.TOTAL_PAYMENTS%type,
        tax_balance_due     GIAC_AGING_SOA_DETAILS.TAX_BALANCE_DUE%type,
        balance_amt_due     GIAC_AGING_SOA_DETAILS.BALANCE_AMT_DUE%type,
        prem_balance_due    GIAC_AGING_SOA_DETAILS.PREM_BALANCE_DUE%type
    );
    
    TYPE aging_soa_tab IS TABLE OF aging_soa_type;
    
    FUNCTION get_aging_soa_details(
        p_assd_no           GIPI_POLBASIC.ASSD_NO%type
    ) RETURN aging_soa_tab PIPELINED;

END GIACS214_PKG;
/


