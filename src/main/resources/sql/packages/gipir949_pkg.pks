CREATE OR REPLACE PACKAGE CPI.GIPIR949_PKG
AS

    TYPE report_type IS RECORD (
        company_name        giis_parameters.PARAM_VALUE_V%type,
        company_address     giis_parameters.PARAM_VALUE_V%type,
        top_date            VARCHAR2(100),
        
        line                VARCHAR2(30),
        subline             VARCHAR2(40), 
        tarf_cd             gipi_risk_profile_dtl.TARF_CD%type,
        tarf_desc           cg_ref_codes.RV_MEANING%type,
        range_from          gipi_risk_profile_dtl.RANGE_FROM%type,
        range_to            gipi_risk_profile_dtl.RANGE_TO%type,
        cf_ranges           VARCHAR2(200),
        policy_no           VARCHAR2(200),
        ann_tsi_amt         gipi_risk_profile_dtl.ANN_TSI_AMT%type,
        netret_prem         gipi_risk_profile_dtl.NET_RETENTION%type,
        facul_prem          gipi_risk_profile_dtl.FACULTATIVE%type,
        quota_prem          gipi_risk_profile_dtl.QUOTA_SHARE%type,
        treaty_prem         NUMBER(18,2),
        pol_total           NUMBER(18,2),
        print_details       VARCHAR2(1)
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    
    FUNCTION populate_report(
        p_line_cd           gipi_risk_profile_dtl.LINE_CD%type,
        p_subline_cd        gipi_risk_profile_dtl.SUBLINE_CD%type,
        p_starting_date     VARCHAR2,
        p_ending_date       VARCHAR2,
        p_all_line_tag      VARCHAR2, -- benjo 05.22.2015 UW-SPECS-2015-046
        p_param_date        VARCHAR2,
        p_user              gipi_risk_profile_dtl.USER_ID%type
    ) RETURN report_tab PIPELINED;


END GIPIR949_PKG;