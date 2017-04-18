CREATE OR REPLACE PACKAGE CPI.gipir198_pkg
AS
   TYPE gipir198_dtls_type IS RECORD (
      company_name         VARCHAR2 (500),
      company_address      VARCHAR2 (500),
      report_desc          VARCHAR2 (500),
      report_date_period   VARCHAR2 (500),
      line_cd              gixx_covernote_exp.line_cd%TYPE,
      line_name            giis_line.line_name%TYPE,
      cf_line_name         VARCHAR2 (50),
      par_number           VARCHAR2 (50),
      assd_name            giis_assured.assd_name%TYPE,
      incept_date          VARCHAR2 (50),
      expiry_date          VARCHAR2 (50),
      covernote_expiry     VARCHAR2 (50),
      tsi_amt              gixx_covernote_exp.tsi_amt%TYPE,
      prem_amt             gixx_covernote_exp.prem_amt%TYPE
   );

   TYPE gipir198_dtls_tab IS TABLE OF gipir198_dtls_type;

   FUNCTION get_gipir198_dtls (
      p_starting_date   DATE,
      p_ending_date     DATE,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN gipir198_dtls_tab PIPELINED;

   FUNCTION company_nameformula
      RETURN VARCHAR2;

   FUNCTION company_addressformula
      RETURN VARCHAR2;
END;
/


