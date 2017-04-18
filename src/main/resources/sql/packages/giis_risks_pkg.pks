CREATE OR REPLACE PACKAGE CPI.Giis_Risks_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: RISKS_RG 
***********************************************************************************/ 

  TYPE risk_list_type IS RECORD
    (risk_cd	GIIS_RISKS.risk_cd%TYPE,
	 risk_desc	GIIS_RISKS.risk_desc%TYPE);

  TYPE risk_list_tab IS TABLE OF risk_list_type;
  
  TYPE all_risk_list_type IS RECORD
    (risk_cd	GIIS_RISKS.risk_cd%TYPE,
	 risk_desc	GIIS_RISKS.risk_desc%TYPE,
	 block_id	GIIS_RISKS.block_id%TYPE);

  TYPE all_risk_list_tab IS TABLE OF all_risk_list_type; 
	 
  FUNCTION get_risk_list(p_block_id GIIS_RISKS.block_id%TYPE)
    RETURN risk_list_tab PIPELINED;
	
  FUNCTION get_all_risk_list
    RETURN all_risk_list_tab PIPELINED;
	
	FUNCTION get_risk_desc(
        p_block_id IN giis_risks.block_id%TYPE,
        p_risk_cd IN giis_risks.risk_cd%TYPE)
    RETURN giis_risks.risk_desc%TYPE;

  FUNCTION get_risk_listing(p_block_id GIIS_RISKS.block_id%TYPE,
                            p_find_text VARCHAR2)
    RETURN risk_list_tab PIPELINED;

END Giis_Risks_Pkg;
/


