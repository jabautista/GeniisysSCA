CREATE OR REPLACE PACKAGE CPI.gipis130_pkg
AS
   TYPE giuw_pol_dist_polbasic_type IS RECORD (
      policy_no             VARCHAR2 (50),
      endt_no               VARCHAR2 (50),
      status                VARCHAR2 (50),
      dist_no               giuw_pol_dist_polbasic_v.dist_no%TYPE,
      dist_flag             giuw_pol_dist_polbasic_v.dist_flag%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      p_user_id             giuw_pol_dist_polbasic_v.user_id%TYPE,
      incept_date           giuw_pol_dist_polbasic_v.incept_date%TYPE,
      expiry_date_polbas    giuw_pol_dist_polbasic_v.expiry_date_polbas%TYPE,
      policy_status         VARCHAR2 (50),
      acct_ent_date         giuw_pol_dist_polbasic_v.acct_ent_date%TYPE,
      acct_neg_date         giuw_pol_dist_polbasic_v.acct_neg_date%TYPE,
      issue_date            giuw_pol_dist_polbasic_v.issue_date%TYPE,
      eff_date              giuw_pol_dist_polbasic_v.eff_date%TYPE,
      expiry_date_poldist   giuw_pol_dist_polbasic_v.expiry_date_poldist%TYPE,
      negate_date           giuw_pol_dist_polbasic_v.negate_date%TYPE,
      last_upd_date         giuw_pol_dist_polbasic_v.last_upd_date%TYPE,
      user_id2              giuw_pol_dist_polbasic_v.user_id2%TYPE,
      line_cd               giuw_pol_dist_polbasic_v.line_cd%TYPE,
      subline_cd            giuw_pol_dist_polbasic_v.subline_cd%TYPE,
      iss_cd                giuw_pol_dist_polbasic_v.iss_cd%TYPE,
      issue_yy              giuw_pol_dist_polbasic_v.issue_yy%TYPE,
      pol_seq_no            giuw_pol_dist_polbasic_v.pol_seq_no%TYPE,
      renew_no              giuw_pol_dist_polbasic_v.renew_no%TYPE,
      par_id                giuw_pol_dist_polbasic_v.par_id%TYPE,
      iss_name              giis_issource.iss_name%TYPE,
      policy_id             giuw_pol_dist_polbasic_v.policy_id%TYPE,
	  post_flag             giuw_pol_dist.post_flag%TYPE --added by robert SR 4887 10.05.15
   );

   TYPE giuw_pol_dist_polbasic_tab IS TABLE OF giuw_pol_dist_polbasic_type;

   FUNCTION get_giuw_pol_dist_polbasic (
      p_branch_cd    giac_branches.branch_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_dist_tag     giuw_pol_dist_polbasic_v.dist_flag%TYPE,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_date_opt     VARCHAR2,
      p_user_id      giis_users.user_id%TYPE,
      p_policy_id    giuw_pol_dist_polbasic_v.policy_id%TYPE,
      --added by shan 06.06.2014
      p_subline_cd   giuw_pol_dist_polbasic_v.SUBLINE_CD%type,
      p_iss_cd       giuw_pol_dist_polbasic_v.ISS_CD%type,
      p_issue_yy     giuw_pol_dist_polbasic_v.ISSUE_YY%type,
      p_pol_seq_no   giuw_pol_dist_polbasic_v.POL_SEQ_NO%type,
      p_renew_no     giuw_pol_dist_polbasic_v.RENEW_NO%type,
	  --added by robert 20756 01.27.16
      p_dist_no      giuw_pol_dist_polbasic_v.DIST_NO%type,
      p_endt_iss_cd  giuw_pol_dist_polbasic_v.ENDT_ISS_CD%type,
      p_endt_yy      giuw_pol_dist_polbasic_v.ENDT_YY%type,
      p_endt_seq_no  giuw_pol_dist_polbasic_v.ENDT_SEQ_NO%type
   )
      RETURN giuw_pol_dist_polbasic_tab PIPELINED;

   TYPE par_history_type IS RECORD (
      par_stat       VARCHAR2 (200),
      parstat_date   VARCHAR2 (200),
      user_id        VARCHAR2 (200)
   );

   TYPE par_history_tab IS TABLE OF par_history_type;

   FUNCTION get_par_history (p_par_id gipi_parhist.par_id%TYPE)
      RETURN par_history_tab PIPELINED;

   TYPE policy_ds_type IS RECORD (
      dist_no            giuw_wpolicyds_policyds_v.dist_no%TYPE,
      dist_seq_no        giuw_wpolicyds_policyds_v.dist_seq_no%TYPE,
      tsi_amt            giuw_wpolicyds_policyds_v.tsi_amt%TYPE,
      prem_amt           giuw_wpolicyds_policyds_v.prem_amt%TYPE,
      policy_no          VARCHAR2 (50),
      dist_flag          giuw_pol_dist_polbasic_v.dist_flag%TYPE,
      status             VARCHAR2 (50),
      dist_spct          giuw_wpolicyds_policyds_dtl_v.dist_spct%TYPE,
      dist_tsi           giuw_wpolicyds_policyds_dtl_v.dist_tsi%TYPE,
      dist_spct1         giuw_wpolicyds_policyds_dtl_v.dist_spct1%TYPE,
      dist_prem          giuw_wpolicyds_policyds_dtl_v.dist_prem%TYPE,
      trty_name          giis_dist_share.trty_name%TYPE,
      s_dist_spct        giuw_wpolicyds_policyds_dtl_v.dist_spct%TYPE,
      s_dist_tsi         giuw_wpolicyds_policyds_dtl_v.dist_tsi%TYPE,
      s_dist_spct1       giuw_wpolicyds_policyds_dtl_v.dist_spct1%TYPE,
      s_dist_prem        giuw_wpolicyds_policyds_dtl_v.dist_prem%TYPE,
      post_flag          giuw_pol_dist.post_flag%TYPE,
      peril_name         giis_peril.peril_name%TYPE,
      line_cd            giis_peril.line_cd%TYPE,
      peril_cd           giis_peril.peril_name%TYPE,
      placement_source   VARCHAR2 (20),
      binder_no          VARCHAR2 (50),
      ri_sname           giis_reinsurer.ri_sname%TYPE,
      ri_shr_pct         giri_frps_ri.ri_shr_pct%TYPE,
      ri_tsi_amt         giri_frps_ri.ri_tsi_amt%TYPE,
      ri_prem_amt        giri_frps_ri.ri_prem_amt%TYPE,
      sum_ri_shr_pct     giri_frps_ri.ri_shr_pct%TYPE,
      sum_ri_tsi_amt     giri_frps_ri.ri_tsi_amt%TYPE,
      sum_ri_prem_amt    giri_frps_ri.ri_prem_amt%TYPE,
	  item_no            giuw_witemds_itemds_v.item_no%TYPE --added by robert SR 4887 10.05.15
   );

   TYPE policy_ds_tab IS TABLE OF policy_ds_type;

   FUNCTION get_policy_ds (
      p_par_id          gipi_parhist.par_id%TYPE,
      p_dist_no         giuw_wpolicyds_policyds_v.dist_no%TYPE,
      p_dist_flag       giuw_pol_dist_polbasic_v.dist_flag%TYPE,
      p_policy_no       VARCHAR2,
      p_policy_status   VARCHAR2,
	  p_item_sw         VARCHAR2 --added by robert SR 4887 10.05.15
   )
      RETURN policy_ds_tab PIPELINED;

   FUNCTION get_policy_ds_dtl (
      p_dist_no       giuw_wpolicyds_policyds_v.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_policyds_v.dist_seq_no%TYPE
   )
      RETURN policy_ds_tab PIPELINED;

   FUNCTION get_policy_ds_dtl2 (
      p_dist_no       giuw_wpolicyds_policyds_v.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_policyds_v.dist_seq_no%TYPE,
      p_line_cd       giis_peril.line_cd%TYPE,
      p_peril_cd      giis_peril.peril_cd%TYPE,
      p_post_flag     VARCHAR2,
	  p_item_no       giuw_witmprlds_itmprlds_dtl_v.item_no%TYPE --added by robert SR 4887 10.05.15
   )
      RETURN policy_ds_tab PIPELINED;

   FUNCTION get_ri_placement (
      p_dist_no            giuw_wpolicyds_policyds_v.dist_no%TYPE,
      p_dist_seq_no        giuw_wpolicyds_policyds_v.dist_seq_no%TYPE,
      p_placement_source   VARCHAR2
   )
      RETURN policy_ds_tab PIPELINED;

   TYPE summarized_dist_type IS RECORD (
      trty_name       giuw_policyds_ext.trty_name%TYPE,
      tsi_spct        giuw_policyds_ext.tsi_spct%TYPE,
      dist_tsi        giuw_policyds_ext.dist_tsi%TYPE,
      prem_spct       giuw_policyds_ext.prem_spct%TYPE,
      dist_prem       giuw_policyds_ext.dist_prem%TYPE,
      tot_tsi_spct    giuw_policyds_ext.tsi_spct%TYPE,
      tot_dist_tsi    giuw_policyds_ext.dist_tsi%TYPE,
      tot_prem_spct   giuw_policyds_ext.prem_spct%TYPE,
      tot_dist_prem   giuw_policyds_ext.dist_prem%TYPE
   );

   TYPE summarized_dist_tab IS TABLE OF summarized_dist_type;

   FUNCTION get_summarized_dist (
      p_line_cd      giuw_policyds_ext.line_cd%TYPE,
      p_subline_cd   giuw_policyds_ext.subline_cd%TYPE,
      p_iss_cd       giuw_policyds_ext.iss_cd%TYPE,
      p_issue_yy     giuw_policyds_ext.issue_yy%TYPE,
      p_pol_seq_no   giuw_policyds_ext.pol_seq_no%TYPE,
      p_renew_no     giuw_policyds_ext.renew_no%TYPE
   )
      RETURN summarized_dist_tab PIPELINED;

   PROCEDURE call_extract_dist_gipis130 (
      p_line_cd        IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN       gipi_polbasic.renew_no%TYPE,
      p_extract_date   IN       giuw_pol_dist.eff_date%TYPE,
      p_message        OUT      VARCHAR2
   );

   FUNCTION on_load_summarized_dist (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN VARCHAR2;

   TYPE ri_placement_type IS RECORD (
      ri_cd             giri_distfrps_ext.ri_cd%TYPE,
      ri_sname          giri_distfrps_ext.ri_sname%TYPE,
      ri_shr_pct        giri_distfrps_ext.ri_shr_pct%TYPE,
      ri_tsi_amt        giri_distfrps_ext.ri_tsi_amt%TYPE,
      ri_prem_amt       giri_distfrps_ext.ri_prem_amt%TYPE,
      tot_ri_shr_pct    giri_distfrps_ext.ri_shr_pct%TYPE,
      tot_ri_tsi_amt    giri_distfrps_ext.ri_tsi_amt%TYPE,
      tot_ri_prem_amt   giri_distfrps_ext.ri_prem_amt%TYPE
   );

   TYPE ri_placement_tab IS TABLE OF ri_placement_type;

   FUNCTION get_ri_placement_tg (
      p_line_cd      giri_distfrps_ext.line_cd%TYPE,
      p_subline_cd   giri_distfrps_ext.subline_cd%TYPE,
      p_iss_cd       giri_distfrps_ext.iss_cd%TYPE,
      p_issue_yy     giri_distfrps_ext.issue_yy%TYPE,
      p_pol_seq_no   giri_distfrps_ext.pol_seq_no%TYPE,
      p_renew_no     giri_distfrps_ext.renew_no%TYPE
   )
      RETURN ri_placement_tab PIPELINED;

   TYPE binders_type IS RECORD (
      binder_no         VARCHAR2 (15),
      ri_name           giis_reinsurer.ri_name%TYPE,
      ri_shr_pct        giri_frps_ri.ri_shr_pct%TYPE,
      ri_tsi_amt        giri_frps_ri.ri_tsi_amt%TYPE,
      ri_prem_amt       giri_frps_ri.ri_prem_amt%TYPE,
      tot_ri_shr_pct    giri_frps_ri.ri_shr_pct%TYPE,
      tot_ri_tsi_amt    giri_frps_ri.ri_tsi_amt%TYPE,
      tot_ri_prem_amt   giri_frps_ri.ri_prem_amt%TYPE
   );

   TYPE binders_tab IS TABLE OF binders_type;

   FUNCTION get_binders_tg (
      p_ri_cd        giis_reinsurer.ri_cd%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN binders_tab PIPELINED;

   TYPE dist_item_type IS RECORD (
      policy_no   VARCHAR2 (50),
      item_no     giuw_itemds_ext.item_no%TYPE
   );

   TYPE dist_item_tab IS TABLE OF dist_item_type;

   FUNCTION get_dist_item_tg (
      p_line_cd      giuw_itemds_ext.line_cd%TYPE,
      p_subline_cd   giuw_itemds_ext.subline_cd%TYPE,
      p_iss_cd       giuw_itemds_ext.iss_cd%TYPE,
      p_issue_yy     giuw_itemds_ext.issue_yy%TYPE,
      p_pol_seq_no   giuw_itemds_ext.pol_seq_no%TYPE,
      p_renew_no     giuw_itemds_ext.renew_no%TYPE
   )
      RETURN dist_item_tab PIPELINED;

   TYPE dist_per_item_type IS RECORD (
      policy_no       VARCHAR2 (50),
      item_no         giuw_itemds_ext.item_no%TYPE,
      trty_name       giuw_itemds_ext.trty_name%TYPE,
      tsi_spct        giuw_itemds_ext.tsi_spct%TYPE,
      dist_tsi        giuw_itemds_ext.dist_tsi%TYPE,
      prem_spct       giuw_itemds_ext.prem_spct%TYPE,
      dist_prem       giuw_itemds_ext.dist_prem%TYPE,
      tot_tsi_spct    giuw_itemds_ext.tsi_spct%TYPE,
      tot_dist_tsi    giuw_itemds_ext.dist_tsi%TYPE,
      tot_prem_spct   giuw_itemds_ext.prem_spct%TYPE,
      tot_dist_prem   giuw_itemds_ext.dist_prem%TYPE
   );

   TYPE dist_per_item_tab IS TABLE OF dist_per_item_type;

   FUNCTION get_dist_per_item_tg (
      p_line_cd      giuw_itemds_ext.line_cd%TYPE,
      p_subline_cd   giuw_itemds_ext.subline_cd%TYPE,
      p_iss_cd       giuw_itemds_ext.iss_cd%TYPE,
      p_issue_yy     giuw_itemds_ext.issue_yy%TYPE,
      p_pol_seq_no   giuw_itemds_ext.pol_seq_no%TYPE,
      p_renew_no     giuw_itemds_ext.renew_no%TYPE,
      p_item_no      giuw_itemds_ext.item_no%TYPE
   )
      RETURN dist_per_item_tab PIPELINED;

   TYPE dist_peril_type IS RECORD (
      policy_no       VARCHAR2 (50),
      peril_cd        giuw_itemperilds_ext.peril_cd%TYPE,
      peril_name      giuw_itemperilds_ext.peril_name%TYPE,
      tot_dist_tsi    giuw_itemperilds_ext.dist_tsi%TYPE,
      tot_dist_prem   giuw_itemperilds_ext.dist_prem%TYPE
   );

   TYPE dist_peril_tab IS TABLE OF dist_peril_type;

   FUNCTION get_dist_peril_tg (
      p_line_cd      giuw_itemperilds_ext.line_cd%TYPE,
      p_subline_cd   giuw_itemperilds_ext.subline_cd%TYPE,
      p_iss_cd       giuw_itemperilds_ext.iss_cd%TYPE,
      p_issue_yy     giuw_itemperilds_ext.issue_yy%TYPE,
      p_pol_seq_no   giuw_itemperilds_ext.pol_seq_no%TYPE,
      p_renew_no     giuw_itemperilds_ext.renew_no%TYPE
   )
      RETURN dist_peril_tab PIPELINED;

   TYPE dist_per_peril_type IS RECORD (
      policy_no       VARCHAR2 (50),
      peril_name      giuw_itemperilds_ext.peril_name%TYPE,
      trty_name       giuw_itemperilds_ext.trty_name%TYPE,
      tsi_spct        giuw_itemperilds_ext.tsi_spct%TYPE,
      dist_tsi        giuw_itemperilds_ext.dist_tsi%TYPE,
      prem_spct       giuw_itemperilds_ext.prem_spct%TYPE,
      dist_prem       giuw_itemperilds_ext.dist_prem%TYPE,
      tot_tsi_spct    giuw_itemperilds_ext.tsi_spct%TYPE,
      tot_dist_tsi    giuw_itemperilds_ext.dist_tsi%TYPE,
      tot_prem_spct   giuw_itemperilds_ext.prem_spct%TYPE,
      tot_dist_prem   giuw_itemperilds_ext.dist_prem%TYPE
   );

   TYPE dist_per_peril_tab IS TABLE OF dist_per_peril_type;

   FUNCTION get_dist_per_peril_tg (
      p_line_cd      giuw_itemperilds_ext.line_cd%TYPE,
      p_subline_cd   giuw_itemperilds_ext.subline_cd%TYPE,
      p_iss_cd       giuw_itemperilds_ext.iss_cd%TYPE,
      p_issue_yy     giuw_itemperilds_ext.issue_yy%TYPE,
      p_pol_seq_no   giuw_itemperilds_ext.pol_seq_no%TYPE,
      p_renew_no     giuw_itemperilds_ext.renew_no%TYPE,
      p_peril_cd     giuw_itemperilds_ext.peril_cd%TYPE
   )
      RETURN dist_per_peril_tab PIPELINED;

   PROCEDURE insert_to_policyds_dtl (
      p_share_cd      NUMBER,
      p_dist_spct     NUMBER,
      p_dist_spct1    NUMBER,
      p_dist_no       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_dtl.dist_seq_no%TYPE,
      p_line_cd       giuw_policyds_ext.line_cd%TYPE
   );

   PROCEDURE insert_to_itemds_dtl (
      p_share_cd      NUMBER,
      p_dist_spct     NUMBER,
      p_dist_spct1    NUMBER,
      p_dist_no       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_dtl.dist_seq_no%TYPE,
      p_line_cd       giuw_policyds_ext.line_cd%TYPE
   );

   PROCEDURE insert_to_itemperilds_dtl (
      p_share_cd      NUMBER,
      p_dist_spct     NUMBER,
      p_dist_spct1    NUMBER,
      p_dist_no       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_dtl.dist_seq_no%TYPE
   );

   PROCEDURE insert_to_wperilds_dtl (
      p_share_cd      NUMBER,
      p_dist_spct     NUMBER,
      p_dist_spct1    NUMBER,
      p_dist_no       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_dtl.dist_seq_no%TYPE
   );

   PROCEDURE insert_summ_dist (
      p_line_cd       IN       giuw_policyds_ext.line_cd%TYPE,
      p_subline_cd    IN       giuw_policyds_ext.subline_cd%TYPE,
      p_iss_cd        IN       giuw_policyds_ext.iss_cd%TYPE,
      p_issue_yy      IN       giuw_policyds_ext.issue_yy%TYPE,
      p_pol_seq_no    IN       giuw_policyds_ext.pol_seq_no%TYPE,
      p_renew_no      IN       giuw_policyds_ext.renew_no%TYPE,
      p_dist_no       IN       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   IN       giuw_wpolicyds_dtl.dist_seq_no%TYPE,
      p_message       OUT      VARCHAR2
   );

   TYPE line_cd_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_cd_lov_tab IS TABLE OF line_cd_lov_type;

   FUNCTION get_linecd_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN line_cd_lov_tab PIPELINED;
END;
/


