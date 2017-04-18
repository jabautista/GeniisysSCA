CREATE OR REPLACE PACKAGE CPI.GIIS_DOCUMENT_PKG AS

  FUNCTION get_doc_text(p_title     GIIS_DOCUMENT.title%TYPE)
    RETURN VARCHAR2;
	
  FUNCTION check_print_premium_details(
    p_line_cd       GIIS_DOCUMENT.line_cd%TYPE
  )
    RETURN VARCHAR2;
	
  FUNCTION get_doc_text2(
    p_line_cd       GIIS_DOCUMENT.line_cd%TYPE,
    p_report_id     GIIS_DOCUMENT.report_id%TYPE,
    p_title         GIIS_DOCUMENT.title%TYPE
  )
    RETURN VARCHAR2;

END GIIS_DOCUMENT_PKG;
/


