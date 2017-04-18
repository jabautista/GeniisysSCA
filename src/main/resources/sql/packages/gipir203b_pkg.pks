CREATE OR REPLACE PACKAGE CPI.GIPIR203B_PKG
AS

    TYPE gipir203b_type IS RECORD(
        assd_no                 GIXX_RECAPITULATION_LOSSES_DTL.assd_no%TYPE,
        assd_name               giis_assured.assd_name%TYPE,
        policy_id               GIXX_RECAPITULATION_LOSSES_DTL.policy_id%TYPE,
        policy_no               VARCHAR2(100),
        claim_id                GIXX_RECAPITULATION_LOSSES_DTL.claim_id%TYPE,
        claim_no                VARCHAR2(100),
        region_cd               GIXX_RECAPITULATION_LOSSES_DTL.region_cd%TYPE,
        region_desc             VARCHAR2(50),
        ind_grp_cd              GIXX_RECAPITULATION_LOSSES_DTL.ind_grp_cd%TYPE,
        ind_grp_nm              giis_industry_group.ind_grp_nm%TYPE,
        loss_amt                GIXX_RECAPITULATION_LOSSES_DTL.loss_amt%TYPE,
        line_cd                 GIXX_RECAPITULATION_LOSSES_DTL.line_cd%TYPE,
        line_name               VARCHAR2(30),
        company_name            giis_parameters.param_name%TYPE,
        company_address         VARCHAR2(1000)
    );
    
    TYPE gipir203b_tab IS TABLE OF gipir203b_type;
    
    FUNCTION populate_report_details
        RETURN gipir203b_tab PIPELINED;

END GIPIR203B_PKG;
/


