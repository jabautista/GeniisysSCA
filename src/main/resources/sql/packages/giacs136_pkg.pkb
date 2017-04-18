CREATE OR REPLACE PACKAGE BODY CPI.GIACS136_PKG
AS

    FUNCTION get_prev_params(
        p_user_id       gixx_trty_prem_comm.user_id%TYPE
    )
        RETURN param_tab PIPELINED
    AS
        v_param  param_type;
        v_share  gixx_trty_prem_comm.share_cd%TYPE;
        v_line   giis_line.line_cd%TYPE;
    BEGIN
        FOR q IN(SELECT cession_year, DECODE(cession_mm,1,1,2,1,3,1,4,2,5,2,6,2
                                                       ,7,3,8,3,9,3,10,4,11,4,12,4) cession_mm,
                        param_line_cd, param_share_cd
                   FROM gixx_trty_prem_comm
                  WHERE rownum = 1
                    AND user_id = p_user_id)
        LOOP
            v_param.cession_year := q.cession_year;
            v_param.cession_mm   := q.cession_mm;
            v_param.share_cd     := q.param_share_cd;
            v_param.line_cd      := q.param_line_cd;            
            
            IF v_param.share_cd IS NOT NULL
            THEN
                 SELECT DISTINCT d.trty_name treaty_name
                   INTO v_param.treaty_name
                   FROM giis_dist_share d
                  WHERE d.share_cd = q.param_share_cd
                    AND d.line_cd = q.param_line_cd;
            END IF;
            
            IF v_param.line_cd IS NOT NULL
            THEN
                SELECT a.line_name 
                  INTO v_param.line_name
                  FROM giis_line a
                 WHERE a.line_cd = q.param_line_cd;            
            END IF;
            
            PIPE ROW(v_param);
        END LOOP;
    END;
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.01.2013
   **  Reference By : GIACS136
   **  Remarks      : list of values for treaty name
   */
    FUNCTION get_treaty_lov(
        p_quarter     gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year        gixx_trty_prem_comm.cession_year%TYPE,
        p_line_cd     gixx_trty_prem_comm.line_cd%TYPE
    )
        RETURN treaty_tab PIPELINED
    AS
        v_list  treaty_type;
    BEGIN
        FOR q IN(SELECT DISTINCT d.share_cd share_code, d.trty_name treaty_name
                   FROM gixx_trty_prem_comm c, giis_dist_share d
                  WHERE d.share_type = 2
                    AND d.trty_yy = c.treaty_yy
                    AND d.line_cd = c.line_cd
                    AND d.share_cd = c.share_cd
                    AND c.line_cd = DECODE (p_line_cd, NULL, d.line_cd, p_line_cd)
                    AND c.cession_mm BETWEEN DECODE (p_quarter, 1, 3, 2, 6, 3, 9, 4, 12, NULL, 3) - 2 AND DECODE (p_quarter, 1, 3, 2, 6, 3, 9, 4, 12, NULL, 3)
                    AND c.cession_year = DECODE (p_year, NULL, TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')), p_year))
                    --AND d.share_cd = NVL(p_share_cd,d.share_cd))
                    --AND d.trty_name LIKE UPPER(NVL(p_treaty_name, d.trty_name)))
        LOOP
            v_list.share_cd     := q.share_code;
            v_list.treaty_name  := q.treaty_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_treaty_lov;
        
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.01.2013
   **  Reference By : GIACS136
   **  Remarks      : list of values for line
   */    
    FUNCTION get_line_lov(
        p_quarter   gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year      gixx_trty_prem_comm.cession_year%TYPE
    )
        RETURN line_tab PIPELINED
    AS
        v_list  line_type;
    BEGIN
        FOR q IN(SELECT DISTINCT c.line_cd line_code, e.line_name line_name 
                   FROM gixx_trty_prem_comm c, giis_line e 
                  WHERE e.line_cd = c.line_cd 
                    AND c.cession_mm BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                    AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3) 
                    AND c.cession_year = DECODE(p_year,NULL,TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),p_year))
                    --AND UPPER(c.line_cd) LIKE UPPER(NVL(p_line_cd, c.line_cd))
                    --AND UPPER(e.line_name) LIKE UPPER(NVL(p_line_name, e.line_name)))
        LOOP
            v_list.line_cd   := q.line_code;
            v_list.line_name := q.line_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_line_lov;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.01.2013
   **  Reference By : GIACS136
   **  Remarks      : validate records before extract
   */   
    FUNCTION validate_existing_extract(
        p_quarter   gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year      gixx_trty_prem_comm.cession_year%TYPE,
        p_user_id   giis_users.user_id%TYPE,
        p_line_cd   gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd  gixx_trty_prem_comm.share_cd%TYPE
    )
        RETURN VARCHAR2
    AS
        v_dummy     NUMBER;
    BEGIN
        SELECT COUNT(*)
          INTO v_dummy
          FROM gixx_trty_prem_comm
         WHERE cession_year = p_year
           AND cession_mm BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
           AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)
           AND user_id = p_user_id
           AND param_share_cd = p_share_cd
           AND param_line_cd = p_line_cd;
        RETURN TO_CHAR(v_dummy);
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        v_dummy := 0;
        RETURN TO_CHAR(v_dummy);     
    END validate_existing_extract;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.01.2013
   **  Reference By : GIACS136
   **  Remarks      : delete previously extracted records before extracting again
   */   
    PROCEDURE delete_extracted_records(
        p_quarter IN  gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year    IN  gixx_trty_prem_comm.cession_year%TYPE,
        p_user_id IN  giis_users.user_id%TYPE
    )
    AS
    BEGIN
        DELETE FROM gixx_trty_prem_comm
--              WHERE cession_year = p_year 
--                AND cession_mm BETWEEN DECODE (p_quarter, 1, 3, 2, 6, 3, 9, 4, 12, NULL, 3) - 2 
--                AND DECODE (p_quarter, 1, 3, 2, 6, 3, 9, 4, 12, NULL, 3)
              WHERE user_id = p_user_id;
    END delete_extracted_records;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.01.2013
   **  Reference By : GIACS136
   **  Remarks      : validate if there would be records that could be extracted
   */ 
    FUNCTION validate_before_insert(
        p_quarter IN  gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year    IN  gixx_trty_prem_comm.cession_year%TYPE,
        p_user_id IN  giis_users.user_id%TYPE
    )
        RETURN VARCHAR2
    AS
        v_dummy NUMBER;
    BEGIN
        SELECT count(*)
          INTO v_dummy
          FROM giis_trty_panel a,  giac_treaty_cessions c, giis_dist_share d,
               giis_trty_peril f, giac_treaty_cession_dtl g
         WHERE a.trty_yy = c.treaty_yy 
           AND a.line_cd = c.line_cd 
           AND a.trty_seq_no = c.share_cd 
           AND a.ri_cd = c.ri_cd 
           AND f.trty_seq_no = d.share_cd
           AND f.line_cd = d.line_cd
           AND f. peril_cd = g.peril_cd
           AND g.cession_id = c.cession_id+0
           AND d.share_type = 2 
           AND d.line_cd = c.line_cd 
           AND d.share_cd = c.share_cd
           AND d.trty_yy = c.treaty_yy
           AND c.cession_mm BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
           AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)
           AND c.cession_year = p_year
           AND check_user_per_iss_cd_acctg2(NULL,c.branch_cd,'GIACS136', p_user_id)=1;
        RETURN TO_CHAR(v_dummy);
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        v_dummy := 0;
        RETURN TO_CHAR(v_dummy);
    END validate_before_insert;   

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.01.2013
   **  Reference By : GIACS136
   **  Remarks      : insert extracted records
   */ 
    PROCEDURE extract_records(
        p_quarter IN  gixx_trty_prem_comm.cession_mm%TYPE, 
        p_year    IN  gixx_trty_prem_comm.cession_year%TYPE,
        p_user_id IN  giis_users.user_id%TYPE,
        p_line_cd  IN  gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd IN  gixx_trty_prem_comm.share_cd%TYPE,
        p_msg     OUT VARCHAR2 
    )
    AS 
       v_ext_count         NUMBER;
    BEGIN
    --added by MarkS 12.14.2016 SR5867 optimization
    --remove the use of forloops as it slows down insertion to database.
       INSERT INTO gixx_trty_prem_comm
                    (cession_year  , cession_mm    , line_cd      , branch_cd    , share_cd        , treaty_yy,  
                         prnt_ri_cd    , trty_shr_pct  , trty_com_rt  , premium_amt  , commission_amt  , user_id,
                         param_share_cd, param_line_cd) 
              SELECT c.cession_year, c.cession_mm, C.LINE_CD,  c.branch_cd,
                        c.share_cd, c.treaty_yy,  nvl(a.prnt_ri_cd,a.ri_cd)prnt_ri_cd,
                        a.trty_shr_pct, f.trty_com_rt,
                        g.premium_amt, g.commission_amt,p_user_id,p_share_cd, p_line_cd            
                   FROM giis_trty_panel a,  giac_treaty_cessions c, giis_dist_share d,
                        giis_trty_peril f, giac_treaty_cession_dtl g
                  WHERE a.trty_yy = c.treaty_yy 
                    AND a.line_cd = c.line_cd 
                    AND a.trty_seq_no = c.share_cd 
                    AND a.ri_cd = c.ri_cd 
                    AND f.trty_seq_no = d.share_cd
                    AND f.line_cd = d.line_cd
                    AND f. peril_cd = g.peril_cd
                    AND g.cession_id = c.cession_id+0
                    AND d.share_type = 2 
                    AND d.line_cd = c.line_cd 
                    AND d.share_cd = c.share_cd
                    AND d.trty_yy = c.treaty_yy
                    AND c.cession_mm BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                    AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)
                    AND c.cession_year = p_year
                    AND c.share_cd = NVL(p_share_cd, c.share_cd)
                    AND c.line_cd = NVL(p_line_cd, c.line_cd)
                    AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GIACS136',p_user_id))
                                   WHERE LINE_CD= c.line_cd and BRANCH_CD = c.branch_cd) 
               ORDER BY 1,2,3,4,5,6,7;           
        SELECT COUNT(*) 
          INTO v_ext_count
          FROM gixx_trty_prem_comm
         WHERE cession_year = p_year
           AND cession_mm BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
           AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)
           AND user_id = p_user_id;
        IF v_ext_count = 0 THEN
            p_msg := 'Extraction finished. No records extracted.';        
        ELSE   
            p_msg := 'Extraction finished. '||v_ext_count||' records extracted.';
        END IF;     
--        -----------------   
--        FOR q IN(SELECT c.cession_year, c.cession_mm, c.line_cd,  c.branch_cd,
--                        c.share_cd, c.treaty_yy,  nvl(a.prnt_ri_cd,a.ri_cd)prnt_ri_cd,
--                        a.trty_shr_pct, f.trty_com_rt,
--                        g.premium_amt, g.commission_amt
--                   FROM giis_trty_panel a,  giac_treaty_cessions c, giis_dist_share d,
--                        giis_trty_peril f, giac_treaty_cession_dtl g
--                  WHERE a.trty_yy = c.treaty_yy 
--                    AND a.line_cd = c.line_cd 
--                    AND a.trty_seq_no = c.share_cd 
--                    AND a.ri_cd = c.ri_cd 
--                    AND f.trty_seq_no = d.share_cd
--                    AND f.line_cd = d.line_cd
--                    AND f. peril_cd = g.peril_cd
--                    AND g.cession_id = c.cession_id+0
--                    AND d.share_type = 2 
--                    AND d.line_cd = c.line_cd 
--                    AND d.share_cd = c.share_cd
--                    AND d.trty_yy = c.treaty_yy
--                    AND c.cession_mm BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
--                    AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)
--                    AND c.cession_year = p_year
--                    AND c.share_cd = NVL(p_share_cd, c.share_cd)
--                    AND c.line_cd = NVL(p_line_cd, c.line_cd)
--                    AND check_user_per_iss_cd_acctg2(NVL(p_line_cd, c.line_cd),c.branch_cd, 'GIACS136', p_user_id)=1 --commented out MarkS 12.14.2016 SR5867
--               ORDER BY 1,2,3,4,5,6,7)
--        LOOP
--            INSERT INTO gixx_trty_prem_comm
--                        (cession_year  , cession_mm    , line_cd      , branch_cd    , share_cd        , treaty_yy,  
--                         prnt_ri_cd    , trty_shr_pct  , trty_com_rt  , premium_amt  , commission_amt  , user_id,
--                         param_share_cd, param_line_cd)
--                 VALUES (q.cession_year, q.cession_mm  , q.line_cd    ,  q.branch_cd , q.share_cd      , q.treaty_yy,  
--                         q.prnt_ri_cd  , q.trty_shr_pct, q.trty_com_rt, q.premium_amt, q.commission_amt, p_user_id,
--                         p_share_cd    , p_line_cd);
--        END LOOP;
--        
--        SELECT COUNT(*) 
--          INTO v_ext_count
--          FROM gixx_trty_prem_comm
--         WHERE cession_year = p_year
--           AND cession_mm BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
--           AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)
--           AND user_id = p_user_id;
--        IF v_ext_count = 0 THEN
--            p_msg := 'Extraction finished. No records extracted.';        
--        ELSE   
--            p_msg := 'Extraction finished. '||v_ext_count||' records extracted.';
--        END IF;          
   END extract_records;
END giacs136_pkg;
/


