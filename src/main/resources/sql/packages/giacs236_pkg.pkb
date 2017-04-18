CREATE OR REPLACE PACKAGE BODY CPI.GIACS236_PKG
AS
   /*
   **  Modified by  :  Maria Gzelle Ison
   **  Date Created : 04.05.2013
   **  Reference By : GIACS236
   **  Remarks      : removed functions of LOV(used existing LOV functions in GIIS_FUNDS_PKG and GIAC_BRANCHES_PKG)
   */
   FUNCTION get_payt_req_status (
        p_fund_cd       giis_funds.fund_cd%TYPE,
        p_branch_cd     giac_branches.branch_cd%TYPE,
        p_status        GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,
        --------------
        --added by Mark SR-5859 11.25.2016 optimization
        p_filt_reqdate          VARCHAR2,
        p_filt_reqno            VARCHAR2,
        p_filt_dept             VARCHAR2,  
        p_filt_rvmeaning        VARCHAR2,
        p_order_by              VARCHAR2,
        p_asc_desc_flag         VARCHAR2,
        p_from                  NUMBER,
        p_to                    NUMBER
        -------------
   )
        RETURN acc_payt_req_status_tab PIPELINED
   IS
        v_list acc_payt_req_status_type;
        -----------------
        --added by Mark SR-5859 11.25.2016 optimization
        TYPE cur_type IS REF CURSOR;
        c        cur_type;
        v_rec   acc_payt_req_status_type;
        v_sql   VARCHAR2(32767);
        -----------------
   BEGIN
   ----------------------
   --added by Mark SR-5859 11.25.2016 optimization
    v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT e.fund_cd, TO_CHAR(e.request_date, ''mm-dd-yyyy''), e.ref_id, b.ouc_cd||'' - ''||b.ouc_name department, s.rv_meaning, c.tran_id, c.payee, c.particulars, TO_CHAR (e.last_update, ''mm-dd-yyyy hh:mi:ss AM''), e.user_id, c.payt_req_flag,
                                              e.document_cd, ( e.document_cd || ''-'' || e.branch_cd||''-''|| e.line_cd || ''-'' ||
                                                                LTRIM( TO_CHAR( e.doc_year,''0999'')) || ''-'' || LTRIM( TO_CHAR( e.doc_mm,''09'')) || ''-'' ||
                                                                LTRIM( TO_CHAR( e.doc_seq_no, ''000009''))) request_no 
                                    FROM giac_oucs b, giac_payt_requests_dtl c, cg_ref_codes s, giac_payt_requests e
                                    WHERE e.fund_cd = b.gibr_gfun_fund_cd
                                    AND e.branch_cd = b.gibr_branch_cd
                                    AND e.gouc_ouc_id = b.ouc_id
                                    AND e.ref_id = c.gprq_ref_id
                                    AND s.rv_low_value = c.payt_req_flag
                                    AND s.rv_domain = ''GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG''
                                    AND e.fund_cd =   '''|| p_fund_cd ||'''
                                    AND e.branch_cd = '''|| p_branch_cd ||'''
                                    AND c.payt_req_flag = NVL('''||p_status||''', c.payt_req_flag)';
    
    IF p_filt_reqdate IS NOT NULL THEN
        v_sql := v_sql ||         ' AND TO_DATE(request_date,''mm-dd-yyyy'') = TO_DATE('''|| p_filt_reqdate ||''',''mm-dd-yyyy'') ';
    END IF;
    IF p_filt_reqno IS NOT NULL THEN
        v_sql := v_sql ||         ' AND UPPER(( e.document_cd || ''-'' || e.branch_cd||''-''|| e.line_cd || ''-'' ||
                                                                LTRIM( TO_CHAR( e.doc_year,''0999'')) || ''-'' || LTRIM( TO_CHAR( e.doc_mm,''09'')) || ''-'' ||
                                                                LTRIM( TO_CHAR( e.doc_seq_no, ''000009'')))) LIKE UPPER('''|| p_filt_reqno ||''')';
    END IF;
    IF p_filt_dept IS NOT NULL THEN
        v_sql := v_sql ||         ' AND UPPER(b.ouc_cd||'' - ''||b.ouc_name) LIKE UPPER('''|| p_filt_dept ||''')';
    END IF;
    IF p_filt_rvmeaning IS NOT NULL THEN 
        v_sql := v_sql ||         ' AND UPPER(rv_meaning) LIKE UPPER('''|| p_filt_rvmeaning ||''')';
    END IF;
    
    IF p_order_by IS NOT NULL THEN
        IF p_order_by = 'requestDate' THEN
            v_sql := v_sql || ' ORDER BY TO_DATE(request_date,''MM-DD-YYYY'') ';
        ELSIF p_order_by = 'requestNo' THEN
            v_sql := v_sql || ' ORDER BY ( e.document_cd || ''-'' || e.branch_cd||''-''|| e.line_cd || ''-'' ||
                                                                LTRIM( TO_CHAR( e.doc_year,''0999'')) || ''-'' || LTRIM( TO_CHAR( e.doc_mm,''09'')) || ''-'' ||
                                                                LTRIM( TO_CHAR( e.doc_seq_no, ''000009''))) ';
        ELSIF p_order_by = 'department' THEN
            v_sql := v_sql || ' ORDER BY department ';
        ELSIF p_order_by = 'rvMeaning' THEN
            v_sql := v_sql || ' ORDER BY rv_meaning ';
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF;
        
    END IF; 
    v_sql := v_sql || '             ) innersql'; 
    v_sql := v_sql || '
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;      
    OPEN c FOR v_sql;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_,
                      v_rec.fund_cd,
                      v_rec.request_date,
                      v_rec.ref_id,
                      v_rec.department,
                      v_rec.rv_meaning,
                      v_rec.tran_id,
                      v_rec.payee,
                      v_rec.particulars,
                      v_rec.last_update,
                      v_rec.user_id,
                      v_rec.status_flag,
                      v_rec.document_cd,
                      v_rec.request_no;                            
         EXIT WHEN c%NOTFOUND;                    
        PIPE ROW (v_rec);
      END LOOP;                
     CLOSE c;                                                 
   ---------------------
   --commented by Mark SR-5859 11.25.2016 optimization
--    FOR a IN (SELECT e.fund_cd, e.request_date, e.ref_id, b.ouc_cd||' - '||b.ouc_name department, s.rv_meaning, c.tran_id, c.payee, c.particulars, e.last_update, e.user_id, c.payt_req_flag,
--                      e.document_cd
--              FROM giac_oucs b, giac_payt_requests_dtl c, cg_ref_codes s, giac_payt_requests e
--             WHERE e.fund_cd = b.gibr_gfun_fund_cd
--               AND e.branch_cd = b.gibr_branch_cd
--               AND e.gouc_ouc_id = b.ouc_id
--               AND e.ref_id = c.gprq_ref_id
--               AND s.rv_low_value = c.payt_req_flag
--               AND s.rv_domain = 'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG'
--               AND e.fund_cd = p_fund_cd
--               AND e.branch_cd = p_branch_cd
--               AND c.payt_req_flag = NVL(p_status, c.payt_req_flag))
--      LOOP
--            v_list.fund_cd          := a.fund_cd;
--            v_list.request_date     := TO_CHAR(a.request_date, 'mm-dd-yyyy');
--            v_list.request_no       := GET_REQUEST_NO(a.ref_id); 
--            v_list.department       := a.department;
--            v_list.rv_meaning       := a.rv_meaning;     
--            v_list.tran_id          := a.tran_id;
--            v_list.payee            := a.payee;     
--            v_list.particulars      := a.particulars;
--            v_list.user_id          := a.user_id;
--            v_list.last_update      := TO_CHAR (a.last_update, 'mm-dd-yyyy hh:mi:ss AM');
--            v_list.status_flag      := a.payt_req_flag;
--            v_list.document_cd      := a.document_cd;
--            v_list.ref_id           := a.ref_id;
--            PIPE ROW(v_list);                         
--       END LOOP;        
        RETURN;
   END get_payt_req_status;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 04.05.2013
   **  Reference By : GIACS236 History
   */
    FUNCTION get_payt_req_hist(
       p_tran_id   GIAC_PAYT_REQUESTS_DTL.tran_id%TYPE   
    ) 
        RETURN acc_payt_req_hist_tab PIPELINED
    IS
        v_list acc_payt_req_hist_type;
    BEGIN
        FOR j IN (SELECT a.tran_id, a.payt_req_flag,
                         RTRIM(LTRIM(b.rv_meaning)) rv_meaning,
                         a.user_id,
                         TO_CHAR(a.last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update
                    FROM GIAC_PAYTREQ_STAT_HIST a, CG_REF_CODES b
                   WHERE tran_id = p_tran_id
                     AND rv_low_value = a.payt_req_flag
                     AND rv_domain = 'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG'
                ORDER BY last_update DESC)
        LOOP
            v_list.tran_id          := j.tran_id;
            v_list.payt_req_flag    := j.payt_req_flag;
            v_list.rv_meaning       := j.rv_meaning;
            v_list.user_id          := j.user_id;
            v_list.last_update      := j.last_update;
            PIPE ROW(v_list);
        END LOOP;
        
    END get_payt_req_hist;
    
END;
/
