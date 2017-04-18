CREATE OR REPLACE PACKAGE CPI.GIPIR203A_PKG
AS
    TYPE gipir203a_type IS RECORD(
        assd_no                 GIXX_RECAPITULATION_DTL.assd_no%TYPE,
        assd_name               giis_assured.assd_name%TYPE,
        policy_id               GIXX_RECAPITULATION_DTL.policy_id%TYPE,
        policy_no               VARCHAR2(50),
        region_cd               GIXX_RECAPITULATION_DTL.region_cd%TYPE,
        region_desc             VARCHAR2(50),
        ind_grp_cd              GIXX_RECAPITULATION_DTL.ind_grp_cd%TYPE,
        ind_grp_nm              giis_industry_group.ind_grp_nm%TYPE,
        premium_amt             GIXX_RECAPITULATION_DTL.premium_amt%TYPE,
        line_cd                 GIXX_RECAPITULATION_DTL.line_cd%TYPE,
        line_name               VARCHAR2(30) --Dren Niebres 07.18.2016 SR-5336
    );
    
    TYPE gipir203a_tab IS TABLE OF gipir203a_type;    
    FUNCTION populate_report_details (p_include_endt VARCHAR2)
        RETURN gipir203a_tab PIPELINED;
        
    TYPE gipir203a_head_type IS RECORD( --Dren Niebres 07.18.2016 SR-5336
        company_name            giis_parameters.param_name%TYPE,
        company_address         VARCHAR2(1000)
    );
    
    TYPE gipir203a_head_tab IS TABLE OF gipir203a_head_type;        
    FUNCTION populate_header --Dren Niebres 07.18.2016 SR-5336
        RETURN gipir203a_head_tab PIPELINED;        

END GIPIR203A_PKG;
/
