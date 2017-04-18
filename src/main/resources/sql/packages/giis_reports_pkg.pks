CREATE OR REPLACE PACKAGE CPI.GIIS_REPORTS_PKG AS
/******************************************************************************
   NAME:       GIIS_REPORTS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/11/2010   Whofeih          1. Created this package.
******************************************************************************/

  TYPE giis_reports_type IS RECORD (
    report_id             GIIS_REPORTS.REPORT_ID%TYPE,
    report_title         GIIS_REPORTS.REPORT_TITLE%TYPE,
    line_cd              GIIS_REPORTS.LINE_CD%TYPE,
    version                 GIIS_REPORTS.VERSION%TYPE
  ); 
  
  TYPE giis_reports_tab IS TABLE OF giis_reports_type;
  
  TYPE giexs006_reports_type IS RECORD (
    report_id            GIIS_REPORTS.REPORT_ID%TYPE,
    report_title         GIIS_REPORTS.REPORT_TITLE%TYPE    
  );
  
  TYPE giexs006_reports_tab IS TABLE OF giexs006_reports_type;
  
  FUNCTION get_report_version(p_report_id VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION get_report_version(p_report_id GIIS_REPORTS.report_id%TYPE,
                              p_line_cd   GIIS_REPORTS.line_cd%TYPE) 
    RETURN VARCHAR2;
  
  FUNCTION get_reports_per_line_cd(p_line_cd         GIIS_REPORTS.line_cd%TYPE)
    RETURN giis_reports_tab PIPELINED;
    
  FUNCTION get_reports_listing
    RETURN giis_reports_tab PIPELINED;
    
    function get_report_desname(p_report_id varchar2) return varchar2;

  FUNCTION get_reports_listing2(p_line_cd GIIS_REPORTS.line_cd%TYPE)
    RETURN giis_reports_tab PIPELINED;
    
  FUNCTION get_report_desname2 (p_report_id VARCHAR2)
  RETURN VARCHAR2;
  
  FUNCTION get_giexs006_reports (p_report_title GIIS_REPORTS.REPORT_TITLE%TYPE)
    RETURN giexs006_reports_tab PIPELINED;

END GIIS_REPORTS_PKG;
/


