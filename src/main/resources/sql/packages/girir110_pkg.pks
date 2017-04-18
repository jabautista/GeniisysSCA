CREATE OR REPLACE PACKAGE CPI.GIRIR110_PKG
AS

    TYPE report_details_type IS RECORD(
        company_name            giis_parameters.param_name%TYPE,
        company_address         VARCHAR2(500),
        print_letterhead        VARCHAR2(1),
        paramdate               VARCHAR2(100),
        ri_cd                   GIIS_REINSURER.RI_CD%type,  
        ri_name                 GIIS_REINSURER.RI_NAME%type,
        line_cd                 GIPI_POLBASIC.LINE_CD%type,
        line_name               GIIS_LINE.LINE_NAME%type,
        bill_address12          GIIS_REINSURER.BILL_ADDRESS1%type,
        bill_address23          GIIS_REINSURER.BILL_ADDRESS2%type,
        bill_address34          GIIS_REINSURER.BILL_ADDRESS3%type,
        issue_date              varchar2(20),      
        cf_opening_paragraph    giis_document.text%TYPE,            
        cf_ending_paragraph     giis_document.text%TYPE,
        cf_ending_date          varchar2(200),
        cf_confirmation         giis_document.text%TYPE,
        cf_auth_sig             giis_document.text%type,
        attention               GIIS_REINSURER.ATTENTION%type,
        cf_status               varchar2(1),
        prem_amt                GIPI_INVOICE.PREM_AMT%type,
        expiry_date             varchar2(20),
        policy_no               varchar(100),
        dist_no                 GIUW_POL_DIST.DIST_NO%type,
        endt_seq_no             GIPI_POLBASIC.ENDT_SEQ_NO%type,
        endt_no                 varchar2(60),
        confirm_no              GIRI_BINDER.CONFIRM_NO%type,
        incept_date             GIPI_POLBASIC.INCEPT_DATE%type,
        sum_insured             GIRI_DISTFRPS.TSI_AMT%type,
        frps_ri_remarks         GIRI_FRPS_RI.REMARKS%type,
        policy_id               GIPI_POLBASIC.POLICY_ID%type,
        assured                 GIIS_ASSURED.ASSD_NAME%type,
        cf_location             varchar2(200),
        assured_address         GIIS_ASSURED.MAIL_ADDR3%type,
        frps_seq_no             GIRI_DISTFRPS.FRPS_SEQ_NO%type,
        tsi                     GIPI_POLBASIC.TSI_AMT%type,
        d050_ri_cd              GIRI_FRPS_RI.RI_CD%type,
        pct_accepted            GIRI_BINDER.RI_SHR_PCT%type,
        binder                  VARCHAR2(50), 
        binder_tsi              GIRI_BINDER.RI_TSI_AMT%type,                
        ri_share                GIRI_FRPS_RI.RI_TSI_AMT%type,
        currency_cd             GIIS_CURRENCY.MAIN_CURRENCY_CD%type,
        currency_desc           GIIS_CURRENCY.CURRENCY_DESC%type,
        print_fields            VARCHAR2(1),
        show_summarized_policy  VARCHAR2(1)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
    
    FUNCTION CF_OPENING_PARAGRAPH
        RETURN VARCHAR2;
        
        
    FUNCTION CF_ENDING_PARAGRAPH
        RETURN VARCHAR2;
        
        
    FUNCTION CF_ENDING_DATE
        RETURN VARCHAR2;
        
       
    FUNCTION CF_CONFIRMATION
        RETURN VARCHAR2;
        
        
    FUNCTION CF_AUTH_SIG
        RETURN VARCHAR2;
        
        
    FUNCTION CF_STATUS(
        p_policy_id     gipi_invoice.POLICY_ID%TYPE
    ) RETURN VARCHAR2;
     
    
    FUNCTION CF_LOCATION(
        p_policy_id         gipi_vehicle.POLICY_ID%TYPE,
        p_line_name         GIIS_LINE.LINE_NAME%TYPE,
        p_line_cd           gipi_polbasic.LINE_CD%TYPE,
        p_assured_address   giis_assured.MAIL_ADDR3%TYPE
    ) RETURN VARCHAR2; 
    
    
    FUNCTION FIELDS_FORMATTRIGGER(
        p_endt_seq_no       GIPI_POLBASIC.ENDT_SEQ_NO%type,
        p_dist_no           GIUW_POL_DIST.DIST_NO%type,
        p_frps_seq_no       GIRI_DISTFRPS.FRPS_SEQ_NO%type,
        p_d050_ri_cd        GIRI_FRPS_RI.RI_CD%type,  
        p_policy_no         varchar
    ) RETURN VARCHAR2;
     
     
    FUNCTION get_report_details(
        p_reinsurer     GIIS_REINSURER.RI_SNAME%TYPE,
        p_line          GIIS_LINE.LINE_NAME%TYPE,
        p_expiry_month  VARCHAR2,
        p_expiry_year   NUMBER
    ) RETURN report_details_tab PIPELINED;
    
    -- added by MarkS 05-11-2016 SR-22068
    FUNCTION GET_TOTAL_RI_SHARE( 
        p_policy_no     VARCHAR2,
        p_reinsurer     GIIS_REINSURER.RI_SNAME%TYPE,
        p_line          GIIS_LINE.LINE_NAME%TYPE,
        p_expiry_month  VARCHAR2,
        p_expiry_year   NUMBER
        ) 
    RETURN NUMBER;
    --end SR-22068
END GIRIR110_PKG;
/