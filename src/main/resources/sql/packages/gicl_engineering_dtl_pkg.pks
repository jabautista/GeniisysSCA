CREATE OR REPLACE PACKAGE CPI.GICL_ENGINEERING_DTL_PKG
AS

    TYPE gicl_engineering_dtl_type IS RECORD (
        claim_id                GICL_ENGINEERING_DTL.claim_id%TYPE,
        item_no                 GICL_ENGINEERING_DTL.item_no%TYPE,
        item_title              GICL_ENGINEERING_DTL.item_title%TYPE,
        dsp_item_title          VARCHAR2(50),
        item_desc               GICL_ENGINEERING_DTL.item_desc%TYPE,
        item_desc2              GICL_ENGINEERING_DTL.item_desc2%TYPE,
        currency_cd             GICL_ENGINEERING_DTL.currency_cd%TYPE,
        dsp_curr_desc           VARCHAR2(30),
        currency_rate           GICL_ENGINEERING_DTL.currency_rate%TYPE,
        region_cd               GICL_ENGINEERING_DTL.region_cd%TYPE,
        dsp_region              VARCHAR2(40),
        province_cd             GICL_ENGINEERING_DTL.province_cd%TYPE,
        dsp_province            VARCHAR2(30),
        loss_date               GICL_ENGINEERING_DTL.loss_date%TYPE,
        gicl_item_peril_exist   VARCHAR2(1),
        gicl_item_peril_msg     VARCHAR2(1),
        loss_date_char        VARCHAR2(30)      -- shan 04.15.2014
    );
    
    TYPE gicl_engineering_dtl_tab IS TABLE OF gicl_engineering_dtl_type;
    
    TYPE gicl_engineering_dtl_cur IS REF CURSOR RETURN gicl_engineering_dtl_type;
    
    FUNCTION get_gicl_engineering_dtl_list(p_claim_id       GICL_ENGINEERING_DTL.claim_id%TYPE)
      RETURN gicl_engineering_dtl_tab PIPELINED;
      
    PROCEDURE load_gicls021_items(p_claim_id        IN     GICL_ENGINEERING_DTL.claim_id%TYPE,
                                  p_control_claim_number       OUT VARCHAR2,
                                  p_control_policy_number      OUT VARCHAR2,
                                  p_control_dsp_line_cd        OUT GICL_CLAIMS.line_cd%TYPE,
                                  p_control_dsp_subline_cd     OUT GICL_CLAIMS.subline_cd%TYPE,
                                  p_control_dsp_iss_cd         OUT GICL_CLAIMS.iss_cd%TYPE,
                                  p_control_dsp_issue_yy       OUT GICL_CLAIMS.issue_yy%TYPE,
                                  p_control_dsp_pol_seq_no     OUT GICL_CLAIMS.pol_seq_no%TYPE,
                                  p_control_dsp_renew_no       OUT GICL_CLAIMS.renew_no%TYPE,
                                  p_control_dsp_pol_iss_cd     OUT GICL_CLAIMS.pol_iss_cd%TYPE,
                                  p_control_dsp_loss_date      OUT GICL_CLAIMS.dsp_loss_date%TYPE,
                                  p_control_loss_date          OUT GICL_CLAIMS.loss_date%TYPE,
                                  p_control_assured            OUT GICL_CLAIMS.assured_name%TYPE,
                                  p_control_loss_ctgry         OUT VARCHAR2,
                                  p_ctrl_expiry_date           OUT GICL_CLAIMS.expiry_date%TYPE,
                                  p_control_pol_eff_date       OUT GICL_CLAIMS.pol_eff_date%TYPE,
                                  p_control_claim_id           OUT GICL_CLAIMS.claim_id%TYPE,
                                  p_control_clm_stat_desc      OUT GIIS_CLM_STAT.clm_stat_desc%TYPE,
                                  p_control_loss_cat_cd        OUT GICL_CLAIMS.loss_cat_cd%TYPE,
                                  p_control_cat_peril_cd       OUT GIIS_LOSS_CTGRY.peril_cd%TYPE,
                                  p_max_record_allowed         OUT NUMBER);
                                  
    PROCEDURE set_gicl_engineering_dtl(
        p_claim_id          GICL_ENGINEERING_DTL.claim_id%TYPE,
        p_item_no           GICL_ENGINEERING_DTL.item_no%TYPE,
        p_currency_cd       GICL_ENGINEERING_DTL.currency_cd%TYPE,
        p_item_title        GICL_ENGINEERING_DTL.item_title%TYPE,
        p_item_desc         GICL_ENGINEERING_DTL.item_desc%TYPE,
        p_item_desc2        GICL_ENGINEERING_DTL.item_desc2%TYPE,
        p_cpi_rec_no        GICL_ENGINEERING_DTL.cpi_rec_no%TYPE,
        p_cpi_branch_cd     GICL_ENGINEERING_DTL.cpi_branch_cd%TYPE,
        p_region_cd         GICL_ENGINEERING_DTL.region_cd%TYPE,
        p_province_cd       GICL_ENGINEERING_DTL.province_cd%TYPE,
        p_currency_rate     GICL_ENGINEERING_DTL.currency_rate%TYPE);
        
    PROCEDURE del_gicl_engineering_dtl(
        p_claim_id      gicl_engineering_dtl.claim_id%TYPE,
        p_item_no       gicl_engineering_dtl.item_no%TYPE);
        
    PROCEDURE extract_engr_data(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE,
        p_claim_id              gicl_claims.claim_id%type,
        c034            IN OUT  gicl_engineering_dtl_pkg.gicl_engineering_dtl_type
        );
        
    FUNCTION get_gicl_engineering_dtl(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_incept_date           gipi_polbasic.incept_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE,
        p_claim_id              gicl_claims.claim_id%type)
    RETURN gicl_engineering_dtl_tab PIPELINED;
        
    FUNCTION check_engineering_item_no (
        p_claim_id        gicl_engineering_dtl.claim_id%TYPE,
        p_item_no         gicl_engineering_dtl.item_no%TYPE,
        p_start_row       VARCHAR2,
        p_end_row         VARCHAR2
    ) RETURN VARCHAR2;
    
    PROCEDURE validate_gicl_engineering_dtl(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_incept_date           gipi_polbasic.incept_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE,
        p_claim_id              gicl_fire_dtl.claim_id%TYPE,
        p_from                  VARCHAR2,
        p_to                    VARCHAR2,
        c014                OUT GICL_ENGINEERING_DTL_PKG.gicl_engineering_dtl_cur,
        p_item_exist        OUT NUMBER,
        p_override_fl       OUT VARCHAR2,
        p_tloss_fl          OUT VARCHAR2,
        p_item_exist2       OUT VARCHAR2
        );

END GICL_ENGINEERING_DTL_PKG;
/


