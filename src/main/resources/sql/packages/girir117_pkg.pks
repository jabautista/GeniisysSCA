CREATE OR REPLACE PACKAGE CPI.GIRIR117_PKG
AS

    TYPE report_type IS RECORD(
        company_name            GIIS_PARAMETERS.PARAM_VALUE_V%type,
        company_address         GIIS_PARAMETERS.PARAM_VALUE_V%type,
        top_date                VARCHAR2(200),
        peril_stat_name         GIXX_LTO_CLAIM_STAT.PERIL_STAT_NAME%type,
        subline                 GIXX_LTO_CLAIM_STAT.SUBLINE%type,
        mla_clm_cnt             GIXX_LTO_CLAIM_STAT.MLA_CLM_CNT%type,
        mla_pd_claims           GIXX_LTO_CLAIM_STAT.MLA_PD_CLAIMS%type,
        mla_losses              GIXX_LTO_CLAIM_STAT.MLA_LOSSES%type,
        outside_mla_cnt         GIXX_LTO_CLAIM_STAT.OUTSIDE_MLA_CNT%type,
        outside_mla_pd_claims   GIXX_LTO_CLAIM_STAT.OUTSIDE_MLA_PD_CLAIMS%type,
        outside_mla_losses      GIXX_LTO_CLAIM_STAT.OUTSIDE_MLA_LOSSES%type,
        user_id                 GIXX_LTO_STAT.USER_ID%type,
        last_update             GIXX_LTO_STAT.LAST_UPDATE%type,
        print_details           VARCHAR2(1)
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION populate_report(
        p_date_param        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_year              VARCHAR2,
        p_user_id           VARCHAR2
    ) RETURN report_tab PIPELINED;


END GIRIR117_PKG;
/


