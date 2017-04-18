DROP FUNCTION CPI.CHECK_EXTRACTED_DIST_DATA;

CREATE OR REPLACE FUNCTION CPI.CHECK_EXTRACTED_DIST_DATA(
    p_print_tab         VARCHAR2,
    p_user_id           EDST_EXT.user_id%TYPE,
    p_branch_param      NUMBER,
    p_scope_param       NUMBER,
    p_iss_cd            EDST_EXT.iss_cd%TYPE,
    p_line_cd           EDST_EXT.line_cd%TYPE,
    p_subline_cd        EDST_EXT.subline_cd%TYPE
)
RETURN VARCHAR2 AS
    /*
    **  Created by    : Marco Paolo Rebong
    **  Date Created  : 06.08.2012
    **  Reference By  : GIPIS901A - UW PRODUCTION REPORTS
    **  Description   : Checks extracted Data for Distribution Tab
    */ 
    v_exist             VARCHAR2(10);
BEGIN
    IF p_print_tab = 'dist' THEN
        BEGIN
            SELECT user_id
              INTO v_exist
              FROM GIPI_UWREPORTS_DIST_PERIL_EXT
             WHERE user_id = p_user_id
               AND DECODE(p_branch_param,1,cred_branch,iss_cd) = DECODE(p_branch_param,1,cred_branch,NVL(p_iss_cd, iss_cd))
               AND line_cd = NVL(p_line_cd, line_cd)
               AND subline_cd = NVL(p_subline_cd, subline_cd)
               AND ((p_scope_param = 3 AND endt_seq_no=endt_seq_no)
                   OR (p_scope_param = 1 AND endt_seq_no=0)
                   OR (p_scope_param = 2 AND endt_seq_no>0))	
               AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_exist := NULL;
            WHEN TOO_MANY_ROWS THEN
                v_exist := 'Y';
        END;
    ELSIF p_print_tab = 'perPeril' THEN
        BEGIN
            SELECT user_id
	          INTO v_exist
	          FROM GIPI_UWREPORTS_PERIL_EXT
	         WHERE user_id = p_user_id
	 	       AND DECODE(p_branch_param,1,cred_branch,iss_cd) = NVL(p_iss_cd,decode(p_branch_param,1,cred_branch,iss_cd))
	 	       AND line_cd = NVL(p_line_cd, line_cd)
               AND subline_cd = NVL(p_subline_cd, subline_cd)
               AND ((p_scope_param = 3 AND endt_seq_no=endt_seq_no)
                   OR (p_scope_param = 1 AND endt_seq_no=0)
                   OR (p_scope_param = 2 AND endt_seq_no>0))
               AND ROWNUM = 1;
        EXCEPTION
	        WHEN NO_DATA_FOUND THEN
		        v_exist := NULL;
	        WHEN TOO_MANY_ROWS THEN
	            v_exist := 'Y';
        END;
    END IF;
    RETURN v_exist;
END CHECK_EXTRACTED_DIST_DATA;
/


