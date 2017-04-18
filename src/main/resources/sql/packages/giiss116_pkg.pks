CREATE OR REPLACE PACKAGE CPI.giiss116_pkg
AS
   TYPE giis_report_signatory_type IS RECORD (
      report_id      giis_signatory.report_id%TYPE,
      report_title   giis_reports.report_title%TYPE,
      iss_cd         giis_signatory.iss_cd%TYPE,
      iss_name       giis_issource.iss_name%TYPE,
      line_cd        giis_signatory.line_cd%TYPE,
      line_name      giis_line.line_name%TYPE
   );

   TYPE giis_report_signatory_tab IS TABLE OF giis_report_signatory_type;

   TYPE giis_report_signatory_dtl_type IS RECORD (
      report_id              giis_signatory.report_id%TYPE,
      iss_cd                 giis_signatory.iss_cd%TYPE,
      line_cd                giis_signatory.line_cd%TYPE,
      current_signatory_sw   giis_signatory.current_signatory_sw%TYPE,
      signatory_id           giis_signatory.signatory_id%TYPE,
      signatory              giis_signatory_names.signatory%TYPE,
      file_name              giis_signatory_names.file_name%TYPE,
      remarks                giis_signatory.remarks%TYPE,
      user_id                giis_signatory.user_id%TYPE,
      last_update            VARCHAR2(50),
      status                 giis_signatory_names.status%TYPE
   );

   TYPE giis_report_signatory_dtl_tab IS TABLE OF giis_report_signatory_dtl_type;

   TYPE giis_report_type IS RECORD (
      report_id      giis_reports.report_id%TYPE,
      report_title   giis_reports.report_title%TYPE
   );

   TYPE giis_report_tab IS TABLE OF giis_report_type;

   TYPE giis_issource_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE giis_issource_tab IS TABLE OF giis_issource_type;

   TYPE giis_line_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE giis_line_tab IS TABLE OF giis_line_type;

   TYPE giis_signatory_type IS RECORD (
      signatory_id   giis_signatory_names.signatory_id%TYPE,
      signatory      giis_signatory_names.signatory%TYPE,
      file_name      giis_signatory_names.file_name%TYPE,
      status         giis_signatory_names.status%TYPE
   );

   TYPE giis_signatory_tab IS TABLE OF giis_signatory_type;

   FUNCTION get_report_signatory (p_user_id giis_users.user_id%TYPE)
      RETURN giis_report_signatory_tab PIPELINED;

   FUNCTION get_report_signatory_details (
      p_report_id   giis_signatory.report_id%TYPE,
      p_iss_cd      giis_signatory.iss_cd%TYPE,
      p_line_cd     giis_signatory.line_cd%TYPE
   )
      RETURN giis_report_signatory_dtl_tab PIPELINED;

   FUNCTION get_report_listing
      RETURN giis_report_tab PIPELINED;

   FUNCTION get_issource_listing(p_user_id VARCHAR2, p_line_cd VARCHAR2)
      RETURN giis_issource_tab PIPELINED;

   FUNCTION get_line_listing(p_user_id VARCHAR2, p_iss_cd VARCHAR2)
      RETURN giis_line_tab PIPELINED;

   FUNCTION get_signatory_listing
      RETURN giis_signatory_tab PIPELINED;

   PROCEDURE val_signatory_report (
      p_report_id   IN       giis_signatory.report_id%TYPE,
      p_iss_cd      IN       giis_signatory.iss_cd%TYPE,
      p_line_cd     IN       giis_signatory.line_cd%TYPE,
      RESULT        OUT      NUMBER
   );

   PROCEDURE set_giis_signatory (p_signatory giis_report_signatory_dtl_type);

   PROCEDURE delete_giis_signatory (
      p_report_id      giis_signatory.report_id%TYPE,
      p_iss_cd         giis_signatory.iss_cd%TYPE,
      p_line_cd        giis_signatory.line_cd%TYPE,
      p_signatory_id   giis_signatory.signatory_id%TYPE
   );

   PROCEDURE set_signatory_file_name (
      p_signatory_id   giis_signatory_names.signatory_id%TYPE,
      p_file_name      giis_signatory_names.file_name%TYPE
   );

   FUNCTION get_report_signatory2 (p_user_id giis_users.user_id%TYPE)
      RETURN giis_report_signatory_tab PIPELINED;
      
   FUNCTION get_used_signatories (
      p_report_id VARCHAR2,
      p_iss_cd VARCHAR2,
      p_line_cd VARCHAR2
   ) RETURN VARCHAR2;      
      
END giiss116_pkg;
/


