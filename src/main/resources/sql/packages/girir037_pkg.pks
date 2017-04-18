CREATE OR REPLACE PACKAGE CPI.GIRIR037_PKG
AS
    
    TYPE report_details_type IS RECORD(
        company_name            GIIS_PARAMETERS.PARAM_VALUE_V%TYPE,
        print_comp_name         VARCHAR2(1),
        company_address         GIIS_PARAMETERS.PARAM_VALUE_V%TYPE,
        print_comp_addr         VARCHAR2(1),
        cf_salutation           giis_document.TEXT%type,
        cf_text1                giis_document.TEXT%type,
        cf_text2                giis_document.TEXT%type,
        cf_text3                giis_document.TEXT%type,
        cf_doc_dept_designation giis_document.TEXT%type,
        ri_cd                   GIRI_INPOLBAS.RI_CD%type,
        ri_name                 GIIS_REINSURER.RI_NAME%type,
        mail_address1           GIIS_REINSURER.MAIL_ADDRESS1%type,
        mail_address2           GIIS_REINSURER.MAIL_ADDRESS2%type,
        mail_address3           GIIS_REINSURER.MAIL_ADDRESS3%type,
        line_cd                 GIPI_POLBASIC.LINE_CD%type,
        line_name               GIIS_LINE.LINE_NAME%type,
        assd_name               GIIS_ASSURED.ASSD_NAME%type,
        ri_policy_no            GIRI_INPOLBAS.RI_POLICY_NO%type,  
        ri_endt_no              GIRI_INPOLBAS.RI_ENDT_NO%type,
        cf_ri_policy_endt       VARCHAR2(50),
        accept_no               GIRI_INPOLBAS.ACCEPT_NO%type,
        term                    VARCHAR2(20),
        no_of_days              NUMBER(6),
        accept_date             GIRI_INPOLBAS.ACCEPT_DATE%type,               
        amount_offered          NUMBER(16,2),     
        print_fields            VARCHAR2(1),     -- date_accepted, no_of_days, and remarks (M_19 header) (M_21 columns) format trigger
        exist                   VARCHAR2(1)
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
        
    
    FUNCTION get_report_details(
        p_ri_cd                 GIRI_INPOLBAS.RI_CD%type,
        p_line_cd               GIPI_POLBASIC.LINE_CD%type,
        p_oar_print_date        VARCHAR2,
        p_date_sw               VARCHAR2,
        p_morethan              NUMBER,
        p_lessthan              NUMBER
    ) RETURN report_details_tab PIPELINED;
    

END GIRIR037_PKG;
/


