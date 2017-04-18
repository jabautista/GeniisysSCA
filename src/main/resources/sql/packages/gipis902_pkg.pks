CREATE OR REPLACE PACKAGE CPI.gipis902_pkg
AS
   TYPE gipi_risk_loss_profile_type IS RECORD (
      line_cd          giis_line.line_cd%TYPE,
      line_name        giis_line.line_name%TYPE,
      subline_cd       giis_subline.subline_cd%TYPE,
      subline_name     giis_subline.subline_name%TYPE,
      cred_branch      gipi_risk_loss_profile.cred_branch%TYPE,
      iss_name         giis_issource.iss_name%TYPE,
      date_from        VARCHAR2 (50),
      date_to          VARCHAR2 (50),
      loss_date_from   VARCHAR2 (50),
      loss_date_to     VARCHAR2 (50),
      all_line_tag     gipi_risk_loss_profile.all_line_tag%TYPE,
      no_of_range      NUMBER
   );

   TYPE gipi_risk_loss_profile_tab IS TABLE OF gipi_risk_loss_profile_type;

   FUNCTION get_gipi_risk_loss_profile (p_user_id VARCHAR2)
      RETURN gipi_risk_loss_profile_tab PIPELINED;

   TYPE risk_loss_profile_range_type IS RECORD (
      range_from   gipi_risk_loss_profile.range_from%TYPE,
      range_to     gipi_risk_loss_profile.range_to%TYPE
   );

   TYPE risk_loss_profile_range_tab IS TABLE OF risk_loss_profile_range_type;

   FUNCTION get_risk_loss_profile_range (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN risk_loss_profile_range_tab PIPELINED;

   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   FUNCTION get_line_lov (p_user_id VARCHAR2)
      RETURN line_lov_tab PIPELINED;

   TYPE subline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE,
      line_cd        giis_line.line_cd%TYPE,
      line_name      giis_line.line_name%TYPE
   );

   TYPE subline_lov_tab IS TABLE OF subline_lov_type;

   FUNCTION get_subline_lov (p_user_id VARCHAR2, p_line_cd VARCHAR2)
      RETURN subline_lov_tab PIPELINED;

   TYPE iss_lov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE iss_lov_tab IS TABLE OF iss_lov_type;

   FUNCTION get_iss_lov (p_user_id VARCHAR2)
      RETURN iss_lov_tab PIPELINED;

   PROCEDURE DELETE (
      p_line_cd        VARCHAR2,
      p_subline_cd     VARCHAR2,
      p_all_line_tag   VARCHAR2,
      p_type           VARCHAR2,
      p_user_id        VARCHAR2
   );

   PROCEDURE update_profile (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_all_line_tag     VARCHAR2,
      p_cred_branch      VARCHAR2
   );

   PROCEDURE save_profile (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_range_from       VARCHAR2,
      p_range_to         VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_all_line_tag     VARCHAR2,
      p_cred_branch      VARCHAR2
   );

--   PROCEDURE update_gicl_loss_profile (
--      p_line_cd         VARCHAR2,
--      p_date_from       VARCHAR2,
--      p_date_to         VARCHAR2,
--      p_loss_date_from  VARCHAR2,
--      p_loss_date_to    VARCHAR2
--   );
   PROCEDURE loss_profile_extract_loss_amt (
      p_pol_sw           VARCHAR2,
      p_loss_sw          VARCHAR2,
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_date_to          VARCHAR2,
      p_date_from        VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_all_line_tag     VARCHAR2,
      p_user_id          VARCHAR2
   );
END;
/


