CREATE OR REPLACE PACKAGE CPI.GIIS_PLAN_PKG
AS

    TYPE giis_plan_type IS RECORD(
        plan_cd             giis_plan.plan_cd%TYPE,
        plan_desc           giis_plan.plan_desc%TYPE,
        line_cd             giis_plan.line_cd%TYPE,
        subline_cd          giis_plan.subline_cd%TYPE,
        remarks             giis_plan.remarks%TYPE,
        user_id             giis_plan.user_id%TYPE,
        last_update         giis_plan.last_update%TYPE
        );

    TYPE giis_plan_tab IS TABLE OF giis_plan_type;
    
    FUNCTION get_plan_cd_list(p_line_cd     giis_plan.line_cd%TYPE)
    RETURN giis_plan_tab PIPELINED;

END;
/


