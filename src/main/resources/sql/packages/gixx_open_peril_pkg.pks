CREATE OR REPLACE PACKAGE CPI.GIXX_OPEN_PERIL_PKG AS

  TYPE pol_doc_operil_type IS RECORD(
         extract_id                GIXX_OPEN_PERIL.extract_id%TYPE,
         operil_prem_rate          VARCHAR2(50),--GIXX_OPEN_PERIL.prem_rate%TYPE,
         operil_prem_rate2  	   VARCHAR2(50),
         operil_peril_name         GIIS_PERIL.peril_name%TYPE,
		 operil_lname			   VARCHAR2(400),
		 remarks		   		   GIXX_OPEN_PERIL.remarks%TYPE,
		 rate_remarks			   GIXX_OPEN_PERIL.remarks%TYPE
         );
      
  TYPE pol_doc_operil_tab IS TABLE OF pol_doc_operil_type;
  
  FUNCTION get_pol_doc_operil(p_extract_id   GIXX_OPEN_PERIL.extract_id%TYPE)
    RETURN pol_doc_operil_tab PIPELINED;
	
  FUNCTION prem_rate_exists(p_extract_id   GIXX_OPEN_PERIL.extract_id%TYPE) 
    RETURN VARCHAR2;
	
  FUNCTION prem_rate_exists2(p_extract_id   GIXX_OPEN_PERIL.extract_id%TYPE) 
    RETURN VARCHAR2;
        
  -- added by Kris 03.11.2013 for GIPIS101
  TYPE open_peril_type IS RECORD (
        extract_id          gixx_open_peril.extract_id%TYPE,
        geog_cd             gixx_open_peril.geog_cd%TYPE,
        line_cd             gixx_open_peril.line_cd%TYPE,
        peril_cd            gixx_open_peril.peril_cd%TYPE,
        prem_rate           gixx_open_peril.prem_rate%TYPE,
        rec_flag            gixx_open_peril.rec_flag%TYPE,
        remarks             gixx_open_peril.remarks%TYPE,
        with_invoice_tag    gixx_open_peril.with_invoice_tag%TYPE,
        policy_id           gixx_open_peril.policy_id%TYPE,
        
        peril_name          giis_peril.peril_name%TYPE,
        peril_type          giis_peril.peril_type%TYPE
  );
  
  TYPE open_peril_tab IS TABLE OF open_peril_type;
  
  FUNCTION get_open_peril_list(
        p_extract_id            gixx_open_peril.extract_id%TYPE,
        p_geog_cd               gixx_open_peril.geog_cd%TYPE
  ) RETURN open_peril_tab PIPELINED;
  -- end 03.11.2013: for GIPIS101

END GIXX_OPEN_PERIL_PKG;
/


