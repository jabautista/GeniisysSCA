CREATE OR REPLACE PACKAGE CPI.GICL_MARINE_HULL_DTL_PKG
AS
/**
* Rey Jadlocon 11-29-2011
* created GICL_MARINE_HULL_DTL_PKG
**/
    TYPE gicl_marine_hull_dtl_type IS RECORD(
        line_cd                 gicl_claims.line_cd%TYPE,
        dsp_loss_date           GICL_CLAIMS.DSP_LOSS_DATE%TYPE,
        assured_name            GICL_CLAIMS.ASSURED_NAME%TYPE,
        renew_no                GICL_CLAIMS.RENEW_NO%TYPE,
        pol_seq_no              gicl_claims.pol_seq_no%TYPE,
        issue_yy                gicl_claims.issue_yy%TYPE,
        pol_iss_cd              gicl_claims.pol_iss_cd%TYPE,
        subline_cd              gicl_claims.subline_cd%TYPE,
        expiry_date             gicl_claims.expiry_date%TYPE,
        pol_eff_date            gicl_claims.pol_eff_date%TYPE,
        claim_id                gicl_hull_dtl.claim_id%TYPE,
        item_no                 gicl_hull_dtl.item_no%TYPE,
        currency_cd             gicl_hull_dtl.currency_cd%TYPE,
        last_update             gicl_hull_dtl.last_update%TYPE,
        item_title              gicl_hull_dtl.item_title%TYPE,
        vessel_cd               gicl_hull_dtl.vessel_cd%TYPE,
        geog_limit              gicl_hull_dtl.geog_limit%TYPE,
        deduct_text             gicl_hull_dtl.deduct_text%TYPE,
        dry_place               gicl_hull_dtl.dry_place%TYPE,
        dry_date                gicl_hull_dtl.dry_date%TYPE,
        loss_date               gicl_hull_dtl.loss_date%TYPE,
        currency_rate           gicl_hull_dtl.currency_rate%TYPE,
        item_desc               gicl_clm_item.item_desc%TYPE,
        item_desc2              gicl_clm_item.item_desc2%TYPE,
        currency_desc           giis_currency.currency_desc%TYPE,
        vessel_name             giis_vessel.vessel_name%TYPE,
        vestype_cd              giis_vessel.vestype_cd%TYPE,
        vessel_old_name         giis_vessel.vessel_old_name%TYPE,
        propel_sw               giis_vessel.propel_sw%TYPE,
        hull_type_cd            giis_vessel.hull_type_cd%TYPE,
        reg_owner               giis_vessel.reg_owner%TYPE,
        reg_place               giis_vessel.reg_place%TYPE,
        gross_ton               giis_vessel.gross_ton%TYPE,
        net_ton                 giis_vessel.net_ton%TYPE,
        deadweight              giis_vessel.deadweight%TYPE,
        year_built              giis_vessel.year_built%TYPE,
        vess_class_cd           giis_vessel.vess_class_cd%TYPE,
        crew_nat                giis_vessel.crew_nat%TYPE,
        no_crew                 giis_vessel.no_crew%TYPE,
        vessel_length           giis_vessel.vessel_length%TYPE,
        vessel_breadth          giis_vessel.vessel_breadth%TYPE,
        vessel_depth            giis_vessel.vessel_depth%TYPE,
        vestype_desc            giis_vestype.vestype_desc%TYPE,
        hull_desc               giis_hull_type.hull_desc%TYPE,
        vess_class_desc         giis_vess_class.vess_class_desc%TYPE,
        msg_alert               VARCHAR2(32000),
        gicl_item_peril_exist   VARCHAR2(1),
        gicl_mortgagee_exist    VARCHAR2(1),
        gicl_item_peril_msg     VARCHAR2(1),
        loss_date_char          VARCHAR2(30)    -- shan 04.15.2014
    );
    
    TYPE gicl_marine_hull_dtl_tab IS TABLE OF gicl_marine_hull_dtl_type;
    
    TYPE gicl_marine_hull_dtl_cur IS REF CURSOR RETURN gicl_marine_hull_dtl_type;
 
FUNCTION get_gicl_marine_hull_dtl(p_claim_id            gicl_hull_dtl.claim_id%TYPE)
        RETURN gicl_marine_hull_dtl_tab PIPELINED;

/**
* Rey Jadlocon
* 01-12-2011
**/

TYPE get_marine_hull_item_info_type IS RECORD(
        claim_no                    VARCHAR2(50),
        policy_no                   VARCHAR2(50),
        line_cd                     gicl_claims.line_cd%TYPE,
        dsp_loss_date               GICL_CLAIMS.DSP_LOSS_DATE%TYPE,
        assured_name                GICL_CLAIMS.ASSURED_NAME%TYPE,
        renew_no                    GICL_CLAIMS.RENEW_NO%TYPE,
        pol_seq_no                  gicl_claims.pol_seq_no%TYPE,
        issue_yy                    gicl_claims.issue_yy%TYPE,
        pol_iss_cd                  gicl_claims.pol_iss_cd%TYPE,
        subline_cd                  gicl_claims.subline_cd%TYPE,
        expiry_date                 gicl_claims.expiry_date%TYPE,
        pol_eff_date                gicl_claims.pol_eff_date%TYPE,
        claim_id                    gicl_claims.claim_id%TYPE,
        clm_stat_desc               giis_clm_stat.clm_stat_desc%TYPE,
        catastrophic_cd             gicl_claims.catastrophic_cd%TYPE,
        clm_file_date               gicl_claims.clm_file_date%TYPE,
        loss_cat_cd                 gicl_claims.loss_cat_cd%TYPE,
        item_no                     gicl_item_peril.item_no%TYPE,
        peril_cd                    gicl_item_peril.peril_cd%TYPE,
        close_flag                  gicl_item_peril.close_flag%TYPE,
        item_title                  gicl_hull_dtl.item_title%TYPE,
        currency_cd                 gicl_hull_dtl.currency_cd%TYPE,
        currency_desc               giis_currency.currency_desc%TYPE,
        currency_rate               gicl_hull_dtl.currency_rate%TYPE,
        item_desc                   gicl_clm_item.item_desc%TYPE,
        item_desc2                  gicl_clm_item.item_desc2%TYPE,
        vessel_cd                   gicl_hull_dtl.vessel_cd%TYPE,
        geog_limit                  gicl_hull_dtl.geog_limit%TYPE,
        deduct_text                 gicl_hull_dtl.deduct_text%TYPE,
        dry_date                    gicl_hull_dtl.dry_date%TYPE,
        dry_place                   gicl_hull_dtl.dry_place%TYPE,
        loss_date                   gicl_hull_dtl.loss_date%TYPE,
        last_update                 gicl_hull_dtl.last_update%TYPE,
        vessel_name                 giis_vessel.vessel_name%TYPE,
        vestype_cd                  giis_vessel.vestype_cd%TYPE,
        vessel_old_name             giis_vessel.vessel_old_name%TYPE,
        propel_sw                   giis_vessel.propel_sw%TYPE,
        hull_type_cd                giis_vessel.hull_type_cd%TYPE,
        reg_owner                   giis_vessel.reg_owner%TYPE,
        reg_place                   giis_vessel.reg_place%TYPE,
        gross_ton                   giis_vessel.gross_ton%TYPE,
        net_ton                     giis_vessel.net_ton%TYPE, 
        deadweight                  giis_vessel.deadweight%TYPE,
        year_built                  giis_vessel.year_built%TYPE,
        vess_class_cd               giis_vessel.vess_class_cd%TYPE,
        crew_nat                    giis_vessel.crew_nat%TYPE,
        no_crew                     giis_vessel.no_crew%TYPE,
        vessel_length               giis_vessel.vessel_length%TYPE,
        vessel_breadth              giis_vessel.vessel_breadth%TYPE,
        vessel_depth                giis_vessel.vessel_depth%TYPE,
        vestype_desc                giis_vestype.vestype_desc%TYPE,
        hull_desc                   giis_hull_type.hull_desc%TYPE,
        vess_class_desc             giis_vess_class.vess_class_desc%TYPE,
        itm                         VARCHAR2 (10),
        gicl_item_peril_exist       VARCHAR2 (1),
        gicl_mortgagee_exist        VARCHAR2 (1),
        gicl_item_peril_msg         VARCHAR2 (1)
    );
    TYPE get_marine_hull_item_info_tab IS TABLE OF get_marine_hull_item_info_type;
    
    
    FUNCTION get_marine_hull_item_info(p_claim_id       gicl_claims.claim_id%TYPE)
            RETURN get_marine_hull_item_info_tab  PIPELINED;

/**
* Rey Jadlocon
* 01-12-2011
**/
FUNCTION check_marine_hull_item_no(
            p_claim_id          gicl_hull_dtl.claim_id%TYPE,
            p_item_no           gicl_hull_dtl.item_no%TYPE,
            p_start_row         VARCHAR2,
            p_end_row           VARCHAR2
            )
            RETURN VARCHAR2;
 
/**
*Rey Jadlocon
* 02-12-2011
**/
  PROCEDURE extract_mh_details(p_renew_no         gicl_claims.renew_no%TYPE,
                             p_pol_seq_no       gicl_claims.pol_seq_no%TYPE,
                             p_issue_yy         gicl_claims.issue_yy%TYPE,
                             p_pol_iss_cd       gicl_claims.pol_iss_cd%TYPE,
                             p_subline_cd       gicl_claims.subline_cd%TYPE,
                             p_line_cd          gicl_claims.line_cd%TYPE,
                             p_pol_eff_date     gicl_claims.pol_eff_date%TYPE,
                             p_loss_date        gicl_claims.loss_date%TYPE,
                             p_expiry_date      gicl_claims.expiry_date%TYPE,
                             p_item_no          gicl_hull_dtl.item_no%TYPE,
                             p_claim_id         gicl_hull_dtl.claim_id%TYPE,
                             MHdata     IN OUT  gicl_marine_hull_dtl_type);
                             
/**
* Rey Jadlocon
* 02-12-2011
**/
FUNCTION get_marine_hull_dtl(p_renew_no         gicl_claims.renew_no%TYPE,
                             p_pol_seq_no       gicl_claims.pol_seq_no%TYPE,
                             p_issue_yy         gicl_claims.issue_yy%TYPE,
                             p_pol_iss_cd       gicl_claims.pol_iss_cd%TYPE,
                             p_subline_cd       gicl_claims.subline_cd%TYPE,
                             p_line_cd          gicl_claims.line_cd%TYPE,
                             p_pol_eff_date     gicl_claims.pol_eff_date%TYPE,
                             p_loss_date        gicl_claims.loss_date%TYPE,
                             p_expiry_date      gicl_claims.expiry_date%TYPE,
                             p_item_no          gicl_hull_dtl.item_no%TYPE,
                             p_claim_id         gicl_hull_dtl.claim_id%TYPE)
          RETURN gicl_marine_hull_dtl_tab PIPELINED;
/**
* Rey Jadlocon
* 02-12-2011
**/ 
PROCEDURE validate_gicl_marine_hull_dtl(
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
                                p_claim_id              gicl_hull_dtl.claim_id%TYPE,
                                p_from                  VARCHAR2,
                                p_to                    VARCHAR2,
                                marine_hull         OUT GICL_MARINE_HULL_DTL_PKG.gicl_marine_hull_dtl_cur,
                                p_item_exist        OUT NUMBER,
                                p_override_fl       OUT VARCHAR2,
                                p_tloss_fl          OUT VARCHAR2,
                                p_item_exist2       OUT VARCHAR2);
                                
/**
* Rey Jadlocon
* 02-12-2011
**/         
FUNCTION get_marine_hull_item_lov(p_claim_id        gicl_claims.claim_id%TYPE)
         RETURN gicl_marine_hull_dtl_tab PIPELINED;              
/**
* Rey Jadlocon
* 05-12-2011
**/        
PROCEDURE set_gicl_marine_hull_dtl(p_claim_id           gicl_hull_dtl.claim_id%TYPE,
                                   p_item_no            gicl_hull_dtl.item_no%TYPE,
                                   p_currency_cd        gicl_hull_dtl.currency_cd%TYPE,
                                   p_user_id            gicl_hull_dtl.user_id%TYPE,
                                   p_last_update        gicl_hull_dtl.last_update%TYPE,
                                   p_item_title         gicl_hull_dtl.item_title%TYPE,
                                   p_vessel_cd          gicl_hull_dtl.vessel_cd%TYPE,
                                   p_geog_limit         gicl_hull_dtl.geog_limit%TYPE,
                                   p_deduct_text        gicl_hull_dtl.deduct_text%TYPE,
                                   p_dry_date           gicl_hull_dtl.dry_date%TYPE,
                                   p_dry_place          gicl_hull_dtl.dry_place%TYPE,
                                   p_cpi_rec_no         gicl_hull_dtl.cpi_rec_no%TYPE,
                                   p_cpi_branch_cd      gicl_hull_dtl.cpi_branch_cd%TYPE,
                                   p_loss_date          gicl_hull_dtl.loss_date%TYPE,
                                   p_currency_rate      gicl_hull_dtl.currency_rate%TYPE);

/**
* Rey Jadlocon
* 05-12-2011
**/         
FUNCTION check_existing_item(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE) 
    RETURN NUMBER;  
    
/**
* Rey Jadlocon
* 05-12-2011
**/         
PROCEDURE del_gicl_marine_hull_dtl(
            p_claim_id          gicl_hull_dtl.claim_id%TYPE,
            p_item_no           gicl_hull_dtl.item_no%TYPE
            );
            
/**
* Rey Jadlocon
* 05-12-2011
**/         
FUNCTION get_gicl_marine_hull_dtl_exist( 
        p_claim_id          gicl_hull_dtl.claim_id%TYPE
        ) 
    RETURN VARCHAR2;                              
         
END GICL_MARINE_HULL_DTL_PKG;
/


