CREATE OR REPLACE PACKAGE CPI.Giis_Type_Of_Body_Pkg AS

  TYPE type_of_body_list_type IS RECORD
    (type_of_body_cd           GIIS_TYPE_OF_BODY.type_of_body_cd%TYPE,
     type_of_body			   GIIS_TYPE_OF_BODY.type_of_body%TYPE);
  
  TYPE type_of_body_list_tab IS TABLE OF type_of_body_list_type; 
        
  FUNCTION get_type_of_body_list RETURN type_of_body_list_tab PIPELINED;

  FUNCTION get_gipir915_type_of_body (
  	 p_policy_id		gipi_vehicle.policy_id%TYPE,
	 p_item_no			gipi_vehicle.item_no%TYPE
  ) RETURN type_of_body_list_tab PIPELINED;
END Giis_Type_Of_Body_Pkg;
/


