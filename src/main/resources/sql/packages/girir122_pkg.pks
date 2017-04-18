CREATE OR REPLACE PACKAGE CPI.GIRIR122_PKG
AS

    TYPE report_details_type IS RECORD(
        company_name            giis_parameters.PARAM_VALUE_V%type,
        company_address         giis_parameters.PARAM_VALUE_V%type,
        cf_paramdate            VARCHAR2(60),
        ri_cd                   GIRI_INPOLBAS.RI_CD%type,
        ri_name                 GIIS_REINSURER.RI_NAME%type,
        policy_id               GIPI_POLBASIC.POLICY_ID%type,
        pol_no                  VARCHAR2(30),
        your_reference          VARCHAR2(48),
        our_reference           VARCHAR2(60),
        line_name               GIIS_LINE.LINE_NAME%type,
        assd_no                 GIIS_ASSURED.ASSD_NO%type,
        assured                 GIIS_ASSURED.ASSD_NAME%type,
        incept_date             GIPI_POLBASIC.INCEPT_DATE%type,
        booking_month           VARCHAR2(15),
        net_amount_due          NUMBER(16,2)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
        
    FUNCTION get_report_details(
        p_reinsurer     GIIS_REINSURER.RI_NAME%type,
        p_line          GIIS_LINE.LINE_NAME%type,
        p_as_of_date    DATE,
        p_rep_date      VARCHAR2 
    ) RETURN report_details_tab PIPELINED;
    
    
END GIRIR122_PKG;
/


