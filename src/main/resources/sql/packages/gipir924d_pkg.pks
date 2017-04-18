CREATE OR REPLACE PACKAGE CPI.GIPIR924D_PKG
AS
	   TYPE report_type IS RECORD (
	   	--dist_flag					giuw_pol_dist.dist_flag%TYPE,
      	rv_meaning					cg_ref_codes.rv_meaning%TYPE,
		line_name					giis_line.line_name%TYPE,
		subline_name				giis_subline.subline_name%TYPE,
   		Policy_Endorsement			VARCHAR(50),
   		issue_date					gipi_polbasic.issue_date%TYPE,
  		incept_date					gipi_polbasic.incept_date%TYPE,	
		assd_name					giis_assured.assd_name%TYPE,
  		tsi_amt						gipi_polbasic.tsi_amt%TYPE,	
 		prem_amt					gipi_polbasic.tsi_amt%TYPE,
 		iss_cd						gipi_polbasic.iss_cd%TYPE,
		cf_iss_name					VARCHAR(50)
   );

   TYPE report_tab IS TABLE OF report_type;

   TYPE header_type IS RECORD (
      cf_company           VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_heading3          VARCHAR2 (150)
   );

   TYPE header_tab IS TABLE OF header_type;	
   
   FUNCTION get_header_gipr924D
      RETURN header_tab PIPELINED;
	  
	FUNCTION cf_companyformula
      RETURN CHAR;
	  
	FUNCTION cf_company_addressformula
      RETURN CHAR;
	
	 FUNCTION populate_gipir924D (
      p_iss_param    gipi_polbasic.iss_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
	  p_direct		 NUMBER,
	  p_ri		 	 NUMBER,
	  p_user_id      GIIS_USERS.user_id%TYPE --added by robert 01.02.2014
   )
      RETURN report_tab PIPELINED;
	  
	  FUNCTION cf_iss_nameformula( 
		p_iss_param    gipi_polbasic.iss_cd%TYPE,
		i_iss_cd       giis_issource.iss_cd%TYPE
		)
   		RETURN CHAR;
	  
END gipir924D_pkg;
/


