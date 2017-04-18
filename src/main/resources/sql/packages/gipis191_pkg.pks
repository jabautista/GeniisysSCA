CREATE OR REPLACE PACKAGE CPI.GIPIS191_PKG
AS

   PROCEDURE process_policy (
      p_line_cd            gipi_polbasic.line_cd%TYPE,
      p_subline_cd         gipi_polbasic.subline_cd%TYPE,
      p_iss_cd             gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no           gipi_polbasic.renew_no%TYPE,
      p_risk_tag     OUT   gipi_polbasic.risk_tag%TYPE,
      p_tsi_amt      OUT   gipi_polbasic.tsi_amt%TYPE,
      p_prem_amt     OUT   gipi_polbasic.prem_amt%TYPE,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE extract_risk_category (
      p_from_date   IN VARCHAR2,
      p_to_date     IN VARCHAR2,
      p_basis       IN VARCHAR2,
      p_user_id     IN VARCHAR2,
      p_no_of_recs  OUT VARCHAR2
   );
   
   TYPE params_type IS RECORD (
      from_date      VARCHAR2(20),
      to_date        VARCHAR2(20),
      date_basis     gixx_risk_category.date_basis%TYPE,
      no_of_recs     NUMBER
   );
   
   TYPE params_tab IS TABLE OF params_type;
   
   FUNCTION get_params (
      p_user_id VARCHAR2
   )
      RETURN params_tab PIPELINED;
END;
/


