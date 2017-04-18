CREATE OR REPLACE PACKAGE CPI.GIRIR029_PKG
AS

    TYPE report_details_type IS RECORD(
        company_name        giis_parameters.PARAM_VALUE_V%type,
        company_address     varchar2(500),
        cf_date_param       varchar2(60),   
        cf_date_value       varchar2(70),
        ri_name             giis_reinsurer.RI_NAME%type,
        line_name           giis_line.LINE_NAME%type,
        assm_facul          number(18,2),
        ced_facul           number(18,2),
        var_facul           number(18,2),
        aloss_facul         number(18,2),
        closs_facul         number(18,2)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
     
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
        
    FUNCTION CF_DATE_PARAM(
        p_user_id   giri_fac_reciprocity.USER_ID%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_DATE_VALUE (
        p_user_id   giri_fac_reciprocity.USER_ID%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION get_report_details(
        p_ri_cd     GIRI_FAC_RECIPROCITY.RI_CD%type,
        p_user_id   GIRI_FAC_RECIPROCITY.USER_ID%type
    ) RETURN report_details_tab PIPELINED;

END GIRIR029_PKG;
/


