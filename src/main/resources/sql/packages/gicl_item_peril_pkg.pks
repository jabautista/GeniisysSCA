CREATE OR REPLACE PACKAGE CPI.gicl_item_peril_pkg
AS

    TYPE gicl_item_peril_type IS RECORD(
        claim_id          gicl_item_peril.claim_id%TYPE,
        item_no           gicl_item_peril.item_no%TYPE,
        peril_cd          gicl_item_peril.peril_cd%TYPE,
        user_id           gicl_item_peril.user_id%TYPE,
        last_update       gicl_item_peril.last_update%TYPE,
        ann_tsi_amt       gicl_item_peril.ann_tsi_amt%TYPE,
        cpi_rec_no        gicl_item_peril.cpi_rec_no%TYPE,
        cpi_branch_cd     gicl_item_peril.cpi_branch_cd%TYPE,
        motshop_tag       gicl_item_peril.motshop_tag%TYPE,
        loss_cat_cd       gicl_item_peril.loss_cat_cd%TYPE,
        line_cd           gicl_item_peril.line_cd%TYPE,
        close_date        gicl_item_peril.close_date%TYPE,
        close_flag        gicl_item_peril.close_flag%TYPE,
        close_flag2       gicl_item_peril.close_flag2%TYPE,
        close_date2       gicl_item_peril.close_date2%TYPE,
        aggregate_sw      gicl_item_peril.aggregate_sw%TYPE,
        grouped_item_no   gicl_item_peril.grouped_item_no%TYPE,
        allow_tsi_amt     gicl_item_peril.allow_tsi_amt%TYPE,
        base_amt          gicl_item_peril.base_amt%TYPE,
        no_of_days        gicl_item_peril.no_of_days%TYPE,
        allow_no_of_days  gicl_item_peril.allow_no_of_days%TYPE,
        hist_indicator    VARCHAR2(1),
        dsp_loss_cat_des  giis_loss_ctgry.loss_cat_des%TYPE,
        dsp_peril_name    giis_peril.peril_name%TYPE,
        nbt_close_flag    VARCHAR2(32000),
        nbt_close_flag2   VARCHAR2(32000),
        tloss_fl          VARCHAR(5),
        
        dsp_item_no       VARCHAR(10),
        dsp_item_title    gicl_clm_item.item_title%TYPE,
        dsp_peril_cd      gicl_item_peril.peril_cd%TYPE,
        dsp_curr_desc     giis_currency.currency_desc%TYPE,
        currency_cd       giis_currency.main_currency_cd%TYPE,
        dsp_grp_itm_title VARCHAR2(50),
                
        color             gicl_motor_car_dtl.color%TYPE,  
        model_year        gicl_motor_car_dtl.model_year%TYPE,
        serial_no         gicl_motor_car_dtl.serial_no%TYPE,
        motor_no          gicl_motor_car_dtl.motor_no%TYPE,
        plate_no          gicl_motor_car_dtl.plate_no%TYPE,
        mv_file_no        gicl_motor_car_dtl.mv_file_no%TYPE,
        drvr_name         gicl_motor_car_dtl.drvr_name%TYPE,
        dsp_make          giis_mc_make.make%TYPE,
        dsp_subline_type  giis_mc_subline_type.subline_type_desc%TYPE,
        
        reserve_dtl_exist VARCHAR2(1),
        payment_dtl_exist VARCHAR2(1),
        sdf_last_update   VARCHAR2(30) --added by steven 06.03.2013
        );
        
    TYPE gicl_item_peril_tab IS TABLE OF gicl_item_peril_type;    

    FUNCTION get_gicl_item_peril_exist( 
        p_claim_id          gicl_item_peril.claim_id%TYPE
        ) 
    RETURN VARCHAR2;
    
    FUNCTION get_gicl_item_peril_exist(
        p_item_no           gicl_item_peril.item_no%TYPE,
        p_claim_id          gicl_item_peril.claim_id%TYPE
        ) 
    RETURN VARCHAR2;    

    FUNCTION get_gicl_item_peril(
        p_claim_id      gicl_item_peril.claim_id%TYPE,
        p_item_no       gicl_item_peril.item_no%TYPE,
        p_line_cd       gicl_item_peril.line_cd%TYPE
        ) 
    RETURN gicl_item_peril_tab PIPELINED;

    PROCEDURE validate_peril_reserve(
        p_item_no               IN  gicl_item_peril.item_no%TYPE,
        p_claim_id              IN  gicl_item_peril.claim_id%TYPE,
        p_grouped_item_no       IN  gicl_item_peril.grouped_item_no%TYPE,
        p_msg_alert             OUT VARCHAR2
        );
        
    FUNCTION populate_allow_tsi_amt(
        p_aggregate_sw          VARCHAR2,
        p_base_amt                NUMBER,
        p_no_of_days            NUMBER,
        p_peril_cd               NUMBER,
        p_item_no               NUMBER,
        p_grouped_item_no       NUMBER,
        p_ann_tsi_amt           NUMBER,
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE
        )
    RETURN NUMBER;        
        
    FUNCTION get_peril_list(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_item_no               gipi_itmperil.item_no%TYPE,
        p_peril_cd              gipi_itmperil.peril_cd%TYPE,
        p_loss_cat_cd           giis_loss_ctgry.loss_cat_cd%TYPE,
        p_loss_cat_desc         giis_loss_ctgry.loss_cat_des%TYPE,
		p_find_text varchar2
        )
    RETURN gicl_item_peril_tab PIPELINED;
    
     FUNCTION get_mc_peril_list(
        p_claim_id gicl_claims.claim_id%type,
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_item_no               gipi_itmperil.item_no%TYPE,
        p_peril_cd              gipi_itmperil.peril_cd%TYPE,
        p_loss_cat_cd           giis_loss_ctgry.loss_cat_cd%TYPE,
        p_loss_cat_desc         giis_loss_ctgry.loss_cat_des%TYPE,
		p_find_text varchar2
        )
    RETURN gicl_item_peril_tab PIPELINED;
       
    PROCEDURE del_gicl_item_peril(
        p_claim_id      gicl_item_peril.claim_id%TYPE,
        p_item_no       gicl_item_peril.item_no%TYPE
        );
        
    PROCEDURE del_gicl_item_peril(
        p_claim_id      gicl_item_peril.claim_id%TYPE,
        p_item_no       gicl_item_peril.item_no%TYPE,
        p_peril_cd      gicl_item_peril.peril_cd%TYPE
        );        
          
    PROCEDURE set_gicl_item_peril(
        p_claim_id          gicl_item_peril.claim_id%TYPE,
        p_item_no           gicl_item_peril.item_no%TYPE,
        p_peril_cd          gicl_item_peril.peril_cd%TYPE,
        p_user_id           gicl_item_peril.user_id%TYPE,
        p_last_update       gicl_item_peril.last_update%TYPE,
        p_ann_tsi_amt       gicl_item_peril.ann_tsi_amt%TYPE,
        p_cpi_rec_no        gicl_item_peril.cpi_rec_no%TYPE,
        p_cpi_branch_cd     gicl_item_peril.cpi_branch_cd%TYPE,
        p_motshop_tag       gicl_item_peril.motshop_tag%TYPE,
        p_loss_cat_cd       gicl_item_peril.loss_cat_cd%TYPE,
        p_line_cd           gicl_item_peril.line_cd%TYPE,
        p_close_date        gicl_item_peril.close_date%TYPE,
        p_close_flag        gicl_item_peril.close_flag%TYPE,
        p_close_flag2       gicl_item_peril.close_flag2%TYPE,
        p_close_date2       gicl_item_peril.close_date2%TYPE,
        p_aggregate_sw      gicl_item_peril.aggregate_sw%TYPE,
        p_grouped_item_no   gicl_item_peril.grouped_item_no%TYPE,
        p_allow_tsi_amt     gicl_item_peril.allow_tsi_amt%TYPE,
        p_base_amt          gicl_item_peril.base_amt%TYPE,
        p_no_of_days        gicl_item_peril.no_of_days%TYPE,
        p_allow_no_of_days  gicl_item_peril.allow_no_of_days%TYPE
		
        );
        
    FUNCTION get_gicl_item_peril2(
        p_claim_id      gicl_item_peril.claim_id%TYPE,
        p_line_cd       gicl_item_peril.line_cd%TYPE
        ) 
    RETURN gicl_item_peril_tab PIPELINED;
    
    FUNCTION populate_allow_tsi_amt_PA(
        p_aggregate_sw          VARCHAR2,
        p_base_amt              NUMBER,
        p_no_of_days            NUMBER,
        p_peril_cd              NUMBER,
        p_item_no               NUMBER,
        p_grouped_item_no       NUMBER,
        p_ann_tsi_amt           NUMBER,
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE
        )
    RETURN NUMBER;   
    
   FUNCTION get_peril_list_PA(
        p_claim_id              gicl_claims.claim_id%TYPE,
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_item_no               gipi_itmperil.item_no%TYPE,
        p_peril_cd              gipi_itmperil.peril_cd%TYPE,
        p_loss_cat_cd           giis_loss_ctgry.loss_cat_cd%TYPE,
        p_loss_cat_desc         giis_loss_ctgry.loss_cat_des%TYPE,
        p_cat_peril_cd          giis_loss_ctgry.peril_cd%TYPE,
        p_grouped_item_no       gicl_item_peril.grouped_item_no%TYPE,
        p_find_text             VARCHAR2
        )
    RETURN gicl_item_peril_tab PIPELINED;
    
   FUNCTION get_gicl_item_peril3(p_claim_id   IN  GICL_ITEM_PERIL.claim_id%TYPE)
    RETURN gicl_item_peril_tab PIPELINED;

    FUNCTION extract_base_amt_grp (
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_item_no               gipi_itmperil.item_no%TYPE,
        p_peril_cd              gipi_itmperil.peril_cd%TYPE,
        p_grouped_item_no       gicl_item_peril.grouped_item_no%TYPE
        )    
    RETURN NUMBER;
    
    FUNCTION extract_base_amt (
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_item_no               gipi_itmperil.item_no%TYPE,
        p_peril_cd              gipi_itmperil.peril_cd%TYPE,
        p_grouped_item_no       gicl_item_peril.grouped_item_no%TYPE
        )    
    RETURN NUMBER;
    
    PROCEDURE check_agg_peril(
        p_aggregate_sw          gicl_item_peril.aggregate_sw%TYPE,
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_item_no               gipi_itmperil.item_no%TYPE,
        p_grouped_item_no       gicl_item_peril.grouped_item_no%TYPE,
        p_peril_cd              gipi_itmperil.peril_cd%TYPE,
        p_no_of_days            NUMBER,
        p_ann_tsi_amt           NUMBER,
        p_agg_peril        OUT  VARCHAR2,
        p_base_amt         OUT  gicl_item_peril.base_amt%TYPE,
        p_allow_tsi_amt    OUT  gicl_item_peril.allow_tsi_amt%TYPE,
    --    p_nbt_allow_tsi    OUT  gicl_item_peril.allow_tsi_amt%TYPE,
        p_allow_no_of_days OUT  gicl_item_peril.allow_no_of_days%TYPE
        
    );
    
   FUNCTION gicls032_check_peril_status(
      p_claim_id        GICL_ITEM_PERIL.claim_id%TYPE,
      p_item_no         GICL_ITEM_PERIL.item_no%TYPE,
      p_peril_cd        GICL_ITEM_PERIL.peril_cd%TYPE,
      p_grouped_item_no GICL_ITEM_PERIL.grouped_item_no%TYPE
   ) RETURN gicl_item_peril.close_flag%type;    
            
   PROCEDURE gicls024_update_status(
      p_claim_id        GICL_ITEM_PERIL.claim_id%TYPE,
      p_item_no         GICL_ITEM_PERIL.item_no%TYPE,
      p_peril_cd        GICL_ITEM_PERIL.peril_cd%TYPE,
      p_grouped_item_no GICL_ITEM_PERIL.grouped_item_no%TYPE,
      p_close_flag      GICL_ITEM_PERIL.close_flag%TYPE,
      p_close_flag2     GICL_ITEM_PERIL.close_flag2%TYPE,
      p_update_xol      VARCHAR2,
      p_distribution_date GICL_CLM_RES_HIST.distribution_date%TYPE,
      p_loss_reserve      GICL_CLM_RESERVE.LOSS_RESERVE%type,
      p_expense_reserve   GICL_CLM_RESERVE.expense_RESERVE%type
   );
   
   PROCEDURE check_peril_status_gicls024 (
        p_claim_id      IN  GICL_ITEM_PERIL.claim_id%TYPE,
        p_peril_cd      IN  GICL_ITEM_PERIL.peril_cd%TYPE,
        p_item_no       IN  GICL_ITEM_PERIL.item_no%TYPE,
        p_grp_item_no   IN  GICL_ITEM_PERIL.grouped_item_no%TYPE,
        v_close_flag    OUT gicl_item_peril.close_flag%type,
        v_close_flag2   OUT gicl_item_peril.close_flag2%type
    );
   
   FUNCTION get_gicl_item_peril4(p_claim_id   IN  GICL_ITEM_PERIL.claim_id%TYPE)
    RETURN gicl_item_peril_tab PIPELINED;
	
   FUNCTION get_gicl_item_peril5(p_claim_id   IN  GICL_ITEM_PERIL.claim_id%TYPE)
    RETURN gicl_item_peril_tab PIPELINED;
    
   FUNCTION check_share_percentage(
        p_claim_id   IN  GICL_ITEM_PERIL.claim_id%TYPE,
        p_peril_cd   IN  GICL_ITEM_PERIL.peril_cd%TYPE,
        p_item_no    IN  GICL_ITEM_PERIL.item_no%TYPE)
    RETURN VARCHAR2;
              
END gicl_item_peril_pkg;
/


