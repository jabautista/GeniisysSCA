CREATE OR REPLACE PACKAGE CPI.GICLS051_PKG 
AS
    TYPE claim_info_type IS RECORD (
        claim_id        GICL_CLAIMS.CLAIM_ID%TYPE,
        line_cd         GICL_CLAIMS.line_cd%TYPE,
        subline_cd      GICL_CLAIMS.subline_cd%TYPE,
        iss_cd          GICL_CLAIMS.iss_cd%TYPE,
        clm_yy          GICL_CLAIMS.clm_yy%TYPE,
        clm_seq_no      GICL_CLAIMS.clm_seq_no%TYPE,
        pol_iss_cd      GICL_CLAIMS.pol_iss_cd%TYPE,
        issue_yy        GICL_CLAIMS.issue_yy%TYPE,
        pol_seq_no      GICL_CLAIMS.pol_seq_no%TYPE,
        renew_no        GICL_CLAIMS.renew_no%TYPE,
        assured_name    GICL_CLAIMS.assured_name%TYPE,
        loss_Date       VARCHAR2(30), --GICL_CLAIMS.loss_Date%TYPE,
        in_hou_adj      GICL_CLAIMS.in_hou_adj%TYPE,
        clm_stat_cd     GICL_CLAIMS.clm_stat_cd%TYPE,
        clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,        
        loss_cat_cd     GICL_CLAIMS.loss_cat_cd%TYPE,
        loss_cat_desc   giis_loss_ctgry.loss_cat_des%TYPE
    );
    
    TYPE claim_info_tab IS TABLE OF claim_info_type;
    
    FUNCTION get_pla_listing(
        p_all_user_sw       GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         giac_user_functions.valid_tag%TYPE,
        p_user_id           giis_users.user_id%TYPE,
        p_module_id         giis_modules.module_id%TYPE,
        p_line_cd           giis_line.line_cd%TYPE
    ) RETURN claim_info_tab PIPELINED;
    
    FUNCTION get_fla_listing(
        p_all_user_sw       GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         giac_user_functions.valid_tag%TYPE,
        p_user_id           giis_users.user_id%TYPE,
        p_module_id         giis_modules.module_id%TYPE,
        p_line_cd           giis_line.line_cd%TYPE
    ) RETURN claim_info_tab PIPELINED;
    
    PROCEDURE query_count_ungen_pla(
        p_all_user_sw       IN  GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         IN  giac_user_functions.valid_tag%TYPE,
        p_module_id         IN  giis_modules.module_id%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_line_cd           IN  giis_line.line_Cd%TYPE,
        p_gen_cnt           OUT NUMBER,
        p_gen_cnt_all       OUT NUMBER
    );
    
    PROCEDURE query_count_ungen_fla(
        p_all_user_sw       IN  GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         IN  giac_user_functions.valid_tag%TYPE,
        p_module_id         IN  giis_modules.module_id%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_line_cd           IN  giis_line.line_Cd%TYPE,
        p_gen_cnt           OUT NUMBER,
        p_gen_cnt_all       OUT NUMBER
    );
    
END GICLS051_PKG;
/


