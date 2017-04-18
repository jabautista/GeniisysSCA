CREATE OR REPLACE PACKAGE CPI.giclr029_pkg
AS
    TYPE giclr029_claim_type IS RECORD (
        in_hou_adj              VARCHAR2(50),--GICL_CLAIMS.in_hou_adj%TYPE,
        line_name               giis_line.line_name%type,
        policy_no               VARCHAR2(30),
        assured                 GICL_CLAIMS.assured_name%TYPE,
        address                 giis_parameters.param_value_v%type,
        issue_date              gipi_polbasic.issue_date%type,
        eff_date                GICL_CLAIMS.pol_eff_date%TYPE,
        expiry_date             GICL_CLAIMS.expiry_date%TYPE,
        oldest_os_prem1         VARCHAR2(10),
        claim_no                VARCHAR2(26),
        uw_year                 GICL_CLAIMS.issue_yy%TYPE,
        loss_dtls               GICL_CLAIMS.loss_dtls%TYPE,
        clm_file_date           GICL_CLAIMS.clm_file_date%TYPE,         
        contact_no              giis_assured.phone_no%type,
        loss_date               GICL_CLAIMS.dsp_loss_date%TYPE,
        loss_location           VARCHAR2(152),
        adjuster                VARCHAR2(553),
        motorshop               varchar2(500),
        recovery_sw             GICL_CLAIMS.recovery_sw%TYPE,
        clm_stat_desc           giis_clm_stat.clm_stat_desc%type,
        assured_name            GICL_CLAIMS.assured_name%TYPE,               
        f_endorsement_no        gipi_polbasic.endt_seq_no%TYPE,
        remarks                 GICL_CLAIMS.remarks%TYPE,
        f_mc_subreport          VARCHAR2(5),
        f_dist_subreport        VARCHAR2(5),
        f_voy_subreport         VARCHAR2(5),
        f_ca_subreport          VARCHAR2(5),
        f_ac_subreport          VARCHAR2(5),
        f_drvr_subreport        VARCHAR2(5),
        f_mtrshp_subreport      VARCHAR2(5),
        f_adjster_subreport     VARCHAR2(5),
		lease_to				giis_assured.assd_name%TYPE,
		label_tag 				gipi_polbasic.label_tag%TYPE,
		menu_line_cd  			giis_line.menu_line_cd%TYPE,
		gitem_no      			NUMBER(9),
   		gitem_title   			VARCHAR2(50),
   		gitem         			VARCHAR2(500),
		acct_of_cd				gicl_claims.acct_of_cd%type,
        ri_name                 giis_reinsurer.ri_name%type
    );
    
    TYPE giclr029_claim_tab IS TABLE OF giclr029_claim_type;
    
    TYPE giclr029_endt_type IS RECORD (
        endt_no                 VARCHAR2(14),
        issue_date              gipi_polbasic.issue_date%type,
        eff_date                GICL_CLAIMS.pol_eff_date%TYPE
    );
    
    TYPE giclr029_endt_tab IS TABLE OF giclr029_endt_type;
    
    TYPE giclr029_mc_type IS RECORD (
        item_title              gicl_motor_car_dtl.item_title%TYPE,
        model_year              gicl_motor_car_dtl.model_year%TYPE,
        make                    giis_mc_make.make%TYPE,
        subline_type            giis_mc_subline_type.subline_type_desc%TYPE,
        serial_no               gicl_motor_car_dtl.serial_no%TYPE,
        motor_no                gicl_motor_car_dtl.motor_no%TYPE,
        plate_no                gicl_motor_car_dtl.plate_no%TYPE,
        color                   gicl_motor_car_dtl.color%TYPE,
        driver                  gicl_motor_car_dtl.drvr_name%TYPE,
        drvr_age                gicl_motor_car_dtl.drvr_age%TYPE
    );
    
    TYPE giclr029_mc_tab IS TABLE OF giclr029_mc_type;
    
    TYPE giclr029_fire_type IS RECORD (
        district_no             gicl_fire_dtl.district_no%TYPE,
        district_desc           giis_block.district_desc%type,
        block_no                gicl_fire_dtl.block_no%TYPE,
        block_desc              giis_block.block_desc%type,
        fire_item               gicl_fire_dtl.item_title%TYPE,
        curr12                  giis_currency.short_name%TYPE,
        amt_insured             gicl_item_peril.ann_tsi_amt%TYPE
    );
    
    TYPE giclr029_fire_tab IS TABLE OF giclr029_fire_type;
    
    TYPE giclr029_cargo_type IS RECORD (
        voyage_from             gicl_cargo_dtl.origin%TYPE,
        voyage_to               gicl_cargo_dtl.destn%TYPE,
        vessel                  giis_vessel.vessel_name%type,
        cargo_type              giis_cargo_type.cargo_type_desc%type
    );
    
    TYPE giclr029_cargo_tab IS TABLE OF giclr029_cargo_type;
    
    TYPE giclr029_cslty_type IS RECORD (
        casualty_item           gicl_casualty_dtl.item_title%TYPE,
        curr11                  giis_currency.short_name%TYPE,
        amt_insured2            VARCHAR2(19)
    );
    
    TYPE giclr029_cslty_tab IS TABLE OF giclr029_cslty_type;
    
    TYPE giclr029_acdnt_type IS RECORD (
        beneficiary             gicl_beneficiary_dtl.beneficiary_name%TYPE,
        relation                gicl_beneficiary_dtl.relation%TYPE,
        date_of_birth           gicl_beneficiary_dtl.date_of_birth%TYPE,
        age                     gicl_beneficiary_dtl.age%TYPE
    );
    
    TYPE giclr029_acdnt_tab IS TABLE OF giclr029_acdnt_type;
    
    TYPE giclr029_q1_type IS RECORD (
        adjuster                VARCHAR2(553)
    );
    
    TYPE giclr029_q1_tab IS TABLE OF giclr029_q1_type;
    
    TYPE giclr029_loss_type IS RECORD (
        remarks1                gicl_clm_res_hist.remarks%TYPE,
        item_no                 gicl_clm_res_hist.item_no%TYPE,
        peril_cd                gicl_clm_res_hist.peril_cd%TYPE,
        line_cd                 gicl_claims.line_cd%TYPE
    );
    
    TYPE giclr029_loss_tab IS TABLE OF giclr029_loss_type;
    
    TYPE giclr029_loss2_type IS RECORD (
        curr14                  giis_currency.short_name%TYPE,
        loss_reserve            gicl_clm_res_hist.loss_reserve%TYPE,
        expense_reserve         gicl_clm_res_hist.expense_reserve%TYPE,
        user_id                 gicl_clm_res_hist.user_id%TYPE,
        setup_date              VARCHAR2(20),
        setup_by                gicl_clm_res_hist.setup_by%TYPE
    );
    
    TYPE giclr029_loss2_tab IS TABLE OF giclr029_loss2_type;
    
    TYPE giclr029_item_type IS RECORD (
        item                VARCHAR2(4000),
        item_no             gicl_clm_item.item_no%TYPE --added Item Number by MAC 11/12/2013.
    );
    
    TYPE giclr029_item_tab IS TABLE OF giclr029_item_type;
    
    TYPE giclr029_peril_type IS RECORD (
        peril                   giis_peril.peril_name%TYPE,
        curr15                  giis_currency.short_name%TYPE,
        tsi                     gipi_itmperil.tsi_amt%TYPE                  
    );
    
    TYPE giclr029_peril_tab IS TABLE OF giclr029_peril_type;
    
    TYPE giclr029_q4_type IS RECORD (
        item                    VARCHAR2(4000),
        peril                   giis_peril.peril_name%TYPE,
        loss_cat_des            giis_loss_ctgry.loss_cat_des%TYPE,
        loss_reserve            gicl_clm_reserve.loss_reserve%TYPE,
        curr6                   giis_currency.short_name%TYPE,
        expense_reserve         gicl_clm_reserve.expense_reserve%TYPE, 
        curr5                   giis_currency.short_name%TYPE,   
		menu_line_cd  			giis_line.menu_line_cd%TYPE,
		gitem_no      			NUMBER(9),
   		gitem_title   			VARCHAR2(50),
   		gitem         			VARCHAR2(500)
    );
    
    TYPE giclr029_q4_tab IS TABLE OF giclr029_q4_type;
    
    TYPE giclr029_m29_type IS RECORD (
        deductible              gipi_deductibles.deductible_amt%type,
        curr21                  VARCHAR2(3),
        mortgagee               giis_mortgagee.mortg_name%type,
        intm                    giis_intermediary.intm_name%type,
        no_of_claims            gicl_claims.claim_id%type,
        curr18                  giis_currency.short_name%TYPE,
        tot_pd_amt              GICL_CLAIMS.loss_pd_amt%TYPE,
        tot_res_amt             GICL_CLAIMS.loss_res_amt%TYPE,
        tot_os                  NUMBER(16,2),
        endt_exist              VARCHAR2(5)
    );
    
    TYPE giclr029_m29_tab IS TABLE OF giclr029_m29_type;
    
    TYPE giclr029_prem_type IS RECORD (
        ref_no                  VARCHAR2(30),
        tran_date               DATE,
        curr3                   giis_currency.short_name%TYPE,
        premium_amt             giac_direct_prem_collns.premium_amt%TYPE,
        curr4                   VARCHAR2(3)
    );
    
    TYPE giclr029_prem_tab IS TABLE OF giclr029_prem_type;
    
    TYPE giclr029_shr_type IS RECORD (
        share_type              giis_dist_share.share_type%TYPE,
        share_name              VARCHAR2(11)
    );
    
    TYPE giclr029_shr_tab IS TABLE OF giclr029_shr_type;
    
    TYPE giclr029_poldist_type IS RECORD (
        curr22                  giis_currency.short_name%TYPE,
        shr_tsi_amt             gicl_policy_dist.shr_tsi_amt%TYPE
    );
    
    TYPE giclr029_poldist_tab IS TABLE OF giclr029_poldist_type;
    
    TYPE giclr029_rdist_type IS RECORD (
        curr10                  giis_currency.short_name%TYPE,
        shr_res_amt             NUMBER(16,2)
    );
    
    TYPE giclr029_rdist_tab IS TABLE OF giclr029_rdist_type;
    
    TYPE giclr029_binder_type IS RECORD (
        reinsurer               giis_reinsurer.ri_name%type,
        binder_no               VARCHAR2(14),
        ri_shr_pct              giri_binder.ri_shr_pct%TYPE,
        curr1                   giis_currency.short_name%TYPE,
        ri_tsi_amt              giri_binder.ri_tsi_amt%TYPE
    );
    
    TYPE giclr029_binder_tab IS TABLE OF giclr029_binder_type;
    
    TYPE giclr029_rdistri_type IS RECORD (
        ri_name                 giis_reinsurer.ri_name%type,
        pla_no                  VARCHAR2(15),
        shr_ri_pct              NUMBER(16,2),
        curr2                   giis_currency.short_name%TYPE,
        pla_amt                 NUMBER(16,2)
    );
    
    TYPE giclr029_rdistri_tab IS TABLE OF giclr029_rdistri_type;
    
    TYPE giclr029_reqd_type IS RECORD (
        req_doc                 gicl_clm_docs.clm_doc_desc%TYPE,
        dt_cmpltd               gicl_reqd_docs.doc_cmpltd_dt%type,
        line_cd                 gicl_claims.line_cd%TYPE
    );
    
    TYPE giclr029_reqd_tab IS TABLE OF giclr029_reqd_type;
    
    TYPE giclr029_sig_type IS RECORD (
        label                   giac_rep_signatory.label%TYPE,
        signatory               giis_signatory_names.signatory%TYPE,
        designation             giis_signatory_names.designation%TYPE
    );
    
    TYPE giclr029_sig_tab IS TABLE OF giclr029_sig_type;
    
    FUNCTION get_claim_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_claim_tab PIPELINED;
    
    FUNCTION get_endt_no(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_endt_tab PIPELINED;
    
    FUNCTION get_mc_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_mc_tab PIPELINED;
    
    FUNCTION get_fire_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_fire_tab PIPELINED;
    
    FUNCTION get_cargo_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_cargo_tab PIPELINED;
    
    FUNCTION get_cslty_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_cslty_tab PIPELINED; 
    
    FUNCTION get_acdnt_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_acdnt_tab PIPELINED;
    
    FUNCTION get_q1_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_q1_tab PIPELINED; 
    
    FUNCTION get_loss_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_loss_tab PIPELINED;
    
    FUNCTION get_peril_name(
        p_line_cd       giis_peril.line_cd%TYPE,
        p_peril_cd      giis_peril.peril_cd%TYPE
    )
    RETURN giclr029_peril_tab PIPELINED;
    
    FUNCTION get_loss_dtls2(
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_peril_cd      giis_peril.peril_cd%TYPE,
        p_item_no       gicl_clm_res_hist.item_no%TYPE -- bonok :: 10.08.2014
    )
    RETURN giclr029_loss2_tab PIPELINED;
    
    FUNCTION get_q2_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_item_tab PIPELINED;
    
    FUNCTION get_peril_dtls(p_claim_id      gicl_claims.claim_id%TYPE,
                            p_item_no       gicl_clm_item.item_no%TYPE)--added Item Number to retrieve Peril details per Item by MAC 11/12/2013.
    RETURN giclr029_peril_tab PIPELINED;
    
    FUNCTION get_q4_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_q4_tab PIPELINED;
    
    FUNCTION get_m29_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_m29_tab PIPELINED;
    
    FUNCTION get_prem_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_prem_tab PIPELINED;
    
    FUNCTION get_share_type
    RETURN giclr029_shr_tab PIPELINED;
    
    FUNCTION get_poldist_dtls(
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_share_type    giis_dist_share.share_type%TYPE
    )
    RETURN giclr029_poldist_tab PIPELINED;
    
    FUNCTION get_rdist_dtls(
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_share_type    giis_dist_share.share_type%TYPE
    )
    RETURN giclr029_rdist_tab PIPELINED;
    
    FUNCTION get_binder_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_binder_tab PIPELINED;
    
    FUNCTION get_rdistri_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_rdistri_tab PIPELINED;
    
    FUNCTION get_reqd_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_reqd_tab PIPELINED;
    
    FUNCTION get_sig_dtls(
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_line_cd           giac_documents.line_cd%TYPE,
        p_report_id         giac_documents.report_id%TYPE
    )
    RETURN giclr029_sig_tab PIPELINED;
	
END; 
/

