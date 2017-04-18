CREATE OR REPLACE PACKAGE CPI.giclr206x_pkg
AS
   TYPE main_type IS RECORD (
      buss_source_type   giis_intermediary.intm_type%TYPE,
      buss_source_name   giis_intm_type.intm_desc%TYPE,
      iss_type           VARCHAR2 (2),
      buss_source        gicl_res_brdrx_ds_extr.buss_source%TYPE,
      source_name        giis_intermediary.intm_name%TYPE,
      iss_cd             gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      line_cd            gicl_res_brdrx_ds_extr.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      loss_year          gicl_res_brdrx_ds_extr.loss_year%TYPE,
      loss_year_dummy    VARCHAR2 (50),
      col1               VARCHAR2 (50),
      col2               VARCHAR2 (50),
      col3               VARCHAR2 (50),
      col4               VARCHAR2 (50),
      tot1               NUMBER,
      tot2               NUMBER,
      tot3               NUMBER,
      tot4               NUMBER,
      company_name       giac_parameters.param_value_v%TYPE,
      company_address    giac_parameters.param_value_v%TYPE,
      report_title       giis_reports.report_title%TYPE,
      date_range         VARCHAR2 (100)
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_main (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN main_tab PIPELINED;

   TYPE details_type IS RECORD (
--      brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      claim_no      gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no     gicl_res_brdrx_extr.policy_no%TYPE,
      assd_name     giis_assured.assd_name%TYPE,
      incept_date   gicl_res_brdrx_extr.incept_date%TYPE,
      expiry_date   gicl_res_brdrx_extr.expiry_date%TYPE,
      loss_date     gicl_res_brdrx_extr.loss_date%TYPE,
      claim_id      gicl_res_brdrx_extr.claim_id%TYPE
   );

   TYPE details_tab IS TABLE OF details_type;

   FUNCTION get_details (
      p_session_id    VARCHAR2,
      p_claim_id      VARCHAR2,
      p_buss_source   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_loss_year     VARCHAR2
   )
      RETURN details_tab PIPELINED;

   TYPE g_item_type IS RECORD (
      item_no           gicl_res_brdrx_extr.item_no%TYPE,
      grouped_item_no   gicl_res_brdrx_extr.grouped_item_no%TYPE,
      item_title        gicl_clm_item.item_title%TYPE
   );

   TYPE g_item_tab IS TABLE OF g_item_type;

   FUNCTION get_g_item (
      p_session_id    VARCHAR2,
      p_claim_id      VARCHAR2,
      p_buss_source   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_loss_year     VARCHAR2
   )
      RETURN g_item_tab PIPELINED;

   TYPE g_peril_type IS RECORD (
      tsi_amt           gicl_res_brdrx_extr.tsi_amt%TYPE,
      peril_cd          gicl_res_brdrx_extr.peril_cd%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      intm_ri           VARCHAR2 (1000),
      dv_no             VARCHAR2 (3000), -- Modified by Jerome Bautista 08.03.2015 SR 18821
      brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE
   );

   TYPE g_peril_tab IS TABLE OF g_peril_type;

   FUNCTION get_g_peril (
      p_session_id    VARCHAR2,
      p_claim_id      VARCHAR2,
      p_buss_source   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_loss_year     VARCHAR2,
      p_item_no       VARCHAR2,
      p_intm_break    VARCHAR2,
      p_paid_date     VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2
   )
      RETURN g_peril_tab PIPELINED;

   TYPE paid_losses_type IS RECORD (
      col1              gicl_res_brdrx_extr.losses_paid%TYPE,
      col2              gicl_res_brdrx_extr.losses_paid%TYPE,
      col3              gicl_res_brdrx_extr.losses_paid%TYPE,
      col4              gicl_res_brdrx_extr.losses_paid%TYPE,
      loss_year_dummy   VARCHAR2 (50)
   );

   TYPE paid_losses_tab IS TABLE OF paid_losses_type;

   FUNCTION get_paid_losses (
      p_session_id        VARCHAR2,
      p_claim_id          VARCHAR2,
      p_buss_source       VARCHAR2,
      p_iss_cd            VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_year         VARCHAR2,
      p_brdrx_record_id   VARCHAR2
   )
      RETURN paid_losses_tab PIPELINED;

   TYPE treaty_type IS RECORD (
      grp_seq_no     gicl_res_brdrx_rids_extr.grp_seq_no%TYPE,
      trty_name      giis_dist_share.trty_name%TYPE,
      ri_sname       giis_reinsurer.ri_sname%TYPE,
      trty_shr_pct   giis_trty_panel.trty_shr_pct%TYPE,
      ri_cd          gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      shr_amt        NUMBER
   );

   TYPE treaty_tab IS TABLE OF treaty_type;

   FUNCTION get_treaty (
      p_session_id    VARCHAR2,
      p_claim_id      VARCHAR2,
      p_buss_source   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_loss_year     VARCHAR2
   )
      RETURN treaty_tab PIPELINED;

--formulas
   FUNCTION cf_intm_riformula (
      p_claim_id     VARCHAR2,
      p_intm_break   VARCHAR2,
      p_session_id   VARCHAR2,
      p_item_no      VARCHAR2,
      p_peril_cd     VARCHAR2,
      p_intm_no      VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION cf_dv_noformula (
      p_paid_losses   VARCHAR2,
      p_claim_id      VARCHAR2,
      p_clm_loss_id   VARCHAR2,
      p_paid_date     VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2
   )
      RETURN VARCHAR2;
END;
/


