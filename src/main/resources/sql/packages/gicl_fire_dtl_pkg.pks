CREATE OR REPLACE PACKAGE CPI.GICL_FIRE_DTL_PKG
AS
    TYPE gicl_fire_dtl_type IS RECORD(
        claim_id              gicl_fire_dtl.claim_id%TYPE,
        item_no               gicl_fire_dtl.item_no%TYPE,
        currency_cd           gicl_fire_dtl.currency_cd%TYPE,
        user_id               gicl_fire_dtl.user_id%TYPE,
        last_update           gicl_fire_dtl.last_update%TYPE,
        item_title            gicl_fire_dtl.item_title%TYPE,
        district_no           gicl_fire_dtl.district_no%TYPE,
        eq_zone               gicl_fire_dtl.eq_zone%TYPE,
        tarf_cd               gicl_fire_dtl.tarf_cd%TYPE,
        block_no              gicl_fire_dtl.block_no%TYPE,
        block_id              gicl_fire_dtl.block_id%TYPE,
        fr_item_type          gicl_fire_dtl.fr_item_type%TYPE,
        loc_risk1             gicl_fire_dtl.loc_risk1%TYPE,
        loc_risk2             gicl_fire_dtl.loc_risk2%TYPE,
        loc_risk3             gicl_fire_dtl.loc_risk3%TYPE,
        tariff_zone           gicl_fire_dtl.tariff_zone%TYPE,
        typhoon_zone          gicl_fire_dtl.typhoon_zone%TYPE,
        construction_cd       gicl_fire_dtl.construction_cd%TYPE,
        construction_remarks  gicl_fire_dtl.construction_remarks%TYPE,
        front                 gicl_fire_dtl.front%TYPE,
        right                 gicl_fire_dtl.right%TYPE,
        left                  gicl_fire_dtl.left%TYPE,
        rear                  gicl_fire_dtl.rear%TYPE,
        occupancy_cd          gicl_fire_dtl.occupancy_cd%TYPE,
        occupancy_remarks     gicl_fire_dtl.occupancy_remarks%TYPE,
        flood_zone            gicl_fire_dtl.flood_zone%TYPE,
        assignee              gicl_fire_dtl.assignee%TYPE,
        cpi_rec_no            gicl_fire_dtl.cpi_rec_no%TYPE,
        cpi_branch_cd         gicl_fire_dtl.cpi_branch_cd%TYPE,
        loss_date             gicl_fire_dtl.loss_date%TYPE,
        currency_rate         gicl_fire_dtl.currency_rate%TYPE,
        risk_cd               gicl_fire_dtl.risk_cd%TYPE,
        risk_desc             giis_risks.risk_desc%TYPE,
        item_desc             gicl_clm_item.item_desc%TYPE,
        item_desc2            gicl_clm_item.item_desc2%TYPE,
        dsp_item_type         giis_fi_item_type.fr_itm_tp_ds%TYPE,
        dsp_eq_zone           giis_eqzone.eq_desc%TYPE,
        dsp_tariff_zone       giis_tariff_zone.tariff_zone_desc%TYPE,
        dsp_typhoon           giis_typhoon_zone.typhoon_zone_desc%TYPE,
        dsp_construction      giis_fire_construction.construction_cd%TYPE,
        dsp_occupancy         giis_fire_occupancy.occupancy_cd%TYPE,
        dsp_flood_zone        giis_flood_zone.flood_zone_desc%TYPE, --benjo 09.08.2015 GENQA-SR-4874 flood_zone -> flood_zone_desc
        dsp_currency_desc     giis_currency.currency_desc%TYPE,
        msg_alert             VARCHAR2(32000),
        gicl_item_peril_exist VARCHAR2(1),
        gicl_mortgagee_exist  VARCHAR2(1),
        gicl_item_peril_msg   VARCHAR2(1),
        loss_date_char        VARCHAR2(30)      -- shan 04.15.2014
        );
        
    TYPE gicl_fire_dtl_tab IS TABLE OF gicl_fire_dtl_type;   
    
    TYPE gicl_fire_dtl_cur IS REF CURSOR RETURN gicl_fire_dtl_type;  
    
    PROCEDURE c014_detail_chk(c014            IN OUT gicl_fire_dtl_type);    
    
    FUNCTION get_gicl_fire_dtl(
        p_claim_id              gicl_fire_dtl.claim_id%TYPE
        )
    RETURN gicl_fire_dtl_tab PIPELINED;
     
    PROCEDURE extract_fire_data(
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
        c014            IN OUT gicl_fire_dtl_type
        );
        
    FUNCTION get_gicl_fire_dtl(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy             gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no             gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_incept_date           gipi_polbasic.incept_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE)
    RETURN gicl_fire_dtl_tab PIPELINED;
            
    PROCEDURE validate_gicl_fire_dtl(
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
        c014                OUT GICL_FIRE_DTL_PKG.gicl_fire_dtl_cur,
        p_item_exist        OUT NUMBER,
        p_override_fl       OUT VARCHAR2,
        p_tloss_fl          OUT VARCHAR2,
        p_item_exist2       OUT VARCHAR2
        );
        
    FUNCTION check_fire_item_no (
        p_claim_id        gicl_fire_dtl.claim_id%TYPE,
        p_item_no         gicl_fire_dtl.item_no%TYPE,
        p_start_row       VARCHAR2,
        p_end_row         VARCHAR2
    ) 
    RETURN VARCHAR2;
         
    PROCEDURE del_gicl_fire_dtl(
        p_claim_id      gicl_fire_dtl.claim_id%TYPE,
        p_item_no       gicl_fire_dtl.item_no%TYPE
        );
        
    PROCEDURE set_gicl_fire_dtl(
        p_claim_id              gicl_fire_dtl.claim_id%TYPE,
        p_item_no               gicl_fire_dtl.item_no%TYPE,
        p_currency_cd           gicl_fire_dtl.currency_cd%TYPE,
        p_user_id               gicl_fire_dtl.user_id%TYPE,
        p_last_update           gicl_fire_dtl.last_update%TYPE,
        p_item_title            gicl_fire_dtl.item_title%TYPE,
        p_district_no           gicl_fire_dtl.district_no%TYPE,
        p_eq_zone               gicl_fire_dtl.eq_zone%TYPE,
        p_tarf_cd               gicl_fire_dtl.tarf_cd%TYPE,
        p_block_no              gicl_fire_dtl.block_no%TYPE,
        p_block_id              gicl_fire_dtl.block_id%TYPE,
        p_fr_item_type          gicl_fire_dtl.fr_item_type%TYPE,
        p_loc_risk1             gicl_fire_dtl.loc_risk1%TYPE,
        p_loc_risk2             gicl_fire_dtl.loc_risk2%TYPE,
        p_loc_risk3             gicl_fire_dtl.loc_risk3%TYPE,
        p_tariff_zone           gicl_fire_dtl.tariff_zone%TYPE,
        p_typhoon_zone          gicl_fire_dtl.typhoon_zone%TYPE,
        p_construction_cd       gicl_fire_dtl.construction_cd%TYPE,
        p_construction_remarks  gicl_fire_dtl.construction_remarks%TYPE,
        p_front                 gicl_fire_dtl.front%TYPE,
        p_right                 gicl_fire_dtl.right%TYPE,
        p_left                  gicl_fire_dtl.left%TYPE,
        p_rear                  gicl_fire_dtl.rear%TYPE,
        p_occupancy_cd          gicl_fire_dtl.occupancy_cd%TYPE,
        p_occupancy_remarks     gicl_fire_dtl.occupancy_remarks%TYPE,
        p_flood_zone            gicl_fire_dtl.flood_zone%TYPE,
        p_assignee              gicl_fire_dtl.assignee%TYPE,
        p_cpi_rec_no            gicl_fire_dtl.cpi_rec_no%TYPE,
        p_cpi_branch_cd         gicl_fire_dtl.cpi_branch_cd%TYPE,
        p_loss_date             gicl_fire_dtl.loss_date%TYPE,
        p_currency_rate         gicl_fire_dtl.currency_rate%TYPE,
        p_risk_cd               gicl_fire_dtl.risk_cd%TYPE
        );
           
    FUNCTION get_gicl_fire_dtl_exist( 
        p_claim_id          gicl_fire_dtl.claim_id%TYPE
        ) 
    RETURN VARCHAR2;
    
    --kenneth SR4855 10072015
    TYPE gipi_item_type IS RECORD (
        policy_id       GIPI_ITEM.policy_id%TYPE,
        item_no         GIPI_ITEM.item_no%TYPE,
        item_title      GIPI_ITEM.item_title%TYPE,
        item_grp        GIPI_ITEM.item_grp%TYPE,
        item_desc       GIPI_ITEM.item_desc%TYPE,
        item_desc2      GIPI_ITEM.item_desc2%TYPE,
        tsi_amt         GIPI_ITEM.tsi_amt%TYPE,
        prem_amt        GIPI_ITEM.prem_amt%TYPE,
        ann_tsi_amt     GIPI_ITEM.ann_tsi_amt%TYPE,
        ann_prem_amt    GIPI_ITEM.ann_prem_amt%TYPE,
        rec_flag        GIPI_ITEM.rec_flag%TYPE,    
        currency_cd     GIPI_ITEM.currency_cd%TYPE,
        currency_rt     GIPI_ITEM.currency_rt%TYPE,
        group_cd        GIPI_ITEM.group_cd%TYPE,
        from_date       GIPI_ITEM.from_date%TYPE,
        to_date         GIPI_ITEM.to_date%TYPE,
        pack_line_cd    GIPI_ITEM.pack_line_cd%TYPE,
        pack_subline_cd GIPI_ITEM.pack_subline_cd%TYPE,
        discount_sw     GIPI_ITEM.discount_sw%TYPE,
        coverage_cd     GIPI_ITEM.coverage_cd%TYPE,
        other_info      GIPI_ITEM.other_info%TYPE,
        surcharge_sw    GIPI_ITEM.surcharge_sw%TYPE,
        region_cd       GIPI_ITEM.region_cd%TYPE,
        changed_tag     GIPI_ITEM.changed_tag%TYPE,
        comp_sw         GIPI_ITEM.comp_sw%TYPE,
        short_rt_percent GIPI_ITEM.short_rt_percent%TYPE,
        pack_ben_cd     GIPI_ITEM.pack_ben_cd%TYPE,
        payt_terms      GIPI_ITEM.payt_terms%TYPE,
        risk_no         GIPI_ITEM.risk_no%TYPE,
        risk_item_no    GIPI_ITEM.risk_item_no%TYPE,
        prorate_flag    GIPI_ITEM.prorate_flag%TYPE,
        currency_desc   GIIS_CURRENCY.currency_desc%TYPE,
        grouped_item_no         GICL_ACCIDENT_DTL.grouped_item_no%TYPE,
        grouped_item_title      GICL_ACCIDENT_DTL.grouped_item_title%TYPE);
    
    TYPE gipi_item_tab IS TABLE OF gipi_item_type;
  
    --kenneth SR4855 10072015
    FUNCTION get_item_no_list(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE
        )
    RETURN gipi_item_tab PIPELINED;
    
    --kenneth SR4855 10072015
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
                        
END gicl_fire_dtl_pkg;
/


