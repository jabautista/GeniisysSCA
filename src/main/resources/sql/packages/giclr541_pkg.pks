CREATE OR REPLACE PACKAGE CPI.GICLR541_PKG
AS
    TYPE report_type IS RECORD (
        cf_company      giis_parameters.param_value_v%TYPE,
        cf_address      giis_parameters.param_value_v%TYPE,
        cf_title        VARCHAR2(50),
        cf_date         VARCHAR2(50),
        cf_clm_amt      VARCHAR2(50),
        line_cd         gicl_claims.line_cd%TYPE,
        line_name       giis_line.line_name%TYPE,
        issource        VARCHAR2(50),
        claim_no        VARCHAR2(50),
        loss_date       VARCHAR2(24),
        clm_file_date   VARCHAR2(24),
        assd_no         gicl_claims.assd_no%TYPE,
        claim_id        gicl_claims.claim_id%TYPE,
        clm_stat_cd     gicl_claims.clm_stat_cd%TYPE,
        v_print         VARCHAR2(8),
        peril_cd        gicl_item_peril.peril_cd%TYPE,
        peril_sname     giis_peril.peril_sname%TYPE,
        claim_id2       gicl_item_peril.claim_id%TYPE,
        line_cd2        giis_peril.line_cd%TYPE,
        retention       gicl_reserve_ds.shr_loss_res_amt%TYPE,
        loss_amount     gicl_clm_res_hist.loss_reserve%TYPE,
        treaty          gicl_reserve_ds.shr_loss_res_amt%TYPE,
        facultative     gicl_reserve_ds.shr_loss_res_amt%TYPE,
        xol             gicl_reserve_ds.shr_loss_res_amt%TYPE        
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION get_main_report(
        p_start_dt  VARCHAR2,
        p_end_dt    VARCHAR2,
        p_line_cd   VARCHAR2,
        p_branch_cd VARCHAR2,
        p_iss_cd    VARCHAR2,
        p_loss_exp  VARCHAR2,
        p_user_id   VARCHAR2
    )
      RETURN report_tab PIPELINED;

    FUNCTION get_detail_report(
        p_start_dt  VARCHAR2,
        p_end_dt    VARCHAR2,
        p_line_cd   VARCHAR2,
        p_branch_cd VARCHAR2,
        p_iss_cd    VARCHAR2,
        p_loss_exp  VARCHAR2,
        p_user_id   VARCHAR2
    )      
        RETURN report_tab PIPELINED;
                        
END GICLR541_PKG;
/


