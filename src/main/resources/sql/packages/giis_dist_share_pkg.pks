CREATE OR REPLACE PACKAGE CPI.giis_dist_share_pkg
AS
    TYPE giis_dist_share_type IS RECORD(
        line_cd                 giis_dist_share.line_cd%TYPE,
        share_cd                giis_dist_share.share_cd%TYPE,
        trty_yy                 giis_dist_share.trty_yy%TYPE,
        trty_sw                 giis_dist_share.trty_sw%TYPE,
        share_type              giis_dist_share.share_type%TYPE,
        old_trty_seq_no         giis_dist_share.old_trty_seq_no%TYPE,
        ccall_limit             giis_dist_share.ccall_limit%TYPE,
        inxs_amt                giis_dist_share.inxs_amt%TYPE,
        est_prem_inc            giis_dist_share.est_prem_inc%TYPE,
        underlying              giis_dist_share.underlying%TYPE,
        dep_prem                giis_dist_share.dep_prem%TYPE,
        profcomp_type           giis_dist_share.profcomp_type%TYPE,
        exc_loss_rt             giis_dist_share.exc_loss_rt%TYPE,
        uw_trty_type            giis_dist_share.uw_trty_type%TYPE,
        trty_cd                 giis_dist_share.trty_cd%TYPE,
        prtfolio_sw             giis_dist_share.prtfolio_sw%TYPE,
        acct_trty_type          giis_dist_share.acct_trty_type%TYPE,
        eff_date                giis_dist_share.eff_date%TYPE,
        expiry_date             giis_dist_share.expiry_date%TYPE,
        no_of_lines             giis_dist_share.no_of_lines%TYPE,
        tot_shr_pct             giis_dist_share.tot_shr_pct%TYPE,
        trty_name               giis_dist_share.trty_name%TYPE,
        trty_limit              giis_dist_share.trty_limit%TYPE,
        qs_shr_pct              giis_dist_share.qs_shr_pct%TYPE,
        prem_adj_rt             giis_dist_share.prem_adj_rt%TYPE,
        reinstatement           giis_dist_share.reinstatement%TYPE,
        share_trty_type         giis_dist_share.share_trty_type%TYPE,
        funds_held_pct          giis_dist_share.funds_held_pct%TYPE,
        user_id                 giis_dist_share.user_id%TYPE,
        last_update             giis_dist_share.last_update%TYPE,
        remarks                 giis_dist_share.remarks%TYPE,
        cpi_rec_no              giis_dist_share.cpi_rec_no%TYPE,
        cpi_branch_cd           giis_dist_share.cpi_branch_cd%TYPE,
        loss_prtfolio_pct       giis_dist_share.loss_prtfolio_pct%TYPE,
        prem_prtfolio_pct       giis_dist_share.prem_prtfolio_pct%TYPE,
        xol_id                  giis_dist_share.xol_id%TYPE,
        reinstatement_limit     giis_dist_share.reinstatement_limit%TYPE,
        xol_allowed_amount      giis_dist_share.xol_allowed_amount%TYPE,
        xol_base_amount         giis_dist_share.xol_base_amount%TYPE,
        xol_reserve_amount      giis_dist_share.xol_reserve_amount%TYPE,
        xol_allocated_amount    giis_dist_share.xol_allocated_amount%TYPE,
        layer_no                giis_dist_share.layer_no%TYPE,
        xol_aggregate_sum       giis_dist_share.xol_aggregate_sum%TYPE,
        xol_prem_mindep         giis_dist_share.xol_prem_mindep%TYPE,
        xol_prem_rate           giis_dist_share.xol_prem_rate%TYPE,
        xol_ded                 giis_dist_share.xol_ded%TYPE
        );
    TYPE giis_dist_share_tab IS TABLE OF giis_dist_share_type;
    TYPE dist_share_list_type IS RECORD(
        trty_cd                 giis_dist_share.trty_cd%TYPE,
        trty_name               giis_dist_share.trty_name%TYPE,
        trty_yy                 giis_dist_share.trty_yy%TYPE, 
        line_cd                 giis_dist_share.line_cd%TYPE, 
        share_cd                giis_dist_share.share_cd%TYPE, 
        share_type              giis_dist_share.share_type%TYPE, 
        eff_date                giis_dist_share.eff_date%TYPE,
        expiry_date             giis_dist_share.expiry_date%TYPE,
        remarks                 giis_dist_share.remarks%TYPE,
        user_id                 giis_dist_share.user_id%TYPE,
        last_update             giis_dist_share.last_update%TYPE,
        str_last_update         VARCHAR2 (30), --steven 11.18.2013
		trty_sw                 giis_dist_share.trty_sw%TYPE
        );
    TYPE dist_share_list_tab IS TABLE OF dist_share_list_type;
    TYPE dist_share_list_type2 IS RECORD(
        trty_name               giis_dist_share.trty_name%TYPE,
        trty_yy                 giis_dist_share.trty_yy%TYPE, 
        line_cd                 giis_dist_share.line_cd%TYPE, 
        line_name               giis_line.line_name%TYPE,
        share_cd                giis_dist_share.share_cd%TYPE, 
        share_type              giis_dist_share.share_type%TYPE,
        main_proc_year          NUMBER(4),
        main_proc_qtr           NUMBER(1),
        main_proc_qtr_str       VARCHAR2(10)
    );
    TYPE dist_share_list_tab2 IS TABLE OF dist_share_list_type2;
    FUNCTION get_dist_treaty_list(
        p_par_id                gipi_wpolbas.par_id%TYPE,
        p_nbt_line_cd           giuw_wpolicyds_dtl.line_cd%TYPE)
    RETURN dist_share_list_tab PIPELINED;
    FUNCTION get_dist_share_list(
        p_nbt_line_cd           giuw_wpolicyds_dtl.line_cd%TYPE,
        p_line_cd               gipi_wpolbas.line_cd%TYPE)
    RETURN dist_share_list_tab PIPELINED;
    FUNCTION get_dist_treaty_list2(p_line_cd      IN    GIPI_POLBASIC.line_cd%TYPE,
                                   p_subline_cd   IN    GIPI_POLBASIC.subline_cd%TYPE,
                                   p_iss_cd       IN    GIPI_POLBASIC.iss_cd%TYPE,
                                   p_issue_yy     IN    GIPI_POLBASIC.issue_yy%TYPE,
                                   p_pol_seq_no   IN    GIPI_POLBASIC.pol_seq_no%TYPE,
                                   p_renew_no     IN    GIPI_POLBASIC.renew_no%TYPE)
    RETURN dist_share_list_tab PIPELINED;
    FUNCTION get_dist_share_list2(p_line_cd      IN       GIIS_DIST_SHARE.line_cd%TYPE)
    RETURN dist_share_list_tab PIPELINED;
    PROCEDURE gicls024_update_xol(
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_peril_cd    gicl_item_peril.peril_cd%TYPE
    );    
    FUNCTION get_giuws013_dist_treaty_lov(
        p_policy_id             gipi_polbasic.policy_id%TYPE,
        p_nbt_line_cd           giuw_wpolicyds_dtl.line_cd%TYPE,
        p_find_text             VARCHAR2)
    RETURN dist_share_list_tab PIPELINED;
    FUNCTION get_giuws013_dist_share_lov(
        p_nbt_line_cd           giuw_wpolicyds_dtl.line_cd%TYPE,
        p_line_cd               gipi_wpolbas.line_cd%TYPE,
        p_find_text             VARCHAR2)
    RETURN dist_share_list_tab PIPELINED;
   FUNCTION get_giuws016_dist_treaty_lov(
        p_policy_id             GIPI_POLBASIC.policy_id%TYPE,
        p_nbt_line_cd           GIUW_WPOLICYDS_DTL.line_cd%TYPE,
        p_find_text             VARCHAR2)
    RETURN dist_share_list_tab PIPELINED;
    FUNCTION get_giuws016_dist_share_lov(
        p_nbt_line_cd           GIUW_WPOLICYDS_DTL.line_cd%TYPE,
        p_line_cd               GIPI_WPOLBAS.line_cd%TYPE,
        p_find_text             VARCHAR2)
    RETURN dist_share_list_tab PIPELINED;
    FUNCTION get_dist_treaty_list3(
        p_par_id                gipi_wpolbas.par_id%TYPE,
        p_nbt_line_cd           giuw_wpolicyds_dtl.line_cd%TYPE)
    RETURN dist_share_list_tab PIPELINED;
    FUNCTION get_giis060_dist_share_list(
        p_line_cd       giis_line.line_cd%TYPE,
        p_share_type    giis_dist_share.share_type%TYPE)
    RETURN dist_share_list_tab PIPELINED; 
    PROCEDURE chk_share_exists (p_line_cd IN giis_line.line_cd%TYPE, 
        p_share_cd IN giis_dist_share.share_cd%TYPE, 
        p_exists OUT giis_line.line_cd%TYPE);
    PROCEDURE set_giis060_dist_share (
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_share_cd      IN  giis_dist_share.share_cd%TYPE,
        p_share_type    IN  giis_dist_share.share_type%TYPE,
        p_trty_name     IN  giis_dist_share.trty_name%TYPE,
        p_remarks       IN  giis_dist_share.remarks%TYPE,
        p_user_id       IN  giis_dist_share.user_id%TYPE,
        p_last_update   IN  giis_dist_share.last_update%TYPE,
        p_trty_yy       IN   giis_dist_share.trty_yy%TYPE,
        p_trty_sw       IN   giis_dist_share.trty_sw%TYPE
    );
    PROCEDURE delete_dist_share ( p_line_cd     giis_line.line_cd%TYPE,
                                  p_share_type  giis_dist_share.share_type%TYPE,
                                  p_share_cd    giis_dist_share.share_cd%TYPE              
    );
    FUNCTION chk_giis_dist_share (p_line_cd IN giis_line.line_cd%TYPE,
                                  p_share_cd IN giis_dist_share.share_cd%TYPE)
    RETURN VARCHAR2;
    PROCEDURE validate_add_dist_share (
        p_line_cd      IN       giis_line.line_cd%TYPE,
        p_share_cd     IN       giis_dist_share.share_cd%TYPE,
        p_trty_name    IN OUT   giis_dist_share.trty_name%TYPE,
        p_share_type   IN OUT   giis_dist_share.share_type%TYPE,
        p_exists       OUT      VARCHAR2,
        p_msg          OUT      VARCHAR2
    );
    PROCEDURE validate_update_dist_share (
        p_line_cd        IN       giis_line.line_cd%TYPE,
        p_share_cd       IN       giis_dist_share.share_cd%TYPE,
        p_trty_name      IN OUT   giis_dist_share.trty_name%TYPE,
        p_share_type     IN OUT   giis_dist_share.share_type%TYPE,
        p_exists         OUT      VARCHAR2,
        p_msg            OUT      VARCHAR2
    ); 
    FUNCTION get_dist_share_list3
        RETURN dist_share_list_tab2 PIPELINED;
END;
/


