DROP FUNCTION CPI.CHECK_UWREPORTS_POLICY;

CREATE OR REPLACE FUNCTION CPI.CHECK_UWREPORTS_POLICY(
    p_date_param        IN  NUMBER,
    p_from_date         IN  VARCHAR2,
    p_to_date           IN  VARCHAR2,
    p_branch_param      IN  NUMBER,
    p_special_pol_param IN  VARCHAR2,
    p_user_id           IN  GIPI_UWREPORTS_EXT.user_id%TYPE,
    p_line_cd           IN  GIPI_UWREPORTS_EXT.line_cd%TYPE,
    p_subline_cd        IN  GIPI_UWREPORTS_EXT.subline_cd%TYPE,
    p_iss_cd            IN  GIPI_UWREPORTS_EXT.iss_cd%TYPE
)
RETURN VARCHAR2 AS
    v_already_extracted     VARCHAR2(1) := 'N';
    /*
    **  Created by    : Marco Paolo Rebong
    **  Date Created  : 05.02.2012
    **  Reference By  : GIPIS901A - UW PRODUCTION REPORTS
    **  Description   : Checks if there is already an existing extraction (Policy Register Tab)
    */ 
BEGIN
    SELECT 'Y' check_uwreports
      INTO v_already_extracted
      FROM GIPI_UWREPORTS_EXT
     WHERE param_date        = p_date_param
       AND from_date         = TO_DATE(p_from_date, 'MM-DD-YYYY')
       AND to_date           = TO_DATE(p_to_date, 'MM-DD-YYYY')
       AND cred_branch_param = p_branch_param
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
END CHECK_UWREPORTS_POLICY;
/


