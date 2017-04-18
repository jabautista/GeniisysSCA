CREATE OR REPLACE PACKAGE CPI.GICL_RESERVE_RIDS_PKG
AS
   
    TYPE gicl_res_rids_type IS RECORD(
        claim_id    gicl_reserve_rids.claim_id%TYPE,
        item_no     gicl_reserve_rids.item_no%TYPE,
        hist_seq_no gicl_reserve_rids.hist_seq_no%TYPE,
        ri_cd       gicl_reserve_rids.ri_cd%TYPE,
        ri_name     giis_reinsurer.ri_name%TYPE,
        shr_ri_pct  gicl_reserve_rids.shr_ri_pct%TYPE,
        shr_loss_ri_res_amt gicl_reserve_rids.shr_loss_ri_res_amt%TYPE,
        shr_exp_ri_res_amt gicl_reserve_rids.shr_exp_ri_res_amt%TYPE
    );
    
    TYPE gicl_res_rids_tab IS TABLE OF gicl_res_rids_type;
    
     FUNCTION get_res_rids (
       p_claim_id   gicl_reserve_rids.claim_id%TYPE,
       p_line_cd    gicl_reserve_rids.line_cd%TYPE,
       p_item_no    gicl_reserve_rids.item_no%TYPE,
       p_hist_seq_no gicl_reserve_rids.hist_seq_no%TYPE,
	   p_clm_dist_no           gicl_reserve_ds.clm_dist_no%TYPE,
	   p_grp_seq_no           gicl_reserve_ds.grp_seq_no%TYPE,
	   p_clm_res_hist_id           gicl_reserve_ds.clm_res_hist_id %TYPE
       
    ) RETURN gicl_res_rids_tab PIPELINED;
    
    PROCEDURE save_reserve_rids(
        p_claim_id  IN gicl_reserve_rids.claim_id%TYPE,
        p_clm_res_hist_id  IN gicl_reserve_rids.clm_res_hist_id%TYPE,
        p_clm_dist_no  IN gicl_reserve_rids.clm_dist_no%TYPE,
        p_grp_seq_no  IN gicl_reserve_rids.grp_seq_no%TYPE,
        p_ri_cd  IN gicl_reserve_rids.ri_cd%TYPE,
        p_line_cd  IN gicl_reserve_rids.line_cd%TYPE,
        p_dist_year  IN gicl_reserve_rids.dist_year%TYPE,
        p_item_no  IN gicl_reserve_rids.item_no%TYPE,
        p_peril_cd  IN gicl_reserve_rids.peril_cd%TYPE,
        p_hist_seq_no  IN gicl_reserve_rids.hist_seq_no%TYPE,
        p_user_id  IN gicl_reserve_rids.user_id%TYPE,
        p_acct_trty_type  IN gicl_reserve_rids.acct_trty_type%TYPE,
        p_prnt_ri_cd  IN gicl_reserve_rids.prnt_ri_cd%TYPE,
        p_shr_ri_pct  IN gicl_reserve_rids.shr_ri_pct%TYPE,
        p_shr_loss_ri_res_amt  IN gicl_reserve_rids.shr_loss_ri_res_amt%TYPE,
        p_shr_exp_ri_res_amt  IN gicl_reserve_rids.shr_exp_ri_res_amt%TYPE,
        p_share_type  IN gicl_reserve_rids.share_type%TYPE,
        --p_cpi_rec_no  IN gicl_reserve_rids.cpi_rec_no%TYPE,
        --p_cpi_branch_cd  IN gicl_reserve_rids.cpi_branch_cd%TYPE,
        p_pla_id  IN gicl_reserve_rids.pla_id%TYPE,
        p_shr_ri_pct_real  IN gicl_reserve_rids.shr_ri_pct_real%TYPE,
        p_res_pla_id  IN gicl_reserve_rids.res_pla_id%TYPE,
        p_grouped_item_no  IN gicl_reserve_rids.grouped_item_no%TYPE
    );
END GICL_RESERVE_RIDS_PKG;
/


