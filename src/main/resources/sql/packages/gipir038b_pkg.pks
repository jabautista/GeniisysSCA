CREATE OR REPLACE PACKAGE CPI.GIPIR038B_PKG
AS

    TYPE report_type IS RECORD(
        company_name        giis_parameters.param_value_v%type,
        company_address     giis_parameters.param_value_v%type,
        cf_title            VARCHAR2(120),
        cf_header           VARCHAR2(100),
        
        count               NUMBER(10),
        nvl_tarf_cd         GIXX_FIRESTAT_SUMMARY.TARF_CD%type,
        cf_count            NUMBER(10),
        nvl_tariff_zone     GIXX_FIRESTAT_SUMMARY.TARIFF_ZONE%type,
        tariff              GIXX_FIRESTAT_SUMMARY.TARF_CD%type,
        sum_tsi_amt         NUMBER(18,2),
        sum_prem_amt        NUMBER(18,2),
        print_details       VARCHAR2(1)
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION populate_report(
        p_zone_type         GIIS_PERIL.ZONE_TYPE%type,
        p_as_of_sw          VARCHAR2,
        p_expired_as_of     VARCHAR2,
        p_period_start      VARCHAR2,
        p_period_end        VARCHAR2,
        p_user              VARCHAR2
    ) RETURN report_tab PIPELINED;

END GIPIR038B_PKG;
/


