CREATE OR REPLACE PACKAGE CPI.GIRIR108_PKG
AS

    TYPE report_details_type IS RECORD(
        company_name        giis_parameters.param_value_v%type,
        company_address     giis_parameters.param_value_v%type,
        cf_paramdate        varchar2(50),
        line_cd             gipi_polbasic.LINE_CD%type,
        line_name           giis_line.LINE_NAME%type,
        policy_no           varchar(30),
        policy_id           gipi_polbasic.POLICY_ID%type,
        assd_name           giis_assured.ASSD_NAME%type,
        binder_no           varchar2(15),
        cf_loc_risk1        gipi_fireitem.LOC_RISK1%type,
        cf_loc_risk2        gipi_fireitem.LOC_RISK2%type,
        cf_loc_risk3        gipi_fireitem.LOC_RISK3%type,
        cf_destn            gipi_cargo.DESTN%type,
        cf_vessel_cd        gipi_cargo.VESSEL_CD%type,
        cf_vessel_name      giis_vessel.VESSEL_NAME%type,
        incept_date         gipi_polbasic.INCEPT_DATE%type,
        expiry_date         gipi_polbasic.EXPIRY_DATE%type,
        sum_insured         giri_distfrps.TSI_AMT%type,
        amt_accepted        giri_binder.RI_TSI_AMT%type,
        pct_accepted        giri_binder.RI_SHR_PCT%type,
        frps_ri_remarks     giri_frps_ri.REMARKS%type
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
       
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
       
    FUNCTION get_report_details(
        p_report_month  VARCHAR2,
        p_report_year   VARCHAR2
    ) RETURN report_details_tab PIPELINED;
    
    
END GIRIR108_PKG;
/


