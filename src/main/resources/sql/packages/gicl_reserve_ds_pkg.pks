CREATE OR REPLACE PACKAGE CPI.GICL_RESERVE_DS_PKG
AS

    TYPE gicl_reserve_ds_type IS RECORD(
        claim_id                  gicl_reserve_ds.claim_id%TYPE,
        clm_res_hist_id           gicl_reserve_ds.clm_res_hist_id %TYPE,
        clm_dist_no               gicl_reserve_ds.clm_dist_no%TYPE,
        grp_seq_no                gicl_reserve_ds.grp_seq_no%TYPE,
        dist_year                 gicl_reserve_ds.dist_year%TYPE,
        item_no                   gicl_reserve_ds.item_no%TYPE,
        peril_cd                  gicl_reserve_ds.peril_cd%TYPE,
        hist_seq_no               gicl_reserve_ds.hist_seq_no%TYPE,
        line_cd                   gicl_reserve_ds.line_cd%TYPE,
        user_id                   gicl_reserve_ds.user_id%TYPE,
        last_update               gicl_reserve_ds.last_update%TYPE,
        negate_tag                gicl_reserve_ds.negate_tag%TYPE,
        acct_trty_type            gicl_reserve_ds.acct_trty_type%TYPE,
        share_type                gicl_reserve_ds.share_type%TYPE,
        shr_pct                   gicl_reserve_ds.shr_pct%TYPE,
        shr_loss_res_amt          gicl_reserve_ds.shr_loss_res_amt%TYPE,
        shr_exp_res_amt           gicl_reserve_ds.shr_exp_res_amt%TYPE,
        cpi_rec_no                gicl_reserve_ds.cpi_rec_no%TYPE,
        cpi_branch_cd             gicl_reserve_ds.cpi_branch_cd%TYPE,
        grouped_item_no             gicl_reserve_ds.grouped_item_no%TYPE,
        xol_ded                     gicl_reserve_ds.xol_ded%TYPE,
        dsp_trty_name             giis_dist_share.trty_name%TYPE,
        dsp_shr_loss_res_amt      gicl_reserve_ds.shr_loss_res_amt%TYPE,
        dsp_shr_exp_res_amt       gicl_reserve_ds.shr_exp_res_amt%TYPE
        );
        
    TYPE gicl_reserve_ds_tab IS TABLE OF gicl_reserve_ds_type;
        
    FUNCTION get_gicl_reserve_ds(
        p_claim_id              gicl_reserve_ds.claim_id%TYPE,
        p_line_cd               gicl_reserve_ds.line_cd%TYPE,
        p_clm_res_hist_id       gicl_reserve_ds.clm_res_hist_id%TYPE,
        p_item_no               gicl_reserve_ds.item_no%TYPE,
        p_grouped_item_no       gicl_reserve_ds.grouped_item_no%TYPE,
        p_peril_cd              gicl_reserve_ds.peril_cd%TYPE,
        p_hist_seq_no           gicl_reserve_ds.hist_seq_no%TYPE
        )
    RETURN gicl_reserve_ds_tab PIPELINED;
    
     TYPE gicl_reserve_ds_type2 IS RECORD(
        claim_id                  gicl_reserve_ds.claim_id%TYPE,
        clm_res_hist_id           gicl_reserve_ds.clm_res_hist_id %TYPE,
        dist_year                 gicl_reserve_ds.dist_year%TYPE,
        --item_no                   gicl_reserve_ds.item_no%TYPE,
        --peril_cd                  gicl_reserve_ds.peril_cd%TYPE,
        hist_seq_no               gicl_reserve_ds.hist_seq_no%TYPE,
        line_cd                   gicl_reserve_ds.line_cd%TYPE,
        --user_id                   gicl_reserve_ds.user_id%TYPE,
        --last_update               gicl_reserve_ds.last_update%TYPE,
        shr_pct                   gicl_reserve_ds.shr_pct%TYPE,
        shr_loss_res_amt          gicl_reserve_ds.shr_loss_res_amt%TYPE,
        shr_exp_res_amt           gicl_reserve_ds.shr_exp_res_amt%TYPE,
		clm_dist_no           gicl_reserve_ds.clm_dist_no%TYPE,
		grp_seq_no           gicl_reserve_ds.grp_seq_no%TYPE,
        --cpi_rec_no                gicl_reserve_ds.cpi_rec_no%TYPE,
        --cpi_branch_cd             gicl_reserve_ds.cpi_branch_cd%TYPE,
        dsp_trty_name             giis_dist_share.trty_name%TYPE
    );
    
    TYPE gicl_reserve_ds_tab2 IS TABLE OF gicl_reserve_ds_type2;
    
    FUNCTION get_gicl_reserve_ds2(
        p_claim_id              gicl_reserve_ds.claim_id%TYPE
    ) RETURN gicl_reserve_ds_tab2 PIPELINED;
    
    PROCEDURE set_gicl_reserve_ds(
        p_claim_id       IN gicl_reserve_ds.claim_id%TYPE,
        p_clm_res_hist_id  IN gicl_reserve_ds.clm_res_hist_id%TYPE,
        p_trty_name        IN GIIS_DIST_SHARE.TRTY_NAME%TYPE,
        p_clm_dist_no      IN gicl_reserve_ds.clm_dist_no%TYPE, 
        p_grp_seq_no       IN gicl_reserve_ds.grp_seq_no%TYPE, 
        p_dist_year        IN gicl_reserve_ds.dist_year%TYPE,
        p_item_no          IN gicl_reserve_ds.item_no%TYPE, 
        p_peril_cd         IN gicl_reserve_ds.peril_cd%TYPE, 
        p_hist_seq_no      IN gicl_reserve_ds.hist_seq_no%TYPE, 
        p_line_cd          IN gicl_reserve_ds.line_cd%TYPE,   
        p_share_type       IN gicl_reserve_ds.share_type%TYPE, 
        p_shr_pct          IN gicl_reserve_ds.shr_pct%TYPE,
        p_shr_loss_res_amt IN gicl_reserve_ds.shr_loss_res_amt%TYPE, 
        p_shr_exp_res_amt  IN gicl_reserve_ds.shr_exp_res_amt%TYPE, 
        p_cpi_rec_no       IN gicl_reserve_ds.cpi_rec_no%TYPE, 
        p_cpi_branch_cd    IN gicl_reserve_ds.cpi_branch_cd%TYPE, 
        p_grouped_item_no  IN gicl_reserve_ds.grouped_item_no%TYPE,
        p_user_id          IN gicl_reserve_ds.user_id%TYPE 
    );
    
    TYPE gicl_reserve_ds_type3 IS RECORD(
        claim_id                  gicl_reserve_ds.claim_id%TYPE,
        clm_res_hist_id           gicl_reserve_ds.clm_res_hist_id %TYPE,
        dist_year                 gicl_reserve_ds.dist_year%TYPE,
        hist_seq_no               gicl_reserve_ds.hist_seq_no%TYPE,
        line_cd                   gicl_reserve_ds.line_cd%TYPE,
        shr_pct                   gicl_reserve_ds.shr_pct%TYPE,
        shr_loss_res_amt          gicl_reserve_ds.shr_loss_res_amt%TYPE,
        shr_exp_res_amt           gicl_reserve_ds.shr_exp_res_amt%TYPE,
		clm_dist_no               gicl_reserve_ds.clm_dist_no%TYPE,
		grp_seq_no                gicl_reserve_ds.grp_seq_no%TYPE,
        dsp_trty_name             giis_dist_share.trty_name%TYPE,
        share_type                gicl_reserve_ds.share_type%TYPE,
        upd_res_dist              giis_parameters.param_value_v%TYPE,
        prtfolio_sw               giis_dist_share.prtfolio_sw%TYPE,
        xol_ded_amt               giis_dist_share.xol_ded%TYPE,
        net_ret                   VARCHAR2(1)
    );
    
    TYPE gicl_reserve_ds_tab3 IS TABLE OF gicl_reserve_ds_type3;
    
    FUNCTION get_gicl_reserve_ds3(
        p_claim_id         IN gicl_reserve_ds.claim_id%TYPE,
        p_clm_res_hist_id  IN gicl_reserve_ds.clm_res_hist_id%TYPE, 
        p_item_no          IN gicl_reserve_ds.item_no%TYPE, 
        p_peril_cd         IN gicl_reserve_ds.peril_cd%TYPE
    ) RETURN gicl_reserve_ds_tab3 PIPELINED;
    
    PROCEDURE validate_xol_deduc(
        p_clm_res_hist_id       IN      gicl_reserve_ds.clm_res_hist_id%TYPE,
        p_grp_seq_no            IN      gicl_reserve_ds.grp_seq_no%TYPE,
        p_line_cd               IN      gicl_reserve_ds.line_cd%TYPE,
        p_shr_loss_res_amt      IN      gicl_reserve_ds.shr_loss_res_amt%TYPE,
        p_shr_exp_res_amt       IN      gicl_reserve_ds.shr_exp_res_amt%TYPE,
        p_xol_ded               IN      gicl_reserve_ds.xol_ded%TYPE,
        p_dsp_xol_ded           IN      gicl_reserve_ds.xol_ded%TYPE,
        p_trigger_item          IN      VARCHAR2,
        p_new_xol_ded              OUT  VARCHAR2,
        p_msg                      OUT  VARCHAR2
    );
    
    PROCEDURE continue_xol_deduc(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_grp_seq_no    IN  giis_dist_share.line_cd%TYPE,
        p_xol_ded       IN  gicl_reserve_ds.xol_ded%TYPE,
        p_dsp_xol_ded   IN  gicl_reserve_ds.xol_ded%TYPE,
        p_msg_alert    OUT  VARCHAR2,
        p_msg          OUT  VARCHAR2
    );
    
    PROCEDURE check_xol_amount_limits(
        p_grp_seq_no                IN  gicl_reserve_ds.grp_seq_no%TYPE,
        p_line_cd                   IN  gicl_reserve_ds.line_cd%TYPE,
        p_claim_id                  IN  gicl_reserve_ds.claim_id%TYPE,
        p_item_no                   IN  gicl_reserve_ds.item_no%TYPE,
        p_peril_cd                  IN  gicl_reserve_ds.peril_cd%TYPE,
        p_clm_dist_no               IN  gicl_reserve_ds.clm_dist_no%TYPE,
        p_clm_res_hist_id           IN  gicl_reserve_ds.clm_res_hist_id%TYPE,
        p_nbt_cat_cd                IN  gicl_claims.catastrophic_cd%TYPE,
        p_trigger_item              IN  VARCHAR2,
        p_c022_expense_reserve      IN  gicl_clm_reserve.expense_reserve%TYPE,
        p_c022_loss_reserve         IN  gicl_clm_reserve.loss_reserve%TYPE,
        p_c017_grouped_item_no      IN  GICL_CLM_RES_HIST.grouped_item_no%TYPE,
        p_shr_loss_res_amt          IN  gicl_reserve_ds.shr_loss_res_amt%TYPE,
        p_previous_loss_res_amt     IN  gicl_reserve_ds.shr_loss_res_amt%TYPE,
        p_xol_ded                   IN  gicl_reserve_ds.xol_ded%TYPE,
        p_dsp_xol_ded               IN  gicl_reserve_ds.xol_ded%TYPE,
        p_shr_exp_res_amt           IN  gicl_reserve_ds.shr_exp_res_amt%TYPE,
        p_previous_exp_res_amt      IN  gicl_reserve_ds.shr_exp_res_amt%TYPE,
        p_shr_pct                   IN  gicl_reserve_ds.shr_pct%TYPE,
        p_previous_shr_pct          IN  gicl_reserve_ds.shr_pct%TYPE,
        p_new_loss_res_amt         OUT  VARCHAR2,
        p_new_exp_res_amt          OUT  VARCHAR2,
        p_new_pct                  OUT  VARCHAR2,
        p_msg                      OUT  VARCHAR2,
        p_msg2                     OUT  VARCHAR2
    );
    
    PROCEDURE update_shr_loss_res_amt (
       p_claim_id           gicl_reserve_rids.claim_id%TYPE,
       p_clm_res_hist_id    gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_item_no            gicl_reserve_ds.item_no%TYPE,
       p_peril_cd           gicl_reserve_ds.peril_cd%TYPE,
       p_grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE,
       p_clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE,
       p_loss_reserve       gicl_clm_res_hist.loss_reserve%TYPE,
       p_tot_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_tot_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_shr_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_prev_loss_res_amt  gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_c007_ann_tsi_amt   gicl_item_peril.ann_tsi_amt%TYPE,
       p_distribution_date  VARCHAR2,
       p_net_ret            VARCHAR2
    );
    
    PROCEDURE create_net_ret_for_loss (
       p_claim_id           gicl_claims.claim_id%TYPE,
       p_peril_cd           giuw_itemperilds_dtl.peril_cd%TYPE,
       p_item_no            giuw_itemperilds_dtl.item_no%TYPE,
       p_loss_reserve       gicl_clm_res_hist.loss_reserve%TYPE,
       p_tot_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_grouped_item_no    gicl_reserve_ds.grouped_item_no%TYPE,
       p_distribution_date  VARCHAR2,
       p_clm_res_hist_id    gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE,
       p_c007_ann_tsi_amt   gicl_item_peril.ann_tsi_amt%TYPE,
       p_prev_loss_res_amt  gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_shr_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE,
       p_share_type         gicl_reserve_ds.share_type%TYPE,
       p_hist_seq_no        gicl_reserve_ds.hist_seq_no%TYPE
    );
    
    PROCEDURE update_shr_pct (
       p_claim_id           gicl_reserve_rids.claim_id%TYPE,
       p_clm_res_hist_id    gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_item_no            gicl_reserve_ds.item_no%TYPE,
       p_peril_cd           gicl_reserve_ds.peril_cd%TYPE,
       p_grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE,
       p_clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE,
       p_loss_reserve       gicl_clm_res_hist.loss_reserve%TYPE,
       p_tot_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_tot_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_tot_shr_pct        gicl_reserve_ds.shr_pct%TYPE,
       p_shr_pct            gicl_reserve_ds.shr_pct%TYPE,
       p_c007_ann_tsi_amt   gicl_item_peril.ann_tsi_amt%TYPE,
       p_distribution_date  VARCHAR2,
       p_net_ret            VARCHAR2
    );
    
    PROCEDURE update_shr_exp_res_amt (
       p_claim_id           gicl_reserve_rids.claim_id%TYPE,
       p_clm_res_hist_id    gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_item_no            gicl_reserve_ds.item_no%TYPE,
       p_peril_cd           gicl_reserve_ds.peril_cd%TYPE,
       p_grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE,
       p_clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE,
       p_expense_reserve    gicl_clm_res_hist.expense_reserve%TYPE,
       p_tot_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_tot_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_shr_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_prev_exp_res_amt   gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_c007_ann_tsi_amt   gicl_item_peril.ann_tsi_amt%TYPE,
       p_distribution_date  VARCHAR2,
       p_net_ret            VARCHAR2
    );
    
    PROCEDURE create_net_ret_for_pct (
       p_claim_id            gicl_claims.claim_id%TYPE,
       p_peril_cd            giuw_itemperilds_dtl.peril_cd%TYPE,
       p_item_no             giuw_itemperilds_dtl.item_no%TYPE,
       p_loss_reserve        gicl_clm_res_hist.loss_reserve%TYPE,
       p_tot_exp_res_amt     gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_grouped_item_no     gicl_reserve_ds.grouped_item_no%TYPE,
       p_distribution_date   VARCHAR2,
       p_clm_res_hist_id     gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_clm_dist_no         gicl_reserve_ds.clm_dist_no%TYPE,
       p_c007_ann_tsi_amt    gicl_item_peril.ann_tsi_amt%TYPE,
       p_grp_seq_no          gicl_reserve_ds.grp_seq_no%TYPE,
       p_share_type          gicl_reserve_ds.share_type%TYPE,
       p_hist_seq_no         gicl_reserve_ds.hist_seq_no%TYPE,
       p_tot_shr_pct         gicl_reserve_ds.shr_pct%TYPE,
       p_tot_loss_res_amt    gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_upd_shr_pct         gicl_reserve_ds.shr_pct%TYPE
    );
    
    PROCEDURE create_net_ret_for_exp (
       p_claim_id           gicl_claims.claim_id%TYPE,
       p_peril_cd           giuw_itemperilds_dtl.peril_cd%TYPE,
       p_item_no            giuw_itemperilds_dtl.item_no%TYPE,
       p_expense_reserve    gicl_clm_res_hist.loss_reserve%TYPE,
       p_tot_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_grouped_item_no    gicl_reserve_ds.grouped_item_no%TYPE,
       p_distribution_date  VARCHAR2,
       p_clm_res_hist_id    gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE,
       p_c007_ann_tsi_amt   gicl_item_peril.ann_tsi_amt%TYPE,
       p_prev_exp_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_shr_exp_res_amt    gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE,
       p_share_type         gicl_reserve_ds.share_type%TYPE,
       p_hist_seq_no        gicl_reserve_ds.hist_seq_no%TYPE
    );
    
END GICL_RESERVE_DS_PKG;
/


