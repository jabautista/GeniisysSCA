CREATE OR REPLACE PACKAGE CPI.giuts031_pkg
AS
   /*
   ** Created By : J. Diago
   ** Date Created : 08.08.2013
   ** Remarks : Referenced by GIUTS031 Extract Expiring Covernote
   */
   TYPE giuts031_line_lov_type IS RECORD (
      line_cd         giis_line.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE,
      pack_pol_flag   giis_line.pack_pol_flag%TYPE
   );

   TYPE giuts031_line_lov_tab IS TABLE OF giuts031_line_lov_type;

   FUNCTION get_line_lov (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN giuts031_line_lov_tab PIPELINED;

   TYPE giuts031_subline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE giuts031_subline_lov_tab IS TABLE OF giuts031_subline_lov_type;

   FUNCTION get_subline_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN giuts031_subline_lov_tab PIPELINED;

   TYPE giuts031_newforminstance_type IS RECORD (
      iss_cd   giis_issource.iss_cd%TYPE
   );

   TYPE giuts031_newforminstance_tab IS TABLE OF giuts031_newforminstance_type;

   FUNCTION when_new_form_instance (p_user_id giis_users.user_id%TYPE)
      RETURN giuts031_newforminstance_tab PIPELINED;

   TYPE giuts031_issue_lov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE giuts031_issue_lov_tab IS TABLE OF giuts031_issue_lov_type;

   FUNCTION get_issue_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN giuts031_issue_lov_tab PIPELINED;

   PROCEDURE extract_giuts031 (
      p_user_id             IN       giis_users.user_id%TYPE,
      p_param_type          IN       VARCHAR2,
      p_from_date           IN       DATE,
      p_to_date             IN       DATE,
      p_from_month          IN       VARCHAR2,
      p_from_year           IN       VARCHAR2,
      p_to_month            IN       VARCHAR2,
      p_to_year             IN       VARCHAR2,
      p_line_cd             IN       giis_line.line_cd%TYPE,
      p_subline_cd          IN       giis_subline.subline_cd%TYPE,
      p_iss_cd              IN       giis_issource.iss_cd%TYPE,
      p_cred_branch_param   IN       VARCHAR2,
      p_exists              OUT      NUMBER,
      p_from                OUT      VARCHAR2,
      p_to                  OUT      VARCHAR2
   );

   TYPE validate_extract_params_type IS RECORD (
      p_user_id             giis_users.user_id%TYPE,
      p_param_type          VARCHAR2 (1),
      p_from_date           VARCHAR2 (20),
      p_to_date             VARCHAR2 (20),
      p_from_month          VARCHAR2 (20),
      p_from_year           VARCHAR2 (4),
      p_to_month            VARCHAR2 (20),
      p_to_year             VARCHAR2 (4),
      p_line_cd             giis_line.line_cd%TYPE,
      p_line_name           giis_line.line_name%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_subline_name        giis_subline.subline_name%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_iss_name            giis_issource.iss_name%TYPE,
      p_cred_branch_param   VARCHAR2 (1),
      p_from                VARCHAR2 (20),
      p_to                  VARCHAR2 (20)
   );

   TYPE validate_extract_params_tab IS TABLE OF validate_extract_params_type;

   FUNCTION validate_extract_params (p_user_id VARCHAR2)
      RETURN validate_extract_params_tab PIPELINED;
END;
/


