CREATE OR REPLACE PACKAGE CPI.GICLS050_PKG 
AS

    TYPE pla_type IS RECORD(
        -- c016
        pla_id                   gicl_advs_pla.pla_id%TYPE,
        claim_id                 gicl_advs_pla.claim_id%TYPE,
        grp_seq_no               gicl_advs_pla.grp_seq_no%TYPE,
        ri_cd                    gicl_advs_pla.ri_cd%TYPE,
        line_cd                  gicl_advs_pla.line_cd%TYPE,
        la_yy                    gicl_advs_pla.la_yy%TYPE,
        pla_seq_no               gicl_advs_pla.pla_seq_no%TYPE,
        loss_shr_amt             gicl_advs_pla.loss_shr_amt%TYPE,
        exp_shr_amt              gicl_advs_pla.exp_shr_amt%TYPE,
        pla_title                gicl_advs_pla.pla_title%TYPE,
        pla_header               gicl_advs_pla.pla_header%TYPE,
        pla_footer               gicl_advs_pla.pla_footer%TYPE,
        ri_sname                 giis_reinsurer.ri_sname%TYPE,
        
        subline_cd               GICL_CLAIMS.subline_cd%TYPE,
        iss_cd                   GICL_CLAIMS.iss_cd%TYPE,
        pol_iss_cd               GICL_CLAIMS.pol_iss_cd%TYPE,
        issue_yy                 GICL_CLAIMS.issue_yy%TYPE,
        pol_seq_no               GICL_CLAIMS.pol_seq_no%TYPE,
        renew_no                 GICL_CLAIMS.renew_no%TYPE,
        assured_name             GICL_CLAIMS.assured_name%TYPE,
        in_hou_adj               GICL_CLAIMS.in_hou_adj%TYPE,
        clm_yy                   GICL_CLAIMS.clm_yy%TYPE,
        clm_seq_no               GICL_CLAIMS.clm_seq_no%TYPE,
        clm_stat_cd              GICL_CLAIMS.clm_stat_cd%TYPE,
        clm_stat_desc            giis_clm_stat.clm_stat_desc%TYPE,
        policy_id                gipi_polbasic.policy_id%TYPE,
        res_pla_id               GICL_ADVS_PLA.RES_PLA_ID%TYPE,
        share_type               GICL_ADVS_PLA.share_type%TYPE,
        print_sw                 GICL_ADVS_PLA.print_sw%TYPE,
        cancel_tag               GICL_ADVS_PLA.cancel_tag%TYPE,
        pla_date                 GICL_ADVS_PLA.pla_date%TYPE,
        
        -- c017
        hist_seq_no              gicl_clm_res_hist.hist_seq_no%TYPE,
        grouped_item_no          gicl_clm_res_hist.grouped_item_no%TYPE,
        item_no                  gicl_clm_res_hist.item_no%TYPE,
        item_title               gipi_item.item_title%TYPE,
        peril_cd                 gicl_clm_res_hist.peril_cd%TYPE,
        peril_sname              giis_peril.peril_sname%TYPE,
        loss_reserve             gicl_clm_res_hist.loss_reserve%TYPE,
        expense_reserve          gicl_clm_res_hist.expense_reserve%TYPE,
       
        -- c018
        trty_name                giis_dist_share.trty_name%TYPE,
        shr_loss_res_amt         NUMBER(20,2),
        shr_exp_res_amt          NUMBER(20,2),
        shr_pct                  NUMBER(20,2)
    );
        
    TYPE pla_tab IS TABLE OF pla_type;
    
    TYPE fla_type IS RECORD (
        -- c028
        fla_id                  GICL_ADVS_FLA.fla_id%TYPE,
        claim_id                GICL_ADVS_FLA.claim_id%TYPE,
        grp_seq_no              GICL_ADVS_FLA.grp_seq_no%TYPE,
        ri_cd                   GICL_ADVS_FLA.ri_cd%TYPE,
        line_cd                 GICL_ADVS_FLA.line_cd%TYPE,
        la_yy                   GICL_ADVS_FLA.la_yy%TYPE,
        fla_seq_no              GICL_ADVS_FLA.fla_seq_no%TYPE,
        fla_date                GICL_ADVS_FLA.fla_date%TYPE,
        paid_shr_amt            GICL_ADVS_FLA.paid_shr_amt%TYPE,
        net_shr_amt             GICL_ADVS_FLA.net_shr_amt%TYPE,
        adv_shr_amt             GICL_ADVS_FLA.adv_shr_amt%TYPE,
        fla_title               GICL_ADVS_FLA.fla_title%TYPE,
        fla_header              GICL_ADVS_FLA.fla_header%TYPE,
        fla_footer              GICL_ADVS_FLA.fla_footer%TYPE,
        adv_fla_id              GICL_ADVS_FLA.adv_fla_id%TYPE,
        
        advice_id                GICL_CLM_LOSS_EXP.advice_id%TYPE,
        ri_sname                 giis_reinsurer.ri_sname%TYPE,
        subline_cd               GICL_CLAIMS.subline_cd%TYPE,
        iss_cd                   GICL_CLAIMS.iss_cd%TYPE,
        pol_iss_cd               GICL_CLAIMS.pol_iss_cd%TYPE,
        issue_yy                 GICL_CLAIMS.issue_yy%TYPE,
        pol_seq_no               GICL_CLAIMS.pol_seq_no%TYPE,
        renew_no                 GICL_CLAIMS.renew_no%TYPE,
        assured_name             GICL_CLAIMS.assured_name%TYPE,
        in_hou_adj               GICL_CLAIMS.in_hou_adj%TYPE,
        clm_yy                   GICL_CLAIMS.clm_yy%TYPE,
        clm_seq_no               GICL_CLAIMS.clm_seq_no%TYPE,
        clm_stat_cd              GICL_CLAIMS.clm_stat_cd%TYPE,
        clm_stat_desc            giis_clm_stat.clm_stat_desc%TYPE,
        share_type               GICL_ADVS_FLA.share_type%TYPE,
        print_sw                 GICL_ADVS_FLA.print_sw%TYPE,
        cancel_tag               GICL_ADVS_FLA.cancel_tag%TYPE,
        
        -- c015
        adv_line_cd              gicl_advice.line_cd%TYPE,
        adv_iss_cd               gicl_advice.iss_cd%TYPE,
        adv_advice_year          gicl_advice.advice_year%TYPE,
        adv_advice_seq_no        gicl_advice.advice_seq_no%TYPE,
        net_amt                  gicl_advice.net_amt%TYPE,
        paid_amt                 gicl_advice.paid_amt%TYPE,
        advise_amt               gicl_advice.advise_amt%TYPE,
        
        -- c029
        trty_name                giis_dist_share.trty_name%TYPE,
        shr_paid_amt             NUMBER(20,2),
        shr_net_amt              NUMBER(20,2),
        shr_advise_amt           NUMBER(20,2)
    );
    
    TYPE fla_tab IS TABLE OF fla_type;
    
    FUNCTION get_unprinted_pla_list(
        p_line_cd       giis_line.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_module_id     giis_modules.module_id%TYPE
    ) RETURN pla_tab PIPELINED;
    
    FUNCTION get_unprinted_fla_list(
        p_line_cd       giis_line.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_module_id     giis_modules.module_id%TYPE
    ) RETURN fla_tab PIPELINED;
    
    PROCEDURE query_count_pla(
        p_all_user_sw       IN  GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         IN  giac_user_functions.valid_tag%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_line_cd           IN  giis_line.line_Cd%TYPE,
        p_pla_cnt           OUT NUMBER,
        p_pla_cnt_all       OUT NUMBER
    );
    
    PROCEDURE query_count_fla(
        p_all_user_sw       IN  GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         IN  giac_user_functions.valid_tag%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_line_cd           IN  giis_line.line_Cd%TYPE,
        p_fla_cnt           OUT NUMBER,
        p_fla_cnt_all       OUT NUMBER
    );
    
    /*PROCEDURE tag_pla_as_printed(
        p_pla   gicl_advs_pla%ROWTYPE
    );*/

END GICLS050_PKG;
/


