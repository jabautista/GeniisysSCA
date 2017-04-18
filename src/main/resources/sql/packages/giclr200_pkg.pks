CREATE OR REPLACE PACKAGE CPI.GICLR200_PKG
AS

    TYPE giclr200_type IS RECORD (
        clm_cnt             gicl_os_pd_clm_extr.clm_cnt%TYPE,
        claim_id            gicl_os_pd_clm_extr.claim_id%TYPE,
        claim_no            gicl_os_pd_clm_extr.claim_no%TYPE,
        assured_name        gicl_os_pd_clm_extr.assured_name%TYPE,
        loss_loc            gicl_os_pd_clm_extr.loss_loc%TYPE,
        policy_no           gicl_os_pd_clm_extr.policy_no%TYPE,
        tsi_amt             gicl_os_pd_clm_extr.tsi_amt%TYPE,
        loss_cat_cd         gicl_os_pd_clm_extr.loss_cat_cd%TYPE,
        loss_category       giis_loss_ctgry.loss_Cat_des%TYPE,
        loss_date           gicl_os_pd_clm_extr.loss_date%TYPE,
        os_loss             gicl_os_pd_clm_extr.os_loss%TYPE,
        os_exp              gicl_os_pd_clm_extr.os_exp%TYPE,
        gross_loss          gicl_os_pd_clm_extr.gross_loss%TYPE,
        pd_loss             gicl_os_pd_clm_extr.pd_loss%TYPE,
        pd_exp              gicl_os_pd_clm_extr.pd_exp%TYPE,
        clm_stat_cd         gicl_os_pd_clm_extr.clm_stat_cd%TYPE,    
        clm_status          VARCHAR2(20),     
        line_cd             gicl_os_pd_clm_extr.line_cd%TYPE,
        line_name           giis_line.line_name%TYPE,
        iss_cd              gicl_os_pd_clm_extr.iss_cd%TYPE,
        iss_name            giis_issource.iss_name%TYPE,
        catastrophic_cd     gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        catastrophic_desc   VARCHAR2(4000),
        total_os            NUMBER(20,2),
        total_pd            NUMBER(20,2),
        company_name        giis_parameters.param_value_v%TYPE,
        company_address     giis_parameters.param_value_v%TYPE,
        cf_date             VARCHAR2(100),
        cf_title            giis_reports.report_title%TYPE
    );
    
    TYPE giclr200_tab IS TABLE OF giclr200_type;
    
    TYPE giclr200_summ_type IS RECORD (
        catastrophic_cd     gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        catastrophic_desc   VARCHAR2(4000),
        grp_seq_no          GICL_OS_PD_CLM_DS_EXTR.GRP_SEQ_NO%TYPE,
        share_type          GICL_OS_PD_CLM_DS_EXTR.SHARE_TYPE%TYPE,
        line_cd             gicl_os_pd_clm_extr.line_cd%TYPE,
        trty_name           giis_dist_share.trty_name%TYPE,
        os                  NUMBER(20,2),
        pd                  NUMBER(20,2),
        total               NUMBER(20,2)
    );
    
    TYPE giclr200_summ_tab IS TABLE OF giclr200_summ_type;
    
    FUNCTION get_report_details(
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_as_of_date    DATE
    ) RETURN giclr200_tab PIPELINED;
    
    
    FUNCTION get_report_summary(
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE        
    ) RETURN giclr200_summ_tab PIPELINED;
    
END GICLR200_PKG;
/


