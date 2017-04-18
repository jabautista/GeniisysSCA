CREATE OR REPLACE PACKAGE BODY CPI.giis_banc_area_pkg
AS
    /*
    **  Created by   :  Jerome Orio
    **  Date Created :  11-17-2010
    **  Reference By : (GIPIS002 - Basic Information)
    **  Description  : banc_area record group
    */
    FUNCTION get_giis_banc_area_list
    RETURN giis_banc_area_tab PIPELINED IS
        v_list  giis_banc_area_type;
    BEGIN
        FOR i IN (SELECT area_cd, area_desc
                    FROM giis_banc_area
                   --WHERE area_cd = NVL (:b540.dsp_area_cd, area_cd)
                ORDER BY area_cd)
        LOOP
            v_list.area_cd     := i.area_cd;
            v_list.area_desc   := i.area_desc;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;

END;
/


