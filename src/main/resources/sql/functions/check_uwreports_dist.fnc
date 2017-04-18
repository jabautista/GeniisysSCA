DROP FUNCTION CPI.CHECK_UWREPORTS_DIST;

CREATE OR REPLACE FUNCTION CPI.CHECK_UWREPORTS_DIST(
    p_scope_param       IN  NUMBER,
    p_date_param        IN  NUMBER,
    p_from_date         IN  VARCHAR2,
    p_to_date           IN  VARCHAR2,
    p_branch_param      IN  NUMBER,
    p_special_pol_param IN  VARCHAR2,
    p_user_id           IN  GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE,
    p_line_cd           IN  GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
    p_subline_cd        IN  GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
    p_iss_cd            IN  GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE
)
RETURN VARCHAR2 AS
    v_already_extracted     VARCHAR2(1) := 'N';
    /*
    **  Created by    : Marco Paolo Rebong
    **  Date Created  : 04.25.2012
    **  Reference By  : GIPIS901A - UW PRODUCTION REPORTS
    **  Description   : Checks if there is already an existing extraction
    */ 
BEGIN
    SELECT 'Y'
      INTO v_already_extracted
      FROM GIPI_UWREPORTS_DIST_PERIL_EXT
     WHERE scope             = p_scope_param
       AND param_date        = p_date_param
       AND from_date1        = TO_DATE(p_from_date, 'MM-DD-YYYY')
       AND to_date1          = TO_DATE(p_to_date, 'MM-DD-YYYY')
       AND NVL(cred_branch_param, 1) = DECODE(cred_branch_param, null, 1, p_branch_param)
       AND NVL(special_pol_param, 'N') = DECODE(special_pol_param, null, 'N', p_special_pol_param)
       AND user_id           = p_user_id
       AND line_cd           = NVL(p_line_cd,line_cd)
       AND subline_cd        = NVL(p_subline_cd,subline_cd)
       AND iss_cd            = NVL(p_iss_cd,iss_cd);
RETURN v_already_extracted;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        v_already_extracted := 'Y';
        RETURN v_already_extracted;
    WHEN NO_DATA_FOUND THEN
        v_already_extracted := 'N';
        RETURN v_already_extracted;
END CHECK_UWREPORTS_DIST;
/


