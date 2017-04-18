CREATE OR REPLACE PACKAGE CPI.GICLR205LR_PKG
AS
   TYPE header_type IS RECORD (
      company_name            giac_parameters.param_value_v%TYPE,
      company_address         giis_parameters.param_value_v%TYPE,
      report_name             giis_reports.report_title%TYPE,
      report_param_date       VARCHAR2 (100),
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
      assd_no            gicl_res_brdrx_extr.assd_no%TYPE,
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

   TYPE treaty_detail_type IS RECORD (
      claim_id                gicl_res_brdrx_extr.claim_id%TYPE,
      peril_cd                gicl_res_brdrx_extr.peril_cd%TYPE,
      brdrx_record_id2        gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      grp_seq_no2             gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      buss_source2            gicl_res_brdrx_extr.buss_source%TYPE,
      iss_cd2                 giis_issource.iss_cd%TYPE,
      line_cd2                giis_line.line_cd%TYPE,
      subline_cd2             giis_subline.subline_cd%TYPE,
      loss_year2              gicl_res_brdrx_extr.loss_year%TYPE,
      treaty_name2            giis_dist_share.trty_name%TYPE,
      outstanding_loss2       gicl_res_brdrx_extr.loss_reserve%TYPE,
      outstanding_loss_sum    gicl_res_brdrx_extr.loss_reserve%TYPE,
      outstanding_loss2_sum   gicl_res_brdrx_extr.loss_reserve%TYPE,
      facul_ri_cd2            gicl_res_brdrx_rids_extr.prnt_ri_cd%TYPE,
      facul_ri_name2          giis_reinsurer.ri_name%TYPE,
      outstanding_loss3       gicl_res_brdrx_extr.loss_reserve%TYPE
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

   TYPE total_type IS RECORD (
      buss_source_type        VARCHAR2 (2),
      buss_source             gicl_res_brdrx_extr.buss_source%TYPE,
      iss_cd                  giis_issource.iss_cd%TYPE,
      line_cd                 giis_line.line_cd%TYPE,
      subline_cd              giis_subline.subline_cd%TYPE,
      outstanding_loss        gicl_res_brdrx_extr.loss_reserve%TYPE,
      treaty_name             giis_dist_share.trty_name%TYPE,
      outstanding_loss_trty   gicl_res_brdrx_extr.loss_reserve%TYPE
   );

   TYPE total_tab IS TABLE OF total_type;

   TYPE grand_total_type IS RECORD (
      grand_treaty_loss   gicl_res_brdrx_extr.loss_reserve%TYPE,
      grand_os_loss       gicl_res_brdrx_extr.loss_reserve%TYPE,
      treaty_name         giis_dist_share.trty_name%TYPE
   );

   TYPE grand_total_tab IS TABLE OF grand_total_type;

   FUNCTION get_page_header (
      p_from_date     DATE,
      p_to_date       DATE,
      p_as_of_date    DATE,
      p_date_option   VARCHAR2,
      p_os_date       VARCHAR2
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
      p_brdrx_record_id GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
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
      p_session_id        gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source       gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd            giis_issource.iss_cd%TYPE,
      p_line_cd           giis_line.line_cd%TYPE,
      p_subline_cd        giis_subline.subline_cd%TYPE,
      p_loss_year         gicl_res_brdrx_extr.loss_year%TYPE,
      p_brdrx_record_id   gicl_res_brdrx_ds_extr.brdrx_record_id%TYPE
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
      RETURN total_tab PIPELINED;

   FUNCTION get_total_per_iss (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE
   )
      RETURN total_tab PIPELINED;

   FUNCTION get_total_per_buss_source (
      p_session_id         gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id           gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source        gicl_res_brdrx_extr.buss_source%TYPE,
      p_buss_source_type   VARCHAR2
   )
      RETURN total_tab PIPELINED;

   FUNCTION get_total_per_buss_source_type (
      p_session_id         gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id           gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source_type   VARCHAR2
   )
      RETURN total_tab PIPELINED;

   FUNCTION get_report_grand_total (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE
   )
      RETURN grand_total_tab PIPELINED;
      
   /* Handle running multipage column 03.13.2014 - J. Diago */
   TYPE giclr205lr_parent_type IS RECORD (
      buss_source_type               giis_intermediary.intm_type%TYPE,
      buss_source_type_name          giis_intm_type.intm_desc%TYPE,
      iss_cd                         gicl_res_brdrx_extr.iss_cd%TYPE,
      buss_source                    gicl_res_brdrx_extr.buss_source%TYPE,
      buss_source_name               giis_reinsurer.ri_name%TYPE,
      iss_name                       giis_issource.iss_name%TYPE,
      line_cd                        gicl_res_brdrx_extr.line_cd%TYPE,
      line_name                      giis_line.line_name%TYPE,
      subline_cd                     gicl_res_brdrx_extr.subline_cd%TYPE,
      subline_name                   giis_subline.subline_name%TYPE,
      loss_year                      gicl_res_brdrx_extr.loss_year%TYPE,
      loss_year_dummy                VARCHAR2(10),
      grp_seq_no1                    gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no2                    gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no3                    gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no4                    gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      treaty1                        giis_dist_share.trty_name%TYPE,
      treaty2                        giis_dist_share.trty_name%TYPE,
      treaty3                        giis_dist_share.trty_name%TYPE,
      treaty4                        giis_dist_share.trty_name%TYPE
   );
   TYPE giclr205lr_parent_tab IS TABLE OF giclr205lr_parent_type;
   
   TYPE treaty_type IS RECORD (
      grp_seq_no   giis_dist_share.share_cd%TYPE,
      trty_name    giis_dist_share.trty_name%TYPE
   );
   TYPE treaty_tab IS TABLE OF treaty_type;
   
   FUNCTION get_giclr205lr_parent(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE
   )
     RETURN giclr205lr_parent_tab PIPELINED;
     
   TYPE giclr205lr_claim_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      assd_name            GIIS_ASSURED.assd_name%TYPE,
      incept_date          GICL_RES_BRDRX_EXTR.incept_date%TYPE,
      expiry_date          GICL_RES_BRDRX_EXTR.expiry_date%TYPE,
      loss_date            GICL_RES_BRDRX_EXTR.loss_date%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE
   );
   TYPE giclr205lr_claim_tab IS TABLE OF giclr205lr_claim_type;
   
   FUNCTION get_giclr205lr_claim(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE
   )
     RETURN giclr205lr_claim_tab PIPELINED;
     
   TYPE giclr205lr_item_main_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      item_title           VARCHAR2(250)
   );
   TYPE giclr205lr_item_main_tab IS TABLE OF giclr205lr_item_main_type;
   
   FUNCTION get_giclr205lr_item_main(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE
   )
     RETURN giclr205lr_item_main_tab PIPELINED;
     
   TYPE giclr205lr_item_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      tsi_amt              GICL_RES_BRDRX_EXTR.tsi_amt%TYPE,
      peril_name           GIIS_PERIL.peril_name%TYPE,
      intm_name            GIIS_INTERMEDIARY.intm_name%TYPE,
      outstanding_loss     GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      brdrx_record_id      GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE
   );
   TYPE giclr205lr_item_tab IS TABLE OF giclr205lr_item_type;
   
   FUNCTION get_giclr205lr_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE
   )
     RETURN giclr205lr_item_tab PIPELINED;
     
   TYPE outstanding_l_type_v IS RECORD(
      outstanding_loss1       VARCHAR2(1000),
      outstanding_loss2       VARCHAR2(1000),
      outstanding_loss3       VARCHAR2(1000),
      outstanding_loss4       VARCHAR2(1000)
   );
   TYPE outstanding_l_tab_v IS TABLE OF outstanding_l_type_v;
   
   FUNCTION get_giclr205lr_treaty(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_iss_cd             gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_line_cd            gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd         gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year          gicl_res_brdrx_ds_extr.loss_year%TYPE  
   )
     RETURN outstanding_l_tab_v PIPELINED;
     
   TYPE facul_type IS RECORD(
      ri_name1                GIIS_REINSURER.ri_sname%TYPE,
      ri_name2                GIIS_REINSURER.ri_sname%TYPE,
      ri_name3                GIIS_REINSURER.ri_sname%TYPE,
      ri_name4                GIIS_REINSURER.ri_sname%TYPE,
      outstanding_loss1    GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      outstanding_loss2    GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      outstanding_loss3    GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      outstanding_loss4    GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE facul_tab IS TABLE OF facul_type;
   
   FUNCTION get_giclr205lr_facul(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE
   )
     RETURN facul_tab PIPELINED;
     
   TYPE total_os_l_type IS RECORD(
      total_os_loss  GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE total_os_l_tab IS TABLE OF total_os_l_type;
   
   FUNCTION get_giclr205lr_os_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE
   )
     RETURN total_os_l_tab PIPELINED;
     
   FUNCTION get_giclr205lr_treaty_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN outstanding_l_tab_v PIPELINED;
     
   TYPE treaty_ri_type2 IS RECORD (
      grp_seq_no           GICL_RES_BRDRX_RIDS_EXTR.grp_seq_no%TYPE,
      brdrx_rids_record_id GICL_RES_BRDRX_RIDS_EXTR.brdrx_rids_record_id%TYPE,
      line_cd              GICL_RES_BRDRX_RIDS_EXTR.line_cd%TYPE,
      treaty_name          GIIS_DIST_SHARE.trty_name%TYPE,
      trty_ri_cd           GICL_RES_BRDRX_RIDS_EXTR.ri_cd%TYPE,
      ri_cd                GICL_RES_BRDRX_RIDS_EXTR.ri_cd%TYPE,
      ri_name              GIIS_REINSURER.ri_name%TYPE,
      trty_shr_pct         GIIS_TRTY_PANEL.trty_shr_pct%TYPE,
      outstanding_loss     GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE treaty_ri_tab2 IS TABLE OF treaty_ri_type2;
   
   FUNCTION get_treaty_ri2(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED;
   
   TYPE per_group_total_type IS RECORD (
      outstanding_loss     GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE per_group_total_tab IS TABLE OF per_group_total_type;
   
   FUNCTION get_per_group_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_buss_source_type   VARCHAR2,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE
   ) 
     RETURN per_group_total_tab PIPELINED;
     
   TYPE per_group_treaty_type IS RECORD(
      trty_name            GIIS_DIST_SHARE.trty_name%TYPE,
      outstanding_loss     GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE per_group_treaty_tab IS TABLE OF per_group_treaty_type;
   
   FUNCTION get_per_group_treaty(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_buss_source_type   VARCHAR2,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_group_sw           VARCHAR2
   )
     RETURN per_group_treaty_tab PIPELINED;
END GICLR205LR_PKG;
/


