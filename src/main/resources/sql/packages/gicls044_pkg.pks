CREATE OR REPLACE PACKAGE CPI.GICLS044_PKG
AS
   TYPE claim_details_type IS RECORD (
      claim_id           gicl_claims.claim_id%TYPE,
      line_cd            gicl_claims.line_cd%TYPE,
      subline_cd         gicl_claims.subline_cd%TYPE,
      iss_cd             gicl_claims.iss_cd%TYPE,
      clm_yy             gicl_claims.clm_yy%TYPE,
      clm_seq_no         gicl_claims.clm_seq_no%TYPE,
      pol_iss_cd         gicl_claims.pol_iss_cd%TYPE,
      issue_yy           gicl_claims.issue_yy%TYPE,
      pol_seq_no         gicl_claims.pol_seq_no%TYPE,
      renew_no           gicl_claims.renew_no%TYPE,
      assured_name       gicl_claims.assured_name%TYPE,
      assd_name2         gicl_claims.assd_name2%TYPE,
      clm_stat_cd        gicl_claims.clm_stat_cd%TYPE,
      in_hou_adj         gicl_claims.in_hou_adj%TYPE,
      remarks            gicl_claims.remarks%TYPE,
      plate_no           gicl_claims.plate_no%TYPE,
      assd_no            gicl_claims.assd_no%TYPE,
      user_id            gicl_claims.user_id%TYPE,
      claim_no           VARCHAR2 (100),
      policy_no          VARCHAR2 (100),
      assd_name          VARCHAR2 (1000),
      claim_status       VARCHAR2 (30),
      reassign_clm_chk   VARCHAR2 (1)
   );

   TYPE claim_details_tab IS TABLE OF claim_details_type;

   TYPE user_info_type IS RECORD (
      user_id     giis_users.user_id%TYPE,
      user_name   giis_users.user_name%TYPE
   );

   TYPE user_info_tab IS TABLE OF user_info_type;

   FUNCTION get_claim_details (
      p_line_cd       gicl_claims.line_cd%TYPE,
      p_all_user_sw   giis_users.all_user_sw%TYPE,
      p_user_id       giis_users.user_id%TYPE
   )
      RETURN claim_details_tab PIPELINED;

   FUNCTION get_user_info
      RETURN user_info_tab PIPELINED;

   PROCEDURE update_claim_record (p_update_claim gicl_claims%ROWTYPE);

   FUNCTION get_user_lov (
      p_line_cd   gicl_claims.line_cd%TYPE,
      p_iss_cd    gicl_claims.iss_cd%TYPE
   )
      RETURN user_info_tab PIPELINED;

   FUNCTION reassign_processor_validation (p_user_id giis_users.user_id%TYPE)
      RETURN VARCHAR2;
      
END GICLS044_PKG;
/


