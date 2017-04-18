CREATE OR REPLACE PACKAGE CPI.gicls270_pkg
AS
    TYPE gicls270_type IS RECORD (
        recovery_id     GICL_CLM_RECOVERY.recovery_id%TYPE,
        line_cd         GICL_CLM_RECOVERY.line_cd%TYPE,
        iss_cd          GICL_CLM_RECOVERY.iss_cd%TYPE,
        rec_year        GICL_CLM_RECOVERY.rec_year%TYPE,
        rec_seq_no      GICL_CLM_RECOVERY.rec_seq_no%TYPE,
        cancel_tag      GICL_CLM_RECOVERY.cancel_tag%TYPE,
        recoverable_amt GICL_CLM_RECOVERY.recoverable_amt%TYPE,
        recovered_amt   GICL_CLM_RECOVERY.recovered_amt%TYPE,
        claim_id        GICL_CLAIMS.claim_id%TYPE,
        line_cd2        GICL_CLAIMS.line_cd%TYPE,
        subline_cd      GICL_CLAIMS.subline_cd%TYPE,
        iss_cd2         GICL_CLAIMS.iss_cd%TYPE,
        clm_yy          GICL_CLAIMS.clm_yy%TYPE,
        clm_seq_no      GICL_CLAIMS.clm_seq_no%TYPE,
        issue_yy        GICL_CLAIMS.issue_yy%TYPE,
        pol_seq_no      GICL_CLAIMS.pol_seq_no%TYPE,
        renew_no        GICL_CLAIMS.renew_no%TYPE,
        assd_no         GICL_CLAIMS.assd_no%TYPE,
        assured_name    GICL_CLAIMS.assured_name%TYPE,
        loss_cat_cd     GICL_CLAIMS.loss_cat_cd%TYPE,
        loss_date       GICL_CLAIMS.loss_date%TYPE,
        cancel_desc     VARCHAR2(50),
        claim_number    VARCHAR2(200),
        recovery_number VARCHAR2(200),
        loss_cat_desc   VARCHAR2(200),
        v_check         NUMBER(2),
        policy_number   VARCHAR2(200)
    );
    TYPE gicls270_tab IS TABLE OF gicls270_type;
    
    TYPE gicls270_payment_det_type IS RECORD(
        payor_class_cd      GICL_RECOVERY_PAYT.payor_class_cd%TYPE,
        payor_cd            GICL_RECOVERY_PAYT.payor_cd%TYPE,
        recovered_amt       GICL_RECOVERY_PAYT.recovered_amt%TYPE,
        tran_date           GICL_RECOVERY_PAYT.tran_date%TYPE,
        cancel_tag          GICL_RECOVERY_PAYT.cancel_tag%TYPE,
        dist_sw             GICL_RECOVERY_PAYT.cancel_tag%TYPE,
        claim_id            GICL_RECOVERY_PAYT.claim_id%TYPE,
        acct_tran_id        GICL_RECOVERY_PAYT.acct_tran_id%TYPE,
        recovery_id         GICL_RECOVERY_PAYT.recovery_id%TYPE,
        recovery_payt_id    GICL_RECOVERY_PAYT.recovery_payt_id%TYPE,
        ref_no              VARCHAR2(200),
        payee_name          VARCHAR2(200),
        v_check             NUMBER(2),
        payor_det           VARCHAR2(200)
    );
    
    TYPE gicls270_payment_det_tab IS TABLE OF gicls270_payment_det_type;
    
    TYPE gicls270_distribution_ds_type IS RECORD(
        recovery_id         GICL_RECOVERY_DS.recovery_id%TYPE,
        recovery_payt_id    GICL_RECOVERY_DS.recovery_payt_id%TYPE,
        rec_dist_no         GICL_RECOVERY_DS.rec_dist_no%TYPE,
        line_cd             GICL_RECOVERY_DS.line_cd%TYPE,
        grp_seq_no          GICL_RECOVERY_DS.grp_seq_no%TYPE,
        share_type          GICL_RECOVERY_DS.share_type%TYPE,
        acct_trty_type      GICL_RECOVERY_DS.acct_trty_type%TYPE,
        dist_year           GICL_RECOVERY_DS.dist_year%TYPE,
        shr_recovery_amt    GICL_RECOVERY_DS.shr_recovery_amt%TYPE,
        negate_tag          GICL_RECOVERY_DS.negate_tag%TYPE,
        negate_date         GICL_RECOVERY_DS.negate_date%TYPE,
        user_id             GICL_RECOVERY_DS.user_id%TYPE,
        last_update         GICL_RECOVERY_DS.last_update%TYPE,
        share_pct           GICL_RECOVERY_DS.share_pct%TYPE,
        share_name          GIIS_DIST_SHARE.trty_name%TYPE
    ); 
    
    TYPE gicls270_distribution_ds_tab IS TABLE OF gicls270_distribution_ds_type;
    
    TYPE gicls270_dist_rids_type IS RECORD(
        recovery_id         GICL_RECOVERY_RIDS.recovery_id%TYPE,
        recovery_payt_id    GICL_RECOVERY_RIDS.recovery_payt_id%TYPE,
        rec_dist_no         GICL_RECOVERY_RIDS.rec_dist_no%TYPE,
        line_cd             GICL_RECOVERY_RIDS.line_cd%TYPE,
        grp_seq_no          GICL_RECOVERY_RIDS.grp_seq_no%TYPE,
        dist_year           GICL_RECOVERY_RIDS.dist_year%TYPE,
        share_type          GICL_RECOVERY_RIDS.share_type%TYPE,
        acct_trty_type      GICL_RECOVERY_RIDS.acct_trty_type%TYPE,
        ri_cd               GICL_RECOVERY_RIDS.ri_cd%TYPE,
        share_ri_pct        GICL_RECOVERY_RIDS.share_ri_pct%TYPE,
        shr_ri_recovery_amt GICL_RECOVERY_RIDS.shr_ri_recovery_amt%TYPE,
        share_ri_pct_real   GICL_RECOVERY_RIDS.share_ri_pct_real%TYPE,
        negate_tag          GICL_RECOVERY_RIDS.negate_tag%TYPE,
        negate_date         GICL_RECOVERY_RIDS.negate_date%TYPE,
        user_id             GICL_RECOVERY_RIDS.user_id%TYPE,
        last_update         GICL_RECOVERY_RIDS.last_update%TYPE,
        cpi_rec_no          GICL_RECOVERY_RIDS.cpi_rec_no%TYPE,
        cpi_branch_cd       GICL_RECOVERY_RIDS.cpi_branch_cd%TYPE,
        ri_name             GIIS_REINSURER.ri_name%TYPE
    ); 
    
    TYPE gicls270_dist_rids_tab IS TABLE OF gicls270_dist_rids_type;
    
    FUNCTION populate_gicls270(
        P_USER_ID           VARCHAR2
    )
        RETURN gicls270_tab PIPELINED;
        
    FUNCTION populate_payment_det(
        P_RECOVERY_ID       GICL_RECOVERY_PAYT.recovery_id%TYPE
    )
        RETURN gicls270_payment_det_tab PIPELINED;
        
    FUNCTION populate_distribution_ds(
        P_RECOVERY_ID       GICL_RECOVERY_PAYT.recovery_id%TYPE,
        P_RECOVERY_PAYT_ID  GICL_RECOVERY_PAYT.recovery_payt_id%TYPE
    )    
        RETURN gicls270_distribution_ds_tab PIPELINED;
        
    FUNCTION populate_distribution_rids(
        P_RECOVERY_ID       GICL_RECOVERY_RIDS.recovery_id%TYPE,
        P_RECOVERY_PAYT_ID  GICL_RECOVERY_RIDS.recovery_payt_id%TYPE,
        P_REC_DIST_NO       GICL_RECOVERY_RIDS.rec_dist_no%TYPE,
        P_GRP_SEQ_NO        GICL_RECOVERY_RIDS.grp_seq_no%TYPE
    )    
        RETURN gicls270_dist_rids_tab PIPELINED;
END;
/


