CREATE OR REPLACE PACKAGE CPI.giiss119_pkg
AS
   TYPE giis_report_parameter_type IS RECORD (
      title           giis_document.title%TYPE,
      text            giis_document.text%TYPE,
      line_cd         giis_document.line_cd%TYPE,
      remarks         giis_document.remarks%TYPE,
      user_id         giis_document.user_id%TYPE,
      last_update     VARCHAR2 (200),
      report_id       giis_document.report_id%TYPE,
      cpi_branch_cd   giis_document.cpi_branch_cd%TYPE,
      cpi_rec_no      giis_document.cpi_rec_no%TYPE
   );

   TYPE giis_report_parameter_tab IS TABLE OF giis_report_parameter_type;

   FUNCTION get_report_parameter_list
      RETURN giis_report_parameter_tab PIPELINED;

   PROCEDURE set_report_parameter (
      p_title           giis_document.title%TYPE,
      p_text            giis_document.text%TYPE,
      p_line_cd         giis_document.line_cd%TYPE,
      p_remarks         giis_document.remarks%TYPE,
      p_report_id       giis_document.report_id%TYPE,
      p_cpi_branch_cd   giis_document.cpi_branch_cd%TYPE,
      p_cpi_rec_no      giis_document.cpi_rec_no%TYPE
   );

   PROCEDURE delete_report_parameter (
      p_title       giis_document.title%TYPE,
      p_report_id   giis_document.report_id%TYPE
   );
END giiss119_pkg;
/


