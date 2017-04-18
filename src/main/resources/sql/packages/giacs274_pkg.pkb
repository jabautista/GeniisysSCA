CREATE OR REPLACE PACKAGE BODY CPI.GIACS274_PKG
AS
    /** Created By:     Shan bati
     ** Date Created:   07.25.2013
     ** Referenced By:  GIACS274 - List of Binders Attached to Redistributed Records
     **/
    
    FUNCTION get_branch_lov(
        p_keyword   VARCHAR2,
        p_user_id   VARCHAR2
    ) RETURN branch_lov_tab PIPELINED
    AS
        lov     branch_lov_type;
    BEGIN
        FOR i IN(SELECT branch_cd, branch_name
                   FROM GIAC_BRANCHES
                  WHERE UPPER(branch_cd) LIKE NVL(UPPER(p_keyword) || '%', branch_cd) 
                    AND check_user_per_iss_cd_acctg2(null, branch_cd, 'GIACS274', p_user_id) = 1 )
        LOOP
            lov.branch_cd   := i.branch_cd;
            lov.branch_name := i.branch_name;
            
            PIPE ROW(lov);
        END LOOP;
    END get_branch_lov;


    PROCEDURE populate_old_dist_no
    AS
    BEGIN
        FOR i IN (SELECT DISTINCT policy_id, dist_no
                    FROM giuw_pol_dist
                   WHERE dist_flag = '5')
        LOOP
            UPDATE giuw_pol_dist
               SET old_dist_no = i.dist_no
             WHERE policy_id IN (SELECT policy_id
                                   FROM giuw_pol_dist
                                  WHERE dist_flag = '5')
               AND dist_flag NOT IN ('5','4')
               AND policy_id = i.policy_id;
        END LOOP;
    END populate_old_dist_no;

    
    PROCEDURE extract_binders(
        p_line_cd       IN  giac_redist_binders_ext.LINE_CD%type,
        p_iss_cd        IN  giac_redist_binders_ext.ISS_CD%type,
        p_from_date     IN  gipi_polbasic.ISSUE_DATE%type,
        p_to_date       IN  gipi_polbasic.ISSUE_DATE%type,
        p_as_of_date    IN  giac_redist_binders_ext.AS_OF_DATE%type,
        p_date_param    IN  VARCHAR2,
        p_issue_date    IN  VARCHAR2,
        p_eff_date      IN  VARCHAR2,
        p_user          IN giac_redist_binders_ext.USER_ID%type
    )
    AS
        v_policy_no          VARCHAR2(100);
        v_collection_amt     NUMBER;
        v_date_tag           VARCHAR2(1);
    BEGIN
        DELETE FROM giac_redist_binders_ext
         WHERE user_id = p_user;
        
        IF p_issue_date = 'I' THEN
            v_date_tag  := 'I';
        ELSE
            v_date_tag  := 'E';
        END IF;
        
        FOR A IN (SELECT DISTINCT g.iss_cd, a.line_cd, d.policy_id, d.dist_no,
                          d.old_dist_no, b.ri_cd, a.fnl_binder_id, a.line_cd||'-'|| 
                          to_char(a.binder_yy)||'-'|| to_char(a.binder_seq_no) binder_no,
                          SUM(a.ri_prem_amt)prem_amt, SUM(a.ri_comm_amt) comm_amt
                    FROM  giri_binder a,
                          giri_frps_ri b,
                          giri_distfrps c,
                          giuw_pol_dist d,
                          gipi_polbasic g 
                   WHERE  a.fnl_binder_id = b.fnl_binder_id
                     AND  b.frps_yy=c.frps_yy
                     AND  b.frps_seq_no=c.frps_seq_no
                     AND  b.line_cd=c.line_cd
                     AND  c.dist_no = d.dist_no
                     AND  c.dist_no = d.dist_no
                     AND  d.policy_id=g.policy_id
                     AND (d.dist_flag = '5'
                          OR d.old_dist_no IS NOT NULL)
                     AND g.pol_flag <> '5'
                     AND ((trunc(g.issue_date) BETWEEN p_from_date AND p_to_date
                              AND p_issue_date ='I' AND p_date_param = 'F') 
                           OR (trunc(g.eff_date) BETWEEN p_from_date AND p_to_date
                                  AND p_eff_date ='E' AND p_date_param = 'F')
                           OR (trunc(g.issue_date) < p_as_of_date 
                                  AND p_issue_date = 'I' AND p_date_param = 'A')
                           OR (trunc(g.eff_date) < p_as_of_date 
                                  AND p_eff_date = 'E' AND p_date_param = 'A'))
                     AND g.iss_cd LIKE NVL(p_iss_cd, '%')
                     AND a.line_cd LIKE NVL(p_line_cd, '%')
                     AND check_user_per_iss_cd_acctg2(null, g.iss_cd, 'GIACS274', p_user) = 1
                     AND check_user_per_line2(a.line_cd, null, 'GIACS274', p_user) = 1
                    GROUP BY g.iss_cd, a.line_cd, d.policy_id, d.dist_no, b.ri_cd,
                             a.line_cd||'-'|| to_char(a.binder_yy)||'-'|| to_char(a.binder_seq_no),
                             d.old_dist_no, a.fnl_binder_id)
        LOOP
            v_collection_amt := 0;
            
            FOR C IN (SELECT SUM(disbursement_amt) paid_amt
                        FROM giac_outfacul_prem_payts d, giac_acctrans b
                       WHERE d010_fnl_binder_id = A.fnl_binder_id
                         AND d.gacc_tran_id = b.tran_id
                         AND  tran_flag <> 'D'
                         AND NOT EXISTS (SELECT x.tran_id
                                           FROM giac_acctrans x,
                                                giac_reversals y
                                          WHERE x.tran_flag <>  'D'
                                            AND y.gacc_tran_id = d.gacc_tran_id
                                            AND x.tran_id = y.reversing_tran_id) ) 
            LOOP
                v_policy_no := get_policy_no(a.policy_id);
                
                INSERT INTO giac_redist_binders_ext (line_cd, iss_cd, policy_id,
                                                     policy_no, dist_no, old_dist_no,
                                                     binder_no, ri_cd, prem_amt,
                                                     comm_amt, paid_amt, user_id,
                                                     from_date, to_date, as_of_date,
                                                     date_tag,
                                                     param_line_cd, param_iss_cd)   -- added by shan 03.12.2014

                                             VALUES (a.line_cd, a.iss_cd, a.policy_id,
                                                     v_policy_no, a.dist_no, a.old_dist_no,
                                                     a.binder_no, a.ri_cd, a.prem_amt,
                                                     a.comm_amt, c.paid_amt, p_user,
                                                     p_from_date, p_to_date, p_as_of_date,
                                                     v_date_tag,
                                                     p_line_cd, p_iss_cd);      -- added by shan 03.12.2014
            END LOOP;
        END LOOP;
        
    END extract_binders;
    
    
    PROCEDURE get_remaining_dist_no(
        p_line_cd       IN  giac_redist_binders_ext.LINE_CD%type,
        p_iss_cd        IN  giac_redist_binders_ext.ISS_CD%type,
        p_from_date     IN  gipi_polbasic.ISSUE_DATE%type,
        p_to_date       IN  gipi_polbasic.ISSUE_DATE%type,
        p_as_of_date    IN  giac_redist_binders_ext.AS_OF_DATE%type,
        p_date_param    IN  VARCHAR2,
        p_issue_date    IN  VARCHAR2,
        p_eff_date      IN  VARCHAR2,
        p_user          IN  giac_redist_binders_ext.USER_ID%type
    )
    AS
        v_policy_no varchar2(100);
        v_date_tag  VARCHAR2(1);
    BEGIN
        IF p_issue_date = 'I' THEN
            v_date_tag  := 'I';
        ELSE
            v_date_tag  := 'E';
        END IF;
        
        FOR I IN (SELECT k.dist_no, k.policy_id, k.old_dist_no,
                         j.line_cd, j.iss_cd, m.ri_cd
                    FROM giuw_pol_dist k,
                         gipi_polbasic j,
                         giri_distfrps l,
                         giri_frps_ri m
                   WHERE k.policy_id=j.policy_id
                     AND (k.dist_flag = '5'
                            OR k.old_dist_no IS NOT NULL)
                     AND j.pol_flag <> '5'
                     AND k.dist_no = l.dist_no
                     AND l.frps_yy = m.frps_yy
                     AND l.line_cd = m.line_cd
                     AND l.frps_seq_no = m.frps_seq_no
                     AND K.dist_no NOT IN (SELECT dist_no
                                             FROM giac_redist_binders_ext)
                     AND ((trunc(j.issue_date) BETWEEN p_from_date AND p_to_date
                               AND p_issue_date ='I' AND p_date_param = 'F') 
                          OR (trunc(j.eff_date) BETWEEN p_from_date AND p_to_date
                               AND p_eff_date ='E' AND p_date_param = 'F')
                          OR (trunc(j.issue_date) < p_as_of_date 
                               AND p_issue_date = 'I' AND p_date_param = 'A')
                          OR (trunc(j.eff_date) < p_as_of_date 
                               AND p_eff_date = 'E' AND p_date_param = 'A'))
                     AND j.iss_cd LIKE NVL(p_iss_cd, '%')
                     AND j.line_cd LIKE NVL(p_line_cd, '%')
                     AND check_user_per_iss_cd_acctg2(null, j.iss_cd, 'GIACS274', p_user) = 1
                     AND check_user_per_line2(j.line_cd, null, 'GIACS274', p_user) = 1) 
        LOOP
            v_policy_no := get_policy_no(i.policy_id);

            INSERT INTO GIAC_REDIST_BINDERS_EXT(LINE_CD, ISS_CD, POLICY_NO,
                                                POLICY_ID, DIST_NO, OLD_DIST_NO,
   			                                    USER_ID, FROM_DATE, TO_DATE,
                                                AS_OF_DATE, date_tag, RI_CD,
                                                param_line_cd, param_iss_cd)   -- added by shan 03.12.2014
                                         VALUES(I.LINE_CD, I.ISS_CD, V_POLICY_NO,
                                                I.POLICY_ID, I.DIST_NO, I.OLD_DIST_NO,
                                                P_USER, P_FROM_DATE,
                                                P_TO_DATE, P_AS_OF_DATE, V_DATE_TAG,
                                                I.RI_CD,
                                                p_line_cd, p_iss_cd);      -- added by shan 03.12.2014

        END LOOP;        
    END get_remaining_dist_no;
    
    
    PROCEDURE extract_records(
        p_line_cd       IN  giac_redist_binders_ext.LINE_CD%type,
        p_iss_cd        IN  giac_redist_binders_ext.ISS_CD%type,
        p_from_date     IN  gipi_polbasic.ISSUE_DATE%type,
        p_to_date       IN  gipi_polbasic.ISSUE_DATE%type,
        p_as_of_date    IN  giac_redist_binders_ext.AS_OF_DATE%type,
        p_date_param    IN  VARCHAR2,
        p_issue_date    IN  VARCHAR2,
        p_eff_date      IN  VARCHAR2,
        p_user          IN  giac_redist_binders_ext.USER_ID%type,
        p_msg           OUT VARCHAR,
        p_rec_extracted OUT NUMBER
    )
    AS
    BEGIN
        populate_old_dist_no;
        
        extract_binders(p_line_cd, p_iss_cd, p_from_date, p_to_date, p_as_of_date, p_date_param, p_issue_date, p_eff_date, p_user);
        
        get_remaining_dist_no(p_line_cd, p_iss_cd, p_from_date, p_to_date, p_as_of_date, p_date_param, p_issue_date, p_eff_date, p_user);
        
        p_msg := 'SUCCESS';
        
        SELECT COUNT(*)
          INTO p_rec_extracted
          FROM GIAC_REDIST_BINDERS_EXT
         WHERE user_id = p_user;
    END extract_records;
    
    
     PROCEDURE check_prev_ext_params(
        p_user_id       IN  giac_redist_binders_ext.USER_ID%type,
        p_param_line_cd OUT giac_redist_binders_ext.PARAM_LINE_CD%type,
        p_line_name     OUT GIIS_LINE.LINE_NAME%type,
        p_param_iss_cd  OUT giac_redist_binders_ext.PARAM_ISS_CD%type,
        p_iss_name      OUT GIAC_BRANCHES.BRANCH_NAME%type,
        p_from_date     OUT VARCHAR2,
        p_to_date       OUT VARCHAR2,
        p_as_of_date    OUT VARCHAR2,
        p_date_tag      OUT giac_redist_binders_ext.DATE_TAG%type
   )
    AS
    BEGIN
        FOR i IN (SELECT DISTINCT param_line_cd, param_iss_cd, from_date, to_date, as_of_date, date_tag
                    FROM giac_redist_binders_ext
                   WHERE user_id = p_user_id)
        LOOP
            p_param_line_cd := i.param_line_cd;
            p_param_iss_cd  := i.param_iss_cd;
            p_from_date     := TO_CHAR(i.from_date, 'MM-DD-RRRR');
            p_to_date       := TO_CHAR(i.to_date, 'MM-DD-RRRR');
            p_as_of_date    := TO_CHAR(i.as_of_date, 'MM-DD-RRRR');
            p_date_tag      := i.date_tag;
            
            FOR j IN (SELECT line_name
                        FROM giis_line
                       WHERE line_cd = p_param_line_cd)
            LOOP 
                p_line_name := j.line_name;
            END LOOP;
             
            FOR j IN (SELECT branch_name
                        FROM giac_branches
                       WHERE branch_cd = p_param_iss_cd)
            LOOP
                p_iss_name := j.branch_name;
            END LOOP;
        END LOOP;
         
        
          
    END check_prev_ext_params;
    
END GIACS274_PKG;
/


