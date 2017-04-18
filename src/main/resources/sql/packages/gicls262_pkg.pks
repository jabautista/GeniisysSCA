CREATE OR REPLACE PACKAGE CPI.GICLS262_PKG
AS
   TYPE clm_list_per_vessel_type IS RECORD (
      claim_id        gicl_claims.claim_id%TYPE,
      vessel_cd       gicl_hull_dtl.vessel_cd%TYPE,
      item_no         gicl_hull_dtl.item_no%TYPE,
      item_title      gicl_hull_dtl.item_title%TYPE,
      dry_date        gicl_hull_dtl.dry_date%TYPE,
      dry_place       gicl_hull_dtl.dry_place%TYPE,
      loss_date       gicl_claims.loss_date%TYPE,
      assured_name    gicl_claims.assured_name%TYPE,
      clm_file_date   gicl_claims.clm_file_date%TYPE,
      clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      claim_number    VARCHAR2 (50),
      policy_number   VARCHAR2 (50),
      los_res_amt     gicl_claims.loss_res_amt%TYPE,
      los_paid_amt    gicl_claims.loss_pd_amt%TYPE,
      exp_res_amt     gicl_claims.exp_res_amt%TYPE,
      exp_paid_amt    gicl_claims.exp_pd_amt%TYPE,
      tot_loss_res_amt   gicl_claims.loss_res_amt%TYPE,
      tot_loss_pd_amt    gicl_claims.loss_pd_amt%TYPE,
      tot_exp_res_amt    gicl_claims.exp_res_amt%TYPE,
      tot_exp_pd_amt     gicl_claims.exp_pd_amt%TYPE
   );

   TYPE clm_list_per_vessel_tab IS TABLE OF clm_list_per_vessel_type;

   TYPE vessel_lov_type IS RECORD (
      vessel_cd     giis_vessel.vessel_cd%TYPE,
      vessel_name   giis_vessel.vessel_name%TYPE
   );

   TYPE vessel_lov_tab IS TABLE OF vessel_lov_type;

   FUNCTION get_vessel_lov
      RETURN vessel_lov_tab PIPELINED;

   FUNCTION populate_per_vessel_details (
      p_vessel_cd    giis_vessel.vessel_cd%TYPE,
      p_search_by    NUMBER,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN clm_list_per_vessel_tab PIPELINED;
END GICLS262_PKG;
/


