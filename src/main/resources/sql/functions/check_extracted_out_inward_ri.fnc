DROP FUNCTION CPI.CHECK_EXTRACTED_OUT_INWARD_RI;

CREATE OR REPLACE FUNCTION CPI.CHECK_EXTRACTED_OUT_INWARD_RI(
    p_print_tab         VARCHAR2,
    p_user_id           EDST_EXT.user_id%TYPE,
    p_branch_param      NUMBER,
    p_scope_param       NUMBER,
    p_iss_cd            EDST_EXT.iss_cd%TYPE,
    p_line_cd           EDST_EXT.line_cd%TYPE,
    p_subline_cd        EDST_EXT.subline_cd%TYPE,
    p_ri_cd             GIPI_UWREPORTS_INW_RI_EXT.ri_cd%TYPE
)
RETURN VARCHAR2 AS
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 01.03.2013
    **  Reference By  : GIPIS901A - UW PRODUCTION REPORTS
    **  Description   : Checks extracted Data for Outward and Inward RI Tab
    */ 
    v_exist             VARCHAR2(10);
BEGIN
    IF p_print_tab = 'inwardRI' THEN
        BEGIN
            SELECT user_id
                INTO v_exist
                FROM GIPI_UWREPORTS_INW_RI_EXT
             WHERE user_id = USER
                 AND NVL(cred_branch,'x') = NVL(p_iss_cd,NVL(cred_branch,'x'))
                 AND iss_cd        = 'RI'
                 AND line_cd       = NVL(p_line_cd, line_cd)
                 AND subline_cd    = NVL(p_subline_cd, subline_cd)
                 AND ((p_scope_param = 3 AND endt_seq_no = endt_seq_no)
                  OR (p_scope_param = 1 AND endt_seq_no = 0)
                  OR (p_scope_param = 2 AND endt_seq_no > 0))
                 AND ri_cd = NVL(p_ri_cd, ri_cd)
                 AND ROWNUM  = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_exist := NULL;
            WHEN TOO_MANY_ROWS THEN
                v_exist := 'Y';
        END;
    ELSIF p_print_tab = 'outwardRI' THEN
        BEGIN
            SELECT user_id
              INTO v_exist
              FROM GIPI_UWREPORTS_RI_EXT
             WHERE user_id = p_user_id
                 AND DECODE(p_branch_param,1,cred_branch,iss_cd) = NVL(p_iss_cd,decode(p_branch_param,1,cred_branch,iss_cd))
                 AND line_cd = NVL(p_line_cd, line_cd)
                 AND subline_cd = NVL(p_subline_cd, subline_cd)
                 AND ((p_scope_param = 3 AND endt_seq_no=endt_seq_no)
                  OR  (p_scope_param = 1 AND endt_seq_no=0)
                  OR  (p_scope_param = 2 AND endt_seq_no>0))
                 AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_exist := NULL;
            WHEN TOO_MANY_ROWS THEN
                v_exist := 'Y';
        END;
    END IF;
    RETURN v_exist;
END CHECK_EXTRACTED_OUT_INWARD_RI;
/


