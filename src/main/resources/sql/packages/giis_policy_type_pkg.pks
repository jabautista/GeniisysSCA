CREATE OR REPLACE PACKAGE CPI.Giis_Policy_Type_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE:  GIPIS002 
  RECORD GROUP NAME: POLICY_TYPE  
***********************************************************************************/ 

  TYPE policy_type_list_type IS RECORD
  (type_desc		GIIS_POLICY_TYPE.type_desc%TYPE,
   type_cd			GIIS_POLICY_TYPE.type_cd%TYPE);
   
  TYPE policy_type_list_tab IS TABLE OF policy_type_list_type;
  
  FUNCTION get_policy_type_list(p_line	 GIIS_POLICY_TYPE.line_cd%TYPE) 
    RETURN policy_type_list_tab PIPELINED;

END Giis_Policy_Type_Pkg;
/


