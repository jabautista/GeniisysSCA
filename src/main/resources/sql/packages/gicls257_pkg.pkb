CREATE OR REPLACE PACKAGE BODY CPI.GICLS257_PKG AS
   FUNCTION get_clm_list_per_adjuster (
      p_user_id     GIIS_USERS.user_id%TYPE,
      p_payee_no    GIIS_PAYEES.payee_no%TYPE,
      p_searchby    VARCHAR2,
      p_date_as_of  VARCHAR2,
      p_date_from   VARCHAR2,
      p_date_to     VARCHAR2,
      p_status      VARCHAR2,
      --ADDED by MarkS 11.11.2016 SR5837 optimization
      p_order_by           VARCHAR2,
      p_asc_desc_flag      VARCHAR2,
      p_from               NUMBER,
      p_to                 NUMBER,
      p_payee_name         VARCHAR2,
      p_assign_date        VARCHAR2,
      p_complete_date      VARCHAR2,
      p_cancel_date        VARCHAR2,
      p_dpo                NUMBER,
      p_paid_amount        NUMBER
      
      --END
   )
      RETURN clm_list_per_adjuster_tab PIPELINED
   IS
      v_list        clm_list_per_adjuster_type;
      TYPE cur_type IS REF CURSOR;
      c        cur_type;
      v_rec   clm_list_per_adjuster_type;
      v_sql   VARCHAR2(32767);
      v_sql2   VARCHAR2(32767);
   BEGIN
   IF p_payee_no IS NOT NULL THEN 
   -----ADDED by MarkS 11.11.2016 SR5837 optimization----
   ------------------------------------------------------
   v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT c.claim_id, 
                 c.clm_adj_id, 
                 c.adj_company_cd, 
                 a.payee_name,
                 c.assign_date,
                 c.complt_date, 
                 c.cancel_tag,
                 (SELECT UPPER(line_cd||''-''||subline_cd||''-''||iss_cd||''-''||LTRIM(TO_CHAR(clm_yy,''09''))||''-''||LTRIM(TO_CHAR(clm_seq_no,''0000009''))) claim_no
                    FROM GICL_CLAIMS
                  WHERE claim_id = c.claim_id) claim_number, --ADDED by MarkS 11.11.2016 SR5837 optimization
                 --GET_CLAIM_NUMBER (c.claim_id) AS claim_number, --commented out by MarkS 11.11.2016 SR5837 optimization
                 b.assured_name,
                 b.line_cd 
                 || ''-'' || b.subline_cd 
                 || ''-'' || b.pol_iss_cd 
                 || ''-'' || LTRIM (TO_CHAR (b.issue_yy, ''09''))
                 || ''-'' || LTRIM (TO_CHAR (b.pol_seq_no, ''0999999'')) 
                 || ''-'' || LTRIM (TO_CHAR (b.renew_no, ''09'')) AS policy_number, 
                 TRUNC(b.loss_date)     AS loss_date, 
                 d.clm_stat_desc        AS claim_status, 
                 TRUNC(b.clm_file_date) AS file_date,
                 e.loss_cat_des         AS loss_desc, 
                 f.cancel_date,
                 DECODE (f.cancel_date, 
                            NULL, (TRUNC(NVL(c.complt_date, SYSDATE)) - TRUNC (c.assign_date)), NULL) AS dpo,
                 (SELECT (NVL(SUM(paid_amt), 0))
                    FROM GICL_CLM_LOSS_EXP a
                   WHERE payee_cd = c.adj_company_cd
                     AND payee_class_cd = (SELECT param_value_v
                                             FROM GIAC_PARAMETERS
                                            WHERE param_name = ''ADJP_CLASS_CD'')
                     AND tran_id IS NOT NULL
                     AND claim_id = c.claim_id) AS paid_amt
            FROM GIIS_ADJUSTER a,
                 GICL_CLAIMS b,
                 GICL_CLM_ADJUSTER c,
                 GIIS_CLM_STAT d,
                 GIIS_LOSS_CTGRY e,
                 (SELECT DISTINCT claim_id, adj_company_cd, TRUNC (cancel_date) AS cancel_date, TRUNC(assign_date) AS assign_date
                    FROM GICL_CLM_ADJ_HIST a
                   WHERE adj_hist_no = (SELECT MAX (adj_hist_no)
                                          FROM GICL_CLM_ADJ_HIST g
                                         WHERE g.claim_id = a.claim_id
                                           AND g.adj_company_cd = a.adj_company_cd
                                           AND g.cancel_date IS NOT NULL)
                     AND a.cancel_date IS NOT NULL
                 ) f         
           WHERE EXISTS (SELECT ''X'' FROM TABLE (security_access.get_branch_line (''CL'',''GICLS257'',''' || p_user_id || '''))
                         WHERE LINE_CD= b.line_cd and BRANCH_CD = b.iss_cd) --added by MarkS 11.11.2016 SR5837 optimization
             AND c.adj_company_cd       = a.adj_company_cd(+)
             AND c.priv_adj_cd          = a.priv_adj_cd(+)
             AND b.claim_id             = c.claim_id
             AND b.clm_stat_cd          = d.clm_stat_cd
             AND b.loss_cat_cd          = e.loss_cat_cd
             AND b.line_cd              = e.line_cd
             AND c.claim_id             = f.claim_id(+)
             AND c.adj_company_cd       = f.adj_company_cd(+)
             AND c.adj_company_cd       = ' || p_payee_no || '
             --added trunc by robert 01.06.2014
             AND ((DECODE (''' || p_searchby || ''',
                           ''lossDate'', TRUNC(b.loss_date),
                           ''claimFileDate'', TRUNC(b.clm_file_date),
                           ''dateAssigned'', TRUNC(c.assign_date)) >= TO_DATE(''' || p_date_from || ''', ''MM-DD-YYYY''))
                   AND (DECODE (''' || p_searchby || ''',
                                ''lossDate'', TRUNC(b.loss_date),
                                ''claimFileDate'', TRUNC(b.clm_file_date),
                                ''dateAssigned'', TRUNC(c.assign_date)) <= TO_DATE(''' || p_date_to || ''', ''MM-DD-YYYY''))
                   OR (DECODE (''' || p_searchby || ''',
                                ''lossDate'', TRUNC(b.loss_date),
                                ''claimFileDate'', TRUNC(b.clm_file_date),
                                ''dateAssigned'', TRUNC(c.assign_date)) <= TO_DATE(''' || p_date_as_of || ''', ''MM-DD-YYYY''))
                 )
             AND EXISTS (SELECT 1 
                         FROM GICL_CLM_ADJ_HIST a                        
                         WHERE a.CLAIM_ID = c.CLAIM_ID                    
                         AND a.CLM_ADJ_ID = c.CLM_ADJ_ID
                         AND ((DECODE (''' || p_searchby || ''',
                                                ''lossDate'', TRUNC(b.loss_date),
                                                ''claimFileDate'', TRUNC(b.clm_file_date),
                                                ''dateAssigned'', TRUNC(c.assign_date)) >= TO_DATE(''' || p_date_from || ''', ''MM-DD-YYYY''))
                               AND (DECODE (''' || p_searchby || ''',
                                                     ''lossDate'', TRUNC(b.loss_date),
                                                    ''claimFileDate'', TRUNC(b.clm_file_date),
                                                     ''dateAssigned'', TRUNC(c.assign_date)) <= TO_DATE(''' || p_date_to || ''', ''MM-DD-YYYY''))
                               OR (DECODE (''' || p_searchby || ''',
                                            ''lossDate'', TRUNC(b.loss_date),
                                            ''claimFileDate'', TRUNC(b.clm_file_date),
                                            ''dateAssigned'', TRUNC(c.assign_date)) <= TO_DATE(''' || p_date_as_of || ''', ''MM-DD-YYYY''))
                             )      
                       )
             AND ((DECODE('''|| p_status ||''',''outstanding'',DECODE(c.cancel_tag,null,DECODE(c.complt_date,null,1,0),0),0)) = 1
                  OR (DECODE('''|| p_status ||''',''cancelled'',DECODE(c.cancel_tag,''Y'',1,0),0)) = 1
                  OR (DECODE('''|| p_status ||''',''completed'',DECODE(c.complt_date,NULL,0,1),0)) =1
                  OR (DECODE('''|| p_status ||''',''allAdjuster'',1,0)) =1
                  ) ';

   
        
   IF p_payee_name IS NOT NULL THEN
        v_sql2 := v_sql2 || ' AND UPPER(a.payee_name) LIKE UPPER('''|| p_payee_name ||''' )  '; 
   ELSIF p_assign_date IS NOT NULL THEN
        v_sql2 := v_sql2 || ' AND c.assign_date = TO_DATE('''|| p_assign_date ||''', ''MM-DD-YYYY'') '; 
   ELSIF p_complete_date IS NOT NULL THEN
        v_sql2 := v_sql2 || ' AND c.complt_date = TO_DATE('''|| p_complete_date ||''', ''MM-DD-YYYY'') '; 
   ELSIF p_cancel_date IS NOT NULL THEN
        v_sql2 := v_sql2 || ' AND f.cancel_date = TO_DATE('''|| p_cancel_date ||''', ''MM-DD-YYYY'') '; 
   ELSIF p_dpo IS NOT NULL THEN
        v_sql2 := v_sql2 || ' AND (DECODE (f.cancel_date, 
                            NULL, (TRUNC(NVL(c.complt_date, SYSDATE)) - TRUNC (c.assign_date)), NULL)) = '|| p_dpo ||' '; 
   ELSIF p_paid_amount IS NOT NULL THEN
        v_sql2 := v_sql2 || ' AND (SELECT (NVL(SUM(paid_amt), 0))
                    FROM GICL_CLM_LOSS_EXP a
                   WHERE payee_cd = c.adj_company_cd
                     AND payee_class_cd = (SELECT param_value_v
                                             FROM GIAC_PARAMETERS
                                            WHERE param_name = ''ADJP_CLASS_CD'')
                     AND tran_id IS NOT NULL
                     AND claim_id = c.claim_id) = '|| p_paid_amount ||' '; 
   END IF;
   
   IF p_order_by IS NOT NULL 
   THEN
   
       IF p_order_by = 'payeeName' THEN
            v_sql2 := v_sql2 || ' ORDER BY payee_name '; 
       ELSIF p_order_by = 'assignDate' THEN
            v_sql2 := v_sql2 || ' ORDER BY c.assign_date '; 
       ELSIF p_order_by = 'completeDate' THEN
            v_sql2 := v_sql2 || ' ORDER BY c.complt_date '; 
       ELSIF p_order_by = 'cancelDate' THEN
            v_sql2 := v_sql2 || ' ORDER BY f.cancel_date '; 
       ELSIF p_order_by = 'dPO' THEN
            v_sql2 := v_sql2 || ' ORDER BY (DECODE (f.cancel_date, 
                            NULL, (TRUNC(NVL(c.complt_date, SYSDATE)) - TRUNC (c.assign_date)), NULL)) '; 
       ELSIF p_order_by = 'paidAmount' THEN
            v_sql2 := v_sql2 || ' ORDER BY (SELECT (NVL(SUM(paid_amt), 0))
                    FROM GICL_CLM_LOSS_EXP a
                   WHERE payee_cd = c.adj_company_cd
                     AND payee_class_cd = (SELECT param_value_v
                                             FROM GIAC_PARAMETERS
                                            WHERE param_name = ''ADJP_CLASS_CD'')
                     AND tran_id IS NOT NULL
                     AND claim_id = c.claim_id) '; 
       END IF;
       
       IF p_asc_desc_flag IS NOT NULL
       THEN
           v_sql2 := v_sql2 || p_asc_desc_flag;
       ELSE
           v_sql2 := v_sql2 || ' ASC';
       END IF; 
   END IF;
   v_sql2 := v_sql2 || '  '; 
        v_sql2 := v_sql2 || ' ) innersql ';
        v_sql2 := v_sql2 || '
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
                    
   OPEN c FOR v_sql || v_sql2;
      LOOP
         FETCH c INTO    v_rec.count_, 
                         v_rec.rownum_, 
                         v_rec.claim_id,
                         v_rec.clm_adj_id,
                         v_rec.adj_company_cd,
                         v_rec.payee_name,
                         v_rec.assign_date,
                         v_rec.complt_date,
                         v_rec.cancel_tag,
                         v_rec.claim_number,
                         v_rec.assured_name,
                         v_rec.policy_number,
                         v_rec.loss_date,
                         v_rec.claim_status,
                         v_rec.file_date,
                         v_rec.loss_desc,
                         v_rec.cancel_date,
                         v_rec.dpo,
                         v_rec.paid_amt;                    
         EXIT WHEN c%NOTFOUND;
         IF v_rec.tot_paid_amt IS NULL
             THEN
                FOR b IN
                   (SELECT TO_CHAR (SUM (NVL (a.paid_amt, 0)), '999,999,990.99') paid_amt
                      FROM GICL_CLM_LOSS_EXP a,
                           GICL_CLAIMS b,
                           GICL_CLM_ADJUSTER c              
                     WHERE a.payee_cd = c.adj_company_cd
                       AND a.claim_id = b.claim_id
                       AND a.claim_id = c.claim_id
                       AND a.payee_cd = p_payee_no
                       AND a.payee_class_cd = (SELECT param_value_v
                                                 FROM GIAC_PARAMETERS
                                                WHERE param_name = 'ADJP_CLASS_CD')
                       AND a.tran_id IS NOT NULL
                       AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
                                   WHERE LINE_CD= b.line_cd and BRANCH_CD = b.iss_cd) --added by MarkS 11.11.2016 SR5837 optimization
                      AND ((DECODE (p_searchby,
                                        'lossDate', TRUNC(b.loss_date),
                                        'claimFileDate', TRUNC(b.clm_file_date),
                                        'dateAssigned', TRUNC(c.assign_date)) >= TO_DATE(p_date_from, 'MM-DD-YYYY'))
                           AND (DECODE (p_searchby,
                                         'lossDate', TRUNC(b.loss_date),
                                         'claimFileDate', TRUNC(b.clm_file_date),
                                         'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_to, 'MM-DD-YYYY'))
                           OR (DECODE (p_searchby,
                                         'lossDate', TRUNC(b.loss_date),
                                         'claimFileDate', TRUNC(b.clm_file_date),
                                         'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_as_of, 'MM-DD-YYYY'))
                          )                       
                   )
                LOOP
                   v_rec.tot_paid_amt := NVL (b.paid_amt, 0);
                END LOOP;
                
             END IF;
         
         PIPE ROW (v_rec);
         
      END LOOP;
      
      RETURN;                                                                           
   ------------------------------------------------------
--      FOR i IN
--         (SELECT c.claim_id, 
--                 c.clm_adj_id, 
--                 c.adj_company_cd, 
--                 a.payee_name,
--                 c.assign_date,
--                 c.complt_date, 
--                 c.cancel_tag,
--                 (SELECT UPPER(line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy,'09'))||'-'||LTRIM(TO_CHAR(clm_seq_no,'0000009'))) claim_no
--                    FROM GICL_CLAIMS
--                  WHERE claim_id = c.claim_id) claim_number, --ADDED by MarkS 11.11.2016 SR5837 optimization
--                 --GET_CLAIM_NUMBER (c.claim_id) AS claim_number, --commented out by MarkS 11.11.2016 SR5837 optimization
--                 b.assured_name,
--                 b.line_cd 
--                 || '-' || b.subline_cd 
--                 || '-' || b.pol_iss_cd 
--                 || '-' || LTRIM (TO_CHAR (b.issue_yy, '09'))
--                 || '-' || LTRIM (TO_CHAR (b.pol_seq_no, '0999999')) 
--                 || '-' || LTRIM (TO_CHAR (b.renew_no, '09')) AS policy_number, 
--                 TRUNC(b.loss_date)     AS loss_date, 
--                 d.clm_stat_desc        AS claim_status, 
--                 TRUNC(b.clm_file_date) AS file_date,
--                 e.loss_cat_des         AS loss_desc, 
--                 f.cancel_date,
--                 DECODE (f.cancel_date, 
--                            NULL, (TRUNC(NVL(c.complt_date, SYSDATE)) - TRUNC (c.assign_date)), NULL) AS dpo,
--                 (SELECT (NVL(SUM(paid_amt), 0))
--                    FROM GICL_CLM_LOSS_EXP a
--                   WHERE payee_cd = c.adj_company_cd
--                     AND payee_class_cd = (SELECT param_value_v
--                                             FROM GIAC_PARAMETERS
--                                            WHERE param_name = 'ADJP_CLASS_CD')
--                     AND tran_id IS NOT NULL
--                     AND claim_id = c.claim_id) AS paid_amt
--            FROM GIIS_ADJUSTER a,
--                 GICL_CLAIMS b,
--                 GICL_CLM_ADJUSTER c,
--                 GIIS_CLM_STAT d,
--                 GIIS_LOSS_CTGRY e,
--                 (SELECT DISTINCT claim_id, adj_company_cd, TRUNC (cancel_date) AS cancel_date, TRUNC(assign_date) AS assign_date
--                    FROM GICL_CLM_ADJ_HIST a
--                   WHERE adj_hist_no = (SELECT MAX (adj_hist_no)
--                                          FROM GICL_CLM_ADJ_HIST g
--                                         WHERE g.claim_id = a.claim_id
--                                           AND g.adj_company_cd = a.adj_company_cd
--                                           AND g.cancel_date IS NOT NULL)
--                     AND a.cancel_date IS NOT NULL
--                 ) f,
--                 (                                                       
--                 SELECT c.claim_id                                                          ----all Adjuster 
--                   FROM GIIS_CLM_STAT a, GICL_CLAIMS b, GICL_CLM_ADJUSTER c, GIIS_CLM_STAT d     
--                  WHERE a.clm_stat_cd = b.clm_stat_cd                             
--                    AND b.claim_id = c.claim_id
--                    AND b.clm_stat_cd = d.clm_stat_cd                                   
--                    AND a.clm_stat_desc LIKE (NVL(d.clm_stat_desc,'%'))
--                 ) n,
--                 (                                                      
--                 SELECT e.claim_id                                                          ----cancelled                                  
--                   FROM GIIS_CLM_STAT a, GICL_CLAIMS b, GICL_CLM_ADJUSTER e, GIIS_CLM_STAT d        
--                  WHERE a.clm_stat_cd = b.clm_stat_cd                            
--                    AND b.claim_id = e.claim_id
--                    AND b.clm_stat_cd = d.clm_stat_cd                                  
--                    AND a.clm_stat_desc LIKE (NVL(d.clm_stat_desc,'%'))            
--                    AND cancel_tag = 'Y'                                        
--                    AND adj_company_cd = e.adj_company_cd
--                 ) h,
--                 (                                    
--                 SELECT c.claim_id                                                          ----completed
--                   FROM GIIS_CLM_STAT a, GICL_CLAIMS b, GICL_CLM_ADJUSTER c,  GIIS_CLM_STAT d        
--                  WHERE a.clm_stat_cd = b.clm_stat_cd                             
--                    AND b.claim_id = c.claim_id
--                    AND b.clm_stat_cd = d.clm_stat_cd                                     
--                    AND a.clm_stat_desc LIKE (NVL(d.clm_stat_desc,'%'))            
--                    AND complt_date IS NOT NULL                                 
--                 ) j,
--                 (                                                      
--                 SELECT e.claim_id                                             
--                   FROM GIIS_CLM_STAT a, GICL_CLAIMS b, GICL_CLM_ADJUSTER e,  GIIS_CLM_STAT d    
--                  WHERE a.clm_stat_cd = b.clm_stat_cd                           
--                    AND b.claim_id = e.claim_id  
--                    AND b.clm_stat_cd          = d.clm_stat_cd                        
--                    AND a.clm_stat_desc LIKE (NVL(d.clm_stat_desc,'%'))         
--                    AND adj_company_cd = e.adj_company_cd                       
--                    AND cancel_tag IS NULL                                      
--                    AND complt_date IS NULL
--                                                         
--                 ) l          
--           WHERE 
--             --CHECK_USER_PER_LINE2(line_cd,ISS_CD,'GICLS257',p_user_id)=1  --commented out by MarkS 11.11.2016 SR5837 optimization
--                         EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
--                                 WHERE LINE_CD= b.line_cd and BRANCH_CD = b.iss_cd) --added by MarkS 11.11.2016 SR5837 optimization
--             AND c.adj_company_cd       = a.adj_company_cd(+)
--             AND c.priv_adj_cd          = a.priv_adj_cd(+)
--             AND b.claim_id             = c.claim_id
--             AND b.clm_stat_cd          = d.clm_stat_cd
--             AND b.loss_cat_cd          = e.loss_cat_cd
--             AND b.line_cd              = e.line_cd
--             AND c.claim_id             = f.claim_id(+)
--             AND c.adj_company_cd       = f.adj_company_cd(+)
--             AND c.adj_company_cd       = p_payee_no
--             AND c.claim_id             = n.claim_id(+)
--             AND c.claim_id             = h.claim_id(+)
--             AND c.claim_id             = j.claim_id(+)
--             AND c.claim_id             = l.claim_id(+)
--             --added trunc by robert 01.06.2014
--             AND ((DECODE (p_searchby,
--                           'lossDate', TRUNC(b.loss_date),
--                           'claimFileDate', TRUNC(b.clm_file_date),
--                           'dateAssigned', TRUNC(c.assign_date)) >= TO_DATE(p_date_from, 'MM-DD-YYYY'))
--                   AND (DECODE (p_searchby,
--                                'lossDate', TRUNC(b.loss_date),
--                                'claimFileDate', TRUNC(b.clm_file_date),
--                                'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_to, 'MM-DD-YYYY'))
--                   OR (DECODE (p_searchby,
--                                'lossDate', TRUNC(b.loss_date),
--                                'claimFileDate', TRUNC(b.clm_file_date),
--                                'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_as_of, 'MM-DD-YYYY'))
--                 )   
----             AND c.claim_id IN (SELECT claim_id
----                                  FROM GICL_CLAIMS
----                                 WHERE --CHECK_USER_PER_LINE2(line_cd,ISS_CD,'GICLS257',p_user_id)=1  --commented out by MarkS 11.11.2016 SR5837 optimization
----                         EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
----                                 WHERE LINE_CD= line_cd and BRANCH_CD = iss_cd) --added by MarkS 11.11.2016 SR5837 optimization
----                                )
--             AND (
--                   (DECODE(p_status,
--                            'outstanding', (DECODE(p_searchby, 
--                                                    'dateAssigned', c.claim_id, l.claim_id))) IN (--SELECT claim_id 
----                                                                                                    FROM GICL_CLAIMS 
----                                                                                                   WHERE --CHECK_USER_PER_LINE2(line_cd,ISS_CD,'GICLS257',p_user_id)=1  --commented out by MarkS 11.11.2016 SR5837 optimization
----                                                                                                         EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
----                                                                                                                 WHERE LINE_CD= line_cd and BRANCH_CD = iss_cd) --added by MarkS 11.11.2016 SR5837 optimization  
----                                                                                                 INTERSECT                                                       
--                                                                                                  SELECT e.claim_id                                               
--                                                                                                    FROM GIIS_CLM_STAT a, GICL_CLAIMS b, GICL_CLM_ADJUSTER e       
--                                                                                                   WHERE a.clm_stat_cd = b.clm_stat_cd                             
--                                                                                                     AND b.claim_id = e.claim_id                                   
--                                                                                                     AND a.clm_stat_desc LIKE (NVL(d.clm_stat_desc,'%'))            
--                                                                                                     AND adj_company_cd = c.adj_company_cd                         
--                                                                                                     AND cancel_tag IS NULL                                        
--                                                                                                     AND complt_date IS NULL
--                                                                                                     AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
--                                                                                                                 WHERE LINE_CD= b.line_cd and BRANCH_CD = b.iss_cd) --added by MarkS 11.11.2016 SR5837 optimization                                                             
--                                                                                                     AND EXISTS (SELECT 1 
--                                                                                                                   FROM GICL_CLM_ADJ_HIST a                        
--                                                                                                                   WHERE a.CLAIM_ID = c.CLAIM_ID                    
--                                                                                                                     AND a.CLM_ADJ_ID = c.CLM_ADJ_ID               
--                                                                                                                     -- AND (TRUNC(a.assign_date) >= TO_DATE (p_date_from, 'MM-DD-YYYY')         
--                                                                                                                     --      AND TRUNC(a.assign_date) <= TO_DATE (p_date_to, 'MM-DD-YYYY')           
--                                                                                                                     --      OR TRUNC(a.assign_date) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY'))   
--                                                                                                                     -- deleted codes above and added codes below by robert 01.06.2014
--                                                                                                                      AND ((DECODE (p_searchby,
--                                                                                                                                           'lossDate', TRUNC(b.loss_date),
--                                                                                                                                           'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                           'dateAssigned', TRUNC(c.assign_date)) >= TO_DATE(p_date_from, 'MM-DD-YYYY'))
--                                                                                                                                   AND (DECODE (p_searchby,
--                                                                                                                                                'lossDate', TRUNC(b.loss_date),
--                                                                                                                                                'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                                'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_to, 'MM-DD-YYYY'))
--                                                                                                                                   OR (DECODE (p_searchby,
--                                                                                                                                                'lossDate', TRUNC(b.loss_date),
--                                                                                                                                                'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                                'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_as_of, 'MM-DD-YYYY'))
--                                                                                                                                 )    
--                                                                                                                 )             
--                                                                                                 )                                                 
--                        OR (DECODE(p_status,
--                                    'cancelled', (DECODE(p_searchby, 
--                                                          'dateAssigned', c.claim_id, h.claim_id)))) IN (--SELECT claim_id 
----                                                                                                           FROM GICL_CLAIMS 
----                                                                                                          WHERE --CHECK_USER_PER_LINE2(line_cd,ISS_CD,'GICLS257',p_user_id)=1  --commented out by MarkS 11.11.2016 SR5837 optimization
----                                                                                                                EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
----                                                                                                                        WHERE LINE_CD= line_cd and BRANCH_CD = iss_cd) --added by MarkS 11.11.2016 SR5837 optimization  
----                                                                                                        --INTERSECT                                                       
--                                                                                                         SELECT e.claim_id                                              
--                                                                                                           FROM GIIS_CLM_STAT a, GICL_CLAIMS b, GICL_CLM_ADJUSTER e       
--                                                                                                          WHERE a.clm_stat_cd = b.clm_stat_cd                             
--                                                                                                            AND b.claim_id = e.claim_id                                   
--                                                                                                            AND a.clm_stat_desc LIKE (NVL(d.clm_stat_desc,'%'))            
--                                                                                                            AND cancel_tag = 'Y'                                          
--                                                                                                            AND adj_company_cd = c.adj_company_cd
--                                                                                                            AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
--                                                                                                                        WHERE LINE_CD= b.line_cd and BRANCH_CD = b.iss_cd) --added by MarkS 11.11.2016 SR5837 optimization                         
--                                                                                                            AND EXISTS (SELECT 1 
--                                                                                                                          FROM GICL_CLM_ADJ_HIST a                        
--                                                                                                                         WHERE a.CLAIM_ID = c.CLAIM_ID                    
--                                                                                                                           AND a.CLM_ADJ_ID = c.CLM_ADJ_ID               
--                                                                                                                           -- AND (TRUNC(a.assign_date) >= TO_DATE (p_date_from, 'MM-DD-YYYY')         
--                                                                                                                           --      AND TRUNC(a.assign_date) <= TO_DATE (p_date_to, 'MM-DD-YYYY')            
--                                                                                                                           --      OR TRUNC(a.assign_date) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')) 
--                                                                                                                           -- deleted codes above and added codes below by robert 01.06.2014
--                                                                                                                            AND ((DECODE (p_searchby,
--                                                                                                                                           'lossDate', TRUNC(b.loss_date),
--                                                                                                                                           'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                           'dateAssigned', TRUNC(c.assign_date)) >= TO_DATE(p_date_from, 'MM-DD-YYYY'))
--                                                                                                                                   AND (DECODE (p_searchby,
--                                                                                                                                                'lossDate', TRUNC(b.loss_date),
--                                                                                                                                                'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                                'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_to, 'MM-DD-YYYY'))
--                                                                                                                                   OR (DECODE (p_searchby,
--                                                                                                                                                'lossDate', TRUNC(b.loss_date),
--                                                                                                                                                'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                                'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_as_of, 'MM-DD-YYYY'))
--                                                                                                                                 )      
--                                                                                                                       )
--                                                                                                        )
--                        OR (DECODE(p_status,
--                                    'completed', (DECODE(p_searchby, 
--                                                          'dateAssigned', c.claim_id, j.claim_id)))) IN (--SELECT claim_id 
----                                                                                                           FROM GICL_CLAIMS 
----                                                                                                          WHERE --CHECK_USER_PER_LINE2(line_cd,ISS_CD,'GICLS257',p_user_id)=1  --commented out by MarkS 11.11.2016 SR5837 optimization
----                                                                                                                EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
----                                                                                                                WHERE f= line_cd and BRANCH_CD = iss_cd) --added by MarkS 11.11.2016 SR5837 optimization 
----                                                                                                        INTERSECT                                                       
--                                                                                                         SELECT e.claim_id                                                
--                                                                                                           FROM GIIS_CLM_STAT a, GICL_CLAIMS b, GICL_CLM_ADJUSTER e       
--                                                                                                          WHERE a.clm_stat_cd = b.clm_stat_cd                            
--                                                                                                            AND b.claim_id = e.claim_id                                   
--                                                                                                            AND a.clm_stat_desc LIKE (NVL(d.clm_stat_desc,'%'))            
--                                                                                                            AND complt_date IS NOT NULL
--                                                                                                            AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
--                                                                                                                 WHERE LINE_CD= b.line_cd and BRANCH_CD = b.iss_cd) --added by MarkS 11.11.2016 SR5837 optimization                                  
--                                                                                                            AND EXISTS (SELECT 1 
--                                                                                                                          FROM GICL_CLM_ADJ_HIST a                       
--                                                                                                                         WHERE a.CLAIM_ID = c.CLAIM_ID                   
--                                                                                                                           AND a.CLM_ADJ_ID = c.CLM_ADJ_ID              
--                                                                                                                          -- AND (TRUNC(a.assign_date) >= TO_DATE (p_date_from, 'MM-DD-YYYY')        
--                                                                                                                          --       AND trunc(a.assign_date) <= TO_DATE (p_date_to, 'MM-DD-YYYY')        
--                                                                                                                          --       OR trunc(a.assign_date) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')) 
--                                                                                                                          -- deleted codes above and added codes below by robert 01.06.2014
--                                                                                                                           AND ((DECODE (p_searchby,
--                                                                                                                                           'lossDate', TRUNC(b.loss_date),
--                                                                                                                                           'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                           'dateAssigned', TRUNC(c.assign_date)) >= TO_DATE(p_date_from, 'MM-DD-YYYY'))
--                                                                                                                                   AND (DECODE (p_searchby,
--                                                                                                                                                'lossDate', TRUNC(b.loss_date),
--                                                                                                                                                'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                                'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_to, 'MM-DD-YYYY'))
--                                                                                                                                   OR (DECODE (p_searchby,
--                                                                                                                                                'lossDate', TRUNC(b.loss_date),
--                                                                                                                                                'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                                'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_as_of, 'MM-DD-YYYY'))
--                                                                                                                                 )     
--                                                                                                                       )     
--                                                                                                        )
--                        OR (DECODE(p_status,
--                                    'allAdjuster', (DECODE(p_searchby,
--                                                            'dateAssigned', c.claim_id, n.claim_id)))) IN (--SELECT claim_id 
----                                                                                                             FROM GICL_CLAIMS 
----                                                                                                            WHERE --CHECK_USER_PER_LINE2(line_cd,ISS_CD,'GICLS257',p_user_id)=1  --commented out by MarkS 11.11.2016 SR5837 optimization
----                                                                                                                  EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
----                                                                                                                  WHERE LINE_CD= line_cd and BRANCH_CD = iss_cd) --added by MarkS 11.11.2016 SR5837 optimization 
----                                                                                                          INTERSECT                                                       
--                                                                                                           SELECT e.claim_id                                                
--                                                                                                             FROM GIIS_CLM_STAT a, GICL_CLAIMS b, GICL_CLM_ADJUSTER e       
--                                                                                                            WHERE a.clm_stat_cd = b.clm_stat_cd                            
--                                                                                                              AND b.claim_id = e.claim_id                                   
--                                                                                                              AND a.clm_stat_desc LIKE (NVL(d.clm_stat_desc,'%'))
--                                                                                                              AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
--                                                                                                                 WHERE LINE_CD= b.line_cd and BRANCH_CD = b.iss_cd) --added by MarkS 11.11.2016 SR5837 optimization
--                                                                                                              AND EXISTS (SELECT 1 
--                                                                                                                            FROM GICL_CLM_ADJ_HIST a                        
--                                                                                                                           WHERE a.CLAIM_ID = c.CLAIM_ID                    
--                                                                                                                             AND a.CLM_ADJ_ID = c.CLM_ADJ_ID               
--                                                                                                                            -- AND (TRUNC(a.assign_date) >= TO_DATE (p_date_from, 'MM-DD-YYYY')        
--                                                                                                                            --       AND trunc(a.assign_date) <= TO_DATE (p_date_to, 'MM-DD-YYYY')         
--                                                                                                                            --       OR trunc(a.assign_date) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY'))
--                                                                                                                            -- deleted codes above and added codes below by robert 01.06.2014
--                                                                                                                             AND ((DECODE (p_searchby,
--                                                                                                                                           'lossDate', TRUNC(b.loss_date),
--                                                                                                                                           'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                           'dateAssigned', TRUNC(c.assign_date)) >= TO_DATE(p_date_from, 'MM-DD-YYYY'))
--                                                                                                                                   AND (DECODE (p_searchby,
--                                                                                                                                                'lossDate', TRUNC(b.loss_date),
--                                                                                                                                                'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                                'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_to, 'MM-DD-YYYY'))
--                                                                                                                                   OR (DECODE (p_searchby,
--                                                                                                                                                'lossDate', TRUNC(b.loss_date),
--                                                                                                                                                'claimFileDate', TRUNC(b.clm_file_date),
--                                                                                                                                                'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_as_of, 'MM-DD-YYYY'))
--                                                                                                                                 )      
--                                                                                                                          )                                                            
--                                                                                                          )
--                   )                                                                                                              
--                 )                                                        
--       ORDER BY b.line_cd, b.subline_cd,b.iss_cd, b.clm_yy, b.clm_seq_no, c.clm_adj_id
--         ) 
--                  
--      LOOP
--         v_list.claim_id        := i.claim_id;
--         v_list.clm_adj_id      := i.clm_adj_id;
--         v_list.adj_company_cd  := i.adj_company_cd;
--         v_list.payee_name      := i.payee_name;
--         v_list.assign_date     := i.assign_date;
--         v_list.complt_date     := i.complt_date;
--         v_list.cancel_tag      := i.cancel_tag;
--         v_list.claim_number    := i.claim_number;
--         v_list.assured_name    := i.assured_name;
--         v_list.policy_number   := i.policy_number;
--         v_list.loss_date       := i.loss_date;
--         v_list.claim_status    := i.claim_status;
--         v_list.file_date       := i.file_date;
--         v_list.loss_desc       := i.loss_desc;
--         v_list.cancel_date     := i.cancel_date;
--         v_list.dpo             := i.dpo;
--         v_list.paid_amt        := i.paid_amt;

--         IF v_list.tot_paid_amt IS NULL
--         THEN
--            FOR b IN
--               (SELECT TO_CHAR (SUM (NVL (a.paid_amt, 0)), '999,999,990.99') paid_amt
--                  FROM GICL_CLM_LOSS_EXP a,
--                       GICL_CLAIMS b,
--                       GICL_CLM_ADJUSTER c              
--                 WHERE a.payee_cd = c.adj_company_cd
--                   AND a.claim_id = b.claim_id
--                   AND a.claim_id = c.claim_id
--                   AND a.payee_cd = p_payee_no
--                   AND a.payee_class_cd = (SELECT param_value_v
--                                             FROM GIAC_PARAMETERS
--                                            WHERE param_name = 'ADJP_CLASS_CD')
--                   AND a.tran_id IS NOT NULL
--                   AND --CHECK_USER_PER_LINE2(line_cd,ISS_CD,'GICLS257',p_user_id)=1  --commented out by MarkS 11.11.2016 SR5837 optimization
--                       EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS257',p_user_id))
--                               WHERE LINE_CD= b.line_cd and BRANCH_CD = b.iss_cd) --added by MarkS 11.11.2016 SR5837 optimization
--                  AND ((DECODE (p_searchby,
--                                    'lossDate', TRUNC(b.loss_date),
--                                    'claimFileDate', TRUNC(b.clm_file_date),
--                                    'dateAssigned', TRUNC(c.assign_date)) >= TO_DATE(p_date_from, 'MM-DD-YYYY'))
--                       AND (DECODE (p_searchby,
--                                     'lossDate', TRUNC(b.loss_date),
--                                     'claimFileDate', TRUNC(b.clm_file_date),
--                                     'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_to, 'MM-DD-YYYY'))
--                       OR (DECODE (p_searchby,
--                                     'lossDate', TRUNC(b.loss_date),
--                                     'claimFileDate', TRUNC(b.clm_file_date),
--                                     'dateAssigned', TRUNC(c.assign_date)) <= TO_DATE(p_date_as_of, 'MM-DD-YYYY'))
--                      )                       
--               )
--            LOOP
--               v_list.tot_paid_amt := NVL (b.paid_amt, 0);
--            END LOOP;
--            
--         END IF;
--         
--         PIPE ROW (v_list);
--         
--      END LOOP;
--      
--      RETURN;
   END IF;   
   END;

   FUNCTION validate_payee_per_adj(p_payee GIIS_ADJUSTER.payee_name%TYPE)
   RETURN VARCHAR2
   IS
    v_temp VARCHAR2(1);
    
   BEGIN
        SELECT(SELECT 'X'
                 FROM GIIS_PAYEES a, GIIS_ADJUSTER c
                WHERE a.payee_class_cd = GIACP.v ('ADJP_CLASS_CD')
                  AND a.payee_no = c.adj_company_cd(+)
                  AND ((a.payee_last_name || DECODE (a.payee_first_name,NULL, NULL, ', ' || a.payee_first_name)
                                   || DECODE (a.payee_middle_name, NULL, NULL, '-' || a.payee_middle_name )) LIKE UPPER(NVL(p_payee, '%'))
                                 OR UPPER(a.payee_no) LIKE UPPER(NVL(p_payee, '%'))
                                )
               )
        INTO v_temp
        FROM DUAL;
        
        IF v_temp IS NOT NULL
        THEN
            RETURN '1';
        ELSE
            RETURN '0';
        END IF;
        
   END;
   
END;
/
