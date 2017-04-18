CREATE OR REPLACE PACKAGE CPI.giuw_pol_dist_pkg
AS
   /*
   **  Created by  : Mark JM
   **  Date Created  : 02.18.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description  : Contains the Insert / Update / Delete procedure of the table
   */
   
   v_share_pct_updated       BOOLEAN := FALSE;     -- for updated share_pct for GIUWS001 : shan 07.22.2014
   
   PROCEDURE del_giuw_pol_dist (p_dist_no giuw_pol_dist.dist_no%TYPE);

   PROCEDURE get_tsi (p_par_id NUMBER);

   PROCEDURE delete_dist (p_dist_no NUMBER, p_par_id NUMBER);

   FUNCTION get_dist_no (p_par_id giuw_pol_dist.par_id%TYPE)
      RETURN NUMBER;

   TYPE giuw_pol_dist_type IS RECORD (
      dist_no                    giuw_pol_dist.dist_no%TYPE,
      par_id                     giuw_pol_dist.par_id%TYPE,
      dist_flag                  giuw_pol_dist.dist_flag%TYPE,
      redist_flag                giuw_pol_dist.redist_flag%TYPE,
      eff_date                   giuw_pol_dist.eff_date%TYPE,
      expiry_date                giuw_pol_dist.expiry_date%TYPE,
      create_date                giuw_pol_dist.create_date%TYPE,
      post_flag                  giuw_pol_dist.post_flag%TYPE,
      policy_id                  giuw_pol_dist.policy_id%TYPE,
      endt_type                  giuw_pol_dist.endt_type%TYPE,
      tsi_amt                    giuw_pol_dist.tsi_amt%TYPE,
      prem_amt                   giuw_pol_dist.prem_amt%TYPE,
      ann_tsi_amt                giuw_pol_dist.ann_tsi_amt%TYPE,
      dist_type                  giuw_pol_dist.dist_type%TYPE,
      item_posted_sw             giuw_pol_dist.item_posted_sw%TYPE,
      ex_loss_sw                 giuw_pol_dist.ex_loss_sw%TYPE,
      negate_date                giuw_pol_dist.negate_date%TYPE,
      acct_ent_date              giuw_pol_dist.acct_ent_date%TYPE,
      acct_neg_date              giuw_pol_dist.acct_neg_date%TYPE,
      batch_id                   giuw_pol_dist.batch_id%TYPE,
      user_id                    giuw_pol_dist.user_id%TYPE,
      last_upd_date              giuw_pol_dist.last_upd_date%TYPE,
      cpi_rec_no                 giuw_pol_dist.cpi_rec_no%TYPE,
      cpi_branch_cd              giuw_pol_dist.cpi_branch_cd%TYPE,
      auto_dist                  giuw_pol_dist.auto_dist%TYPE,
      old_dist_no                giuw_pol_dist.old_dist_no%TYPE,
      post_date                  giuw_pol_dist.post_date%TYPE,
      iss_cd                     giuw_pol_dist.iss_cd%TYPE,
      prem_seq_no                giuw_pol_dist.prem_seq_no%TYPE,
      takeup_seq_no              giuw_pol_dist.takeup_seq_no%TYPE,
      item_grp                   giuw_pol_dist.item_grp%TYPE,
      arc_ext_data               giuw_pol_dist.arc_ext_data%TYPE,
      multi_booking_mm           gipi_winvoice.multi_booking_mm%TYPE,
      multi_booking_yy           gipi_winvoice.multi_booking_yy%TYPE,
      mean_dist_flag             cg_ref_codes.rv_meaning%TYPE,
      var_share                  VARCHAR2 (1),
      dist_post_flag             giuw_pol_dist.post_flag%TYPE,
      giuw_wpolicyds_dtl_exist   VARCHAR2 (1),
      giuw_wpolicyds_exist       VARCHAR2 (1),
      giuw_policyds_dtl_exist    VARCHAR2 (1),
      giuw_policyds_exist        VARCHAR2 (1),
      giuw_wperilds_dtl_exist    VARCHAR2 (1),
      giuw_wperilds_exist        VARCHAR2 (1),
      reverse_date               giri_binder.reverse_date%TYPE,
      reverse_sw                 giri_frps_ri.reverse_sw%TYPE
   );

   TYPE giuw_pol_dist_tab IS TABLE OF giuw_pol_dist_type;
   
   TYPE giuws012_post_query_type IS RECORD (
      dist_flag                    giuw_pol_dist.dist_flag%TYPE,
      batch_id                     giuw_pol_dist.batch_id%TYPE
   );
   
   TYPE giuws012_post_query_tab IS TABLE OF giuws012_post_query_type;

   FUNCTION get_giuw_pol_dist (p_par_id giuw_pol_dist.par_id%TYPE)
      RETURN giuw_pol_dist_tab PIPELINED;

   FUNCTION get_giuw_pol_dist (
      p_par_id    giuw_pol_dist.par_id%TYPE,
      p_dist_no   giuw_pol_dist.dist_no%TYPE
   )
      RETURN giuw_pol_dist_tab PIPELINED;

   PROCEDURE delete_dist1 (
      p_par_id        IN   giuw_pol_dist.par_id%TYPE,
      p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
      p_tsi_amt       IN   giuw_pol_dist.tsi_amt%TYPE,
      p_prem_amt      IN   giuw_pol_dist.prem_amt%TYPE,
      p_ann_tsi_amt   IN   giuw_pol_dist.ann_tsi_amt%TYPE
   );

   PROCEDURE compare_gipi_item_itmperil (
      p_par_id              IN       gipi_wpolbas.par_id%TYPE,
      p_nbt_pack_pol_flag   IN       gipi_wpolbas.pack_pol_flag%TYPE,
      p_line_cd             IN       gipi_wpolbas.line_cd%TYPE,
      p_msg_alert           OUT      VARCHAR2
   );

   PROCEDURE compare_gipi_item_itmperil2 (
      p_par_id          IN       gipi_wpolbas.par_id%TYPE,
      p_pack_pol_flag   IN       gipi_wpolbas.pack_pol_flag%TYPE,
      p_line_cd         IN       gipi_wpolbas.line_cd%TYPE,
      p_msg_alert       OUT      VARCHAR2
   );

   PROCEDURE update_witemds (
      p_dist_no       giuw_witemperilds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_witemperilds_dtl.dist_seq_no%TYPE
   );

   PROCEDURE update_dtls_no_share_cd (
      p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   IN   giuw_wpolicyds.dist_seq_no%TYPE,
      p_type          IN   VARCHAR2,
      p_line_cd       IN   gipi_wpolbas.line_cd%TYPE
   );

   PROCEDURE update_dtls_no_share_cd2 (
      p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   IN   giuw_wpolicyds.dist_seq_no%TYPE,
      p_line_cd       IN   gipi_wpolbas.line_cd%TYPE
   );

   PROCEDURE adjust_amts (p_dist_no IN giuw_pol_dist.dist_no%TYPE);

   PROCEDURE create_grp_dflt_witemds (
      p_dist_no        IN   giuw_witemds_dtl.dist_no%TYPE,
      p_dist_seq_no    IN   giuw_witemds_dtl.dist_seq_no%TYPE,
      p_item_no        IN   giuw_witemds_dtl.item_no%TYPE,
      p_line_cd        IN   giuw_witemds_dtl.line_cd%TYPE,
      p_dist_tsi       IN   giuw_witemds_dtl.dist_tsi%TYPE,
      p_dist_prem      IN   giuw_witemds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi   IN   giuw_witemds_dtl.ann_dist_tsi%TYPE,
      p_rg_count       IN   NUMBER,
      p_pol_flag       IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id         IN   gipi_wpolbas.par_id%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE create_grp_dflt_witemds2 (
      p_dist_no        IN   giuw_witemds_dtl.dist_no%TYPE,
      p_dist_seq_no    IN   giuw_witemds_dtl.dist_seq_no%TYPE,
      p_item_no        IN   giuw_witemds_dtl.item_no%TYPE,
      p_line_cd        IN   giuw_witemds_dtl.line_cd%TYPE,
      p_dist_tsi       IN   giuw_witemds_dtl.dist_tsi%TYPE,
      p_dist_prem      IN   giuw_witemds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi   IN   giuw_witemds_dtl.ann_dist_tsi%TYPE,
      p_rg_count       IN   NUMBER,
      p_pol_flag       IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id         IN   gipi_wpolbas.par_id%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE,
	  p_default_no	   IN   giis_default_dist.default_no%TYPE
   );

   PROCEDURE create_peril_dflt_witemds3 (
      p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   IN   giuw_wpolicyds.dist_seq_no%TYPE,
      p_item_no       IN   giuw_witemperilds.item_no%TYPE,
      p_line_cd       IN   giuw_wperilds.line_cd%TYPE,
      p_tsi_amt       IN   giuw_wperilds.tsi_amt%TYPE,
      p_prem_amt      IN   giuw_wperilds.prem_amt%TYPE,
      p_ann_tsi_amt   IN   giuw_wperilds.ann_tsi_amt%TYPE,
      p_pol_flag      IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id        IN   gipi_wpolbas.par_id%TYPE,
      p_par_type      IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE create_grp_dflt_witemperilds (
      p_dist_no        IN   giuw_witemperilds_dtl.dist_no%TYPE,
      p_dist_seq_no    IN   giuw_witemperilds_dtl.dist_seq_no%TYPE,
      p_item_no        IN   giuw_witemperilds_dtl.item_no%TYPE,
      p_line_cd        IN   giuw_witemperilds_dtl.line_cd%TYPE,
      p_peril_cd       IN   giuw_witemperilds_dtl.peril_cd%TYPE,
      p_dist_tsi       IN   giuw_witemperilds_dtl.dist_tsi%TYPE,
      p_dist_prem      IN   giuw_witemperilds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi   IN   giuw_witemperilds_dtl.ann_dist_tsi%TYPE,
      p_rg_count       IN   NUMBER,
      p_pol_flag       IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id         IN   gipi_wpolbas.par_id%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE create_grp_dflt_witemperilds2 (
      p_dist_no        IN   giuw_witemperilds_dtl.dist_no%TYPE,
      p_dist_seq_no    IN   giuw_witemperilds_dtl.dist_seq_no%TYPE,
      p_item_no        IN   giuw_witemperilds_dtl.item_no%TYPE,
      p_line_cd        IN   giuw_witemperilds_dtl.line_cd%TYPE,
      p_peril_cd       IN   giuw_witemperilds_dtl.peril_cd%TYPE,
      p_dist_tsi       IN   giuw_witemperilds_dtl.dist_tsi%TYPE,
      p_dist_prem      IN   giuw_witemperilds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi   IN   giuw_witemperilds_dtl.ann_dist_tsi%TYPE,
      p_rg_count       IN   NUMBER,
      p_pol_flag       IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id         IN   gipi_wpolbas.par_id%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE,
	  p_default_no     IN   giis_default_dist.default_no%TYPE
   );

   PROCEDURE create_grp_dflt_wperilds (
      p_dist_no        IN   giuw_wperilds_dtl.dist_no%TYPE,
      p_dist_seq_no    IN   giuw_wperilds_dtl.dist_seq_no%TYPE,
      p_line_cd        IN   giuw_wperilds_dtl.line_cd%TYPE,
      p_peril_cd       IN   giuw_wperilds_dtl.peril_cd%TYPE,
      p_dist_tsi       IN   giuw_wperilds_dtl.dist_tsi%TYPE,
      p_dist_prem      IN   giuw_wperilds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi   IN   giuw_wperilds_dtl.ann_dist_tsi%TYPE,
      p_rg_count       IN   NUMBER,
      p_pol_flag       IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id         IN   gipi_wpolbas.par_id%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE create_grp_dflt_wperilds2 (
      p_dist_no        IN   giuw_wperilds_dtl.dist_no%TYPE,
      p_dist_seq_no    IN   giuw_wperilds_dtl.dist_seq_no%TYPE,
      p_line_cd        IN   giuw_wperilds_dtl.line_cd%TYPE,
      p_peril_cd       IN   giuw_wperilds_dtl.peril_cd%TYPE,
      p_dist_tsi       IN   giuw_wperilds_dtl.dist_tsi%TYPE,
      p_dist_prem      IN   giuw_wperilds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi   IN   giuw_wperilds_dtl.ann_dist_tsi%TYPE,
      p_rg_count       IN   NUMBER,
      p_pol_flag       IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id         IN   gipi_wpolbas.par_id%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE,
      p_default_no     IN   giis_default_dist.default_no%TYPE
   );

   PROCEDURE create_grp_dflt_dist (
      p_dist_no          IN       giuw_wpolicyds.dist_no%TYPE,
      p_dist_seq_no      IN       giuw_wpolicyds.dist_seq_no%TYPE,
      p_dist_flag        IN       giuw_wpolicyds.dist_flag%TYPE,
      p_policy_tsi       IN       giuw_wpolicyds.tsi_amt%TYPE,
      p_policy_premium   IN       giuw_wpolicyds.prem_amt%TYPE,
      p_policy_ann_tsi   IN       giuw_wpolicyds.ann_tsi_amt%TYPE,
      p_item_grp         IN       giuw_wpolicyds.item_grp%TYPE,
      p_line_cd          IN       giis_line.line_cd%TYPE,
      p_rg_count         IN OUT   NUMBER,
      p_default_type     IN       giis_default_dist.default_type%TYPE,
      p_currency_rt      IN       gipi_witem.currency_rt%TYPE,
      p_par_id           IN       gipi_parlist.par_id%TYPE,
      p_pol_flag         IN       gipi_wpolbas.pol_flag%TYPE,
      p_par_type         IN       gipi_parlist.par_type%TYPE,
      p_dist_exists      IN       VARCHAR2
     ,p_default_no      IN      giis_default_dist.default_no%TYPE --added edgar 09/17/2014
   );

   PROCEDURE create_par_distribution_recs (
      p_dist_no         IN   giuw_pol_dist.dist_no%TYPE,
      p_par_id          IN   gipi_parlist.par_id%TYPE,
      p_line_cd         IN   gipi_parlist.line_cd%TYPE,
      p_subline_cd      IN   gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd          IN   gipi_wpolbas.iss_cd%TYPE,
      p_pack_pol_flag   IN   gipi_wpolbas.pack_pol_flag%TYPE,
      p_pol_flag        IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_type        IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE delete_dist_working_tables (p_dist_no giuw_pol_dist.dist_no%TYPE);

   PROCEDURE delete_dist_master_tables (p_dist_no giuw_pol_dist.dist_no%TYPE);

   PROCEDURE post_dist_with_validation (
      p_par_id              IN       gipi_wpolbas.par_id%TYPE,
      p_dist_no             IN       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no         IN       giuw_wpolicyds.dist_seq_no%TYPE,
      p_module              IN       VARCHAR2,
      p_user_id             IN       giis_users.user_id%TYPE,
      p_current_form_name   IN       VARCHAR2,
	  p_override_switch     IN       VARCHAR2, -- added by: Nica 05.24.2012
      p_net_msg             OUT      VARCHAR2,
      p_treaty_msg          OUT      VARCHAR2,
      p_override_msg        OUT      VARCHAR2,
      p_net_override        OUT      VARCHAR2,
      p_treaty_override     OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2,
      p_dist_flag           OUT      VARCHAR2,
      p_mean_dist_flag      OUT      VARCHAR2,
      p_workflow_msgr       OUT      VARCHAR2,
      p_param_function      OUT      VARCHAR2
   );

   PROCEDURE post_dist_giuws004_final (
      p_par_id              IN       gipi_wpolbas.par_id%TYPE,
      p_dist_no             IN       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no         IN       giuw_wpolicyds.dist_seq_no%TYPE,
      p_module              IN       VARCHAR2,
      p_user_id             IN       giis_users.user_id%TYPE,
      p_current_form_name   IN       VARCHAR2,
	  p_override_switch     IN       VARCHAR2, -- added by: Nica 05.24.2012
      p_net_msg             OUT      VARCHAR2,
      p_treaty_msg          OUT      VARCHAR2,
      p_override_msg        OUT      VARCHAR2,
      p_net_override        OUT      VARCHAR2,
      p_treaty_override     OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2,
      p_dist_flag           OUT      VARCHAR2,
      p_mean_dist_flag      OUT      VARCHAR2,
      p_workflow_msgr       OUT      VARCHAR2,
      p_param_function      OUT      VARCHAR2
   );   

   PROCEDURE set_giuw_pol_dist (
      p_dist_no          giuw_pol_dist.dist_no%TYPE,
      p_par_id           giuw_pol_dist.par_id%TYPE,
      p_dist_flag        giuw_pol_dist.dist_flag%TYPE,
      p_redist_flag      giuw_pol_dist.redist_flag%TYPE,
      p_eff_date         giuw_pol_dist.eff_date%TYPE,
      p_expiry_date      giuw_pol_dist.expiry_date%TYPE,
      p_create_date      giuw_pol_dist.create_date%TYPE,
      p_post_flag        giuw_pol_dist.post_flag%TYPE,
      p_policy_id        giuw_pol_dist.policy_id%TYPE,
      p_endt_type        giuw_pol_dist.endt_type%TYPE,
      p_tsi_amt          giuw_pol_dist.tsi_amt%TYPE,
      p_prem_amt         giuw_pol_dist.prem_amt%TYPE,
      p_ann_tsi_amt      giuw_pol_dist.ann_tsi_amt%TYPE,
      p_dist_type        giuw_pol_dist.dist_type%TYPE,
      p_item_posted_sw   giuw_pol_dist.item_posted_sw%TYPE,
      p_ex_loss_sw       giuw_pol_dist.ex_loss_sw%TYPE,
      p_negate_date      giuw_pol_dist.negate_date%TYPE,
      p_acct_ent_date    giuw_pol_dist.acct_ent_date%TYPE,
      p_acct_neg_date    giuw_pol_dist.acct_neg_date%TYPE,
      p_batch_id         giuw_pol_dist.batch_id%TYPE,
      p_user_id          giuw_pol_dist.user_id%TYPE,
      p_last_upd_date    giuw_pol_dist.last_upd_date%TYPE,
      p_cpi_rec_no       giuw_pol_dist.cpi_rec_no%TYPE,
      p_cpi_branch_cd    giuw_pol_dist.cpi_branch_cd%TYPE,
      p_auto_dist        giuw_pol_dist.auto_dist%TYPE,
      p_old_dist_no      giuw_pol_dist.old_dist_no%TYPE,
      p_post_date        giuw_pol_dist.post_date%TYPE,
      p_iss_cd           giuw_pol_dist.iss_cd%TYPE,
      p_prem_seq_no      giuw_pol_dist.prem_seq_no%TYPE,
      p_item_grp         giuw_pol_dist.item_grp%TYPE,
      p_takeup_seq_no    giuw_pol_dist.takeup_seq_no%TYPE,
      p_arc_ext_data     giuw_pol_dist.arc_ext_data%TYPE
   );

   PROCEDURE adjust_wpolicyds_dtl (
      p_dist_no       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds.dist_seq_no%TYPE
   );

   PROCEDURE adjust_wpolicyds_dtl_giuws005 (
      p_dist_no       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds.dist_seq_no%TYPE
   );

   PROCEDURE populate_witem_peril_dtl (p_dist_no giuw_pol_dist.dist_no%TYPE);

   PROCEDURE populate_witem_pl_dtl_giuws005 (
      p_dist_no   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE create_ri_records (
      p_dist_no      IN   giuw_pol_dist.dist_no%TYPE,
      p_par_id       IN   gipi_parlist.par_id%TYPE,
      p_line_cd      IN   gipi_wpolbas.line_cd%TYPE,
      p_subline_cd   IN   gipi_wpolbas.subline_cd%TYPE
   );

   PROCEDURE create_ri_records2 (
      p_dist_no      IN   giuw_pol_dist.dist_no%TYPE,
      p_par_id       IN   gipi_parlist.par_id%TYPE,
      p_line_cd      IN   gipi_wpolbas.line_cd%TYPE,
      p_subline_cd   IN   gipi_wpolbas.subline_cd%TYPE
   );

   PROCEDURE post_form_commit_giuws004 (
      p_par_id        giuw_pol_dist.par_id%TYPE,
      p_dist_no       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds.dist_seq_no%TYPE,
      p_pol_flag      gipi_wpolbas.pol_flag%TYPE,
      p_par_type      gipi_parlist.par_type%TYPE,
      p_line_cd       gipi_wpolbas.line_cd%TYPE,
      p_subline_cd    gipi_wpolbas.subline_cd%TYPE
   );

   PROCEDURE post_form_commit_giuws005 (
      p_par_id        giuw_pol_dist.par_id%TYPE,
      p_dist_no       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds.dist_seq_no%TYPE,
      p_pol_flag      gipi_wpolbas.pol_flag%TYPE,
      p_par_type      gipi_parlist.par_type%TYPE,
      p_line_cd       gipi_wpolbas.line_cd%TYPE,
      p_subline_cd    gipi_wpolbas.subline_cd%TYPE
   );

   PROCEDURE create_peril_dflt_witemds (
      p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   IN   giuw_wpolicyds.dist_seq_no%TYPE,
      p_pol_flag      IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id        IN   gipi_wpolbas.par_id%TYPE,
      p_par_type      IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE create_peril_dflt_wperilds (
      p_dist_no           IN   giuw_wperilds_dtl.dist_no%TYPE,
      p_dist_seq_no       IN   giuw_wperilds_dtl.dist_seq_no%TYPE,
      p_line_cd           IN   giuw_wperilds_dtl.line_cd%TYPE,
      p_peril_cd          IN   giuw_wperilds_dtl.peril_cd%TYPE,
      p_dist_tsi          IN   giuw_wperilds_dtl.dist_tsi%TYPE,
      p_dist_prem         IN   giuw_wperilds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi      IN   giuw_wperilds_dtl.ann_dist_tsi%TYPE,
      p_currency_rt       IN   gipi_winvoice.currency_rt%TYPE,
      p_default_no        IN   giis_default_dist.default_no%TYPE,
      p_default_type      IN   giis_default_dist.default_type%TYPE,
      p_dflt_netret_pct   IN   giis_default_dist.dflt_netret_pct%TYPE,
      p_pol_flag          IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id            IN   gipi_wpolbas.par_id%TYPE,
      p_par_type          IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE create_par_distribution_recs2 (
      p_dist_no         IN   giuw_pol_dist.dist_no%TYPE,
      p_par_id          IN   gipi_parlist.par_id%TYPE,
      p_line_cd         IN   gipi_parlist.line_cd%TYPE,
      p_subline_cd      IN   gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd          IN   gipi_wpolbas.iss_cd%TYPE,
      p_pack_pol_flag   IN   gipi_wpolbas.pack_pol_flag%TYPE,
      p_pol_flag        IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_type        IN   gipi_parlist.par_type%TYPE,
      p_item_grp        IN   giuw_pol_dist.item_grp%TYPE,
      p_takeup_seq_no   IN   giuw_pol_dist.takeup_seq_no%TYPE
   );

   PROCEDURE check_dist_flag (
      p_dist_no       IN       giuw_wperilds_dtl.dist_no%TYPE,
      p_dist_seq_no   IN       giuw_wperilds_dtl.dist_seq_no%TYPE,
      p_peril_cd      IN       giuw_wperilds_dtl.peril_cd%TYPE,
      p_count         OUT      NUMBER,
      p_count2        OUT      NUMBER
   );

   PROCEDURE create_par_distribution_recs3 (
      p_dist_no         IN   giuw_pol_dist.dist_no%TYPE,
      p_par_id          IN   gipi_parlist.par_id%TYPE,
      p_line_cd         IN   gipi_parlist.line_cd%TYPE,
      p_subline_cd      IN   gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd          IN   gipi_wpolbas.iss_cd%TYPE,
      p_pack_pol_flag   IN   gipi_wpolbas.pack_pol_flag%TYPE,
      p_pol_flag        IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_type        IN   gipi_parlist.par_type%TYPE,
      p_item_grp        IN   giuw_wpolicyds.item_grp%TYPE
   );

   PROCEDURE post_dist_giuws003 (
      p_par_id              IN       gipi_wpolbas.par_id%TYPE,
      p_dist_no             IN       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no         IN       giuw_wpolicyds.dist_seq_no%TYPE,
      p_module              IN       VARCHAR2,
      p_user_id             IN       giis_users.user_id%TYPE,
      p_current_form_name   IN       VARCHAR2,
      p_net_msg             OUT      VARCHAR2,
      p_treaty_msg          OUT      VARCHAR2,
      p_override_msg        OUT      VARCHAR2,
      p_net_override        OUT      VARCHAR2,
      p_treaty_override     OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2,
      p_dist_flag           OUT      VARCHAR2,
      p_mean_dist_flag      OUT      VARCHAR2,
      p_workflow_msgr       OUT      VARCHAR2,
      p_param_function      OUT      VARCHAR2
   );

   PROCEDURE adjust_wperilds_dtl (
      p_dist_no       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   giuw_wperilds.dist_seq_no%TYPE,
      p_line_cd       giuw_wperilds.line_cd%TYPE,
      p_peril_cd      giuw_wperilds.peril_cd%TYPE
   );

   PROCEDURE adjust_wperilds_dtl2 (
      p_dist_no       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   giuw_wperilds.dist_seq_no%TYPE,
      p_line_cd       giuw_wperilds.line_cd%TYPE,
      p_peril_cd      giuw_wperilds.peril_cd%TYPE
   );

   PROCEDURE adjust_policy_level_amts (
      p_dist_no   IN   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE adjust_item_level_amts (p_dist_no IN giuw_pol_dist.dist_no%TYPE);

   PROCEDURE adjust_item_peril_level_amts (
      p_dist_no   IN   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE adjust_final_giuws003 (p_dist_no IN giuw_pol_dist.dist_no%TYPE);

   PROCEDURE adjust_net_ret_imperfection (
      p_dist_no   IN   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE adjust_net_ret_imperfection2 (
      p_dist_no   IN   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE adjust_net_ret_imperfection3 (
      p_dist_no   IN   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE post_form_commit_giuws003 (
      p_par_id        gipi_wpolbas.par_id%TYPE,
      p_dist_no       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   giuw_wperilds.dist_seq_no%TYPE,
      p_line_cd       giuw_wperilds.line_cd%TYPE,
      p_peril_cd      giuw_wperilds.peril_cd%TYPE,
      p_subline_cd    gipi_wpolbas.subline_cd%TYPE,
      p_pol_flag      gipi_wpolbas.pol_flag%TYPE,
      p_par_type      gipi_parlist.par_type%TYPE,
      p_post_sw       VARCHAR2
   );

   PROCEDURE create_peril_dflt_wperilds2 (
      p_dist_no           IN   giuw_wperilds_dtl.dist_no%TYPE,
      p_dist_seq_no       IN   giuw_wperilds_dtl.dist_seq_no%TYPE,
      p_line_cd           IN   giuw_wperilds_dtl.line_cd%TYPE,
      p_peril_cd          IN   giuw_wperilds_dtl.peril_cd%TYPE,
      p_dist_tsi          IN   giuw_wperilds_dtl.dist_tsi%TYPE,
      p_dist_prem         IN   giuw_wperilds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi      IN   giuw_wperilds_dtl.ann_dist_tsi%TYPE,
      p_currency_rt       IN   gipi_winvoice.currency_rt%TYPE,
      p_default_no        IN   giis_default_dist.default_no%TYPE,
      p_default_type      IN   giis_default_dist.default_type%TYPE,
      p_dflt_netret_pct   IN   giis_default_dist.dflt_netret_pct%TYPE,
      p_pol_flag          IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id            IN   gipi_wpolbas.par_id%TYPE,
      p_par_type          IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE create_peril_dflt_witemds2 (
      p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   IN   giuw_wpolicyds.dist_seq_no%TYPE,
      p_item_no       IN   giuw_witemperilds.item_no%TYPE,
      p_line_cd       IN   giuw_wperilds.line_cd%TYPE,
      p_tsi_amt       IN   giuw_wperilds.tsi_amt%TYPE,
      p_prem_amt      IN   giuw_wperilds.prem_amt%TYPE,
      p_ann_tsi_amt   IN   giuw_wperilds.ann_tsi_amt%TYPE,
      p_pol_flag      IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id        IN   gipi_wpolbas.par_id%TYPE,
      p_par_type      IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE inherit_dist_pct (
      p_dist_no    NUMBER,
      p_par_type   gipi_parlist.par_type%TYPE,
      p_par_id     gipi_parlist.par_id%TYPE
   );

   PROCEDURE create_peril_dflt_dist2 (
      p_dist_no             IN   giuw_wpolicyds.dist_no%TYPE,
      p_dist_seq_no         IN   giuw_wpolicyds.dist_seq_no%TYPE,
      p_dist_flag           IN   giuw_wpolicyds.dist_flag%TYPE,
      p_policy_tsi          IN   giuw_wpolicyds.tsi_amt%TYPE,
      p_policy_premium      IN   giuw_wpolicyds.prem_amt%TYPE,
      p_policy_ann_tsi      IN   giuw_wpolicyds.ann_tsi_amt%TYPE,
      p_item_grp            IN   giuw_wpolicyds.item_grp%TYPE,
      p_line_cd             IN   giis_line.line_cd%TYPE,
      p_default_no          IN   giis_default_dist.default_no%TYPE,
      p_default_type        IN   giis_default_dist.default_type%TYPE,
      p_dflt_netret_pct     IN   giis_default_dist.dflt_netret_pct%TYPE,
      p_currency_rt         IN   gipi_witem.currency_rt%TYPE,
      p_par_id              IN   gipi_parlist.par_id%TYPE,
      p_pol_dist_item_grp   IN   giuw_pol_dist.item_grp%TYPE,
      p_dist_exists         IN   VARCHAR2,
      p_pol_flag            IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_type            IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE create_peril_dflt_dist3 (
      p_dist_no             IN   giuw_wpolicyds.dist_no%TYPE,
      p_dist_seq_no         IN   giuw_wpolicyds.dist_seq_no%TYPE,
      p_dist_flag           IN   giuw_wpolicyds.dist_flag%TYPE,
      p_policy_tsi          IN   giuw_wpolicyds.tsi_amt%TYPE,
      p_policy_premium      IN   giuw_wpolicyds.prem_amt%TYPE,
      p_policy_ann_tsi      IN   giuw_wpolicyds.ann_tsi_amt%TYPE,
      p_item_grp            IN   giuw_wpolicyds.item_grp%TYPE,
      p_line_cd             IN   giis_line.line_cd%TYPE,
      p_default_no          IN   giis_default_dist.default_no%TYPE,
      p_default_type        IN   giis_default_dist.default_type%TYPE,
      p_dflt_netret_pct     IN   giis_default_dist.dflt_netret_pct%TYPE,
      p_currency_rt         IN   gipi_witem.currency_rt%TYPE,
      p_par_id              IN   gipi_parlist.par_id%TYPE,
      p_pol_dist_item_grp   IN   giuw_pol_dist.item_grp%TYPE,
      p_dist_exists         IN   VARCHAR2,
      p_pol_flag            IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_type            IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE create_peril_dflt_witmperilds (
      p_dist_no        IN   giuw_wperilds_dtl.dist_no%TYPE,
      p_dist_seq_no    IN   giuw_wperilds_dtl.dist_seq_no%TYPE,
      p_item_no        IN   giuw_witemperilds_dtl.item_no%TYPE,
      p_line_cd        IN   giuw_wperilds_dtl.line_cd%TYPE,
      p_peril_cd       IN   giuw_wperilds_dtl.peril_cd%TYPE,
      p_dist_tsi       IN   giuw_witemperilds_dtl.dist_tsi%TYPE,
      p_dist_prem      IN   giuw_witemperilds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi   IN   giuw_witemperilds_dtl.ann_dist_tsi%TYPE,
      p_par_id         IN   gipi_parlist.par_id%TYPE,
      p_pol_flag       IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE create_peril_dflt_wpolicyds2 (
      p_dist_no        IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no    IN   giuw_wpolicyds.dist_seq_no%TYPE,
      p_line_cd        IN   giuw_wpolicyds_dtl.line_cd%TYPE,
      p_dist_tsi       IN   giuw_wpolicyds_dtl.dist_tsi%TYPE,
      p_dist_prem      IN   giuw_wpolicyds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi   IN   giuw_wpolicyds_dtl.ann_dist_tsi%TYPE,
      p_par_id         IN   gipi_parlist.par_id%TYPE,
      p_item_grp       IN   gipi_witem.item_grp%TYPE,
      p_pol_flag       IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE adjust_peril_level_amts2 (
      p_dist_no   IN   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE check_dist_menu (
      p_par_id      IN       giuw_pol_dist.par_id%TYPE,
      p_module_id   IN       VARCHAR2,
      p_pack        IN       VARCHAR2,
      p_msg_alert   OUT      VARCHAR2,
      p_msg_icon    OUT      VARCHAR2
   );

   PROCEDURE adjust_net_ret_imp_giuws005 (
      p_dist_no   IN   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE create_ri_records_giuws005 (
      p_dist_no      IN   giuw_pol_dist.dist_no%TYPE,
      p_par_id       IN   gipi_parlist.par_id%TYPE,
      p_line_cd      IN   gipi_wpolbas.line_cd%TYPE,
      p_subline_cd   IN   gipi_wpolbas.subline_cd%TYPE
   );

   PROCEDURE delete_dist_mster_tbl_giuws005 (
      p_dist_no   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE populate_dist_and_ri_tables (
      p_par_id        gipi_wpolbas.par_id%TYPE,
      p_dist_no       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   giuw_wperilds.dist_seq_no%TYPE,
      p_line_cd       giuw_wperilds.line_cd%TYPE,
      p_peril_cd      giuw_wperilds.peril_cd%TYPE,
      p_subline_cd    gipi_wpolbas.subline_cd%TYPE,
      p_pol_flag      gipi_wpolbas.pol_flag%TYPE,
      p_par_type      gipi_parlist.par_type%TYPE
   );

   PROCEDURE check_peril_distribution_error (
      p_dist_no     IN       giuw_pol_dist.dist_no%TYPE,
      p_msg_alert   OUT      VARCHAR2
   );

   PROCEDURE create_par_dist_recs_giuws005 (
      p_dist_no         IN   giuw_pol_dist.dist_no%TYPE,
      p_par_id          IN   gipi_parlist.par_id%TYPE,
      p_line_cd         IN   gipi_parlist.line_cd%TYPE,
      p_subline_cd      IN   gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd          IN   gipi_wpolbas.iss_cd%TYPE,
      p_pack_pol_flag   IN   gipi_wpolbas.pack_pol_flag%TYPE,
      p_pol_flag        IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_type        IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE adjust_pol_lvl_amts_giuws005 (
      p_dist_no   IN   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE create_par_distribution_recs4 (
      p_dist_no         IN   giuw_pol_dist.dist_no%TYPE,
      p_par_id          IN   gipi_parlist.par_id%TYPE,
      p_line_cd         IN   gipi_parlist.line_cd%TYPE,
      p_subline_cd      IN   gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd          IN   gipi_wpolbas.iss_cd%TYPE,
      p_pack_pol_flag   IN   gipi_wpolbas.pack_pol_flag%TYPE,
      p_pol_flag        IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_type        IN   gipi_parlist.par_type%TYPE,
      p_item_grp        IN   giuw_wpolicyds.item_grp%TYPE
   );

   PROCEDURE post_dist_giuws006 (
      p_par_id              IN       gipi_wpolbas.par_id%TYPE,
      p_dist_no             IN       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no         IN       giuw_wpolicyds.dist_seq_no%TYPE,
      p_module              IN       VARCHAR2,
      p_user_id             IN       giis_users.user_id%TYPE,
      p_current_form_name   IN       VARCHAR2,
      p_net_msg             OUT      VARCHAR2,
      p_treaty_msg          OUT      VARCHAR2,
      p_override_msg        OUT      VARCHAR2,
      p_net_override        OUT      VARCHAR2,
      p_treaty_override     OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2,
      p_dist_flag           OUT      VARCHAR2,
      p_mean_dist_flag      OUT      VARCHAR2,
      p_workflow_msgr       OUT      VARCHAR2,
      p_param_function      OUT      VARCHAR2
   );

   PROCEDURE create_grp_dflt_dist_giuws005 (
      p_dist_no          IN       giuw_wpolicyds.dist_no%TYPE,
      p_dist_seq_no      IN       giuw_wpolicyds.dist_seq_no%TYPE,
      p_dist_flag        IN       giuw_wpolicyds.dist_flag%TYPE,
      p_policy_tsi       IN       giuw_wpolicyds.tsi_amt%TYPE,
      p_policy_premium   IN       giuw_wpolicyds.prem_amt%TYPE,
      p_policy_ann_tsi   IN       giuw_wpolicyds.ann_tsi_amt%TYPE,
      p_item_grp         IN       giuw_wpolicyds.item_grp%TYPE,
      p_line_cd          IN       giis_line.line_cd%TYPE,
      p_rg_count         IN OUT   NUMBER,
      p_default_no       IN       giis_default_dist.default_no%TYPE,   -- shan 06.20.2014
      p_default_type     IN       giis_default_dist.default_type%TYPE,
      p_dflt_netret_pct  IN       giis_default_dist.dflt_netret_pct%TYPE,  -- shan 06.20.2014
      p_currency_rt      IN       gipi_witem.currency_rt%TYPE,
      p_par_id           IN       gipi_parlist.par_id%TYPE,
      p_pol_flag         IN       gipi_wpolbas.pol_flag%TYPE,
      p_par_type         IN       gipi_parlist.par_type%TYPE,
      p_dist_exists      IN       VARCHAR2
   );

   PROCEDURE crt_grp_dflt_witemds_giuws005 (
      p_dist_no        IN   giuw_witemds_dtl.dist_no%TYPE,
      p_dist_seq_no    IN   giuw_witemds_dtl.dist_seq_no%TYPE,
      p_item_no        IN   giuw_witemds_dtl.item_no%TYPE,
      p_line_cd        IN   giuw_witemds_dtl.line_cd%TYPE,
      p_dist_tsi       IN   giuw_witemds_dtl.dist_tsi%TYPE,
      p_dist_prem      IN   giuw_witemds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi   IN   giuw_witemds_dtl.ann_dist_tsi%TYPE,
      p_rg_count       IN   NUMBER,
      p_default_no      IN       giis_default_dist.default_no%TYPE,   -- shan 06.20.2014
      p_default_type    IN       giis_default_dist.default_type%TYPE,   -- shan 06.20.2014
      p_dflt_netret_pct IN       giis_default_dist.dflt_netret_pct%TYPE,  -- shan 06.20.2014
      p_item_grp        IN       gipi_witem.item_grp%TYPE,              -- shan 06.20.2014
      p_currency_rt      IN       gipi_witem.currency_rt%TYPE,      -- shan 06.20.2014
      p_pol_flag       IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id         IN   gipi_wpolbas.par_id%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE crt_grp_dflt_wperilds_giuws005 (
      p_dist_no        IN   giuw_wperilds_dtl.dist_no%TYPE,
      p_dist_seq_no    IN   giuw_wperilds_dtl.dist_seq_no%TYPE,
      p_line_cd        IN   giuw_wperilds_dtl.line_cd%TYPE,
      p_peril_cd       IN   giuw_wperilds_dtl.peril_cd%TYPE,
      p_dist_tsi       IN   giuw_wperilds_dtl.dist_tsi%TYPE,
      p_dist_prem      IN   giuw_wperilds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi   IN   giuw_wperilds_dtl.ann_dist_tsi%TYPE,
      p_rg_count       IN   NUMBER,
      p_default_no      IN       giis_default_dist.default_no%TYPE,   -- shan 06.20.2014
      p_default_type    IN       giis_default_dist.default_type%TYPE,   -- shan 06.20.2014
      p_dflt_netret_pct IN       giis_default_dist.dflt_netret_pct%TYPE,  -- shan 06.20.2014
      p_item_grp        IN       gipi_witem.item_grp%TYPE,              -- shan 06.20.2014
      p_currency_rt      IN       gipi_witem.currency_rt%TYPE,      -- shan 06.20.2014
      p_pol_flag       IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id         IN   gipi_wpolbas.par_id%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE ct_grp_dflt_witmperld_giuws005 (
      p_dist_no        IN   giuw_witemperilds_dtl.dist_no%TYPE,
      p_dist_seq_no    IN   giuw_witemperilds_dtl.dist_seq_no%TYPE,
      p_item_no        IN   giuw_witemperilds_dtl.item_no%TYPE,
      p_line_cd        IN   giuw_witemperilds_dtl.line_cd%TYPE,
      p_peril_cd       IN   giuw_witemperilds_dtl.peril_cd%TYPE,
      p_dist_tsi       IN   giuw_witemperilds_dtl.dist_tsi%TYPE,
      p_dist_prem      IN   giuw_witemperilds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi   IN   giuw_witemperilds_dtl.ann_dist_tsi%TYPE,
      p_rg_count       IN   NUMBER,
      p_default_no      IN       giis_default_dist.default_no%TYPE,   -- shan 06.20.2014
      p_default_type    IN       giis_default_dist.default_type%TYPE,   -- shan 06.20.2014
      p_dflt_netret_pct IN       giis_default_dist.dflt_netret_pct%TYPE,  -- shan 06.20.2014
      p_item_grp        IN       gipi_witem.item_grp%TYPE,              -- shan 06.20.2014
      p_currency_rt      IN       gipi_witem.currency_rt%TYPE,      -- shan 06.20.2014
      p_pol_flag       IN   gipi_wpolbas.pol_flag%TYPE,
      p_par_id         IN   gipi_wpolbas.par_id%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE
   );

   PROCEDURE upd_dtls_no_share_cd_giuws005 (
      p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   IN   giuw_wpolicyds.dist_seq_no%TYPE,
      p_type          IN   VARCHAR2,
      p_line_cd       IN   gipi_wpolbas.line_cd%TYPE
   );

   PROCEDURE ct_grp_dflt_wpolicyds_giuws005 (
      p_dist_no         IN       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no     IN       giuw_wpolicyds_dtl.dist_seq_no%TYPE,
      p_line_cd         IN       giuw_wpolicyds_dtl.line_cd%TYPE,
      p_dist_tsi        IN       giuw_wpolicyds_dtl.dist_tsi%TYPE,
      p_dist_prem       IN       giuw_wpolicyds_dtl.dist_prem%TYPE,
      p_ann_dist_tsi    IN       giuw_wpolicyds_dtl.ann_dist_tsi%TYPE,
      p_rg_count        IN OUT   NUMBER,
      p_default_no      IN       giis_default_dist.default_no%TYPE,   -- shan 06.20.2014
      p_default_type    IN       giis_default_dist.default_type%TYPE,
      p_dflt_netret_pct IN       giis_default_dist.dflt_netret_pct%TYPE,  -- shan 06.20.2014
      p_currency_rt     IN       gipi_witem.currency_rt%TYPE,
      p_par_id          IN       gipi_parlist.par_id%TYPE,
      p_item_grp        IN       gipi_witem.item_grp%TYPE,
      p_pol_flag        IN       gipi_wpolbas.pol_flag%TYPE,
      p_par_type        IN       gipi_parlist.par_type%TYPE
   );

   PROCEDURE post_dist_with_val_giuws005 (
      p_par_id              IN       gipi_wpolbas.par_id%TYPE,
      p_dist_no             IN       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no         IN       giuw_wpolicyds.dist_seq_no%TYPE,
      p_module              IN       VARCHAR2,
      p_user_id             IN       giis_users.user_id%TYPE,
      p_current_form_name   IN       VARCHAR2,
	  p_override_switch     IN       VARCHAR2, -- added by: shan 05.29.2014
      p_net_msg             OUT      VARCHAR2,
      p_treaty_msg          OUT      VARCHAR2,
      p_override_msg        OUT      VARCHAR2,
      p_net_override        OUT      VARCHAR2,
      p_treaty_override     OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2,
      p_dist_flag           OUT      VARCHAR2,
      p_mean_dist_flag      OUT      VARCHAR2,
      p_workflow_msgr       OUT      VARCHAR2,
      p_param_function      OUT      VARCHAR2
   );

   PROCEDURE post_wpolicyds_dtl_giuws005 (
      p_dist_no              giuw_pol_dist.dist_no%TYPE,
      p_par_type             gipi_parlist.par_type%TYPE,
      p_nbt_eff_date         gipi_wpolbas.eff_date%TYPE,
      p_msg_alert      OUT   VARCHAR2
   );

   PROCEDURE post_witemds_dtl_giuws005 (p_dist_no giuw_pol_dist.dist_no%TYPE);

   PROCEDURE post_witemperilds_dtl_giuws005 (
      p_dist_no   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE post_wperilds_dtl_giuws005 (p_dist_no giuw_pol_dist.dist_no%TYPE);

   FUNCTION get_giuw_pol_dist1 (p_par_id giuw_pol_dist.par_id%TYPE)
      RETURN giuw_pol_dist_tab PIPELINED;

   FUNCTION get_giuw_pol_dist1 (
      p_par_id    giuw_pol_dist.par_id%TYPE,
      p_dist_no   giuw_pol_dist.dist_no%TYPE
   )
      RETURN giuw_pol_dist_tab PIPELINED;

   FUNCTION check_if_posted (p_dist_no giuw_pol_dist.dist_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_pack_giuw_pol_dist (
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE
   )
      RETURN giuw_pol_dist_tab PIPELINED;

   FUNCTION get_pack_giuw_pol_dist1 (
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE
   )
      RETURN giuw_pol_dist_tab PIPELINED;

   FUNCTION get_giuw_pol_dist_giuws013 (
      p_par_id      giuw_pol_dist.par_id%TYPE,
      p_policy_id   gipi_invoice.policy_id%TYPE,
	  p_dist_no   giuw_pol_dist.dist_no%TYPE
   )
      RETURN giuw_pol_dist_tab PIPELINED;

   PROCEDURE post_dist_giuws013 (
      p_policy_id             giuw_pol_dist.policy_id%TYPE,
      p_dist_no               giuw_pol_dist.dist_no%TYPE,
      p_endt_seq_no           gipi_polbasic_pol_dist_v1.endt_seq_no%TYPE,
      p_eff_date              gipi_polbasic_pol_dist_v1.eff_date%TYPE,
      p_batch_id        IN OUT   giuw_pol_dist.batch_id%TYPE,
      p_line_cd               gipi_polbasic_pol_dist_v1.line_cd%TYPE,
      p_subline_cd            gipi_polbasic_pol_dist_v1.subline_cd%TYPE,
      p_iss_cd                gipi_polbasic_pol_dist_v1.iss_cd%TYPE,
      p_issue_yy              gipi_polbasic_pol_dist_v1.issue_yy%TYPE,
      p_pol_seq_no            gipi_polbasic_pol_dist_v1.pol_seq_no%TYPE,
      p_renew_no              gipi_polbasic_pol_dist_v1.renew_no%TYPE,
      p_dist_seq_no           giuw_wpolicyds.dist_seq_no%TYPE,
      p_facul_sw              VARCHAR2,
      p_workflow_msgr   OUT   VARCHAR2,
      p_message         OUT   VARCHAR2
   );
   
   PROCEDURE pre_post_giuws013 (
   p_policy_id            giuw_pol_dist.policy_id%TYPE,
   p_dist_no              giuw_pol_dist.dist_no%TYPE,
   p_facul_sw       OUT   VARCHAR2,
   p_facul_share    OUT   giuw_wpolicyds_dtl_pkg.giuw_facul_share_dtl_cur,
   p_facul_share2   OUT   giuw_wpolicyds_dtl_pkg.giuw_facul_share_dtl_cur,
   p_message        OUT   VARCHAR2,
   p_count          OUT   NUMBER,
   p_exist          OUT   VARCHAR2,
   p_old_dist_no    OUT   NUMBER
);

PROCEDURE post_form_commit_giuws013 (
	  p_policy_id     giuw_pol_dist.par_id%TYPE,
      p_dist_no       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds.dist_seq_no%TYPE,
      p_batch_id      giuw_pol_dist.batch_id%TYPE,
      p_batch_dist_sw  VARCHAR2        -- shan 08.11.2014
   );
   
   PROCEDURE ADJUST_DTL_AMTS_GIUWS012(p_dist_no		GIUW_POL_DIST.dist_no%TYPE);
   
   PROCEDURE adjust_net_ret_imperfection4 (p_dist_no   IN   giuw_pol_dist.dist_no%TYPE);
   
   PROCEDURE post_form_commit_giuws012 (
	  p_policy_id	  				gipi_polbasic.policy_id%TYPE,
      p_dist_no       				giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   				giuw_wperilds.dist_seq_no%TYPE,
      p_line_cd       				giuw_wperilds.line_cd%TYPE,
      p_peril_cd      				giuw_wperilds.peril_cd%TYPE,
      p_batch_id	  				giuw_pol_dist.batch_id%TYPE,
      p_post_sw       				VARCHAR2,
	  p_user_id		  				giuw_pol_dist.user_id%TYPE
   );
   
   FUNCTION get_giuw_pol_dist_giuts002 (
      p_par_id      giuw_pol_dist.par_id%TYPE,
      p_policy_id   gipi_invoice.policy_id%TYPE,
	  p_dist_no   giuw_pol_dist.dist_no%TYPE
   )
      RETURN giuw_pol_dist_tab PIPELINED;
      
   FUNCTION get_giuw_pol_dist_giuws016 (
      p_policy_id   GIUW_POL_DIST.policy_id%TYPE,
      p_dist_no     GIUW_POL_DIST.dist_no%TYPE,
      p_par_type    GIPI_POLBASIC_POL_DIST_V1.par_type%TYPE,
      p_pol_flag    GIPI_POLBASIC_POL_DIST_V1.pol_flag%TYPE
   )
    RETURN giuw_pol_dist_tab PIPELINED;
   
    FUNCTION get_giuw_pol_dist_giuws017(
        p_policy_id         GIUW_POL_DIST.policy_id%TYPE,
        p_dist_no           GIUW_POL_DIST.dist_no%TYPE,
        p_pol_flag          gipi_wpolbas.pol_flag%TYPE,
        p_par_type          gipi_parlist.par_type%TYPE)  
    RETURN giuw_pol_dist_tab PIPELINED;
    
    PROCEDURE negate_distribution (
        p_policy_id         IN   NUMBER,
        p_dist_no           IN   NUMBER,
        p_line_cd           IN   VARCHAR2,
        p_temp_distno       OUT  NUMBER,
        p_msg               OUT  VARCHAR2,
        p_current_form_name IN   VARCHAR2,
        p_par_id            IN   VARCHAR2,
        p_workflow_msgr     OUT  VARCHAR2,
        p_user_id           IN   VARCHAR2
    );
    
    PROCEDURE neg_pol_dist (
        p_dist_no      IN giuw_pol_dist.dist_no%TYPE,
        p_temp_distno  IN giuw_pol_dist.dist_no%TYPE
    );
    
    PROCEDURE POLICY_NEGATED_CHECK_GIUWS012(p_facul_sw          IN OUT VARCHAR2,
                                        p_policy_id         IN     GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                        p_dist_no           IN     GIUW_POL_DIST.dist_no%TYPE,
                                        p_line_cd           IN     GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                        p_subline_cd        IN     GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE);
                                        
    PROCEDURE post_wpolicyds_dtl_giuws012(p_dist_no         GIUW_POL_DIST.dist_no%TYPE,
                                      p_endt_seq_no         GIPI_POLBASIC_POL_DIST_V1.endt_seq_no%TYPE,
                                      p_eff_date        GIPI_POLBASIC_POL_DIST_V1.eff_date%TYPE,
                                      p_message         OUT VARCHAR2);
                                      
    PROCEDURE DELETE_DIST_WORKING_TABLES_2(p_dist_no GIUW_POL_DIST.dist_no%TYPE);
    
    PROCEDURE delete_dist_spct1_giuws012(p_dist_no GIUW_POL_DIST.dist_no%TYPE);
    
    PROCEDURE post_dist_giuws012(p_policy_id       IN     GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                               p_dist_no           IN     GIUW_POL_DIST.dist_no%TYPE,
                               p_par_id            IN     GIUW_POL_DIST.par_id%TYPE,
                               p_line_cd           IN     GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                               p_subline_cd        IN     GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
                               p_iss_cd            IN     GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
                               p_issue_yy          IN     GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
                               p_pol_seq_no        IN     GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
                               p_renew_no          IN     GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
                               p_endt_seq_no       IN     GIPI_POLBASIC_POL_DIST_V1.endt_seq_no%TYPE,
                               p_eff_date          IN     GIPI_POLBASIC_POL_DIST_V1.eff_date%TYPE,
                               p_batch_id          IN     GIUW_POL_DIST.batch_id%TYPE,
                               p_message              OUT VARCHAR2,
                               p_workflow_msgr        OUT VARCHAR2,
                               p_v_facul_sw           OUT VARCHAR2);
                               
   FUNCTION get_dist_flag_and_batch_id (p_policy_id     GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                        p_dist_no       GIUW_POL_DIST.dist_no%TYPE)
     RETURN giuws012_post_query_tab PIPELINED;     
     
    PROCEDURE VALIDATE_EXISTING_DIST(
        p_dist_no                IN giuw_pol_dist.dist_no%TYPE,
        p_policy_id              IN giuw_pol_dist.policy_id%TYPE,
        p_enabled_btn_sw        OUT VARCHAR2
        );
        
    PROCEDURE NEG_POL_DIST_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                    p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                    p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                    p_v_ratio          IN OUT NUMBER,
                                    p_v_post_flag      IN OUT VARCHAR2,
                                    p_nbt_rdate        IN     DATE,
                                    p_expiry_date      IN     DATE,
                                    p_eff_date         IN     DATE);
                                    
    PROCEDURE post_wpolicyds_dtl_giuts021(p_dist_no              giuw_pol_dist.dist_no%TYPE);
    
    PROCEDURE post_witemperilds_dtl_giuts021(p_dist_no   giuw_pol_dist.dist_no%TYPE);
    
    PROCEDURE NEGATE_DISTRIBUTION_GIUTS021(p_policy_id        IN     GIPI_POLBASIC.policy_id%TYPE,
                                  p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_neg_distno       IN     GIUW_POL_DIST.dist_no%TYPE,
                                  p_renew_flag       IN     GIPI_POLBASIC.renew_flag%TYPE,
                                  p_nbt_rdate        IN     VARCHAR2,
                                  p_expiry_date      IN     VARCHAR2,
                                  p_eff_date         IN     VARCHAR2,
                                  p_line_cd          IN     GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                  p_subline_cd       IN     GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
                                  p_msg_alert           OUT VARCHAR2);
    
    PROCEDURE ADJUST_WITMPRLDS_DTL(p_dist_no       giuw_pol_dist.dist_no%TYPE);
    
    PROCEDURE cmpr_gipi_witmperl_vs_mstrtbls (
        p_par_id        IN  gipi_parlist.par_id%TYPE,
        p_dist_no       IN  giuw_pol_dist.dist_no%TYPE,
        p_msg_alert     OUT VARCHAR2
        );
        
    PROCEDURE adjust_dist_prem_GIUWS004 (
        p_par_id    IN giuw_pol_dist.par_id%TYPE,
        p_dist_no   IN giuw_pol_dist.dist_no%TYPE
        );  
    
    PROCEDURE adjust_all_wtables_GIUWS004 (
        p_dist_no   IN giuw_pol_dist.dist_no%TYPE
        ); 
        
    PROCEDURE get_dist_spct1 (
        p_dist_no       IN  giuw_pol_dist.dist_no%TYPE,
        p_exist         OUT VARCHAR2
        );        
        
    PROCEDURE update_dist_spct1_to_null (
        p_dist_no   IN giuw_pol_dist.dist_no%TYPE
        );         
    
    PROCEDURE compare_del_rinsrt_wdist_table (
       p_dist_no   IN   giuw_pol_dist.dist_no%TYPE
    );
    
    PROCEDURE compare_wdist_table (
      p_dist_no             IN       giuw_pol_dist.dist_no%TYPE,
      p_par_id              IN       gipi_wpolbas.par_id%TYPE
    );    
    
    TYPE wpolbas_type IS RECORD(
        line_cd         gipi_wpolbas.LINE_CD%type,
        line_name       giis_line.LINE_NAME%type,
        subline_cd      gipi_wpolbas.SUBLINE_CD%type,
        iss_cd          gipi_wpolbas.ISS_CD%type,
        issue_yy        gipi_wpolbas.ISSUE_YY%type,
        pol_seq_no      gipi_wpolbas.POL_SEQ_NO%type,
        renew_no        gipi_wpolbas.RENEW_NO%type,
        eff_date        gipi_wpolbas.EFF_DATE%type,
        endt_seq_no     gipi_wpolbas.ENDT_SEQ_NO%type
    );
    
    TYPE wpolbas_tab IS TABLE OF wpolbas_type;
    
    FUNCTION get_wpolbas_dtl_GIUWS005(
        p_par_id        gipi_wpolbas.PAR_ID%type
    ) RETURN wpolbas_tab PIPELINED;
    
    -- shan 06.10.2014
    PROCEDURE check_null_dist_prem_GIUWS006(
        p_dist_no   IN  GIUW_POL_DIST.DIST_NO%type,
        p_btn_sw    IN  VARCHAR2,
        p_counter   OUT VARCHAR2
    );
    
    PROCEDURE populate_witem_pl_dtl_giuws006 (
        p_dist_no   giuw_pol_dist.dist_no%TYPE
    ); 
    
    PROCEDURE populate_witem_peril_giuws006 (
        p_dist_no   giuw_pol_dist.dist_no%TYPE
    );
    
    FUNCTION check_sum_insrd_prem_giuws006(
        p_dist_no   giuw_pol_dist.DIST_NO%type
    )RETURN VARCHAR2;
    
    PROCEDURE validate_b4_post_GIUWS006(
        p_dist_no   giuw_pol_dist.DIST_NO%type,
        p_par_id    giuw_pol_dist.PAR_ID%type
    );
    
    PROCEDURE post_wpolicyds_dtl_giuws006 (
      p_dist_no              giuw_pol_dist.dist_no%TYPE,
      p_par_type             gipi_parlist.par_type%TYPE,
      p_nbt_eff_date         gipi_wpolbas.eff_date%TYPE,
      p_msg_alert      OUT   VARCHAR2
   );
   
    PROCEDURE post_witemds_dtl_giuws006 (
        p_dist_no giuw_pol_dist.dist_no%TYPE
    );
    
    PROCEDURE post_witemperilds_dtl_giuws006 (
        p_dist_no giuw_pol_dist.dist_no%TYPE
    );
            
   PROCEDURE post_dist_giuws003_final (
      p_par_id              IN       gipi_wpolbas.par_id%TYPE,
      p_dist_no             IN       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no         IN       giuw_wpolicyds.dist_seq_no%TYPE,
      p_module              IN       VARCHAR2,
      p_user_id             IN       giis_users.user_id%TYPE,
      p_current_form_name   IN       VARCHAR2,
      p_net_msg             OUT      VARCHAR2,
      p_treaty_msg          OUT      VARCHAR2,
      p_override_msg        OUT      VARCHAR2,
      p_net_override        OUT      VARCHAR2,
      p_treaty_override     OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2,
      p_dist_flag           OUT      VARCHAR2,
      p_mean_dist_flag      OUT      VARCHAR2,
      p_workflow_msgr       OUT      VARCHAR2,
      p_param_function      OUT      VARCHAR2      
   );    

    PROCEDURE compareDel_rinsrt_wdist_table4 (
       p_dist_no   IN   giuw_pol_dist.dist_no%TYPE
    );   

    PROCEDURE cmpareDel_rinsrt_wdist_tbl_1_4 (
       p_dist_no   IN   giuw_pol_dist.dist_no%TYPE
    );     
    
    PROCEDURE post_dist_giuws006_final (
      p_par_id              IN       gipi_wpolbas.par_id%TYPE,
      p_dist_no             IN       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no         IN       giuw_wpolicyds.dist_seq_no%TYPE,
      p_module              IN       VARCHAR2,
      p_user_id             IN       giis_users.user_id%TYPE,
      p_current_form_name   IN       VARCHAR2,
      p_net_msg             OUT      VARCHAR2,
      p_treaty_msg          OUT      VARCHAR2,
      p_override_msg        OUT      VARCHAR2,
      p_net_override        OUT      VARCHAR2,
      p_treaty_override     OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2,
      p_dist_flag           OUT      VARCHAR2,
      p_mean_dist_flag      OUT      VARCHAR2,
      p_workflow_msgr       OUT      VARCHAR2,
      p_param_function      OUT      VARCHAR2
   );
   
   PROCEDURE compare_wdist_table_for_policy (
      p_dist_no             IN       giuw_pol_dist.dist_no%TYPE,
      p_policy_id           IN       gipi_polbasic.policy_id%TYPE
   );
   
   PROCEDURE val_renum_items (
      p_policy_id   VARCHAR2,
      p_dist_no     VARCHAR2
   );
   
   
   PROCEDURE post_dist_giuws005_final (
      p_par_id              IN       gipi_wpolbas.par_id%TYPE,
      p_dist_no             IN       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no         IN       giuw_wpolicyds.dist_seq_no%TYPE,
      p_module              IN       VARCHAR2,
      p_user_id             IN       giis_users.user_id%TYPE,
      p_current_form_name   IN       VARCHAR2,
	  p_override_switch     IN       VARCHAR2, -- added by: shan 05.29.2014
      p_net_msg             OUT      VARCHAR2,
      p_treaty_msg          OUT      VARCHAR2,
      p_override_msg        OUT      VARCHAR2,
      p_net_override        OUT      VARCHAR2,
      p_treaty_override     OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2,
      p_dist_flag           OUT      VARCHAR2,
      p_mean_dist_flag      OUT      VARCHAR2,
      p_workflow_msgr       OUT      VARCHAR2,
      p_param_function      OUT      VARCHAR2
   );
   
   PROCEDURE pre_post_dist_giuws012(
      p_dist_no                     GIUW_WPOLICYDS.dist_no%TYPE,
      p_policy_id                   GIPI_POLBASIC.policy_id%TYPE
   );
   
   PROCEDURE check_posted_binder (
      p_par_id          IN  giuw_pol_dist.par_id%TYPE,
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_process         IN  VARCHAR2,
      p_alert          OUT  VARCHAR2
   );
   
   PROCEDURE limit_validation2 (
      p_par_id              gipi_parlist.par_id%TYPE,
      p_line_cd             gipi_polbasic.line_cd%TYPE,
      v_block         OUT   VARCHAR2,
      v_type_exceed   OUT   VARCHAR2,
      v_share_type          giis_dist_share.share_type%TYPE,
      v_eff_date            giuw_pol_dist.eff_date%TYPE,
      v_dist_spct           giuw_wpolicyds_dtl.dist_spct%TYPE,
      p_count         OUT   NUMBER
   );
   
    PROCEDURE ca_limit_validation2 (
       p_par_id              gipi_parlist.par_id%TYPE,
       p_line_cd             gipi_polbasic.line_cd%TYPE,
       v_loc           OUT   VARCHAR2,
       v_type_exceed   OUT   VARCHAR2,
       v_share_type          giis_dist_share.share_type%TYPE,
       v_eff_date            giuw_pol_dist.eff_date%TYPE,
       v_dist_spct           giuw_wpolicyds_dtl.dist_spct%TYPE,
       p_count         OUT   NUMBER
    );
    
    FUNCTION is_peril_group_share_diff (p_dist_no    NUMBER)
       RETURN VARCHAR2;
       
    PROCEDURE delete_binder_working_tables (
        p_dist_no giuw_pol_dist.dist_no%TYPE
    ); 
    
    PROCEDURE delete_missing_shares (
        p_dist_no giuw_pol_dist.dist_no%TYPE
    );
    
    PROCEDURE pre_val_neg_dist (
        p_policy_id gipi_polbasic.policy_id%TYPE,
        p_dist_no   giuw_pol_dist.dist_no%TYPE
    );   
    
    PROCEDURE ADJUST_DIST_TABLES_GIUTS021 (
        p_dist_no       IN  giuw_pol_dist.dist_no%TYPE,
        p_temp_dist_no  IN  giuw_pol_dist.dist_no%TYPE,
        p_policy_id     IN  giuw_pol_dist.policy_id%TYPE
    );     
    
    PROCEDURE update_gpd_giuts021 (
       p_policy_id     IN   gipi_polbasic.policy_id%TYPE,
       p_neg_dist_no   IN   giuw_pol_dist.dist_no%TYPE,
       p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
       p_temp_distno   IN   giuw_pol_dist.dist_no%TYPE
    );
    
    PROCEDURE validate_takeup_giuts021 (p_policy_id IN gipi_polbasic.policy_id%TYPE);
    
    PROCEDURE delete_bond_dist (p_par_id giuw_pol_dist.par_id%TYPE);
    --added by robert SR 5053 11.11.15
    PROCEDURE validate_dist_wperildtl(
        p_dist_no           giuw_pol_dist.DIST_NO%type,
        p_message   OUT     VARCHAR2
    );
    
    PROCEDURE validate_wrking_tbls_amts(
        p_dist_no           giuw_pol_dist.DIST_NO%type,
        p_message   OUT     VARCHAR2
    );
    
    -- added new procedures by jhing 04.06.2016 REPUBLICFULLWEB 21797
    PROCEDURE populate_oth_tbls_one_risk (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE 
    );    
    
    PROCEDURE populate_oth_tbls_peril_dist (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE 
    ); 

    PROCEDURE insert_setup_dflt_peril_values (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no     IN  giuw_policyds.dist_seq_no%TYPE ,
      p_rg_count        IN  NUMBER ,
      p_default_no      IN  giis_default_dist.default_no%TYPE ,
      p_default_type    IN  giis_default_dist.default_type%TYPE,
      p_line_cd         IN  giis_line.line_cd%TYPE ,
      p_peril_cd        IN  giis_peril.peril_cd%TYPE,
      p_tsi_amt         IN  giuw_policyds.tsi_amt%TYPE,
      p_prem_amt        IN  giuw_policyds.prem_amt%TYPE,
      p_ann_tsi_amt     IN  giuw_policyds.ann_tsi_amt%TYPE,
      p_currency_rt     IN  gipi_item.currency_rt%TYPE
    );     
    
    PROCEDURE get_default_dist_params (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_par_id          IN OUT giuw_pol_dist.par_id%TYPE,
      p_post_flag       OUT giuw_pol_dist.post_flag%TYPE,
      p_line_cd         IN OUT giis_default_dist.line_cd%TYPE ,
      p_default_no      OUT giis_default_dist.default_no%TYPE , 
      p_dist_type       OUT giis_default_dist.dist_type%TYPE , 
      p_default_type    OUT giis_default_dist.default_type%TYPE,
      p_orig_dist_no    OUT giuw_pol_dist.dist_no%TYPE 
    ); 

    PROCEDURE populate_default_dist (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_post_flag       IN OUT giuw_pol_dist.post_flag%TYPE ,
      p_dist_type       IN OUT giuw_pol_dist.dist_type%TYPE
    ); 
    
    PROCEDURE CRTE_PRELIM_REGRPED_DIST_RECS
         (p_dist_no       IN giuw_pol_dist.dist_no%TYPE    ,
          p_par_id        IN gipi_parlist.par_id%TYPE  ,
          p_line_cd       IN gipi_parlist.line_cd%TYPE    ,
          p_subline_cd    IN gipi_wpolbas.subline_cd%TYPE ,
          p_iss_cd        IN gipi_wpolbas.iss_cd%TYPE     ,
          p_pack_pol_flag IN gipi_wpolbas.pack_pol_flag%TYPE);     
          
    PROCEDURE RECRTE_GRP_DFLT_DIST_DS
        (p_dist_no        IN    GIUW_WPOLICYDS.dist_no%TYPE,
         p_dist_seq_no    IN    GIUW_WPOLICYDS.dist_seq_no%TYPE,
         p_dist_flag      IN    GIUW_WPOLICYDS.dist_flag%TYPE,
         p_policy_tsi     IN    GIUW_WPOLICYDS.tsi_amt%TYPE,
         p_policy_premium IN    GIUW_WPOLICYDS.prem_amt%TYPE,
         p_policy_ann_tsi IN    GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
         p_item_grp       IN    GIUW_WPOLICYDS.item_grp%TYPE,
         p_line_cd        IN    GIIS_LINE.line_cd%TYPE,
         p_rg_count       IN OUT NUMBER,
         p_default_type   IN    GIIS_DEFAULT_DIST.default_type%TYPE,
         p_currency_rt    IN    GIPI_ITEM.currency_rt%TYPE,
         p_par_id         IN    GIPI_WPOLBAS.par_id%TYPE,
         p_v_default_no   IN    GIIS_DEFAULT_DIST.default_no%TYPE);  
         
        PROCEDURE val_sequential_distGrp (
          p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
          p_module_id       IN giis_modules.module_id%TYPE,
          p_result          OUT VARCHAR2
        );   
            
        PROCEDURE val_multipleBillGrp_perDist (
          p_dist_no         IN giuw_pol_dist.dist_no%TYPE , 
          p_par_id          IN gipi_parlist.par_id%TYPE,
          p_result          OUT VARCHAR2
        );   
           
        PROCEDURE check_missing_dist_rec_item (
          p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
          p_par_id          IN gipi_parlist.par_id%TYPE,
          p_result          OUT VARCHAR2
        ) ;                                
        
END giuw_pol_dist_pkg;
/


