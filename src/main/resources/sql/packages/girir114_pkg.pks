CREATE OR REPLACE PACKAGE CPI.GIRIR114_PKG
AS

    TYPE report_details_type IS RECORD (
        company_name            giis_parameters.param_name%TYPE,
        company_address         VARCHAR2(500),
        paramdate               VARCHAR2(100),
        cf_text1                giis_document.text%TYPE,
        cf_text2                giis_document.text%TYPE,
        cf_sign_name            giis_parameters.param_value_v%TYPE,
        cf_sign_position        giis_parameters.param_value_v%TYPE,
        ri_cd                   gixx_inw_tran.RI_CD%type,
        ri_name                 giis_reinsurer.RI_NAME%type,
        mail_address1           giis_reinsurer.MAIL_ADDRESS1%type,
        mail_address2           giis_reinsurer.MAIL_ADDRESS2%type,
        mail_address3           giis_reinsurer.MAIL_ADDRESS3%type,
        line_cd                 gixx_inw_tran.LINE_CD%type,
        cf_line_name            giis_line.LINE_NAME%type,
        extract_id              gixx_inw_tran.EXTRACT_ID%type,
        policy_no               gixx_inw_tran.POLICY_NO%type,
        ri_policy_no            gixx_inw_tran.RI_POLICY_NO%type,
        orig_tsi_amt            gixx_inw_tran.ORIG_TSI_AMT%type,
        our_tsi_amt             gixx_inw_tran.OUR_TSI_AMT%type,
        accept_date             gixx_inw_tran.ACCEPT_DATE%type,
        expiry_date             gixx_inw_tran.EXPIRY_DATE%type,
        assd_no                 gixx_inw_tran.ASSD_NO%type,
        cf_assd_name            giis_assured.ASSD_NAME%type        
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
     
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
    
    FUNCTION CF_TEXT1
        RETURN VARCHAR2;
     
    
    FUNCTION CF_TEXT2
        RETURN VARCHAR2; 
    
    
    FUNCTION CF_SIGN_NAME
        RETURN VARCHAR2;
        
     
    FUNCTION CF_SIGN_POSITION
        RETURN VARCHAR2;
        
        
    FUNCTION CF_LINE_NAME(
        p_line_cd   GIXX_INW_TRAN.LINE_CD%TYPE
     ) RETURN VARCHAR2;
     
    
    FUNCTION CF_ASSD_NAME(
        p_assd_no   GIXX_INW_TRAN.ASSD_NO%TYPE
     ) RETURN VARCHAR2;
       
    
    FUNCTION get_report_details(
        p_extract_id    gixx_inw_tran.EXTRACT_ID%type,
        p_month         varchar2,
        p_year          number
    ) RETURN report_details_tab PIPELINED;
    

END GIRIR114_PKG;
/


