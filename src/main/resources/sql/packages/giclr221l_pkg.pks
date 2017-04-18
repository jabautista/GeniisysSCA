CREATE OR REPLACE PACKAGE CPI.GICLR221L_PKG
AS
   TYPE get_details_type IS RECORD (
      enrollee         gicl_res_brdrx_extr.enrollee%TYPE,
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      report_title     VARCHAR2 (50),
      cf_param_date    VARCHAR2 (100),
      cf_date          VARCHAR2 (100),
      v_exist          VARCHAR2 (1)
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   TYPE get_report_details_type IS RECORD (
      brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      line_cd           giis_line.line_cd%TYPE,
      claim_no          gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no         VARCHAR2 (60),
      assd_no           gicl_res_brdrx_extr.assd_no%TYPE,
      incept_date       VARCHAR2 (100),
      expiry_date       VARCHAR2 (100),
      loss_date         VARCHAR2 (100),
      clm_file_date     gicl_res_brdrx_extr.clm_file_date%TYPE,
      item_no           gicl_res_brdrx_extr.item_no%TYPE,
      grouped_item_no   gicl_res_brdrx_extr.grouped_item_no%TYPE,
      enrollee          gicl_res_brdrx_extr.enrollee%TYPE,
      peril_cd          gicl_res_brdrx_extr.peril_cd%TYPE,
      loss_cat_cd       gicl_res_brdrx_extr.loss_cat_cd%TYPE,
      tsi_amt           gicl_res_brdrx_extr.tsi_amt%TYPE,
      intm_no           gicl_res_brdrx_extr.intm_no%TYPE,
      clm_loss_id       gicl_res_brdrx_extr.clm_loss_id%TYPE,
      paid_losses       gicl_res_brdrx_extr.losses_paid%TYPE,
      cf_policy_no      VARCHAR2 (60),
      assd_name         giis_assured.assd_name%TYPE,
      item_title        VARCHAR2 (200),
      peril_name        giis_peril.peril_name%TYPE,
      intm_ri           VARCHAR2 (1000),
      cf_dv_no          VARCHAR2 (500)
   );

   TYPE get_report_details_tab IS TABLE OF get_report_details_type;

   TYPE get_treaty_header_type IS RECORD (
      grp_seq_no      gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      line_cd         gicl_res_brdrx_ds_extr.line_cd%TYPE,
      enrollee        gicl_res_brdrx_extr.enrollee%TYPE,
      trty_name       giis_dist_share.trty_name%TYPE,
      dummy_measure   NUMBER
   );

   TYPE get_treaty_header_tab IS TABLE OF get_treaty_header_type;

   TYPE get_treaty_details_type IS RECORD (
      enrollee          gicl_res_brdrx_extr.enrollee%TYPE,
      brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      grp_seq_no        gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      share_pct         gicl_res_brdrx_ds_extr.shr_pct%TYPE,
      paid_losses       gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      paid_losses2      gicl_res_brdrx_ds_extr.losses_paid%TYPE,
      ri_name           giis_reinsurer.ri_sname%TYPE
   );

   TYPE get_treaty_details_tab IS TABLE OF get_treaty_details_type;

   TYPE get_ri_details_type IS RECORD (
      enrollee              gicl_res_brdrx_extr.enrollee%TYPE,
      trty_name             giis_dist_share.trty_name%TYPE,
      ri_name               giis_reinsurer.ri_sname%TYPE,
      ri_shr                giis_trty_panel.trty_shr_pct%TYPE,
      dummy_measure         NUMBER,
      ri_cd                 NUMBER,
      trty_ri_cd            NUMBER,
      trty_shr_pct          giis_trty_panel.trty_shr_pct%TYPE,
      grp_seq_no            gicl_res_brdrx_ds_extr.grp_seq_no%TYPE
   );

   TYPE get_ri_details_tab IS TABLE OF get_ri_details_type;

   TYPE get_ri_amount_type IS RECORD (
      enrollee        gicl_res_brdrx_extr.enrollee%TYPE,
      trty_name       giis_dist_share.trty_name%TYPE,
      ri_name         giis_reinsurer.ri_sname%TYPE,
      ri_shr          giis_trty_panel.trty_shr_pct%TYPE,
      dummy_measure   NUMBER,
      trty_ri_cd      NUMBER,
      grp_seq_no      gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      paid_losses3    gicl_res_brdrx_ds_extr.losses_paid%TYPE
   );

   TYPE get_ri_amount_tab IS TABLE OF get_ri_amount_type;

   FUNCTION get_header(
      p_from_date    DATE,
      p_to_date      DATE,
      p_paid_date    NUMBER
   )
      RETURN get_details_tab PIPELINED;
      
   FUNCTION get_details (
      p_from_date    DATE,
      p_to_date      DATE,
      p_paid_date    NUMBER,
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_amt          VARCHAR2
   )
      RETURN get_details_tab PIPELINED;

   FUNCTION get_report_details (
      p_from_date    DATE,
      p_to_date      DATE,
      p_paid_date    NUMBER,
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee     gicl_res_brdrx_extr.enrollee%TYPE,
      p_amt          VARCHAR2
   )
      RETURN get_report_details_tab PIPELINED;

   FUNCTION get_treaty_header (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee     gicl_res_brdrx_extr.enrollee%TYPE
   )
      RETURN get_treaty_header_tab PIPELINED;

   FUNCTION get_treaty_details (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee     gicl_res_brdrx_extr.enrollee%TYPE,
      p_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE
      --p_peril_cd     giis_peril.peril_cd%TYPE,
      --p_claim_no     gicl_res_brdrx_extr.claim_no%TYPE
   )
      RETURN get_treaty_details_tab PIPELINED;

   FUNCTION get_facul (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee     gicl_res_brdrx_extr.enrollee%TYPE,
      p_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE
      --p_peril_cd     giis_peril.peril_cd%TYPE,
      --p_claim_no     gicl_res_brdrx_extr.claim_no%TYPE
   )
      RETURN get_treaty_details_tab PIPELINED;

   FUNCTION get_ri_details (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee     gicl_res_brdrx_extr.enrollee%TYPE
   )
      RETURN get_ri_details_tab PIPELINED;

   FUNCTION get_ri_amount (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee     gicl_res_brdrx_extr.enrollee%TYPE,
      p_ri_cd        NUMBER
   )
      RETURN get_ri_amount_tab PIPELINED;
      
      
   /* Handle running multipage matrix 03.03.2014 - J. Diago */
      
   TYPE giclr221l_parent_type IS RECORD (
      enrollee          gicl_res_brdrx_extr.enrollee%TYPE,
      enrollee_dummy    VARCHAR2 (100),
      grp_seq_no1       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no2       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no3       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no4       gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      treaty1           giis_dist_share.trty_name%TYPE,
      treaty2           giis_dist_share.trty_name%TYPE,
      treaty3           giis_dist_share.trty_name%TYPE,
      treaty4           giis_dist_share.trty_name%TYPE
   );
   TYPE giclr221l_parent_tab IS TABLE OF giclr221l_parent_type;
   
   TYPE treaty_type IS RECORD (
      grp_seq_no   giis_dist_share.share_cd%TYPE,
      trty_name    giis_dist_share.trty_name%TYPE
   );
   TYPE treaty_tab IS TABLE OF treaty_type;
   
   FUNCTION get_giclr221l_parent(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE
   )
     RETURN giclr221l_parent_tab PIPELINED;
     
   TYPE giclr221l_claim_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      enrollee             GICL_RES_BRDRX_EXTR.enrollee%TYPE,
      assd_name            GIIS_ASSURED.assd_name%TYPE,
      incept_date          GICL_RES_BRDRX_EXTR.incept_date%TYPE,
      expiry_date          GICL_RES_BRDRX_EXTR.expiry_date%TYPE,
      loss_date            GICL_RES_BRDRX_EXTR.loss_date%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE
   );
   TYPE giclr221l_claim_tab IS TABLE OF giclr221l_claim_type;
   
   FUNCTION get_giclr221l_claim(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee           GICL_RES_BRDRX_EXTR.enrollee%TYPE
   )
     RETURN giclr221l_claim_tab PIPELINED;
     
   TYPE giclr221l_item_main_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      enrollee             GICL_RES_BRDRX_EXTR.enrollee%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      item_title           VARCHAR2(250)
   );
   TYPE giclr221l_item_main_tab IS TABLE OF giclr221l_item_main_type;
   
   FUNCTION get_giclr221l_item_main(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee           GICL_RES_BRDRX_EXTR.enrollee%TYPE
   )
     RETURN giclr221l_item_main_tab PIPELINED;
     
   TYPE giclr221l_item_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      enrollee             GICL_RES_BRDRX_EXTR.enrollee%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      tsi_amt              GICL_RES_BRDRX_EXTR.tsi_amt%TYPE,
      loss_cat_des         GIIS_LOSS_CTGRY.loss_cat_des%TYPE,
      intm_name            GIIS_INTERMEDIARY.intm_name%TYPE,
      dv_no                VARCHAR2(150),
      paid_losses          GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      brdrx_record_id      GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE
   );
   TYPE giclr221l_item_tab IS TABLE OF giclr221l_item_type;
   
   FUNCTION get_giclr221l_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee           GICL_RES_BRDRX_EXTR.enrollee%TYPE,
      p_paid_date          NUMBER,
      p_from_date          DATE,
      p_to_date            DATE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE
   )
     RETURN giclr221l_item_tab PIPELINED;
     
   TYPE paid_losses_type_v IS RECORD(
      paid_losses1       VARCHAR2(1000),
      paid_losses2       VARCHAR2(1000),
      paid_losses3       VARCHAR2(1000),
      paid_losses4       VARCHAR2(1000)
   );
   TYPE paid_losses_tab_v IS TABLE OF paid_losses_type_v;
   
   FUNCTION get_giclr221l_treaty(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee_dummy     GICL_RES_BRDRX_EXTR.enrollee%TYPE,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE
   )
     RETURN paid_losses_tab_v PIPELINED;
     
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
   
   FUNCTION get_giclr221l_facul(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee_dummy     GICL_RES_BRDRX_EXTR.enrollee%TYPE,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE
   )
     RETURN facul_tab PIPELINED;
     
   TYPE total_paid_losses_type IS RECORD(
      total_paid_losses  GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE total_paid_losses_tab IS TABLE OF total_paid_losses_type;
   
   FUNCTION get_giclr221l_losses_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee           GICL_RES_BRDRX_EXTR.enrollee%TYPE
   )
      RETURN total_paid_losses_tab PIPELINED;
      
   FUNCTION get_giclr221l_treaty_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee_dummy     GICL_RES_BRDRX_EXTR.enrollee%TYPE
   )
     RETURN paid_losses_tab_v PIPELINED;
     
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
      paid_losses          GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE treaty_ri_tab2 IS TABLE OF treaty_ri_type2;
   
   FUNCTION get_treaty_ri2(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee           GICL_RES_BRDRX_EXTR.enrollee%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED;
END;
/


