CREATE OR REPLACE PACKAGE BODY CPI.giis_banc_type_pkg
AS
    /*
    **  Created by   :  Jerome Orio
    **  Date Created :  11-17-2010
    **  Reference By : (GIPIS002 - Basic Information)
    **  Description  : banc_type record group
    */
    FUNCTION get_giis_banc_type_list
    RETURN giis_banc_type_tab PIPELINED IS
        v_list  giis_banc_type_type;
    BEGIN
        FOR i IN (SELECT banc_type_cd, banc_type_desc
                    FROM giis_banc_type
                ORDER BY upper(banc_type_cd))
        LOOP
            v_list.banc_type_cd     := i.banc_type_cd;
            v_list.banc_type_desc   := i.banc_type_desc;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;

	FUNCTION get_giis_banc_type(p_par_id		GIPI_WPOLBAS.par_id%TYPE)
	  RETURN giis_banc_type_tab PIPELINED
	IS
	  v_banc_type				giis_banc_type_type;
	BEGIN
	  FOR i IN (SELECT banc_type_cd, banc_type_desc, rate
				  FROM GIIS_BANC_TYPE
				 WHERE banc_type_cd IN (SELECT banc_type_cd
				  	   				      FROM GIPI_WPOLBAS
										 WHERE par_id = p_par_id)
	  ) LOOP
	  	v_banc_type.banc_type_cd		 := i.banc_type_cd;
		v_banc_type.banc_type_desc		 := i.banc_type_desc;
		v_banc_type.rate				 := i.rate;

	  	PIPE ROW(v_banc_type);
	  END LOOP;
	END get_giis_banc_type;

END;
/


