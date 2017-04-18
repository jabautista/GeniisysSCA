CREATE OR REPLACE PACKAGE BODY CPI.GICLS219_PKG
AS
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.31.2013
   **  Reference By : GICLS219
   **  Remarks      : subline list of values for gicls219
   */
    FUNCTION get_outst_loa_subline_lov(
        p_branch_cd     giis_issource.iss_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN subline_tab PIPELINED
    AS
        v_list  subline_type;
    BEGIN
        FOR q IN(SELECT DISTINCT a.subline_cd, a.subline_name
                   FROM giis_subline a, giis_line b
                  WHERE NVL(b.menu_line_cd, a.line_cd) = Giisp.v('LINE_CODE_MC')
                    AND a.line_Cd = b.line_cd 
                    AND a.subline_cd IN DECODE(Check_User_Per_Iss_Cd2(Giisp.v('LINE_CODE_MC'), p_branch_cd,'GICLS219', p_user_id),1,a.subline_cd,0,'') 
               ORDER BY a.subline_cd, a.subline_name)
        LOOP
            v_list.subline_cd    := q.subline_cd;
            v_list.subline_name  := q.subline_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_outst_loa_subline_lov;
        
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.31.2013
   **  Reference By : GICLS219
   **  Remarks      : branch list of values for gicls219
   */    
    FUNCTION get_outst_loa_branch_lov(
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN branch_tab PIPELINED
    AS
        v_list  branch_type;
    BEGIN
        FOR q IN(SELECT iss_cd, iss_name 
                   FROM giis_issource a
                  WHERE CHECK_USER_PER_ISS_CD2(NVL(Giisp.v('LINE_CODE_MC'),NULL), a.iss_cd, 'GICLS219', p_user_id) = 1
               ORDER BY iss_cd, iss_name)
        LOOP
            v_list.iss_cd   := q.iss_cd;
            v_list.iss_name := q.iss_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_outst_loa_branch_lov;

END GICLS219_pkg;
/


