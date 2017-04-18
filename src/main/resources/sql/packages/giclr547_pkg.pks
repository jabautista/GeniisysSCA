CREATE OR REPLACE PACKAGE CPI.GICLR547_PKG
AS
    TYPE report_type IS RECORD (
        cf_company          giis_parameters.param_value_v%TYPE,
        cf_address          giis_parameters.param_value_v%TYPE,
        cf_title            VARCHAR2(50),
        cf_date             VARCHAR2(50),
        cf_clm_amt          VARCHAR2(50),
        cf_intm             VARCHAR2(1000),
        clm_stat_cd         gicl_claims.clm_stat_cd%TYPE,
        clm_stat_desc       giis_clm_stat.clm_stat_desc%TYPE,
        claim_id            gicl_claims.claim_id%TYPE,
        claim_no            VARCHAR2(50),
        policy_no           VARCHAR2(50),
        assured             gicl_claims.assured_name%TYPE,
        intm_no             gicl_claims.intm_no%TYPE,
        pol_iss_cd          gicl_claims.pol_iss_cd%TYPE,
        pol_eff_date        VARCHAR2(24),
        loss_date           VARCHAR2(24),
        clm_file_date       VARCHAR2(24),
        grouped_item_title  gicl_accident_dtl.grouped_item_title%TYPE,
        control_cd          gicl_accident_dtl.control_cd%TYPE,
        control_type_cd     gicl_accident_dtl.control_type_cd%TYPE,
        item_no             gicl_accident_dtl.item_no%TYPE,
        v_print             VARCHAR2(8),
        peril_cd            gicl_item_peril.peril_cd%TYPE,
        peril_name          giis_peril.peril_name%TYPE,
        claim_id2           gicl_item_peril.claim_id%TYPE,
        exp_amount          gicl_clm_res_hist.expense_reserve%TYPE,
        exp_retention       gicl_reserve_ds.shr_loss_res_amt%TYPE,
        retention           gicl_reserve_ds.shr_loss_res_amt%TYPE,
        loss_amount         gicl_clm_res_hist.loss_reserve%TYPE,
        exp_treaty          gicl_reserve_ds.shr_loss_res_amt%TYPE,
        treaty              gicl_reserve_ds.shr_loss_res_amt%TYPE,
        exp_facultative     gicl_reserve_ds.shr_loss_res_amt%TYPE,
        facultative         gicl_reserve_ds.shr_loss_res_amt%TYPE,
        exp_xol             gicl_reserve_ds.shr_loss_res_amt%TYPE,
        xol                 gicl_reserve_ds.shr_loss_res_amt%TYPE        
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION get_main_report(
        p_start_dt           VARCHAR2,
        p_end_dt             VARCHAR2,
        p_grouped_item_title VARCHAR2,
        p_control_cd         VARCHAR2,
        p_control_type_cd    gicl_accident_dtl.control_type_cd%TYPE,
        p_loss_exp           VARCHAR2,
        p_user_id            VARCHAR2
    )
      RETURN report_tab PIPELINED;
      
    FUNCTION get_detail_report(
        p_claim_id    gicl_claims.claim_id%TYPE,
        p_item_no     gicl_accident_dtl.item_no%TYPE,
        p_loss_exp    VARCHAR2,
        p_clm_stat_cd gicl_claims.clm_stat_cd%TYPE
    )      
      RETURN report_tab PIPELINED;

    FUNCTION get_totals(
        p_start_dt           VARCHAR2,
        p_end_dt             VARCHAR2,
        p_grouped_item_title VARCHAR2,
        p_control_cd         VARCHAR2,
        p_control_type_cd    gicl_accident_dtl.control_type_cd%TYPE,
        p_loss_exp           VARCHAR2,
        p_user_id            VARCHAR2
    )
      RETURN report_tab PIPELINED;
                
END GICLR547_PKG;
/


