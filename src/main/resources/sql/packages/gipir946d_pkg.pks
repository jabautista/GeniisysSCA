CREATE OR REPLACE PACKAGE CPI.GIPIR946D_PKG AS
/******************************************************************************
   NAME:       GIPIR946D_PKG
   PURPOSE:

   REVISIONS:
   Ver        Start-End Date  Author           Description
   ---------  --------------  ---------------  ------------------------------------
   1.0        07/02-02/2012   Rodel         
******************************************************************************/
    TYPE header_type IS RECORD (
        cf_company           VARCHAR2 (150),
        cf_company_address   VARCHAR2 (500),
        cf_heading3          VARCHAR2 (150),
        cf_based_on          VARCHAR2 (100)
    );

    TYPE header_tab IS TABLE OF header_type;

    TYPE report_type IS RECORD (
        iss_cd                  gipi_uwreports_peril_ext.iss_cd%TYPE,
        iss_name                VARCHAR2 (100),
        line_cd                 gipi_uwreports_peril_ext.line_cd%TYPE,
        line_name               gipi_uwreports_peril_ext.line_name%TYPE,
        subline_cd              gipi_uwreports_peril_ext.subline_cd%TYPE,
        subline_name            giis_subline.subline_name%TYPE,
        intm_no                 gipi_uwreports_peril_ext.intm_no%TYPE,
        intm_name               gipi_uwreports_peril_ext.intm_name%TYPE,
        peril_cd                gipi_uwreports_peril_ext.peril_cd%TYPE,
        peril_name              gipi_uwreports_peril_ext.peril_name%TYPE,
        peril_type              gipi_uwreports_peril_ext.peril_type%TYPE,
        sum_tsi_amt             gipi_uwreports_peril_ext.tsi_amt%TYPE,
        tsi_basic               gipi_uwreports_peril_ext.tsi_amt%TYPE,
        sum_prem_amt            gipi_uwreports_peril_ext.prem_amt%TYPE
    );

    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION get_header_gipir946d (
        p_scope     gipi_uwreports_peril_ext.SCOPE%TYPE,
        p_user_id   gipi_uwreports_peril_ext.user_id%TYPE
    )
        RETURN header_tab PIPELINED;
        
    FUNCTION cf_companyformula
        RETURN CHAR;
        
    FUNCTION cf_company_addressformula
        RETURN CHAR;
    
    FUNCTION cf_heading3formula (p_user_id gipi_uwreports_peril_ext.user_id%TYPE)
        RETURN CHAR;

    FUNCTION cf_based_onformula (
        p_user_id   gipi_uwreports_peril_ext.user_id%TYPE,
        p_scope     gipi_uwreports_peril_ext.SCOPE%TYPE
    )
        RETURN CHAR;
        

    
    FUNCTION populate_gipir946d (
        p_iss_cd            gipi_uwreports_peril_ext.iss_cd%TYPE,
        p_line_cd           gipi_uwreports_peril_ext.line_cd%TYPE,
        p_subline_cd        gipi_uwreports_peril_ext.subline_cd%TYPE,
        p_scope             gipi_uwreports_peril_ext.scope%TYPE,
        p_iss_param         NUMBER,
        p_user_id           gipi_uwreports_peril_ext.user_id%TYPE
    )
        RETURN report_tab PIPELINED;
        
    FUNCTION cf_iss_nameFormula (p_iss_cd giis_issource.iss_cd%TYPE)
        RETURN CHAR;
                       
END GIPIR946D_PKG;
/


