CREATE OR REPLACE PACKAGE CPI.GICL_LOSS_EXP_RIDS_PKG AS
    
    TYPE gicl_loss_exp_rids_type IS RECORD(
        claim_id                GICL_LOSS_EXP_RIDS.claim_id%TYPE,             
        clm_loss_id             GICL_LOSS_EXP_RIDS.clm_loss_id%TYPE,
        clm_dist_no             GICL_LOSS_EXP_RIDS.clm_dist_no%TYPE,
        dist_year               GICL_LOSS_EXP_RIDS.dist_year%TYPE,
        item_no                 GICL_LOSS_EXP_RIDS.item_no%TYPE,
        peril_cd                GICL_LOSS_EXP_RIDS.peril_cd%TYPE,
        payee_cd                GICL_LOSS_EXP_RIDS.payee_cd%TYPE,
        grp_seq_no              GICL_LOSS_EXP_RIDS.grp_seq_no%TYPE,
        ri_cd                   GICL_LOSS_EXP_RIDS.ri_cd%TYPE,
        dsp_ri_name             GIIS_REINSURER.ri_sname%TYPE,
        line_cd                 GICL_LOSS_EXP_RIDS.line_cd%TYPE,
        user_id                 GICL_LOSS_EXP_RIDS.user_id%TYPE,
        last_update             GICL_LOSS_EXP_RIDS.last_update%TYPE,
        acct_trty_type          GICL_LOSS_EXP_RIDS.acct_trty_type%TYPE,
        shr_loss_exp_ri_pct     GICL_LOSS_EXP_RIDS.shr_loss_exp_ri_pct%TYPE,
        shr_le_ri_pd_amt        GICL_LOSS_EXP_RIDS.shr_le_ri_pd_amt%TYPE,
        shr_le_ri_adv_amt       GICL_LOSS_EXP_RIDS.shr_le_ri_adv_amt%TYPE,
        shr_le_ri_net_amt       GICL_LOSS_EXP_RIDS.shr_le_ri_net_amt%TYPE, 
        share_type              GICL_LOSS_EXP_RIDS.share_type%TYPE
    );
    
    TYPE gicl_loss_exp_rids_tab IS TABLE OF gicl_loss_exp_rids_type;
    
    FUNCTION get_gicl_loss_exp_rids(p_claim_id      GICL_LOSS_EXP_RIDS.claim_id%TYPE,
                                    p_clm_loss_id   GICL_LOSS_EXP_RIDS.clm_loss_id%TYPE,
                                    p_clm_dist_no   GICL_LOSS_EXP_RIDS.clm_dist_no%TYPE,
                                    p_grp_seq_no    GICL_LOSS_EXP_RIDS.grp_seq_no%TYPE )
                                    
      RETURN gicl_loss_exp_rids_tab PIPELINED;              
 


END GICL_LOSS_EXP_RIDS_PKG;
/


