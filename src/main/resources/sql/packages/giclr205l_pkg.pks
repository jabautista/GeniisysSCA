CREATE OR REPLACE PACKAGE CPI.giclr205l_pkg
AS
   TYPE header_type IS RECORD (
      company_name            giac_parameters.param_value_v%TYPE,
      company_address         giis_parameters.param_value_v%TYPE,
      report_name             giis_reports.report_title%TYPE,
      report_date             VARCHAR2 (100),
      buss_source_type        VARCHAR2 (2),
      buss_source_name        giis_intm_type.intm_desc%TYPE,
      iss_type                VARCHAR2 (2),
      buss_source             gicl_res_brdrx_extr.buss_source%TYPE,
      source_name             giis_intermediary.intm_name%TYPE,
      iss_cd                  giis_issource.iss_cd%TYPE,
      iss_name                giis_issource.iss_name%TYPE,
      line_cd                 giis_line.line_cd%TYPE,
      line_name               giis_line.line_name%TYPE,
      subline_cd              giis_subline.subline_cd%TYPE,
      subline_name            giis_subline.subline_name%TYPE,
      loss_year               gicl_res_brdrx_extr.loss_year%TYPE,
      trty_name               giis_dist_share.trty_name%TYPE,
      report_format_trigger   VARCHAR2 (10)
   );

   TYPE header_tab IS TABLE OF header_type;

   TYPE detail_type IS RECORD (
      brdrx_record_id    gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      buss_source        gicl_res_brdrx_extr.buss_source%TYPE,
      iss_cd             giis_issource.iss_cd%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      subline_cd         giis_subline.subline_cd%TYPE,
      loss_year          gicl_res_brdrx_extr.loss_year%TYPE,
      claim_id           gicl_res_brdrx_extr.claim_id%TYPE,
      claim_no           gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no          VARCHAR2 (60),
      assd_name          giis_assured.assd_name%TYPE,
      incept_date        gicl_res_brdrx_extr.incept_date%TYPE,
      expiry_date        gicl_res_brdrx_extr.expiry_date%TYPE,
      loss_date          gicl_res_brdrx_extr.loss_date%TYPE,
      item_no            gicl_res_brdrx_extr.item_no%TYPE,
      item_title         VARCHAR2 (2000),
      tsi_amt            gicl_res_brdrx_extr.tsi_amt%TYPE,
      peril_cd           gicl_res_brdrx_extr.peril_cd%TYPE,
      peril_name         giis_peril.peril_name%TYPE,
      intm_ri            VARCHAR2 (1000),
      outstanding_loss   gicl_res_brdrx_extr.loss_reserve%TYPE
   );

   TYPE detail_tab IS TABLE OF detail_type;

   TYPE treaty_header_type IS RECORD (
      iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE,
      line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      subline_cd    gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE,
      grp_seq_no    gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      treaty_name   giis_dist_share.trty_name%TYPE
   );

   TYPE treaty_header_tab IS TABLE OF treaty_header_type;

   TYPE treaty_detail_type IS RECORD (
      brdrx_record_id2        gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      grp_seq_no2             gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      buss_source2            gicl_res_brdrx_extr.buss_source%TYPE,
      iss_cd2                 giis_issource.iss_cd%TYPE,
      line_cd2                giis_line.line_cd%TYPE,
      subline_cd2             giis_subline.subline_cd%TYPE,
      loss_year2              gicl_res_brdrx_extr.loss_year%TYPE,
      treaty_name2            giis_dist_share.trty_name%TYPE,
      outstanding_loss2       gicl_res_brdrx_extr.loss_reserve%TYPE,
      outstanding_loss2_sum   gicl_res_brdrx_extr.loss_reserve%TYPE
   );

   TYPE treaty_detail_tab IS TABLE OF treaty_detail_type;

   TYPE treaty_facul_type IS RECORD (
      brdrx_ds_record_id2   gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE,
      brdrx_record_id2      gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      treaty_name2          giis_dist_share.trty_name%TYPE,
      grp_seq_no2           gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      facul_ri_cd2          gicl_res_brdrx_rids_extr.prnt_ri_cd%TYPE,
      facul_ri_name2        giis_reinsurer.ri_name%TYPE,
      outstanding_loss3     gicl_res_brdrx_extr.loss_reserve%TYPE
   );

   TYPE treaty_facul_tab IS TABLE OF treaty_facul_type;

   TYPE treaty_ri_type IS RECORD (
      brdrx_record_id        gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      brdrx_ds_record_id     gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE,
      buss_source            gicl_res_brdrx_extr.buss_source%TYPE,
      iss_cd                 giis_issource.iss_cd%TYPE,
      line_cd                giis_line.line_cd%TYPE,
      subline_cd             giis_subline.subline_cd%TYPE,
      loss_year              gicl_res_brdrx_extr.loss_year%TYPE,
      grp_seq_no             gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      trty_ri_cd             gicl_res_brdrx_rids_extr.prnt_ri_cd%TYPE,
      ri_cd                  gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      shr_ri_pct             gicl_res_brdrx_rids_extr.shr_ri_pct%TYPE,
      treaty_name2           giis_dist_share.trty_name%TYPE,
      ri_name                giis_reinsurer.ri_name%TYPE,
      ri_shr                 giis_trty_panel.trty_shr_pct%TYPE,
      buss_source2           gicl_res_brdrx_extr.buss_source%TYPE,
      iss_cd2                giis_issource.iss_cd%TYPE,
      line_cd2               giis_line.line_cd%TYPE,
      subline_cd2            giis_subline.subline_cd%TYPE,
      loss_year2             gicl_res_brdrx_extr.loss_year%TYPE,
      grp_seq_no2            gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      brdrx_rids_record_id   gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE,
      grp_seq_no3            gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      outstanding_loss4      gicl_res_brdrx_extr.loss_reserve%TYPE
   );

   TYPE treaty_ri_tab IS TABLE OF treaty_ri_type;

   TYPE total_per_line_type IS RECORD (
      iss_cd             giis_issource.iss_cd%TYPE,
      subline_cd         giis_subline.subline_cd%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      outstanding_loss   gicl_res_brdrx_extr.loss_reserve%TYPE
   );

   TYPE total_per_line_tab IS TABLE OF total_per_line_type;

   TYPE total_treaty_type IS RECORD (
      iss_cd             giis_issource.iss_cd%TYPE,
      outstanding_loss   gicl_res_brdrx_extr.loss_reserve%TYPE,
      treaty_name        giis_dist_share.trty_name%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      buss_source        gicl_res_brdrx_extr.buss_source%TYPE,
      buss_source_type   VARCHAR2 (2)
   );

   TYPE total_treaty_tab IS TABLE OF total_treaty_type;

   TYPE total_per_iss_type IS RECORD (
      subline_cd         giis_subline.subline_cd%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      iss_cd             giis_issource.iss_cd%TYPE,
      outstanding_loss   gicl_res_brdrx_extr.loss_reserve%TYPE
   );

   TYPE total_per_iss_tab IS TABLE OF total_per_iss_type;

   TYPE total_per_buss_source_type IS RECORD (
      subline_cd         giis_subline.subline_cd%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      iss_cd             giis_issource.iss_cd%TYPE,
      buss_source        gicl_res_brdrx_extr.buss_source%TYPE,
      outstanding_loss   gicl_res_brdrx_extr.loss_reserve%TYPE
   );

   TYPE total_per_buss_source_tab IS TABLE OF total_per_buss_source_type;

   TYPE total_per_buss_src_type_type IS RECORD (
      subline_cd         giis_subline.subline_cd%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      iss_cd             giis_issource.iss_cd%TYPE,
      buss_source        gicl_res_brdrx_extr.buss_source%TYPE,
      buss_source_type   VARCHAR2 (2),
      outstanding_loss   gicl_res_brdrx_extr.loss_reserve%TYPE
   );

   TYPE total_per_buss_src_type_tab IS TABLE OF total_per_buss_src_type_type;

   TYPE grand_total_type IS RECORD (
      grand_treaty_loss   gicl_res_brdrx_extr.loss_reserve%TYPE,
      treaty_name         giis_dist_share.trty_name%TYPE,
      grp_seq_no          gicl_res_brdrx_ds_extr.grp_seq_no%TYPE
   );

   TYPE grand_total_tab IS TABLE OF grand_total_type;

   FUNCTION get_page_header (
      p_from_date     DATE,
      p_to_date       DATE,
      p_as_of_date    DATE,
      p_date_option   VARCHAR2
   )
      RETURN header_tab PIPELINED;

   FUNCTION get_report_header (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE
   )
      RETURN header_tab PIPELINED;

   FUNCTION get_report_detail (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_intm_break    VARCHAR2,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE
   )
      RETURN detail_tab PIPELINED;

   FUNCTION get_treaty_header (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE
   )
      RETURN treaty_header_tab PIPELINED;

   FUNCTION get_treaty (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_intm_break    VARCHAR2,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE
   )
      RETURN treaty_detail_tab PIPELINED;

   FUNCTION get_treaty_facul (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE
   )
      RETURN treaty_facul_tab PIPELINED;

   FUNCTION get_treaty_ri1 (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE
   )
      RETURN treaty_ri_tab PIPELINED;

   FUNCTION get_treaty_ri (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE
   )
      RETURN treaty_ri_tab PIPELINED;

   FUNCTION get_treaty_ri_amt (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE,
      p_ri_cd         gicl_res_brdrx_rids_extr.ri_cd%TYPE
   )
      RETURN treaty_ri_tab PIPELINED;

   FUNCTION get_total_per_line (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE
   )
      RETURN total_per_line_tab PIPELINED;

   FUNCTION get_total_treaty (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE
   )
      RETURN total_treaty_tab PIPELINED;

   FUNCTION get_total_per_iss (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE
   )
      RETURN total_per_iss_tab PIPELINED;

   FUNCTION get_total_treaty_iss (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE
   )
      RETURN total_treaty_tab PIPELINED;

   FUNCTION get_total_per_buss_source (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE
   )
      RETURN total_per_buss_source_tab PIPELINED;

   FUNCTION get_total_treaty_buss_source (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE
   )
      RETURN total_treaty_tab PIPELINED;

   FUNCTION get_total_per_buss_source_type (
      p_session_id         gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id           gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source_type   VARCHAR2
   )
      RETURN total_per_buss_src_type_tab PIPELINED;

   FUNCTION get_total_treaty_buss_src_type (
      p_session_id         gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id           gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source_type   VARCHAR2
   )
      RETURN total_treaty_tab PIPELINED;

   FUNCTION get_report_grand_total (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE
   )
      RETURN grand_total_tab PIPELINED;

   FUNCTION cf_intm (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_item_no      gicl_res_brdrx_extr.item_no%TYPE,
      p_peril_cd     giis_peril.peril_cd%TYPE,
      p_intm_no      gicl_res_brdrx_extr.intm_no%TYPE,
      p_intm_break   VARCHAR2
   )
      RETURN VARCHAR2;

   --added by steven for matrix... not the movie
   TYPE giclr205l_parent_type IS RECORD (
      buss_source_type        giis_intermediary.intm_type%TYPE,
      buss_source_type_name   giis_intm_type.intm_desc%TYPE,
      iss_type                gicl_res_brdrx_extr.iss_cd%TYPE,
      iss_cd                  gicl_res_brdrx_extr.iss_cd%TYPE,
      buss_source             gicl_res_brdrx_extr.buss_source%TYPE,
      buss_source_name        giis_reinsurer.ri_name%TYPE,
      iss_name                giis_issource.iss_name%TYPE,
      line_cd                 gicl_res_brdrx_extr.line_cd%TYPE,
      line_name               giis_line.line_name%TYPE,
      subline_cd              gicl_res_brdrx_extr.subline_cd%TYPE,
      subline_name            giis_subline.subline_name%TYPE,
      loss_year               gicl_res_brdrx_extr.loss_year%TYPE,
      loss_year_dummy         VARCHAR2 (10),
      grp_seq_no1             gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no2             gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no3             gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no4             gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      treaty1                 giis_dist_share.trty_name%TYPE,
      treaty2                 giis_dist_share.trty_name%TYPE,
      treaty3                 giis_dist_share.trty_name%TYPE,
      treaty4                 giis_dist_share.trty_name%TYPE
   );

   TYPE giclr205l_parent_tab IS TABLE OF giclr205l_parent_type;

   TYPE treaty_type IS RECORD (
      grp_seq_no   giis_dist_share.share_cd%TYPE,
      trty_name    giis_dist_share.trty_name%TYPE
   );

   TYPE treaty_tab IS TABLE OF treaty_type;

   TYPE giclr205l_claim_type IS RECORD (
      claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      claim_no      gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no     gicl_res_brdrx_extr.policy_no%TYPE,
      assd_name     giis_assured.assd_name%TYPE,
      incept_date   gicl_res_brdrx_extr.incept_date%TYPE,
      expiry_date   gicl_res_brdrx_extr.expiry_date%TYPE,
      loss_date     gicl_res_brdrx_extr.loss_date%TYPE,
      item_no       gicl_res_brdrx_extr.item_no%TYPE
   );

   TYPE giclr205l_claim_tab IS TABLE OF giclr205l_claim_type;

   TYPE giclr205l_item_main_type IS RECORD (
      claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      claim_no     gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no    gicl_res_brdrx_extr.policy_no%TYPE,
      item_no      gicl_res_brdrx_extr.item_no%TYPE,
      item_title   VARCHAR2 (250),
      tsi_amt      gicl_res_brdrx_extr.tsi_amt%TYPE, --Added by carlo
      peril_name   giis_peril.peril_name%TYPE --Added by carlo
   );

   TYPE giclr205l_item_main_tab IS TABLE OF giclr205l_item_main_type;

   TYPE giclr205l_item_type IS RECORD (
      claim_id           gicl_res_brdrx_extr.claim_id%TYPE,
      claim_no           gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no          gicl_res_brdrx_extr.policy_no%TYPE,
      item_no            gicl_res_brdrx_extr.item_no%TYPE,
      --tsi_amt            gicl_res_brdrx_extr.tsi_amt%TYPE, comment out by carlo
      peril_name         giis_peril.peril_name%TYPE,
      intm_name          giis_intermediary.intm_name%TYPE,
      outstanding_loss   gicl_res_brdrx_extr.expenses_paid%TYPE,
      brdrx_record_id    gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      intm_no            gicl_res_brdrx_extr.intm_no%TYPE --Added by carlo
   );

   TYPE giclr205l_item_tab IS TABLE OF giclr205l_item_type;

   TYPE outstanding_loss_type_v IS RECORD (
      outstanding_loss1   VARCHAR2 (1000),
      outstanding_loss2   VARCHAR2 (1000),
      outstanding_loss3   VARCHAR2 (1000),
      outstanding_loss4   VARCHAR2 (1000)
   );

   TYPE outstanding_loss_tab_v IS TABLE OF outstanding_loss_type_v;

   TYPE facul_type IS RECORD (
      ri_name1            giis_reinsurer.ri_sname%TYPE,
      ri_name2            giis_reinsurer.ri_sname%TYPE,
      ri_name3            giis_reinsurer.ri_sname%TYPE,
      ri_name4            giis_reinsurer.ri_sname%TYPE,
      outstanding_loss1   gicl_res_brdrx_extr.expenses_paid%TYPE,
      outstanding_loss2   gicl_res_brdrx_extr.expenses_paid%TYPE,
      outstanding_loss3   gicl_res_brdrx_extr.expenses_paid%TYPE,
      outstanding_loss4   gicl_res_brdrx_extr.expenses_paid%TYPE
   );

   TYPE facul_tab IS TABLE OF facul_type;

   TYPE total_os_loss_type IS RECORD (
      total_os_loss   gicl_res_brdrx_extr.expenses_paid%TYPE
   );

   TYPE total_os_loss_tab IS TABLE OF total_os_loss_type;

   TYPE treaty_ri_type2 IS RECORD (
      policy_no              gicl_res_brdrx_extr.policy_no%TYPE,
      grp_seq_no             gicl_res_brdrx_rids_extr.grp_seq_no%TYPE,
      brdrx_rids_record_id   gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE,
      line_cd                gicl_res_brdrx_rids_extr.line_cd%TYPE,
      treaty_name            giis_dist_share.trty_name%TYPE,
      trty_ri_cd             gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      ri_cd                  gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      ri_name                giis_reinsurer.ri_name%TYPE,
      trty_shr_pct           giis_trty_panel.trty_shr_pct%TYPE,
      outstanding_loss       gicl_res_brdrx_extr.expenses_paid%TYPE
   );

   TYPE treaty_ri_tab2 IS TABLE OF treaty_ri_type2;

   TYPE summary_treaty_type IS RECORD (
      outstanding_loss   gicl_res_brdrx_extr.expenses_paid%TYPE,
      trty_name          giis_dist_share.trty_name%TYPE
   );

   TYPE summary_treaty_tab IS TABLE OF summary_treaty_type;

   TYPE treaty_details_type IS RECORD (
      claim_id                  gicl_res_brdrx_extr.claim_id%TYPE,
      buss_source               gicl_res_brdrx_extr.buss_source%TYPE,
      iss_cd                    gicl_res_brdrx_extr.iss_cd%TYPE,
      line_cd                   gicl_res_brdrx_extr.line_cd%TYPE,
      subline_cd                gicl_res_brdrx_extr.subline_cd%TYPE,
      loss_year                 gicl_res_brdrx_extr.loss_year%TYPE,
      brdrx_record_id           gicl_res_brdrx_ds_extr.brdrx_record_id%TYPE,
      brdrx_ds_record_id        gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE,
      grp_seq_no                gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      treaty_name               giis_dist_share.trty_name%TYPE,
      shr_pct                   gicl_res_brdrx_ds_extr.shr_pct%TYPE,
      outstanding_loss2         gicl_res_brdrx_extr.expenses_paid%TYPE,
      print_flg                 VARCHAR2 (1),
      -- for treaty_facul
      facul_ri_cd               gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      facul_ri_name             giis_reinsurer.ri_name%TYPE,
      facul_shr_ri_pct          gicl_res_brdrx_rids_extr.shr_ri_pct%TYPE,
      facul_outstanding_loss3   gicl_res_brdrx_rids_extr.expense_reserve%TYPE
   );

   TYPE treaty_details_tab IS TABLE OF treaty_details_type;

   FUNCTION get_giclr205l_parent (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE
   )
      RETURN giclr205l_parent_tab PIPELINED;

   FUNCTION get_giclr205l_claim (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_line_cd       gicl_res_brdrx_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_extr.subline_cd%TYPE,
      p_iss_cd        gicl_res_brdrx_extr.iss_cd%TYPE
   )
      RETURN giclr205l_claim_tab PIPELINED;

   FUNCTION get_giclr205l_item_main (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_line_cd       gicl_res_brdrx_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_extr.subline_cd%TYPE,
      p_iss_cd        gicl_res_brdrx_extr.iss_cd%TYPE
   )
      RETURN giclr205l_item_main_tab PIPELINED;

   FUNCTION get_giclr205l_item (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_item_no       gicl_res_brdrx_extr.item_no%TYPE
   )
      RETURN giclr205l_item_tab PIPELINED;

   FUNCTION get_giclr205l_treaty (
       p_session_id        gicl_res_brdrx_ds_extr.session_id%TYPE,
       p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
       p_buss_source       gicl_res_brdrx_extr.buss_source%TYPE,
       p_loss_year_dummy   VARCHAR2,
       p_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
       p_iss_cd            gicl_res_brdrx_ds_extr.iss_cd%TYPE,
       p_line_cd           gicl_res_brdrx_ds_extr.line_cd%TYPE,
       p_subline_cd        gicl_res_brdrx_ds_extr.subline_cd%TYPE,
       p_loss_year         gicl_res_brdrx_ds_extr.loss_year%TYPE  
   )
      RETURN outstanding_loss_tab_v PIPELINED;

   FUNCTION get_giclr205l_facul (
      p_session_id        gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source       gicl_res_brdrx_extr.buss_source%TYPE,
      p_loss_year_dummy   VARCHAR2,
      p_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      p_grp_seq_no1       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      p_grp_seq_no2       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      p_grp_seq_no3       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      p_grp_seq_no4       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE
   )
      RETURN facul_tab PIPELINED;

   FUNCTION get_giclr205l_os_total (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        gicl_res_brdrx_extr.iss_cd%TYPE,
      p_line_cd       gicl_res_brdrx_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_extr.subline_cd%TYPE
   )
      RETURN total_os_loss_tab PIPELINED;

   FUNCTION get_giclr205l_treaty_total (
      p_session_id        gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source       gicl_res_brdrx_extr.buss_source%TYPE,
      p_loss_year_dummy   VARCHAR2,
      p_iss_cd            gicl_res_brdrx_extr.iss_cd%TYPE,
      p_line_cd           gicl_res_brdrx_extr.line_cd%TYPE,
      p_subline_cd        gicl_res_brdrx_extr.subline_cd%TYPE,
      p_loss_year         gicl_res_brdrx_extr.loss_year%TYPE
   )
      RETURN outstanding_loss_tab_v PIPELINED;

   FUNCTION get_treaty_ri2 (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        gicl_res_brdrx_extr.iss_cd%TYPE,
      p_line_cd       gicl_res_brdrx_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_extr.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE
   )
      RETURN treaty_ri_tab2 PIPELINED;

   FUNCTION get_treaty_summary_line (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        gicl_res_brdrx_extr.iss_cd%TYPE,
      p_line_cd       gicl_res_brdrx_extr.line_cd%TYPE
   )
      RETURN summary_treaty_tab PIPELINED;

   FUNCTION get_treaty_summary_iss_source (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        gicl_res_brdrx_extr.iss_cd%TYPE,
      p_line_cd       gicl_res_brdrx_extr.line_cd%TYPE
   )
      RETURN summary_treaty_tab PIPELINED;

   FUNCTION get_treaty_summary_buss_source (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        gicl_res_brdrx_extr.iss_cd%TYPE,
      p_line_cd       gicl_res_brdrx_extr.line_cd%TYPE
   )
      RETURN summary_treaty_tab PIPELINED;

   FUNCTION get_treaty_summary_grand (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        gicl_res_brdrx_extr.iss_cd%TYPE,
      p_line_cd       gicl_res_brdrx_extr.line_cd%TYPE
   )
      RETURN summary_treaty_tab PIPELINED;

   FUNCTION cf_intm_riformula (
      p_claim_id   gicl_intm_itmperil.claim_id%TYPE,
      p_item_no    gicl_intm_itmperil.item_no%TYPE,
      p_peril_cd   gicl_intm_itmperil.peril_cd%TYPE,
      p_intm_no    gicl_intm_itmperil.intm_no%TYPE  --Added by carlo
   )
      RETURN VARCHAR2;

   FUNCTION get_treaty_facul (
      p_session_id        gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      p_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      p_buss_source       gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd            gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_line_cd           gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd        gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year         gicl_res_brdrx_ds_extr.loss_year%TYPE
   )
      RETURN treaty_details_tab PIPELINED;

   FUNCTION cf_treaty_nameformula (
      p_grp_seq_no   giis_dist_share.share_cd%TYPE,
      p_line_cd      giis_dist_share.line_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION cf_ri_nameformula (p_ri_cd giis_reinsurer.ri_cd%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_treaty_details (
      p_session_id        gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      p_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      p_buss_source       gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd            gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_line_cd           gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd        gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year         gicl_res_brdrx_ds_extr.loss_year%TYPE
   )
      RETURN treaty_details_tab PIPELINED;

   FUNCTION get_treaty_summary_buss_type (
      p_session_id         gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id           gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source_type   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd             gicl_res_brdrx_extr.iss_cd%TYPE,
      p_line_cd            gicl_res_brdrx_extr.line_cd%TYPE
   )
      RETURN summary_treaty_tab PIPELINED;
END giclr205l_pkg;
/


