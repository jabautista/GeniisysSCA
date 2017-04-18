CREATE OR REPLACE PACKAGE CPI.GIPIR924J_PKG
AS
	 TYPE report_type IS RECORD (
	  line_cd              gipi_uwreports_ext.line_cd%TYPE,
	  subline_cd           gipi_uwreports_ext.subline_cd%TYPE,
      iss_cd               gipi_uwreports_ext.iss_cd%TYPE,
	  total_si             NUMBER (20, 2),
	  total_prem           NUMBER (20, 2),
	  evatprem             NUMBER (20, 2),
      fst                  NUMBER (20, 2),
	  lgt                  NUMBER (20, 2),
	  doc_stamps           NUMBER (20, 2),
	  other_taxes          NUMBER (20, 2),
	  other_charges        NUMBER (20, 2),
	  total                NUMBER (20, 2),
	  pol_count            NUMBER (20, 2),
	  total_taxes          NUMBER (20, 2),
	  cf_iss_name          VARCHAR2(200),
	  cf_iss_title         VARCHAR2 (30),
      cf_line_name         giis_line.line_name%TYPE,
	  cf_subline_name      giis_subline.subline_name%TYPE,
	  cf_heading3          VARCHAR2 (150),
	  cf_company 		   VARCHAR2 (150),
	  cf_based_on          VARCHAR2 (200),
	  cf_company_address   VARCHAR2 (500),
	  param_v		   	   VARCHAR2 (1)
   );

   TYPE report_tab IS TABLE OF report_type;
   
    FUNCTION populate_gipir924j (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    VARCHAR2,
	  p_scope     gipi_uwreports_ext.SCOPE%TYPE,
	  p_user_id gipi_uwreports_ext.user_id%TYPE)
      RETURN report_tab PIPELINED;
	
END;
/


