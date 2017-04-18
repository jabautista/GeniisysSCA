CREATE OR REPLACE PACKAGE CPI.GIRIR011_PKG
AS

    TYPE report_details_type IS RECORD(
        company_name        GIIS_PARAMETERS.PARAM_VALUE_V%type,
        reinsurer_type      VARCHAR2(40),
        ri_cd               GIIS_REINSURER.RI_CD%type,
        ri_short_name       GIIS_REINSURER.RI_SNAME%type,
        reinsurer           GIIS_REINSURER.RI_NAME%type,
        address             VARCHAR2(160)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
       
    
    FUNCTION get_report_details(
        p_ri_type_desc  GIIS_REINSURER_TYPE.RI_TYPE_DESC%type
    ) RETURN report_details_tab PIPELINED;
    
    
END GIRIR011_PKG;
/


