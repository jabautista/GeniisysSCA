CREATE OR REPLACE PACKAGE BODY CPI.GIACS038_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   12.12.2013
     ** Referenced By:  GIACS038 - Transaction Month Maintenance
     **/
    FUNCTION get_fund_lov
        RETURN fund_lov_tab PIPELINED
    AS
        lov     fund_lov_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIIS_FUNDS)
        LOOP
            lov.fund_cd     := i.fund_cd;
            lov.fund_desc   := i.fund_desc;
          
            PIPE ROW(lov);
        END LOOP;
    END get_fund_lov;
    
    
    FUNCTION get_branch_lov(
        p_fund_cd       GIIS_FUNDS.fund_cd%TYPE,
        p_user_id       GIAC_BRANCHES.user_id%TYPE
    ) RETURN branch_lov_tab PIPELINED
    AS
        lov     branch_lov_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_BRANCHES
                   WHERE gfun_fund_cd LIKE NVL(UPPER(p_fund_cd), '%')
                     AND check_user_per_iss_cd_acctg2 (NULL, branch_cd, 'GIACS038', p_user_id) = 1)
        LOOP
            lov.branch_cd   := i.branch_cd;
            lov.branch_name := i.branch_name;
                
            PIPE ROW(lov);
        END LOOP;
    END get_branch_lov;
    
    
    FUNCTION get_rec_list(
        p_fund_cd       GIAC_TRAN_MM.FUND_CD%type,
        p_branch_cd     GIAC_TRAN_MM.BRANCH_CD%type
    ) RETURN rec_tab PIPELINED
    AS
        rec     rec_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_TRAN_MM
                   WHERE UPPER(fund_cd) = UPPER(p_fund_cd)
                     AND UPPER(branch_cd) = UPPER(p_branch_cd)
		  	       ORDER BY tran_yr DESC, tran_mm ASC)
        LOOP
            rec.fund_cd         := i.fund_cd;
            rec.branch_cd       := i.branch_cd;
            rec.tran_yr         := i.tran_yr;
            rec.tran_mm         := i.tran_mm;
            rec.closed_tag      := i.closed_tag;
            rec.clm_closed_tag  := i.clm_closed_tag;
            rec.remarks         := i.remarks;
            rec.user_id         := i.user_id;
            rec.last_update     := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            
            rec.dsp_month       := TO_CHAR(TO_DATE(i.tran_mm||'-01-00','MM-DD-YY'),'FmMonth');            
            rec.chk_cct         := i.clm_closed_tag;
            
            IF i.closed_tag = 'Y' THEN
                rec.dsp_closed  := 'Closed';
                rec.chk_tc      := 'N';
            ELSIF i.closed_tag = 'N' THEN
                rec.dsp_closed  := 'Open';
                rec.chk_tc      := 'N';
            ELSIF i.closed_tag = 'T' THEN
                rec.dsp_closed  := 'Temporarily Closed';
                rec.chk_tc      := 'T';
            END IF;
            
            PIPE ROW(rec);
        END LOOP;
    END get_rec_list;
    
    
    FUNCTION check_function(
        p_user              VARCHAR2,   --user 
        p_module            VARCHAR2,   --module name
        p_function_code     VARCHAR2    --function code
    ) RETURN VARCHAR2
    AS
    BEGIN
        FOR rec IN  ( SELECT '1'
                        FROM giac_user_functions a, giac_modules b , giac_functions c
                       WHERE a.module_id = b.module_id 
                         AND a.module_id = c.module_id
                         AND a.function_code = c.function_code
                         AND module_name LIKE p_module
                         AND valid_tag = 'Y'
                         AND c.function_code LIKE p_function_code
                         AND a.user_id = p_user
                         AND validity_dt < SYSDATE
                         AND NVL(termination_dt, SYSDATE) >= SYSDATE
                         AND ROWNUM = 1)
        LOOP
            RETURN ('Y');  	
        END LOOP;  
        
        RETURN ('N');
    END check_function;


    FUNCTION get_next_tran_yr(
        p_fund_cd       GIAC_TRAN_MM.FUND_CD%type,
        p_branch_cd     GIAC_TRAN_MM.BRANCH_CD%type
    ) RETURN NUMBER
    AS
        v_nxt_yr        NUMBER(4);
    BEGIN
        SELECT NVL((MAX(TRAN_YR)+1),TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))) 
          INTO v_nxt_yr 
          FROM GIAC_TRAN_MM
         WHERE FUND_CD = P_FUND_CD 
           AND BRANCH_CD = P_BRANCH_CD ;
           
        RETURN (v_nxt_yr);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
    END get_next_tran_yr;
    
    
    PROCEDURE generate_tran_mm(
        p_fund_cd       GIAC_TRAN_MM.FUND_CD%type,
        p_branch_cd     GIAC_TRAN_MM.BRANCH_CD%type,
        p_tran_yr       GIAC_TRAN_MM.TRAN_YR%type,
        p_user_id       GIAC_TRAN_MM.USER_ID%type
    )
    AS
        v_exist     BOOLEAN := FALSE;
    BEGIN
        
        FOR i IN (SELECT DISTINCT tran_yr
                    FROM GIAC_TRAN_MM
                   WHERE fund_cd = p_fund_cd
                     AND branch_cd = p_branch_cd
                     AND tran_yr = p_tran_yr) 
        LOOP
            v_exist := TRUE;
        END LOOP;
        
        IF v_exist = FALSE THEN
            FOR i IN 1..12
            LOOP
                INSERT INTO GIAC_TRAN_MM (fund_cd, branch_cd, tran_yr, tran_mm, closed_tag, clm_closed_tag, user_id, last_update)
                                  VALUES (p_fund_cd, p_branch_cd, p_tran_yr, i, 'N', 'N', p_user_id, SYSDATE);
            END LOOP;
        END IF;
    END generate_tran_mm;
    
    
    FUNCTION get_tranmm_stat_hist(
        p_fund_cd       GIAC_TRAN_MM.FUND_CD%type,
        p_branch_cd     GIAC_TRAN_MM.BRANCH_CD%type,
        p_tran_yr       GIAC_TRAN_MM.TRAN_YR%type,
        p_tran_mm       GIAC_TRAN_MM.TRAN_MM%type
    ) RETURN tranmm_hist_tab PIPELINED
    AS
        rec     tranmm_hist_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_TRANMM_STAT_HIST
                   WHERE fund_cd = p_fund_cd
                     AND branch_cd = p_branch_cd
                     AND tran_yr = p_tran_yr
                     AND tran_mm = p_tran_mm
                   ORDER BY last_update DESC)
        LOOP
            rec.closed_tag      := i.closed_tag;
            rec.user_id         := i.user_id;
            rec.last_update     := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            rec.rv_meaning      := NULL;
            
            FOR j IN (SELECT RV_MEANING
                        FROM CG_REF_CODES A
                       WHERE A.RV_DOMAIN = 'GIAC_TRAN_MM.CLOSED_TAG'
                          AND A.RV_LOW_VALUE = i.CLOSED_TAG)
            LOOP
                rec.RV_MEANING := j.RV_MEANING;
            END LOOP;
            
            PIPE ROW(rec);
        END LOOP;
    END get_tranmm_stat_hist;
    
    
     FUNCTION get_clm_tranmm_stat_hist(
        p_fund_cd       GIAC_TRAN_MM.FUND_CD%type,
        p_branch_cd     GIAC_TRAN_MM.BRANCH_CD%type,
        p_tran_yr       GIAC_TRAN_MM.TRAN_YR%type,
        p_tran_mm       GIAC_TRAN_MM.TRAN_MM%type
    ) RETURN clm_tranmm_hist_tab PIPELINED
    AS
        rec     clm_tranmm_hist_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_CLM_TRANMM_STAT_HIST
                   WHERE fund_cd = p_fund_cd
                     AND branch_cd = p_branch_cd
                     AND tran_yr = p_tran_yr
                     AND tran_mm = p_tran_mm
                   ORDER BY last_update DESC)
        LOOP
            rec.clm_closed_tag  := i.clm_closed_tag;
            rec.user_id         := i.user_id;
            rec.last_update     := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            rec.rv_meaning      := NULL;
            
            FOR j IN (SELECT RV_MEANING
                        FROM CG_REF_CODES A
                       WHERE A.RV_DOMAIN = 'GIAC_TRAN_MM.CLM_CLOSED_TAG' 
                          AND A.RV_LOW_VALUE = i.CLM_CLOSED_TAG)
            LOOP
                rec.RV_MEANING := j.RV_MEANING;
            END LOOP;
            
            PIPE ROW(rec);
        END LOOP;
    END get_clm_tranmm_stat_hist;
    
    
    PROCEDURE update_rec (
        p_rec           GIAC_TRAN_MM%ROWTYPE,
        p_update_cct    VARCHAR2,
        p_update_ct     VARCHAR2
    )
    IS
    BEGIN
        IF p_update_cct IS NOT NULL THEN
            UPDATE GIAC_TRAN_MM
               SET clm_closed_tag   = p_rec.clm_closed_tag,
                   user_id          = p_rec.user_id, 
                   last_update      = SYSDATE
             WHERE fund_cd      = p_rec.fund_cd
               AND branch_cd    = p_rec.branch_cd
               AND tran_yr      = p_rec.tran_yr
               AND tran_mm      = p_rec.tran_mm
                ;
        END IF;
        
        IF p_update_ct IS NOT NULL THEN
            UPDATE GIAC_TRAN_MM
               SET closed_tag       = p_rec.closed_tag,
                   --clm_closed_tag   = p_rec.clm_closed_tag,  -- created separate UPDATE
                   remarks          = p_rec.remarks, 
                   user_id          = p_rec.user_id, 
                   last_update      = SYSDATE
             WHERE fund_cd      = p_rec.fund_cd
               AND branch_cd    = p_rec.branch_cd
               AND tran_yr      = p_rec.tran_yr
               AND tran_mm      = p_rec.tran_mm
                ;
        END IF;
       
        IF p_update_ct IS NULL AND p_update_cct IS NULL THEN
            UPDATE GIAC_TRAN_MM
               SET remarks          = p_rec.remarks, 
                   user_id          = p_rec.user_id, 
                   last_update      = SYSDATE
             WHERE fund_cd      = p_rec.fund_cd
               AND branch_cd    = p_rec.branch_cd
               AND tran_yr      = p_rec.tran_yr
               AND tran_mm      = p_rec.tran_mm
                ;
        END IF;
    END update_rec;
    
END GIACS038_PKG;
/


