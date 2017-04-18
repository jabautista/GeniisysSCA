CREATE OR REPLACE PACKAGE CPI.GIRIR036_PKG
AS

    TYPE report_details_type IS RECORD(
        company_name            GIIS_PARAMETERS.PARAM_VALUE_V%TYPE,
        company_address         GIIS_PARAMETERS.PARAM_VALUE_V%TYPE,
        cf_salutation           giis_document.TEXT%type,
        cf_text1                giis_document.TEXT%type,
        cf_text2                giis_document.TEXT%type,
        cf_text3                giis_document.TEXT%type,
        cf_doc_dept_designation giis_document.TEXT%type,
        ri_cd                   GIRI_BINDER.RI_CD%TYPE,
        fnl_binder_id           GIRI_BINDER.FNL_BINDER_ID%TYPE,
        line_cd                 GIRI_FRPS_RI.LINE_CD%TYPE,
        assd_name               GIIS_ASSURED.ASSD_NAME%TYPE,
        ri_cd2                  GIRI_BINDER.RI_CD%TYPE,
        ri_name                 GIIS_REINSURER.RI_NAME%TYPE,
        fnl_binder_id2          GIRI_BINDER.FNL_BINDER_ID%TYPE,
        line_cd2                GIRI_BINDER.LINE_CD%TYPE,
        line_name               GIIS_LINE.LINE_NAME%TYPE,
        mail_address1           GIIS_REINSURER.MAIL_ADDRESS1%TYPE,
        mail_address2           GIIS_REINSURER.MAIL_ADDRESS2%TYPE,
        mail_address3           GIIS_REINSURER.MAIL_ADDRESS3%TYPE,
        policy_no               VARCHAR2(35),
        endt_no                 VARCHAR2(15),
        endt_seq_no             GIPI_POLBASIC.ENDT_SEQ_NO%TYPE,
        binder_date             GIRI_BINDER.BINDER_DATE%TYPE,
        binder_number           VARCHAR2(15)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
      
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
        
    FUNCTION CF_SALUTATION
        RETURN VARCHAR2;
        
        
    FUNCTION CF_TEXT1
        RETURN VARCHAR2;
    
    
    FUNCTION CF_TEXT2
        RETURN VARCHAR2;
        
        
    FUNCTION CF_TEXT3
        RETURN VARCHAR2;
        
        
    FUNCTION CF_DOC_DEPT_DESIGNATION
        RETURN VARCHAR2;
        
    
    FUNCTION get_report_details (
        p_ri_cd         GIRI_BINDER.RI_CD%TYPE,
        p_line_cd       GIRI_BINDER.LINE_CD%TYPE,
        p_from_date     GIRI_BINDER.BINDER_DATE%TYPE,
        p_to_date       GIRI_BINDER.BINDER_DATE%TYPE
    ) RETURN report_details_tab PIPELINED;
    

END GIRIR036_PKG;
/


