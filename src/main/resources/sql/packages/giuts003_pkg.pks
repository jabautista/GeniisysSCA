CREATE OR REPLACE PACKAGE CPI.GIUTS003_PKG
    /*
    **  Created by        : bonok
    **  Date Created      : 02.21.2013
    **  Reference By      : GIUTS003 - SPOIL POLICY/ENDORSEMENT
    */
AS
    TYPE when_new_form_giuts003_type IS RECORD(
        allow_spoilage        giac_parameters.param_value_v%TYPE,
        clm_stat_cancel        giis_parameters.param_value_v%TYPE,
        require_reason        giis_parameters.param_value_v%TYPE
    );
    
    TYPE when_new_form_giuts003_tab IS TABLE OF when_new_form_giuts003_type;
    
    FUNCTION when_new_form_giuts003
    RETURN when_new_form_giuts003_tab PIPELINED;
    
    TYPE get_policy_giuts003_lov_type IS RECORD(
        policy_id           gipi_polbasic.policy_id%TYPE,
        policy_no           VARCHAR2(50),
        endt_no             VARCHAR2(50),
        assd_name           giis_assured.assd_name%TYPE,
        line_cd             gipi_polbasic.line_cd%TYPE,
        subline_cd          gipi_polbasic.subline_cd%TYPE,
        iss_cd              gipi_polbasic.iss_cd%TYPE,
        issue_yy            gipi_polbasic.issue_yy%TYPE,
        pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
        renew_no            gipi_polbasic.renew_no%TYPE,
        acct_ent_date       gipi_polbasic.acct_ent_date%TYPE,
        eff_date            gipi_polbasic.eff_date%TYPE,
        expiry_date         gipi_polbasic.expiry_date%TYPE,
        spld_flag           gipi_polbasic.spld_flag%TYPE,
        spld_user_id        gipi_polbasic.spld_user_id%TYPE,
        spld_date           gipi_polbasic.spld_date%TYPE,
        policy_status       VARCHAR2(150),
        spld_approval       gipi_polbasic.spld_approval%TYPE,
        endt_seq_no         gipi_polbasic.endt_seq_no%TYPE,
        spoil_cd            gipi_polbasic.spoil_cd%TYPE,
        spoil_desc          giis_spoilage_reason.spoil_desc%TYPE,
        pol_flag            gipi_polbasic.pol_flag%TYPE,
        endt_expiry_date    gipi_polbasic.endt_expiry_date%TYPE,
        prorate_flag        gipi_polbasic.prorate_flag%TYPE,
        comp_sw             gipi_polbasic.comp_sw%TYPE,
        short_rt_percent    gipi_polbasic.short_rt_percent%TYPE
    );
    
    TYPE get_policy_giuts003_lov_tab IS TABLE OF get_policy_giuts003_lov_type;
    
    FUNCTION get_policy_giuts003_lov(
        p_line_cd           gipi_polbasic.line_cd%TYPE,
        p_subline_cd        gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          gipi_polbasic.renew_no%TYPE,
        p_user_id            giis_users.user_id%TYPE --added by reymon 05062013
    ) RETURN get_policy_giuts003_lov_tab PIPELINED;
    
    TYPE get_spoil_cd_giuts003_lov_type IS RECORD(
        spoil_cd            giis_spoilage_reason.spoil_cd%TYPE,
        spoil_desc            giis_spoilage_reason.spoil_desc%TYPE
    );
    
    TYPE get_spoil_cd_giuts003_lov_tab IS TABLE OF get_spoil_cd_giuts003_lov_type;
    
    FUNCTION get_spoil_cd_giuts003_lov
    RETURN get_spoil_cd_giuts003_lov_tab PIPELINED;
    
    PROCEDURE spoil_policy_giuts003(
        p_user_id           IN  gipi_polbasic.user_id%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE,
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_subline_cd        IN  gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          IN  gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        IN  gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          IN  gipi_polbasic.renew_no%TYPE,
        p_endt_seq_no       IN  gipi_polbasic.endt_seq_no%TYPE,
        p_eff_date          IN  gipi_polbasic.eff_date%TYPE,
        p_acct_ent_date     IN  gipi_polbasic.acct_ent_date%TYPE,
        p_spld_flag         IN OUT gipi_polbasic.spld_flag%TYPE,
        p_spoil_cd          IN  gipi_polbasic.spoil_cd%TYPE,
        p_require_reason    IN  giis_parameters.param_value_v%TYPE,
        p_pol_flag          IN  gipi_polbasic.pol_flag%TYPE,
        p_message           OUT VARCHAR2,
        p_cont              OUT VARCHAR2,
        p_policy_status     OUT VARCHAR2,
        p_spld_user_id      OUT gipi_polbasic.spld_user_id%TYPE,
        p_spld_date         OUT VARCHAR2
        
    );
    
    PROCEDURE check_paid_policy(
        p_policy_id         gipi_polbasic.policy_id%TYPE,
        p_line_cd           gipi_polbasic.line_cd%TYPE,
        p_iss_cd            gipi_polbasic.iss_cd%TYPE
    );
    
    PROCEDURE check_reinsurance_payment(
        p_policy_id         gipi_polbasic.policy_id%TYPE,
        p_line_cd           gipi_polbasic.line_cd%TYPE
    );
    
    PROCEDURE check_mrn(
        p_line_cd           gipi_polbasic.line_cd%TYPE,
        p_subline_cd        gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          gipi_polbasic.renew_no%TYPE
    );
    
    PROCEDURE check_endorsement(
        p_line_cd           gipi_polbasic.line_cd%TYPE,
        p_subline_cd        gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          gipi_polbasic.renew_no%TYPE,
        p_pol_flag          gipi_polbasic.pol_flag%TYPE,
        p_policy_id         gipi_polbasic.policy_id%TYPE,
        p_endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
        p_eff_date          gipi_polbasic.eff_date%TYPE
    );
    
    PROCEDURE unspoil_policy_giuts003(
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_spld_flag         IN  gipi_polbasic.spld_flag%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE,
        p_policy_status     OUT VARCHAR2
    );
    
        PROCEDURE post_policy_giuts003(
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_subline_cd        IN  gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          IN  gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        IN  gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          IN  gipi_polbasic.renew_no%TYPE,
        p_eff_date          IN  gipi_polbasic.eff_date%TYPE,
        p_acct_ent_date     IN  gipi_polbasic.acct_ent_date%TYPE,
        p_spld_flag         IN OUT gipi_polbasic.spld_flag%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE,
        p_endt_expiry_date  IN  gipi_polbasic.endt_expiry_date%TYPE,
        p_prorate_flag      IN  gipi_polbasic.prorate_flag%TYPE,
        p_comp_sw           IN  gipi_polbasic.comp_sw%TYPE,
        p_short_rt_percent  IN  gipi_polbasic.short_rt_percent%TYPE,
        p_user_id           IN  gipi_polbasic.user_id%TYPE,
        p_exist             OUT VARCHAR2,
        p_message           OUT VARCHAR2,
        p_cont              OUT VARCHAR2,
        p_policy_status     OUT VARCHAR2,
        p_spld_user_id      OUT gipi_polbasic.spld_user_id%TYPE,
        p_spld_date         OUT VARCHAR2,
        p_spld_approval     OUT gipi_polbasic.spld_approval%TYPE
    );
    
    PROCEDURE post_policy2_giuts003(
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_subline_cd        IN  gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          IN  gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        IN  gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          IN  gipi_polbasic.renew_no%TYPE,
        p_eff_date          IN  gipi_polbasic.eff_date%TYPE,
        p_acct_ent_date     IN  gipi_polbasic.acct_ent_date%TYPE,
        p_spld_flag         IN OUT gipi_polbasic.spld_flag%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE,
        p_endt_expiry_date  IN  gipi_polbasic.endt_expiry_date%TYPE,
        p_prorate_flag      IN  gipi_polbasic.prorate_flag%TYPE,
        p_comp_sw           IN  gipi_polbasic.comp_sw%TYPE,
        p_short_rt_percent  IN  gipi_polbasic.short_rt_percent%TYPE,
        p_user_id           IN  gipi_polbasic.user_id%TYPE,
        p_alert             IN  VARCHAR2,
        p_message           OUT VARCHAR2,
        p_cont              OUT VARCHAR2,
        p_policy_status     OUT VARCHAR2,
        p_spld_user_id      OUT gipi_polbasic.spld_user_id%TYPE,
        p_spld_date         OUT VARCHAR2,
        p_spld_approval     OUT gipi_polbasic.spld_approval%TYPE
    );
    
    PROCEDURE check_paid_policy(
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE
    );
    
    PROCEDURE check_reinsurance_payment(
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE
    );
    
    PROCEDURE check_reinsurance(
        p_dist_no           IN  NUMBER,
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE
    );
    
    PROCEDURE update_affected_endt(
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE,
        p_prorate_flag        IN  gipi_polbasic.prorate_flag%TYPE,
        p_comp_sw           IN  gipi_polbasic.comp_sw%TYPE,
        p_endt_expiry_date  IN  gipi_polbasic.endt_expiry_date%TYPE,
        p_eff_date          IN  gipi_polbasic.eff_date%TYPE,
        p_short_rt_percent  IN  gipi_polbasic.short_rt_percent%TYPE,
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_subline_cd        IN  gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          IN  gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        IN  gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          IN  gipi_polbasic.renew_no%TYPE
    );

   FUNCTION validate_spoil_cd(
      p_spoil_cd           giis_spoilage_reason.spoil_cd%TYPE
   ) RETURN VARCHAR2;       
END;
/


