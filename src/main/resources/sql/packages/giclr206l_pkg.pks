CREATE OR REPLACE PACKAGE CPI.GICLR206L_PKG
AS
   TYPE header_type IS RECORD (
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      report_title     VARCHAR2 (50),
      cf_param_date    VARCHAR2 (100),
      cf_date          VARCHAR2 (100)
   );

   TYPE header_tab IS TABLE OF header_type;

   TYPE detail_type IS RECORD (
      iss_type           VARCHAR2 (2),
      buss_source_type   VARCHAR2 (2),
      iss_cd             giis_issource.iss_cd%TYPE,
      buss_source        gicl_res_brdrx_extr.buss_source%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      subline_cd         giis_subline.subline_cd%TYPE,
      loss_year          gicl_res_brdrx_extr.loss_year%TYPE,
      buss_source_name   giis_intm_type.intm_desc%TYPE,
      source_name        giis_intermediary.intm_name%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      v_exist            VARCHAR2 (1),
      brdrx_record_id    gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      claim_no           gicl_res_brdrx_extr.claim_no%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      policy_no          VARCHAR2 (60),
      cf_policy_no       VARCHAR2 (60),
      incept_date        VARCHAR2 (100),
      expiry_date        VARCHAR2 (100),
      loss_date          VARCHAR2 (100),
      item_title         VARCHAR2 (200),
      tsi_amt            gicl_res_brdrx_extr.tsi_amt%TYPE,
      peril_name         giis_peril.peril_name%TYPE,
      intm_ri            VARCHAR2 (1000),
      cf_dv_no           VARCHAR2 (500),
      paid_losses        gicl_res_brdrx_extr.losses_paid%TYPE,
      peril_cd           giis_peril.peril_cd%TYPE,
      item_no            NUMBER,
      claim_id           NUMBER
   );

   TYPE detail_tab IS TABLE OF detail_type;

   TYPE treaty_detail_type IS RECORD (
      grp_seq_no        gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      trty_name         giis_dist_share.trty_name%TYPE,
      paid_losses2      gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      paid_losses3      gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      ri_sname          giis_reinsurer.ri_sname%TYPE,
      brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      item_no           NUMBER
   );

   TYPE treaty_detail_tab IS TABLE OF treaty_detail_type;

   TYPE ri_detail_type IS RECORD (
      trty_name       giis_dist_share.trty_name%TYPE,
      ri_name         giis_reinsurer.ri_sname%TYPE,
      ri_shr          giis_trty_panel.trty_shr_pct%TYPE,
      dummy_measure   NUMBER,
      ri_cd           NUMBER,
      trty_ri_cd      NUMBER,
      trty_shr_pct    giis_trty_panel.trty_shr_pct%TYPE,
      grp_seq_no      gicl_res_brdrx_ds_extr.grp_seq_no%TYPE
   );

   TYPE ri_detail_tab IS TABLE OF ri_detail_type;

   TYPE ri_amount_type IS RECORD (
      trty_name       giis_dist_share.trty_name%TYPE,
      ri_name         giis_reinsurer.ri_sname%TYPE,
      ri_shr          giis_trty_panel.trty_shr_pct%TYPE,
      dummy_measure   NUMBER,
      trty_ri_cd      NUMBER,
      grp_seq_no      gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      paid_losses3    gicl_res_brdrx_ds_extr.losses_paid%TYPE
   );

   TYPE ri_amount_tab IS TABLE OF ri_amount_type;

   FUNCTION get_header (p_from_date DATE, p_to_date DATE, p_paid_date NUMBER)
      RETURN header_tab PIPELINED;

   FUNCTION get_detail (
      p_from_date       DATE,
      p_to_date         DATE,
      p_paid_date       NUMBER,
      p_session_id      gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id        gicl_res_brdrx_extr.claim_id%TYPE,
      p_amt             VARCHAR2,
      p_intm_break      NUMBER,
      p_iss_break       NUMBER,
      p_subline_break   NUMBER
   )
      RETURN detail_tab PIPELINED;

   FUNCTION get_treaty_detail (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE
   )
      RETURN treaty_detail_tab PIPELINED;

   FUNCTION get_ri_detail (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE
   )
      RETURN ri_detail_tab PIPELINED;

   FUNCTION get_ri_amount (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE,
      p_ri_cd         NUMBER
   )
      RETURN ri_amount_tab PIPELINED;
      
   TYPE treaty_type IS RECORD(
      grp_seq_no           GIIS_DIST_SHARE.share_cd%TYPE,
      trty_name            GIIS_DIST_SHARE.trty_name%TYPE
   );
   TYPE treaty_tab IS TABLE OF treaty_type;
   
   TYPE paid_losses_type IS RECORD(
      paid_losses1         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses2         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses3         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses4         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      ds_record_id         GICL_RES_BRDRX_DS_EXTR.brdrx_ds_record_id%TYPE
   );
   TYPE paid_losses_tab IS TABLE OF paid_losses_type;
   
   TYPE facul_type IS RECORD(
      ri_name1             GIIS_REINSURER.ri_sname%TYPE,
      ri_name2             GIIS_REINSURER.ri_sname%TYPE,
      ri_name3             GIIS_REINSURER.ri_sname%TYPE,
      ri_name4             GIIS_REINSURER.ri_sname%TYPE,
      paid_losses1         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses2         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses3         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses4         GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE facul_tab IS TABLE OF facul_type;
   
   TYPE treaty_ri_type IS RECORD(
      treaty_name          GIIS_DIST_SHARE.trty_name%TYPE,
      trty_shr_pct         GIIS_TRTY_PANEL.trty_shr_pct%TYPE,
      paid_losses          GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      ri_name              GIIS_REINSURER.ri_sname%TYPE,
      grp_seq_no           GICL_RES_BRDRX_RIDS_EXTR.grp_seq_no%TYPE,
      ri_cd                GICL_RES_BRDRX_RIDS_EXTR.ri_cd%TYPE
   );
   TYPE treaty_ri_tab IS TABLE OF treaty_ri_type;

   TYPE giclr206l_main_type IS RECORD (
      dummy                NUMBER(10),
      iss_type             VARCHAR2(2),
      buss_source_type     VARCHAR2(2),
      iss_cd               giis_issource.iss_cd%TYPE,
      buss_source          gicl_res_brdrx_extr.buss_source%TYPE,
      line_cd              giis_line.line_cd%TYPE,
      subline_cd           giis_subline.subline_cd%TYPE,
      loss_year            gicl_res_brdrx_extr.loss_year%TYPE,
      buss_source_name     giis_intm_type.intm_desc%TYPE,
      source_name          giis_intermediary.intm_name%TYPE,
      iss_name             giis_issource.iss_name%TYPE,
      line_name            giis_line.line_name%TYPE,
      subline_name         giis_subline.subline_name%TYPE,
      grp_seq_no1          gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no2          gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no3          gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no4          gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      treaty1              giis_dist_share.trty_name%TYPE,
      treaty2              giis_dist_share.trty_name%TYPE,
      treaty3              giis_dist_share.trty_name%TYPE,
      treaty4              giis_dist_share.trty_name%TYPE
   );
   TYPE giclr206l_main_tab IS TABLE OF giclr206l_main_type;
   
   TYPE giclr206l_detail_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      ref_pol_no           GICL_RES_BRDRX_EXTR.ref_pol_no%TYPE,
      incept_date          VARCHAR2(20),
      expiry_date          VARCHAR2(20),
      loss_date            VARCHAR2(20),
      assd_no              GICL_RES_BRDRX_EXTR.assd_no%TYPE,
      assd_name            GIIS_ASSURED.assd_name%TYPE
   );
   TYPE giclr206l_detail_tab IS TABLE OF giclr206l_detail_type;
   
   TYPE giclr206l_item_type IS RECORD(
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      item_title           VARCHAR2(200),
      grouped_item_no      GICL_RES_BRDRX_EXTR.grouped_item_no%TYPE
   );
   TYPE giclr206l_item_tab IS TABLE OF giclr206l_item_type;
   
   TYPE giclr206l_peril_type IS RECORD(
      tsi_amt              GICL_RES_BRDRX_EXTR.tsi_amt%TYPE,
      peril_cd             GICL_RES_BRDRX_EXTR.peril_cd%TYPE,
      peril_name           GIIS_PERIL.peril_name%TYPE,
      intm_cedant          VARCHAR2(10000),
      dv_no                VARCHAR2(1000),
      paid_losses          GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      brdrx_id             VARCHAR2(100) --added by gab 03.21.2016 SR 21796
   );
   TYPE giclr206l_peril_tab IS TABLE OF giclr206l_peril_type;
      
   FUNCTION get_giclr206l_main(
      p_paid_date          NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_amt                VARCHAR2,
      p_intm_break         NUMBER,
      p_iss_break          NUMBER,
      p_subline_break      NUMBER
   )
     RETURN giclr206l_main_tab PIPELINED;
   
   FUNCTION get_giclr206l_detail(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN giclr206l_detail_tab PIPELINED;
     
   FUNCTION get_giclr206l_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_claim_no           GICL_RES_BRDRX_EXTR.claim_no%TYPE
   )
     RETURN giclr206l_item_tab PIPELINED;
     
   FUNCTION get_giclr206l_peril(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_claim_no           GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_grouped_item_no    GICL_RES_BRDRX_EXTR.grouped_item_no%TYPE,
      p_intm_break         NUMBER,
      p_paid_date          NUMBER,
      p_from_date          DATE,
      p_to_date            DATE
   )
     RETURN giclr206l_peril_tab PIPELINED;
     
   FUNCTION get_giclr206l_treaty(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_peril_cd           GICL_RES_BRDRX_EXTR.peril_cd%TYPE,
      p_brdrx_id           VARCHAR2 --added by gab 03.21.2016 SR 21796
   )
     RETURN paid_losses_tab PIPELINED;
     
   FUNCTION get_giclr206l_facul(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_ds_record_id       GICL_RES_BRDRX_RIDS_EXTR.brdrx_ds_record_id%TYPE
   )
     RETURN facul_tab PIPELINED;
     
   FUNCTION get_giclr206l_treaty_total(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE
   )
     RETURN paid_losses_tab PIPELINED;
     
   FUNCTION get_giclr206l_treaty_ri(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN treaty_ri_tab PIPELINED;
     
   FUNCTION get_giclr206l_totals(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source_type   VARCHAR2,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN NUMBER;
   
END;
/


