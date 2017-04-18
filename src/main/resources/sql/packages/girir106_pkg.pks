CREATE OR REPLACE PACKAGE CPI.GIRIR106_PKG
AS

    TYPE report_details_type IS RECORD(
        company_name            giis_parameters.PARAM_VALUE_V%type,
        company_address         giis_parameters.PARAM_VALUE_V%type,
        cf_paramdate            VARCHAR(100),
        line_cd                 GIPI_POLBASIC.LINE_CD%type,
        line_name               GIIS_LINE.LINE_NAME%type,
        subline_cd              GIPI_POLBASIC.SUBLINE_CD%type,
        subline_name            GIIS_SUBLINE.SUBLINE_NAME%type,
        policy_no               VARCHAR2(30),
        endt_no                 VARCHAR2(15),
        assd_name               GIIS_ASSURED.ASSD_NAME%type,
        dist_no                 VARCHAR2(13),
        dist_seq_no             VARCHAR2(8),
        frps_no                 VARCHAR2(20),
        group_no                VARCHAR2(10),
        ri_name                 GIIS_REINSURER.RI_NAME%TYPE,
        peril_name              GIIS_PERIL.PERIL_NAME%TYPE,
        sum_insured             GIRI_FRPERIL.RI_TSI_AMT%TYPE,
        commission              GIRI_FRPERIL.RI_PREM_AMT%TYPE,
        premium                 GIRI_FRPERIL.RI_COMM_AMT%TYPE,
        net_premium             GIRI_FRPERIL.RI_PREM_AMT%TYPE
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
        
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
        
    FUNCTION get_report_details(
        p_report_month      VARCHAR2,
        p_report_year       VARCHAR2
    ) RETURN report_details_tab PIPELINED;
    

END GIRIR106_PKG;
/


