CREATE OR REPLACE PACKAGE CPI.gicl_claims_pkg
AS
   FUNCTION policy_has_claims (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,   
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN BOOLEAN;
 
   FUNCTION get_clm_no (p_claim_id VARCHAR2)
      RETURN VARCHAR;

   FUNCTION chk_for_pending_claims (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN gicl_claims.claim_id%TYPE;

   FUNCTION chk_pending_claims_for_pack (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN gicl_claims.claim_id%TYPE;

   FUNCTION get_claim_id (
      p_line_cd      IN   gicl_claims.line_cd%TYPE,
      p_subline_cd   IN   gicl_claims.subline_cd%TYPE,
      p_iss_cd       IN   gicl_claims.iss_cd%TYPE,
      p_issue_yy     IN   gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   IN   gicl_claims.pol_seq_no%TYPE,
      p_renew_no     IN   gicl_claims.renew_no%TYPE
   )
      RETURN NUMBER;

   TYPE gipi_related_claims_type IS RECORD (
      claim_id        gicl_claims.claim_id%TYPE, -- added by: Nica 05.11.2013
      line_cd         gicl_claims.line_cd%TYPE,
      claim_no        VARCHAR2 (100),
      clm_file_date   gicl_claims.clm_file_date%TYPE,
      str_clm_file_date VARCHAR2 (50), -- added by: Angelo 04.22.2014
      clm_setl_date   gicl_claims.clm_setl_date%TYPE,
      claim_amt       gicl_claims.exp_res_amt%TYPE,
      paid_amt        gicl_claims.exp_pd_amt%TYPE,
      clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE
   );

   TYPE gipi_related_claims_tab IS TABLE OF gipi_related_claims_type;

   TYPE gicl_claims_listing_type IS RECORD (
      claim_id              gicl_claims.claim_id%TYPE,
      claim_no              VARCHAR2 (1000),
      policy_no             VARCHAR2 (1000),
      claim_stat_desc       giis_clm_stat.clm_stat_desc%TYPE,
      in_house_adjustment   gicl_claims.in_hou_adj%TYPE,
      assured_name          gicl_claims.assured_name%TYPE,
      plate_no              gicl_claims.plate_no%TYPE,
      pack_policy           VARCHAR2 (1),
      line_cd               gicl_claims.line_cd%TYPE,
      subline_cd            gicl_claims.subline_cd%TYPE,
      iss_cd                gicl_claims.iss_cd%TYPE,
      clm_yy                gicl_claims.clm_yy%TYPE,
      clm_seq_no            gicl_claims.clm_seq_no%TYPE,
      pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
      pol_seq_no            gicl_claims.pol_seq_no%TYPE,
      renew_no              gicl_claims.renew_no%TYPE,
      recovery_id           gicl_clm_recovery.recovery_id%TYPE,
      rec_year              gicl_clm_recovery.rec_year%TYPE,
      rec_seq_no            gicl_clm_recovery.rec_seq_no%TYPE,
      line_cd2              gicl_clm_recovery.line_cd%TYPE,
      iss_cd2               gicl_clm_recovery.iss_cd%TYPE,
      line_cd3              gicl_claims.line_cd%TYPE,
      subline_cd2           gicl_claims.subline_cd%TYPE,
      issue_yy              gicl_claims.issue_yy%TYPE,
      clm_stat_cd           gicl_claims.clm_stat_cd%TYPE,
      loss_cat_cd           gicl_claims.loss_cat_cd%TYPE,
      assd_no               gicl_claims.assd_no%TYPE,
      loss_date             VARCHAR2 (100), --gicl_claims.loss_date%TYPE,
      clm_file_date         gicl_claims.clm_file_date%TYPE,
      cancel_tag            gicl_clm_recovery.cancel_tag%TYPE,
      recovery_no           VARCHAR2 (1000),
      wra                   VARCHAR2 (5),
      rec_stat_desc         giis_recovery_status.rec_stat_desc%TYPE,
      rec_stat_cd           giis_recovery_status.rec_stat_cd%TYPE,
      loss_cat_des          VARCHAR2 (1000),
      dist                  VARCHAR2 (1),
      entry                 VARCHAR2 (1),
      dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
      expiry_date           gicl_claims.expiry_date%TYPE,
      incept_date           gipi_polbasic.incept_date%TYPE,
      pol_eff_date          gicl_claims.pol_eff_date%TYPE,
      catastrophic_cd       gicl_claims.catastrophic_cd%TYPE,
      peril_cd              giis_loss_ctgry.peril_cd%TYPE,
      item_limit            NUMBER,
      district_no           gicl_claims.district_no%TYPE,
      block_id              gicl_claims.block_id%TYPE,
      recovery_sw           NUMBER (1),
      clm_stat_desc         giis_clm_stat.clm_stat_desc%TYPE,
      recovery_acct_id        gicl_recovery_payt.recovery_acct_id%TYPE,
      package_policy        VARCHAR2(100),
      grouped_item_title    gicl_accident_dtl.grouped_item_title%TYPE,
      assignee                gicl_motor_car_dtl.assignee%TYPE
   );

   TYPE gicl_claims_listing_tab IS TABLE OF gicl_claims_listing_type;
/*Added by pjsantos 11/11/2016, for optimization GENQA 5825*/
 TYPE gicl_claims_listing_type2 IS RECORD (
      count_                NUMBER,
      rownum_               NUMBER,
      recovery_id           gicl_clm_recovery.recovery_id%TYPE,      
      claim_id              gicl_claims.claim_id%TYPE,
      line_cd2              gicl_clm_recovery.line_cd%TYPE,
      rec_year              gicl_clm_recovery.rec_year%TYPE,
      rec_seq_no            gicl_clm_recovery.rec_seq_no%TYPE,
      line_cd               gicl_claims.line_cd%TYPE,
      subline_cd            gicl_claims.subline_cd%TYPE,
      iss_cd                gicl_claims.iss_cd%TYPE,
      iss_cd2               gicl_clm_recovery.iss_cd%TYPE,
      clm_yy                gicl_claims.clm_yy%TYPE,
      clm_seq_no            gicl_claims.clm_seq_no%TYPE,
      line_cd3              gicl_claims.line_cd%TYPE,
      subline_cd2           gicl_claims.subline_cd%TYPE,
      pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
      issue_yy              gicl_claims.issue_yy%TYPE,
      pol_seq_no            gicl_claims.pol_seq_no%TYPE,
      renew_no              gicl_claims.renew_no%TYPE, 
      clm_stat_cd           gicl_claims.clm_stat_cd%TYPE,
      loss_cat_cd           gicl_claims.loss_cat_cd%TYPE,
      assd_no               gicl_claims.assd_no%TYPE,
      assured_name          gicl_claims.assured_name%TYPE,
      loss_date             VARCHAR2 (100), --gicl_claims.loss_date%TYPE, 
      clm_file_date         gicl_claims.clm_file_date%TYPE,
      cancel_tag            gicl_clm_recovery.cancel_tag%TYPE, 
      dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
      recovery_no           VARCHAR2 (1000),
      claim_no              VARCHAR2 (1000),
      policy_no             VARCHAR2 (1000),
      loss_cat_des          VARCHAR2 (1000),
      clm_stat_desc         giis_clm_stat.clm_stat_desc%TYPE,
      wra                   VARCHAR2 (5),
      rec_stat_desc         giis_recovery_status.rec_stat_desc%TYPE,
      rec_stat_cd           giis_recovery_status.rec_stat_cd%TYPE,
      recovery_acct_id      gicl_recovery_payt.recovery_acct_id%TYPE,
      dist                  VARCHAR2 (1),
      entry                 VARCHAR2 (1)      
   );

   TYPE gicl_claims_listing_tab2 IS TABLE OF gicl_claims_listing_type2;
   FUNCTION get_related_claims (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_related_claims_tab PIPELINED;

   FUNCTION get_claim_listing (
      p_assured_name      gicl_claims.assured_name%TYPE,
      p_plate_number      gicl_claims.plate_no%TYPE,
      p_claim_stat_desc   VARCHAR2,
      p_claim_processor   gicl_claims.in_hou_adj%TYPE,
      p_line_cd           gicl_claims.line_cd%TYPE,
      p_subline_cd        gicl_claims.subline_cd%TYPE,
      p_iss_cd            gicl_claims.iss_cd%TYPE,
      p_clm_yy            gicl_claims.clm_yy%TYPE,
      p_clm_seq_no        gicl_claims.clm_seq_no%TYPE,
      p_pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
      p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      p_renew_no          gicl_claims.pol_iss_cd%TYPE,
      p_module_id         giis_modules.module_id%TYPE,
      p_user_id           giis_users.user_id%TYPE
   )
      RETURN gicl_claims_listing_tab PIPELINED;
   FUNCTION get_lost_recovery_listing (
      p_module_id      giis_modules.module_id%TYPE,
      p_claim_no       VARCHAR2,
      p_policy_no      VARCHAR2,
      p_recovery_no    VARCHAR2,
      p_assured_name   VARCHAR2,
      p_file_date      VARCHAR2,
      p_loss_date      VARCHAR2,
      p_user_id        VARCHAR2,
      p_line_cd        VARCHAR2,
      p_rec_stat_desc  VARCHAR2,
      p_order_by       VARCHAR2,
      p_asc_desc_flag  VARCHAR2,
      p_first_row      NUMBER,
      p_last_row       NUMBER
   )
      RETURN gicl_claims_listing_tab2 PIPELINED;
   
   TYPE gicl_claims_type IS RECORD (
      claim_id                 gicl_claims.claim_id%TYPE,
      line_cd                  gicl_claims.line_cd%TYPE,
      line_name                   giis_line.line_name%TYPE,
      subline_cd               gicl_claims.subline_cd%TYPE,
      issue_yy                 gicl_claims.issue_yy%TYPE,
      pol_seq_no               gicl_claims.pol_seq_no%TYPE,
      renew_no                 gicl_claims.renew_no%TYPE,
      pol_iss_cd               gicl_claims.pol_iss_cd%TYPE,
      clm_yy                   gicl_claims.clm_yy%TYPE,
      clm_seq_no               gicl_claims.clm_seq_no%TYPE,
      iss_cd                   gicl_claims.iss_cd%TYPE,
      clm_control              gicl_claims.clm_control%TYPE,
      clm_coop                 gicl_claims.clm_coop%TYPE,
      assd_no                  gicl_claims.assd_no%TYPE,
      recovery_sw              gicl_claims.recovery_sw%TYPE,
      clm_file_date            gicl_claims.clm_file_date%TYPE,
      loss_date                gicl_claims.loss_date%TYPE,
      entry_date               gicl_claims.entry_date%TYPE,
      dsp_loss_date            gicl_claims.dsp_loss_date%TYPE,
      clm_stat_cd              gicl_claims.clm_stat_cd%TYPE,
      clm_setl_date            gicl_claims.clm_setl_date%TYPE,
      loss_pd_amt              gicl_claims.loss_pd_amt%TYPE,
      loss_res_amt             gicl_claims.loss_res_amt%TYPE,
      exp_pd_amt               gicl_claims.exp_pd_amt%TYPE,
      loss_loc1                gicl_claims.loss_loc1%TYPE,
      loss_loc2                gicl_claims.loss_loc2%TYPE,
      loss_loc3                gicl_claims.loss_loc3%TYPE,
      in_hou_adj               gicl_claims.in_hou_adj%TYPE,
      pol_eff_date             gicl_claims.pol_eff_date%TYPE,
      csr_no                   gicl_claims.csr_no%TYPE,
      loss_cat_cd              gicl_claims.loss_cat_cd%TYPE,
      intm_no                  gicl_claims.intm_no%TYPE,
      clm_amt                  gicl_claims.clm_amt%TYPE,
      loss_dtls                gicl_claims.loss_dtls%TYPE,
      obligee_no               gicl_claims.obligee_no%TYPE,
      exp_res_amt              gicl_claims.exp_res_amt%TYPE,
      assured_name             gicl_claims.assured_name%TYPE,
      ri_cd                    gicl_claims.ri_cd%TYPE,
      plate_no                 gicl_claims.plate_no%TYPE,
      clm_dist_tag             gicl_claims.clm_dist_tag%TYPE,
      assd_name2               gicl_claims.assd_name2%TYPE,
      old_stat_cd              gicl_claims.old_stat_cd%TYPE,
      close_date               gicl_claims.close_date%TYPE,
      expiry_date              gicl_claims.expiry_date%TYPE,
      acct_of_cd               gicl_claims.acct_of_cd%TYPE,
      max_endt_seq_no          gicl_claims.max_endt_seq_no%TYPE,
      remarks                  gicl_claims.remarks%TYPE,
      catastrophic_cd          gicl_claims.catastrophic_cd%TYPE,
      cred_branch              gicl_claims.cred_branch%TYPE,
      net_pd_loss              gicl_claims.net_pd_loss%TYPE,
      net_pd_exp               gicl_claims.net_pd_exp%TYPE,
      refresh_sw               gicl_claims.refresh_sw%TYPE,
      total_tag                gicl_claims.total_tag%TYPE,
      reason_cd                gicl_claims.reason_cd%TYPE,
      province_cd              gicl_claims.province_cd%TYPE,
      city_cd                  gicl_claims.city_cd%TYPE,
      zip_cd                   gicl_claims.zip_cd%TYPE,
      pack_policy_id           gicl_claims.pack_policy_id%TYPE,
      motor_no                 gicl_claims.motor_no%TYPE,
      serial_no                gicl_claims.serial_no%TYPE,
      settling_agent_cd        gicl_claims.settling_agent_cd%TYPE,
      survey_agent_cd          gicl_claims.survey_agent_cd%TYPE,
      tran_no                  gicl_claims.tran_no%TYPE,
      contact_no               gicl_claims.contact_no%TYPE,
      email_address            gicl_claims.email_address%TYPE,
      special_instructions     gicl_claims.special_instructions%TYPE,
      def_processor            gicl_claims.def_processor%TYPE,
      location_cd              gicl_claims.location_cd%TYPE,
      block_id                 gicl_claims.block_id%TYPE,
      district_no              gicl_claims.district_no%TYPE,
      reported_by              gicl_claims.reported_by%TYPE,
      cpi_rec_no               gicl_claims.cpi_rec_no%TYPE,
      cpi_branch_cd            gicl_claims.cpi_branch_cd%TYPE,
      user_id                  gicl_claims.user_id%TYPE,
      last_update              gicl_claims.last_update%TYPE,
      clm_stat_desc            giis_clm_stat.clm_stat_desc%TYPE,
      dsp_ri_name              giis_reinsurer.ri_name%TYPE,
      dsp_province_desc        giis_province.province_desc%TYPE,
      dsp_city_desc            giis_city.city%TYPE,
      dsp_cat_desc             gicl_cat_dtl.catastrophic_desc%TYPE,
      dsp_loss_cat_desc        giis_loss_ctgry.loss_cat_des%TYPE,
      dsp_in_hou_adj_name      giis_users.user_name%TYPE,
      pack_pol_flag            giis_line.pack_pol_flag%TYPE,
      dsp_cred_br_desc         giis_issource.iss_name%TYPE,
      block_no                 giis_block.block_no%TYPE,
      location_desc            giis_ca_location.location_desc%TYPE,
      pack_pol_no              VARCHAR2 (30),
      issue_date               gipi_polbasic.issue_date%TYPE,
      redist_sw                gicl_clm_reserve.redist_sw%TYPE,
      claim_no                 VARCHAR2 (100),
      policy_no                VARCHAR2 (100),
      loss_ctgry               VARCHAR2 (200),
      op_number                VARCHAR2 (3200),
      item_no                  gipi_vehicle.item_no%TYPE,
      gicl_mortgagee_exist     VARCHAR2 (1),
      gicl_item_peril_exist    VARCHAR2 (1),
      gicl_clm_item_exist      VARCHAR2 (1),
      gicl_clm_reserve_exist   VARCHAR2 (1),
      dsp_settling_name        VARCHAR2 (32000),
      dsp_survey_name          VARCHAR2 (32000),
      dsp_policy_no            VARCHAR2 (32000),
      dsp_claim_no             VARCHAR2 (32000),
      peril_cd                 giis_loss_ctgry.peril_cd%TYPE,
      item_limit               NUMBER,
      dsp_acct_of              VARCHAR2 (32000),
      policy_id                   gipi_polbasic.policy_id%TYPE
   );

   TYPE gicl_claims_tab IS TABLE OF gicl_claims_type;

   FUNCTION get_basic_info (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN gicl_claims_tab PIPELINED;

   FUNCTION get_clm_assured (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_renew_no     gicl_claims.line_cd%TYPE
   )
      RETURN gicl_claims_listing_tab PIPELINED;

   PROCEDURE update_gicl_claims_gicls010 (
      p_claim_id        gicl_claims.claim_id%TYPE,
      p_clm_stat_cd     gicl_claims.clm_stat_cd%TYPE,
      p_clm_control     gicl_claims.clm_control%TYPE,
      p_clm_coop        gicl_claims.clm_coop%TYPE,
      p_unpaid_prem     VARCHAR2,
      p_upd_user_flag   VARCHAR2
   );

   TYPE basic_intm_type IS RECORD (
      claim_id         gicl_claims.claim_id%TYPE,
      policy_no        VARCHAR2 (100),
      intm_no          gipi_comm_invoice.intrmdry_intm_no%TYPE,
      parent_intm_no   giis_intermediary.parent_intm_no%TYPE,
      intm_type        giis_intermediary.intm_type%TYPE,
      intm_name        giis_intermediary.intm_name%TYPE
   );

   TYPE basic_intm_tab IS TABLE OF basic_intm_type;

   FUNCTION get_basic_intm_dtls (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN basic_intm_tab PIPELINED;

   /**
   * Rey Jadlocon
   * 09-01-2011
   * Casualty Item Info
   **/
   TYPE get_casualty_item_info_type IS RECORD (
      claim_no                 VARCHAR2 (50),
      policy_no                VARCHAR2 (50),
      line_cd                  gicl_claims.line_cd%TYPE,
      dsp_loss_date            gicl_claims.dsp_loss_date%TYPE,
      loss_date                gicl_claims.loss_date%TYPE,
      assured_name             gicl_claims.assured_name%TYPE,
      renew_no                 gicl_claims.renew_no%TYPE,
      loss_ctgry               VARCHAR2 (50),
      pol_seq_no               gicl_claims.pol_seq_no%TYPE,
      issue_yy                 gicl_claims.issue_yy%TYPE,
      pol_iss_cd               gicl_claims.pol_iss_cd%TYPE,
      subline_cd               gicl_claims.subline_cd%TYPE,
      expiry_date              gicl_claims.expiry_date%TYPE,
      pol_eff_date             gicl_claims.pol_eff_date%TYPE,
      claim_id                 gicl_claims.claim_id%TYPE,
      clm_stat_desc            giis_clm_stat.clm_stat_desc%TYPE,
      catastrophic_cd          gicl_claims.catastrophic_cd%TYPE,
      clm_file_date            gicl_claims.clm_file_date%TYPE,
      loss_cat_cd              gicl_claims.loss_cat_cd%TYPE,
      item_no                  gicl_item_peril.item_no%TYPE,
      peril_cd                 gicl_item_peril.peril_cd%TYPE,
      close_flag               gicl_item_peril.close_flag%TYPE,
      item_title               gicl_casualty_dtl.item_title%TYPE,
      grouped_item_no          gicl_casualty_dtl.grouped_item_no%TYPE,
      grouped_item_title       gicl_casualty_dtl.grouped_item_title%TYPE,
      currency_cd              gicl_casualty_dtl.currency_cd%TYPE,
      currency_desc            giis_currency.currency_desc%TYPE,
      currency_rate            gicl_casualty_dtl.currency_rate%TYPE,
      section_or_hazard_info   gicl_casualty_dtl.section_or_hazard_info%TYPE,
      section_or_hazard_cd     gicl_casualty_dtl.section_or_hazard_cd%TYPE,
      item_desc                gicl_clm_item.item_desc%TYPE,
      item_desc2               gicl_clm_item.item_desc2%TYPE,
      property_no              gicl_casualty_dtl.property_no%TYPE,
      property_no_type         gicl_casualty_dtl.property_no_type%TYPE,
      LOCATION                 gicl_casualty_dtl.LOCATION%TYPE,
      conveyance_info          gicl_casualty_dtl.conveyance_info%TYPE,
      interest_on_premises     gicl_casualty_dtl.interest_on_premises%TYPE,
      amount_coverage          gicl_casualty_dtl.amount_coverage%TYPE,
      limit_of_liability       gicl_casualty_dtl.limit_of_liability%TYPE,
      capacity_cd              gicl_casualty_dtl.capacity_cd%TYPE,
      itm                      VARCHAR2 (10),
      gicl_item_peril_exist    VARCHAR2 (1),
      gicl_mortgagee_exist     VARCHAR2 (1),
      gicl_item_peril_msg      VARCHAR2 (1)
   );

   TYPE get_casualty_item_info_tab IS TABLE OF get_casualty_item_info_type;

   FUNCTION get_casualty_item_info (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN get_casualty_item_info_tab PIPELINED;

   PROCEDURE clm_item_post_form_commit (p_claim_id gicl_claims.claim_id%TYPE);

      /**
   * Irwin Tabisora
   * 09-19-2011
   * Checks the plate no if it is existing in the other claims
   **/
   PROCEDURE check_plate_no (
      p_plate_no        IN OUT   gicl_claims.plate_no%TYPE,
      p_dsp_loss_date   IN OUT   VARCHAR2,
      claim_no          OUT      VARCHAR2,
      RESULT            OUT      VARCHAR2
   );

      /**
   * Irwin Tabisora
   * 09-19-2011
   * Checks the motor no if it is existing in the other claims
   **/
   PROCEDURE check_motor_no (
      p_motor_no        IN OUT   gicl_claims.motor_no%TYPE,
      p_dsp_loss_date   IN OUT   VARCHAR2,
      claim_no          OUT      VARCHAR2,
      RESULT            OUT      VARCHAR2
   );

      /**
   * Irwin Tabisora
   * 09-19-2011
   * Checks the Serial no if it is existing in the other claims
   **/
   PROCEDURE check_serial_no (
      p_serial_no       IN OUT   gicl_claims.motor_no%TYPE,
      p_dsp_loss_date   IN OUT   VARCHAR2,
      claim_no          OUT      VARCHAR2,
      RESULT            OUT      VARCHAR2
   );

   FUNCTION get_claim_info_gicls041 (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN gicl_claims_tab PIPELINED;

   PROCEDURE check_claim_status (
      p_line_cd            gicl_claims.line_cd%TYPE,
      p_subline_cd         gicl_claims.subline_cd%TYPE,
      p_iss_cd             gicl_claims.iss_cd%TYPE,
      p_clm_yy             gicl_claims.clm_yy%TYPE,
      p_clm_seq_no         gicl_claims.clm_seq_no%TYPE,
      p_msg_alert    OUT   VARCHAR2
   );

   PROCEDURE get_assured_obligee (
      p_assd_no       IN OUT   gipi_wpolbas.assd_no%TYPE,
      p_assd_name     IN OUT   giis_assured.assd_name%TYPE,
      p_acct_of_cd    IN OUT   gicl_claims.acct_of_cd%TYPE,
      p_obligee_no    IN OUT   gicl_claims.obligee_no%TYPE,
      p_line_cd                gipi_polbasic.line_cd%TYPE,
      p_subline_cd             gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd             gipi_polbasic.iss_cd%TYPE,
      p_issue_yy               gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no             gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no               gipi_polbasic.renew_no%TYPE,
      p_loss_date              gipi_polbasic.eff_date%TYPE,
      p_expiry_date            gipi_polbasic.expiry_date%TYPE
   );

   PROCEDURE validate_policy_no (
      p_line_cd          IN OUT   gipi_polbasic.line_cd%TYPE,
      p_subline_cd       IN OUT   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd       IN OUT   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy         IN OUT   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       IN OUT   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no         IN OUT   gipi_polbasic.renew_no%TYPE,
      p_loss_date        IN OUT   gipi_polbasic.eff_date%TYPE,
      p_pol_eff_date     OUT      VARCHAR2,   --GIPI_POLBASIC.issue_date%TYPE,
      p_expiry_date      OUT      VARCHAR2,  --GIPI_POLBASIC.expiry_date%TYPE,
      p_issue_date       OUT      VARCHAR2,   --GIPI_POLBASIC.issue_date%TYPE,
      p_assd_no          OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name        OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd       OUT      gicl_claims.acct_of_cd%TYPE,
      p_acct_of_name     OUT      giis_assured.assd_name%TYPE, --added by christian
      p_obligee_no       OUT      gicl_claims.obligee_no%TYPE,
      p_nbt_pk_pol       OUT      VARCHAR2,
      p_nbt_pack_pol     OUT      gipi_polbasic.pack_pol_flag%TYPE,
      p_pack_policy_id   OUT      gipi_polbasic.pack_policy_id%TYPE,
      p_msg_alert        OUT      VARCHAR2,
      p_msg_alert2       OUT      VARCHAR2,
      p_msg_alert3       OUT      VARCHAR2,
      p_exp_date_sw      OUT      VARCHAR2,
      p_item_no          OUT      gipi_vehicle.item_no%TYPE,
      p_plate_no         OUT      gipi_vehicle.plate_no%TYPE,
      p_motor_no         OUT      gipi_vehicle.motor_no%TYPE,
      p_serial_no        OUT      gipi_vehicle.serial_no%TYPE,
      p_plate_sw         OUT      VARCHAR2,
      p_package_sw       OUT      VARCHAR2,
      p_menu_line_cd     OUT      giis_line.menu_line_cd%TYPE --added by jeffdojello 10.01.2013
   );

   TYPE basic_claim_dtls_type IS RECORD (
      claim_no        VARCHAR2 (100),
      claim_id        gicl_claims.claim_id%TYPE,
      clm_stat_cd     gicl_claims.clm_stat_cd%TYPE,
      clm_file_date   gicl_claims.clm_file_date%TYPE,
      loss_res_amt    gicl_claims.loss_res_amt%TYPE,
      loss_pd_amt     gicl_claims.loss_pd_amt%TYPE,
      clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE
   );

   TYPE basic_claim_dtls_tab IS TABLE OF basic_claim_dtls_type;

   FUNCTION get_basic_claim_dtls (
      p_pack_policy_id   gipi_polbasic.pack_policy_id%TYPE,
      p_policy_id        gipi_polbasic.policy_id%TYPE
   )
      RETURN basic_claim_dtls_tab PIPELINED;

   PROCEDURE check_existing_claim (
      p_line_cd      IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd   IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN       gipi_polbasic.renew_no%TYPE,
      p_plate_no     IN       gicl_claims.plate_no%TYPE,
      p_msg_alert    OUT      VARCHAR2,
      p_status_cd    OUT      VARCHAR2,
      p_total_tag    OUT      VARCHAR2
   );

   PROCEDURE validate_plate_no (
      p_line_cd        IN OUT   gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN OUT   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     IN OUT   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN OUT   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN OUT   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN OUT   gipi_polbasic.renew_no%TYPE,
      p_loss_date      IN OUT   gipi_polbasic.eff_date%TYPE,
      p_pol_eff_date   OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_expiry_date    OUT      VARCHAR2,    --GIPI_POLBASIC.expiry_date%TYPE,
      p_issue_date     OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_assd_no        OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name      OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd     OUT      gicl_claims.acct_of_cd%TYPE,
      p_obligee_no     OUT      gicl_claims.obligee_no%TYPE,
      p_item_no        IN OUT   gipi_vehicle.item_no%TYPE,
      p_plate_no       IN OUT   gipi_vehicle.plate_no%TYPE,
      p_motor_no       IN OUT   gipi_vehicle.motor_no%TYPE,
      p_serial_no      IN OUT   gipi_vehicle.serial_no%TYPE,
      p_msg_alert      OUT      VARCHAR2,
      p_msg_alert2     OUT      VARCHAR2,
      p_msg_alert3     OUT      VARCHAR2,
      p_exp_date_sw    OUT      VARCHAR2,
      p_plate_sw2      OUT      VARCHAR2,
      p_validate_pol   IN       VARCHAR2
   );

   PROCEDURE validate_motor_no (
      p_line_cd        IN OUT   gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN OUT   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     IN OUT   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN OUT   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN OUT   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN OUT   gipi_polbasic.renew_no%TYPE,
      p_loss_date      IN OUT   gipi_polbasic.eff_date%TYPE,
      p_pol_eff_date   OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_expiry_date    OUT      VARCHAR2,    --GIPI_POLBASIC.expiry_date%TYPE,
      p_issue_date     OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_assd_no        OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name      OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd     OUT      gicl_claims.acct_of_cd%TYPE,
      p_obligee_no     OUT      gicl_claims.obligee_no%TYPE,
      p_item_no        IN OUT   gipi_vehicle.item_no%TYPE,
      p_plate_no       IN OUT   gipi_vehicle.plate_no%TYPE,
      p_motor_no       IN OUT   gipi_vehicle.motor_no%TYPE,
      p_serial_no      IN OUT   gipi_vehicle.serial_no%TYPE,
      p_msg_alert      OUT      VARCHAR2,
      p_msg_alert2     OUT      VARCHAR2,
      p_msg_alert3     OUT      VARCHAR2,
      p_exp_date_sw    OUT      VARCHAR2,
      p_plate_sw2      OUT      VARCHAR2,
      p_validate_pol   IN       VARCHAR2
   );

   PROCEDURE validate_serial_no (
      p_line_cd        IN OUT   gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN OUT   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     IN OUT   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN OUT   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN OUT   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN OUT   gipi_polbasic.renew_no%TYPE,
      p_loss_date      IN OUT   gipi_polbasic.eff_date%TYPE,
      p_pol_eff_date   OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_expiry_date    OUT      VARCHAR2,    --GIPI_POLBASIC.expiry_date%TYPE,
      p_issue_date     OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_assd_no        OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name      OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd     OUT      gicl_claims.acct_of_cd%TYPE,
      p_obligee_no     OUT      gicl_claims.obligee_no%TYPE,
      p_item_no        IN OUT   gipi_vehicle.item_no%TYPE,
      p_plate_no       IN OUT   gipi_vehicle.plate_no%TYPE,
      p_motor_no       IN OUT   gipi_vehicle.motor_no%TYPE,
      p_serial_no      IN OUT   gipi_vehicle.serial_no%TYPE,
      p_msg_alert      OUT      VARCHAR2,
      p_msg_alert2     OUT      VARCHAR2,
      p_msg_alert3     OUT      VARCHAR2,
      p_exp_date_sw    OUT      VARCHAR2,
      p_plate_sw2      OUT      VARCHAR2,
      p_validate_pol   IN       VARCHAR2
   );

   TYPE policy_lov_type IS RECORD (
      policy_no     VARCHAR2 (3200),
      assd_name     giis_assured.assd_name%TYPE,
      line_cd       gipi_polbasic.line_cd%TYPE,
      subline_cd    gipi_polbasic.subline_cd%TYPE,
      iss_cd        gipi_polbasic.iss_cd%TYPE,
      issue_yy      gipi_polbasic.issue_yy%TYPE,
      pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      renew_no      gipi_polbasic.renew_no%TYPE,
      incept_date   gipi_polbasic.incept_date%TYPE,
      expiry_date   gipi_polbasic.expiry_date%TYPE,
      motor_no      gipi_vehicle.motor_no%TYPE,
      serial_no     gipi_vehicle.serial_no%TYPE,
      plate_no      gipi_vehicle.plate_no%TYPE
   );

   TYPE policy_lov_tab IS TABLE OF policy_lov_type;

   FUNCTION get_policy_list (p_param VARCHAR2, p_param2 VARCHAR2)
      RETURN policy_lov_tab PIPELINED;

   PROCEDURE check_loss_date_time (
      p_line_cd             IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd          IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd          IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy            IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no          IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no            IN       gipi_polbasic.renew_no%TYPE,
      p_dsp_loss_date       IN       gicl_claims.dsp_loss_date%TYPE,
      p_subline_time        OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2,
      p_alert_accept_date   OUT      VARCHAR2,
      p_alert_override      OUT      VARCHAR2,
      p_allowed             OUT      VARCHAR2
   );

   PROCEDURE check_last_endt_plate_no (
      p_line_cd      IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd   IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN       gipi_polbasic.renew_no%TYPE,
      p_plate_no     IN OUT   gicl_claims.plate_no%TYPE,
      p_item_no      IN       gipi_vehicle.item_no%TYPE,
      p_loss_date    IN       gicl_claims.dsp_loss_date%TYPE, --benjo 10.20.2016 SR-23261
      p_pol_eff_date IN       gicl_claims.pol_eff_date%TYPE, --benjo 10.20.2016 SR-23261
      p_expiry_date  IN       gicl_claims.expiry_date%TYPE, --benjo 10.20.2016 SR-23261
      p_msg_alert    OUT      VARCHAR2,
      p_count        OUT      NUMBER
   );

   PROCEDURE check_loss_date_with_plate_no (
      p_line_cd           IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd        IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd        IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          IN       gipi_polbasic.renew_no%TYPE,
      p_plate_no          IN OUT   gicl_claims.plate_no%TYPE,
      p_item_no           IN OUT   gipi_vehicle.item_no%TYPE,
      p_dsp_loss_date     IN       gicl_claims.dsp_loss_date%TYPE,
      p_pol_eff_date      IN       gicl_claims.pol_eff_date%TYPE,
      p_expiry_date       IN       gicl_claims.expiry_date%TYPE,
      p_time              IN       VARCHAR2,
      p_check_loss_date   OUT      VARCHAR2,
      p_plate_sw          OUT      VARCHAR2,
      p_serial_no         OUT      gicl_claims.serial_no%TYPE,
      p_motor_no          OUT      gicl_claims.motor_no%TYPE
   );

   PROCEDURE validate_loss_date_plate_no (
      p_line_cd           IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd        IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd        IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          IN       gipi_polbasic.renew_no%TYPE,
      p_plate_no          IN OUT   gicl_claims.plate_no%TYPE,
      p_item_no           IN OUT   gipi_vehicle.item_no%TYPE,
      p_dsp_loss_date     IN       gicl_claims.dsp_loss_date%TYPE,
      p_pol_eff_date      IN       gicl_claims.pol_eff_date%TYPE,
      p_expiry_date       IN       gicl_claims.expiry_date%TYPE,
      p_time              IN       VARCHAR2,
      p_msg_alert         OUT      VARCHAR2,
      p_count             OUT      NUMBER,
      p_check_loss_date   OUT      VARCHAR2,
      p_plate_sw          OUT      VARCHAR2,
      p_serial_no         OUT      gicl_claims.serial_no%TYPE,
      p_motor_no          OUT      gicl_claims.motor_no%TYPE
   );

   PROCEDURE validate_loss_time (
      p_line_cd               IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd            IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd            IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy              IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no            IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no              IN       gipi_polbasic.renew_no%TYPE,
      p_loss_date             IN       gicl_claims.dsp_loss_date%TYPE,
      p_expiry_date           IN       gipi_polbasic.expiry_date%TYPE,
      p_user_level            IN       giis_users.user_level%TYPE,
      p_in_hou_adj            OUT      giis_users.user_id%TYPE,
      p_nbt_in_hou_adj_name   OUT      giis_users.user_name%TYPE,
      p_clm_file_date         OUT      VARCHAR2,
      p_ri_cd                 OUT      giri_inpolbas.ri_cd%TYPE,
      p_dsp_ri_name           OUT      giis_reinsurer.ri_name%TYPE,
      p_assd_no               OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name             OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd            OUT      gicl_claims.acct_of_cd%TYPE,
      p_obligee_no            OUT      gicl_claims.obligee_no%TYPE
   );

   PROCEDURE check_claim (
      p_line_cd         IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd      IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd      IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        IN       gipi_polbasic.renew_no%TYPE,
      p_plate_no        IN       gicl_claims.plate_no%TYPE,
      p_claim_id        IN       gicl_claims.claim_id%TYPE,
      p_dsp_loss_date   IN       gicl_claims.dsp_loss_date%TYPE,
      p_time            IN       VARCHAR2,
      p_expiry_date     IN       gipi_polbasic.expiry_date%TYPE,
      p_time_flag       OUT      VARCHAR2,
      p_override        OUT      VARCHAR2,
      p_msg_alert       OUT      VARCHAR2,
      p_user_flag       OUT      VARCHAR2,
      p_ri_cd           OUT      giri_inpolbas.ri_cd%TYPE,
      p_dsp_ri_name     OUT      giis_reinsurer.ri_name%TYPE,
      p_assd_no         OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name       OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd      OUT      gicl_claims.acct_of_cd%TYPE,
      p_obligee_no      OUT      gicl_claims.obligee_no%TYPE
   );

   PROCEDURE validate_catastrophic_code (
      p_line_cd             IN       gicl_claims.line_cd%TYPE,
      p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
      p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
      p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
      p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
      p_claim_id            IN       gicl_claims.claim_id%TYPE,
      p_catastrophic_cd     IN OUT   gicl_claims.catastrophic_cd%TYPE,
      p_catastrophic_desc   OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2
   );

   PROCEDURE validate_unpaid_prem (
      p_claim_id                gicl_claims.claim_id%TYPE,
      p_nbt_clm_stat_cd         VARCHAR2,
      p_msg_alert         OUT   VARCHAR2,
      p_workflow_msgr     OUT   VARCHAR2
   );

   PROCEDURE get_check_location_dtl (
      p_claim_id                        gicl_claims.claim_id%TYPE,
      p_gicl_fire_dtl_exist       OUT   VARCHAR2,
      p_gicl_casualty_dtl_exist   OUT   VARCHAR2,
      p_block_id                  OUT   gicl_fire_dtl.block_id%TYPE,
      p_district_no               OUT   gicl_fire_dtl.district_no%TYPE,
      p_block_no                  OUT   gicl_fire_dtl.block_no%TYPE,
      p_location                        gicl_casualty_dtl.location%TYPE,
      p_val_loc                   OUT   VARCHAR2
   );

   PROCEDURE get_clm_seq_no (
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_clm_yy             gicl_claims.clm_yy%TYPE,
      p_clm_seq_no   OUT   giis_clm_seq.clm_seq_no%TYPE
   );

   PROCEDURE set_gicl_claims (
      p_claim_id               gicl_claims.claim_id%TYPE,
      p_line_cd                gicl_claims.line_cd%TYPE,
      p_subline_cd             gicl_claims.subline_cd%TYPE,
      p_issue_yy               gicl_claims.issue_yy%TYPE,
      p_pol_seq_no             gicl_claims.pol_seq_no%TYPE,
      p_renew_no               gicl_claims.renew_no%TYPE,
      p_pol_iss_cd             gicl_claims.pol_iss_cd%TYPE,
      p_clm_yy                 gicl_claims.clm_yy%TYPE,
      p_clm_seq_no             gicl_claims.clm_seq_no%TYPE,
      p_iss_cd                 gicl_claims.iss_cd%TYPE,
      p_clm_control            gicl_claims.clm_control%TYPE,
      p_clm_coop               gicl_claims.clm_coop%TYPE,
      p_assd_no                gicl_claims.assd_no%TYPE,
      p_recovery_sw            gicl_claims.recovery_sw%TYPE,
      p_clm_file_date          gicl_claims.clm_file_date%TYPE,
      p_loss_date              gicl_claims.loss_date%TYPE,
      p_entry_date             gicl_claims.entry_date%TYPE,
      p_user_id                gicl_claims.user_id%TYPE,
      p_last_update            gicl_claims.last_update%TYPE,
      p_dsp_loss_date          gicl_claims.dsp_loss_date%TYPE,
      p_clm_stat_cd            gicl_claims.clm_stat_cd%TYPE,
      p_clm_setl_date          gicl_claims.clm_setl_date%TYPE,
      p_loss_pd_amt            gicl_claims.loss_pd_amt%TYPE,
      p_loss_res_amt           gicl_claims.loss_res_amt%TYPE,
      p_exp_pd_amt             gicl_claims.exp_pd_amt%TYPE,
      p_loss_loc1              gicl_claims.loss_loc1%TYPE,
      p_loss_loc2              gicl_claims.loss_loc2%TYPE,
      p_loss_loc3              gicl_claims.loss_loc3%TYPE,
      p_in_hou_adj             gicl_claims.in_hou_adj%TYPE,
      p_pol_eff_date           gicl_claims.pol_eff_date%TYPE,
      p_csr_no                 gicl_claims.csr_no%TYPE,
      p_loss_cat_cd            gicl_claims.loss_cat_cd%TYPE,
      p_intm_no                gicl_claims.intm_no%TYPE,
      p_clm_amt                gicl_claims.clm_amt%TYPE,
      p_loss_dtls              gicl_claims.loss_dtls%TYPE,
      p_obligee_no             gicl_claims.obligee_no%TYPE,
      p_exp_res_amt            gicl_claims.exp_res_amt%TYPE,
      p_assured_name           gicl_claims.assured_name%TYPE,
      p_ri_cd                  gicl_claims.ri_cd%TYPE,
      p_plate_no               gicl_claims.plate_no%TYPE,
      p_cpi_rec_no             gicl_claims.cpi_rec_no%TYPE,
      p_cpi_branch_cd          gicl_claims.cpi_branch_cd%TYPE,
      p_clm_dist_tag           gicl_claims.clm_dist_tag%TYPE,
      p_assd_name2             gicl_claims.assd_name2%TYPE,
      p_old_stat_cd            gicl_claims.old_stat_cd%TYPE,
      p_close_date             gicl_claims.close_date%TYPE,
      p_expiry_date            gicl_claims.expiry_date%TYPE,
      p_acct_of_cd             gicl_claims.acct_of_cd%TYPE,
      p_max_endt_seq_no        gicl_claims.max_endt_seq_no%TYPE,
      p_remarks                gicl_claims.remarks%TYPE,
      p_catastrophic_cd        gicl_claims.catastrophic_cd%TYPE,
      p_cred_branch            gicl_claims.cred_branch%TYPE,
      p_net_pd_loss            gicl_claims.net_pd_loss%TYPE,
      p_net_pd_exp             gicl_claims.net_pd_exp%TYPE,
      p_refresh_sw             gicl_claims.refresh_sw%TYPE,
      p_total_tag              gicl_claims.total_tag%TYPE,
      p_reason_cd              gicl_claims.reason_cd%TYPE,
      p_province_cd            gicl_claims.province_cd%TYPE,
      p_city_cd                gicl_claims.city_cd%TYPE,
      p_zip_cd                 gicl_claims.zip_cd%TYPE,
      p_pack_policy_id         gicl_claims.pack_policy_id%TYPE,
      p_motor_no               gicl_claims.motor_no%TYPE,
      p_serial_no              gicl_claims.serial_no%TYPE,
      p_settling_agent_cd      gicl_claims.settling_agent_cd%TYPE,
      p_survey_agent_cd        gicl_claims.survey_agent_cd%TYPE,
      p_tran_no                gicl_claims.tran_no%TYPE,
      p_contact_no             gicl_claims.contact_no%TYPE,
      p_email_address          gicl_claims.email_address%TYPE,
      p_special_instructions   gicl_claims.special_instructions%TYPE,
      p_def_processor          gicl_claims.def_processor%TYPE,
      p_location_cd            gicl_claims.location_cd%TYPE,
      p_block_id               gicl_claims.block_id%TYPE,
      p_district_no            gicl_claims.district_no%TYPE,
      p_reported_by            gicl_claims.reported_by%TYPE
   );

   PROCEDURE pre_ins_gicl_claims (
      p_claim_id               IN OUT   gicl_claims.claim_id%TYPE,
      p_line_cd                         gicl_claims.line_cd%TYPE,
      p_subline_cd                      gicl_claims.subline_cd%TYPE,
      p_issue_yy                        gicl_claims.issue_yy%TYPE,
      p_pol_seq_no                      gicl_claims.pol_seq_no%TYPE,
      p_renew_no                        gicl_claims.renew_no%TYPE,
      p_pol_iss_cd                      gicl_claims.pol_iss_cd%TYPE,
      p_clm_yy                 IN OUT   gicl_claims.clm_yy%TYPE,
      p_clm_seq_no             IN OUT   gicl_claims.clm_seq_no%TYPE,
      p_iss_cd                 IN OUT   gicl_claims.iss_cd%TYPE,
      p_clm_control                     gicl_claims.clm_control%TYPE,
      p_clm_coop                        gicl_claims.clm_coop%TYPE,
      p_assd_no                         gicl_claims.assd_no%TYPE,
      p_recovery_sw                     gicl_claims.recovery_sw%TYPE,
      p_clm_file_date                   gicl_claims.clm_file_date%TYPE,
      p_loss_date                       gicl_claims.loss_date%TYPE,
      p_entry_date             IN OUT   gicl_claims.entry_date%TYPE,
      p_user_id                         gicl_claims.user_id%TYPE,
      p_last_update                     gicl_claims.last_update%TYPE,
      p_dsp_loss_date                   gicl_claims.dsp_loss_date%TYPE,
      p_clm_stat_cd            IN OUT   gicl_claims.clm_stat_cd%TYPE,
      p_clm_setl_date                   gicl_claims.clm_setl_date%TYPE,
      p_loss_pd_amt                     gicl_claims.loss_pd_amt%TYPE,
      p_loss_res_amt                    gicl_claims.loss_res_amt%TYPE,
      p_exp_pd_amt                      gicl_claims.exp_pd_amt%TYPE,
      p_loss_loc1                       gicl_claims.loss_loc1%TYPE,
      p_loss_loc2                       gicl_claims.loss_loc2%TYPE,
      p_loss_loc3                       gicl_claims.loss_loc3%TYPE,
      p_in_hou_adj             IN OUT   gicl_claims.in_hou_adj%TYPE,
      p_pol_eff_date                    gicl_claims.pol_eff_date%TYPE,
      p_csr_no                          gicl_claims.csr_no%TYPE,
      p_loss_cat_cd                     gicl_claims.loss_cat_cd%TYPE,
      p_intm_no                         gicl_claims.intm_no%TYPE,
      p_clm_amt                         gicl_claims.clm_amt%TYPE,
      p_loss_dtls                       gicl_claims.loss_dtls%TYPE,
      p_obligee_no                      gicl_claims.obligee_no%TYPE,
      p_exp_res_amt                     gicl_claims.exp_res_amt%TYPE,
      p_assured_name                    gicl_claims.assured_name%TYPE,
      p_ri_cd                           gicl_claims.ri_cd%TYPE,
      p_plate_no                        gicl_claims.plate_no%TYPE,
      p_cpi_rec_no                      gicl_claims.cpi_rec_no%TYPE,
      p_cpi_branch_cd                   gicl_claims.cpi_branch_cd%TYPE,
      p_clm_dist_tag                    gicl_claims.clm_dist_tag%TYPE,
      p_assd_name2                      gicl_claims.assd_name2%TYPE,
      p_old_stat_cd                     gicl_claims.old_stat_cd%TYPE,
      p_close_date                      gicl_claims.close_date%TYPE,
      p_expiry_date                     gicl_claims.expiry_date%TYPE,
      p_acct_of_cd                      gicl_claims.acct_of_cd%TYPE,
      p_max_endt_seq_no                 gicl_claims.max_endt_seq_no%TYPE,
      p_remarks                         gicl_claims.remarks%TYPE,
      p_catastrophic_cd                 gicl_claims.catastrophic_cd%TYPE,
      p_cred_branch            IN OUT   gicl_claims.cred_branch%TYPE,
      p_net_pd_loss                     gicl_claims.net_pd_loss%TYPE,
      p_net_pd_exp                      gicl_claims.net_pd_exp%TYPE,
      p_refresh_sw                      gicl_claims.refresh_sw%TYPE,
      p_total_tag                       gicl_claims.total_tag%TYPE,
      p_reason_cd                       gicl_claims.reason_cd%TYPE,
      p_province_cd                     gicl_claims.province_cd%TYPE,
      p_city_cd                         gicl_claims.city_cd%TYPE,
      p_zip_cd                          gicl_claims.zip_cd%TYPE,
      p_pack_policy_id                  gicl_claims.pack_policy_id%TYPE,
      p_motor_no                        gicl_claims.motor_no%TYPE,
      p_serial_no                       gicl_claims.serial_no%TYPE,
      p_settling_agent_cd      IN OUT   gicl_claims.settling_agent_cd%TYPE,
      p_survey_agent_cd        IN OUT   gicl_claims.survey_agent_cd%TYPE,
      p_tran_no                         gicl_claims.tran_no%TYPE,
      p_contact_no                      gicl_claims.contact_no%TYPE,
      p_email_address                   gicl_claims.email_address%TYPE,
      p_special_instructions            gicl_claims.special_instructions%TYPE,
      p_def_processor                   gicl_claims.def_processor%TYPE,
      p_location_cd                     gicl_claims.location_cd%TYPE,
      p_block_id                        gicl_claims.block_id%TYPE,
      p_district_no                     gicl_claims.district_no%TYPE,
      p_reported_by                     gicl_claims.reported_by%TYPE,
      p_nbt_clm_stat_cd                 VARCHAR2
   );

   PROCEDURE ins_clm_item_and_peril (
      p_line_cd        IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN   gipi_polbasic.renew_no%TYPE,
      p_loss_date      IN   gicl_claims.dsp_loss_date%TYPE,
      p_expiry_date    IN   gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   IN   gicl_claims.pol_eff_date%TYPE,
      p_loss_cat_cd    IN   gicl_claims.loss_cat_cd%TYPE,
      p_claim_id       IN   gicl_claims.claim_id%TYPE
   );

   PROCEDURE post_ins_gicls010 (
      p_line_cd         IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd      IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd      IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        IN       gipi_polbasic.renew_no%TYPE,
      p_claim_id        IN       gicl_claims.claim_id%TYPE,
      p_msg_alert       OUT      VARCHAR2,
      p_workflow_msgr   OUT      VARCHAR2
   );

   PROCEDURE refresh_claims (
      p_claim_id        gicl_claims.claim_id%TYPE,
      p_line_cd         gicl_claims.line_cd%TYPE,
      p_subline_cd      gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd      gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy        gicl_claims.issue_yy%TYPE,
      p_pol_seq_no      gicl_claims.pol_seq_no%TYPE,
      p_renew_no        gicl_claims.renew_no%TYPE,
      p_expiry_date     gicl_claims.expiry_date%TYPE,
      p_pol_eff_date    gicl_claims.pol_eff_date%TYPE,
      p_dsp_loss_date   gicl_claims.dsp_loss_date%TYPE
   );

   TYPE loss_cat_tag_type IS RECORD (
      claim_id              gicl_claims.claim_id%TYPE,
      claim_no              VARCHAR2 (1000),
      policy_no             VARCHAR2 (1000),
      claim_stat_desc       giis_clm_stat.clm_stat_desc%TYPE,
      in_house_adjustment   gicl_claims.in_hou_adj%TYPE,
      assured_name          gicl_claims.assured_name%TYPE,
      line_cd               gicl_claims.line_cd%TYPE,
      subline_cd            gicl_claims.subline_cd%TYPE,
       iss_cd            gicl_claims.iss_cd%TYPE,
      clm_seq_no            gicl_claims.clm_seq_no%TYPE,
      clm_yy            gicl_claims.clm_yy%TYPE,
      pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
      pol_seq_no            gicl_claims.pol_seq_no%TYPE,
      renew_no              gicl_claims.renew_no%TYPE,
      recovery_id           gicl_clm_recovery.recovery_id%TYPE,
      rec_year              gicl_clm_recovery.rec_year%TYPE,
      rec_seq_no            gicl_clm_recovery.rec_seq_no%TYPE,
      subline_cd2           gicl_claims.subline_cd%TYPE,
      issue_yy              gicl_claims.issue_yy%TYPE,
      clm_stat_cd           gicl_claims.clm_stat_cd%TYPE,
      loss_cat_cd           gicl_claims.loss_cat_cd%TYPE,
      loss_date             gicl_claims.loss_date%TYPE,    -- VARCHAR2 (100),
      recovery_no           VARCHAR2 (1000),
      loss_cat_des          VARCHAR2 (1000),
      dsp_loss_date         VARCHAR2 (100),
      peril_cd              giis_loss_ctgry.peril_cd%TYPE,
      recovery_sw           VARCHAR2 (1),
      recovery_exist        VARCHAR2 (1),
      dist_sw               VARCHAR2 (1),
      entry_tag             VARCHAR2 (1),
      stat_sw               VARCHAR2 (1)
   );

    type loss_cat_tag_tab is table of loss_cat_tag_type;
   FUNCTION get_loss_cat_tag_listing (
      p_claim_no          VARCHAR2,
      p_policy_no         VARCHAR2,
      p_loss_cat          VARCHAR2,
      p_claim_stat_desc   VARCHAR2,
      p_claim_processor   gicl_claims.in_hou_adj%TYPE,
      p_line_cd           gicl_claims.line_cd%TYPE,
      p_dsp_loss_date     VARCHAR2,
      p_assured_name      gicl_claims.assured_name%TYPE,
      p_clm_seq_no        gicl_claims.clm_seq_no%TYPE,
      p_renew_no        gicl_claims.renew_no%TYPE,
      p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      p_pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
      p_clm_yy        gicl_claims.clm_yy%TYPE,
      p_iss_cd        gicl_claims.iss_cd%TYPE,
      p_subline_cd        gicl_claims.subline_cd%TYPE,
      p_user_id           gicl_claims.user_id%TYPE

   )

      RETURN loss_cat_tag_tab PIPELINED;

   FUNCTION get_claims_per_policy (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   gicl_claims.pol_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE,
      p_module       VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gicl_claims_tab PIPELINED;

   FUNCTION get_claims_per_policy2 (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   gicl_claims.pol_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE,
      p_module       VARCHAR2,
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN gicl_claims_tab PIPELINED;

   procedure update_loss_tag_recovery(
    p_claim_id gicl_claims.claim_id%TYPE,
    p_recovery_Sw gicl_claims.recovery_sw%TYPE
   ) ;

    TYPE lov_listing_type IS RECORD(
        code        VARCHAR2(32000),
        code_desc   VARCHAR2(32000)
        );

    TYPE lov_listing_tab IS TABLE OF lov_listing_type;

    FUNCTION get_clm_line_list(
        p_module_id   GIIS_MODULES.module_id%TYPE
        )
    RETURN lov_listing_tab PIPELINED;

    FUNCTION get_clm_line_list2(
        p_module_id   GIIS_MODULES.module_id%TYPE,
        p_user_id giis_users.user_id%TYPE
        )
    RETURN lov_listing_tab PIPELINED;

    FUNCTION get_clm_subline_list(
        p_line_cd   gicl_claims.line_cd%TYPE
        )
    RETURN lov_listing_tab PIPELINED;

    FUNCTION get_clm_iss_list(
        p_line_cd       gicl_claims.line_cd%TYPE,
        p_subline_cd    gicl_claims.subline_cd%TYPE
        )
    RETURN lov_listing_tab PIPELINED;

    FUNCTION get_clm_iss_list2(
        p_line_cd       gicl_claims.line_cd%TYPE,
        p_subline_cd    gicl_claims.subline_cd%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
        )
    RETURN lov_listing_tab PIPELINED;

    FUNCTION get_clm_issue_yy_list(
        p_line_cd       gicl_claims.line_cd%TYPE,
        p_subline_cd    gicl_claims.subline_cd%TYPE
        )
    RETURN lov_listing_tab PIPELINED;

    PROCEDURE check_claims_gicls026 (
        p_line_cd       IN gicl_claims.line_cd%TYPE,
        p_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_iss_cd        IN gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy      IN gicl_claims.issue_yy%TYPE,
        p_pol_seq_no    IN gicl_claims.pol_seq_no%TYPE,
        p_renew_no      IN gicl_claims.renew_no%TYPE,
        p_msg          OUT VARCHAR2
    );

    PROCEDURE check_item_gicls026(
        p_line_cd        IN  gicl_claims.line_cd%TYPE,
        p_subline_cd     IN  gicl_claims.subline_cd%TYPE,
        p_iss_cd         IN  gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy       IN  gicl_claims.issue_yy%TYPE,
        p_pol_seq_no     IN  gicl_claims.pol_seq_no%TYPE,
        p_renew_no       IN  gicl_claims.renew_no%TYPE,
        p_item_no        IN  gicl_clm_item.item_no%TYPE,
        p_nc_loss_date   IN  gicl_clm_item.loss_date%TYPE,
        p_msg           OUT  VARCHAR2
    );

    PROCEDURE get_recovery_amount(
        p_claim_id                  IN    gicl_claims.claim_id%TYPE,
        p_recoverable_amt        IN OUT gicl_clm_recovery.recoverable_amt%TYPE,
        p_recovered_amt          IN OUT gicl_clm_recovery.recovered_amt%TYPE
        );

    /**
        Added by Irwin Tabisora
        Date: 07.2.2012
        Claim basic info required documents validation.
    **/
    PROCEDURE CHECK_CLAIM_REQ_DOCS(
        P_CLAIM_ID in gicl_claims.claim_id%TYPE,
        p_has_docs out varchar2,
        p_has_completed_dates out varchar2
    );

    FUNCTION get_related_claims2 (p_claim_id gicl_claims.claim_id%TYPE)
       RETURN gicl_claims_tab PIPELINED;

       /**
        Added by Christian Santos
        Date: 10.05.2012
        Batch Claim Closing
    **/
   TYPE gicl_claim_closing_type IS RECORD (
      claim_id                 gicl_claims.claim_id%TYPE,
      line_cd                  gicl_claims.line_cd%TYPE,
      line_name                   giis_line.line_name%TYPE,
      subline_cd               gicl_claims.subline_cd%TYPE,
      issue_yy                 gicl_claims.issue_yy%TYPE,
      pol_seq_no               gicl_claims.pol_seq_no%TYPE,
      renew_no                 gicl_claims.renew_no%TYPE,
      pol_iss_cd               gicl_claims.pol_iss_cd%TYPE,
      clm_yy                   gicl_claims.clm_yy%TYPE,
      clm_seq_no               gicl_claims.clm_seq_no%TYPE,
      iss_cd                   gicl_claims.iss_cd%TYPE,
      clm_control              gicl_claims.clm_control%TYPE,
      clm_coop                 gicl_claims.clm_coop%TYPE,
      assd_no                  gicl_claims.assd_no%TYPE,
      recovery_sw              gicl_claims.recovery_sw%TYPE,
      clm_file_date            gicl_claims.clm_file_date%TYPE,
      loss_date                gicl_claims.loss_date%TYPE,
      entry_date               gicl_claims.entry_date%TYPE,
      dsp_loss_date            gicl_claims.dsp_loss_date%TYPE,
      clm_stat_cd              gicl_claims.clm_stat_cd%TYPE,
      clm_setl_date            gicl_claims.clm_setl_date%TYPE,
      loss_pd_amt              gicl_claims.loss_pd_amt%TYPE,
      loss_res_amt             gicl_claims.loss_res_amt%TYPE,
      exp_pd_amt               gicl_claims.exp_pd_amt%TYPE,
      loss_loc1                gicl_claims.loss_loc1%TYPE,
      loss_loc2                gicl_claims.loss_loc2%TYPE,
      loss_loc3                gicl_claims.loss_loc3%TYPE,
      in_hou_adj               gicl_claims.in_hou_adj%TYPE,
      pol_eff_date             gicl_claims.pol_eff_date%TYPE,
      csr_no                   gicl_claims.csr_no%TYPE,
      loss_cat_cd              gicl_claims.loss_cat_cd%TYPE,
      intm_no                  gicl_claims.intm_no%TYPE,
      clm_amt                  gicl_claims.clm_amt%TYPE,
      loss_dtls                gicl_claims.loss_dtls%TYPE,
      obligee_no               gicl_claims.obligee_no%TYPE,
      exp_res_amt              gicl_claims.exp_res_amt%TYPE,
      assured_name             gicl_claims.assured_name%TYPE,
      ri_cd                    gicl_claims.ri_cd%TYPE,
      plate_no                 gicl_claims.plate_no%TYPE,
      clm_dist_tag             gicl_claims.clm_dist_tag%TYPE,
      assd_name2               gicl_claims.assd_name2%TYPE,
      old_stat_cd              gicl_claims.old_stat_cd%TYPE,
      close_date               gicl_claims.close_date%TYPE,
      expiry_date              gicl_claims.expiry_date%TYPE,
      acct_of_cd               gicl_claims.acct_of_cd%TYPE,
      max_endt_seq_no          gicl_claims.max_endt_seq_no%TYPE,
      remarks                  gicl_claims.remarks%TYPE,
      catastrophic_cd          gicl_claims.catastrophic_cd%TYPE,
      cred_branch              gicl_claims.cred_branch%TYPE,
      net_pd_loss              gicl_claims.net_pd_loss%TYPE,
      net_pd_exp               gicl_claims.net_pd_exp%TYPE,
      refresh_sw               gicl_claims.refresh_sw%TYPE,
      total_tag                gicl_claims.total_tag%TYPE,
      reason_cd                gicl_claims.reason_cd%TYPE,
      province_cd              gicl_claims.province_cd%TYPE,
      city_cd                  gicl_claims.city_cd%TYPE,
      zip_cd                   gicl_claims.zip_cd%TYPE,
      pack_policy_id           gicl_claims.pack_policy_id%TYPE,
      motor_no                 gicl_claims.motor_no%TYPE,
      serial_no                gicl_claims.serial_no%TYPE,
      settling_agent_cd        gicl_claims.settling_agent_cd%TYPE,
      survey_agent_cd          gicl_claims.survey_agent_cd%TYPE,
      tran_no                  gicl_claims.tran_no%TYPE,
      contact_no               gicl_claims.contact_no%TYPE,
      email_address            gicl_claims.email_address%TYPE,
      special_instructions     gicl_claims.special_instructions%TYPE,
      def_processor            gicl_claims.def_processor%TYPE,
      location_cd              gicl_claims.location_cd%TYPE,
      block_id                 gicl_claims.block_id%TYPE,
      district_no              gicl_claims.district_no%TYPE,
      reported_by              gicl_claims.reported_by%TYPE,
      cpi_rec_no               gicl_claims.cpi_rec_no%TYPE,
      cpi_branch_cd            gicl_claims.cpi_branch_cd%TYPE,
      user_id                  gicl_claims.user_id%TYPE,
      last_update              gicl_claims.last_update%TYPE,
      clm_stat_desc            giis_clm_stat.clm_stat_desc%TYPE,
      dsp_ri_name              giis_reinsurer.ri_name%TYPE,
      dsp_province_desc        giis_province.province_desc%TYPE,
      dsp_city_desc            giis_city.city%TYPE,
      dsp_cat_desc             gicl_cat_dtl.catastrophic_desc%TYPE,
      dsp_loss_cat_desc        giis_loss_ctgry.loss_cat_des%TYPE,
      dsp_in_hou_adj_name      giis_users.user_name%TYPE,
      pack_pol_flag            giis_line.pack_pol_flag%TYPE,
      dsp_cred_br_desc         giis_issource.iss_name%TYPE,
      block_no                 giis_block.block_no%TYPE,
      location_desc            giis_ca_location.location_desc%TYPE,
      pack_pol_no              VARCHAR2 (30),
      issue_date               gipi_polbasic.issue_date%TYPE,
      redist_sw                gicl_clm_reserve.redist_sw%TYPE,
      claim_no                 VARCHAR2 (100),
      policy_no                VARCHAR2 (100),
      loss_ctgry               VARCHAR2 (200),
      op_number                VARCHAR2 (3200),
      item_no                  gipi_vehicle.item_no%TYPE,
      gicl_mortgagee_exist     VARCHAR2 (1),
      gicl_item_peril_exist    VARCHAR2 (1),
      gicl_clm_item_exist      VARCHAR2 (1),
      gicl_clm_reserve_exist   VARCHAR2 (1),
      dsp_settling_name        VARCHAR2 (32000),
      dsp_survey_name          VARCHAR2 (32000),
      dsp_policy_no            VARCHAR2 (32000),
      dsp_claim_no             VARCHAR2 (32000),
      peril_cd                 giis_loss_ctgry.peril_cd%TYPE,
      item_limit               NUMBER,
      dsp_acct_of              VARCHAR2 (32000),
      policy_id                   gipi_polbasic.policy_id%TYPE,

      pol_flag                 gipi_polbasic.pol_flag%TYPE,
      clm_setld                VARCHAR2 (1),
      advice_exist             VARCHAR2 (1),
      chk_payment              VARCHAR2 (1),
      payt_sw                  VARCHAR2 (1),
      with_recovery            VARCHAR2 (1)
   );

   TYPE gicl_claim_closing_tab IS TABLE OF gicl_claim_closing_type;

   FUNCTION get_claim_closing_listing(
       p_clm_line_cd       gicl_claims.line_cd%TYPE,
       p_clm_subline_cd    gicl_claims.subline_cd%TYPE,
       p_clm_iss_cd        gicl_claims.iss_cd%TYPE,
       p_clm_yy            gicl_claims.clm_yy%TYPE,
       p_clm_seq_no        gicl_claims.clm_seq_no%TYPE,
       p_pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
       p_pol_issue_yy      gicl_claims.issue_yy%TYPE,
       p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
       p_pol_renew_no      gicl_claims.renew_no%TYPE,
       p_assd_no           gicl_claims.assd_no%TYPE,
       p_search_by         NUMBER,
       p_as_of_date        VARCHAR2,
       p_from_date         VARCHAR2,
       p_to_date           VARCHAR2,    
       p_status_control    VARCHAR2
       )
   RETURN gicl_claim_closing_tab PIPELINED;

   PROCEDURE CHECK_USER_FUNCTION(
    p_user_id          IN       GIIS_USERS.user_id%TYPE,
    p_module_id        OUT      GIAC_MODULES.module_id%TYPE,
    p_function_cd      IN       GIAC_FUNCTIONS.function_code%TYPE,
    p_function_name    OUT      VARCHAR2,
    p_function_exist   OUT      VARCHAR2,
    p_user_valid       OUT      giac_user_functions.valid_tag%TYPE
    );

   PROCEDURE UPDATE_BATCH_CLAIM_CLOSING(
    p_claim_id         IN       GICL_CLAIMS.claim_id%TYPE,
    p_user_id          IN       GICL_CLAIMS.user_id%TYPE,
    p_last_update      IN       GICL_CLAIMS.last_update%TYPE,
    p_remarks          IN       GICL_CLAIMS.remarks%TYPE
    );

   PROCEDURE CHK_CANCELLED_XOL_RES (
    p_curr_net         IN OUT   VARCHAR2,
    p_curr_xol         IN OUT   VARCHAR2,
    p_item_no                   gicl_reserve_ds.item_no%TYPE,
    p_grouped_item_no           gicl_reserve_ds.grouped_item_no%TYPE,
    p_peril_cd                  gicl_reserve_ds.peril_cd%TYPE,
    p_claim_id                  gicl_claims.claim_id%TYPE
    );

   PROCEDURE CHK_CANCELLED_XOL_PAYT (
    p_curr_net        IN OUT    VARCHAR2,
    p_curr_xol        IN OUT    varchar2,
    p_item_no                   gicl_loss_exp_ds.item_no%TYPE,
    p_grouped_item_no           gicl_loss_Exp_ds.grouped_item_no%TYPE,
    p_peril_cd                  gicl_loss_exp_ds.peril_cd%TYPE,
    p_claim_id                  gicl_claims.claim_id%TYPE
    );

   PROCEDURE CHK_PAID_XOL_PAYT (
    p_curr_net        IN OUT    VARCHAR2,
    p_curr_xol        IN OUT    varchar2,
    p_item_no                   gicl_loss_exp_ds.item_no%TYPE,
    p_grouped_item_no           gicl_loss_exp_ds.grouped_item_no%TYPE,
    p_peril_cd                  gicl_loss_exp_ds.peril_cd%TYPE,
    p_claim_id                  gicl_claims.claim_id%TYPE
    );

   PROCEDURE OPEN_CLAIMS (
    p_claim_id        IN        gicl_claims.claim_id%TYPE,
    p_loss_date       IN        gicl_claims.loss_date%TYPE,
    p_chk_reserve     IN OUT    VARCHAR2,
    p_chk_spld        IN OUT    VARCHAR2
    );

   PROCEDURE REDISTRIBUTE_RESERVE_GICLS039 (
    p_claim_id                  gicl_claims.claim_id%TYPE,
    p_line_cd                   gicl_claims.line_cd%TYPE,
    p_subline_cd                gicl_claims.subline_cd%TYPE,
    p_pol_iss_cd                gicl_claims.pol_iss_cd%TYPE,
    p_issue_yy                  gicl_claims.issue_yy%TYPE,
    p_pol_seq_no                gicl_claims.pol_seq_no%TYPE,
    p_renew_no                  gicl_claims.renew_no%TYPE,
    p_pol_eff_date              gicl_claims.pol_eff_date%TYPE,
    p_expiry_date               gicl_claims.expiry_date%TYPE,
    p_dsp_loss_date             gicl_claims.loss_date%TYPE,
    p_clm_file_date             gicl_claims.clm_file_date%TYPE,
    p_catastrophic_cd           gicl_claims.catastrophic_cd%TYPE,
    p_user_id                   giis_users.user_id%TYPE
    );

   PROCEDURE CREATE_NEW_RESERVE_GICLS039 (
    p_claim_id                  gicl_claims.claim_id%TYPE,
      p_item_no                   gicl_item_peril.item_no%TYPE,
      p_peril_cd                  gicl_item_peril.peril_cd%TYPE,
      p_grouped_item_no           gicl_item_peril.grouped_Item_no%TYPE,
      p_dsp_loss_date                 gicl_claims.dsp_loss_date%TYPE,
      p_clm_file_date             gicl_claims.clm_file_date%TYPE,
      p_line_cd                   gicl_claims.line_cd%TYPE,  --for distribute_reserve
      p_subline_cd                gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd                gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy                  gicl_claims.issue_yy%TYPE,
      p_pol_seq_no                gicl_claims.pol_seq_no%TYPE,
      p_renew_no                  gicl_claims.renew_no%TYPE,
      p_pol_eff_date              gicl_claims.pol_eff_date%TYPE,
      p_expiry_date               gicl_claims.expiry_date%TYPE,
     -- p_loss_date                 gicl_claims.loss_date%TYPE,
      p_catastrophic_cd           gicl_claims.catastrophic_cd%TYPE,
      p_user_id                   VARCHAR2 --Added by Jerome Bautista SR 21233 01.21.2016
    );

   /*PROCEDURE GET_BOOKING_DATE(
    p_loss_date      IN          gicl_claims.loss_date%TYPE,
    p_clm_file_date  IN          gicl_claims.clm_file_date%TYPE,
    p_month          IN OUT      gicl_clm_res_hist.booking_month%TYPE,
    p_year           IN OUT      gicl_clm_res_hist.booking_year%TYPE
    );*/

   PROCEDURE PROCESS_DISTRIBUTION_GICLS039 (
    p_claim_id                  gicl_claims.claim_id%TYPE,
    p_clm_res_hist              gicl_clm_res_hist.clm_res_hist_id%TYPE,
    p_hist_seq_no               gicl_clm_res_hist.hist_seq_no%TYPE,
    p_item_no                   gicl_item_peril.item_no%TYPE,
    p_grouped_item_no           gicl_item_peril.grouped_item_no%TYPE,
    p_peril_cd                  gicl_item_peril.peril_cd%TYPE,
    p_line_cd                   gicl_claims.line_cd%TYPE,
    p_subline_cd                gicl_claims.subline_cd%TYPE,
    p_pol_iss_cd                gicl_claims.pol_iss_cd%TYPE,
    p_issue_yy                  gicl_claims.issue_yy%TYPE,
    p_pol_seq_no                gicl_claims.pol_seq_no%TYPE,
    p_renew_no                  gicl_claims.renew_no%TYPE,
    p_pol_eff_date              gicl_claims.pol_eff_date%TYPE,
    p_expiry_date               gicl_claims.expiry_date%TYPE,
    p_loss_date                 gicl_claims.loss_date%TYPE,
    p_catastrophic_cd           gicl_claims.catastrophic_cd%TYPE,
    p_user_id                   VARCHAR2 --Added by Jerome Bautista SR 21233 01.21.2016
    );

   PROCEDURE DISTRIBUTE_RESERVE_GICLS039 (
    p_claim_id                    gicl_clm_res_hist.claim_id%type,
    p_clm_res_hist_id           gicl_clm_res_hist.clm_res_hist_id%type,
    p_item_no                   gicl_item_peril.item_no%TYPE,
    p_peril_cd                  gicl_item_peril.peril_cd%TYPE,
    p_line_cd                   gicl_claims.line_cd%TYPE,
    p_subline_cd                gicl_claims.subline_cd%TYPE,
    p_pol_iss_cd                gicl_claims.pol_iss_cd%TYPE,
    p_issue_yy                  gicl_claims.issue_yy%TYPE,
    p_pol_seq_no                gicl_claims.pol_seq_no%TYPE,
    p_renew_no                  gicl_claims.renew_no%TYPE,
    p_pol_eff_date              gicl_claims.pol_eff_date%TYPE,
    p_expiry_date               gicl_claims.expiry_date%TYPE,
    p_loss_date                 gicl_claims.loss_date%TYPE,
    p_catastrophic_cd           gicl_claims.catastrophic_cd%TYPE,
    p_grouped_item_no           gicl_item_peril.grouped_item_no%TYPE, --Added by Jerome Bautista 01.13.2016 SR 21233
    p_user_id                   VARCHAR2 --Added by Jerome Bautista SR 21233 01.21.2016
    );

   PROCEDURE REOPEN_CLAIMS (
     p_claim_id                gicl_clm_res_hist.claim_id%type,
     p_refresh_sw           gicl_claims.refresh_sw%type,
     p_max_endt_seq_no      gicl_claims.max_endt_seq_no%TYPE,
     p_dsp_loss_date        gicl_claims.dsp_loss_date%TYPE,
     p_pol_eff_date         gicl_claims.pol_eff_date%TYPE,
     p_line_cd              gicl_claims.line_cd%TYPE,
     p_subline_cd           gicl_claims.subline_cd%TYPE,
     p_pol_iss_cd           gicl_claims.iss_cd%TYPE,
     p_issue_yy             gicl_claims.issue_yy%TYPE,
     p_pol_seq_no           gicl_claims.pol_seq_no%TYPE,
     p_renew_no             gicl_claims.renew_no%TYPE,
     p_assd_no              gicl_claims.assd_no%TYPE,      -- FOR EXTRACT_LATEST_ASSURED
     p_acct_of_cd           gicl_claims.acct_of_cd%TYPE,
     p_assured_name         gicl_claims.assured_name%TYPE,
     p_assd_name2           gicl_claims.assd_name2%TYPE,
     p_user_id              gicl_claims.user_id%TYPE
    );

   PROCEDURE UPDATE_SPOILED(
     p_claim_id              gicl_claims.claim_id%TYPE,
     p_max_endt_seq_no       gicl_claims.max_endt_seq_no%TYPE,
     p_dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
     p_pol_eff_date          gicl_claims.pol_eff_date%TYPE,  -- FOR UPDATE_EXPIRY
     p_line_cd               gicl_claims.line_cd%TYPE,
     p_subline_cd            gicl_claims.subline_cd%TYPE,
     p_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
     p_issue_yy              gicl_claims.issue_yy%TYPE,
     p_pol_seq_no            gicl_claims.pol_seq_no%TYPE,
     p_renew_no              gicl_claims.renew_no%TYPE,
     p_assd_no               gicl_claims.assd_no%TYPE,      -- FOR EXTRACT_LATEST_ASSURED
     p_acct_of_cd            gicl_claims.acct_of_cd%TYPE,
     p_assured_name          gicl_claims.assured_name%TYPE,
     p_assd_name2            gicl_claims.assd_name2%TYPE
    );

   PROCEDURE UPDATE_ENDT_INFO(
     p_claim_id              gicl_claims.claim_id%TYPE,
     p_max_endt_seq_no       gicl_claims.max_endt_seq_no%TYPE,
     p_dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
     p_pol_eff_date          gicl_claims.pol_eff_date%TYPE,
     p_line_cd               gicl_claims.line_cd%TYPE,
     p_subline_cd            gicl_claims.subline_cd%TYPE,
     p_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
     p_issue_yy              gicl_claims.issue_yy%TYPE,
     p_pol_seq_no            gicl_claims.pol_seq_no%TYPE,
     p_renew_no              gicl_claims.renew_no%TYPE,
     p_assd_no               gicl_claims.assd_no%TYPE,      -- FOR EXTRACT_LATEST_ASSURED
     p_acct_of_cd            gicl_claims.acct_of_cd%TYPE,
     p_assured_name          gicl_claims.assured_name%TYPE,
     p_assd_name2            gicl_claims.assd_name2%TYPE
     );

    PROCEDURE CONFIRM_USER_GICLS039(
     p_type                IN     VARCHAR2,
     p_claim_id            IN     gicl_claims.claim_id%TYPE,
     p_line_cd             IN     gicl_claims.line_cd%TYPE,
     p_subline_cd          IN     gicl_claims.subline_cd%TYPE,
     p_iss_cd              IN     gicl_claims.iss_cd%TYPE,
     p_clm_yy              IN     gicl_claims.clm_yy%TYPE,
     p_clm_seq_no          IN     gicl_claims.clm_seq_no%TYPE,
     p_catastrophic_cd     IN     gicl_claims.catastrophic_cd%TYPE,
     p_select_type         IN     VARCHAR2,
     p_status_control      IN     NUMBER,
     p_cat_payt_res_flag   IN OUT VARCHAR2,
     p_cat_desc            OUT    VARCHAR2,
     p_message_text        OUT    VARCHAR2);

    PROCEDURE DENY_CLAIMS_GICLS039(
     p_claim_id            IN       gicl_claims.claim_id%TYPE,
     p_catastrophic_cd     IN       gicl_claims.catastrophic_cd%TYPE,
     p_line_cd             IN       gicl_claims.line_cd%TYPE,
     p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
     p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
     p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
     p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
     p_old_stat_cd         IN       gicl_claims.clm_stat_cd%TYPE,
     p_cat_payt_res_flag   IN OUT   VARCHAR2,
     p_cat_desc            OUT      VARCHAR2,
     p_msg_txt             OUT      VARCHAR2);

    PROCEDURE WITHDRAW_CLAIMS_GICLS039(
     p_claim_id            IN       gicl_claims.claim_id%TYPE,
     p_catastrophic_cd     IN       gicl_claims.catastrophic_cd%TYPE,
     p_line_cd             IN       gicl_claims.line_cd%TYPE,
     p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
     p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
     p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
     p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
     p_old_stat_cd         IN       gicl_claims.clm_stat_cd%TYPE,
     p_cat_payt_res_flag   IN OUT   VARCHAR2,
     p_cat_desc            OUT      VARCHAR2,
     p_msg_txt             OUT      VARCHAR2);

    PROCEDURE CANCEL_CLAIMS_GICLS039(
     p_claim_id            IN       gicl_claims.claim_id%TYPE,
     p_catastrophic_cd     IN       gicl_claims.catastrophic_cd%TYPE,
     p_line_cd             IN       gicl_claims.line_cd%TYPE,
     p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
     p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
     p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
     p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
     p_old_stat_cd         IN       gicl_claims.clm_stat_cd%TYPE,
     p_cat_payt_res_flag   IN OUT   VARCHAR2,
     p_cat_desc            OUT      VARCHAR2,
     p_msg_txt             OUT       VARCHAR2);

    PROCEDURE CHK_CLM_CLOSING_GICLS039(
     v_claim_id       IN      gicl_claims.claim_id%TYPE,
     v_prntd_fla      IN      VARCHAR2,
     v_chk_tag        IN      VARCHAR2,
     --v_payt_sw        OUT     VARCHAR2,
     v_batch_chkbx    OUT     VARCHAR2,
     v_tag_allow      OUT     VARCHAR2,
     v_param          OUT     VARCHAR2,
     v_msg_alert      OUT     VARCHAR2);

    PROCEDURE CLOSE_CLAIMS(
     p_claim_id       IN    gicl_claims.claim_id%TYPE,
     p_line_cd        IN    gicl_claims.line_cd%TYPE,
     p_remarks        IN    gicl_claims.remarks%TYPE,
     p_recovery_sw    IN    gicl_claims.recovery_sw%TYPE,
     p_closed_status  IN    VARCHAR2,
     p_msg_txt        OUT   VARCHAR2);

    TYPE claims_information_type IS RECORD(
        claim_id            GICL_CLAIMS.claim_id%TYPE,
        claim_no            VARCHAR2 (100),
        policy_no           VARCHAR2 (100),
        line_cd             GICL_CLAIMS.line_cd%TYPE,
        subline_cd          GICL_CLAIMS.subline_cd%TYPE,
        issue_yy            GICL_CLAIMS.issue_yy%TYPE,
        pol_seq_no          GICL_CLAIMS.pol_seq_no%TYPE,
        renew_no            GICL_CLAIMS.renew_no%TYPE,
        pol_iss_cd          GICL_CLAIMS.pol_iss_cd%TYPE,
        clm_yy              GICL_CLAIMS.clm_yy%TYPE,
        clm_seq_no          GICL_CLAIMS.clm_seq_no%TYPE,
        iss_cd              GICL_CLAIMS.iss_cd%TYPE,
        assd_no             GICL_CLAIMS.assd_no%TYPE,
        dsp_assured            VARCHAR2(1500),
        assured_name        GICL_CLAIMS.assured_name%TYPE,
        assd_name2          GICL_CLAIMS.assd_name2%TYPE,
        recovery_sw         GICL_CLAIMS.recovery_sw%TYPE,
        user_id             GICL_CLAIMS.user_id%TYPE,
        last_update         GICL_CLAIMS.last_update%TYPE,
        loss_date           GICL_CLAIMS.loss_date%TYPE,
        dsp_loss_date       GICL_CLAIMS.dsp_loss_date%TYPE,
        dsp_loss_time        VARCHAR2(50),
        clm_file_date       GICL_CLAIMS.clm_file_date%TYPE,
        entry_date          GICL_CLAIMS.entry_date%TYPE,
        clm_stat_cd         GICL_CLAIMS.clm_stat_cd%TYPE,
        clm_stat_desc       GIIS_CLM_STAT.clm_stat_desc%TYPE,
        clm_setl_date       GICL_CLAIMS.clm_setl_date%TYPE,
        loss_pd_amt         GICL_CLAIMS.loss_pd_amt%TYPE,
        loss_res_amt        GICL_CLAIMS.loss_res_amt%TYPE,
        exp_pd_amt          GICL_CLAIMS.exp_pd_amt%TYPE,
        in_hou_adj          GICL_CLAIMS.in_hou_adj%TYPE,
        in_hou_adj_name        GIIS_USERS.user_name%TYPE,
        intm_no             GICL_CLAIMS.intm_no%TYPE,
        loss_cat_cd         GICL_CLAIMS.loss_cat_cd%TYPE,
        loss_cat_desc        GIIS_LOSS_CTGRY.loss_cat_des%TYPE,
        loss_loc1           GICL_CLAIMS.loss_loc1%TYPE,
        loss_loc2           GICL_CLAIMS.loss_loc2%TYPE,
        loss_loc3           GICL_CLAIMS.loss_loc3%TYPE,
        pol_eff_date        GICL_CLAIMS.pol_eff_date%TYPE,
        csr_no              GICL_CLAIMS.csr_no%TYPE,
        clm_amt             GICL_CLAIMS.clm_amt%TYPE,
        loss_dtls           GICL_CLAIMS.loss_dtls%TYPE,
        obligee_no          GICL_CLAIMS.obligee_no%TYPE,
        exp_res_amt         GICL_CLAIMS.exp_res_amt%TYPE,
        ri_cd               GICL_CLAIMS.ri_cd%TYPE,
        ri_name                GIIS_REINSURER.ri_name%TYPE,
        plate_no            GICL_CLAIMS.plate_no%TYPE,
        clm_dist_tag        GICL_CLAIMS.clm_dist_tag%TYPE,
        old_stat_cd         GICL_CLAIMS.old_stat_cd%TYPE,
        close_date          GICL_CLAIMS.close_date%TYPE,
        expiry_date         GICL_CLAIMS.expiry_date%TYPE,
        acct_of_cd          GICL_CLAIMS.acct_of_cd%TYPE,
        acct_of_cd_name        GIIS_ASSURED.assd_name%TYPE,
        pack_policy_id      GICL_CLAIMS.pack_policy_id%TYPE,
        pack_pol_no         VARCHAR2 (100),
        max_endt_seq_no     GICL_CLAIMS.max_endt_seq_no%TYPE,
        assignee            VARCHAR2(500),
        remarks                GICL_CLAIMS.remarks%TYPE,
        catastrophic_cd        GICL_CLAIMS.catastrophic_cd%TYPE,
        catastrophic_desc   GICL_CAT_DTL.catastrophic_desc%TYPE,
        cred_branch            GICL_CLAIMS.cred_branch%TYPE,
        cred_branch_name    GIIS_ISSOURCE.iss_name%TYPE,
        dsp_op_number        VARCHAR2 (100),
        total_tag            GICL_CLAIMS.total_tag%TYPE,
        survey_agent_cd     GICL_CLAIMS.survey_agent_cd%TYPE,
        settling_agent_cd   GICL_CLAIMS.settling_agent_cd%TYPE,
        dsp_settling_name   VARCHAR2 (32000),
        dsp_survey_name     VARCHAR2 (32000),
        gicl_mortgagee_exist VARCHAR2(1),
        recovery_exist        VARCHAR2(1),
        basic_intm_exist    VARCHAR2(1),
        sdf_loss_date       VARCHAR2(20),--added by steven  06.03.2013
        sdf_clm_file_date   VARCHAR2(20),--added by steven  06.03.2013
        line_name           VARCHAR2(50) --added by gab 05.23.2016 SR 21694
    );

    TYPE claims_information_tab IS TABLE OF claims_information_type;
    --Added by pjsantos 11/08/2016 for optimization GENQA 5818
     TYPE claims_information_type2 IS RECORD(
        count_              NUMBER,
        rownum_             NUMBER,
        claim_id            GICL_CLAIMS.claim_id%TYPE,
        claim_no            VARCHAR2 (100),
        policy_no           VARCHAR2 (100),
        line_cd             GICL_CLAIMS.line_cd%TYPE,
        subline_cd          GICL_CLAIMS.subline_cd%TYPE,
        issue_yy            GICL_CLAIMS.issue_yy%TYPE,
        pol_seq_no          GICL_CLAIMS.pol_seq_no%TYPE,
        renew_no            GICL_CLAIMS.renew_no%TYPE,
        pol_iss_cd          GICL_CLAIMS.pol_iss_cd%TYPE,
        clm_yy              GICL_CLAIMS.clm_yy%TYPE,
        clm_seq_no          GICL_CLAIMS.clm_seq_no%TYPE,
        iss_cd              GICL_CLAIMS.iss_cd%TYPE,
        assd_no             GICL_CLAIMS.assd_no%TYPE,
        dsp_assured         VARCHAR2(1500),
        assured_name        GICL_CLAIMS.assured_name%TYPE,
        assd_name2          GICL_CLAIMS.assd_name2%TYPE,
        recovery_sw         GICL_CLAIMS.recovery_sw%TYPE,
        user_id             GICL_CLAIMS.user_id%TYPE,
        last_update         GICL_CLAIMS.last_update%TYPE,
        loss_date           GICL_CLAIMS.loss_date%TYPE,
        dsp_loss_date       GICL_CLAIMS.dsp_loss_date%TYPE,
        acct_of_cd          GICL_CLAIMS.acct_of_cd%TYPE,
        clm_file_date       GICL_CLAIMS.clm_file_date%TYPE,
        entry_date          GICL_CLAIMS.entry_date%TYPE,
        obligee_no          GICL_CLAIMS.obligee_no%TYPE,
        clm_stat_cd         GICL_CLAIMS.clm_stat_cd%TYPE,
        clm_stat_desc       GIIS_CLM_STAT.clm_stat_desc%TYPE,
        clm_setl_date       GICL_CLAIMS.clm_setl_date%TYPE,
        loss_pd_amt         GICL_CLAIMS.loss_pd_amt%TYPE,
        loss_res_amt        GICL_CLAIMS.loss_res_amt%TYPE,
        exp_pd_amt          GICL_CLAIMS.exp_pd_amt%TYPE,
        in_hou_adj          GICL_CLAIMS.in_hou_adj%TYPE,
        intm_no             GICL_CLAIMS.intm_no%TYPE,
        loss_cat_cd         GICL_CLAIMS.loss_cat_cd%TYPE,
        loss_loc1           GICL_CLAIMS.loss_loc1%TYPE, 
        loss_loc2           GICL_CLAIMS.loss_loc2%TYPE,
        loss_loc3           GICL_CLAIMS.loss_loc3%TYPE,
        pol_eff_date        GICL_CLAIMS.pol_eff_date%TYPE,
        csr_no              GICL_CLAIMS.csr_no%TYPE,
        clm_amt             GICL_CLAIMS.clm_amt%TYPE,
        loss_dtls           GICL_CLAIMS.loss_dtls%TYPE,        
        exp_res_amt         GICL_CLAIMS.exp_res_amt%TYPE, 
        ri_cd               GICL_CLAIMS.ri_cd%TYPE,
        plate_no            GICL_CLAIMS.plate_no%TYPE,
        clm_dist_tag        GICL_CLAIMS.clm_dist_tag%TYPE,
        old_stat_cd         GICL_CLAIMS.old_stat_cd%TYPE,
        close_date          GICL_CLAIMS.close_date%TYPE,
        expiry_date         GICL_CLAIMS.expiry_date%TYPE,  
        max_endt_seq_no     GICL_CLAIMS.max_endt_seq_no%TYPE,      
        pack_policy_id      GICL_CLAIMS.pack_policy_id%TYPE,
        pack_pol_no         VARCHAR2 (100),        
        assignee            VARCHAR2(500),
        sdf_loss_date       VARCHAR2(20), 
        sdf_clm_file_date   VARCHAR2(20),
        line_name           VARCHAR2(50) 
    );
        TYPE claims_information_tab2 IS TABLE OF claims_information_type2;
     --pjsantos end

    FUNCTION get_claims_information_listing(
          p_line_cd           GICL_CLAIMS.line_cd%TYPE,
          p_subline_cd        GICL_CLAIMS.subline_cd%TYPE,
          p_iss_cd            GICL_CLAIMS.iss_cd%TYPE,
          p_clm_yy            GICL_CLAIMS.clm_yy%TYPE,
          p_clm_seq_no        GICL_CLAIMS.clm_seq_no%TYPE,
          p_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE,
          p_pol_issue_yy      GICL_CLAIMS.issue_yy%TYPE,
          p_pol_seq_no        GICL_CLAIMS.pol_seq_no%TYPE,
          p_renew_no          GICL_CLAIMS.pol_iss_cd%TYPE,
          p_assured_name      VARCHAR2,
          p_plate_number      GICL_CLAIMS.plate_no%TYPE,
          p_claim_stat_desc   VARCHAR2,
          p_clm_file_date     VARCHAR2,
          p_loss_date         VARCHAR2,
          p_claim_id          GICL_CLAIMS.claim_id%TYPE, --added by robert SR 21694 03.28.16
          p_module_id         VARCHAR2,
          p_user_id           GIIS_USERS.user_id%TYPE,
          p_order_by          VARCHAR2,      
          p_asc_desc_flag     VARCHAR2,      
          p_first_row         NUMBER,        
          p_last_row          NUMBER         )

    RETURN claims_information_tab2 PIPELINED;--modified by pjsantos 11/08/2016 for optimization GENQA 5818

    FUNCTION get_claims_info_basic_details(p_claim_id    GICL_CLAIMS.claim_id%TYPE)
    RETURN claims_information_tab PIPELINED;

   /** Added by adpascual 
   **  07.0213
   **/ 
   TYPE gicl_claims_v2_type IS RECORD (
      claim_id         gicl_claims.claim_id%TYPE,
      line_cd          gicl_claims.line_cd%TYPE,
      subline_cd       gicl_claims.subline_cd%TYPE,
      clm_line_cd      gicl_claims.line_cd%TYPE,
      clm_subline_cd   gicl_claims.subline_cd%TYPE,
      iss_cd           gicl_claims.iss_cd%TYPE,
      pol_iss_cd       gicl_claims.iss_cd%TYPE,
      clm_yy           gicl_claims.clm_yy%TYPE,
      issue_yy         gicl_claims.issue_yy%TYPE,
      clm_seq_no       gicl_claims.clm_seq_no%TYPE,
      pol_seq_no       gicl_claims.pol_seq_no%TYPE,
      renew_no         gicl_claims.renew_no%TYPE,
      assured_name     gicl_claims.assured_name%TYPE,
      clm_stat_desc    giis_clm_stat.clm_stat_desc%TYPE,
      loss_date        gicl_claims.loss_date%TYPE,
      loss_cat         VARCHAR2 (1000)
   );

   TYPE gicl_claims_v2_tab IS TABLE OF gicl_claims_v2_type;

   FUNCTION get_claim_list_lov (
      p_module           VARCHAR2,
      p_line_cd          gicl_claims.line_cd%TYPE,
      p_subline_cd       gicl_claims.subline_cd%TYPE,
      p_clm_line_cd      gicl_claims.line_cd%TYPE,
      p_clm_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd           gicl_claims.iss_cd%TYPE,
      p_pol_iss_cd       gicl_claims.iss_cd%TYPE,
      p_clm_yy           gicl_claims.issue_yy%TYPE,
      p_issue_yy         gicl_claims.issue_yy%TYPE,
      p_clm_seq_no       gicl_claims.clm_seq_no%TYPE,
      p_pol_seq_no       gicl_claims.clm_seq_no%TYPE,
      p_renew_no         gicl_claims.renew_no%TYPE,
      p_user_id          giis_users.user_id%TYPE
   )
      RETURN gicl_claims_v2_tab PIPELINED;

   PROCEDURE validate_giac_param_stat;
END gicl_claims_pkg;
/


