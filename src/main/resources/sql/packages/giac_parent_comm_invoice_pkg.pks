CREATE OR REPLACE PACKAGE CPI.GIAC_PARENT_COMM_INVOICE_PKG
AS
  TYPE issue_source_type IS RECORD (
  	   iss_cd	   	  GIIS_ISSOURCE.iss_cd%TYPE,
	   iss_name		  GIIS_ISSOURCE.iss_name%TYPE
  );
  
  TYPE issue_source_tab IS TABLE OF issue_source_type;
  
  TYPE intermediary_listing_type IS RECORD (
  	   intm_no		  GIIS_INTERMEDIARY.intm_no%TYPE,
	   intm_name	  GIIS_INTERMEDIARY.intm_name%TYPE
  );
  
  TYPE intermediary_listing_tab IS TABLE OF intermediary_listing_type;
  
  PROCEDURE get_parent_child_intm_name(p_intm_no	  		IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								  p_chld_intm_no	IN     GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								  p_iss_cd			IN	   GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
								  p_prem_seq_no		IN	   GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
								  p_intm_name		   OUT GIIS_INTERMEDIARY.intm_name%TYPE,
								  p_child_intm_name	   OUT GIIS_INTERMEDIARY.intm_name%TYPE);
								  
  PROCEDURE get_assd_policy_name (p_intm_no	  		IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								  p_chld_intm_no	IN     GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								  p_iss_cd			IN	   GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
								  p_prem_seq_no		IN	   GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
								  p_policy_no		   OUT GIIS_INTERMEDIARY.intm_name%TYPE,
								  p_assd_name	   	   OUT GIIS_INTERMEDIARY.intm_name%TYPE);
								  
  FUNCTION get_iss_cd_per_module (p_module_name		   VARCHAR2,
                                  p_user_id giis_users.user_id%TYPE)
    RETURN issue_source_tab PIPELINED;
	
  FUNCTION get_intermediary_listing(p_iss_cd		  GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  		   							p_prem_seq_no	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE)
	RETURN intermediary_listing_tab PIPELINED;
	
  FUNCTION get_child_intm_listing(p_iss_cd		  GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  		   						  p_prem_seq_no	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
								  p_intm_no		  GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
								  p_is_distinct	  VARCHAR2)
	RETURN intermediary_listing_tab PIPELINED;
  
END GIAC_PARENT_COMM_INVOICE_PKG;
/


