CREATE OR REPLACE PACKAGE CPI.giis_banc_area_pkg
AS

    TYPE giis_banc_area_type IS RECORD(
        area_cd         giis_banc_area.area_cd%TYPE,
        area_desc       giis_banc_area.area_desc%TYPE,
        eff_date        giis_banc_area.eff_date%TYPE,
        remarks         giis_banc_area.remarks%TYPE,
        user_id         giis_banc_area.user_id%TYPE,
        last_update     giis_banc_area.last_update%TYPE
        );

    TYPE giis_banc_area_tab IS TABLE OF giis_banc_area_type;

    FUNCTION get_giis_banc_area_list
    RETURN giis_banc_area_tab PIPELINED;

END;
/


