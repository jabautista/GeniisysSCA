CREATE OR REPLACE PACKAGE BODY CPI.GIPIR803_PKG
AS
    /*
   **  Created by   :  Kenneth Mark C. Labrador
   **  Date Created : 09.25.2013
   **  Report Id : GIPIR803 - List of Sublines
   */
   
    FUNCTION get_gipir803_record (p_user_id giis_users.user_id%TYPE)
        RETURN get_gipir803_record_tab PIPELINED
    IS
        v_subline get_gipir803_record_type;
    BEGIN
        FOR i IN (SELECT   a.line_cd, a.line_cd || '-' || b.line_name line_desc, a.subline_cd, a.subline_name,
                           DECODE (a.op_flag, 'Y', 'Yes', 'No') open_policy,
--                           TO_DATE(TO_NUMBER(TRUNC((subline_time)/ 3600,0),'99')||
--                           LPAD(TO_NUMBER(TRUNC((TO_NUMBER(subline_time)/3600 - TRUNC(TO_NUMBER(subline_time)/3600))*3600/60,0),'99'),2,0) ||
--                           LPAD(TO_NUMBER(TRUNC(((TO_NUMBER(subline_time)/3600 - TRUNC(TO_NUMBER(subline_time)/3600))*3600/60
--                           - TRUNC((TO_NUMBER(subline_time)/3600 - TRUNC(TO_NUMBER(subline_time)/3600))*3600/60)) * 60,0),'99'),2,0),'HH24MISS') default_time
                           TO_CHAR (TRUNC (SYSDATE) + NUMTODSINTERVAL (subline_time, 'second'), 'HH:MI:SS PM') default_time
                    FROM giis_subline a, giis_line b
                   WHERE a.line_cd = b.line_cd
                     AND check_user_per_line2 (a.line_cd, NULL, 'GIISS002', p_user_id) = 1
                ORDER BY a.subline_cd)
        LOOP    
            v_subline.line_cd := i.line_cd;
            v_subline.line_desc := i.line_desc;
            v_subline.subline_cd := i.subline_cd;
            v_subline.subline_name := i.subline_name;
            v_subline.op_flag := i.open_policy;
            v_subline.default_time := i.default_time;
            v_subline.company_name := giisp.v('COMPANY_NAME');
            v_subline.company_address := giisp.v('COMPANY_ADDRESS');
        PIPE ROW(v_subline);
        END LOOP;
    END get_gipir803_record;
    
END GIPIR803_PKG;
/


