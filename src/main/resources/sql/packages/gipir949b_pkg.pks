CREATE OR REPLACE PACKAGE CPI.GIPIR949B_PKG
AS

    TYPE report_type IS RECORD(
        company_name        giis_parameters.param_value_v%type,
        company_address     giis_parameters.param_value_v%type,
        top_date1           VARCHAR2(100),
        top_date2           VARCHAR2(100),
        
        line                VARCHAR2(50),
        range_from          gipi_risk_profile_item.RANGE_FROM%type,
        range               VARCHAR2(50),
        pol                 VARCHAR2(100),
        item_no             gipi_item.ITEM_NO%type,
        item_title          VARCHAR2(100),
        tsi_amt             NUMBER(18,2),
        prem_amt            NUMBER(18,2),
        net_tsi             NUMBER(18,2),
        net_prem            NUMBER(18,2),
        treaty_tsi          NUMBER(18,2),
        treaty_prem         NUMBER(18,2),
        facul_tsi           NUMBER(18,2),
        facul_prem          NUMBER(18,2),
        print_detail        VARCHAR2(1)
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION populate_report(
        p_line_cd           gipi_risk_profile_dtl.LINE_CD%type,
        p_subline_cd        gipi_risk_profile_dtl.SUBLINE_CD%type,
        p_starting_date     VARCHAR2,
        p_ending_date       VARCHAR2,
        p_all_line_tag      VARCHAR2,
        p_param_date        VARCHAR2,
        p_claim_date        VARCHAR2,
        p_loss_date_from    VARCHAR2,
        p_loss_date_to      VARCHAR2,
        p_user              gipi_risk_profile_dtl.USER_ID%type
    ) RETURN report_tab PIPELINED;
    
END GIPIR949B_PKG;
/


