CREATE OR REPLACE PACKAGE CPI.GIPIS203_PKG 
AS

    TYPE recap_dtl_region_type IS RECORD (
        region_cd       gixx_recapitulation_dtl.region_cd%TYPE,
        region_desc     giis_region.region_desc%TYPE,
        ind_grp_cd      gixx_recapitulation_dtl.ind_grp_cd%TYPE,
        ind_grp_nm      giis_industry_group.ind_grp_nm%TYPE
    );
    
    TYPE recap_dtl_region_tab IS TABLE OF recap_dtl_region_type;
    
    TYPE recap_dtl_type IS RECORD (
        region_cd           gixx_recapitulation_dtl.region_cd%TYPE,
        ind_grp_cd          gixx_recapitulation_dtl.ind_grp_cd%TYPE,
        policy_id           GIXX_RECAPITULATION_DTL.policy_id%TYPE,
        policy_no           VARCHAR2(100),
        assd_no             GIXX_RECAPITULATION_DTL.assd_no%TYPE,
        assd_name           giis_assured.assd_name%TYPE,
        premium_amt         GIXX_RECAPITULATION_DTL.PREMIUM_AMT%TYPE,
        
        -- for loss
        claim_no            VARCHAR2(100),
        claim_id            GIXX_RECAPITULATION_LOSSES_DTL.claim_id%TYPE,
        loss_amt            GIXX_RECAPITULATION_LOSSES_DTL.loss_amt%TYPE
    );
    
    TYPE recap_dtl_tab IS TABLE OF recap_dtl_type;

    FUNCTION check_extracted_record(
        p_rg1           VARCHAR2,
        p_rg2           VARCHAR2,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION check_record_bef_print(
        p_rg1           VARCHAR2,
        p_rg2           VARCHAR2
    ) RETURN VARCHAR2;
    
    FUNCTION get_recap_dtl_region_list(
        p_recap_dtl_type        VARCHAR2
    ) RETURN recap_dtl_region_tab PIPELINED;
        
    FUNCTION get_recap_dtl_prem_list(
        p_region_cd     gixx_recapitulation_dtl.region_cd%TYPE,
        p_ind_grp_cd    gixx_recapitulation_dtl.ind_grp_cd%TYPE
    ) RETURN recap_dtl_tab PIPELINED;    
    
    FUNCTION get_recap_dtl_loss_list(
        p_region_cd     GIXX_RECAPITULATION_LOSSES_DTL.region_cd%TYPE,
        p_ind_grp_cd    GIXX_RECAPITULATION_LOSSES_DTL.ind_grp_cd%TYPE
    ) RETURN recap_dtl_tab PIPELINED;
    
END GIPIS203_PKG;
/


