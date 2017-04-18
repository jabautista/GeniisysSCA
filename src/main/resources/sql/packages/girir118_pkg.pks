CREATE OR REPLACE PACKAGE CPI.GIRIR118_PKG
AS

    TYPE report_type IS RECORD(
        comp_name       GIIS_PARAMETERS.PARAM_VALUE_V%type,
        comp_address    GIIS_PARAMETERS.PARAM_VALUE_V%type,
        top_date        VARCHAR2(100),
        coverage        GIXX_NLTO_STAT.COVERAGE%type,
        peril_name      GIXX_NLTO_STAT.PERIL_NAME%type,
        pc_clm_count    GIXX_NLTO_CLAIM_STAT.PC_CLM_COUNT%type,
        pc_pd_clm       GIXX_NLTO_CLAIM_STAT.PC_PD_CLAIMS%type,
        pc_losses       GIXX_NLTO_CLAIM_STAT.PC_LOSSES%type,
        cv_clm_count    GIXX_NLTO_CLAIM_STAT.CV_CLM_COUNT%type,
        cv_pd_clm       GIXX_NLTO_CLAIM_STAT.CV_PD_CLAIMS%type,
        cv_losses       GIXX_NLTO_CLAIM_STAT.CV_LOSSES%type,
        mc_clm_count    GIXX_NLTO_CLAIM_STAT.MC_CLM_COUNT%type,
        mc_pd_clm       GIXX_NLTO_CLAIM_STAT.MC_PD_CLAIMS%type,
        mc_losses       GIXX_NLTO_CLAIM_STAT.MC_LOSSES%type,
        user_id         GIXX_NLTO_STAT.USER_ID%type,
        last_update     GIXX_NLTO_STAT.LAST_UPDATE%type,
        print_details   VARCHAR2(1)
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    
    FUNCTION populate_report(
        p_date_param        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_year              VARCHAR2,
        p_user_id           VARCHAR2
    ) RETURN report_tab PIPELINED;

END GIRIR118_PKG;
/


