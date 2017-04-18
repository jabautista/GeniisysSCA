CREATE OR REPLACE PACKAGE CPI.gicls274_pkg
AS
   TYPE clm_list_per_pack_policy_type IS RECORD (
      claim_id             gicl_claims.claim_id%TYPE,
      claim_no             VARCHAR (30),
      loss_res_amt         VARCHAR (50),
      exp_res_amt          VARCHAR (50),
      loss_pd_amt          VARCHAR (50),
      exp_pd_amt           VARCHAR (50),
      tot_loss_res_amt     VARCHAR (50),
      tot_loss_pd_amt      VARCHAR (50),
      tot_exp_res_amt      VARCHAR (50),
      tot_exp_pd_amt       VARCHAR (50),
      pol_no               VARCHAR (30),
      clm_stat_desc        giis_clm_stat.clm_stat_desc%TYPE,
      clm_file_date        gicl_claims.clm_file_date%TYPE,
      dsp_loss_date        gicl_claims.dsp_loss_date%TYPE,
      recovery_sw          gicl_claims.recovery_sw%TYPE,
      recovery_det_count   NUMBER (10)
   );

   TYPE clm_list_per_pack_policy_tab IS TABLE OF clm_list_per_pack_policy_type;

   TYPE lov_listing_type IS RECORD (
      code        VARCHAR2 (32000),
      code_desc   VARCHAR2 (32000)
   );

   TYPE lov_listing_tab IS TABLE OF lov_listing_type;

   TYPE get_clm_pack_policy_lov_type IS RECORD (
      line_cd          gicl_claims.line_cd%TYPE,
      subline_cd       gicl_claims.subline_cd%TYPE,
      iss_cd           gicl_claims.iss_cd%TYPE,
      issue_yy         gicl_claims.issue_yy%TYPE,
      pol_seq_no       gicl_claims.pol_seq_no%TYPE,
      renew_no         gicl_claims.renew_no%TYPE,
      assd_no          giis_assured.assd_no%TYPE,
      assd_name        giis_assured.assd_name%TYPE,
      pack_policy_id   gicl_claims.pack_policy_id%TYPE
   );

   TYPE get_clm_pack_policy_lov_tab IS TABLE OF get_clm_pack_policy_lov_type;

   FUNCTION get_clm_pack_policy_lov (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   gicl_claims.pol_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE
   )
      RETURN get_clm_pack_policy_lov_tab PIPELINED;

   FUNCTION get_clm_list_per_pack_policy (
      p_pack_policy_id   gicl_claims.pack_policy_id%TYPE,
      p_line_cd          giis_line.line_cd%TYPE,
      p_iss_cd           giis_issource.iss_cd%TYPE,
      p_user_id          giis_users.user_id%TYPE,
      p_search_by_opt    VARCHAR2,
      p_date_as_of       VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_claim_no         VARCHAR2,
      p_loss_res_amt     NUMBER,
      p_exp_res_amt      NUMBER,
      p_loss_pd_amt      NUMBER,
      p_exp_pd_amt       NUMBER,
      p_recovery_sw      VARCHAR2
   )
      RETURN clm_list_per_pack_policy_tab PIPELINED;

   /*FUNCTION get_clm_pack_line_list (p_module_id giis_modules.module_id%TYPE)
      RETURN lov_listing_tab PIPELINED;*/
   FUNCTION get_clm_pack_line_list
      RETURN lov_listing_tab PIPELINED;

   FUNCTION get_clm_pack_subline_list (p_line_cd gicl_claims.line_cd%TYPE)
      RETURN lov_listing_tab PIPELINED;

   FUNCTION get_clm_pack_iss_list (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE
   )
      RETURN lov_listing_tab PIPELINED;

   FUNCTION get_clm_issue_pack_yy_list (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd  gicl_claims.pol_iss_cd%TYPE
   )
      RETURN lov_listing_tab PIPELINED;
END;
/


