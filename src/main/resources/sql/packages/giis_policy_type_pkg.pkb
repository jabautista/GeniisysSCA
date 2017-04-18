CREATE OR REPLACE PACKAGE BODY CPI.Giis_Policy_Type_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE:  GIPIS002
  RECORD GROUP NAME: POLICY_TYPE
***********************************************************************************/

  FUNCTION get_policy_type_list(p_line		GIIS_POLICY_TYPE.line_cd%TYPE)
    RETURN policy_type_list_tab PIPELINED IS

  v_policy_type		policy_type_list_type;

  BEGIN
  	FOR i IN (
		SELECT type_desc, type_cd
		  FROM GIIS_POLICY_TYPE
		 WHERE line_cd = p_line
         ORDER BY upper(type_desc))
	LOOP
		v_policy_type.type_desc		:= i.type_desc;
		v_policy_type.type_cd  	 	:= i.type_cd;
	  PIPE ROW(v_policy_type);
	END LOOP;

    RETURN;
  END get_policy_type_list;

END Giis_Policy_Type_Pkg;
/


