CREATE OR REPLACE PACKAGE CPI.giclr222le_pkg
AS
   TYPE header_type IS RECORD (
      company_name      giac_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      report_title      giis_reports.report_title%TYPE,
      paramdate         VARCHAR2 (100),
      date_period       VARCHAR2 (100)
   );

   TYPE header_tab IS TABLE OF header_type;

   TYPE report_details_type IS RECORD (
      policy_no         gicl_res_brdrx_extr.policy_no%TYPE,
      cf_policy         VARCHAR2 (60),
      assd_no           gicl_res_brdrx_extr.assd_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      incept_date       gicl_res_brdrx_extr.incept_date%TYPE,
      expiry_date       gicl_res_brdrx_extr.expiry_date%TYPE,
      term              VARCHAR2 (30),
      claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      line_cd           gicl_res_brdrx_extr.line_cd%TYPE,
      claim_no          gicl_res_brdrx_extr.claim_no%TYPE,
      loss_date         gicl_res_brdrx_extr.loss_date%TYPE,
      clm_file_date     gicl_res_brdrx_extr.clm_file_date%TYPE,
      clm_loss_id       gicl_res_brdrx_extr.clm_loss_id%TYPE,
      item_no           gicl_res_brdrx_extr.item_no%TYPE,
      item_title        VARCHAR2 (200),
      grouped_item_no   gicl_res_brdrx_extr.grouped_item_no%TYPE,
      peril_cd          gicl_res_brdrx_extr.peril_cd%TYPE,
      --peril_name          GIIS_PERIL.PERIL_NAME%TYPE,
      loss_cat_cd       gicl_res_brdrx_extr.loss_cat_cd%TYPE,
      loss_cat_des      giis_loss_ctgry.loss_cat_des%TYPE,
      paid_losses       gicl_res_brdrx_extr.losses_paid%TYPE,
      paid_expenses     gicl_res_brdrx_extr.expenses_paid%TYPE,
      intm_no           gicl_res_brdrx_extr.intm_no%TYPE,
      tsi_amt           gicl_res_brdrx_extr.tsi_amt%TYPE,
      cf_intm           VARCHAR2 (200),
      cf_intm_ri        VARCHAR2 (1000),
      cf_dv_no          VARCHAR2 (500),
      brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE
   );

   TYPE report_details_tab IS TABLE OF report_details_type;

   TYPE treaty_header_type IS RECORD (
      policy_no     gicl_res_brdrx_extr.policy_no%TYPE,
      treaty_name   giis_dist_share.trty_name%TYPE,
      line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      grp_seq_no    gicl_res_brdrx_ds_extr.grp_seq_no%TYPE
   );

   TYPE treaty_header_tab IS TABLE OF treaty_header_type;

   TYPE treaty_details_type IS RECORD (
      policy_no            gicl_res_brdrx_extr.policy_no%TYPE,
      claim_id             gicl_res_brdrx_extr.claim_id%TYPE,
      treaty_name          giis_dist_share.trty_name%TYPE,
      brdrx_record_id      gicl_res_brdrx_ds_extr.brdrx_record_id%TYPE,
      brdrx_ds_record_id   gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE,
      grp_seq_no           gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      shr_pct              gicl_res_brdrx_ds_extr.shr_pct%TYPE,
      paid_losses          gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      paid_expenses        gicl_res_brdrx_ds_extr.expenses_paid%TYPE,
      facul_ri_cd          gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      facul_ri_name        giis_reinsurer.ri_name%TYPE,
      facul_shr_ri_pct     gicl_res_brdrx_rids_extr.shr_ri_pct%TYPE,
      paid_losses2         gicl_res_brdrx_rids_extr.losses_paid%TYPE,
      paid_expenses2       gicl_res_brdrx_ds_extr.expenses_paid%TYPE
   );

   TYPE treaty_details_tab IS TABLE OF treaty_details_type;

   TYPE treaty_ri_type IS RECORD (
      policy_no              gicl_res_brdrx_extr.policy_no%TYPE,
      grp_seq_no             gicl_res_brdrx_rids_extr.grp_seq_no%TYPE,
      brdrx_rids_record_id   gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE,
      line_cd                gicl_res_brdrx_rids_extr.line_cd%TYPE,
      treaty_name            giis_dist_share.trty_name%TYPE,
      trty_ri_cd             gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      ri_cd                  gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      ri_name                giis_reinsurer.ri_name%TYPE,
      trty_shr_pct           giis_trty_panel.trty_shr_pct%TYPE
   );

   TYPE treaty_ri_tab IS TABLE OF treaty_ri_type;

   TYPE treaty_ri_amt_type IS RECORD (
      policy_no              gicl_res_brdrx_extr.policy_no%TYPE,
      grp_seq_no             gicl_res_brdrx_rids_extr.grp_seq_no%TYPE,
      brdrx_rids_record_id   gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE,
      line_cd                gicl_res_brdrx_rids_extr.line_cd%TYPE,
      treaty_name            giis_dist_share.trty_name%TYPE,
      trty_ri_cd             gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      ri_cd                  gicl_res_brdrx_rids_extr.ri_cd%TYPE,
      ri_name                giis_reinsurer.ri_name%TYPE,
      trty_shr_pct           giis_trty_panel.trty_shr_pct%TYPE,
      paid_losses3           gicl_res_brdrx_rids_extr.losses_paid%TYPE,
      paid_expenses3         gicl_res_brdrx_ds_extr.expenses_paid%TYPE
   );

   TYPE treaty_ri_amt_tab IS TABLE OF treaty_ri_amt_type;

   FUNCTION cf_companyformula
      RETURN VARCHAR2;

   FUNCTION cf_com_addressformula
      RETURN VARCHAR2;

   FUNCTION report_nameformula
      RETURN VARCHAR2;

   FUNCTION cf_paramdateformula (p_paid_date NUMBER)
      RETURN VARCHAR2;

   FUNCTION cf_dateformula (p_from_date DATE, p_to_date DATE)
      RETURN VARCHAR2;

   FUNCTION get_report_header (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_paid_date    NUMBER,
      p_from_date    DATE,
      p_to_date      DATE
   )
      RETURN header_tab PIPELINED;

   FUNCTION cf_policyformula (p_policy_no gicl_res_brdrx_extr.policy_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION item_titleformula (
      p_claim_id          gicl_claims.claim_id%TYPE,
      p_line_cd           gicl_claims.line_cd%TYPE,
      p_item_no           gicl_accident_dtl.item_no%TYPE,
      p_grouped_item_no   gicl_accident_dtl.grouped_item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION loss_cat_desformula (
      p_loss_cat_cd   giis_loss_ctgry.loss_cat_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION cf_intmformula (
      p_claim_id   gicl_intm_itmperil.claim_id%TYPE,
      p_item_no    gicl_intm_itmperil.item_no%TYPE,
      p_peril_cd   gicl_intm_itmperil.peril_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION cf_intm_riformula (
      p_claim_id   gicl_intm_itmperil.claim_id%TYPE,
      p_item_no    gicl_intm_itmperil.item_no%TYPE,
      p_peril_cd   gicl_intm_itmperil.peril_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION cf_dv_noformula (
      p_claim_id        gicl_clm_res_hist.claim_id%TYPE,
      p_item_no         giac_chk_disbursement.item_no%TYPE,
      p_clm_loss_id     gicl_clm_res_hist.clm_loss_id%TYPE,
      p_paid_losses     gicl_res_brdrx_extr.losses_paid%TYPE,
      p_paid_expenses   gicl_res_brdrx_extr.expenses_paid%TYPE,
      p_paid_date       NUMBER,
      p_from_date       DATE,
      p_to_date         DATE
   )
      RETURN VARCHAR2;

   FUNCTION peril_nameformula (
      p_peril_cd   giis_peril.peril_cd%TYPE,
      p_line_cd    giis_peril.line_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION assd_nameformula (p_assd_no giis_assured.assd_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_report_details (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_policy_no    gicl_res_brdrx_extr.policy_no%TYPE,
      p_paid_date    NUMBER,
      p_from_date    DATE,
      p_to_date      DATE
   )
      RETURN report_details_tab PIPELINED;

   FUNCTION treaty_nameformula (
      p_grp_seq_no   giis_dist_share.share_cd%TYPE,
      p_line_cd      giis_dist_share.line_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION facul_ri_nameformula (p_facul_ri_cd giis_reinsurer.ri_cd%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_treaty_header (
      p_session_id   gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_ds_extr.claim_id%TYPE,
      p_policy_no    gicl_res_brdrx_extr.policy_no%TYPE
   )
      RETURN treaty_header_tab PIPELINED;

   FUNCTION get_treaty_details (
      p_session_id        gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      p_policy_no         gicl_res_brdrx_extr.policy_no%TYPE,
      p_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE
   )
      RETURN treaty_details_tab PIPELINED;

   FUNCTION get_treaty_facul (
      p_session_id        gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      p_policy_no         gicl_res_brdrx_extr.policy_no%TYPE,
      p_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE
   )
      RETURN treaty_details_tab PIPELINED;

   FUNCTION ri_shrformula (
      p_line_cd      giis_trty_panel.line_cd%TYPE,
      p_grp_seq_no   giis_trty_panel.trty_seq_no%TYPE,
      p_ri_cd        giis_trty_panel.ri_cd%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_treaty_ri (
      p_session_id   gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_policy_no    gicl_res_brdrx_extr.policy_no%TYPE
   )
      RETURN treaty_ri_tab PIPELINED;

   FUNCTION get_treaty_ri_amt (
      p_session_id   gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_policy_no    gicl_res_brdrx_extr.policy_no%TYPE,
      p_ri_cd        gicl_res_brdrx_rids_extr.ri_cd%TYPE
   )
      RETURN treaty_ri_amt_tab PIPELINED;

   /* Added by : J. Diago */
   TYPE giclr222le_header_type IS RECORD (
      policy_no         gicl_res_brdrx_extr.policy_no%TYPE,
      policy_no_dummy   VARCHAR2 (50),
      assd_no           gicl_res_brdrx_extr.assd_no%TYPE,
      incept_date       gicl_res_brdrx_extr.incept_date%TYPE,
      expiry_date       gicl_res_brdrx_extr.expiry_date%TYPE,
      term              VARCHAR2 (100),
      assd_name         giis_assured.assd_name%TYPE,
      grp_seq_no1       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no2       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no3       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no4       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      treaty1           giis_dist_share.trty_name%TYPE,
      treaty2           giis_dist_share.trty_name%TYPE,
      treaty3           giis_dist_share.trty_name%TYPE,
      treaty4           giis_dist_share.trty_name%TYPE
   );
   TYPE giclr222le_header_tab IS TABLE OF giclr222le_header_type;

   TYPE treaty_type IS RECORD (
      grp_seq_no   giis_dist_share.share_cd%TYPE,
      trty_name    giis_dist_share.trty_name%TYPE
   );
   TYPE treaty_tab IS TABLE OF treaty_type;
   
   TYPE giclr222le_claim_type IS RECORD(
      record_id            GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      loss_date            GICL_RES_BRDRX_EXTR.loss_date%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE
   );
   TYPE giclr222le_claim_tab IS TABLE OF giclr222le_claim_type;
   
   TYPE giclr222le_item_main_type IS RECORD(
      record_id            GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      loss_date            GICL_RES_BRDRX_EXTR.loss_date%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      item_title           VARCHAR2(250),
      peril_cd             GICL_RES_BRDRX_EXTR.peril_cd%TYPE
   );
   TYPE giclr222le_item_main_tab IS TABLE OF giclr222le_item_main_type;
   
   TYPE giclr222le_item_type IS RECORD(
      record_id            GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      loss_date            GICL_RES_BRDRX_EXTR.loss_date%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      clm_loss_id          GICL_RES_BRDRX_EXTR.clm_loss_id%TYPE,
      tsi_amt              GICL_RES_BRDRX_EXTR.tsi_amt%TYPE,
      loss_cat_cd          GICL_RES_BRDRX_EXTR.loss_cat_cd%TYPE,
      loss_cat_desc        GIIS_LOSS_CTGRY.loss_cat_des%TYPE,
      intm_no              GICL_RES_BRDRX_EXTR.intm_no%TYPE,
      intm_name            GIIS_INTERMEDIARY.intm_name%TYPE,
      paid_losses          GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_expenses        GICL_RES_BRDRX_EXTR.expenses_paid%TYPE,
      dv_no                VARCHAR2(300),
      peril_cd             GICL_RES_BRDRX_EXTR.peril_cd%TYPE
   );
   TYPE giclr222le_item_tab IS TABLE OF giclr222le_item_type;
   
   TYPE paid_losses_type_v IS RECORD(
      paid_losses1         VARCHAR2(1000),
      paid_losses2         VARCHAR2(1000),
      paid_losses3         VARCHAR2(1000),
      paid_losses4         VARCHAR2(1000),
      paid_expenses1       VARCHAR2(1000),
      paid_expenses2       VARCHAR2(1000),
      paid_expenses3       VARCHAR2(1000),
      paid_expenses4       VARCHAR2(1000)
   );
   TYPE paid_losses_tab_v IS TABLE OF paid_losses_type_v;
   
   TYPE facul_type IS RECORD(
      ri_name1             GIIS_REINSURER.ri_sname%TYPE,
      ri_name2             GIIS_REINSURER.ri_sname%TYPE,
      ri_name3             GIIS_REINSURER.ri_sname%TYPE,
      ri_name4             GIIS_REINSURER.ri_sname%TYPE,
      paid_losses1         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses2         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses3         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses4         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_expenses1       GICL_RES_BRDRX_EXTR.expenses_paid%TYPE,
      paid_expenses2       GICL_RES_BRDRX_EXTR.expenses_paid%TYPE,
      paid_expenses3       GICL_RES_BRDRX_EXTR.expenses_paid%TYPE,
      paid_expenses4       GICL_RES_BRDRX_EXTR.expenses_paid%TYPE
   );
   TYPE facul_tab IS TABLE OF facul_type;
   
   TYPE total_paid_le_type IS RECORD(
      total_paid_losses    GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      total_paid_expenses  GICL_RES_BRDRX_EXTR.expenses_paid%TYPE
   );
   TYPE total_paid_le_tab IS TABLE OF total_paid_le_type;
   
   TYPE treaty_ri_type2 IS RECORD (
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      grp_seq_no           GICL_RES_BRDRX_RIDS_EXTR.grp_seq_no%TYPE,
      brdrx_rids_record_id GICL_RES_BRDRX_RIDS_EXTR.brdrx_rids_record_id%TYPE,
      line_cd              GICL_RES_BRDRX_RIDS_EXTR.line_cd%TYPE,
      treaty_name          GIIS_DIST_SHARE.trty_name%TYPE,
      trty_ri_cd           GICL_RES_BRDRX_RIDS_EXTR.ri_cd%TYPE,
      ri_cd                GICL_RES_BRDRX_RIDS_EXTR.ri_cd%TYPE,
      ri_name              GIIS_REINSURER.ri_name%TYPE,
      trty_shr_pct         GIIS_TRTY_PANEL.trty_shr_pct%TYPE,
      paid_losses          GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_expenses        GICL_RES_BRDRX_EXTR.expenses_paid%TYPE
   );
   TYPE treaty_ri_tab2 IS TABLE OF treaty_ri_type2;
   
   FUNCTION get_giclr222le_header(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN giclr222le_header_tab PIPELINED;
     
   FUNCTION get_giclr222le_claim(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE
   )
     RETURN giclr222le_claim_tab PIPELINED;
     
   FUNCTION get_giclr222le_item_main(
      --p_record_id          GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE
   )
     RETURN giclr222le_item_main_tab PIPELINED;
   
   FUNCTION get_giclr222le_item(
      --p_record_id          GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_paid_date          NUMBER,
      p_from_date          DATE,
      p_to_date            DATE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE
      --p_peril_cd           GICL_RES_BRDRX_EXTR.peril_cd%TYPE
   )
     RETURN giclr222le_item_tab PIPELINED;
     
   FUNCTION get_giclr222le_treaty(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN paid_losses_tab_v PIPELINED;
     
   FUNCTION get_giclr222le_facul(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN facul_tab PIPELINED;
   
   FUNCTION get_giclr222le_loss_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN total_paid_le_tab PIPELINED;
     
   FUNCTION get_giclr222le_treaty_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN paid_losses_tab_v PIPELINED;
     
   FUNCTION get_treaty_ri2(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED;
END giclr222le_pkg;
/


