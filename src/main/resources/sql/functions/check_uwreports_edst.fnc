DROP FUNCTION CPI.CHECK_UWREPORTS_EDST;

CREATE OR REPLACE FUNCTION CPI.CHECK_UWREPORTS_EDST(
    p_edst_scope        IN  NUMBER,
    p_date_param        IN  NUMBER,
    p_from_date         IN  VARCHAR2,
    p_to_date           IN  VARCHAR2,
    p_branch_param      IN  NUMBER,
    p_line_cd           IN  EDST_EXT.line_cd%TYPE,
    p_subline_cd        IN  EDST_EXT.subline_cd%TYPE,
    p_iss_cd            IN  EDST_EXT.iss_cd%TYPE,
    p_user_id           IN  EDST_EXT.user_id%TYPE
)
RETURN VARCHAR2 AS
    v_already_extracted     VARCHAR2(1) := 'N';
    /*
    **  Created by    : Marco Paolo Rebong
    **  Date Created  : 04.23.2012
    **  Reference By  : GIPIS901A - UW PRODUCTION REPORTS
    **  Description   : Checks if there is already an existing extraction - for EDST
    */ 
BEGIN
   FOR i IN(SELECT 'Y'
              FROM EDST_EXT
             WHERE scope = p_edst_scope
               AND param_date = p_date_param
               AND from_date = TO_DATE(p_from_date, 'MM-DD-YYYY')
               AND to_date1 = TO_DATE(p_to_date, 'MM-DD-YYYY')
               AND cred_branch_param = p_branch_param
               AND user_id = p_user_id
               AND line_cd = NVL(p_line_cd,line_cd)
               AND subline_cd = NVL(p_subline_cd,subline_cd)
               AND iss_cd = NVL(p_iss_cd,iss_cd))
   LOOP
      v_already_extracted := 'Y';
      EXIT;
   END LOOP;
   
   RETURN v_already_extracted;
END CHECK_UWREPORTS_EDST;
/


