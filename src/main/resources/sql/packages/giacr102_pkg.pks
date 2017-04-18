CREATE OR REPLACE PACKAGE CPI.giacr102_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company           VARCHAR2 (50),
      cf_com_address       VARCHAR2 (200),
      cf_run_date          VARCHAR2 (30),
      dist_flag            gipi_polbasic.dist_flag%TYPE,
      rv_meaning           cg_ref_codes.rv_meaning%TYPE,
      line_name            giis_line.line_name%TYPE,
      subline_name         giis_subline.subline_name%TYPE,
      policy_endorsement   VARCHAR2 (45),
      issue_date           gipi_polbasic.issue_date%TYPE,
      incept_date          gipi_polbasic.incept_date%TYPE,
      assd_name            giis_assured.assd_name%TYPE,
      tsi_amt              gipi_polbasic.tsi_amt%TYPE,
      prem_amt             gipi_polbasic.prem_amt%TYPE
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details(
      p_line_cd            VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   )
      RETURN get_details_tab PIPELINED;
END;
/
