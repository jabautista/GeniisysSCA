CREATE OR REPLACE PACKAGE CPI.giis_banc_type_pkg
AS

    TYPE giis_banc_type_type IS RECORD(
        banc_type_cd        giis_banc_type.banc_type_cd%TYPE,
        banc_type_desc      giis_banc_type.banc_type_desc%TYPE,
        rate                giis_banc_type.rate%TYPE,
        user_id             giis_banc_type.user_id%TYPE,
        last_update         giis_banc_type.last_update%TYPE
        );

    TYPE giis_banc_type_tab IS TABLE OF giis_banc_type_type;

	TYPE giis_banc_type_cur IS REF CURSOR RETURN giis_banc_type_type;

    FUNCTION get_giis_banc_type_list
    RETURN giis_banc_type_tab PIPELINED;

	FUNCTION get_giis_banc_type(p_par_id		GIPI_WPOLBAS.par_id%TYPE)
	  RETURN giis_banc_type_tab PIPELINED;

END;
/


