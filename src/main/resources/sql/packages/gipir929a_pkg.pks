CREATE OR REPLACE PACKAGE CPI.GIPIR929A_PKG AS
/******************************************************************************
   NAME:       GIPIR929A_PKG
   PURPOSE:

   REVISIONS:
   Ver        Start-End Date  Author           Description
   ---------  --------------  ---------------  ---------------------------------
   1.0        07/06-06/2012   Rodel             Package for report conversion.
******************************************************************************/
    TYPE header_type IS RECORD (
        cf_company           VARCHAR2 (150),
        cf_company_address   VARCHAR2 (500),
        cf_heading3          VARCHAR2 (150),
        cf_based_on          VARCHAR2 (100)
    );

    TYPE header_tab IS TABLE OF header_type;

    TYPE report_type IS RECORD (
        iss_cd                  gipi_uwreports_inw_ri_ext.cred_branch%TYPE,
        iss_name                VARCHAR2(100),
        ri_cd                   gipi_uwreports_inw_ri_ext.ri_cd%TYPE,
        ri_name                 gipi_uwreports_inw_ri_ext.ri_name%TYPE,
        line_cd                 gipi_uwreports_inw_ri_ext.line_cd%TYPE,
        line_name               gipi_uwreports_inw_ri_ext.line_name%TYPE,
        subline_cd              gipi_uwreports_inw_ri_ext.subline_cd%TYPE,
        subline_name            gipi_uwreports_inw_ri_ext.subline_name%TYPE,
        total_tsi               gipi_uwreports_inw_ri_ext.total_tsi%TYPE,
        total_prem              gipi_uwreports_inw_ri_ext.total_prem%TYPE,
        evatprem                gipi_uwreports_inw_ri_ext.evatprem%TYPE,
        lgt                     gipi_uwreports_inw_ri_ext.lgt%TYPE,
        doc_stamps              gipi_uwreports_inw_ri_ext.doc_stamps%TYPE,
        fst                     gipi_uwreports_inw_ri_ext.fst%TYPE,
        other_taxes             gipi_uwreports_inw_ri_ext.other_taxes%TYPE,
        other_charges           gipi_uwreports_inw_ri_ext.other_charges%TYPE,
        param_date              gipi_uwreports_inw_ri_ext.param_date%TYPE,
        from_date               gipi_uwreports_inw_ri_ext.from_date%TYPE,
        to_date                 gipi_uwreports_inw_ri_ext.to_date%TYPE,
        scope                   gipi_uwreports_inw_ri_ext.scope%TYPE,
        user_id                 gipi_uwreports_inw_ri_ext.user_id%TYPE,
        total                   NUMBER,
        polcount                NUMBER,
        commission              gipi_uwreports_inw_ri_ext.ri_comm_amt%TYPE,
        ri_comm_vat             gipi_uwreports_inw_ri_ext.ri_comm_vat%TYPE
    );

    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION get_header_gipir929a (
        p_scope     gipi_uwreports_inw_ri_ext.SCOPE%TYPE,
        p_user_id   gipi_uwreports_inw_ri_ext.user_id%TYPE
    )
        RETURN header_tab PIPELINED;
        
    FUNCTION cf_companyformula
        RETURN CHAR;
        
    FUNCTION cf_company_addressformula
        RETURN CHAR;
    
    FUNCTION cf_heading3formula (p_user_id gipi_uwreports_inw_ri_ext.user_id%TYPE)
        RETURN CHAR;

    FUNCTION cf_based_onformula (
        p_user_id   gipi_uwreports_inw_ri_ext.user_id%TYPE,
        p_scope     gipi_uwreports_inw_ri_ext.SCOPE%TYPE
    )
        RETURN CHAR;
    
    FUNCTION populate_gipir929a (
        p_user_id           gipi_uwreports_inw_ri_ext.user_id%TYPE,
        p_scope             gipi_uwreports_inw_ri_ext.iss_cd%TYPE,
        p_subline_cd        gipi_uwreports_inw_ri_ext.subline_cd%TYPE,
        p_line_cd           gipi_uwreports_inw_ri_ext.line_cd%TYPE,
        p_iss_cd            gipi_uwreports_inw_ri_ext.cred_branch%TYPE,
        p_ri_cd             gipi_uwreports_inw_ri_ext.ri_cd%TYPE
    )
        RETURN report_tab PIPELINED;
               
    FUNCTION cf_iss_nameFormula (p_iss_cd giis_issource.iss_cd%TYPE) 
        RETURN CHAR;
                       
END GIPIR929A_PKG;
/


