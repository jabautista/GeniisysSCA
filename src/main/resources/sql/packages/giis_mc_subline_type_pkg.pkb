CREATE OR REPLACE PACKAGE BODY CPI.Giis_Mc_Subline_Type_Pkg AS

  FUNCTION get_sublinetype_list (p_subline    GIIS_SUBLINE.subline_cd%TYPE)
    RETURN sublinetype_list_tab PIPELINED  IS

	v_sublinetype      sublinetype_list_type;

  BEGIN

    FOR i IN (
      SELECT subline_type_cd, subline_type_desc
        FROM GIIS_MC_SUBLINE_TYPE
       WHERE subline_cd = p_subline)
    LOOP
	  v_sublinetype.subline_type_cd    := i.subline_type_cd;
	  v_sublinetype.subline_type_desc  := i.subline_type_desc;
      PIPE ROW (v_sublinetype);
    END LOOP;

	RETURN;
  END get_sublinetype_list;


  FUNCTION get_all_sublinetype_list
    RETURN sublinetype_list_tab PIPELINED  IS

	v_sublinetype      sublinetype_list_type;

  BEGIN

    FOR i IN (
      SELECT subline_cd, subline_type_cd, subline_type_desc
        FROM GIIS_MC_SUBLINE_TYPE)
    LOOP
      v_sublinetype.subline_cd         := i.subline_cd;
	  v_sublinetype.subline_type_cd    := i.subline_type_cd;
	  v_sublinetype.subline_type_desc  := i.subline_type_desc;
      PIPE ROW (v_sublinetype);
    END LOOP;

	RETURN;
  END get_all_sublinetype_list;

END Giis_Mc_Subline_Type_Pkg;
/


