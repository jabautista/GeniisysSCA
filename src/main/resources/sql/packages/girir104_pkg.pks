CREATE OR REPLACE PACKAGE CPI.GIRIR104_PKG
AS
    TYPE report_details_type IS RECORD(      
        company_name        giis_parameters.param_name%type,
        company_address     varchar2(500),
        paramdate           varchar2(60),
          
        line_name           GIIS_LINE.LINE_NAME%type,
        ytd_pre_year        GIIN_ASSMD_PROD_COMPARATIVE.YTD_PRE_YEAR%type,
        ytd_cur_year        GIIN_ASSMD_PROD_COMPARATIVE.YTD_CUR_YEAR%type,
        mtd_pre_year        GIIN_ASSMD_PROD_COMPARATIVE.M01_PRE_YEAR%type,
        mtd_cur_year        GIIN_ASSMD_PROD_COMPARATIVE.M01_CUR_YEAR%type,
        qtd_pre_year        GIIN_ASSMD_PROD_COMPARATIVE.QD1_PRE_YEAR%type,
        qtd_cur_year        GIIN_ASSMD_PROD_COMPARATIVE.QD1_CUR_YEAR%type,
        cf_quarter          varchar2(20),
        cf_var_month        number(16,2),
        cf_var_quarter      number(16,2),
        cf_var_year         number(16,2)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
    
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
       
    FUNCTION CF_VARIANCE(
        p_pre_year  GIIN_ASSMD_PROD_COMPARATIVE.M01_PRE_YEAR%type,
        p_cur_year  GIIN_ASSMD_PROD_COMPARATIVE.M01_CUR_YEAR%type
    ) RETURN NUMBER;
    
    
    FUNCTION CF_TOTAL_VARIANCE(
        p_total_pre_year  GIIN_ASSMD_PROD_COMPARATIVE.M01_PRE_YEAR%type,
        p_total_cur_year  GIIN_ASSMD_PROD_COMPARATIVE.M01_CUR_YEAR%type
    ) RETURN NUMBER;
    
    
    FUNCTION get_report_details(
        p_report_month      VARCHAR2,
        p_report_year       NUMBER
    ) RETURN report_details_tab PIPELINED;
    

END GIRIR104_PKG;
/


