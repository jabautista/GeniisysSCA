DROP FUNCTION CPI.COUNT_NO_SHARE_CD;

CREATE OR REPLACE FUNCTION CPI.COUNT_NO_SHARE_CD(
    p_user_id           EDST_EXT.user_id%TYPE,
    p_iss_cd            EDST_EXT.iss_cd%TYPE,
    p_line_cd           EDST_EXT.line_cd%TYPE,
    p_subline_cd        EDST_EXT.subline_cd%TYPE
)
RETURN VARCHAR2 AS
    /*
    **  Created by    : Marco Paolo Rebong
    **  Date Created  : 06.08.2012
    **  Reference By  : GIPIS901A - UW PRODUCTION REPORTS
    **  Description   : Counts number of records for Breakdown - Detailed
    */ 
    v_count             NUMBER(10);
BEGIN
    BEGIN
        SELECT COUNT(*)  no_records
          INTO v_count
		  FROM (SELECT DISTINCT share_type,share_cd 
		          FROM gipi_uwreports_dist_peril_ext
 			     WHERE user_id = p_user_id
   				   AND iss_cd = NVL(p_iss_cd,iss_cd)
   				   AND line_cd = NVL(p_line_cd,line_cd)
   				   AND subline_cd = NVL(p_subline_cd,subline_cd));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_count := 0;
    END;
    RETURN v_count;
END COUNT_NO_SHARE_CD;
/


