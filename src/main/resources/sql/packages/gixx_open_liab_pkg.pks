CREATE OR REPLACE PACKAGE CPI.GIXX_OPEN_LIAB_PKG AS

  TYPE pol_doc_openliab_type IS RECORD(
         extract_id                GIXX_OPEN_LIAB.extract_id%TYPE,
         opliab_limit_liab         VARCHAR2(20),
         opliab_limit_liab1  	   VARCHAR2(20),
         opliab_currency_cd        GIXX_OPEN_LIAB.currency_cd%TYPE,
		 opliab_voyage_limit       GIXX_OPEN_LIAB.voy_limit%TYPE,
		 opliab_geog_desc		   GIIS_GEOG_CLASS.geog_desc%TYPE,
		 opliab_geog_cd			   GIXX_OPEN_LIAB.geog_cd%TYPE,
		 f_cargo_class_desc		   VARCHAR2(1000),
		 prem_rate_exists		   VARCHAR2(1),
	     prem_rate_exists2		   VARCHAR2(1)
         );
      
  TYPE pol_doc_openliab_tab IS TABLE OF pol_doc_openliab_type;
  
  FUNCTION get_pol_doc_opliab(p_extract_id		  GIXX_OPEN_LIAB.extract_id%TYPE)
    RETURN pol_doc_openliab_tab PIPELINED;
	
  FUNCTION CF_CARGO_CLASS_DESC(p_extract_id		GIXX_OPEN_LIAB.extract_id%TYPE,
							   p_geog_cd		GIXX_OPEN_LIAB.geog_cd%TYPE) 
	RETURN VARCHAR2;
    
    
  -- added by Kris 03.11.2013 for GIPIS101
  TYPE open_liab_type IS RECORD (
    extract_id              gixx_open_liab.extract_id%TYPE,
    geog_cd                 gixx_open_liab.geog_cd%TYPE,
    voy_limit               gixx_open_liab.voy_limit%TYPE,
    currency_cd             gixx_open_liab.currency_cd%TYPE,
    currency_rt             gixx_open_liab.currency_rt%TYPE,
    limit_liability         gixx_open_liab.limit_liability%TYPE,
    with_invoice_tag        gixx_open_liab.with_invoice_tag%TYPE,
    
    geog_desc               giis_geog_class.geog_desc%TYPE,
    currency_desc           giis_currency.currency_desc%TYPE
  );
  
  TYPE open_liab_tab IS TABLE OF open_liab_type;
  
  FUNCTION get_open_liab(
    p_extract_id    gixx_open_liab.extract_id%TYPE,
    p_iss_cd        gipi_polbasic.iss_cd%TYPE,
    p_line_cd       gipi_polbasic.line_cd%TYPE,
    p_subline_cd    gipi_polbasic.subline_cd%TYPE,
    p_issue_yy      gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no      gipi_polbasic.renew_no%TYPE
  ) RETURN open_liab_tab PIPELINED;

END GIXX_OPEN_LIAB_PKG;
/


