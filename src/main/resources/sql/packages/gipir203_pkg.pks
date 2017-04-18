CREATE OR REPLACE PACKAGE CPI.GIPIR203_PKG 
AS

    TYPE recap_dtl_type IS RECORD (
        region_cd               gixx_recapitulation.region_cd%TYPE,
        region_name             VARCHAR2(100),
        ind_grp_cd              gixx_recapitulation.ind_grp_cd%TYPE,
        ind_grp_nm              giis_industry_group.ind_grp_nm%TYPE,
        no_of_policy            gixx_recapitulation.no_of_policy%TYPE,
        gross_prem              gixx_recapitulation.gross_prem%TYPE,
        gross_losses            gixx_recapitulation.gross_losses%TYPE,
        social_gross_prem       gixx_recapitulation.social_gross_prem%TYPE,
        company_name            giis_parameters.param_name%TYPE,
        company_address         giis_parameters.param_name%TYPE
    );
    
    TYPE recap_dtl_tab IS TABLE OF recap_dtl_type;
    
    FUNCTION populate_gipir203_details
        RETURN recap_dtl_tab PIPELINED;
    
END GIPIR203_PKG;
/


