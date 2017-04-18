CREATE OR REPLACE PACKAGE BODY CPI.Giis_Type_Of_Body_Pkg AS

  FUNCTION get_type_of_body_list RETURN type_of_body_list_tab PIPELINED  IS

	v_type_of_body         type_of_body_list_type;

  BEGIN

    FOR i IN (
      SELECT type_of_body_cd, type_of_body
        FROM GIIS_TYPE_OF_BODY )
    LOOP
	  v_type_of_body.type_of_body_cd  := i.type_of_body_cd;
	  v_type_of_body.type_of_body     := i.type_of_body;
      PIPE ROW (v_type_of_body);
    END LOOP;

	RETURN;
  END get_type_of_body_list;

  FUNCTION get_gipir915_type_of_body (
  	 p_policy_id		gipi_vehicle.policy_id%TYPE,
	 p_item_no			gipi_vehicle.item_no%TYPE
  ) RETURN type_of_body_list_tab PIPELINED
  IS
  	v_gipir915_type_of_body			type_of_body_list_type;
  BEGIN
  	   FOR i IN (SELECT  distinct a.type_of_body_cd, a.type_of_body  body
	   	   	 	   FROM GIIS_TYPE_OF_BODY a , GIPI_VEHICLE   b
                  WHERE a.TYPE_of_body_cd = b.TYPE_of_body_cd
                    AND b.policy_id = p_policy_id
                    AND b.item_no = p_item_no
	            )

	   LOOP
	   	   v_gipir915_type_of_body.type_of_body_cd := i.type_of_body_cd;
		   v_gipir915_type_of_body.type_of_body	   := i.body;
		   PIPE ROW(v_gipir915_type_of_body);
	   END LOOP;
  END;
END Giis_Type_Of_Body_Pkg;
/


