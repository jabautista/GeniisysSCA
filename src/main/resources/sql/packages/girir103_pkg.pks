CREATE OR REPLACE PACKAGE CPI.GIRIR103_PKG
AS
    
    TYPE report_details_type IS RECORD(
        company_name        giis_parameters.param_name%type,
        company_address     varchar2(500),
        paramdate           varchar2(60),
        
        line_cd                 GIIS_LINE.LINE_CD%type,
        line_name               GIIS_LINE.LINE_NAME%type,
        subline_cd              GIIS_SUBLINE.SUBLINE_CD%type,
        subline_name            GIIS_SUBLINE.SUBLINE_NAME%type,
        ri_policy_no            GIRI_INPOLBAS.RI_POLICY_NO%type,
        endorsement_no          varchar2(20),
        policy_id               GIPI_POLBASIC.POLICY_ID%type,
        ri_name                 GIIS_REINSURER.RI_NAME%type,
        assd_name               GIIS_ASSURED.ASSD_NAME%type,
        cf_loc_risk1            gipi_fireitem.LOC_RISK1%type,
        cf_loc_risk2            gipi_fireitem.LOC_RISK2%type,
        cf_loc_risk3            gipi_fireitem.LOC_RISK3%type,
        cf_destn                gipi_cargo.destn%type,
        cf_vessel_cd            gipi_cargo.vessel_cd%type,
        cf_vessel_name          giis_vessel.vessel_name%type,
        ri_binder_no            GIRI_INPOLBAS.RI_BINDER_NO%type,
        incept_date             varchar2(12),
        expiry_date             varchar2(12),
        item_no                 GIPI_ITMPERIL.ITEM_NO%type,
        item_title              GIPI_ITEM.ITEM_TITLE%type,
        item_peril_cd           GIPI_ITMPERIL.PERIL_CD%type,
        peril_name              GIIS_PERIL.PERIL_NAME%type,
        amt_accepted            GIPI_ITMPERIL.TSI_AMT%type,
        amt_accepted2           GIPI_ITMPERIL.TSI_AMT%type,
        gross_ri_prem_amt       GIPI_ITMPERIL.PREM_AMT%type,
        ri_comm_rt              GIPI_ITMPERIL.RI_COMM_RATE%type,
        ri_comm_amt             GIPI_ITMPERIL.RI_COMM_AMT%type,
        premium_tax             GIPI_ITMPERIL.PREM_AMT%type,
        net_premium             GIPI_ITMPERIL.PREM_AMT%type
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;    
   

    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
    
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
       
    FUNCTION CF_loc_risk1(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_policy_id     GIPI_POLBASIC.POLICY_ID%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_loc_risk2(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_policy_id     GIPI_POLBASIC.POLICY_ID%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_loc_risk3(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_policy_id     GIPI_POLBASIC.POLICY_ID%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_DESTN(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_policy_id     GIPI_POLBASIC.POLICY_ID%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_VESSEL_CD(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_policy_id     GIPI_POLBASIC.POLICY_ID%type
    ) RETURN VARCHAR2;
     
    
    FUNCTION CF_VESSEL_NAME(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_vessel_cd     gipi_cargo.vessel_cd%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION get_report_details(
        p_report_month      VARCHAR2,
        p_report_year       NUMBER
    ) RETURN report_details_tab PIPELINED;
    

END GIRIR103_PKG;
/


