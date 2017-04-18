DROP FUNCTION CPI.CHECK_EXTRACTED_DATA;

CREATE OR REPLACE FUNCTION CPI.CHECK_EXTRACTED_DATA(
    p_edst_ctr          VARCHAR2,
    p_user_id           EDST_EXT.user_id%TYPE,
    p_branch_param      NUMBER,
    p_iss_cd            EDST_EXT.iss_cd%TYPE,
    p_line_cd           EDST_EXT.line_cd%TYPE,
    p_subline_cd        EDST_EXT.subline_cd%TYPE
)
RETURN VARCHAR2 AS
    /*
    **  Created by    : Marco Paolo Rebong
    **  Date Created  : 04.24.2012
    **  Reference By  : GIPIS901A - UW PRODUCTION REPORTS
    **  Description   : Counts extracted Data
    */ 
    v_exist             VARCHAR2(10);
BEGIN
    IF p_edst_ctr = 'Y' THEN
        BEGIN
            SELECT user_id
              INTO v_exist
              FROM EDST_EXT
             WHERE user_id = p_user_id
               AND DECODE(p_branch_param,1,cred_branch,iss_cd) = DECODE(p_branch_param,1,cred_branch,NVL(p_iss_cd, iss_cd))
               AND line_cd = NVL (p_line_cd, line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)
               AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_exist := NULL;
            WHEN TOO_MANY_ROWS THEN
                v_exist := 'Y';
        END;
    ELSE
        BEGIN
            SELECT user_id
              INTO v_exist
              FROM GIPI_UWREPORTS_EXT
             WHERE user_id = p_user_id
               AND DECODE(p_branch_param,1,cred_branch,iss_cd) = DECODE(p_branch_param,1,cred_branch,NVL(p_iss_cd, iss_cd))
               AND line_cd = NVL (p_line_cd, line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)         
               AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_exist := NULL;
            WHEN TOO_MANY_ROWS THEN
                v_exist := 'Y';
        END;
    END IF;
    RETURN v_exist;
END CHECK_EXTRACTED_DATA;
/


