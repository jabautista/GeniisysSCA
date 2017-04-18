CREATE OR REPLACE PACKAGE CPI.GICL_RECOVERY_PAYT_PKG AS

    TYPE gicl_recovery_payt_type IS RECORD (
        recovery_id             GICL_RECOVERY_PAYT.recovery_id%TYPE,
        recovery_payt_id        GICL_RECOVERY_PAYT.recovery_payt_id%TYPE,
        claim_id                GICL_RECOVERY_PAYT.claim_id%TYPE,
        payor_class_cd          GICL_RECOVERY_PAYT.payor_class_cd%TYPE,
        payor_cd                GICL_RECOVERY_PAYT.payor_cd%TYPE,
        recovered_amt           GICL_RECOVERY_PAYT.recovered_amt%TYPE,
        acct_tran_id            GICL_RECOVERY_PAYT.acct_tran_id%TYPE,
        tran_date               GICL_RECOVERY_PAYT.tran_date%TYPE,
        cancel_tag              GICL_RECOVERY_PAYT.cancel_tag%TYPE,
        cancel_date             GICL_RECOVERY_PAYT.cancel_date%TYPE,
        entry_tag               GICL_RECOVERY_PAYT.entry_tag%TYPE,
        dist_sw                 GICL_RECOVERY_PAYT.dist_sw%TYPE,
        acct_tran_id2           GICL_RECOVERY_PAYT.acct_tran_id2%TYPE,
        tran_date2              GICL_RECOVERY_PAYT.tran_date2%TYPE,
        recovery_acct_id        GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        stat_sw                 GICL_RECOVERY_PAYT.stat_sw%TYPE,
        
        dsp_line_cd             GICL_CLM_RECOVERY.line_cd%TYPE,
        dsp_iss_cd              GICL_CLM_RECOVERY.iss_cd%TYPE,
        dsp_rec_year            GICL_CLM_RECOVERY.rec_year%TYPE,
        dsp_rec_seq_no          GICL_CLM_RECOVERY.rec_seq_no%TYPE,
        dsp_line_cd2            GICL_CLAIMS.line_cd%TYPE,
        dsp_subline_cd1         GICL_CLAIMS.subline_cd%TYPE,    
        dsp_iss_cd1             GICL_CLAIMS.iss_cd%TYPE,
        dsp_clm_yy              GICL_CLAIMS.clm_yy%TYPE,
        dsp_clm_seq_no          GICL_CLAIMS.clm_seq_no%TYPE,
        dsp_pol_iss_cd          GICL_CLAIMS.pol_iss_cd%TYPE,
        dsp_issue_yy            GICL_CLAIMS.issue_yy%TYPE,
        dsp_pol_seq_no          GICL_CLAIMS.pol_seq_no%TYPE,
        dsp_renew_no            GICL_CLAIMS.renew_no%TYPE,
        
        dsp_recovery_no         VARCHAR2(50),
        dsp_payor_name          VARCHAR2(600), -- changed by robert from 300 to 600 11.15.2013
        dsp_assured_name        GICL_CLAIMS.assured_name%TYPE,
        dsp_ref_no              VARCHAR2(50),
        dsp_claim_no            VARCHAR2(50),
        dsp_policy_no           VARCHAR2(50),
        dsp_loss_date           VARCHAR2(30),
        dsp_loss_ctgry          GIIS_LOSS_CTGRY.loss_cat_des%TYPE,
        dsp_clm_stat_cd         GICL_CLAIMS.clm_stat_cd%TYPE,
        dsp_in_hou_adj          GICL_CLAIMS.in_hou_adj%TYPE,
        acct_exists             VARCHAR2(2),
        tran_flag               GIAC_ACCTRANS.tran_flag%TYPE
    );
    
    TYPE gicl_recovery_payt_tab IS TABLE OF gicl_recovery_payt_type;
    
    FUNCTION get_gicl_recovery_payt_list ( 
        p_claim_id              GICL_CLAIMS.claim_id%TYPE,
        p_recovery_acct_id      GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        p_module_id             VARCHAR2,
        p_user_id               GIIS_USERS.user_id%TYPE --marco - 08.07.2014
    ) RETURN gicl_recovery_payt_tab PIPELINED;
    
/*    FUNCTION get_gicl_recovery_payt_list1 ( 
        p_claim_id              GICL_CLAIMS.claim_id%TYPE,
        p_recovery_acct_id      GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        p_module_id             VARCHAR2
    ) RETURN gicl_recovery_payt_tab PIPELINED;*/
    
    PROCEDURE cancel_recovery_payt (
        p_recovery_acct_id      IN GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        p_acct_tran_id          IN VARCHAR2,
        p_user_id               IN GIIS_USERS.user_id%TYPE,
        p_message               OUT VARCHAR2
    );
    
    PROCEDURE update_recovery_for_post (
        p_recovery_acct_id      GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        p_acct_tran_id          GICL_RECOVERY_PAYT.acct_tran_id%TYPE
    );
    
    FUNCTION get_gicl_recovery_payt_list1 ( 
        p_claim_id              GICL_CLAIMS.claim_id%TYPE,
        p_recovery_acct_id      GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        p_module_id             VARCHAR2,
        p_user_id               GIIS_USERS.user_id%TYPE --marco - 08.07.2014
    ) RETURN gicl_recovery_payt_tab PIPELINED;
    
    PROCEDURE update_generated_rec_payt (
        p_recovery_id             GICL_RECOVERY_PAYT.recovery_id%TYPE,
        p_recovery_payt_id        GICL_RECOVERY_PAYT.recovery_payt_id%TYPE,
        p_recovery_acct_id        GICL_RECOVERY_PAYT.recovery_acct_id%TYPE
    );

    PROCEDURE check_recover_valid_payt(
        p_claim_id                  gicl_recovery_payt.claim_id%TYPE,
        p_recovery_id               gicl_recovery_payt.recovery_id%TYPE,
        p_check_valid        OUT    NUMBER,
        p_check_all          OUT    NUMBER
        );
        
    TYPE gicl_recovery_payt_type2 IS RECORD (
        recovery_id             GICL_RECOVERY_PAYT.recovery_id%TYPE,
        recovery_payt_id        GICL_RECOVERY_PAYT.recovery_payt_id%TYPE,
        claim_id                GICL_RECOVERY_PAYT.claim_id%TYPE,
        payor_class_cd          GICL_RECOVERY_PAYT.payor_class_cd%TYPE,
        payor_cd                GICL_RECOVERY_PAYT.payor_cd%TYPE,
        recovered_amt           GICL_RECOVERY_PAYT.recovered_amt%TYPE,
        acct_tran_id            GICL_RECOVERY_PAYT.acct_tran_id%TYPE,
        tran_date               GICL_RECOVERY_PAYT.tran_date%TYPE,
        cancel_tag              GICL_RECOVERY_PAYT.cancel_tag%TYPE,
        cancel_date             GICL_RECOVERY_PAYT.cancel_date%TYPE,
        entry_tag               GICL_RECOVERY_PAYT.entry_tag%TYPE,
        dist_sw                 GICL_RECOVERY_PAYT.dist_sw%TYPE,
        acct_tran_id2           GICL_RECOVERY_PAYT.acct_tran_id2%TYPE,
        tran_date2              GICL_RECOVERY_PAYT.tran_date2%TYPE,
        recovery_acct_id        GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        stat_sw                 GICL_RECOVERY_PAYT.stat_sw%TYPE,
        user_id                 GICL_RECOVERY_PAYT.user_id%TYPE,
        last_update             GICL_RECOVERY_PAYT.last_update%TYPE,
        cpi_rec_no              GICL_RECOVERY_PAYT.cpi_rec_no%TYPE,
        cpi_branch_cd           GICL_RECOVERY_PAYT.cpi_branch_cd%TYPE,
        dsp_payor_name          VARCHAR2(3200),
        dsp_ref_cd              VARCHAR2(3200),
        dsp_check_cancel        VARCHAR2(1),
        dsp_check_dist          VARCHAR2(1),
        sdf_tran_date           VARCHAR2(20)
        );
        
    TYPE gicl_recovery_payt_tab2 IS TABLE OF gicl_recovery_payt_type2;                     
    
    FUNCTION get_gicl_recovery_payt ( 
        p_claim_id              GICL_CLAIMS.claim_id%TYPE,
        p_recovery_id           GICL_RECOVERY_PAYT.recovery_acct_id%TYPE 
    ) RETURN gicl_recovery_payt_tab2 PIPELINED;
	
	FUNCTION get_gicl_recovery_payt2 ( 
        p_claim_id              GICL_CLAIMS.claim_id%TYPE,
        p_recovery_id           GICL_RECOVERY_PAYT.recovery_acct_id%TYPE 
    ) RETURN gicl_recovery_payt_tab2 PIPELINED;  
    
END GICL_RECOVERY_PAYT_PKG;
/


