CREATE OR REPLACE PACKAGE CPI.gipir924f_pkg
AS
   TYPE report_type IS RECORD (
      iss_cd               gipi_uwreports_ext.iss_cd%TYPE,
      iss_cd_header        gipi_uwreports_ext.iss_cd%TYPE,
      cf_iss_name          VARCHAR2 (999),
      cf_iss_title         VARCHAR2 (999),
      line_cd              gipi_uwreports_ext.line_cd%TYPE,
      cf_line_name         VARCHAR2 (999),
      commission           NUMBER (20, 2),
      total_taxes          NUMBER (20, 2),
      pol_count            NUMBER (20, 2),
      total                NUMBER (20, 2),
      subline_cd           gipi_uwreports_ext.subline_cd%TYPE,
      total_si             NUMBER (20, 2),
      total_prem           NUMBER (20, 2),
      cf_subline_name      VARCHAR2 (999),
      cf_new_comm          NUMBER (20, 2),
      cf_heading3          VARCHAR2 (999),
      cf_company           VARCHAR2 (999),
      cf_based_on          VARCHAR2 (999),
      cf_company_address   VARCHAR2 (999),
      evatprem             NUMBER (20, 2),
      lgt                  NUMBER (20, 2),
      doc_stamps           NUMBER (20, 2),
      fst                  NUMBER (20, 2),
      other_taxes          NUMBER (20, 2),
      other_charges        NUMBER (20, 2),
      user_id              gipi_uwreports_ext.user_id%TYPE, 
      scope                gipi_uwreports_ext.scope%TYPE,
      param_v              VARCHAR2 (999)  
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION populate_gipir924f (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN report_tab PIPELINED;

  FUNCTION cf_company (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN CHAR;

   FUNCTION cf_company_address (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN CHAR;

   FUNCTION cf_heading3 (p_user_id gipi_uwreports_ext.user_id%TYPE)
      RETURN CHAR;

   FUNCTION cf_based_on (p_user_id gipi_uwreports_ext.user_id%TYPE)
      RETURN CHAR;

   FUNCTION cf_iss_name (p_iss_cd gipi_uwreports_ext.iss_cd%TYPE)
      RETURN CHAR;

   FUNCTION cf_iss_title (p_iss_param gipi_uwreports_ext.iss_cd%TYPE)
      RETURN CHAR;

   FUNCTION cf_line_name (p_line_cd giis_line.line_cd%TYPE)
      RETURN CHAR;

   FUNCTION cf_subline_name (
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_line_cd      giis_subline.line_cd%TYPE
   )
      RETURN CHAR;
      
   FUNCTION cf_new_comm (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN NUMBER;
      
END gipir924f_pkg;
/


