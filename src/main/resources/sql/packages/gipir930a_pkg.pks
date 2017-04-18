CREATE OR REPLACE PACKAGE CPI.GIPIR930A_PKG 
AS
    TYPE gipir930a_header_type IS RECORD (
        company         giis_parameters.PARAM_VALUE_V%TYPE,
        company_address VARCHAR2(500),  --Halley 01.28.14
        based_on        VARCHAR2(100),
        heading3        VARCHAR2(150)
    );
    
    TYPE gipir930a_header_tab IS TABLE OF gipir930a_header_type;
    
    
    TYPE gipir930a_report_type IS RECORD (
        iss_header          VARCHAR2(20),
        iss_cd              gipi_uwreports_ri_ext.ISS_CD%TYPE,
        iss_name            giis_issource.iss_name%TYPE ,
        line_cd             gipi_uwreports_ri_ext.LINE_CD%TYPE,
        line_name           gipi_uwreports_ri_ext.LINE_NAME%TYPE ,
        subline_cd          gipi_uwreports_ri_ext.SUBLINE_CD%TYPE,
        subline_name        gipi_uwreports_ri_ext.SUBLINE_NAME%TYPE ,
        binder_count        NUMBER(12) ,
        tsi                 gipi_uwreports_ri_ext.TOTAL_SI%TYPE ,
        prem                gipi_uwreports_ri_ext.TOTAL_PREM%TYPE ,
        reinsured           gipi_uwreports_ri_ext.SUM_REINSURED%TYPE ,
        share_prem          gipi_uwreports_ri_ext.SHARE_PREMIUM%TYPE ,
        ri_prem_vat         gipi_uwreports_ri_ext.RI_PREM_VAT%TYPE ,
        ri_comm             gipi_uwreports_ri_ext.RI_COMM_AMT%TYPE ,
        ri_comm_vat         gipi_uwreports_ri_ext.RI_COMM_VAT%TYPE ,
        ri_wholding_vat     gipi_uwreports_ri_ext.RI_WHOLDING_VAT%TYPE ,
        ri_premium_tax      gipi_uwreports_ri_ext.RI_PREMIUM_TAX%TYPE ,
        net_due             gipi_uwreports_ri_ext.NET_DUE%TYPE,
        vat_title           VARCHAR2(20) 
    );
    
    TYPE gipir930a_report_tab IS TABLE OF gipir930a_report_type;
       
    
    FUNCTION CF_companyFormula 
        RETURN Char;
        
    FUNCTION cf_company_addressformula
        RETURN CHAR;        
        
    FUNCTION CF_based_onFormula(
        p_scope     NUMBER,
        p_user_id   gipi_uwreports_ri_ext.user_id%TYPE
    )
        RETURN Char;
        
    FUNCTION CF_heading3Formula(
        p_user_id   gipi_uwreports_ri_ext.user_id%TYPE
    )
        RETURN Char;    
    
    FUNCTION get_gipir930a_header(
         p_scope     NUMBER,
         p_user_id   gipi_uwreports_ri_ext.user_id%TYPE
    )
    RETURN gipir930a_header_tab PIPELINED;
 
    
    FUNCTION CF_iss_headerFormula (
        p_iss_param gipi_uwreports_ri_ext.CRED_BRANCH%TYPE
    )
        RETURN Char;
        
    FUNCTION CF_iss_nameFormula (
        p_iss_cd gipi_uwreports_ri_ext.ISS_CD%TYPE
    )
        RETURN Char;
        
    FUNCTION CF_reinsuredFormula(
        p_line_cd       gipi_uwreports_ri_ext.LINE_CD%TYPE,
        p_subline_cd    gipi_uwreports_ri_ext.SUBLINE_CD%TYPE,
        p_iss_cd        gipi_uwreports_ri_ext.ISS_CD%TYPE,
        p_iss_param     gipi_uwreports_ri_ext.CRED_BRANCH%TYPE,
        p_scope         NUMBER,
        p_user_id       gipi_uwreports_ri_ext.user_id%TYPE
    ) 
        RETURN Number;
      
    PROCEDURE CF_tsi_premFormula(
        p_line_cd        gipi_uwreports_ri_ext.LINE_CD%TYPE,
        p_subline_cd     gipi_uwreports_ri_ext.SUBLINE_CD%TYPE,
        p_iss_cd         gipi_uwreports_ri_ext.ISS_CD%TYPE,
        p_iss_param      gipi_uwreports_ri_ext.CRED_BRANCH%TYPE,
        p_scope          NUMBER,
        v_total_si   OUT GIPI_UWREPORTS_RI_EXT.total_si%TYPE,
        v_total_prem OUT GIPI_UWREPORTS_RI_EXT.total_prem%TYPE,
        p_user_id        GIPI_UWREPORTS_RI_EXT.user_id%TYPE
    ) ;
       
    FUNCTION CF_vat_titleFormula
        RETURN Char;

    FUNCTION populate_gipir930a_report (
        p_iss_cd        gipi_uwreports_ri_ext.ISS_CD%TYPE,
        p_line_cd       gipi_uwreports_ri_ext.LINE_CD%TYPE,
        p_subline_cd    gipi_uwreports_ri_ext.SUBLINE_CD%TYPE,
        p_iss_param     gipi_uwreports_ri_ext.CRED_BRANCH%TYPE,
        p_scope         NUMBER,
        p_user_id       gipi_uwreports_ri_ext.user_id%TYPE
    ) 
    RETURN gipir930a_report_tab PIPELINED;
    
    
END;  --end of package specs
/


