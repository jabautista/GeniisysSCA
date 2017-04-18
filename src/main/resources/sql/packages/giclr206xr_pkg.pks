CREATE OR REPLACE PACKAGE CPI.giclr206xr_pkg
AS
   TYPE giclr206xr_type IS RECORD (
      cf_company       giac_parameters.param_value_v%TYPE,
      cf_com_address   giac_parameters.param_value_v%TYPE,
      report_title     giis_reports.report_title%TYPE,
      cf_param_date    VARCHAR2 (100),
      cf_date          VARCHAR2 (100)
   );

   TYPE giclr206xr_tab IS TABLE OF giclr206xr_type;

   FUNCTION get_giclr206xr_main (
      p_paid_date   NUMBER,
      p_from_date   DATE,
      p_to_date     DATE
   )
      RETURN giclr206xr_tab PIPELINED;

   TYPE header_type IS RECORD (
      buss_source_type   VARCHAR2 (2),
      iss_type           VARCHAR2 (2),
      iss_cd             gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      line_cd            gicl_res_brdrx_ds_extr.line_cd%TYPE,
      subline_cd         gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      buss_source_name   giis_intm_type.intm_desc%TYPE,
      source_name        giis_intermediary.intm_name%TYPE,
      buss_source        gicl_res_brdrx_ds_extr.buss_source%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      loss_year          gicl_res_brdrx_ds_extr.loss_year%TYPE,
      claim_no           gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no          VARCHAR2 (60),
      assd_name          giis_assured.assd_name%TYPE,
      incept_date        gicl_res_brdrx_extr.incept_date%TYPE,
      expiry_date        gicl_res_brdrx_extr.expiry_date%TYPE,
      loss_date          gicl_res_brdrx_extr.loss_date%TYPE,
      brdrx_record_id    gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      dummy              VARCHAR2 (100),
      header_part        NUMBER (1)
   );

   TYPE header_tab IS TABLE OF header_type;

   FUNCTION get_header (p_session_id gicl_res_brdrx_extr.session_id%TYPE)
      RETURN header_tab PIPELINED;

   TYPE treaty_header_type IS RECORD (
      treaty_name   giis_dist_share.trty_name%TYPE,
      grp_seq_no    gicl_res_brdrx_ds_extr.grp_seq_no%TYPE
   );

   TYPE treaty_header_tab IS TABLE OF treaty_header_type;

   FUNCTION get_treaty_header (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE,
      p_header_part   NUMBER
   )
      RETURN treaty_header_tab PIPELINED;

   TYPE details_type IS RECORD (
      claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      claim_no          gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no         gicl_res_brdrx_extr.policy_no%TYPE,
      assd_no           giis_assured.assd_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      incept_date       gicl_res_brdrx_extr.incept_date%TYPE,
      expiry_date       gicl_res_brdrx_extr.expiry_date%TYPE,
      loss_date         gicl_res_brdrx_extr.loss_date%TYPE,
      brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      paid_losses       NUMBER,
      ref_pol_no        gicl_res_brdrx_extr.ref_pol_no%TYPE
   );

   TYPE details_tab IS TABLE OF details_type;

   FUNCTION get_details (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE
   )
      RETURN details_tab PIPELINED;

   TYPE item_type IS RECORD (
      item_no      gicl_res_brdrx_extr.item_no%TYPE,
      item_title   VARCHAR2 (200)
   );

   TYPE item_tab IS TABLE OF item_type;

   FUNCTION get_items (
      p_session_id   gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE
   )
      RETURN item_tab PIPELINED;

   TYPE peril_type IS RECORD (
      peril_cd       gicl_res_brdrx_extr.peril_cd%TYPE,
      loss_cat_cd    gicl_res_brdrx_extr.loss_cat_cd%TYPE,
      tsi_amt        gicl_res_brdrx_extr.tsi_amt%TYPE,
      intm_no        gicl_res_brdrx_extr.intm_no%TYPE,
      clm_loss_id    gicl_res_brdrx_extr.clm_loss_id%TYPE,
      paid_losses    gicl_res_brdrx_extr.losses_paid%TYPE,
      cf_intm_ri     VARCHAR2 (1000),
      cf_dv_no       VARCHAR2 (500),
      loss_cat_des   giis_loss_ctgry.loss_cat_des%TYPE
   );

   TYPE peril_tab IS TABLE OF peril_type;

   FUNCTION get_perils (
      p_session_id   gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_item_no      gicl_res_brdrx_extr.item_no%TYPE,
      p_paid_date    NUMBER,
      p_from_date    DATE,
      p_to_date      DATE,
      p_intm_break   NUMBER
   )
      RETURN peril_tab PIPELINED;

   TYPE treaty_details_type IS RECORD (
      brdrx_ds_record_id1   gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE,
      paid_losses1          gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      brdrx_ds_record_id2   gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE,
      paid_losses2          gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      brdrx_ds_record_id3   gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE,
      paid_losses3          gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      brdrx_ds_record_id4   gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE,
      paid_losses4          gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      brdrx_ds_record_id5   gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE,
      paid_losses5          gicl_res_brdrx_ds_extr.losses_paid%TYPE
   );

   TYPE treaty_details_tab IS TABLE OF treaty_details_type;

   FUNCTION get_treaty_details (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_ds_extr.claim_id%TYPE,
      p_iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE,
      p_header_part   NUMBER
   )
      RETURN treaty_details_tab PIPELINED;

   TYPE facul_type IS RECORD (
      ri_sname1      giis_reinsurer.ri_sname%TYPE,
      paid_losses1   gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      ri_sname2      giis_reinsurer.ri_sname%TYPE,
      paid_losses2   gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      ri_sname3      giis_reinsurer.ri_sname%TYPE,
      paid_losses3   gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      ri_sname4      giis_reinsurer.ri_sname%TYPE,
      paid_losses4   gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      ri_sname5      giis_reinsurer.ri_sname%TYPE,
      paid_losses5   gicl_res_brdrx_ds_extr.losses_paid%TYPE
   );

   TYPE facul_tab IS TABLE OF facul_type;

   FUNCTION get_facul (
      p_session_id           gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_iss_cd               gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_buss_source          gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_line_cd              gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd           gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year            gicl_res_brdrx_ds_extr.loss_year%TYPE,
      p_header_part          NUMBER,
      p_brdrx_ds_record_id   gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE
   )
      RETURN facul_tab PIPELINED;

   TYPE treaty_ri_type IS RECORD (
      grp_seq_no             gicl_res_brdrx_rids_extr.grp_seq_no%TYPE,
      brdrx_rids_record_id   gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE,
      line_cd                gicl_res_brdrx_rids_extr.line_cd%TYPE,
      treaty_name            giis_dist_share.trty_name%TYPE,
      trty_ri_cd             gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      ri_cd                  gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      ri_name                giis_reinsurer.ri_name%TYPE,
      trty_shr_pct           giis_trty_panel.trty_shr_pct%TYPE,
      paid_losses            gicl_res_brdrx_rids_extr.losses_paid%TYPE
   );

   TYPE treaty_ri_tab IS TABLE OF treaty_ri_type;

   FUNCTION get_treaty_ri (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE
   )
      RETURN treaty_ri_tab PIPELINED;
END;
/


