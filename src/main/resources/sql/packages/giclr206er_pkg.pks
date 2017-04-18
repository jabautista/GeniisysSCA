CREATE OR REPLACE PACKAGE CPI.GICLR206ER_PKG
AS
   TYPE report_type IS RECORD (
      iss_type          VARCHAR2 (100),
      buss_source_type  VARCHAR2 (100),
      iss_cd            VARCHAR2 (100),
      buss_source       GICL_RES_BRDRX_EXTR.BUSS_SOURCE%TYPE,
      line_cd           GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
      subline_cd        GICL_RES_BRDRX_EXTR.SUBLINE_CD%TYPE,
      loss_year         GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
      company_name      VARCHAR2 (500),
      company_address   VARCHAR2 (500),
      report_title      VARCHAR2 (300),
      date_title        VARCHAR2 (300),
      date_sw           VARCHAR2 (300),
      intm_name         VARCHAR2 (500),
      source_name       VARCHAR2 (100),
      iss_name          VARCHAR2 (300),
      line_name         VARCHAR2 (100),
      subline_name      VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      policy_number     VARCHAR2 (500),
      assd_name         VARCHAR2 (500),
      item_name         VARCHAR2 (200),
      loss_cat_des      VARCHAR2 (200),
      pol_iss_cd        VARCHAR2 (20),
      intm_ri           VARCHAR2 (300),
      dv_no             VARCHAR2 (200),
      pd_loss           NUMBER (16,2),
      intm_no           VARCHAR2 (10),
      claim_no          VARCHAR2 (50),
      incept_date       DATE,
      expiry_date       DATE,
      loss_date         DATE,
      tsi_amt           NUMBER (16,2),
      claim_id          GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE,
      brdrx_record_id   gicl_res_brdrx_extr.BRDRX_RECORD_ID%TYPE,
      exist             VARCHAR2(1)
   );
   
   TYPE report_tab IS TABLE OF report_type;

  FUNCTION get_giclr_206er_report (
      p_amt             VARCHAR2,
      p_claim_id        NUMBER,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_intm_break      NUMBER,
      p_iss_break       NUMBER,
      p_subline_break   NUMBER,
      p_paid_date       VARCHAR2,
      p_session_id      VARCHAR2
   )
      RETURN report_tab PIPELINED;
      
   TYPE giclr206er_detail_type IS RECORD (
      treaty_name       giis_dist_share.trty_name%TYPE,
      grp_seq_no        gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      paid_losses       NUMBER (16, 2),
      paid_losses3      NUMBER (16, 2),
      ri_name           giis_reinsurer.ri_sname%TYPE,
      brdrx_record_id   gicl_res_brdrx_ds_extr.brdrx_record_id%TYPE
   );

   TYPE giclr206er_detail_tab IS TABLE OF giclr206er_detail_type;
   
   FUNCTION get_giclr206er_treaty_detail (
      p_session_id        VARCHAR2,
      p_claim_id          NUMBER,
      p_buss_source       gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_iss_cd            gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_line_cd           gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_loss_year         gicl_res_brdrx_ds_extr.loss_year%TYPE,
      p_brdrx_record_id   GICL_RES_BRDRX_DS_EXTR.brdrx_record_id%TYPE,
      p_subline_cd        GICL_RES_BRDRX_DS_EXTR.SUBLINE_CD%TYPE
   )
      RETURN giclr206er_detail_tab PIPELINED;
      
   TYPE giclr206er_treaty_type IS RECORD (
      trty_shr_pct    NUMBER (16,2),
      trty_ri_name    VARCHAR2 (50),
      treaty_name     GIIS_DIST_SHARE.TRTY_NAME%TYPE,
      iss_cd          VARCHAR2 (100),
      buss_source     GICL_RES_BRDRX_EXTR.BUSS_SOURCE%TYPE,
      line_cd         GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
      subline_cd      GICL_RES_BRDRX_EXTR.SUBLINE_CD%TYPE,
      loss_year       GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
      ri_cd           GICL_RES_BRDRX_RIDS_EXTR.RI_CD%TYPE,
      grp_seq_no      GICL_RES_BRDRX_RIDS_EXTR.GRP_SEQ_NO%TYPE
      
   );

   TYPE giclr206er_treaty_tab IS TABLE OF giclr206er_treaty_type;

   FUNCTION get_giclr_206er_treaty (
      p_claim_id      NUMBER,
      p_session_id    VARCHAR2,
      p_iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE,
      p_buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE  
   )
      RETURN giclr206er_treaty_tab PIPELINED;
      
   TYPE giclr206er_share_type IS RECORD (
      pd_loss4        NUMBER(16,2),
      treaty_name     GIIS_DIST_SHARE.TRTY_NAME%TYPE,
      trty_ri_name    VARCHAR2 (50),
      grp_seq_no      GICL_RES_BRDRX_RIDS_EXTR.GRP_SEQ_NO%TYPE,
      row_1           VARCHAR2 (1),
      ri_cd           gicl_res_brdrx_rids_extr.RI_CD%TYPE
   );

   TYPE giclr206er_share_tab IS TABLE OF giclr206er_share_type;

   FUNCTION get_giclr_206er_share (
      p_claim_id      NUMBER,
      p_session_id    VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_ri_cd         GICL_RES_BRDRX_RIDS_EXTR.RI_CD%TYPE
   )
      RETURN giclr206er_share_tab PIPELINED;
      
   --marco - 03.14.2014
   
   TYPE giclr206er_header_type IS RECORD(
      company_name      VARCHAR2(1000),
      company_address   VARCHAR2(1000),
      report_title      VARCHAR2(500),
      date_title        VARCHAR2(500),
      date_sw           VARCHAR2(500)
   );
   TYPE giclr206er_header_tab IS TABLE OF giclr206er_header_type;
      
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
   
   TYPE treaty_ri_type2 IS RECORD(
      treaty_name          GIIS_DIST_SHARE.trty_name%TYPE,
      trty_shr_pct         GIIS_TRTY_PANEL.trty_shr_pct%TYPE,
      paid_losses          GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      ri_name              GIIS_REINSURER.ri_sname%TYPE,
      grp_seq_no           GICL_RES_BRDRX_RIDS_EXTR.grp_seq_no%TYPE,
      ri_cd                GICL_RES_BRDRX_RIDS_EXTR.ri_cd%TYPE
   );
   TYPE treaty_ri_tab2 IS TABLE OF treaty_ri_type2;

   TYPE giclr206er_main_type IS RECORD (
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
   TYPE giclr206er_main_tab IS TABLE OF giclr206er_main_type;
   
   TYPE giclr206er_detail_type2 IS RECORD(
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
   TYPE giclr206er_detail_tab2 IS TABLE OF giclr206er_detail_type2;
   
   TYPE giclr206er_item_type IS RECORD(
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      item_title           GICL_CLM_ITEM.item_title%TYPE,
      grouped_item_no      GICL_RES_BRDRX_EXTR.grouped_item_no%TYPE
   );
   TYPE giclr206er_item_tab IS TABLE OF giclr206er_item_type;
   
   TYPE giclr206er_peril_type IS RECORD(
      tsi_amt              GICL_RES_BRDRX_EXTR.tsi_amt%TYPE,
      peril_cd             GICL_RES_BRDRX_EXTR.peril_cd%TYPE,
      peril_name           GIIS_PERIL.peril_name%TYPE,
      intm_cedant          VARCHAR2(10000),
      dv_no                VARCHAR2(1000),
      paid_losses          GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE giclr206er_peril_tab IS TABLE OF giclr206er_peril_type;
   
   FUNCTION get_giclr206er_header(
      p_paid_date          NUMBER,
      p_from_date          VARCHAR2,
      p_to_date            VARCHAR2
   )
     RETURN giclr206er_header_tab PIPELINED;
      
   FUNCTION get_giclr206er_main(
      p_paid_date          NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_amt                VARCHAR2,
      p_intm_break         NUMBER,
      p_iss_break          NUMBER,
      p_subline_break      NUMBER
   )
     RETURN giclr206er_main_tab PIPELINED;
   
   FUNCTION get_giclr206er_detail(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN giclr206er_detail_tab2 PIPELINED;
     
   FUNCTION get_giclr206er_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_claim_no           GICL_RES_BRDRX_EXTR.claim_no%TYPE
   )
     RETURN giclr206er_item_tab PIPELINED;
     
   FUNCTION get_giclr206er_peril(
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
     RETURN giclr206er_peril_tab PIPELINED;
     
   FUNCTION get_giclr206er_treaty(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_peril_cd           GICL_RES_BRDRX_EXTR.peril_cd%TYPE
   )
     RETURN paid_losses_tab PIPELINED;
     
   FUNCTION get_giclr206er_facul(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_ds_record_id       GICL_RES_BRDRX_RIDS_EXTR.brdrx_ds_record_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_peril_cd           GICL_RES_BRDRX_EXTR.peril_cd%TYPE
   )
     RETURN facul_tab PIPELINED;
     
   FUNCTION get_giclr206er_treaty_total(
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
     
   FUNCTION get_giclr206er_treaty_ri(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED;
     
   FUNCTION get_giclr206er_totals(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source_type   VARCHAR2,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN NUMBER;
     
   FUNCTION get_giclr206er_total_loss(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN NUMBER;

END;
/


