CREATE OR REPLACE PACKAGE CPI.giac_aging_ri_soa_details_pkg
AS
  TYPE aging_ri_soa_details_type IS RECORD (
  	  a180_ri_cd				 GIAC_AGING_RI_SOA_DETAILS.a180_ri_cd%TYPE,
	  prem_seq_no				 GIAC_AGING_RI_SOA_DETAILS.prem_seq_no%TYPE,
	  inst_no					 GIAC_AGING_RI_SOA_DETAILS.inst_no%TYPE,
	  a150_line_cd				 GIAC_AGING_RI_SOA_DETAILS.a150_line_cd%TYPE,
	  total_amount_due			 GIAC_AGING_RI_SOA_DETAILS.total_amount_due%TYPE,
	  total_payments			 GIAC_AGING_RI_SOA_DETAILS.total_payments%TYPE,
	  temp_payments				 GIAC_AGING_RI_SOA_DETAILS.temp_payments%TYPE,
	  balance_due				 GIAC_AGING_RI_SOA_DETAILS.balance_due%TYPE,
	  a020_assd_no				 GIAC_AGING_RI_SOA_DETAILS.a020_assd_no%TYPE
  );
  
  TYPE aging_ri_soa_details_tab IS TABLE OF aging_ri_soa_details_type;
  
  FUNCTION get_aging_ri_soa_details (p_keyword	   VARCHAR2)
     RETURN aging_ri_soa_details_tab PIPELINED;
	 
END giac_aging_ri_soa_details_pkg;
/


