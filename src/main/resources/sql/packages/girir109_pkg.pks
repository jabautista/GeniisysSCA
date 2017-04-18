CREATE OR REPLACE PACKAGE CPI.GIRIR109_PKG
AS
    TYPE report_header_type IS RECORD(
        company_name        giis_parameters.param_value_v%type,
        company_address     giis_parameters.param_value_v%type,
        cf_paramdate        VARCHAR2(50)
    );
    
    TYPE report_header_tab IS TABLE OF report_header_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
        
    FUNCTION get_report_header(
        p_report_month  VARCHAR2,
        p_report_year   VARCHAR2
     )  RETURN report_header_tab PIPELINED;
        
    
    TYPE treaty_bordereaux_type IS RECORD(
        line_cd             giis_line.LINE_CD%type,
        line_name           giis_line.LINE_NAME%type,
        treaty_no           varchar2(10),
        premium_amt         giac_treaty_cessions.PREMIUM_AMT%type,
        commission_amt      giac_treaty_cessions.COMMISSION_AMT%type,
        cf_net_due          number,
        cf_funds_held       number
    );
    
    TYPE treaty_bordereaux_tab IS TABLE OF treaty_bordereaux_type;
    
    
    FUNCTION CF_NET_DUE(
        p_premium_amt       giac_treaty_cessions.PREMIUM_AMT%type,
        p_commission_amt    giac_treaty_cessions.COMMISSION_AMT%type,
        p_cf_funds_held     NUMBER
    ) RETURN NUMBER;
    
    
    FUNCTION CF_FUNDS_HELD(
        p_line_cd       giis_line.LINE_CD%type,
        p_premium_amt   giac_treaty_cessions.PREMIUM_AMT%type
    ) RETURN NUMBER;
    
    
    FUNCTION get_treaty_bordereaux(
        p_line_name     giis_line.line_name%type,
        p_report_month  VARCHAR2,
        p_report_year   VARCHAR2
    ) RETURN treaty_bordereaux_tab PIPELINED;
    
    
    TYPE treaty_border_fire_type IS RECORD(
        line_cd             giis_line.line_cd%type,
        line_name           giis_line.line_name%type,
        fire_peril          varchar2(20),
        treaty_no           varchar2(10),
        premium_amt         giac_treaty_cessions.PREMIUM_AMT%type,
        commission_amt      giac_treaty_cessions.COMMISSION_AMT%type,
        funds_held_fire     number(16,3),
        cf_net_due_fire     number
    );
    
    TYPE treaty_border_fire_tab IS TABLE OF treaty_border_fire_type;
    
    
    FUNCTION get_treaty_border_fire(
        p_report_month      VARCHAR2,
        p_report_year       VARCHAR2
    ) RETURN treaty_border_fire_tab PIPELINED; 
    
    
END GIRIR109_PKG;
/


