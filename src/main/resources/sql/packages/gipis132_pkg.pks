CREATE OR REPLACE PACKAGE CPI.gipis132_pkg
AS
   TYPE gipis132_type IS RECORD (
      policy_id          gipi_polbasic.policy_id%TYPE,
      par_id             gipi_polbasic.par_id%TYPE,
      line_cd            gipi_polbasic.line_cd%TYPE,
      subline_cd         gipi_polbasic.subline_cd%TYPE,
      iss_cd             gipi_polbasic.iss_cd%TYPE,
      issue_yy           gipi_polbasic.issue_yy%TYPE,
      pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      renew_no           gipi_polbasic.renew_no%TYPE,
      endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy            gipi_polbasic.endt_yy%TYPE,
      endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      user_id            gipi_polbasic.user_id%TYPE,
      assd_name          VARCHAR2 (525),--changed from 500 to 525 reymon 05022013
      mean_pol_flag      VARCHAR2 (100),
      cred_branch        gipi_polbasic.cred_branch%TYPE,
      cred_branch_name   giis_issource.iss_name%TYPE,
      incept_date        gipi_polbasic.incept_date%TYPE,
      expiry_date        gipi_polbasic.expiry_date%TYPE,
      eff_date           gipi_polbasic.eff_date%TYPE,
      issue_date         gipi_polbasic.issue_date%TYPE
   );

   TYPE gipis132_tab IS TABLE OF gipis132_type;

   FUNCTION get_policy_status (
      p_user_id       VARCHAR2,
      p_pol_flag      VARCHAR2,
      p_dist_flag     VARCHAR2,
      p_date_type     VARCHAR2,
      p_as_of_date    VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_issue_yy      NUMBER,
      p_pol_seq_no    NUMBER,
      p_renew_no      NUMBER,
      p_endt_iss_cd   VARCHAR2,
      p_endt_yy       NUMBER,
      p_endt_seq_no   NUMBER,
      p_assd_name     VARCHAR2,
      p_user_id2      VARCHAR2,
      p_cred_branch   VARCHAR2
   )
      RETURN gipis132_tab PIPELINED;

   FUNCTION get_user_access (
      p_line_cd       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION get_main_policy_id (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     NUMBER,
      p_pol_seq_no   NUMBER,
      p_renew_no     NUMBER
   )
      RETURN NUMBER;
END;
/


