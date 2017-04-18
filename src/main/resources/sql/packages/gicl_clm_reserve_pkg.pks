CREATE OR REPLACE PACKAGE CPI.gicl_clm_reserve_pkg
AS      

    FUNCTION get_gicl_clm_reserve_exist( 
        p_claim_id          gicl_clm_reserve.claim_id%TYPE
    )RETURN VARCHAR2;
    
    PROCEDURE update_clm_dist_tag_gicls024(
        p_claim_id        IN gicl_clm_reserve.claim_id%TYPE
    );
    
    PROCEDURE update_negate_date(
        p_claim_id        IN gicl_clm_reserve.claim_id%TYPE,
        p_item_no         IN gicl_clm_reserve.item_no%TYPE,
        p_peril_cd        IN gicl_clm_reserve.peril_cd%TYPE,
        p_grouped_item_no IN gicl_clm_reserve.grouped_item_no%TYPE,
        p_hist_seq_no     IN gicl_clm_res_hist.hist_seq_no%TYPE
    );
    
    PROCEDURE update_preb_booking_date(
        p_claim_id          IN gicl_clm_res_hist.claim_id%TYPE,
        p_item_no           IN gicl_clm_res_hist.item_no%TYPE,
        p_peril_cd          IN gicl_clm_res_hist.peril_cd%TYPE,
        p_grouped_item_no   IN gicl_clm_res_hist.grouped_item_no%TYPE,
        p_hist_seq_no       IN gicl_clm_res_hist.hist_seq_no%TYPE,
        p_clm_res_hist_id   IN gicl_clm_res_hist.clm_res_hist_id%TYPE,
        p_old_month         IN OUT VARCHAR2,
        p_old_year          IN OUT NUMBER
    );
    
    PROCEDURE update_workflow_switch(
        p_event_desc IN VARCHAR2,
        p_module_id  IN VARCHAR2,
        p_user       IN VARCHAR2
        
    );
    
    PROCEDURE extract_expiry(
        p_line_cd IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no IN gipi_polbasic.renew_no%TYPE,
        p_loss_date IN gipi_polbasic.eff_date%TYPE,
        p_nbt_expiry_date OUT gipi_polbasic.expiry_date%TYPE
    );
    
    PROCEDURE validate_existing_dist(
       p_line_cd IN gipi_polbasic.line_cd%TYPE,
       p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
       p_iss_cd IN gipi_polbasic.iss_cd%TYPE,
       p_issue_yy IN gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no IN gipi_polbasic.renew_no%TYPE,
       p_proceed OUT VARCHAR2,
       p_message OUT VARCHAR2, 
       p_call_module OUT VARCHAR2
    );
    
    PROCEDURE init_claim_reserve1(
        p_claim_id IN gicl_claims.claim_id%TYPE,
        p_item_no   IN gicl_clm_reserve.item_no%TYPE,
        p_peril_cd  IN gicl_clm_reserve.peril_cd%TYPE,
        p_grouped_item_no IN gicl_clm_reserve.grouped_item_no%TYPE,
        p_line_cd_ac OUT giis_parameters.param_value_v%TYPE, 
        p_line_cd_ca OUT giis_parameters.param_value_v%TYPE,
        p_claim_number OUT VARCHAR2,
        p_policy_number OUT VARCHAR2,
        p_line_cd OUT gicl_claims.line_cd%TYPE,
        p_dsp_loss_date OUT gicl_claims.dsp_loss_date%TYPE,
        p_loss_date OUT gicl_claims.loss_date%TYPE,
        p_assured_name OUT gicl_claims.assured_name%TYPE,
        p_loss_category OUT VARCHAR2,
        p_subline_cd OUT gicl_claims.subline_cd%TYPE,
        p_pol_iss_cd OUT gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy OUT gicl_claims.issue_yy%TYPE,
        p_pol_seq_no OUT gicl_claims.pol_seq_no%TYPE,
        p_renew_no OUT gicl_claims.renew_no%TYPE,
        p_iss_cd OUT gicl_claims.iss_cd%TYPE,
        p_pol_eff_date OUT gicl_claims.pol_eff_date%TYPE,
        p_expiry_date OUT gicl_claims.expiry_date%TYPE,
        p_clm_file_date OUT gicl_claims.clm_file_date%TYPE,
        p_clm_stat_desc OUT giis_clm_stat.clm_stat_desc%TYPE,
        p_catastrophic_cd OUT gicl_claims.catastrophic_cd%TYPE,
        p_claim_yy OUT gicl_claims.clm_yy%TYPE,
        p_exist OUT VARCHAR2,
        p_show_reserve_history_btn OUT VARCHAR2,
        p_show_payment_history_btn OUT VARCHAR2
     );
    
     TYPE clm_res_type IS RECORD(
        claim_id        gicl_clm_reserve.claim_id%TYPE,
        item_no         gicl_clm_reserve.item_no%TYPE,
        peril_cd        gicl_clm_reserve.peril_cd%TYPE,
        loss_reserve    gicl_clm_reserve.loss_reserve%TYPE,
        losses_paid     gicl_clm_reserve.losses_paid%TYPE,
        expense_reserve gicl_clm_reserve.expense_reserve%TYPE,
        expenses_paid   gicl_clm_reserve.expenses_paid%TYPE,
        currency_cd     gicl_clm_reserve.currency_cd%TYPE,
        convert_rate    gicl_clm_reserve.convert_rate%TYPE,
        net_pd_loss     gicl_clm_reserve.net_pd_loss%TYPE,
        net_pd_exp      gicl_clm_reserve.net_pd_exp%TYPE,
        grouped_item_no gicl_clm_reserve.grouped_item_no%TYPE,
        redist_sw       gicl_clm_reserve.redist_sw%TYPE
    );
    
    FUNCTION get_gicl_clm_res(
        p_claim_id          gicl_clm_reserve.claim_id%TYPE
    )RETURN clm_res_type;
    
    TYPE recoverable_details_type IS RECORD(
        claim_id                gicl_clm_reserve.claim_id%TYPE,
        item_no                 gicl_clm_reserve.item_no%TYPE,
        peril_cd                gicl_clm_reserve.peril_cd%TYPE,
        loss_reserve            gicl_clm_reserve.loss_reserve%TYPE,    
        expense_reserve         gicl_clm_reserve.expense_reserve%TYPE,
        dsp_item_desc           gicl_clm_item.item_title%TYPE,
        dsp_peril_desc          giis_peril.peril_sname%TYPE,
        nbt_paid_amt            NUMBER,
        clm_loss_id             gicl_clm_loss_exp.clm_loss_id%TYPE,
        hist_seq_no             gicl_clm_loss_exp.hist_seq_no%TYPE,
        chk_choose              VARCHAR2(1),
        nbt_ann_tsi_amt         gicl_item_peril.ann_tsi_amt%TYPE,
        orig_nbt_paid_amt       NUMBER -- added by apollo cruz 07.10.2015 UCPB SR 19584 
        );
        
    TYPE recoverable_details_tab IS TABLE OF recoverable_details_type;    
    
    FUNCTION get_recoverable_details(
        p_claim_id          gicl_clm_reserve.claim_id%TYPE,
        p_line_cd           gicl_claims.line_cd%TYPE,
        p_recovery_id       gicl_clm_recovery_dtl.recovery_id%TYPE
        )
    RETURN recoverable_details_tab PIPELINED;
    
    TYPE availments_type IS RECORD(
        claim_id            gicl_claims.claim_id%TYPE,
        loss_date           gicl_claims.loss_date%TYPE,
        clm_stat_cd         gicl_claims.clm_stat_cd%TYPE,
        clm_stat_desc       giis_clm_stat.clm_stat_desc%TYPE,
        loss_reserve        gicl_clm_reserve.loss_reserve%TYPE,
        paid_amt            gicl_clm_loss_exp.paid_amt%TYPE,
        no_of_units         gicl_loss_exp_dtl.no_of_units%TYPE,
        peril_cd            gicl_clm_reserve.peril_cd%TYPE,
        claim_no            VARCHAR2(50)
    );
    TYPE availments_tab IS TABLE OF availments_type;
    
    FUNCTION get_availments(
        p_line_cd           gicl_claims.line_cd%TYPE,
        p_subline_cd        gicl_claims.subline_cd%TYPE,
        p_iss_cd            gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy          gicl_claims.issue_yy%TYPE,
        p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
        p_renew_no          gicl_claims.renew_no%TYPE,
        p_peril_cd          gicl_clm_reserve.peril_cd%TYPE,
        p_no_of_days        gicl_item_peril.no_of_days%TYPE
    ) RETURN availments_tab PIPELINED;
    
    PROCEDURE check_uw_dist_gicls024 (
        p_line_cd       IN  GICL_CLAIMS.line_cd%TYPE,
        p_subline_cd    IN  GICL_CLAIMS.subline_cd%TYPE,
        p_pol_iss_cd    IN  GICL_CLAIMS.pol_iss_cd%TYPE,
        p_issue_yy      IN  GICL_CLAIMS.issue_yy%TYPE,
        p_pol_seq_no    IN  GICL_CLAIMS.pol_seq_no%TYPE,
        p_renew_no      IN  GICL_CLAIMS.renew_no%TYPE,
        p_eff_date      IN  GICL_CLAIMS.pol_eff_date%TYPE,
        p_expiry_date   IN  GICL_CLAIMS.expiry_date%TYPE,
        p_loss_date     IN  GICL_CLAIMS.loss_date%TYPE,
        p_c007_peril_cd IN  GICL_ITEM_PERIL.peril_cd%TYPE,
        p_c007_item_no  IN  GICL_ITEM_PERIL.item_no%TYPE,
        p_message       OUT VARCHAR2
    ); 
    
    PROCEDURE redistribute_reserve(
        p_claim_id              IN GICL_CLAIMS.claim_id%TYPE,
        p_item_no               IN GICL_ITEM_PERIL.item_no%TYPE,
        p_peril_cd              IN GICL_ITEM_PERIL.peril_cd%TYPE,
        p_grouped_item_no       IN GICL_ITEM_PERIL.grouped_item_no%TYPE,
        p_distribution_date     IN GICL_CLM_RES_HIST.distribution_date%TYPE,  
        p_loss_reserve          IN GICL_CLM_RESERVE.LOSS_RESERVE%TYPE,
        p_expense_reserve       IN GICL_CLM_RESERVE.expense_RESERVE%TYPE,
        p_line_cd               IN GICL_CLAIMS.line_cd%TYPE,
        p_hist_seq_no           IN gicl_clm_res_hist.hist_seq_no%TYPE,
        p_clm_res_hist_id       IN gicl_clm_res_hist.clm_res_hist_id%TYPE, 
        p_message               OUT VARCHAR2
    );
    
    PROCEDURE checkOverrideGICLS024(
        p_user              IN VARCHAR2,
        p_loss_reserve      IN NUMBER,
        p_line_cd           IN VARCHAR2,
        p_iss_cd            IN VARCHAR2,
        p_message           OUT VARCHAR2
    );
    
	FUNCTION trty_peril_exists_loc (
      v_line_cd     giis_trty_peril.line_cd%TYPE,
      v_peril_cd    giis_trty_peril.peril_cd%TYPE,
      v_loss_date   DATE,
      v_location_cd   gipi_casualty_item.location_cd%TYPE
   )RETURN BOOLEAN;
	
	FUNCTION trty_peril_exists_risk (
      v_line_cd     giis_trty_peril.line_cd%TYPE,
      v_peril_cd    giis_trty_peril.peril_cd%TYPE,
      v_loss_date   DATE,
      v_risk_cd   gipi_fireitem.risk_cd%TYPE
   )RETURN BOOLEAN;
	
	FUNCTION loc_dist_exists(
      v_location_cd   gipi_casualty_item.location_cd%TYPE,
      v_loss_date     DATE
   )RETURN BOOLEAN;
	
	PROCEDURE process_distribution (
		p_clm_res_hist  		IN gicl_clm_res_hist.clm_res_hist_id%TYPE,
        p_hist_seq_no   		IN gicl_clm_res_hist.hist_seq_no%TYPE,
		p_claim_id              IN gicl_claims.claim_id%TYPE,
        p_item_no               IN gicl_item_peril.item_no%TYPE,
        p_peril_cd              IN gicl_item_peril.peril_cd%TYPE,
        p_grouped_item_no       IN gicl_item_peril.grouped_item_no%TYPE
	);
	    
	PROCEDURE create_new_reserve(
        p_claim_id              IN gicl_claims.claim_id%TYPE,
        p_item_no               IN gicl_item_peril.item_no%TYPE,
        p_peril_cd              IN gicl_item_peril.peril_cd%TYPE,
        p_grouped_item_no       IN gicl_item_peril.grouped_item_no%TYPE,
        p_hist_seq_no           OUT gicl_clm_res_hist.hist_seq_no%TYPE,
        p_user_id               IN gicl_claims.user_id%TYPE,
        p_loss_reserve          IN gicl_clm_reserve.loss_reserve%TYPE,
        p_exp_reserve           IN gicl_clm_reserve.expense_reserve%TYPE,
        p_booking_month         IN gicl_clm_res_hist.booking_month%TYPE,
        p_booking_year          IN gicl_clm_res_hist.booking_month%TYPE,
        p_currency_cd           IN gicl_clm_res_hist.currency_cd%TYPE,
		p_convert_rate			IN gicl_clm_res_hist.convert_rate%TYPE,
		p_dist_date				IN gicl_clm_res_hist.distribution_date%TYPE
    );
	
	FUNCTION RISK_DIST_EXISTS  (
	  p_claim_id              IN gicl_claims.claim_id%TYPE,
      v_risk_cd   gipi_fireitem.risk_cd%TYPE,
      v_loss_date     DATE
   ) RETURN BOOLEAN;
	
	PROCEDURE DISTRIBUTE_RESERVE (
		p_claim_id			IN gicl_claims.claim_id%TYPE,
        p_item_no			IN gicl_item_peril.item_no%TYPE,
        p_peril_cd          IN gicl_item_peril.peril_cd%TYPE,
        p_grouped_item_no	IN gicl_item_peril.grouped_item_no%TYPE,
        p_hist_seq_no		OUT gicl_clm_res_hist.hist_seq_no%TYPE,
		p_clm_dist_no		IN OUT gicl_clm_res_hist.dist_no%TYPE,
		p_distribution_date IN OUT DATE,
		p_user_id			IN gicl_claims.user_id%TYPE,
		v1_claim_id	 		IN gicl_clm_res_hist.claim_id%TYPE,
        v1_clm_res_hist_id 	IN gicl_clm_res_hist.clm_res_hist_id%TYPE,
		nbt_eff_date		IN DATE,
		nbt_expiry_date		IN DATE,
		nbt_cat_cd			IN NUMBER,
		loss_date			IN DATE,
		dsp_line_cd			IN GICL_CLAIMS.line_cd%TYPE,
		dsp_subline_cd		IN GICL_CLAIMS.subline_cd%TYPE,
		dsp_pol_iss_cd		IN GICL_CLAIMS.pol_iss_cd%TYPE,
		dsp_issue_yy		IN GICL_CLAIMS.issue_yy%TYPE,
		dsp_pol_seq_no		IN GICL_CLAIMS.pol_seq_no%TYPE,
		dsp_renew_no		IN GICL_CLAIMS.renew_no%TYPE
	);
	
	PROCEDURE offset_amt (
		v_clm_dist_no		IN gicl_reserve_ds.clm_dist_no%TYPE,
        v1_claim_id			IN gicl_clm_res_hist.claim_id%TYPE,
        v1_clm_res_hist_id  IN gicl_reserve_ds.clm_res_hist_id%TYPE
	);
	
	PROCEDURE create_new_reserve2(
		p_claim_id              IN gicl_claims.claim_id%TYPE,  -- C022.claim_id
        p_item_no               IN gicl_item_peril.item_no%TYPE,
        p_peril_cd              IN gicl_item_peril.peril_cd%TYPE,
        p_grouped_item_no       IN gicl_item_peril.grouped_item_no%TYPE,
        p_hist_seq_no           IN gicl_clm_res_hist.hist_seq_no%TYPE,
        p_user_id               IN gicl_claims.user_id%TYPE,
        p_loss_reserve          IN gicl_clm_reserve.loss_reserve%TYPE,
        p_exp_reserve           IN gicl_clm_reserve.expense_reserve%TYPE,
		p_currency_cd			IN gicl_clm_res_hist.currency_cd%TYPE,
		p_convert_rate			IN gicl_clm_res_hist.convert_rate%TYPE,
		p_booking_month			IN gicl_clm_res_hist.booking_month%TYPE,
		p_booking_year			IN gicl_clm_res_hist.booking_year%TYPE,
		p_dist_date				IN DATE
	);

	PROCEDURE gicls024_post_forms_commit(
        p_claim_id              IN gicl_claims.claim_id%TYPE
    );
    
    PROCEDURE gicls024_check_loss_rsrv(
        p_c007_claim_id          IN GICL_ITEM_PERIL.claim_id%TYPE,
        p_c007_item_no           IN GICL_ITEM_PERIL.item_no%TYPE,
        p_c007_peril_cd          IN GICL_ITEM_PERIL.peril_cd%TYPE,
        p_c007_grouped_item_no   IN GICL_ITEM_PERIL.grouped_item_no%TYPE,
        p_dsp_line_cd            IN GICL_CLAIMS.line_cd%TYPE,
        p_dsp_iss_cd             IN GICL_CLAIMS.iss_cd%TYPE,
        p_user_id                IN GIAC_USER_FUNCTIONS.user_id%TYPE,
        p_c022_loss_reserve      IN NUMBER,
        p_c022_expense_reserve   IN NUMBER,
        p_c017_convert_rate      IN NUMBER,
        p_message               OUT VARCHAR2
    );
    
    FUNCTION gicls024_check_booking_date(p_claim_id gicl_claims.claim_id%TYPE)
    RETURN VARCHAR2; 
    
    FUNCTION gicls024_get_override_cnt(p_claim_id gicl_claims.claim_id%TYPE)
    RETURN VARCHAR2;
    
	FUNCTION get_curr_cd (p_claim_id  GICL_CLAIMS.claim_id%TYPE, p_item_no GICL_CLM_ITEM.item_no%TYPE)
     RETURN  NUMBER;
       
    FUNCTION get_curr_rt (p_claim_id  GICL_CLAIMS.claim_id%TYPE, p_item_no GICL_CLM_ITEM.item_no%TYPE)
     RETURN  NUMBER;
	 
END gicl_clm_reserve_pkg;
/


