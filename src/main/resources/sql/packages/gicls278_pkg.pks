CREATE OR REPLACE PACKAGE CPI.GICLS278_PKG
AS
    
    TYPE gicls278_policy_type IS RECORD(
        policy_no       VARCHAR2(25),
        line_cd         gicl_claims.line_cd%TYPE,
        subline_cd      gicl_claims.subline_cd%TYPE,
        pol_iss_cd      gicl_claims.pol_iss_cd%TYPE,
        iss_cd          gicl_claims.iss_cd%TYPE,
        issue_yy        gicl_claims.issue_yy%TYPE,
        pol_seq_no      gicl_claims.pol_seq_no%TYPE,
        renew_no        gicl_claims.renew_no%TYPE,
        assd_no         giis_assured.assd_no%TYPE,
        assd_name       giis_assured.assd_name%TYPE
    );
    TYPE gicls278_policy_tab IS TABLE OF gicls278_policy_type;

    TYPE claims_with_enrollees_type IS RECORD(
        claim_id        gicl_claims.claim_id%TYPE,
        claim_no        VARCHAR2(100),
        line_cd         gicl_claims.line_cd%TYPE,
        subline_cd      gicl_claims.subline_cd%TYPE,
        iss_cd          gicl_claims.iss_cd%TYPE,
        clm_yy          gicl_claims.clm_yy%TYPE,
        clm_seq_no      gicl_claims.clm_seq_no%TYPE,
        enrollee        VARCHAR2(200),
        loss_res_amt    gicl_claims.loss_res_amt%TYPE,
        loss_pd_amt     gicl_claims.loss_pd_amt%TYPE,
        exp_res_amt     gicl_claims.exp_res_amt%TYPE,
        exp_pd_amt      gicl_claims.exp_pd_amt%TYPE,
        clm_stat_cd     gicl_claims.clm_stat_cd%TYPE,
        claim_status    giis_clm_stat.clm_stat_desc%TYPE,
        entry_date      VARCHAR2(10),
        loss_date       VARCHAR2(10),
        file_date       VARCHAR2(10),
        clm_recovery    VARCHAR2(1),
        tot_loss_res    gicl_claims.loss_res_amt%TYPE,
        tot_loss_pd     gicl_claims.loss_pd_amt%TYPE,
        tot_exp_res     gicl_claims.exp_res_amt%TYPE,
        tot_exp_pd      gicl_claims.exp_pd_amt%TYPE
    );
    TYPE claims_with_enrollees_tab IS TABLE OF claims_with_enrollees_type;
    
    TYPE line_lov_type IS RECORD(
        line_cd         giis_line.line_cd%TYPE,
        line_name       giis_line.line_name%TYPE
    );
    TYPE line_lov_tab IS TABLE OF line_lov_type;
    
    TYPE subline_lov_type IS RECORD(
        subline_cd      giis_subline.subline_cd%TYPE,
        subline_name    giis_subline.subline_name%TYPE
    );
    TYPE subline_lov_tab IS TABLE OF subline_lov_type;
    
    TYPE issource_lov_type IS RECORD(
        iss_cd          giis_issource.iss_cd%TYPE,
        iss_name        giis_issource.iss_name%TYPE
    );
    TYPE issource_lov_tab IS TABLE OF issource_lov_type;
    
    TYPE issue_yy_lov_type IS RECORD(
        issue_yy        gicl_claims.issue_yy%TYPE
    );
    TYPE issue_yy_lov_tab IS TABLE OF issue_yy_lov_type;
    
    FUNCTION validate_entry(
        p_line_cd       gicl_claims.line_cd%TYPE,
        p_subline_cd    gicl_claims.subline_cd%TYPE,
        p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy      gicl_claims.issue_yy%TYPE,
        p_pol_seq_no    gicl_claims.pol_seq_no%TYPE,
        p_renew_no      gicl_claims.renew_no%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN VARCHAR2;
    
    FUNCTION get_gicls278_policy(
        p_line_cd       gicl_claims.line_cd%TYPE,
        p_subline_cd    gicl_claims.subline_cd%TYPE,
        p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy      gicl_claims.issue_yy%TYPE,
        p_pol_seq_no    gicl_claims.pol_seq_no%TYPE,
        p_renew_no      gicl_claims.renew_no%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN gicls278_policy_tab PIPELINED;
    
    FUNCTION get_claims_with_enrollees(
        p_line_cd       gicl_claims.line_cd%TYPE,
        p_subline_cd    gicl_claims.subline_cd%TYPE,
        p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy      gicl_claims.issue_yy%TYPE,
        p_pol_seq_no    gicl_claims.pol_seq_no%TYPE,
        p_renew_no      gicl_claims.renew_no%TYPE,
        p_date_type     VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_module_id     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN claims_with_enrollees_tab PIPELINED;
      
    FUNCTION validate_gicls278_line_cd(
        p_line_cd       gicl_claims.line_cd%TYPE
    )
      RETURN VARCHAR2;
      
    FUNCTION validate_gicls278_subline_cd(
        p_subline_cd    gicl_claims.subline_cd%TYPE
    )
      RETURN VARCHAR2;
      
    FUNCTION validate_gicls278_pol_iss_cd(
        p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE
    )
      RETURN VARCHAR2;
      
    FUNCTION validate_gicls278_issue_yy(
        p_issue_yy      gicl_claims.issue_yy%TYPE
    )
      RETURN VARCHAR2;  
    
    FUNCTION get_line_lov(
       p_find_text      VARCHAR2,
       p_module_id      giis_modules.module_id%TYPE,
       p_user_id        giis_users.user_id%TYPE
    )
      RETURN line_lov_tab PIPELINED;
      
    FUNCTION get_subline_lov(
       p_line_cd        giis_subline.line_cd%TYPE,
       p_find_text      VARCHAR2,
       p_module_id      giis_modules.module_id%TYPE
    )
      RETURN subline_lov_tab PIPELINED;
      
    FUNCTION get_issource_lov(
       p_line_cd        giis_subline.line_cd%TYPE,
       p_subline_cd     giis_subline.subline_cd%TYPE,
       p_find_text      VARCHAR2,
       p_module_id      giis_modules.module_id%TYPE,
       p_user_id        giis_users.user_id%TYPE
    )
      RETURN issource_lov_tab PIPELINED;
      
    FUNCTION get_issue_yy_lov(
       p_line_cd        giis_subline.line_cd%TYPE,
       p_subline_cd     giis_subline.subline_cd%TYPE,
       p_find_text      VARCHAR2
    )
      RETURN issue_yy_lov_tab PIPELINED;
      
END GICLS278_PKG;
/


