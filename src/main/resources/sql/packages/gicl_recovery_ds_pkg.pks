CREATE OR REPLACE PACKAGE CPI.GICL_RECOVERY_DS_PKG AS

    TYPE gicl_recovery_ds_type IS RECORD (
        recovery_id             GICL_RECOVERY_DS.recovery_id%TYPE,
        recovery_payt_id        GICL_RECOVERY_DS.recovery_payt_id%TYPE,
        rec_dist_no             GICL_RECOVERY_DS.rec_dist_no%TYPE,
        line_cd                 GICL_RECOVERY_DS.line_cd%TYPE,
        grp_seq_no              GICL_RECOVERY_DS.grp_seq_no%TYPE,
        dist_year               GICL_RECOVERY_DS.dist_year%TYPE,
        share_type              GICL_RECOVERY_DS.share_type%TYPE,
        acct_trty_type          GICL_RECOVERY_DS.acct_trty_type%TYPE,
        share_pct               GICL_RECOVERY_DS.share_pct%TYPE,
        shr_recovery_amt        GICL_RECOVERY_DS.shr_recovery_amt%TYPE,
        negate_tag              GICL_RECOVERY_DS.negate_tag%TYPE,
        negate_date             GICL_RECOVERY_DS.negate_date%TYPE,
        
        dsp_share_name          GIIS_DIST_SHARE.trty_name%TYPE,
		dsp_line_cd				GICL_RECOVERY_DS.line_cd%TYPE
    );
    
     TYPE gicl_recovery_ds_tab IS TABLE OF gicl_recovery_ds_type;
     
     FUNCTION get_gicl_recovery_ds (
        p_recovery_id             GICL_RECOVERY_DS.recovery_id%TYPE,
        p_recovery_payt_id        GICL_RECOVERY_DS.recovery_payt_id%TYPE           
     ) RETURN gicl_recovery_ds_tab PIPELINED;

	
	FUNCTION get_recovery_distribution(
		p_recovery_id       gicl_recovery_ds.recovery_id%TYPE,
		p_recovery_payt_id   gicl_recovery_ds.recovery_payt_id%TYPE
	)   
  	  RETURN gicl_recovery_ds_tab PIPELINED; 
	
	 PROCEDURE DISTRIBUTE_RECOVERY (
		p_recovery_id           gicl_recovery_payt.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_payt.recovery_payt_id%TYPE,
		p_dsp_line_cd           gipi_polbasic.line_cd%TYPE,
		p_dsp_subline_cd        gipi_polbasic.subline_cd%TYPE,
		p_dsp_iss_cd            gipi_polbasic.iss_cd%TYPE,
		p_dsp_issue_yy          gipi_polbasic.issue_yy%TYPE,
		p_dsp_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
		p_dsp_renew_no          gipi_polbasic.renew_no%TYPE,
		p_eff_date              gipi_polbasic.eff_date%TYPE,
		p_expiry_date           gipi_polbasic.expiry_date%TYPE,
		p_loss_date             gicl_claims.loss_date%TYPE
	);
	
	PROCEDURE negate_dist_recovery (
		p_recovery_id           gicl_recovery_payt.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_payt.recovery_payt_id%TYPE
	);
    
    PROCEDURE upd_dist_recovery (
		p_recovery_id           gicl_recovery_ds.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_ds.recovery_payt_id%TYPE,
        p_rec_dist_no           gicl_recovery_ds.rec_dist_no%TYPE,
		p_grp_seq_no            gicl_recovery_ds.grp_seq_no%TYPE,
        p_share_pct             gicl_recovery_ds.share_pct%TYPE,
		p_shr_recovery_amt      gicl_recovery_ds.shr_recovery_amt%TYPE
	);
    
    PROCEDURE del_dist_recovery (
		p_recovery_id           gicl_recovery_ds.recovery_id%TYPE,
		p_recovery_payt_id      gicl_recovery_ds.recovery_payt_id%TYPE,
        p_rec_dist_no           gicl_recovery_ds.rec_dist_no%TYPE,
		p_grp_seq_no            gicl_recovery_ds.grp_seq_no%TYPE
	);
   
   PROCEDURE update_gicls054_ri_shares (
      p_recovery_id        VARCHAR2,
      p_recovery_payt_id   VARCHAR2
   );
   
END GICL_RECOVERY_DS_PKG;
/


