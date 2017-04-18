CREATE OR REPLACE PACKAGE CPI.GICLS212_PKG
   /*
   **  Created by        : bonok
   **  Date Created      : 09.12.2013
   **  Reference By      : GICLS212 - VIEW LOSS PROFILE DETAILS
   **
   */
AS   
   TYPE summary_type IS RECORD (
      range_from              gicl_loss_profile.range_from%TYPE,
      range_to                gicl_loss_profile.range_to%TYPE,
      policy_count            gicl_loss_profile.policy_count%TYPE,
      total_tsi_amt           gicl_loss_profile.total_tsi_amt%TYPE,
      nbt_gross_loss          gicl_loss_profile.net_retention%TYPE,
      net_retention           gicl_loss_profile.net_retention%TYPE,
      sec_net_retention_loss  gicl_loss_profile.sec_net_retention_loss%TYPE,
      facultative             gicl_loss_profile.facultative%TYPE,
      treaty1_loss            gicl_loss_profile.treaty1_loss%TYPE,
      treaty2_loss            gicl_loss_profile.treaty2_loss%TYPE,
      treaty3_loss            gicl_loss_profile.treaty3_loss%TYPE,
      treaty4_loss            gicl_loss_profile.treaty4_loss%TYPE,
      treaty5_loss            gicl_loss_profile.treaty5_loss%TYPE,
      treaty6_loss            gicl_loss_profile.treaty6_loss%TYPE,
      treaty7_loss            gicl_loss_profile.treaty7_loss%TYPE,
      treaty8_loss            gicl_loss_profile.treaty8_loss%TYPE,
      treaty9_loss            gicl_loss_profile.treaty9_loss%TYPE,
      treaty10_loss           gicl_loss_profile.treaty10_loss%TYPE,
      treaty                  gicl_loss_profile.treaty%TYPE,
      quota_share             gicl_loss_profile.quota_share%TYPE,
      sum_policy_count        gicl_loss_profile.policy_count%TYPE,
      sum_total_tsi_amt       gicl_loss_profile.total_tsi_amt%TYPE,
      sum_nbt_gross_loss      gicl_loss_profile.net_retention%TYPE,
      sum_net_retention       gicl_loss_profile.net_retention%TYPE,
      sum_facultative         gicl_loss_profile.facultative%TYPE,
      sum_treaty              gicl_loss_profile.treaty%TYPE,
      lbl1                    giis_dist_share.trty_name%TYPE,
      lbl2                    giis_dist_share.trty_name%TYPE,
      lbl3                    giis_dist_share.trty_name%TYPE,
      lbl4                    giis_dist_share.trty_name%TYPE,
      lbl5                    giis_dist_share.trty_name%TYPE,
      lbl6                    giis_dist_share.trty_name%TYPE,
      lbl7                    giis_dist_share.trty_name%TYPE,
      lbl8                    giis_dist_share.trty_name%TYPE,
      lbl9                    giis_dist_share.trty_name%TYPE,
      lbl10                   giis_dist_share.trty_name%TYPE
   );
   
   TYPE summary_tab IS TABLE OF summary_type; 
   
   FUNCTION get_summary_list(
      p_global_choice         VARCHAR2,
      p_global_treaty         VARCHAR2,
      p_global_line_cd        gicl_loss_profile.line_cd%TYPE,
      p_global_subline_cd     gicl_loss_profile.subline_cd%TYPE,
      p_user_id               gicl_loss_profile.user_id%TYPE
   ) RETURN summary_tab PIPELINED;
   
   FUNCTION get_sum_summary_list(
      p_global_choice         VARCHAR2,
      p_global_treaty         VARCHAR2,
      p_global_line_cd        gicl_loss_profile.line_cd%TYPE,
      p_global_subline_cd     gicl_loss_profile.subline_cd%TYPE,
      p_user_id               gicl_loss_profile.user_id%TYPE
   ) RETURN summary_tab PIPELINED;
   
   TYPE range_type IS RECORD(
      range_from              gicl_loss_profile.range_from%TYPE,
      range_to                gicl_loss_profile.range_to%TYPE
   );
   
   TYPE range_tab IS TABLE OF range_type; 
   
   FUNCTION get_range_list(
      p_global_line_cd        gicl_loss_profile.line_cd%TYPE,
      p_global_subline_cd     gicl_loss_profile.subline_cd%TYPE
   ) RETURN range_tab PIPELINED;
   
   TYPE detail_type IS RECORD (
      claim_id                gicl_claims.claim_id%TYPE,
      nbt_pol                 VARCHAR2(50),
      tsi_amt                 gicl_loss_profile_ext2.tsi_amt%TYPE,
      loss_amt                gicl_loss_profile_ext3.loss_amt%TYPE,
      nbt_claim_no            VARCHAR2(50),
      assured_name            giis_assured.assd_name%TYPE,
      nbt_gross_loss          gicl_loss_profile.net_retention%TYPE,
      nbt_net_ret             gicl_loss_profile.net_retention%TYPE,
      nbt_treaty              gicl_loss_profile.treaty%TYPE,
      nbt_facul               gicl_loss_profile.facultative%TYPE,
      sum_nbt_gross_loss      gicl_loss_profile.net_retention%TYPE,
      sum_nbt_net_ret         gicl_loss_profile.net_retention%TYPE,
      sum_nbt_treaty          gicl_loss_profile.treaty%TYPE,
      sum_nbt_facul           gicl_loss_profile.facultative%TYPE
   );
   
   TYPE detail_tab IS TABLE OF detail_type; 
   
   FUNCTION get_detail_list(
      p_global_extr           VARCHAR2,
      p_range_from            gicl_loss_profile.range_from%TYPE,
      p_range_to              gicl_loss_profile.range_to%TYPE,
      p_line_cd               gicl_loss_profile.line_cd%TYPE,
      p_subline_cd            gicl_loss_profile.subline_cd%TYPE,
      p_user_id               gicl_loss_profile.user_id%TYPE
   ) RETURN detail_tab PIPELINED;
   
   FUNCTION get_sum_detail_list(
      p_global_extr           VARCHAR2,
      p_range_from            gicl_loss_profile.range_from%TYPE,
      p_range_to              gicl_loss_profile.range_to%TYPE,
      p_line_cd               gicl_loss_profile.line_cd%TYPE,
      p_subline_cd            gicl_loss_profile.subline_cd%TYPE,
      p_user_id               gicl_loss_profile.user_id%TYPE
   ) RETURN detail_tab PIPELINED;
   
   FUNCTION check_recovery(
      p_claim_id              gicl_claims.claim_id%TYPE
   ) RETURN VARCHAR2;
   
   TYPE recovery_type IS RECORD (
      nbt_rec_no              VARCHAR2(50),
      nbt_gross_loss          gicl_loss_profile.net_retention%TYPE,
      nbt_net_ret             gicl_loss_profile.net_retention%TYPE,
      nbt_treaty              gicl_loss_profile.treaty%TYPE,
      nbt_facul               gicl_loss_profile.facultative%TYPE,
      sum_nbt_gross_loss      gicl_loss_profile.net_retention%TYPE,
      sum_nbt_net_ret         gicl_loss_profile.net_retention%TYPE,
      sum_nbt_treaty          gicl_loss_profile.treaty%TYPE,
      sum_nbt_facul           gicl_loss_profile.facultative%TYPE
   );
   
   TYPE recovery_tab IS TABLE OF recovery_type;
   
   FUNCTION get_recovery_list(
      p_claim_id              gicl_clm_recovery.claim_id%TYPE,
      p_global_extr           VARCHAR2
   ) RETURN recovery_tab PIPELINED;
END GICLS212_PKG;
/


