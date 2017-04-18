CREATE OR REPLACE PACKAGE BODY CPI.gicls271_pkg
AS
/*Modified by pjsantos 11/20/2016 for optimization, GENQA 5834*/
   FUNCTION get_in_hou_adj_list(
      p_user_id             VARCHAR2,
      p_find_text           VARCHAR2,
      p_search_string       VARCHAR2,                                       
      p_order_by            VARCHAR2,       
      p_asc_desc_flag       VARCHAR2,      
      p_first_row           NUMBER,        
      p_last_row            NUMBER 
   )
      RETURN in_hou_adj_tab PIPELINED
   IS
      v_list in_hou_adj_type;
      TYPE cur_type IS REF CURSOR;     
      c        cur_type;                
      v_sql    VARCHAR2(32767); 
   BEGIN
      /*Comment out by pjsantos 09/14/2016, replaced by code below for optimization*/
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT DISTINCT in_hou_adj 
         FROM gicl_claims z
        WHERE  EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''CL'', ''GICLS271'','''||p_user_id||'''))
                                WHERE branch_cd = z.iss_cd) ';

       IF p_search_string IS NOT NULL
        THEN
          v_sql := v_sql ||' AND UPPER(in_hou_adj) LIKE '''||REPLACE(UPPER(p_search_string),'''','''''')||''' ';
      END IF;           
      IF p_find_text IS NOT NULL
        THEN
          v_sql := v_sql ||' AND UPPER(in_hou_adj) LIKE '''||REPLACE(UPPER(p_find_text),'''','''''')|| ''' '; 
      END IF;                               
                                
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'inHouAdj'
         THEN        
          v_sql := v_sql || ' ORDER BY in_hou_adj ';                      
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      ELSE
           v_sql := v_sql || ' ORDER BY in_hou_adj ';
      END IF;
    
    v_sql := v_sql || ') innersql ) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row;
    
   
 
 
    OPEN c FOR v_sql;   
      LOOP
      FETCH c INTO 
            v_list.count_,
            v_list.rownum_,
            v_list.in_hou_adj;-- := i.in_hou_adj;
       EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_list);
      END LOOP;      
      CLOSE c; 
   
      RETURN;
   END get_in_hou_adj_list;   
         
/*Modified by pjsantos 11/20/2016 for optimization, GENQA 5834*/
   FUNCTION get_clm_list_per_user (
      p_user_id           giis_users.user_id%TYPE,
      p_in_hou_adj        gicl_claims.in_hou_adj%TYPE,
      p_search_by_opt     VARCHAR2,
      p_date_as_of        VARCHAR2,
      p_date_to           VARCHAR2,
      p_date_from         VARCHAR2,
      p_recovery_sw       VARCHAR2,
      p_claim_number      VARCHAR2,
      p_claim_status      VARCHAR2,
      p_loss_reserve      gicl_claims.loss_res_amt%TYPE,
      p_expense_reserve   gicl_claims.exp_res_amt%TYPE,
      p_losses_paid       gicl_claims.loss_pd_amt%TYPE,
      p_expenses_paid     gicl_claims.exp_pd_amt%TYPE,
      p_order_by          VARCHAR2,       
      p_asc_desc_flag     VARCHAR2,      
      p_first_row         NUMBER,        
      p_last_row          NUMBER
   )
      RETURN clm_list_per_user_tab PIPELINED
   IS
      v_list   clm_list_per_user_type;
      TYPE cur_type IS REF CURSOR;     
      c        cur_type;  
      d        cur_type;  
      v_sql    VARCHAR2(32767);   
      v_sql2    VARCHAR2(32767);     
   BEGIN
     -- FOR i IN(
       v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT a.claim_id, a.recovery_sw, (SELECT line_cd||''-''||subline_cd||''-''||iss_cd||''-''||LTRIM(TO_CHAR(clm_yy, ''09''))||''-''||LTRIM(TO_CHAR(clm_seq_no, ''0000009'')) claim
                                      FROM gicl_claims
                                     WHERE claim_id = a.claim_id
                                       AND ROWNUM = 1)    claim_no,    
                 b.clm_stat_desc,
                 NVL (a.loss_res_amt, 0) loss_res_amt,
                 a.entry_date,
                 NVL (a.exp_res_amt, 0) exp_res_amt,
                 NVL (a.loss_pd_amt, 0) loss_pd_amt,
                 NVL (a.exp_pd_amt, 0) exp_pd_amt,
                 (   a.line_cd
                  || ''-''
                  || a.subline_cd
                  || ''-''
                  || a.pol_iss_cd
                  || ''-''
                  || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                  || ''-''
                  || LTRIM (TO_CHAR (a.pol_seq_no, ''0999999''))
                  || ''-''
                  || LTRIM (TO_CHAR (a.renew_no, ''09''))
                 ) policy_no,
                 a.assured_name, a.dsp_loss_date, a.clm_file_date,
                NULL tot_loss_res, NULL tot_exp_res, NULL tot_loss_pd, NULL tot_exp_pd, NULL recovery_det_count 
            FROM gicl_claims a , giis_clm_stat b
           WHERE  1=1 
             AND a.clm_stat_cd = b.clm_stat_cd
             AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''CL'', ''GICLS271'','''||p_user_id||'''))
                                WHERE branch_cd = a.iss_cd) 
             AND (   (    (DECODE ('''||p_search_by_opt||''',
                                   ''lossDate'', TRUNC (a.loss_date),
                                   ''fileDate'', TRUNC (a.clm_file_date),
                                   ''entryDate'', TRUNC(a.entry_date)
                                  ) >= TO_DATE ('''||p_date_from||''', ''MM-DD-YYYY'')
                          )
                      AND (DECODE ('''||p_search_by_opt||''',
                                   ''lossDate'', TRUNC (a.loss_date),
                                   ''fileDate'', TRUNC (a.clm_file_date),
                                   ''entryDate'', TRUNC(a.entry_date)
                                  ) <= TO_DATE ('''||p_date_to||''', ''MM-DD-YYYY'')
                          )
                     )
                  OR (DECODE ('''||p_search_by_opt||''',
                              ''lossDate'', TRUNC (a.loss_date),
                              ''fileDate'', TRUNC (a.clm_file_date),
                              ''entryDate'', TRUNC(a.entry_date)
                             ) <= TO_DATE ('''||p_date_as_of||''', ''MM-DD-YYYY''))) ';
           IF p_in_hou_adj IS NOT NULL
            THEN
              v_sql := v_sql || ' AND a.in_hou_adj = '''|| p_in_hou_adj ||''' '; 
           END IF;
           IF p_recovery_sw IS NOT NULL
            THEN
              v_sql := v_sql || '  AND UPPER (a.recovery_sw) LIKE '''||UPPER (p_recovery_sw)||''' ';
           END IF;
           IF p_claim_number IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER (get_clm_no (a.claim_id)) LIKE '''||UPPER (p_claim_number)||''' ';
           END IF;
           IF p_claim_status IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER (b.clm_stat_desc) LIKE '''||UPPER (p_claim_status)||''' ';
           END IF;
           IF p_loss_reserve IS NOT NULL
            THEN
              v_sql := v_sql || ' AND NVL (a.loss_res_amt, 0) LIKE '''||p_loss_reserve||''' ';
           END IF;
           IF p_expense_reserve IS NOT NULL
            THEN
              v_sql := v_sql || ' AND NVL (a.exp_res_amt, 0) LIKE  '''||p_expense_reserve||''' ';
           END IF;
           IF p_losses_paid IS NOT NULL
            THEN
              v_sql := v_sql || ' AND NVL (loss_pd_amt, 0) LIKE '''||p_losses_paid||''' ';
           END IF;
           IF p_expenses_paid IS NOT NULL
            THEN
              v_sql := v_sql || '  AND NVL (a.exp_pd_amt, 0) LIKE '''||p_expenses_paid||''' ';
           END IF;    
       
         IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'recoverySw'
         THEN        
          v_sql := v_sql || ' ORDER BY recovery_sw ';   
        ELSIF p_order_by = 'claimNo'
         THEN        
          v_sql := v_sql || ' ORDER BY claim_no ';        
        ELSIF p_order_by = 'claimStatDesc'
         THEN        
          v_sql := v_sql || ' ORDER BY clm_stat_desc ';  
        ELSIF p_order_by = 'lossResAmt'
         THEN        
          v_sql := v_sql || ' ORDER BY loss_res_amt ';    
        ELSIF p_order_by = 'expResAmt'
         THEN        
          v_sql := v_sql || ' ORDER BY exp_res_amt ';     
        ELSIF p_order_by = 'lossPdAmt'
         THEN        
          v_sql := v_sql || ' ORDER BY loss_pd_amt ';    
        ELSIF p_order_by = 'expPdAmt'
         THEN        
          v_sql := v_sql || ' ORDER BY exp_pd_amt ';        
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      ELSE
           v_sql := v_sql || ' ORDER BY in_hou_adj ';
      END IF;
       
       
       v_sql := v_sql || ') innersql ) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row;
     OPEN c FOR v_sql;   
      LOOP
       FETCH c INTO 
         v_list.count_,
         v_list.rownum_,
         v_list.claim_id,
         v_list.recovery_sw,
         v_list.claim_no,
         v_list.clm_stat_desc,
         v_list.loss_res_amt ,
         v_list.entry_date ,
         v_list.exp_res_amt,
         v_list.loss_pd_amt ,
         v_list.exp_pd_amt ,
         v_list.policy_no ,
         v_list.assured_name ,
         v_list.loss_date ,
         v_list.clm_file_date ,
         v_list.tot_loss_res ,
         v_list.tot_exp_res ,
         v_list.tot_loss_pd ,
         v_list.tot_exp_pd  ,
         v_list.recovery_det_count ;
         /*v_list.claim_id := i.claim_id;
         v_list.recovery_sw := i.recovery_sw;
         v_list.claim_no := get_clm_no (i.claim_id);
         v_list.clm_stat_desc := i.clm_stat_desc;
         v_list.loss_res_amt := i.loss_res_amt;
         v_list.entry_date := i.entry_date;
         v_list.exp_res_amt := i.exp_res_amt;
         v_list.loss_pd_amt := i.loss_pd_amt;
         v_list.exp_pd_amt := i.exp_pd_amt;
         v_list.policy_no := i.policy_no;
         v_list.assured_name := i.assured_name;
         v_list.loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;*/
         

         BEGIN
            SELECT COUNT (*)
              INTO v_list.recovery_det_count
              FROM gicl_clm_recovery
             WHERE claim_id = v_list.claim_id;
         END;

         IF v_list.tot_loss_res IS NULL
         THEN
            BEGIN          
--               FOR a IN(
            v_sql2 := ' SELECT SUM (NVL (a.loss_res_amt, 0)) tot_loss_res_amt,
                          SUM (NVL (a.loss_pd_amt, 0)) tot_loss_paid_amt,
                          SUM (NVL (a.exp_res_amt, 0)) tot_exp_res_amt,
                          SUM (NVL (a.exp_pd_amt, 0)) tot_exp_paid_amt
                     FROM gicl_claims a, giis_clm_stat b
                    WHERE 1=1
                      AND a.clm_stat_cd = b.clm_stat_cd
                      AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''CL'', ''GICLS271'', '''||p_user_id||'''))
                                WHERE branch_cd = a.iss_cd)
                       AND (   (    (DECODE ('''||p_search_by_opt||''',
                                            ''lossDate'', TRUNC (a.loss_date),
                                            ''fileDate'', TRUNC (a.clm_file_date),
                                            ''entryDate'', TRUNC(a.entry_date)
                                           ) >=
                                           TO_DATE ('''||p_date_from||''', ''MM-DD-YYYY'')
                                   )
                               AND (DECODE ('''||p_search_by_opt||''',
                                            ''lossDate'', TRUNC (a.loss_date),
                                            ''fileDate'', TRUNC (a.clm_file_date),
                                            ''entryDate'', TRUNC(a.entry_date)
                                           ) <=
                                             TO_DATE ('''||p_date_to||''', ''MM-DD-YYYY'')
                                   )
                              )
                           OR (DECODE ('''||p_search_by_opt||''',
                                       ''lossDate'', TRUNC (a.loss_date),
                                       ''fileDate'', TRUNC (a.clm_file_date),
                                       ''entryDate'', TRUNC(a.entry_date)
                                      ) <=
                                          TO_DATE ('''||p_date_as_of||''', ''MM-DD-YYYY''))) ';
                      
                      IF p_in_hou_adj IS NOT NULL
                        THEN
                            v_sql2 := v_sql2 ||' AND  a.in_hou_adj = '''||p_in_hou_adj||''' ';
                      END IF;
                     
                      IF p_recovery_sw IS NOT NULL
                        THEN
                            v_sql2 := v_sql2 ||' AND UPPER (a.recovery_sw) LIKE '''||UPPER (p_recovery_sw)||''' ';
                      END IF;
                      IF p_claim_number IS NOT NULL
                        THEN
                            v_sql2 := v_sql2 ||' AND UPPER (get_clm_no (a.claim_id)) LIKE '''||UPPER (p_claim_number)||''' ';
                      END IF;
                      IF p_claim_status IS NOT NULL
                        THEN
                            v_sql2 := v_sql2 ||' AND UPPER (b.clm_stat_desc) LIKE '''||UPPER (p_claim_status)||''' ';
                      END IF;
                      IF p_loss_reserve IS NOT NULL
                        THEN
                            v_sql2 := v_sql2 ||' AND NVL (a.loss_res_amt, 0) LIKE '''||p_loss_reserve||''' ';
                      END IF;
                      IF p_expense_reserve IS NOT NULL
                        THEN
                            v_sql2 := v_sql2 ||' AND NVL (a.exp_res_amt, 0) LIKE '''||p_expense_reserve ||''' ';
                      END IF;
                      IF p_losses_paid IS NOT NULL
                        THEN
                            v_sql2 := v_sql2 ||'  AND NVL (loss_pd_amt, 0) LIKE '''|| p_losses_paid||''' ';
                      END IF;
                      IF p_expenses_paid IS NOT NULL
                        THEN
                            v_sql2 := v_sql2 ||'  AND NVL (a.exp_pd_amt, 0) LIKE '''|| p_expenses_paid ||''' ';
                      END IF;               
                   OPEN d FOR v_sql2;   
                    LOOP
                        FETCH d INTO 
                          v_list.tot_loss_res,
                          v_list.tot_loss_pd,
                          v_list.tot_exp_res,
                          v_list.tot_exp_pd;         
                          /*v_list.tot_loss_res := a.tot_loss_res_amt;
                          v_list.tot_loss_pd := a.tot_loss_paid_amt;
                          v_list.tot_exp_res := a.tot_exp_res_amt;
                          v_list.tot_exp_pd := a.tot_exp_paid_amt;*/
                     EXIT;             
                PIPE ROW (v_list);
                END LOOP;      
                CLOSE d; 
            END;
         END IF;
            EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_list);
      END LOOP;      
     CLOSE c;

      RETURN;
   END get_clm_list_per_user;

   FUNCTION get_processor_history (
      p_claim_id   gicl_processor_hist.claim_id%TYPE
   )
      RETURN processor_history_tab PIPELINED
   IS
      v_list   processor_history_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM gicl_processor_hist
                   WHERE claim_id = p_claim_id
                ORDER BY last_update DESC)
      LOOP
         v_list.in_hou_adj := i.in_hou_adj;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'mm-dd-yyyy HH:MI:ss AM');
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_processor_history;

   FUNCTION get_claim_status_history (
      p_claim_id   gicl_clm_stat_hist.claim_id%TYPE
   )
      RETURN clm_stat_hist_tab PIPELINED
   IS
      v_list   clm_stat_hist_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM gicl_clm_stat_hist
                   WHERE claim_id = p_claim_id
                ORDER BY clm_stat_dt DESC)
      LOOP
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.user_id := i.user_id;
         v_list.clm_stat_dt :=
                            TO_CHAR (i.clm_stat_dt, 'mm-dd-yyyy HH:MI:ss AM');

         BEGIN
            SELECT clm_stat_desc
              INTO v_list.clm_stat_desc
              FROM giis_clm_stat
             WHERE clm_stat_cd = i.clm_stat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.clm_stat_desc := NULL;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_claim_status_history; 
END;
/


