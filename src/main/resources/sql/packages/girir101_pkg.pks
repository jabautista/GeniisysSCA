CREATE OR REPLACE PACKAGE CPI.GIRIR101_PKG
AS

    TYPE report_details_type IS RECORD(
        company_name        VARCHAR2(500),
        company_address     VARCHAR2(500),
        oar_print_date      giri_inpolbas.OAR_PRINT_DATE%type,
        ri_cd               giri_inpolbas.RI_CD%type,
        reinsurer           giis_reinsurer.RI_NAME%type,
        assd_name           giis_assured.ASSD_NAME%type,
        line_cd             gipi_polbasic.LINE_CD%type,
        line_name           giis_line.LINE_NAME%type,
        amount_offered      NUMBER(16,2),   
        our_acceptance      gipi_polbasic.TSI_AMT%type,
        incept_date         gipi_polbasic.INCEPT_DATE%type,
        expiry_date         gipi_polbasic.EXPIRY_DATE%type,
        date_accepted       giri_inpolbas.ACCEPT_DATE%type,
        accept_no           giri_inpolbas.ACCEPT_NO%type,
        no_of_days          NUMBER(6),
        format_trigger      VARCHAR2(1),
        exist               VARCHAR2(1)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;

    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
        
    FUNCTION get_report_details(
        p_ri_cd             giri_inpolbas.RI_CD%type,
        p_line_cd           gipi_polbasic.LINE_CD%type,
        p_oar_print_date    VARCHAR2,
        p_morethan          NUMBER,
        p_lessthan          NUMBER,
        p_date_sw           VARCHAR2
    ) RETURN report_details_tab PIPELINED;

END GIRIR101_PKG;
/


