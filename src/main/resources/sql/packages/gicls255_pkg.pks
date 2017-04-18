CREATE OR REPLACE PACKAGE CPI.gicls255_pkg
AS
   TYPE claims_info_type IS RECORD (
      claim_id         gicl_claims.claim_id%TYPE,
      line_cd          gicl_claims.line_cd%TYPE,
      subline_cd       gicl_claims.subline_cd%TYPE,
      clm_line_cd      gicl_claims.line_cd%TYPE,
      clm_subline_cd   gicl_claims.subline_cd%TYPE,
      iss_cd           gicl_claims.iss_cd%TYPE,
      pol_iss_cd       gicl_claims.iss_cd%TYPE,
      clm_yy           gicl_claims.clm_yy%TYPE,
      issue_yy         gicl_claims.issue_yy%TYPE,
      clm_seq_no       gicl_claims.clm_seq_no%TYPE,
      pol_seq_no       gicl_claims.pol_seq_no%TYPE,
      renew_no         gicl_claims.renew_no%TYPE,
      assured_name     gicl_claims.assured_name%TYPE,
      clm_stat_desc    giis_clm_stat.clm_stat_desc%TYPE,
      loss_date        gicl_claims.loss_date%TYPE,
      loss_cat         VARCHAR2 (1000)
   );

   TYPE claims_info_tab IS TABLE OF claims_info_type;

   FUNCTION get_gicls255_clm_info_lov (
      p_module           VARCHAR2,
      p_line_cd          gicl_claims.line_cd%TYPE,
      p_subline_cd       gicl_claims.subline_cd%TYPE,
      p_clm_line_cd      gicl_claims.line_cd%TYPE,
      p_clm_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd           gicl_claims.iss_cd%TYPE,
      p_pol_iss_cd       gicl_claims.iss_cd%TYPE,
      p_clm_yy           gicl_claims.issue_yy%TYPE,
      p_issue_yy         gicl_claims.issue_yy%TYPE,
      p_clm_seq_no       gicl_claims.clm_seq_no%TYPE,
      p_pol_seq_no       gicl_claims.clm_seq_no%TYPE,
      p_renew_no         gicl_claims.renew_no%TYPE,
      p_user_id          giis_users.user_id%TYPE
   )
      RETURN claims_info_tab PIPELINED;

   TYPE reserve_info_type IS RECORD (
      claim_id          gicl_claims.claim_id%TYPE,
      clm_res_hist_id   gicl_clm_res_hist.clm_res_hist_id%TYPE,
      item_no           gicl_clm_reserve.item_no%TYPE,
      grouped_item_no   gicl_clm_reserve.grouped_item_no%TYPE,
      peril_cd          gicl_clm_reserve.peril_cd%TYPE,
      loss_reserve      gicl_clm_reserve.loss_reserve%TYPE,
      expense_reserve   gicl_clm_reserve.expense_reserve%TYPE,
      item_title        gipi_item.item_title%TYPE,
      peril_name        giis_peril.peril_name%TYPE
   );

   TYPE reserve_info_tab IS TABLE OF reserve_info_type;

   FUNCTION get_clm_reserve_info (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN reserve_info_tab PIPELINED;

   TYPE reserve_ds_type IS RECORD (
      claim_id           gicl_claims.claim_id%TYPE,
      clm_res_hist_id    gicl_clm_res_hist.clm_res_hist_id%TYPE,
      clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE,
      grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE,
      item_no            gicl_clm_reserve.item_no%TYPE,
      peril_cd           gicl_clm_reserve.peril_cd%TYPE,
      line_cd            gicl_reserve_ds.line_cd%TYPE,
      dist_year          gicl_reserve_ds.dist_year%TYPE,
      shr_pct            gicl_reserve_ds.shr_pct%TYPE,
      shr_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
      shr_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE,
      trty_name          giis_dist_share.trty_name%TYPE
   );

   TYPE reserve_ds_tab IS TABLE OF reserve_ds_type;

   FUNCTION get_reserve_ds (
      p_claim_id          gicl_claims.claim_id%TYPE,
      p_clm_res_hist_id   gicl_clm_res_hist.clm_res_hist_id%TYPE
   )
      RETURN reserve_ds_tab PIPELINED;

   TYPE reserve_ri_type IS RECORD (
      claim_id              gicl_claims.claim_id%TYPE,
      clm_res_hist_id       gicl_clm_res_hist.clm_res_hist_id%TYPE,
      clm_dist_no           gicl_reserve_ds.clm_dist_no%TYPE,
      grp_seq_no            gicl_reserve_ds.grp_seq_no%TYPE,
      line_cd               gicl_reserve_ds.line_cd%TYPE,
      ri_cd                 gicl_reserve_rids.ri_cd%TYPE,
      dist_year             gicl_reserve_rids.dist_year%TYPE,
      ri_sname              giis_reinsurer.ri_sname%TYPE,
      shr_ri_pct            gicl_reserve_rids.shr_ri_pct%TYPE,
      shr_loss_ri_res_amt   gicl_reserve_rids.shr_loss_ri_res_amt%TYPE,
      shr_exp_ri_res_amt    gicl_reserve_rids.shr_exp_ri_res_amt%TYPE
   );

   TYPE reserve_ri_tab IS TABLE OF reserve_ri_type;

   FUNCTION get_res_ds_ri (
      p_claim_id          gicl_claims.claim_id%TYPE,
      p_clm_res_hist_id   gicl_clm_res_hist.clm_res_hist_id%TYPE,
      p_grp_seq_no        gicl_reserve_ds.grp_seq_no%TYPE,
      p_clm_dist_no       gicl_reserve_ds.clm_dist_no%TYPE
   )
      RETURN reserve_ri_tab PIPELINED;

   TYPE loss_exp_info_type IS RECORD (
      claim_id          gicl_claims.claim_id%TYPE,
      clm_loss_id       gicl_clm_loss_exp.clm_loss_id%TYPE,
      item_no           gicl_clm_reserve.item_no%TYPE,
      grouped_item_no   gicl_clm_reserve.grouped_item_no%TYPE,
      peril_cd          gicl_clm_reserve.peril_cd%TYPE,
      hist_seq_no       gicl_clm_loss_exp.hist_seq_no%TYPE,
      item_stat_cd      gicl_clm_loss_exp.item_stat_cd%TYPE,
      dist_sw           gicl_clm_loss_exp.dist_sw%TYPE,
      paid_amt          gicl_clm_loss_exp.paid_amt%TYPE,
      net_amt           gicl_clm_loss_exp.net_amt%TYPE,
      advise_amt        gicl_clm_loss_exp.advise_amt%TYPE,
      payee_type        gicl_loss_exp_payees.payee_type%TYPE,
      payee_class_cd    gicl_loss_exp_payees.payee_class_cd%TYPE,
      payee_cd          gicl_loss_exp_payees.payee_cd%TYPE,
      payee_name        VARCHAR (2000),
      item_title        gipi_item.item_title%TYPE,
      peril_name        giis_peril.peril_name%TYPE
   );

   TYPE loss_exp_info_tab IS TABLE OF loss_exp_info_type;

   FUNCTION get_clm_loss_exp_info (
      p_claim_id          gicl_claims.claim_id%TYPE,
      p_line_cd           gicl_claims.line_cd%TYPE
   )
      RETURN loss_exp_info_tab PIPELINED;

   TYPE loss_exp_ds_type IS RECORD (
      claim_id           gicl_claims.claim_id%TYPE,
      clm_loss_id        gicl_loss_exp_ds.clm_loss_id%TYPE,
      item_no            gicl_clm_reserve.item_no%TYPE,
      peril_cd           gicl_clm_reserve.peril_cd%TYPE,
      grp_seq_no         gicl_loss_exp_ds.grp_seq_no%TYPE,
      clm_dist_no        gicl_loss_exp_ds.clm_dist_no%TYPE,
      dist_year          gicl_loss_exp_ds.dist_year%TYPE,
      line_cd            gicl_loss_exp_ds.line_cd%TYPE,
      trty_name          giis_dist_share.trty_name%TYPE,
      acct_trty_type     gicl_loss_exp_ds.acct_trty_type%TYPE,
      share_type         gicl_loss_exp_ds.share_type%TYPE,
      shr_loss_exp_pct   gicl_loss_exp_ds.shr_loss_exp_pct%TYPE,
      shr_le_pd_amt      gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      shr_le_adv_amt     gicl_loss_exp_ds.shr_le_adv_amt%TYPE,
      shr_le_net_amt     gicl_loss_exp_ds.shr_le_net_amt%TYPE,
      negate_tag         gicl_loss_exp_ds.negate_tag%TYPE--gicl_loss_exp_ds.shr_le_pd_amt%TYPE
   );

   TYPE loss_exp_ds_tab IS TABLE OF loss_exp_ds_type;

   FUNCTION get_loss_exp_ds (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_clm_loss_id   gicl_loss_exp_ds.clm_loss_id%TYPE,
      p_item_no       gicl_loss_exp_ds.item_no%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE
   )
      RETURN loss_exp_ds_tab PIPELINED;

   TYPE le_ds_ri_type IS RECORD (
      claim_id              gicl_claims.claim_id%TYPE,
      clm_loss_id           gicl_loss_exp_ds.clm_loss_id%TYPE,
      clm_dist_no           gicl_loss_exp_ds.clm_dist_no%TYPE,
      grp_seq_no            gicl_loss_exp_ds.grp_seq_no%TYPE,
      item_no               gicl_clm_reserve.item_no%TYPE,
      peril_cd              gicl_clm_reserve.peril_cd%TYPE,
      line_cd               gicl_loss_exp_ds.line_cd%TYPE,
      ri_cd                 giis_reinsurer.ri_cd%TYPE,
      dist_year             gicl_loss_exp_ds.dist_year%TYPE,
      ri_sname              giis_reinsurer.ri_sname%TYPE,
      acct_trty_type        gicl_loss_exp_ds.acct_trty_type%TYPE,
      share_type            gicl_loss_exp_ds.share_type%TYPE,
      shr_loss_exp_ri_pct   gicl_loss_exp_rids.shr_loss_exp_ri_pct%TYPE,
      shr_le_ri_pd_amt      gicl_loss_exp_rids.shr_le_ri_pd_amt%TYPE,
      shr_le_ri_adv_amt     gicl_loss_exp_rids.shr_le_ri_adv_amt%TYPE,
      shr_le_ri_net_amt     gicl_loss_exp_rids.shr_le_ri_net_amt%TYPE
   );

   TYPE le_ds_ri_tab IS TABLE OF le_ds_ri_type;

   FUNCTION get_le_ds_ri (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_clm_loss_id   gicl_loss_exp_rids.clm_loss_id%TYPE,
      p_grp_seq_no    gicl_reserve_ds.grp_seq_no%TYPE,
      p_clm_dist_no   gicl_reserve_ds.clm_dist_no%TYPE
   )
      RETURN le_ds_ri_tab PIPELINED;
END;
/


