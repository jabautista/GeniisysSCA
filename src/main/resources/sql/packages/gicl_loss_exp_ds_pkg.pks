CREATE OR REPLACE PACKAGE CPI.GICL_LOSS_EXP_DS_PKG AS

    TYPE gicl_loss_exp_ds_type IS RECORD (
        claim_id                GICL_LOSS_EXP_DS.claim_id%TYPE,        
        clm_loss_id             GICL_LOSS_EXP_DS.clm_loss_id%TYPE,
        clm_dist_no             GICL_LOSS_EXP_DS.clm_dist_no%TYPE,
        dist_year               GICL_LOSS_EXP_DS.dist_year%TYPE,
        item_no                 GICL_LOSS_EXP_DS.item_no%TYPE,
        peril_cd                GICL_LOSS_EXP_DS.peril_cd%TYPE,
        payee_cd                GICL_LOSS_EXP_DS.payee_cd%TYPE,
        grp_seq_no              GICL_LOSS_EXP_DS.grp_seq_no%TYPE,
        line_cd                 GICL_LOSS_EXP_DS.line_cd%TYPE,
        user_id                 GICL_LOSS_EXP_DS.user_id%TYPE,
        last_update             GICL_LOSS_EXP_DS.last_update%TYPE,
        acct_trty_type          GICL_LOSS_EXP_DS.acct_trty_type%TYPE,
        shr_loss_exp_pct        GICL_LOSS_EXP_DS.shr_loss_exp_pct%TYPE,
        shr_le_pd_amt           GICL_LOSS_EXP_DS.shr_le_pd_amt%TYPE,
        shr_le_adv_amt          GICL_LOSS_EXP_DS.shr_le_adv_amt%TYPE,
        shr_le_net_amt          GICL_LOSS_EXP_DS.shr_le_net_amt%TYPE,
        share_type              GICL_LOSS_EXP_DS.share_type%TYPE,
        negate_tag              GICL_LOSS_EXP_DS.negate_tag%TYPE,
        distribution_date       GICL_LOSS_EXP_DS.distribution_date%TYPE,
        grouped_item_no         GICL_LOSS_EXP_DS.grouped_item_no%TYPE,
        xol_ded                 GICL_LOSS_EXP_DS.xol_ded%TYPE,
        trty_name               GIIS_DIST_SHARE.trty_name%TYPE
    );
    
    TYPE gicl_loss_exp_ds_tab IS TABLE OF gicl_loss_exp_ds_type;
    
    FUNCTION get_gicl_loss_exp_ds(p_claim_id        GICL_LOSS_EXP_DS.claim_id%TYPE,
                                  p_clm_loss_id     GICL_LOSS_EXP_DS.clm_loss_id%TYPE)
    RETURN gicl_loss_exp_ds_tab PIPELINED;
    
    FUNCTION check_exist_gicl_loss_exp_ds
    (p_claim_id     IN   GICL_LOSS_EXP_DS.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_DS.clm_loss_id%TYPE)
     
     RETURN VARCHAR2;
     
    FUNCTION check_loss_exp_ds_not_negated
    (p_claim_id     IN   GICL_LOSS_EXP_DS.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_DS.clm_loss_id%TYPE)
     
     RETURN VARCHAR2;
     
    FUNCTION get_max_clm_dist_no
    (p_claim_id     IN   GICL_CLM_LOSS_EXP.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
     
    RETURN NUMBER;

END GICL_LOSS_EXP_DS_PKG;
/


