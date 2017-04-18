CREATE OR REPLACE PACKAGE CPI.GIXX_ENGG_BASIC_PKG AS

  TYPE gixx_engg_basic_type IS RECORD
  	   (construct_end_date		  GIXX_ENGG_BASIC.construct_end_date%TYPE,
	    construct_start_date	  GIXX_ENGG_BASIC.construct_start_date%TYPE,
		contract_proj_buss_title  GIXX_ENGG_BASIC.contract_proj_buss_title%TYPE,
		f_length				  VARCHAR2(4),
		mbi_policy_no	  		  GIXX_ENGG_BASIC.mbi_policy_no%TYPE,
		extract_id	  			  GIXX_ENGG_BASIC.extract_id%TYPE,
		site_location	  		  GIXX_ENGG_BASIC.site_location%TYPE,
		time_excess	  			  GIXX_ENGG_BASIC.time_excess%TYPE,
		weeks_test	  			  GIXX_ENGG_BASIC.weeks_test%TYPE,
		testing_start_date		  VARCHAR2(20),
		testing_end_date		  VARCHAR2(20),
		maintain_start_date	  	  VARCHAR2(20),
		maintain_end_date	      VARCHAR2(20));

  TYPE gixx_engg_basic_tab IS TABLE OF gixx_engg_basic_type;
  
  FUNCTION get_engg_basic_details(p_extract_id	   GIXX_ENGG_BASIC.extract_id%TYPE)
    RETURN gixx_engg_basic_tab PIPELINED;

END GIXX_ENGG_BASIC_PKG;
/


