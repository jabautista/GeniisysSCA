CREATE OR REPLACE PACKAGE CPI.GIRIR116_PKG
AS

    TYPE report_type IS RECORD(
        comp_name       GIIS_PARAMETERS.PARAM_VALUE_V%type,
        comp_address    GIIS_PARAMETERS.PARAM_VALUE_V%type,
        top_date        VARCHAR2(100),
        coverage        GIXX_NLTO_STAT.COVERAGE%type,
        peril_name      GIXX_NLTO_STAT.PERIL_NAME%type,
        pc_count        GIXX_NLTO_STAT.PC_COUNT%type,
        pc_prem         GIXX_NLTO_STAT.PC_PREM%type,
        cv_count        GIXX_NLTO_STAT.CV_COUNT%type,
        cv_prem         GIXX_NLTO_STAT.CV_PREM%type,
        mc_count        GIXX_NLTO_STAT.MC_COUNT%type,
        mc_prem         GIXX_NLTO_STAT.MC_PREM%type,
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

END GIRIR116_PKG;
/


