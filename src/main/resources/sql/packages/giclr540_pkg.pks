CREATE OR REPLACE PACKAGE CPI.GICLR540_PKG
AS
    TYPE main_report_type IS RECORD (
        cf_company      giis_parameters.param_value_v%TYPE,
        cf_address      giis_parameters.param_value_v%TYPE,
        cf_title        VARCHAR2(50),
        cf_date         VARCHAR2(50),
        cf_clm_amt      VARCHAR2(50),
        line_cd         gicl_claims.line_cd%TYPE,
        line_name       giis_line.line_name%TYPE,
        iss_cd          gicl_claims.iss_cd%TYPE,
        claim_no        VARCHAR2(50),
        policy_no       VARCHAR2(50),
        loss_date       VARCHAR2(24),
        clm_file_date   VARCHAR2(24),
        pol_eff_date    VARCHAR2(24),
        subline_cd      gicl_claims.subline_cd%TYPE,
        pol_iss_cd      gicl_claims.pol_iss_cd%TYPE,
        issue_yy        gicl_claims.issue_yy%TYPE,
        pol_seq_no      gicl_claims.pol_seq_no%TYPE,
        renew_no        gicl_claims.renew_no%TYPE,
        assured         gicl_claims.assured_name%TYPE,
        cf_intm         VARCHAR2(1000),
        claim_id        gicl_claims.claim_id%TYPE,
        clm_stat_cd     gicl_claims.clm_stat_cd%TYPE,
        old_stat_cd     gicl_claims.old_stat_cd%TYPE,
        close_date      gicl_claims.close_date%TYPE,
        clm_stat        giis_clm_stat.clm_stat_desc%TYPE,
        v_print         VARCHAR2(8),
        peril_cd        gicl_item_peril.peril_cd%TYPE,
        peril_sname     giis_peril.peril_sname%TYPE,
        claim_id2        gicl_item_peril.claim_id%TYPE,
        line_cd2         giis_peril.line_cd%TYPE,
        exp_amount      gicl_clm_res_hist.expense_reserve%TYPE,
        exp_retention   gicl_reserve_ds.shr_loss_res_amt%TYPE,
        retention       gicl_reserve_ds.shr_loss_res_amt%TYPE,
        loss_amount     gicl_clm_res_hist.loss_reserve%TYPE,
        exp_treaty      gicl_reserve_ds.shr_loss_res_amt%TYPE,
        treaty          gicl_reserve_ds.shr_loss_res_amt%TYPE,
        exp_facultative gicl_reserve_ds.shr_loss_res_amt%TYPE,
        facultative     gicl_reserve_ds.shr_loss_res_amt%TYPE,
        exp_xol         gicl_reserve_ds.shr_loss_res_amt%TYPE,
        xol             gicl_reserve_ds.shr_loss_res_amt%TYPE        
    );
    
    TYPE main_report_tab IS TABLE OF main_report_type;
    
    TYPE peril_report_type IS RECORD(
        cf_intm         VARCHAR2(1000),
        peril_cd        gicl_item_peril.peril_cd%TYPE,
        peril_sname     giis_peril.peril_sname%TYPE,
        claim_id        gicl_item_peril.claim_id%TYPE,
        line_cd         giis_peril.line_cd%TYPE,
        exp_amount      gicl_clm_res_hist.expense_reserve%TYPE,
        exp_retention   gicl_reserve_ds.shr_loss_res_amt%TYPE,
        retention       gicl_reserve_ds.shr_loss_res_amt%TYPE,
        loss_amount     gicl_clm_res_hist.loss_reserve%TYPE,
        exp_treaty      gicl_reserve_ds.shr_loss_res_amt%TYPE,
        treaty          gicl_reserve_ds.shr_loss_res_amt%TYPE,
        exp_facultative gicl_reserve_ds.shr_loss_res_amt%TYPE,
        facultative     gicl_reserve_ds.shr_loss_res_amt%TYPE,
        exp_xol         gicl_reserve_ds.shr_loss_res_amt%TYPE,
        xol             gicl_reserve_ds.shr_loss_res_amt%TYPE
    );
    
    TYPE peril_report_tab IS TABLE OF peril_report_type;
    
    FUNCTION get_main_report(
        p_start_dt  VARCHAR2,
        p_end_dt    VARCHAR2,
        p_line_cd   VARCHAR2,
        p_branch_cd VARCHAR2,
        p_iss_cd    VARCHAR2,
        p_loss_exp  VARCHAR2,
        p_user_id   VARCHAR2
    )
      RETURN main_report_tab PIPELINED;
      
    FUNCTION get_detail_report(
        p_claim_id    gicl_claims.claim_id%TYPE,
        p_line_cd     giis_line.line_cd%TYPE,
        p_loss_exp    VARCHAR2,
        p_clm_stat_cd gicl_claims.clm_stat_cd%TYPE
    )      
      RETURN peril_report_tab PIPELINED;

    FUNCTION get_line_totals(
        p_start_dt  VARCHAR2,
        p_end_dt    VARCHAR2,
        p_line_cd   VARCHAR2,
        p_branch_cd VARCHAR2,
        p_iss_cd    VARCHAR2,
        p_loss_exp  VARCHAR2,
        p_user_id   VARCHAR2
    )
      RETURN main_report_tab PIPELINED;
                
END GICLR540_PKG;
/


