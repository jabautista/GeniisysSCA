CREATE OR REPLACE PACKAGE CPI.GICL_PRELIM_LOSS_REPORT_PKG AS

    TYPE prelim_loss_info_type IS RECORD (
        line_cd             GICL_CLAIMS.line_cd%TYPE,
        subline_cd          GICL_CLAIMS.subline_cd%TYPE,
        iss_cd              GICL_CLAIMS.iss_cd%TYPE,
        issue_yy            GICL_CLAIMS.issue_yy%TYPE,
        pol_seq_no          GICL_CLAIMS.pol_seq_no%TYPE,
        renew_no            GICL_CLAIMS.renew_no%TYPE,
        clm_yy              GICL_CLAIMS.clm_yy%TYPE,
        clm_seq_no          GICL_CLAIMS.clm_seq_no%TYPE,
        claim_no            VARCHAR2(50),
        policy_no           VARCHAR2(50),
        issue_date          VARCHAR2(50),
        incept_date         VARCHAR2(50),
        expiry_date         VARCHAR2(50),
        assd_name           GIIS_ASSURED.assd_name%TYPE,
        bill_address        VARCHAR2(250),
        loss_cat_des        GIIS_LOSS_CTGRY.loss_cat_des%TYPE,
        mortg_name          GICL_MORTGAGEE_V1.mortg_name%TYPE,
        intm_name           GICL_BASIC_INTM_V1.intm_name%TYPE,
        intm_no             GICL_BASIC_INTM_V1.intrmdry_intm_no%TYPE,
        loss_loc1           GICL_CLAIMS.loss_loc1%TYPE,
        loss_loc2           GICL_CLAIMS.loss_loc2%TYPE,
        loss_loc3           GICL_CLAIMS.loss_loc3%TYPE,
        loss_date           VARCHAR2(50),
        clm_file_date       VARCHAR2(50)
    );
    TYPE prelim_loss_info_tab IS TABLE OF prelim_loss_info_type;
    
    TYPE fire_item_info_type IS RECORD (
        item_no             GICL_FIRE_DTL.item_no%TYPE,
        item_title          GICL_FIRE_DTL.item_title%TYPE,
        loc_risk            VARCHAR2(1000),
        ann_tsi_amt         GICL_ITEM_PERIL.ann_tsi_amt%TYPE
    );
    TYPE fire_item_info_tab IS TABLE OF fire_item_info_type;
    
    TYPE aviation_item_info_type IS RECORD (
        item_no             GICL_AVIATION_DTL.item_no%TYPE,
        item_title          GICL_AVIATION_DTL.item_title%TYPE,
        vessel_name         GIIS_VESSEL.vessel_name%TYPE,
        purpose             GICL_AVIATION_DTL.purpose%TYPE,
        est_util_hrs        GICL_AVIATION_DTL.est_util_hrs%TYPE
    );
    TYPE aviation_item_info_tab IS TABLE OF aviation_item_info_type;
    
    TYPE casualty_item_info_type IS RECORD (
        item_no                 GICL_CASUALTY_DTL.item_no%TYPE,
        item_title              GICL_CASUALTY_DTL.item_title%TYPE,
        location                GICL_CASUALTY_DTL.location%TYPE,
        conveyance_info         GICL_CASUALTY_DTL.conveyance_info%TYPE,
        interest_on_premises    GICL_CASUALTY_DTL.interest_on_premises%TYPE,
        limit_of_liability      GICL_CASUALTY_DTL.limit_of_liability%TYPE,
        amount_coverage         GICL_CASUALTY_DTL.amount_coverage%TYPE
    );
    TYPE casualty_item_info_tab IS TABLE OF casualty_item_info_type;
    
    TYPE en_item_info_type IS RECORD (
        item_no                 GICL_ENGINEERING_DTL.item_no%TYPE,
        item_title              GICL_ENGINEERING_DTL.item_title%TYPE,
        item_desc               GICL_ENGINEERING_DTL.item_desc%TYPE,
        item_desc2              GICL_ENGINEERING_DTL.item_desc2%TYPE,
        region_desc             GIIS_REGION.region_desc%TYPE,
        province_desc           GIIS_PROVINCE.province_desc%TYPE
    );
    TYPE en_item_info_tab IS TABLE OF en_item_info_type;
    
    TYPE mc_item_info_type IS RECORD (
        item_no                 GICL_MOTOR_CAR_DTL.item_no%TYPE,
        item_title              GICL_MOTOR_CAR_DTL.item_title%TYPE,
        motor_no                GICL_MOTOR_CAR_DTL.motor_no%TYPE,
        make                    GIIS_MC_MAKE.make%TYPE,
        plate_no                GICL_MOTOR_CAR_DTL.plate_no%TYPE,
        serial_no               GICL_MOTOR_CAR_DTL.serial_no%TYPE
    );
    TYPE mc_item_info_tab IS TABLE OF mc_item_info_type;
    
    TYPE mh_item_info_type IS RECORD (
        item_no                 GICL_HULL_DTL.item_no%TYPE,
        item_title              GICL_HULL_DTL.item_title%TYPE,
        vessel_name             GIIS_VESSEL.vessel_name%TYPE,
        hull_desc               GIIS_HULL_TYPE.hull_desc%TYPE,
        geog_limit              GICL_HULL_DTL.geog_limit%TYPE,
        dry_date                GICL_HULL_DTL.dry_date%TYPE,
        dry_place               GICL_HULL_DTL.dry_place%TYPE
    );
    TYPE mh_item_info_tab IS TABLE OF mh_item_info_type;
    
    TYPE mn_item_info_type IS RECORD (
        item_no                 GICL_CARGO_DTL.item_no%TYPE,
        item_title              GICL_CARGO_DTL.item_title%TYPE,
        etd                     GICL_CARGO_DTL.etd%TYPE,
        eta                     GICL_CARGO_DTL.eta%TYPE,
        vessel_name             GIIS_VESSEL.vessel_name%TYPE,
        cargo_class_desc        GIIS_CARGO_CLASS.cargo_class_desc%TYPE,
        lc_no                   GICL_CARGO_DTL.lc_no%TYPE,
        bl_awb                  GICL_CARGO_DTL.bl_awb%TYPE
    );
    TYPE mn_item_info_tab IS TABLE OF mn_item_info_type;
    
    TYPE pa_item_info_type IS RECORD (
        claim_id                GICL_ACCIDENT_DTL.claim_id%TYPE,
        item_no                 GICL_ACCIDENT_DTL.item_no%TYPE,
        item_title              GICL_ACCIDENT_DTL.item_title%TYPE,
        grouped_item_no         GICL_ACCIDENT_DTL.grouped_item_no%TYPE,
        grouped_item_title      GICL_ACCIDENT_DTL.grouped_item_title%TYPE,
        date_of_birth           GICL_ACCIDENT_DTL.date_of_birth%TYPE,
        position_cd             GICL_ACCIDENT_DTL.position_cd%TYPE,
        position                GIIS_POSITION.position%TYPE,
        beneficiary_name        GICL_BENEFICIARY_DTL.beneficiary_name%TYPE,
        beneficiary_addr        GICL_BENEFICIARY_DTL.beneficiary_addr%TYPE,
        relation                GICL_BENEFICIARY_DTL.relation%TYPE
    );
    TYPE pa_item_info_tab IS TABLE OF pa_item_info_type;
    
    TYPE docs_on_file_type IS RECORD (
        clm_doc_cd              GICL_LOSS_REP_EXT.clm_doc_cd%TYPE,
        line_cd                 GICL_LOSS_REP_EXT.line_cd%TYPE,
        subline_cd              GICL_LOSS_REP_EXT.subline_cd%TYPE,
        clm_doc_desc            GICL_LOSS_REP_EXT.clm_doc_desc%TYPE,
        doc_cmpltd_dt           GICL_REQD_DOCS.doc_cmpltd_dt%TYPE
    );
    TYPE docs_on_file_tab IS TABLE OF docs_on_file_type;
    
    TYPE prem_payment_type IS RECORD (
        premium_amt             GIAC_DIRECT_PREM_COLLNS.premium_amt%TYPE,
        tran_date               GIAC_ACCTRANS.tran_date%TYPE,               
        ref_no                  VARCHAR2(30)
    );
    TYPE prem_payment_tab IS TABLE OF prem_payment_type;
    
    TYPE distribution_dtl_type IS RECORD (
        peril_cd                GIIS_PERIL.peril_cd%TYPE,
        peril_name              GIIS_PERIL.peril_name%TYPE,
        ann_tsi_amt2            GICL_ITEM_PERIL.ann_tsi_amt%TYPE,
        tsi_trty                GIIS_DIST_SHARE.trty_name%TYPE,
        trty_shr_tsi_pct        GICL_POLICY_DIST.shr_tsi_pct%TYPE,
        trty_tsi                GICL_ITEM_PERIL.ann_tsi_amt%TYPE,
        reserve_amt             GICL_ITEM_PERIL.ann_tsi_amt%TYPE,
        reserve_trty            GIIS_DIST_SHARE.trty_name%TYPE,
        trty_shr_pct            GICL_RESERVE_DS.shr_pct%TYPE,
        trty_reserve            GICL_ITEM_PERIL.ann_tsi_amt%TYPE,
        share_cd                GICL_POLICY_DIST.share_cd%TYPE
    );
    TYPE distribution_dtl_tab IS TABLE OF distribution_dtl_type;
    
    TYPE reinsurance_type IS RECORD (
        ri_name                 GIIS_REINSURER.ri_name%TYPE,
        shr_ri_tsi_pct          GICL_POLICY_DIST_RI.shr_ri_tsi_pct%TYPE,
        shr_ri_tsi_amt          GICL_POLICY_DIST_RI.shr_ri_tsi_amt%TYPE,
        item_no                 GICL_POLICY_DIST_RI.item_no%TYPE,
        grouped_item_no         GICL_POLICY_DIST_RI.grouped_item_no%TYPE,
        ri_cd                   GICL_POLICY_DIST_RI.ri_cd%TYPE,
        ri_res_amt              GICL_RESERVE_RIDS_V1.ri_res_amt%TYPE,
        reserve_item_no         GICL_RESERVE_RIDS_V1.ri_res_amt%TYPE,
        grp_seq_no              GICL_RESERVE_RIDS_V1.ri_res_amt%TYPE
    );
    TYPE reinsurance_tab IS TABLE OF reinsurance_type;
    
    TYPE final_loss_info_type IS RECORD (
        line_cd             GICL_CLAIMS.line_cd%TYPE,
        subline_cd          GICL_CLAIMS.subline_cd%TYPE,
        iss_cd              GICL_CLAIMS.iss_cd%TYPE,
        issue_yy            GICL_CLAIMS.issue_yy%TYPE,
        pol_seq_no          GICL_CLAIMS.pol_seq_no%TYPE,
        renew_no            GICL_CLAIMS.renew_no%TYPE,
        clm_yy              GICL_CLAIMS.clm_yy%TYPE,
        clm_seq_no          GICL_CLAIMS.clm_seq_no%TYPE,
        claim_no            VARCHAR2(50),
        policy_no           VARCHAR2(50),
        issue_date          VARCHAR2(50),
        incept_date         VARCHAR2(50),
        expiry_date         VARCHAR2(50),
        assd_name           GIIS_ASSURED.assd_name%TYPE,
        bill_address        VARCHAR2(250),
        loss_cat_des        GIIS_LOSS_CTGRY.loss_cat_des%TYPE,
        mortg_name          GICL_MORTGAGEE_V1.mortg_name%TYPE,
        intm_name           GICL_BASIC_INTM_V1.intm_name%TYPE,
        intm_no             GICL_BASIC_INTM_V1.intrmdry_intm_no%TYPE,
        loss_loc1           GICL_CLAIMS.loss_loc1%TYPE,
        loss_date           VARCHAR2(50),
        clm_file_date       VARCHAR2(50),
        advice_id           GICL_ADVICE.advice_id%TYPE,
        advice_no           VARCHAR2(50)
    );
    TYPE final_loss_info_tab IS TABLE OF final_loss_info_type;
    
    TYPE advice_no_type IS RECORD (
        advice_id           GICL_ADVICE.advice_id%TYPE,
        advice_no           VARCHAR2(50)
    );
    TYPE advice_no_tab IS TABLE OF advice_no_type;
    
    TYPE payee_type IS RECORD (
        payee_name          VARCHAR2(600), -- marco - 04.15.2013 - modified length
        claim_id            GICL_CLM_LOSS_EXP.claim_id%TYPE,
        item_no             GICL_CLM_LOSS_EXP.item_no%TYPE,
        advice_id           GICL_ADVICE.advice_id%TYPE,
        payee_class_cd      GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
        payee_cd            GICL_CLM_LOSS_EXP.payee_cd%TYPE,
        paid_amt            GICL_CLM_LOSS_EXP.paid_amt%TYPE,
        net_amt             GICL_CLM_LOSS_EXP.net_amt%TYPE,
        wh_tax              GICL_LOSS_EXP_TAX.tax_amt%TYPE,
        evat                GICL_LOSS_EXP_TAX.tax_amt%TYPE
    );
    TYPE payee_tab IS TABLE OF payee_type;
    
    TYPE final_peril_type IS RECORD (
        peril_name          GIIS_PERIL.peril_name%TYPE,
        ann_tsi_amt2        GICL_ITEM_PERIL.ann_tsi_amt%TYPE,
        trty_shr_tsi_pct    GICL_POLICY_DIST.shr_tsi_pct%TYPE,
        trty_tsi            NUMBER(16, 2),
        reserve_amt         GICL_CLM_LOSS_EXP.net_amt%TYPE,
        trty_shr_pct        GICL_POLICY_DIST.shr_tsi_pct%TYPE,
        trty_reserve        GICL_CLM_LOSS_EXP.net_amt%TYPE,
        share_cd            GICL_POLICY_DIST.share_cd%TYPE,
        tsi_trty            GIIS_DIST_SHARE.trty_name%TYPE,
        reserve_trty        GIIS_DIST_SHARE.trty_name%TYPE,
        peril_cd            GICL_ITEM_PERIL.peril_cd%TYPE
    );
    TYPE final_peril_tab IS TABLE OF final_peril_type;
    
    TYPE reserve_ri_type IS RECORD (
        ri_name             GIIS_REINSURER.ri_name%TYPE,
        shr_ri_pct          GICL_RESERVE_RIDS_V1.shr_ri_pct%TYPE,
        ri_res_amt          GICL_RESERVE_RIDS_V1.ri_res_amt%TYPE,
        ri_res_amt2         GICL_RESERVE_RIDS_V1.ri_res_amt%TYPE
    );
    TYPE reserve_ri_tab IS TABLE OF reserve_ri_type;
    
    TYPE agent_list_type IS RECORD(
        agent               GIIS_INTERMEDIARY.intm_name%TYPE
    );
    TYPE agent_list_tab IS TABLE OF agent_list_type;
    
    TYPE mortgagee_list_type IS RECORD(
        mortgagee           GIIS_MORTGAGEE.mortg_name%TYPE
    );
    TYPE mortgagee_list_tab IS TABLE OF mortgagee_list_type;
    
    FUNCTION get_prelim_loss_info(
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
        RETURN prelim_loss_info_tab PIPELINED;

    FUNCTION get_fire_item_information(
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
        RETURN fire_item_info_tab PIPELINED;
        
    FUNCTION get_aviation_item_information(
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
        RETURN aviation_item_info_tab PIPELINED;
        
    FUNCTION get_casualty_item_information(
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN casualty_item_info_tab PIPELINED;
      
    FUNCTION get_en_item_information (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN en_item_info_tab PIPELINED;
      
    FUNCTION get_mc_item_information (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN mc_item_info_tab PIPELINED;
      
    FUNCTION get_mh_item_information (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN mh_item_info_tab PIPELINED;
      
    FUNCTION get_mn_item_information (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN mn_item_info_tab PIPELINED;
      
    FUNCTION get_pa_item_information (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN pa_item_info_tab PIPELINED;
      
    FUNCTION get_docs_on_file (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN docs_on_file_tab PIPELINED;

    FUNCTION get_prem_payment (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN prem_payment_tab PIPELINED;
        
    FUNCTION get_treaties (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE,
        p_line_cd           GICL_CLAIMS.line_cd%TYPE
    )
      RETURN distribution_dtl_tab PIPELINED;
      
    FUNCTION default_currency (
        p_ann_tsi_amt       GICL_ITEM_PERIL.ann_tsi_amt%TYPE,
        p_item_no           GICL_ITEM_PERIL.item_no%TYPE,
        p_grouped_item_no   GICL_ITEM_PERIL.grouped_item_no%TYPE,
        p_claim_id          GICL_ITEM_PERIL.claim_id%TYPE
    )
      RETURN NUMBER;

    FUNCTION get_reinsurance (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE,
        p_share_cd          GICL_POLICY_DIST_RI.share_cd%TYPE,
        p_peril_cd          GICL_ITEM_PERIL.peril_cd%TYPE
    )
      RETURN reinsurance_tab PIPELINED;
      
    FUNCTION get_final_loss_info (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN final_loss_info_tab PIPELINED;
      
    FUNCTION get_advice_no_lov (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN advice_no_tab PIPELINED;
      
    FUNCTION get_payee (
        p_claim_id          GICL_ADVICE.claim_id%TYPE,
        p_advice_id         GICL_ADVICE.advice_id%TYPE
    )
      RETURN payee_tab PIPELINED;
      
    FUNCTION get_final_peril_info (
        p_claim_id          GICL_ADVICE.claim_id%TYPE,
        p_line_cd           GICL_ADVICE.line_cd%TYPE,
        p_advice_id         GICL_ADVICE.advice_id%TYPE
    )
      RETURN final_peril_tab PIPELINED;
      
    FUNCTION get_reserve_reinsurance (
        p_claim_id          GICL_RESERVE_RIDS_V1.claim_id%TYPE,
        p_share_cd          GIIS_DIST_SHARE.share_cd%TYPE,
        p_peril_cd          GICL_ITEM_PERIL.peril_cd%TYPE
    )
      RETURN reserve_ri_tab PIPELINED;
      
    FUNCTION get_final_res_ri (
        p_claim_id          GICL_NET_RIDS_V1.claim_id%TYPE,
        p_advice_id         GICL_ADVICE.advice_id%TYPE,
        p_share_cd          GIIS_DIST_SHARE.share_cd%TYPE,
        p_peril_cd          GICL_ITEM_PERIL.peril_cd%TYPE
    )
      RETURN reserve_ri_tab PIPELINED;
      
    FUNCTION get_agent_list(
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN agent_list_tab PIPELINED;
      
    FUNCTION get_mortgagee_list(
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN mortgagee_list_tab PIPELINED;
      
END GICL_PRELIM_LOSS_REPORT_PKG;
/


