CREATE OR REPLACE PACKAGE CPI.GIRIR105_PKG
AS

    TYPE report_details_type IS RECORD(
        company_name        VARCHAR2(500),
        company_address     VARCHAR2(500),
        paramdate           VARCHAR2(100),
        line_cd             GIIS_LINE.LINE_CD%type,
        line_name           GIIS_LINE.LINE_NAME%type,
        subline_cd          GIIS_SUBLINE.SUBLINE_CD%type,
        subline_name        GIIS_SUBLINE.SUBLINE_NAME%type,
        policy_id           GIRI_DISTFRPS_WDISTFRPS_V.PAR_POLICY_ID%type,
        frps_no             VARCHAR2(30),
        par_no              VARCHAR2(30),
        policy_no           VARCHAR2(30),
        ri_create_dt        VARCHAR2(10),
        endt_no             VARCHAR2(20),
        assured             GIRI_DISTFRPS_WDISTFRPS_V.ASSD_NAME%type,
        total_sum_insured   GIRI_DISTFRPS_WDISTFRPS_V.TSI_AMT%type,
        facultative_amt     GIRI_DISTFRPS_WDISTFRPS_V.TOT_FAC_TSI%type,
        cf_location1        gipi_fireitem.loc_risk1%type,
        cf_location2        gipi_fireitem.loc_risk2%type,
        cf_location3        gipi_fireitem.loc_risk3%type,
        cf_destn            gipi_cargo.destn%type,
        cf_vessel_cd        gipi_cargo.vessel_cd%type,
        cf_vessel_name      giis_vessel.vessel_name%type,
        cf_share_pct        giri_distfrps.tot_fac_tsi%type,
        print_field         VARCHAR2(1)        
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
        
    FUNCTION get_report_details(
        p_from_date     VARCHAR2 ,
        p_to_date       VARCHAR2,
        p_line_cd       GIRI_DISTFRPS_WDISTFRPS_V.LINE_CD%type
    ) RETURN report_details_tab PIPELINED;
    

END GIRIR105_PKG;
/


