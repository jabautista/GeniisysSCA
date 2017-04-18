CREATE OR REPLACE PACKAGE CPI.GICLS540_PKG AS

    TYPE branch_type IS RECORD(
        iss_cd       giis_issource.iss_cd%TYPE,
        iss_name     giis_issource.iss_name%TYPE,
        pol_iss_cd   giis_issource.iss_cd%TYPE
    );
   
    TYPE branch_tab IS TABLE OF branch_type;
    
    TYPE line_type IS RECORD(
        line_cd         giis_line.line_cd%TYPE,
        line_name       giis_line.line_name%TYPE,
        pol_line_cd     giis_line.line_cd%TYPE,
        pol_subline_cd  giis_subline.subline_cd%TYPE
    );
    
    TYPE line_tab IS TABLE OF line_type; 
    
    TYPE assured_type IS RECORD(
        assured_no      gicl_claims.assd_no%TYPE,
        assured_name    giis_assured.assd_name%TYPE
    );
    
    TYPE assured_tab IS TABLE OF assured_type;

    TYPE intm_type IS RECORD(
        intm_no      giis_intermediary.intm_no%TYPE,
        intm_name    giis_intermediary.intm_name%TYPE
    );
    
    TYPE intm_tab IS TABLE OF intm_type;    

    TYPE clm_stat_type IS RECORD(
        clm_stat_cd     giis_clm_stat.clm_stat_cd%TYPE,
        clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
        clm_stat_type   giis_clm_stat.clm_stat_type%TYPE
    );
    
    TYPE clm_stat_tab IS TABLE OF clm_stat_type;  
    
    FUNCTION get_rep_clm_branch_lov(
        p_line_cd       giis_line.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN branch_tab PIPELINED;

    FUNCTION get_rep_clm_line_lov(
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN line_tab PIPELINED;        

    FUNCTION get_rep_clm_assured_lov
        RETURN assured_tab PIPELINED;
        
    FUNCTION get_rep_clm_intm_lov
        RETURN intm_tab PIPELINED;                 
        
    FUNCTION get_rep_clm_stat_lov
        RETURN clm_stat_tab PIPELINED;

    FUNCTION get_rep_clm_pol_line_lov(
        p_pol_subline_cd    giis_subline.subline_cd%TYPE,
        p_pol_iss_cd       giis_issource.iss_cd%TYPE,
        p_user_id           giis_users.user_id%TYPE
    )
        RETURN line_tab PIPELINED;

    FUNCTION get_rep_clm_pol_subline_lov(
        p_pol_line_cd    giis_line.line_cd%TYPE,
        p_pol_iss_cd     giis_issource.iss_cd%TYPE
    )
        RETURN line_tab PIPELINED;        

    FUNCTION get_rep_clm_pol_iss_lov(
        p_pol_subline_cd    giis_subline.subline_cd%TYPE,
        p_pol_line_cd       giis_line.line_cd%TYPE,
        p_user_id           giis_users.user_id%TYPE
    )
        RETURN branch_tab PIPELINED;

    FUNCTION get_sub_agent(
        p_intm_no       giis_intermediary.intm_no%TYPE
    )
        RETURN NUMBER;
        
    FUNCTION AMOUNT_PER_SHARE_TYPE(
        p_claim_id     gicl_claims.claim_id%TYPE,
        p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
        p_share_type   gicl_loss_exp_ds.share_type%TYPE,
        p_loss_exp     VARCHAR2,
        p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE
    )
        RETURN NUMBER;
    
    FUNCTION get_loss_amt(
        p_claim_id     gicl_claims.claim_id%TYPE,
        p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
        p_loss_exp     VARCHAR2,
        p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE
    )
        RETURN NUMBER;
  
    FUNCTION get_amount_per_item_peril(
        p_claim_id     gicl_claims.claim_id%TYPE,
        p_item_no      gicl_loss_exp_ds.item_no%TYPE,
        p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
        p_share_type   gicl_loss_exp_ds.share_type%TYPE,
        p_loss_exp     VARCHAR2,
        p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE
    )
        RETURN NUMBER;
  
    FUNCTION get_loss_amount_per_item_peril(
        p_claim_id     gicl_claims.claim_id%TYPE,
        p_item_no      gicl_loss_exp_ds.item_no%TYPE,
        p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
        p_loss_exp     VARCHAR2,
        p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE
    )
        RETURN NUMBER;
                                                                          
END GICLS540_pkg;
/


