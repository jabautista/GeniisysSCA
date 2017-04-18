CREATE OR REPLACE PACKAGE CPI.GIUTS003A_PKG
AS
          
    TYPE when_new_form_giuts003a_type IS RECORD(
        allow_spoilage      giac_parameters.param_value_v%TYPE,
        clm_stat_cancel     giis_parameters.PARAM_VALUE_V%TYPE,
        req_spl_reason      giis_parameters.PARAM_VALUE_V%TYPE
    );
    
    TYPE giuts003a_policy_lov_type IS RECORD (
        pack_policy_id              GIPI_PACK_POLBASIC.PACK_POLICY_ID%TYPE,
        pack_par_id                 GIPI_PACK_POLBASIC.PACK_PAR_ID%TYPE,
        line_cd                     GIPI_PACK_POLBASIC.LINE_CD%TYPE,
        subline_cd                  GIPI_PACK_POLBASIC.SUBLINE_CD%TYPE,
        iss_cd                      GIPI_PACK_POLBASIC.ISS_CD%TYPE,
        issue_yy                    GIPI_PACK_POLBASIC.ISSUE_YY%TYPE,
        pol_seq_no                  GIPI_PACK_POLBASIC.POL_SEQ_NO%TYPE,
        renew_no                    GIPI_PACK_POLBASIC.RENEW_NO%TYPE,
        policy_status               VARCHAR(50),
        endt_iss_cd                 GIPI_PACK_POLBASIC.ENDT_ISS_CD%TYPE,
        endt_yy                     GIPI_PACK_POLBASIC.ENDT_YY%TYPE,
        endt_seq_no                 GIPI_PACK_POLBASIC.ENDT_SEQ_NO%TYPE,
        acct_ent_date               GIPI_PACK_POLBASIC.ACCT_ENT_DATE%TYPE,
        assd_no                     GIPI_PACK_POLBASIC.ASSD_NO%TYPE,
        assd_name                   GIIS_ASSURED.ASSD_NAME%TYPE,
        eff_date                    GIPI_PACK_POLBASIC.EFF_DATE%TYPE,
        expiry_date                 GIPI_PACK_POLBASIC.EXPIRY_DATE%TYPE,
        endt_expiry_date            GIPI_PACK_POLBASIC.ENDT_EXPIRY_DATE%TYPE,
        spld_date                   GIPI_PACK_POLBASIC.SPLD_DATE%TYPE,
        user_id                     GIPI_PACK_POLBASIC.USER_ID%TYPE,
        dist_flag                   GIPI_PACK_POLBASIC.DIST_FLAG%TYPE,
        spld_user_id                GIPI_PACK_POLBASIC.SPLD_USER_ID%TYPE,
        spld_approval               GIPI_PACK_POLBASIC.SPLD_APPROVAL%TYPE,
        spld_flag                   GIPI_PACK_POLBASIC.SPLD_FLAG%TYPE,
        mean_pol_flag               VARCHAR2(100),
        policy_no                   VARCHAR2(50),
        endt_no                     VARCHAR2(50),
        comp_sw                     GIPI_PACK_POLBASIC.COMP_SW%TYPE,
        prorate_flag                GIPI_PACK_POLBASIC.PRORATE_FLAG%TYPE,
        short_rt_percent            GIPI_PACK_POLBASIC.SHORT_RT_PERCENT%TYPE,
        spld_acct_ent_date          GIPI_PACK_POLBASIC.SPLD_ACCT_ENT_DATE%TYPE,
        pol_flag                    GIPI_PACK_POLBASIC.POL_FLAG%TYPE,
        last_upd_date               GIPI_PACK_POLBASIC.LAST_UPD_DATE%TYPE,
        ann_tsi_amt                 GIPI_PACK_POLBASIC.ANN_TSI_AMT%TYPE,
        ann_prem_amt                GIPI_PACK_POLBASIC.ANN_PREM_AMT%TYPE,
        eis_flag                    GIPI_PACK_POLBASIC.EIS_FLAG%TYPE,
        spoil_cd                    GIPI_PACK_POLBASIC.SPOIL_CD%TYPE,
        spoil_desc                  GIIS_SPOILAGE_REASON.SPOIL_DESC%TYPE
    );

    TYPE giuts003a_spoil_lov_type IS RECORD(
        spoil_cd        GIIS_SPOILAGE_REASON.SPOIL_CD%TYPE,
        spoil_desc      GIIS_SPOILAGE_REASON.SPOIL_DESC%TYPE
    );
    
    TYPE giuts003a_pack_spoil_msg_type IS RECORD(
        msg_considered  VARCHAR2(100),
        msg_spoiled     VARCHAR2(100)
    );
    
    TYPE policy_existing_claims_type IS RECORD(
        policy_no           VARCHAR2(50),
        has_claims          VARCHAR2(1),
        policy_id           GIPI_POLBASIC.POLICY_ID%TYPE,
        line_cd             GIPI_POLBASIC.LINE_CD%type,
        subline_cd          GIPI_POLBASIC.SUBLINE_CD%type,
        iss_cd              GIPI_POLBASIC.ISS_CD%type,
        issue_yy            GIPI_POLBASIC.ISSUE_YY%type,
        pol_seq_no          GIPI_POLBASIC.POL_SEQ_NO%type,
        renew_no            GIPI_POLBASIC.RENEW_NO%type,
        eff_date            GIPI_POLBASIC.EFF_DATE%type,
        pol_flag            GIPI_POLBASIC.POL_FLAG%type,
        endt_seq_no         GIPI_POLBASIC.ENDT_SEQ_NO%type,
        acct_ent_date       GIPI_POLBASIC.ACCT_ENT_DATE%type,
        spld_flag           GIPI_POLBASIC.SPLD_FLAG%type,
        prorate_flag        GIPI_POLBASIC.PRORATE_FLAG%TYPE,
        comp_sw             GIPI_POLBASIC.COMP_SW%TYPE,
        endt_expiry_date    GIPI_POLBASIC.ENDT_EXPIRY_DATE%TYPE,
        short_rt_percent    GIPI_POLBASIC.SHORT_RT_PERCENT%TYPE
    );
    
    TYPE when_new_form_giuts003a_tab IS TABLE OF when_new_form_giuts003a_type;
    
    TYPE giuts003a_policy_lov_tab IS TABLE OF giuts003a_policy_lov_type;
    
    TYPE giuts003a_spoil_lov_tab IS TABLE OF giuts003a_spoil_lov_type;
    
    TYPE giuts003a_pack_spoil_msg_tab IS TABLE OF giuts003a_pack_spoil_msg_type;
    
    TYPE policy_existing_claims_tab IS TABLE OF policy_existing_claims_type;
    
    
    FUNCTION when_new_form_giuts003a
    RETURN when_new_form_giuts003a_tab PIPELINED;
    
    FUNCTION get_pack_policy_giuts003a(
        p_module_id         VARCHAR2,
        p_pack_policy_id    GIPI_PACK_POLBASIC.PACK_POLICY_ID%TYPE,
        p_line_cd           GIPI_PACK_POLBASIC.LINE_CD%TYPE,
        p_subline_cd        GIPI_PACK_POLBASIC.SUBLINE_CD%TYPE,
        p_iss_cd            GIPI_PACK_POLBASIC.ISS_CD%TYPE,
        p_issue_yy          GIPI_PACK_POLBASIC.ISSUE_YY%TYPE,
        p_pol_seq_no        GIPI_PACK_POLBASIC.POL_SEQ_NO%TYPE,
        p_renew_no          GIPI_PACK_POLBASIC.RENEW_NO%TYPE,
		p_user_id           GIPI_PACK_POLBASIC.USER_ID%TYPE
    ) RETURN giuts003a_policy_lov_tab PIPELINED;
    
    
    FUNCTION get_spoil_giuts003a(p_find_text IN VARCHAR2)
    RETURN giuts003a_spoil_lov_tab PIPELINED;
    
    
    FUNCTION chk_pack_policy_for_spoilage(
        p_pack_policy_id        GIPI_POLBASIC.PACK_POLICY_ID%TYPE,
        p_iss_cd                GIPI_PACK_POLBASIC.ISS_CD%TYPE
        --p_msg_considered    OUT VARCHAR2,
        --p_msg_spoiled       OUT VARCHAR2
    ) RETURN giuts003a_pack_spoil_msg_tab PIPELINED;
    
    --added by kenneth 07132015 SR 4753
    PROCEDURE chk_pack_policy2(
        p_pack_policy_id        GIPI_POLBASIC.PACK_POLICY_ID%TYPE,
        p_iss_cd                GIPI_PACK_POLBASIC.ISS_CD%TYPE,
        p_message               OUT VARCHAR2 -- apollo cruz 11.13.2015 sr#20906 
        --p_msg_considered    OUT VARCHAR2,
        --p_msg_spoiled       OUT VARCHAR2
    );
    
    PROCEDURE chk_paid_policy(
        p_policy_id     GIPI_POLBASIC.POLICY_ID%TYPE,
        p_line_cd       GIPI_POLBASIC.LINE_CD%TYPE,
        p_iss_cd        GIPI_POLBASIC.ISS_CD%TYPE
    );
    
    PROCEDURE chk_reinsurance_payment(
        p_policy_id     GIPI_POLBASIC.POLICY_ID%TYPE,
        p_line_cd       GIPI_POLBASIC.LINE_CD%TYPE
    );
    
    PROCEDURE check_mrn(
        p_line_cd       GIPI_POLBASIC.LINE_CD%TYPE , 
        p_subline_cd    GIPI_POLBASIC.SUBLINE_CD%TYPE , 
        p_iss_cd        GIPI_POLBASIC.ISS_CD%TYPE , 
        p_issue_yy      GIPI_POLBASIC.ISSUE_YY%TYPE , 
        p_pol_seq_no    GIPI_POLBASIC.POL_SEQ_NO%TYPE , 
        p_renew_no      GIPI_POLBASIC.RENEW_NO%TYPE
    );
    
    PROCEDURE check_endorsement(
        p_policy_id     GIPI_POLBASIC.POLICY_ID%TYPE , 
        p_line_cd       GIPI_POLBASIC.LINE_CD%TYPE , 
        p_subline_cd    GIPI_POLBASIC.SUBLINE_CD%TYPE , 
        p_iss_cd        GIPI_POLBASIC.ISS_CD%TYPE , 
        p_issue_yy      GIPI_POLBASIC.ISSUE_YY%TYPE , 
        p_pol_seq_no    GIPI_POLBASIC.POL_SEQ_NO%TYPE , 
        p_renew_no      GIPI_POLBASIC.RENEW_NO%TYPE , 
        p_eff_date      GIPI_POLBASIC.EFF_DATE%TYPE , 
        p_pol_flag      GIPI_POLBASIC.POL_FLAG%TYPE , 
        p_endt_seq_no   GIPI_POLBASIC.ENDT_SEQ_NO%TYPE 
    );
                  
    PROCEDURE pack_spoil(
        p_spoil_cd           GIPI_PACK_POLBASIC.SPOIL_CD%TYPE,
        p_pack_policy_id     GIPI_PACK_POLBASIC.PACK_POLICY_ID%TYPE,
        p_spld_flag          GIPI_PACK_POLBASIC.SPLD_FLAG%TYPE,
        p_user_id             GIIS_USERS.user_id%TYPE,
        p_mean_pol_flag OUT  VARCHAR2
    );
    
    PROCEDURE pack_unspoil(
        p_iss_cd            GIPI_PACK_POLBASIC.ISS_CD%TYPE,
        p_pack_policy_id    GIPI_PACK_POLBASIC.PACK_POLICY_ID%TYPE,
        p_spld_flag         GIPI_PACK_POLBASIC.SPLD_FLAG%TYPE,
        p_mean_pol_flag OUT VARCHAR2
    );
    
    
    PROCEDURE chk_pack_policy_post(
        p_module_id             GIIS_USER_GRP_MODULES.MODULE_ID%TYPE,
        p_line_cd               GIPI_PACK_POLBASIC.LINE_CD%TYPE,
        p_iss_cd                GIPI_PACK_POLBASIC.ISS_CD%TYPE,
        p_pack_policy_id        GIPI_PACK_POLBASIC.PACK_POLICY_ID%TYPE,
        p_user_id               GIPI_POLBASIC.USER_ID%TYPE,
        p_continue_spoilage     VARCHAR,
        p_start         IN OUT  NUMBER,
        p_policy_no        OUT  VARCHAR2,
        p_mean_pol_flag    OUT  VARCHAR2,
        p_ann_prem_amt     OUT  GIPI_PACK_POLBASIC.ANN_PREM_AMT%TYPE,
        p_ann_tsi_amt      OUT  GIPI_PACK_POLBASIC.ANN_TSI_AMT%TYPE,
        p_msg_considered   OUT  VARCHAR2,
        p_final_msg        OUT  VARCHAR2
    );
    
    PROCEDURE chk_reinsurance(
        p_dist_no       NUMBER,
        p_line_cd       giuw_policyds_dtl.LINE_CD%TYPE
    );
    
    PROCEDURE update_affected_endt(
        p_policy_id         GIPI_POLBASIC.POLICY_ID%TYPE , 
        p_line_cd           GIPI_POLBASIC.LINE_CD%TYPE , 
        p_subline_cd        GIPI_POLBASIC.SUBLINE_CD%TYPE , 
        p_iss_cd            GIPI_POLBASIC.ISS_CD%TYPE , 
        p_issue_yy          GIPI_POLBASIC.ISSUE_YY%TYPE , 
        p_pol_seq_no        GIPI_POLBASIC.POL_SEQ_NO%TYPE , 
        p_renew_no          GIPI_POLBASIC.RENEW_NO%TYPE ,
        p_prorate_flag      GIPI_POLBASIC.PRORATE_FLAG%TYPE , 
        p_comp_sw           GIPI_POLBASIC.COMP_SW%TYPE , 
        p_endt_expiry_date  GIPI_POLBASIC.ENDT_EXPIRY_DATE%TYPE , 
        p_eff_date          GIPI_POLBASIC.EFF_DATE%TYPE , 
        p_short_rt_percent  GIPI_POLBASIC.SHORT_RT_PERCENT%TYPE
    );
    
    PROCEDURE pack_post(
        p_pack_policy_id    GIPI_PACK_POLBASIC.PACK_POLICY_ID%TYPE,
        p_line_cd           GIPI_PACK_POLBASIC.LINE_CD%TYPE,
        p_subline_cd        GIPI_PACK_POLBASIC.SUBLINE_CD%TYPE,
        p_iss_cd            GIPI_PACK_POLBASIC.ISS_CD%TYPE,
        p_issue_yy          GIPI_PACK_POLBASIC.ISSUE_YY%TYPE,
        p_pol_seq_no        GIPI_PACK_POLBASIC.POL_SEQ_NO%TYPE,
        p_renew_no          GIPI_PACK_POLBASIC.RENEW_NO%TYPE,
        p_spld_flag         GIPI_PACK_POLBASIC.SPLD_FLAG%TYPE,
        p_user_id           GIPI_PACK_POLBASIC.SPLD_APPROVAL%TYPE,
        p_mean_pol_flag OUT VARCHAR2,
        p_ann_prem_amt  OUT GIPI_PACK_POLBASIC.ANN_PREM_AMT%TYPE,
        p_ann_tsi_amt   OUT GIPI_PACK_POLBASIC.ANN_TSI_AMT%TYPE
    );
    
END GIUTS003A_PKG;
/


