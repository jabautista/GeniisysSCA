CREATE OR REPLACE PACKAGE CPI.gicls039_pkg
AS
   PROCEDURE reopen_claims (
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
      p_refresh_sw        gicl_claims.refresh_sw%TYPE,
      p_max_endt_seq_no   gicl_claims.max_endt_seq_no%TYPE,
      p_dsp_loss_date     gicl_claims.dsp_loss_date%TYPE,
      p_pol_eff_date      gicl_claims.pol_eff_date%TYPE,
      p_line_cd           gicl_claims.line_cd%TYPE,
      p_subline_cd        gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd        gicl_claims.iss_cd%TYPE,
      p_issue_yy          gicl_claims.issue_yy%TYPE,
      p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      p_renew_no          gicl_claims.renew_no%TYPE,
      p_assd_no           gicl_claims.assd_no%TYPE,
      -- FOR EXTRACT_LATEST_ASSURED
      p_acct_of_cd        gicl_claims.acct_of_cd%TYPE,
      p_assured_name      gicl_claims.assured_name%TYPE,
      p_assd_name2        gicl_claims.assd_name2%TYPE,
      p_user_id           gicl_claims.user_id%TYPE
   );

   PROCEDURE close_claims (
      p_claim_id        IN       gicl_claims.claim_id%TYPE,
      p_line_cd         IN       gicl_claims.line_cd%TYPE,
      p_remarks         IN       gicl_claims.remarks%TYPE,
      p_recovery_sw     IN       gicl_claims.recovery_sw%TYPE,
      p_closed_status   IN       VARCHAR2,
      p_msg_txt         OUT      VARCHAR2
   );

   PROCEDURE chk_clm_closing_gicls039 (
      v_claim_id      IN       gicl_claims.claim_id%TYPE,
      v_prntd_fla     IN       VARCHAR2,
      v_chk_tag       IN       VARCHAR2,
      v_batch_chkbx   OUT      VARCHAR2,
      v_tag_allow     OUT      VARCHAR2,
      v_param         OUT      VARCHAR2,
      v_msg_alert     OUT      VARCHAR2
   );

   PROCEDURE deny_claims_gicls039 (
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
      p_msg_txt             OUT      VARCHAR2
   );

   PROCEDURE confirm_user_gicls039 (
      p_type                IN       VARCHAR2,
      p_claim_id            IN       gicl_claims.claim_id%TYPE,
      p_line_cd             IN       gicl_claims.line_cd%TYPE,
      p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
      p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
      p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
      p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
      p_catastrophic_cd     IN       gicl_claims.catastrophic_cd%TYPE,
      p_select_type         IN       VARCHAR2,
      p_status_control      IN       NUMBER,
      p_cat_payt_res_flag   IN OUT   VARCHAR2,
      p_cat_desc            OUT      VARCHAR2,
      p_message_text        OUT      VARCHAR2
   );

   PROCEDURE withdraw_claims_gicls039 (
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
      p_msg_txt             OUT      VARCHAR2
   );

   PROCEDURE cancel_claims_gicls039 (
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
      p_msg_txt             OUT      VARCHAR2
   );
   
   -- added by gab 08.14.2015
   TYPE assured_type IS RECORD(
     assd_no gicl_claims.assd_no%TYPE,
     assured_name gicl_claims.assured_name%TYPE
   );
   
   TYPE assured_tab IS TABLE OF assured_type;
   
   FUNCTION get_assured_lov (
     p_find_text VARCHAR2
   ) RETURN assured_tab PIPELINED;
   
   TYPE processor_type IS RECORD(
     user_id giis_users.user_id%TYPE,
     user_name giis_users.user_name%TYPE
   );
   
   --moved from gicl_claims_pkg kenneth L SR 5147 11.13.2015
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
      with_recovery            VARCHAR2 (1),
      reason_desc              VARCHAR2 (500)
   );

   TYPE gicl_claim_closing_tab IS TABLE OF gicl_claim_closing_type;
   
   --moved from gicl_claims_pkg kenneth L SR 5147 11.13.2015
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
   
   --start kenneth L SR 5147 11.13.2015
   TYPE reason_list_type IS RECORD (
       count_               NUMBER,
       rownum_              NUMBER,
       reason_cd			gicl_reasons.reason_cd%TYPE,
	   reason_desc          gicl_reasons.reason_desc%TYPE
   );
   
   TYPE reason_list_tab IS TABLE OF reason_list_type;
   
   FUNCTION get_reason_lov (
       p_find_text     	    VARCHAR2,
       p_order_by      	    VARCHAR2,
       p_asc_desc_flag      VARCHAR2,
       p_from          	    NUMBER,
       p_to            	    NUMBER
   ) RETURN reason_list_tab PIPELINED;
   
   PROCEDURE update_reason_cd(
       p_claim_id       IN  GICL_CLAIMS.claim_id%TYPE,
       p_reason_cd      IN  GICL_CLAIMS.reason_cd%TYPE
   );
   --end kenneth L SR 5147 11.13.2015
   
END;
/
