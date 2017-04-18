CREATE OR REPLACE PACKAGE BODY CPI.GIUTS030_PKG AS
   FUNCTION get_binder_list(
      p_module_id VARCHAR2,
      p_user_id   VARCHAR2,
      p_status    VARCHAR2,
      --added by MarkS 11.8.2016 SR5801
      p_order_by              VARCHAR2,
      p_asc_desc_flag       VARCHAR2,
      p_from                  NUMBER,
      p_to                    NUMBER,
      p_line_cd             VARCHAR2,
      p_binder_yy           NUMBER,
      p_binder_seq_no       NUMBER,
      p_ri_name             VARCHAR2,
      p_binder_date         VARCHAR2,
      p_reverse_date        VARCHAR2,
      p_ri_tsi_amt          NUMBER,   
      p_ri_prem_amt         NUMBER,   
      p_bndr_stat_desc      VARCHAR2
      --END
   )  
      RETURN binder_list_tab PIPELINED
   IS
      v_list binder_list_type;
      TYPE cur_type IS REF CURSOR;
      c        cur_type;
      v_rec   binder_list_type;
      v_sql   VARCHAR2(32767);
   BEGIN
   --added by MarkS 11.8.2016 SR5801 optimization
   v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT line_cd, binder_yy, binder_seq_no, ri_cd, binder_date, reverse_date, ri_tsi_amt, ri_prem_amt,
                                           bndr_stat_cd, fnl_binder_id, ref_binder_no, confirm_no, confirm_date, release_date, released_by,
                                           replaced_flag,(SELECT ri_name
                                                                FROM giis_reinsurer
                                                          WHERE ri_cd = gb.ri_cd) ri_name,
                                           DECODE((SELECT bndr_stat_desc
                                                    FROM giis_binder_status
                                                   WHERE bndr_stat_cd = gb.bndr_stat_cd),NULL,DECODE(replaced_flag,''Y'',''REPLACED'',DECODE(reverse_date,NULL,(SELECT bndr_stat_desc
                                                                                                                                                                    FROM giis_binder_status
                                                                                                                                                                WHERE bndr_stat_cd = gb.bndr_stat_cd),''REVERSED'')),(SELECT bndr_stat_desc
                                                                                                                                                                                                                        FROM giis_binder_status
                                                                                                                                                                                                                      WHERE bndr_stat_cd = gb.bndr_stat_cd)) bndr_stat_desc                                                                
                                             FROM giri_binder gb
                                             WHERE EXISTS (SELECT ''X'' FROM TABLE (security_access.get_branch_line (''UW'','''|| p_module_id ||''','''|| p_user_id ||'''))
                                                                WHERE LINE_CD= gb.line_cd and BRANCH_CD = gb.iss_cd)
                                               AND (('''|| p_status ||''' = ''1'' AND bndr_stat_cd = ''CN'')
                                                     OR ('''|| p_status ||''' = ''2'' AND bndr_stat_cd = ''RL'')
                                                     OR ('''|| p_status ||''' = ''3'' AND bndr_stat_cd = ''UR'')
                                                     OR ('''|| p_status ||''' = ''4'' AND reverse_date IS NOT NULL AND (replaced_flag is NULL OR replaced_flag = ''N''))
                                                     OR ('''|| p_status ||''' = ''5'' AND replaced_flag = ''Y'')
                                                     OR('''|| p_status ||''' = ''6'' AND NVL(bndr_stat_cd, ''XXXX'') = NVL(bndr_stat_cd, ''XXXX'')))';
    
   IF p_line_cd IS NOT NULL THEN
        v_sql := v_sql || ' AND UPPER(line_cd) LIKE UPPER(NVL('''|| p_line_cd ||''',''%'')) ';
    END IF;
    
    IF p_binder_yy IS NOT NULL THEN
        v_sql := v_sql || ' AND UPPER(binder_yy) LIKE NVL('''|| p_binder_yy ||''',''%'') ';
    END IF;
    
    IF p_binder_seq_no IS NOT NULL THEN
        v_sql := v_sql || ' AND binder_seq_no LIKE NVL('''|| p_binder_seq_no ||''',''%'') ';
    END IF;
    
    IF p_ri_name IS NOT NULL THEN
        v_sql := v_sql || ' AND UPPER((SELECT ri_name
                                                                FROM giis_reinsurer
                                                          WHERE ri_cd = gb.ri_cd)) LIKE UPPER(NVL('''|| p_ri_name ||''',''%'')) ';
    END IF;
    
    IF p_binder_date IS NOT NULL THEN
        v_sql := v_sql || ' AND TRUNC(binder_date) = TO_DATE('''|| p_binder_date ||''', ''mm-dd-yyyy'') ';
    END  IF;
    
    IF p_reverse_date IS NOT NULL THEN
        v_sql := v_sql || ' AND TRUNC(reverse_date) = TO_DATE('''|| p_reverse_date ||''', ''mm-dd-yyyy'') ';
    END IF;
    
    IF p_ri_tsi_amt IS NOT NULL THEN
        v_sql := v_sql || ' AND ri_tsi_amt LIKE NVL('''|| p_ri_tsi_amt ||''',''%'') ';
    END IF;
    
    IF p_ri_prem_amt IS NOT NULL THEN
        v_sql := v_sql || ' AND ri_prem_amt LIKE NVL('''|| p_ri_prem_amt ||''',''%'') ';
    END IF;
    
    IF p_bndr_stat_desc IS NOT NULL THEN
        v_sql := v_sql || ' AND UPPER((DECODE((SELECT bndr_stat_desc
                                                    FROM giis_binder_status
                                                   WHERE bndr_stat_cd = gb.bndr_stat_cd),NULL,DECODE(replaced_flag,''Y'',''REPLACED'',DECODE(reverse_date,NULL,(SELECT bndr_stat_desc
                                                                                                                                                                    FROM giis_binder_status
                                                                                                                                                                WHERE bndr_stat_cd = gb.bndr_stat_cd),''REVERSED'')),(SELECT bndr_stat_desc
                                                                                                                                                                                                                        FROM giis_binder_status
                                                                                                                                                                                                                      WHERE bndr_stat_cd = gb.bndr_stat_cd)))) LIKE UPPER(NVL('''|| p_bndr_stat_desc ||''',''%'')) ';
    END IF;
                              
   IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'lineCd binderYy binderSeqNo'
        THEN        
          v_sql := v_sql || ' ORDER BY line_cd ';
          IF p_asc_desc_flag = 'ASC' THEN
            v_sql := v_sql || ' ASC ';
          ELSIF p_asc_desc_flag = 'DESC' THEN
            v_sql := v_sql || ' DESC ';
          END IF;
          v_sql := v_sql || ', binder_yy ';
          IF p_asc_desc_flag = 'ASC' THEN
            v_sql := v_sql || ' ASC ';
          ELSIF p_asc_desc_flag = 'DESC' THEN
            v_sql := v_sql || ' DESC ';
          END IF;
          v_sql := v_sql || ', binder_seq_no '; 
        ELSIF p_order_by = 'riName'
        THEN
          v_sql := v_sql || ' ORDER BY ri_name ';
        ELSIF p_order_by = 'binderDate'
        THEN
          v_sql := v_sql || ' ORDER BY binder_date ';
        ELSIF p_order_by = 'reverseDate'
        THEN
          v_sql := v_sql || ' ORDER BY reverse_date ';           
        ELSIF p_order_by = 'riTsiAmt'
        THEN
          v_sql := v_sql || ' ORDER BY ri_tsi_amt ';
        ELSIF p_order_by = 'riPremAmt'
        THEN
          v_sql := v_sql || ' ORDER BY ri_prem_amt ';
        ELSIF p_order_by = 'bndrStatDesc'
        THEN
          v_sql := v_sql || ' ORDER BY bndr_stat_desc ';
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
   END IF; 
   v_sql := v_sql ||               ' ) innersql ';
   
   v_sql := v_sql ||     ' ) outersql
                         ) mainsql 
                   WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to; 
   
   OPEN c FOR v_sql;
      LOOP
         FETCH c INTO v_rec.count_,
                      v_rec.rownum_,
                      v_rec.line_cd,
                      v_rec.binder_yy,
                      v_rec.binder_seq_no,
                      v_rec.ri_cd,
                      v_rec.binder_date,
                      v_rec.reverse_date,
                      v_rec.ri_tsi_amt,
                      v_rec.ri_prem_amt,
                      v_rec.bndr_stat_cd,
                      v_rec.fnl_binder_id,
                      v_rec.ref_binder_no,
                      v_rec.confirm_no,
                      v_rec.confirm_date,
                      v_rec.release_date,
                      v_rec.released_by,
                      v_rec.replaced_flag,
                      v_rec.ri_name,
                      v_rec.bndr_stat_desc
                      ;             
         EXIT WHEN c%NOTFOUND; 
         FOR p IN (SELECT a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LPAD(a.issue_yy,2,0)||'-'||LPAD(a.pol_seq_no,7,0)||'-'||LPAD(a.renew_no,2,0)||
                                DECODE( a.endt_seq_no, 0 , '', ' / '||a.endt_iss_cd||'-'||LPAD(a.endt_yy,2,0)||'-'||LPAD(a.endt_seq_no,6,0)) policy_no
                     FROM gipi_polbasic a, giuw_pol_dist b, giri_distfrps c, giri_frps_ri d, giri_binder e
                    WHERE a.policy_id = b.policy_id
                      AND b.dist_no = c.dist_no   
                      AND (c.line_cd = d.line_cd AND c.frps_yy = d.frps_yy AND c.frps_seq_no = d.frps_seq_no)
                      AND d.fnl_binder_id = e.fnl_binder_id
                      AND e.fnl_binder_id = v_rec.fnl_binder_id)    
           LOOP
                v_rec.policy_no := p.policy_no;
           END LOOP;
         FOR a IN (SELECT f.assd_name 
                     FROM gipi_polbasic a, giuw_pol_dist b, giri_distfrps c, giri_frps_ri d, giri_binder e, giis_assured f, gipi_parlist g
                     WHERE a.policy_id = b.policy_id
                       AND b.dist_no = c.dist_no   
                       AND (c.line_cd = d.line_cd AND c.frps_yy = d.frps_yy AND c.frps_seq_no = d.frps_seq_no)
                       AND d.fnl_binder_id = e.fnl_binder_id
                       AND f.assd_no = g.assd_no 
                       AND g.par_id = a.par_id
                       AND e.fnl_binder_id = v_rec.fnl_binder_id)
         LOOP
            v_rec.assd_name := a.assd_name;
         END LOOP;
         
         FOR f IN (SELECT line_cd||'-'||LPAD(frps_yy,2,0)||'-'||LPAD(frps_seq_no,8,0) frps_no
                    FROM giri_frps_ri WHERE fnl_binder_id = v_rec.fnl_binder_id)
        
         LOOP
            v_rec.frps_no := f.frps_no;
         END LOOP;
         
         PIPE ROW (v_rec);
      END LOOP;
      CLOSE c;                     
   --END SR5801
   --commented out By MarkS 11.9.2016 optimization  SR5801
   ---------------------------  
--   FOR i IN (SELECT *
--                  FROM giri_binder gb
--                 WHERE
--                  EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('UW', p_module_id,p_user_id))
--                                                                WHERE LINE_CD= gb.line_cd and BRANCH_CD = gb.iss_cd)
--                   AND ((p_status = '1' AND bndr_stat_cd = 'CN')
--                         OR (p_status = '2' AND bndr_stat_cd = 'RL')
--                         OR (p_status = '3' AND bndr_stat_cd = 'UR')
--                         OR (p_status = '4' AND reverse_date IS NOT NULL AND (replaced_flag is NULL OR replaced_flag = 'N'))
--                         OR (p_status = '5' AND replaced_flag = 'Y')
--                         OR(p_status = '6' AND NVL(bndr_stat_cd, 'XXXX') = NVL(bndr_stat_cd, 'XXXX'))))
--      LOOP
--         v_list.line_cd := i.line_cd;
--         v_list.binder_yy := i.binder_yy;
--         v_list.binder_seq_no := i.binder_seq_no;
--         v_list.ri_cd := i.ri_cd;
--         v_list.binder_date := i.binder_date;
--         v_list.reverse_date := i.reverse_date;
--         v_list.ri_tsi_amt := i.ri_tsi_amt;
--         v_list.ri_prem_amt := i.ri_prem_amt;
--         v_list.bndr_stat_cd := i.bndr_stat_cd;
--         v_list.fnl_binder_id := i.fnl_binder_id;
--         v_list.ref_binder_no := i.ref_binder_no;
--         v_list.confirm_no := i.confirm_no;
--         v_list.confirm_date := i.confirm_date;
--         v_list.release_date := i.release_date;
--         v_list.released_by := i.released_by;
--         v_list.replaced_flag := i.replaced_flag;
--         
--         BEGIN
--            SELECT ri_name
--              INTO v_list.ri_name
--              FROM giis_reinsurer
--                WHERE ri_cd = i.ri_cd;
--         EXCEPTION WHEN NO_DATA_FOUND THEN
--            v_list.ri_name := NULL;    
--         END;
--         
--         BEGIN
--            SELECT bndr_stat_desc
--              INTO v_list.bndr_stat_desc
--              FROM giis_binder_status
--                 WHERE bndr_stat_cd = i.bndr_stat_cd;
--         EXCEPTION WHEN NO_DATA_FOUND THEN
--            v_list.bndr_stat_desc := NULL;                   
--         END;
--         
--         IF v_list.bndr_stat_desc IS NULL AND v_list.replaced_flag ='Y' THEN        
--               v_list.bndr_stat_desc := 'REPLACED';            
--         ELSIF v_list.bndr_stat_desc IS NULL AND v_list.reverse_date is NOT NULL
--               AND(v_list.replaced_flag is NULL OR v_list.replaced_flag = 'N') THEN 
--           v_list.bndr_stat_desc := 'REVERSED';
--         END IF;
--         
--         FOR p IN (SELECT a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LPAD(a.issue_yy,2,0)||'-'||LPAD(a.pol_seq_no,7,0)||'-'||LPAD(a.renew_no,2,0)||
--                                DECODE( a.endt_seq_no, 0 , '', ' / '||a.endt_iss_cd||'-'||LPAD(a.endt_yy,2,0)||'-'||LPAD(a.endt_seq_no,6,0)) policy_no
--                     FROM gipi_polbasic a, giuw_pol_dist b, giri_distfrps c, giri_frps_ri d, giri_binder e
--                    WHERE a.policy_id = b.policy_id
--                      AND b.dist_no = c.dist_no   
--                      AND (c.line_cd = d.line_cd AND c.frps_yy = d.frps_yy AND c.frps_seq_no = d.frps_seq_no)
--                      AND d.fnl_binder_id = e.fnl_binder_id
--                      AND e.fnl_binder_id = i.fnl_binder_id)    
--           LOOP
--                v_list.policy_no := p.policy_no;
--           END LOOP;
--         
--         FOR a IN (SELECT f.assd_name 
--                     FROM gipi_polbasic a, giuw_pol_dist b, giri_distfrps c, giri_frps_ri d, giri_binder e, giis_assured f, gipi_parlist g
--                     WHERE a.policy_id = b.policy_id
--                       AND b.dist_no = c.dist_no   
--                       AND (c.line_cd = d.line_cd AND c.frps_yy = d.frps_yy AND c.frps_seq_no = d.frps_seq_no)
--                       AND d.fnl_binder_id = e.fnl_binder_id
--                       AND f.assd_no = g.assd_no 
--                       AND g.par_id = a.par_id
--                       AND e.fnl_binder_id = i.fnl_binder_id)
--        
--         LOOP
--            v_list.assd_name := a.assd_name;
--         END LOOP;
--         
--         
--         FOR f IN (SELECT line_cd||'-'||LPAD(frps_yy,2,0)||'-'||LPAD(frps_seq_no,8,0) frps_no
--                    FROM giri_frps_ri WHERE fnl_binder_id = i.fnl_binder_id)
--        
--         LOOP
--            v_list.frps_no := f.frps_no;
--         END LOOP;
--      
--         PIPE ROW(v_list);
--      END LOOP;
   ---------------------------
   END;
END;
/
