CREATE OR REPLACE PACKAGE CPI.GIRIR115_PKG
AS

    TYPE report_type IS RECORD(
        company_name        GIIS_PARAMETERS.PARAM_VALUE_V%type,
        company_address     GIIS_PARAMETERS.PARAM_VALUE_V%type,
        top_date            VARCHAR2(200),
        peril_stat_name     GIXX_LTO_STAT.PERIL_STAT_NAME%type,
        subline             GIXX_LTO_STAT.SUBLINE%type,
        mla_cnt             GIXX_LTO_STAT.MLA_CNT%type,
        outside_mla_cnt     GIXX_LTO_STAT.OUTSIDE_MLA_CNT%type,
        mla_prem            GIXX_LTO_STAT.MLA_PREM%type,
        outside_mla_prem    GIXX_LTO_STAT.OUTSIDE_MLA_PREM%type,
        user_id             GIXX_LTO_STAT.USER_ID%type,
        last_update         GIXX_LTO_STAT.LAST_UPDATE%type,
        print_details       VARCHAR2(1)
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION populate_report(
        p_date_param        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_year              VARCHAR2,
        p_user_id           VARCHAR2
    ) RETURN report_tab PIPELINED;


END GIRIR115_PKG;
/


