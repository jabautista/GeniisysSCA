CREATE OR REPLACE PACKAGE CPI.GIPIR924A_PKG
AS

   TYPE report_type IS RECORD (
   	  assd_name				   /*GIPI_UWREPORTS_INTM_EXT.assd_name%TYPE */ VARCHAR2(2000) ,  -- jhing replaced with varchar2 FGICWEB 17728. field will display assdno and name
      assd_no                GIPI_UWREPORTS_INTM_EXT.assd_no%TYPE , -- jhing 08.19.2015  FGICWEB 17728
      main_assd_name GIPI_UWREPORTS_INTM_EXT.assd_name%TYPE , -- jhing 08.19.2015  FGICWEB 17728
	  line_cd                  GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
	  line_name                GIPI_UWREPORTS_INTM_EXT.line_name%TYPE,
	  subline_cd               GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
	  subline_name             GIPI_UWREPORTS_INTM_EXT.subline_name%TYPE,
	  iss_cd                   GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
	  total_tsi                GIPI_UWREPORTS_INTM_EXT.total_tsi%TYPE,
	  total_prem               GIPI_UWREPORTS_INTM_EXT.total_prem%TYPE,
	  evatprem                 GIPI_UWREPORTS_INTM_EXT.evatprem%TYPE,
	  fst                      GIPI_UWREPORTS_INTM_EXT.fst%TYPE,
      lgt                      GIPI_UWREPORTS_INTM_EXT.lgt%TYPE,
      doc_stamps               GIPI_UWREPORTS_INTM_EXT.doc_stamps%TYPE,
	  other_taxes              GIPI_UWREPORTS_INTM_EXT.other_taxes%TYPE, 
	  other_charges			   GIPI_UWREPORTS_INTM_EXT.other_taxes%TYPE,
	  total_charges            NUMBER,  
      pol_count                NUMBER,
	  cf_iss_header			   VARCHAR2(20),
	  cf_iss_name			   VARCHAR2(60)
   );

   TYPE report_tab IS TABLE OF report_type;

   TYPE header_type IS RECORD (
      cf_company           VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_heading3          VARCHAR2 (150),
      cf_based_on          VARCHAR2 (100)
   );

   TYPE header_tab IS TABLE OF header_type;	
   
   FUNCTION get_header_gipr924A (
      p_scope     gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id   gipi_uwreports_ext.user_id%TYPE
   )
      RETURN header_tab PIPELINED;
	  
	FUNCTION cf_companyformula
      RETURN CHAR;
	  
	FUNCTION cf_company_addressformula
      RETURN CHAR;
	
   FUNCTION cf_heading3formula (p_user_id gipi_uwreports_ext.user_id%TYPE)
      RETURN CHAR;

    FUNCTION cf_based_onformula (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN CHAR;
	  	  		  
	  FUNCTION populate_gipir924A (
      p_iss_param    GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
      p_iss_cd       GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
      p_scope        GIPI_UWREPORTS_INTM_EXT.SCOPE%TYPE,
      p_line_cd      GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
      p_subline_cd   GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
	  p_assd_no		 GIPI_UWREPORTS_INTM_EXT.assd_no%TYPE,
	  p_intm_no		 GIPI_UWREPORTS_INTM_EXT.intm_no%TYPE,
      p_user_id      GIPI_UWREPORTS_INTM_EXT.user_id%TYPE
   )
      RETURN report_tab PIPELINED;
	  
	FUNCTION CF_ISS_HEADERFormula(p_iss_param    GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE) 
	   RETURN CHAR;
	   
	FUNCTION cf_iss_nameformula(i_iss_cd		GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE) 
   		RETURN CHAR ;
	FUNCTION check_unique_policy(pol_id_i GIPI_UWREPORTS_INTM_EXT.policy_id%TYPE,pol_id_j GIPI_UWREPORTS_INTM_EXT.policy_id%TYPE) 
        RETURN CHAR;
END gipir924A_pkg;
/