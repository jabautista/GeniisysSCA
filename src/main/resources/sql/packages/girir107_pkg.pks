CREATE OR REPLACE PACKAGE CPI.GIRIR107_PKG
AS

    TYPE report_details_type IS RECORD(
        company_name        giis_parameters.PARAM_VALUE_V%type,
        company_address     giis_parameters.PARAM_VALUE_V%type,
        cf_paramdate        VARCHAR2(50),
        line_cd             gipi_polbasic.LINE_CD%type,
        line_name           giis_line.LINE_NAME%type,
        subline_cd          gipi_polbasic.SUBLINE_CD%type,
        subline_name        giis_subline.SUBLINE_NAME%type,
        policy_no           VARCHAR2(30),
        policy_id           gipi_polbasic.POLICY_ID%type,
        dist_no             VARCHAR2(13),
        dist_seq_no         VARCHAR2(8),
        frps_no             VARCHAR2(20),
        group_no            VARCHAR2(10),
        ri_name             giis_reinsurer.RI_NAME%type,
        peril_name          giis_peril.PERIL_NAME%type,
        sum_insured         GIRI_FRPERIL.RI_TSI_AMT%TYPE,
        premium             GIRI_FRPERIL.RI_PREM_AMT%TYPE,
        commission          GIRI_FRPERIL.RI_COMM_AMT%TYPE,
        net_premium         GIRI_FRPERIL.RI_PREM_AMT%TYPE
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


END GIRIR107_PKG;
/


