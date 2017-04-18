CREATE OR REPLACE PACKAGE CPI.GIAC_WHOLDING_TAXES_PKG
AS

  TYPE whtax_code_type IS RECORD(
  	   gibr_branch_cd  	  		 					  GIAC_WHOLDING_TAXES.gibr_branch_cd%TYPE,
	   whtax_code									  GIAC_WHOLDING_TAXES.whtax_code%TYPE,
	   bir_tax_cd									  GIAC_WHOLDING_TAXES.bir_tax_cd%TYPE,
	   percent_rate									  GIAC_WHOLDING_TAXES.percent_rate%TYPE,
	   whtax_desc									  GIAC_WHOLDING_TAXES.whtax_desc%TYPE,
	   whtax_id										  GIAC_WHOLDING_TAXES.whtax_id%TYPE
  );
  
  TYPE whtax_code_tab IS TABLE OF whtax_code_type;
  
  FUNCTION get_whtax_code_listing (p_gacc_branch_cd	  GIAC_WHOLDING_TAXES.gibr_branch_cd%TYPE)
    RETURN whtax_code_tab PIPELINED;
	
  PROCEDURE check_whtax_code_fk(  p_whtax_code				IN     GIAC_WHOLDING_TAXES.whtax_code%TYPE,
			  					  p_bir_tax_cd				IN	   GIAC_WHOLDING_TAXES.bir_tax_cd%TYPE,
								  p_percent_rate			IN	   GIAC_WHOLDING_TAXES.percent_rate%TYPE,
								  p_whtax_desc				IN	   GIAC_WHOLDING_TAXES.whtax_desc%TYPE,
								  p_field_level				IN	   BOOLEAN,
								  p_whtax_id				   OUT GIAC_WHOLDING_TAXES.whtax_id%TYPE,
								  p_message				       OUT VARCHAR2);
	
  PROCEDURE validate_giacs022_whtax_code(  p_whtax_code				IN     GIAC_WHOLDING_TAXES.whtax_code%TYPE,
			  							   p_bir_tax_cd				IN	   GIAC_WHOLDING_TAXES.bir_tax_cd%TYPE,
										   p_percent_rate			IN	   GIAC_WHOLDING_TAXES.percent_rate%TYPE,
										   p_whtax_desc				IN	   GIAC_WHOLDING_TAXES.whtax_desc%TYPE,
										   p_whtax_id				   OUT GIAC_WHOLDING_TAXES.whtax_id%TYPE,
										   p_sl_required			   OUT VARCHAR2,
										   p_message				   OUT VARCHAR2);

END GIAC_WHOLDING_TAXES_PKG;
/


