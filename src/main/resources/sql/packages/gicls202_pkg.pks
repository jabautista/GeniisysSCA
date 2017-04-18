CREATE OR REPLACE PACKAGE cpi.GICLS202_PKG
    /*
    **  Created by        : bonok
    **  Date Created      : 03.13.2013
    **  Reference By      : GICLS202 - BORDEREAUX AND CLAIMS REGISTER
    **
    */
AS
	TYPE when_new_form_gicls202_type IS RECORD(
        ri_iss_cd           giac_parameters.param_value_v%TYPE,
        clm_loss_payee_type giac_parameters.param_value_v%TYPE,
        clm_exp_payee_type  giac_parameters.param_value_v%TYPE,
        impl_sw             giis_parameters.param_value_v%TYPE
    );
    
    TYPE when_new_form_gicls202_tab IS TABLE OF when_new_form_gicls202_type;
     
    FUNCTION when_new_form_gicls202        
    RETURN when_new_form_gicls202_tab PIPELINED;
    
    TYPE when_new_block_e010_type IS RECORD(
        rep_name            gicl_res_brdrx_extr.extr_type%TYPE,					
        brdrx_type          gicl_res_brdrx_extr.brdrx_type%TYPE, 			
        brdrx_date_option   gicl_res_brdrx_extr.ol_date_opt%TYPE,
        brdrx_option        gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
        dsp_gross_tag       gicl_res_brdrx_extr.res_tag%TYPE,			
        paid_date_option    gicl_res_brdrx_extr.pd_date_opt%TYPE, 
        per_intermediary    gicl_res_brdrx_extr.intm_tag%TYPE,
        per_issource        gicl_res_brdrx_extr.iss_cd_tag%TYPE,
        per_line_subline    gicl_res_brdrx_extr.line_cd_tag%TYPE,	
        per_loss_cat        gicl_res_brdrx_extr.loss_cat_tag%TYPE, 		
        dsp_from_date       VARCHAR2(10),
        dsp_to_date         VARCHAR2(10),
        dsp_as_of_date      VARCHAR2(10),
        branch_option       gicl_res_brdrx_extr.branch_opt%TYPE, 		
        reg_button          gicl_res_brdrx_extr.reg_date_opt%TYPE, 			
        net_rcvry_chkbx     gicl_res_brdrx_extr.net_rcvry_tag%TYPE, 	
        dsp_rcvry_from_date VARCHAR2(10),
        dsp_rcvry_to_date   VARCHAR2(10), 
        per_enrollee        gicl_res_brdrx_extr.enrollee_tag%TYPE,			
        per_policy		    gicl_res_brdrx_extr.policy_tag%TYPE,
        date_option         NUMBER,
        per_line            gicl_res_brdrx_extr.line_cd_tag%TYPE,
        per_iss             gicl_res_brdrx_extr.iss_cd_tag%TYPE,
        per_buss            gicl_res_brdrx_extr.intm_tag%TYPE,
        iss_cd              gicl_res_brdrx_extr.iss_cd%TYPE,
        line_cd             gicl_res_brdrx_extr.line_cd%TYPE,
        subline_cd          gicl_res_brdrx_extr.subline_cd%TYPE,
        intm_no             gicl_res_brdrx_extr.intm_no%TYPE,
        peril_cd            gicl_res_brdrx_extr.peril_cd%TYPE,
        loss_cat_cd         gicl_res_brdrx_extr.loss_cat_cd%TYPE,
        enrollee            gicl_res_brdrx_extr.enrollee%TYPE,
        control_type        gicl_res_brdrx_extr.control_type%TYPE,
        control_number      gicl_res_brdrx_extr.control_number%TYPE,
        pol_line_cd         gicl_res_brdrx_extr_param.pol_line_cd%TYPE,
        pol_subline_cd      gicl_res_brdrx_extr_param.pol_subline_cd%TYPE,
        pol_iss_cd          gicl_res_brdrx_extr_param.pol_iss_cd%TYPE,
        issue_yy            gicl_res_brdrx_extr_param.issue_yy%TYPE,
        pol_seq_no          gicl_res_brdrx_extr_param.pol_seq_no%TYPE,
        renew_no            gicl_res_brdrx_extr_param.renew_no%TYPE,
        as_of_date          VARCHAR2(10),
        per_buss_param      gicl_res_brdrx_extr_param.per_buss%TYPE,
        per_issource_param  gicl_res_brdrx_extr_param.per_buss%TYPE,
        per_line_subline_param   gicl_res_brdrx_extr_param.per_line_subline%TYPE,
        per_policy_param    gicl_res_brdrx_extr_param.per_policy%TYPE,
        per_enrollee_param  gicl_res_brdrx_extr_param.per_enrollee%TYPE,
        per_line_param      gicl_res_brdrx_extr_param.per_line%TYPE,
        per_branch_param    gicl_res_brdrx_extr_param.per_branch%TYPE,
        per_intm_param      gicl_res_brdrx_extr_param.per_intm%TYPE,
        per_loss_cat_param  gicl_res_brdrx_extr_param.per_loss_cat%TYPE
    );
    
    TYPE when_new_block_e010_tab IS TABLE OF when_new_block_e010_type;
    
    FUNCTION when_new_block_e010(
        p_user_id           gicl_res_brdrx_extr.user_id%TYPE
    ) RETURN when_new_block_e010_tab PIPELINED;
    
    PROCEDURE get_policy_number_gicls202(
        p_user_id           IN  gicl_res_brdrx_extr.user_id%TYPE, 
        p_dsp_line_cd2      OUT gicl_res_brdrx_extr.line_cd%TYPE,
        p_dsp_subline_cd2   OUT gicl_res_brdrx_extr.subline_cd%TYPE,
        p_dsp_iss_cd2       OUT gicl_res_brdrx_extr.iss_cd%TYPE,
        p_dsp_issue_yy      OUT gicl_res_brdrx_extr.issue_yy%TYPE,
        p_dsp_pol_seq_no    OUT gicl_res_brdrx_extr.pol_seq_no%TYPE,
        p_dsp_renew_no      OUT gicl_res_brdrx_extr.renew_no%TYPE,
        p_too_many_rows     OUT VARCHAR2
    );
    
    FUNCTION get_session_id
    RETURN NUMBER;
    
    FUNCTION get_gicl_res_brdrx_extr_count(
        p_session_id        gicl_res_brdrx_extr.session_id%TYPE
    ) RETURN NUMBER;
    
    PROCEDURE delete_data_gicls202(
        p_user_id           giis_users.user_id%TYPE  
    );
    
    PROCEDURE delete_rcvry_data_gicls202;
    
    PROCEDURE reset_record_id(
        p_brdrx_record_id         IN OUT gicl_res_brdrx_extr.brdrx_record_id%TYPE,
        p_brdrx_ds_record_id      IN OUT gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE, 
        p_brdrx_rids_record_id    IN OUT gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE
    );
    
    PROCEDURE extract_gicls202(
        p_user_id           IN giis_users.user_id%TYPE,
        p_branch_option     IN NUMBER,
        p_brdrx_date_option IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_clm_exp_payee_type IN VARCHAR2,
        p_clm_loss_payee_type IN VARCHAR2,
        p_date_option       IN NUMBER,
        p_dsp_as_of_date    IN DATE,
        p_dsp_from_date     IN DATE, --10
        p_dsp_to_date       IN DATE,
        p_dsp_line_cd2      IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd2   IN gicl_claims.subline_cd%TYPE,
        p_dsp_iss_cd2       IN gicl_claims.iss_cd%TYPE,
        p_dsp_issue_yy      IN gicl_claims.issue_yy%TYPE,
        p_dsp_pol_seq_no    IN gicl_claims.pol_seq_no%TYPE,
        p_dsp_renew_no      IN gicl_claims.renew_no%TYPE,
        p_dsp_gross_tag     IN NUMBER,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE, --20
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_loss_cat_cd   IN gicl_claims.loss_cat_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE, 
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_dsp_enrollee      IN gicl_accident_dtl.grouped_item_title%TYPE,
        p_dsp_control_type  IN gicl_accident_dtl.control_type_cd%TYPE,
        p_dsp_control_number IN gicl_accident_dtl.control_cd%TYPE,
        p_net_rcvry_chkbx   IN VARCHAR2, --30
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_enrollee      IN NUMBER, 
        p_per_intermediary  IN NUMBER,
        p_per_issource      IN NUMBER,
        p_per_line_subline  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_per_policy        IN NUMBER,
        p_reg_button        IN NUMBER,
        p_rep_name          IN NUMBER, --40
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_count             OUT NUMBER,
        p_impl_sw           OUT giis_parameters.param_value_v%TYPE
    );
    
    /*erli = EXTRACT_RESERVE_LOSS_INTM start*/
    PROCEDURE erli_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        v_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    FUNCTION get_parent_intm_gicls202(
        p_intrmdry_intm_no  giis_intermediary.intm_no%TYPE
    ) RETURN NUMBER;
    
    PROCEDURE erli_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    PROCEDURE erli_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    
    /*erl = EXTRACT_RESERVE_LOSS start*/
    PROCEDURE erl_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_brdrx_record_id   IN OUT NUMBER
    );
    
    PROCEDURE erl_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*erl = EXTRACT_RESERVE_LOSS end*/
    
    /*erei = EXTRACT_RESERVE_EXP_INTM start*/
    PROCEDURE erei_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_date_option IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_branch_option     IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    PROCEDURE erei_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_iss_break         IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_branch_option     IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    PROCEDURE erei_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*erei = EXTRACT_RESERVE_EXP_INTM end*/
    
    /*ere = EXTRACT_RESERVE_EXP start*/
    PROCEDURE ere_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_brdrx_record_id   IN OUT NUMBER
    );
    
    PROCEDURE ere_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_gross_tag     IN NUMBER,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*ere = EXTRACT_RESERVE_EXP end*/
    
    /*erlei = EXTRACT_RESERVE_LOSS_EXP_INTM start*/
    PROCEDURE erlei_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        v_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    PROCEDURE erlei_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    PROCEDURE erlei_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*erlei = EXTRACT_RESERVE_LOSS_EXP_INTM end*/
    
    /*erle = EXTRACT_RESERVE_LOSS_EXP start*/
    PROCEDURE erle_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_brdrx_record_id   IN OUT NUMBER
    );
    
    PROCEDURE erle_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_gross_tag     IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*erle = EXTRACT_RESERVE_LOSS_EXP end*/
    
    /*ertui = EXTRACT_RESERVE_TAKE_UP_INTM start*/
    PROCEDURE ertui_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_posted            IN VARCHAR2,
        p_brdrx_record_id   IN OUT NUMBER
    );
         
    PROCEDURE ertui_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_as_of_date    IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER,
        p_posted            IN VARCHAR2
    );               
    /*ertui = EXTRACT_RESERVE_TAKE_UP_INTM end*/
    
    /*ertu = EXTRACT_RESERVE_TAKE_UP start*/
    PROCEDURE ertu_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_posted            IN VARCHAR2,
        p_brdrx_record_id   IN OUT NUMBER
    );    
    
    PROCEDURE ertu_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_as_of_date    IN DATE,
        p_posted            IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*ertu = EXTRACT_RESERVE_TAKE_UP end*/
    
    /*erlia = EXTRACT_RESERVE_LOSS_INTM_ALL start*/
    PROCEDURE erlia_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    PROCEDURE erlia_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    PROCEDURE erlia_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_gross_tag     IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*erlia = EXTRACT_RESERVE_LOSS_INTM_ALL end*/
    
    /*erla = EXTRACT_RESERVE_LOSS_ALL start*/
    PROCEDURE erla_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,        
        p_brdrx_record_id   IN OUT NUMBER
    );
    
    PROCEDURE erla_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_gross_tag     IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*erla = EXTRACT_RESERVE_LOSS_ALL end*/
    
    /*ereia = EXTRACT_RESERVE_EXP_INTM_ALL start*/
    PROCEDURE ereia_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE        
    );
    
    PROCEDURE ereia_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    PROCEDURE ereia_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
		p_dsp_as_of_date    IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*ereia = EXTRACT_RESERVE_EXP_INTM_ALL end*/
    
    /*erea = EXTRACT_RESERVE_EXP_ALL start*/
    PROCEDURE erea_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,        
        p_brdrx_record_id   IN OUT NUMBER
    );
    
    PROCEDURE erea_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
		p_dsp_as_of_date    IN DATE,
        p_dsp_gross_tag     IN NUMBER,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*erea = EXTRACT_RESERVE_EXP_ALL end*/
    
    /*erleia = EXTRACT_RESERVE_LOSSEXPINTMALL start*/
    PROCEDURE erleia_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    PROCEDURE erleia_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    PROCEDURE erleia_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_as_of_date    IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*erleia = EXTRACT_RESERVE_LOSSEXPINTMALL end*/
    
    /*erlea = EXTRACT_RESERVE_LOSS_EXP_ALL start*/
    PROCEDURE erlea_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,        
        p_brdrx_record_id   IN OUT NUMBER
    );
    
    PROCEDURE erlea_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
		p_dsp_as_of_date    IN DATE,
        p_dsp_gross_tag     IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*erlea = EXTRACT_RESERVE_LOSS_EXP_ALL end*/
    
    /*epli = EXTRACT_PAID_LE_INTM start*/
    PROCEDURE epli_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE   
    );
    
    PROCEDURE epli_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    PROCEDURE epli_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_brdrx_option      IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
		p_dsp_as_of_date    IN DATE,
        p_dsp_gross_tag     IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*epli = EXTRACT_PAID_LE_INTM end*/
    
    /*epl = EXTRACT_PAID_LE start*/
    PROCEDURE epl_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,        
        p_brdrx_record_id   IN OUT NUMBER
    );
    
    PROCEDURE epl_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_brdrx_option      IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
		p_dsp_as_of_date    IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*epl = EXTRACT_PAID_LE end*/
    
    PROCEDURE extract_brdrx_rcvry(
        p_session_id                IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_rcvry_from_date       IN DATE,
        p_dsp_rcvry_to_date         IN DATE,
        p_rcvry_brdrx_rec_id        IN gicl_rcvry_brdrx_extr.rcvry_brdrx_record_id%TYPE,
        p_rcvry_brdrx_ds_rec_id     IN gicl_rcvry_brdrx_ds_extr.rcvry_brdrx_ds_record_id%TYPE,
        p_rcvry_brdrx_rids_rec_id   IN gicl_rcvry_brdrx_rids_extr.rcvry_brdrx_rids_record_id%TYPE
    );
    
    /*edr - EXTRACT_DATA_REG start*/
    PROCEDURE edr_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_dsp_loss_cat_cd   IN gicl_claims.loss_cat_cd%TYPE,
        p_clm_exp_payee_type IN VARCHAR2,
        p_clm_loss_payee_type IN VARCHAR2,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    FUNCTION edr_get_paid_le_amt(
        p_claim_id   IN gicl_claims.claim_id%type,
        p_item_no    IN gicl_clm_loss_exp.item_no%type,
        p_peril_cd   IN gicl_clm_loss_exp.peril_cd%type,
        p_payee_type IN gicl_clm_loss_exp.payee_type%type
    ) RETURN NUMBER;
    
    FUNCTION edr_get_tsi_amt(
        p_claim_id   gicl_claims.claim_id%TYPE,
        p_item_no    gicl_item_peril.item_no%TYPE,
        p_peril_cd   gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER;
    
    FUNCTION edr_get_tot_prem_amt(
        p_claim_id IN gicl_claims.claim_id%TYPE,
        p_item_no  IN gicl_item_peril.item_no%TYPE,
        p_peril_cd IN gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER;
    
    FUNCTION edr_get_parent_intm(
        p_intrmdry_intm_no IN giis_intermediary.intm_no%TYPE
    ) RETURN NUMBER;
    
    PROCEDURE edr_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_dsp_loss_cat_cd   IN gicl_claims.loss_cat_cd%TYPE,
        p_clm_exp_payee_type IN VARCHAR2,
        p_clm_loss_payee_type IN VARCHAR2,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    );
    
    FUNCTION edr_get_ri_prem_amt(
        p_policy_id  gipi_polbasic.policy_id%TYPE,
        p_item_no    gipi_itmperil.item_no%TYPE,
        p_peril_cd   gipi_itmperil.peril_cd%TYPE
    ) RETURN NUMBER;
    /*edr - EXTRACT_DATA_REG end*/ 
    
    /*ecri - EXTRACT_CLM_REG_INTM start*/
    PROCEDURE ecri_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_clm_exp_payee_type IN VARCHAR2,
        p_clm_loss_payee_type IN VARCHAR2,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,        
        p_brdrx_record_id   IN NUMBER
    );
    
    FUNCTION ecri_get_tsi_amt(
        p_claim_id   gicl_claims.claim_id%TYPE,
        p_item_no    gicl_item_peril.item_no%TYPE,
        p_peril_cd   gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER;
    
    FUNCTION ecri_get_tot_prem_amt(
        p_claim_id IN gicl_claims.claim_id%TYPE,
        p_item_no  IN gicl_item_peril.item_no%TYPE,
        p_peril_cd IN gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER;
    
    FUNCTION ecri_get_paid_le_amt(
        p_claim_id   IN gicl_claims.claim_id%type,
        p_item_no    IN gicl_clm_loss_exp.item_no%type,
        p_peril_cd   IN gicl_clm_loss_exp.peril_cd%type,
        p_payee_type IN gicl_clm_loss_exp.payee_type%type
    ) RETURN NUMBER;
    /*ecri - EXTRACT_CLM_REG_INTM end*/   
    
    /*ecr - EXTRACT_CLM_REG start*/
    PROCEDURE ecr_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_dsp_loss_cat_cd   IN gicl_claims.loss_cat_cd%TYPE,
        p_clm_exp_payee_type IN VARCHAR2,
        p_clm_loss_payee_type IN VARCHAR2,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,        
        p_brdrx_record_id   IN NUMBER
    );
    
    FUNCTION ecr_get_tsi_amt(
        p_claim_id   gicl_claims.claim_id%TYPE,
        p_item_no    gicl_item_peril.item_no%TYPE,
        p_peril_cd   gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER;
    
    FUNCTION ecr_get_tot_prem_amt(
        p_claim_id IN gicl_claims.claim_id%TYPE,
        p_item_no  IN gicl_item_peril.item_no%TYPE,
        p_peril_cd IN gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER;
    
    FUNCTION ecr_get_paid_le_amt(
        p_claim_id   IN gicl_claims.claim_id%TYPE,
        p_item_no    IN gicl_clm_loss_exp.item_no%TYPE,
        p_peril_cd   IN gicl_clm_loss_exp.peril_cd%TYPE,
        p_payee_type IN gicl_clm_loss_exp.payee_type%TYPE
    ) RETURN NUMBER;
    /*ecr - EXTRACT_CLM_REG end*/
    
    /*eplp - EXTRACT_PAID_LE_POLICY start*/
    PROCEDURE eplp_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_brdrx_rep_type    IN gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
        p_pd_date_opt       IN gicl_res_brdrx_extr.pd_date_opt%TYPE,
        p_from_date         IN gicl_res_brdrx_extr.from_date%TYPE,
        p_to_date           IN gicl_res_brdrx_extr.TO_DATE%TYPE,
        p_line_cd           IN gicl_claims.line_cd%TYPE,
        p_subline_cd        IN gicl_claims.subline_cd%TYPE,
        p_pol_iss_cd        IN gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy          IN gicl_claims.issue_yy%TYPE,
        p_pol_seq_no        IN gicl_claims.pol_seq_no%TYPE,
        p_renew_no          IN gicl_claims.renew_no%TYPE,
        p_brdrx_record_id   IN NUMBER
    );
    
    PROCEDURE eplp_extract_distribution(
        p_user_id               IN giis_users.user_id%TYPE,        
        p_session_id            IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_brdrx_rep_type        IN gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
        p_from_date             IN gicl_res_brdrx_extr.from_date%TYPE,
        p_to_date               IN gicl_res_brdrx_extr.to_date%TYPE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*eplp - EXTRACT_PAID_LE_POLICY end*/
    
    /*eple - EXTRACT_PAID_LE_ENROLLEE start*/
    PROCEDURE eple_extract_all (
        p_user_id               IN giis_users.user_id%TYPE, 
        p_session_id            IN gicl_res_brdrx_extr.session_id%TYPE,
        p_brdrx_rep_type        IN gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
        p_pd_date_opt           IN gicl_res_brdrx_extr.pd_date_opt%TYPE,
        p_from_date             IN gicl_res_brdrx_extr.from_date%TYPE,
        p_to_date               IN gicl_res_brdrx_extr.to_date%TYPE,
        p_enrollee              IN gicl_accident_dtl.grouped_item_title%TYPE,
        p_control_type          IN gicl_accident_dtl.control_type_cd%TYPE,
        p_control_number        IN gicl_accident_dtl.control_cd%TYPE,
        p_brdrx_record_id       IN NUMBER
    );
    
    PROCEDURE eple_extract_distribution(
        p_user_id               IN giis_users.user_id%TYPE,
        p_session_id            IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_brdrx_rep_type        IN gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
        p_from_date             IN gicl_res_brdrx_extr.from_date%TYPE,
        p_to_date               IN gicl_res_brdrx_extr.to_date%TYPE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    );
    /*eple - EXTRACT_PAID_LE_ENROLLEE end*/
    
    FUNCTION validate_line_cd2_gicls202(
        p_dsp_line_cd2      IN giis_subline.line_cd%TYPE,
        p_dsp_iss_cd2       IN giis_issource.iss_cd%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION validate_subline_cd2_gicls202(
        p_dsp_line_cd2      IN giis_subline.line_cd%TYPE,
        p_dsp_subline_cd2   IN giis_subline.subline_cd%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION validate_iss_cd2_gicls202(
        p_dsp_line_cd2      IN giis_subline.line_cd%TYPE,
        p_dsp_iss_cd2       IN giis_issource.iss_cd%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION validate_line_cd_gicls202(
        p_dsp_line_cd       IN giis_line.line_cd%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION validate_subline_cd_gicls202(
        p_dsp_line_cd       IN giis_subline.line_cd%TYPE,
        p_dsp_subline_cd    IN giis_subline.subline_cd%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION validate_iss_cd_gicls202(
        p_dsp_iss_cd        IN giis_issource.iss_cd%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION validate_loss_cat_cd_gicls202(
        p_dsp_line_cd       IN giis_line.line_cd%TYPE,
        p_dsp_loss_cat_cd   IN giis_loss_ctgry.loss_cat_cd%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION validate_peril_cd_gicls202(
        p_dsp_line_cd       IN giis_line.line_cd%TYPE,
        p_dsp_peril_cd      IN giis_peril.peril_cd%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION validate_intm_no_gicls202(
        p_dsp_intm_no       IN giis_intermediary.intm_no%TYPE        
    ) RETURN VARCHAR2;
    
    FUNCTION validate_cntrl_typ_cd_gicls202(
        p_dsp_control_type_cd   IN giis_control_type.control_type_cd%TYPE        
    ) RETURN VARCHAR2;
    
    TYPE line_listing_type IS RECORD (
        line_cd             giis_line.line_cd%TYPE,
        line_name           giis_line.line_name%TYPE
    );

    TYPE line_listing_tab IS TABLE OF line_listing_type;
   
    FUNCTION get_line_cd_gicls202_lov(
        p_dsp_iss_cd        giis_issource.iss_cd%TYPE,
        p_dsp_iss_cd2       giis_issource.iss_cd%TYPE,
        p_module_id         giis_modules.module_id%TYPE,
        p_user_id           giis_users.user_id%TYPE
    ) RETURN line_listing_tab PIPELINED;
    
    TYPE subline_listing_type IS RECORD (
        subline_cd          giis_subline.subline_cd%TYPE,
        subline_name        giis_subline.subline_name%TYPE
    );

    TYPE subline_listing_tab IS TABLE OF subline_listing_type;
    
    FUNCTION get_subline_cd2_gicls202_lov(
        p_dsp_line_cd       giis_line.line_cd%TYPE,
        p_dsp_line_cd2      giis_line.line_cd%TYPE,        
        p_per_policy        NUMBER        
    ) RETURN subline_listing_tab PIPELINED;
    
    TYPE issource_listing_type IS RECORD (
        iss_cd          giis_issource.iss_cd%TYPE,
        iss_name        giis_issource.iss_name%TYPE
    );

    TYPE issource_listing_tab IS TABLE OF issource_listing_type;
    
    FUNCTION get_iss_cd2_gicls202_lov(
        p_dsp_line_cd       giis_line.line_cd%TYPE,
        p_dsp_line_cd2      giis_line.line_cd%TYPE,
        p_module_id         giis_modules.module_id%TYPE,
        p_user_id           giis_users.user_id%TYPE
    ) RETURN issource_listing_tab PIPELINED;
    
    TYPE peril_listing_type IS RECORD (
        peril_cd            giis_peril.peril_cd%TYPE,
        peril_name          giis_peril.peril_name%TYPE
    );

    TYPE peril_listing_tab IS TABLE OF peril_listing_type;
    
    FUNCTION get_peril_cd_gicls202_lov(
        p_dsp_line_cd       giis_line.line_cd%TYPE
    ) RETURN peril_listing_tab PIPELINED;
    
    TYPE loss_cat_listing_type IS RECORD (
        loss_cat_cd         giis_loss_ctgry.loss_cat_cd%TYPE,
        loss_cat_desc       giis_loss_ctgry.loss_cat_des%TYPE
    );

    TYPE loss_cat_listing_tab IS TABLE OF loss_cat_listing_type;
    
    FUNCTION get_loss_cat_cd_gicls202_lov(
        p_dsp_line_cd       giis_line.line_cd%TYPE
    ) RETURN loss_cat_listing_tab PIPELINED;
    
    TYPE intm_listing_type IS RECORD (
        intm_no             giis_intermediary.intm_no%TYPE,
        intm_name           giis_intermediary.intm_name%TYPE
    );

    TYPE intm_listing_tab IS TABLE OF intm_listing_type;
    
    FUNCTION get_intm_no_gicls202_lov
    RETURN intm_listing_tab PIPELINED;
    
    TYPE control_type_cd_listing_type IS RECORD (
        control_type_cd             giis_control_type.control_type_cd%TYPE,
        control_type_desc           giis_control_type.control_type_desc%TYPE
    );

    TYPE control_type_cd_listing_tab IS TABLE OF control_type_cd_listing_type;
    
    FUNCTION get_cntrl_type_cd_gicls202_lov
    RETURN control_type_cd_listing_tab PIPELINED;
    
    TYPE enrollee_type IS RECORD (
        grouped_item_title          gicl_accident_dtl.grouped_item_title%TYPE
    );
    
    TYPE enrollee_tab IS TABLE OF enrollee_type;
    
    FUNCTION get_enrollee_lov
    RETURN enrollee_tab PIPELINED;
    
    PROCEDURE print_gicls202(
        p_user_id           IN  gicl_res_brdrx_extr.user_id%TYPE,
        p_rep_name          IN  gicl_res_brdrx_extr.extr_type%TYPE,
        p_session_id        OUT gicl_res_brdrx_extr.session_id%TYPE,
        p_message           OUT VARCHAR2,
        p_exist             OUT VARCHAR2
    );
    
    PROCEDURE extract_gicls202_web( p_user_id               gicl_res_brdrx_extr.user_id%TYPE,
                                    p_rep_name              gicl_res_brdrx_extr.extr_type%TYPE,     -- (1-Bordereaux or 2-Claims Register)
                                    p_brdrx_type            gicl_res_brdrx_extr.brdrx_type%TYPE,    -- (1-Outstanding or 2-Losses Paid)
                                    p_brdrx_date_option     gicl_res_brdrx_extr.ol_date_opt%TYPE,   -- (1-Loss Date, 2-Claim File Date, 3-Booking Month)
                                    p_brdrx_option          gicl_res_brdrx_extr.brdrx_rep_type%TYPE,-- (1-Loss, 2-Expense, 3-Loss+Expense)
                                    p_dsp_gross_tag         gicl_res_brdrx_extr.res_tag%TYPE,       -- Reserve Tag (1 or 0)
                                    p_paid_date_option      gicl_res_brdrx_extr.pd_date_opt%TYPE,   -- (1-Tran Date or 2-Posting Date)
                                    p_per_intermediary      gicl_res_brdrx_extr.intm_tag%TYPE,      -- Per Business Source (1 or 0) - under Bordereaux option
                                    p_per_issource          gicl_res_brdrx_extr.iss_cd_tag%TYPE,    -- Per Issue Source (1 or 0) - under Bordereaux option
                                    p_per_line_subline      gicl_res_brdrx_extr.line_cd_tag%TYPE,   -- Per Line/Subline (1 or 0) - under Bordereaux option
                                    p_per_policy            NUMBER,                                 -- Per Policy (1 or 0)- under Bordereaux option
                                    p_per_enrollee          NUMBER,                                 -- Per Enrollee (1 or 0)- under Bordereaux option
                                    p_per_line              gicl_res_brdrx_extr.line_cd_tag%TYPE,   -- Per Line/Subline (1 or 0) - under Claims Register option
                                    p_per_iss               gicl_res_brdrx_extr.iss_cd_tag%TYPE,    -- Per Branch (1 or 0) - under Claims Register option
                                    p_per_buss              gicl_res_brdrx_extr.intm_tag%TYPE,      -- Per Intermediary (1 or 0) - under Claims Register option
                                    p_per_loss_cat          gicl_res_brdrx_extr.loss_cat_tag%TYPE,  -- Per Loss Category (1 or 2) - under Claims Register option
                                    p_dsp_from_date         gicl_res_brdrx_extr.from_date%TYPE,     -- By Period From Date  
                                    p_dsp_to_date           gicl_res_brdrx_extr.to_date%TYPE,       -- By Period To Date
                                    p_dsp_as_of_date        gicl_res_brdrx_extr.to_date%TYPE,       -- As of Date
                                    p_branch_option         gicl_res_brdrx_extr.branch_opt%TYPE,    -- Branch Parameter (1-Claim Iss Cd or 2-Policy Iss Cd)
                                    p_reg_button            gicl_res_brdrx_extr.reg_date_opt%TYPE,  -- (1-Loss Date or 2-Claim File Date)
                                    p_net_rcvry_chkbx       gicl_res_brdrx_extr.net_rcvry_tag%TYPE, -- Net of Recovery (Y or N)
                                    p_dsp_rcvry_from_date   gicl_res_brdrx_extr.rcvry_from_date%TYPE,-- Net of Recovery From Date
                                    p_dsp_rcvry_to_date     gicl_res_brdrx_extr.rcvry_to_date%TYPE, -- Net of Recovery To Date
                                    p_date_option           NUMBER,                                 -- (1-By Period or 2-As Of)
                                    p_dsp_line_cd           gicl_res_brdrx_extr.line_cd%TYPE,       -- Line
                                    p_dsp_subline_cd        gicl_res_brdrx_extr.subline_cd%TYPE,    -- Subline
                                    p_dsp_iss_cd            gicl_res_brdrx_extr.iss_cd%TYPE,        -- Branch
                                    p_dsp_loss_cat_cd       gicl_res_brdrx_extr.loss_cat_cd%TYPE,   -- Loss Category (Claims Register option only)
                                    p_dsp_peril_cd          gicl_res_brdrx_extr.peril_cd%TYPE,      -- Peril
                                    p_dsp_intm_no           gicl_res_brdrx_extr.intm_no%TYPE,       -- Intermediary Number
                                    p_dsp_line_cd2          gicl_res_brdrx_extr.line_cd%TYPE,       -- Line Code (Per Policy option only)
                                    p_dsp_subline_cd2       gicl_res_brdrx_extr.subline_cd%TYPE,    -- Subline Code (Per Policy option only)
                                    p_dsp_iss_cd2           gicl_res_brdrx_extr.iss_cd%TYPE,        -- Issue Code (Per Policy option only)
                                    p_issue_yy              gicl_res_brdrx_extr.pol_iss_cd%TYPE,    -- Issue Year (Per Policy option only)
                                    p_pol_seq_no            gicl_res_brdrx_extr.pol_seq_no%TYPE,    -- Policy Sequence Number (Per Policy option only)
                                    p_renew_no              gicl_res_brdrx_extr.renew_no%TYPE,      -- Renew Number (Per Policy option only)
                                    p_dsp_enrollee          gicl_res_brdrx_extr.enrollee%TYPE,      -- Enrollee Number (Per Enrollee option only)
                                    p_dsp_control_type      gicl_res_brdrx_extr.control_type%TYPE,  -- Control Type (Per Enrollee option only)
                                    p_dsp_control_number    gicl_res_brdrx_extr.control_number%TYPE,-- Control Number (Per Enrollee option only)
                                    p_count             OUT NUMBER
                                   );
                                   
   FUNCTION GET_PARENT_INTM(p_intrmdry_intm_no IN giis_intermediary.intm_no%TYPE)
        RETURN NUMBER;
    
    FUNCTION GET_TOT_PREM_AMT(p_claim_id IN gicl_claims.claim_id%type,
                              p_item_no  IN gicl_item_peril.item_no%type,
                              p_peril_cd IN gicl_item_peril.peril_cd%type)
         RETURN NUMBER;
    
    FUNCTION CHECK_CLOSE_DATE1(p_brdrx_type IN NUMBER,
                               p_claim_id IN gicl_claims.claim_id%type,
                               p_item_no  IN gicl_item_peril.item_no%type,
                               p_peril_cd IN gicl_item_peril.peril_cd%type,
                               p_date     IN DATE)
         RETURN NUMBER;
    
    FUNCTION CHECK_CLOSE_DATE2(p_brdrx_type IN NUMBER,
                               p_claim_id IN gicl_claims.claim_id%type,
                               p_item_no  IN gicl_item_peril.item_no%type,
                               p_peril_cd IN gicl_item_peril.peril_cd%type,
                               p_date     IN DATE)
         RETURN NUMBER;
         
    FUNCTION GET_REVERSAL(p_tran_id          IN gicl_clm_res_hist.tran_id%TYPE,
                          p_from_date         IN DATE,
                          p_to_date           IN DATE,
                          p_paid_date_option  IN gicl_res_brdrx_extr.pd_date_opt%TYPE)     
        RETURN NUMBER;
        
    FUNCTION GET_VOUCHER_CHECK_NO(p_claim_id          IN gicl_clm_res_hist.claim_id%TYPE,
                                  p_item_no           IN gicl_clm_res_hist.item_no%TYPE,
                                  p_peril_cd          IN gicl_clm_res_hist.peril_cd%TYPE,
                                  p_grouped_item_no   IN gicl_clm_res_hist.grouped_item_no%TYPE,
                                  p_dsp_from_date     IN DATE,
                                  p_dsp_to_date       IN DATE,
                                  p_paid_date_option  IN gicl_res_brdrx_extr.pd_date_opt%TYPE,
                                  p_payee_type        IN VARCHAR)     
        RETURN VARCHAR;
    FUNCTION GET_GICLR209_DTL(p_claim_id          IN gicl_clm_res_hist.claim_id%TYPE,
                              p_dsp_from_date     IN DATE,
                              p_dsp_to_date       IN DATE,
                              p_paid_date_option  IN gicl_res_brdrx_extr.pd_date_opt%TYPE,
                              p_payee_type        IN VARCHAR,
                              p_type              IN VARCHAR)     
        RETURN VARCHAR;
END GICLS202_PKG;
/