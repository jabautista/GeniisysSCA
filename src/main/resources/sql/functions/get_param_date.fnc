DROP FUNCTION CPI.GET_PARAM_DATE;

CREATE OR REPLACE FUNCTION CPI.GET_PARAM_DATE(
    p_user_id           GIIS_USERS.user_id%TYPE
)
RETURN NUMBER AS
    /*
    **  Created by    : Marco Paolo Rebong
    **  Date Created  : 05.02.2012
    **  Reference By  : GIPIS901A - UW PRODUCTION REPORTS
    **  Description   : Gets param_date from table for validation
    */ 
    v_param_date        GIPI_UWREPORTS_PARAM.param_date%TYPE;
BEGIN
    SELECT param_date
      INTO v_param_date
      FROM GIPI_UWREPORTS_EXT
     WHERE user_id = p_user_id
       AND ROWNUM = 1;
    RETURN v_param_date;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END GET_PARAM_DATE;
/


