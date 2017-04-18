CREATE OR REPLACE PACKAGE BODY CPI.GIIS_PLAN_PKG
AS
    /*
    **  Created by   :  Jerome Orio
    **  Date Created :  11-18-2010
    **  Reference By : (GIPIS002 - Basic Information)
    **  Description  :  PLAN_RG record group
    */
    FUNCTION get_plan_cd_list(p_line_cd     giis_plan.line_cd%TYPE)
    RETURN giis_plan_tab PIPELINED IS
        v_list      giis_plan_type;
    BEGIN
        FOR i IN (SELECT plan_cd, plan_desc, subline_cd
                    FROM giis_plan
                   WHERE line_cd = p_line_cd
                     --AND subline_cd = :b540.subline_cd
                ORDER BY upper(plan_desc))
        LOOP
            v_list.plan_cd      := i.plan_cd;
            v_list.plan_desc    := i.plan_desc;
            v_list.subline_cd   := i.subline_cd;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;

END;
/


