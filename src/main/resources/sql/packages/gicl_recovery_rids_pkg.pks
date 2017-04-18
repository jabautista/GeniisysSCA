CREATE OR REPLACE PACKAGE CPI.GICL_RECOVERY_RIDS_PKG AS

    TYPE gicl_recovery_rids_type IS RECORD (
        recovery_id                 GICL_RECOVERY_RIDS.recovery_id%TYPE,
        recovery_payt_id            GICL_RECOVERY_RIDS.recovery_payt_id%TYPE,
        rec_dist_no                 GICL_RECOVERY_RIDS.rec_dist_no%TYPE,
        line_cd                     GICL_RECOVERY_RIDS.line_cd%TYPE,
        grp_seq_no                  GICL_RECOVERY_RIDS.grp_seq_no%TYPE,
        dist_year                   GICL_RECOVERY_RIDS.dist_year%TYPE,
        share_type                  GICL_RECOVERY_RIDS.share_type%TYPE,
        acct_trty_type              GICL_RECOVERY_RIDS.acct_trty_type%TYPE,
        ri_cd                       GICL_RECOVERY_RIDS.ri_cd%TYPE,
        share_ri_pct                GICL_RECOVERY_RIDS.share_ri_pct%TYPE,
        shr_ri_recovery_amt         GICL_RECOVERY_RIDS.shr_ri_recovery_amt%TYPE,
        share_ri_pct_real           GICL_RECOVERY_RIDS.share_ri_pct_real%TYPE,
        negate_tag                  GICL_RECOVERY_RIDS.negate_tag%TYPE,
        negate_date                 GICL_RECOVERY_RIDS.negate_date%TYPE,
        
        dsp_ri_name                 GIIS_REINSURER.ri_name%TYPE      
    );
    
    TYPE gicl_recovery_rids_tab IS TABLE OF gicl_recovery_rids_type;
    
    TYPE recovery_type IS RECORD(
        ri_cd                   GICL_RECOVERY_RIDS.ri_cd%TYPE,
        shr_ri_recovery_amt     GICL_RECOVERY_RIDS.shr_ri_recovery_amt%TYPE,
        shr_recovery_amt        GICL_RECOVERY_DS.shr_recovery_amt%TYPE,
        recovered_amt           GICL_CLM_RECOVERY.recovered_amt%TYPE,
        grp_seq_no              GICL_RECOVERY_RIDS.grp_seq_no%TYPE,
        share_type              GICL_RECOVERY_RIDS.share_type%TYPE
    );
    TYPE recovery_tab IS TABLE OF recovery_type;
	
	TYPE gicl_recovery_ri_dist_type IS RECORD(
		recovery_id                 gicl_clm_recovery.recovery_id%TYPE,
        recovery_payt_id            NUMBER,
		rec_dist_no                 NUMBER,
		dsp_line_cd                 gicl_clm_recovery.line_cd%TYPE,
		dist_year                   NUMBER,
		grp_seq_no                  NUMBER,
		acct_trty_type              NUMBER,
        share_type                  VARCHAR2(1),
		ri_cd						NUMBER,
		dsp_ri_name					VARCHAR2(200),
		share_ri_pct				NUMBER,
		share_ri_pct_real			NUMBER,
		shr_ri_recovery_amt       	NUMBER,
		negate_tag                  VARCHAR(1),
        negate_date                 VARCHAR2(20)
	);
	
	TYPE gicl_recovery_ri_dist_tab IS TABLE OF gicl_recovery_ri_dist_type;
    
    FUNCTION get_recovery_rids (
        p_recovery_id             GICL_RECOVERY_RIDS.recovery_id%TYPE,
        p_recovery_payt_id        GICL_RECOVERY_RIDS.recovery_payt_id%TYPE,
        p_rec_dist_no             GICL_RECOVERY_RIDS.rec_dist_no%TYPE, 
        p_grp_seq_no              GICL_RECOVERY_RIDS.grp_seq_no%TYPE            
    ) RETURN gicl_recovery_rids_tab PIPELINED;

    FUNCTION get_gicl_recovery_rids (
        p_recovery_id               GICL_RECOVERY_RIDS.recovery_id%TYPE,
        p_recovery_payt_id          GICL_RECOVERY_RIDS.recovery_payt_id%TYPE,
        p_rec_dist_no               GICL_RECOVERY_RIDS.rec_dist_no%TYPE,
        p_grp_seq_no                GICL_RECOVERY_RIDS.grp_seq_no%TYPE           
        ) 
    RETURN gicl_recovery_rids_tab PIPELINED;
    
    FUNCTION get_fla_recovery(
        p_claim_id              GICL_ADVS_FLA.claim_id%TYPE,
        p_adv_fla_id            GICL_ADVS_FLA.adv_fla_id%TYPE
    )
    RETURN recovery_tab PIPELINED;
	
	FUNCTION get_recovery_ri_dist (
		p_recovery_id		gicl_recovery_rids.recovery_id%TYPE,
		p_recovery_payt_id	gicl_recovery_rids.recovery_payt_id%TYPE,
		p_rec_dist_no		gicl_recovery_rids.rec_dist_no%TYPE,
		p_grp_seq_no		gicl_recovery_rids.grp_seq_no%TYPE
	)
 	RETURN gicl_recovery_ri_dist_tab PIPELINED;
    
    PROCEDURE upd_ridist_recovery (
		p_recovery_id           gicl_recovery_rids.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_rids.recovery_payt_id%TYPE,
        p_rec_dist_no           gicl_recovery_rids.rec_dist_no%TYPE,
		p_grp_seq_no            gicl_recovery_rids.grp_seq_no%TYPE,
        p_ri_cd                 gicl_recovery_rids.ri_cd%TYPE,
        p_share_ri_pct             gicl_recovery_rids.share_ri_pct%TYPE,
		p_shr_ri_recovery_amt      gicl_recovery_rids.shr_ri_recovery_amt%TYPE
	);
    
    PROCEDURE del_ridist_recovery (
		p_recovery_id           gicl_recovery_rids.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_rids.recovery_payt_id%TYPE,
        p_rec_dist_no           gicl_recovery_rids.rec_dist_no%TYPE,
		p_grp_seq_no            gicl_recovery_rids.grp_seq_no%TYPE
    );
    
END GICL_RECOVERY_RIDS_PKG;
/


