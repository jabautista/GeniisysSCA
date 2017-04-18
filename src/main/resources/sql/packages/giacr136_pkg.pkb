CREATE OR REPLACE PACKAGE BODY CPI.giacr136_pkg
AS
   FUNCTION get_giacr136_dtls (
      p_cession_year   VARCHAR2,
      p_line_cd        VARCHAR2,
      p_quarter        VARCHAR2,
      p_share_cd       NUMBER,
      p_user_id        VARCHAR2
   )
      RETURN get_giacr136_tab PIPELINED
   IS
      v_list   get_giacr136_type;
      v_header       BOOLEAN := TRUE;
      -- added by MarkS SR5867 Optimization 
      v_count                   NUMBER :=   1;
      v_mm_total                NUMBER :=   0;
      v_grp_count               NUMBER :=   1;
      last_val_cf_month         VARCHAR2(100)   := null;
      last_val_grp_ris          VARCHAR2(100) := NULL;
      last_val_share_cd         NUMBER :=   0;
      --SR5867
      
   BEGIN

      BEGIN
        FOR i IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
           v_list.company_name := i.param_value_v;
           EXIT;
        END LOOP;
      END;

      BEGIN
        BEGIN
           SELECT param_value_v
             INTO v_list.company_address
             FROM giac_parameters
            WHERE param_name = 'COMPANY_ADDRESS';
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              v_list.company_address := ' ';
        END;
      END;
            
      FOR i IN (SELECT   a.line_cd, a.share_cd, treaty_yy, cession_year,
                            DECODE (p_quarter,
                                    1, 'FIRST QUARTER',
                                    2, 'SECOND QUARTER',
                                    3, 'THIRD QUARTER',
                                    4, 'FOURTH QUARTER'
                                   )
                         || ' '
                         || cession_year quarter_year,
                         c.line_name || ' - ' || b.trty_name line_treaty
                    FROM giis_line c,
                         giis_dist_share b,
                         gixx_trty_prem_comm a
                   WHERE 1 = 1
                     AND a.line_cd = b.line_cd
                     AND a.share_cd = b.share_cd
                     AND a.treaty_yy = b.trty_yy
                     AND a.line_cd = c.line_cd
                     AND a.share_cd = NVL (p_share_cd, a.share_cd)
                     AND a.line_cd = NVL (UPPER (p_line_cd), a.line_cd)
                     AND a.cession_mm BETWEEN   DECODE (p_quarter,
                                                        1, 3,
                                                        2, 6,
                                                        3, 9,
                                                        4, 12,
                                                        NULL, 3
                                                       )
                                              - 2
                                          AND DECODE (p_quarter,
                                                      1, 3,
                                                      2, 6,
                                                      3, 9,
                                                      4, 12,
                                                      NULL, 3
                                                     )
                     AND a.cession_year =
                            TO_NUMBER (NVL (p_cession_year,
                                            TO_CHAR (SYSDATE, 'YYYY')
                                           )
                                      )
                     AND a.user_id = p_user_id
                GROUP BY a.line_cd,
                         c.line_name,
                         a.share_cd,
                         treaty_yy,
                         cession_year,
                         b.trty_name)
      LOOP
         v_header := FALSE;
         v_list.header_flag := 'N';
         v_list.quarter_year := i.quarter_year;
         v_list.line_treaty := i.line_treaty;
         v_list.treaty_yy := i.treaty_yy;
         v_list.share_cd := i.share_cd;
         v_list.line_cd := i.line_cd;
         v_list.cession_year := i.cession_year;
         FOR j IN (SELECT   line_cd, share_cd, treaty_yy, cession_year,
                            cession_mm, trty_com_rt, branch_cd
                            ,DECODE(cession_mm,LAG(cession_mm,1,0) OVER(ORDER BY  cession_mm,branch_cd), NULL, cession_mm) cess_dum,
                            SUM (premium_amt) premium_per_branch
                       FROM gixx_trty_prem_comm
                      WHERE cession_mm BETWEEN   DECODE (p_quarter,
                                                         1, 3,
                                                         2, 6,
                                                         3, 9,
                                                         4, 12,
                                                         NULL, 3
                                                        )
                                               - 2
                                           AND DECODE (p_quarter,
                                                       1, 3,
                                                       2, 6,
                                                       3, 9,
                                                       4, 12,
                                                       NULL, 3
                                                      )
                        AND UPPER (user_id) = UPPER (p_user_id)
                        AND line_cd = i.line_cd
                        AND share_cd = i.share_cd
                        AND cession_year = i.cession_year
                   GROUP BY line_cd,
                            share_cd,
                            treaty_yy,
                            cession_year,
                            cession_mm,
                            trty_com_rt,
                            branch_cd)
         LOOP
               
               v_list.cf_month :=
                           (TO_CHAR (TO_DATE (j.cession_mm, 'MM'), 'MONTH')
                           );
               v_list.cession_mm := j.cession_mm;
               -- added by MarkS SR5867 Optimization 
               IF j.cess_dum IS NULL THEN
                   v_list.cf_month_dum:= NULL;
               ELSE
                   v_list.cf_month_dum:= v_list.cf_month;    
               END IF;
               v_list.branch_cd := j.branch_cd;
               v_list.premium_per_branch := j.premium_per_branch;
               v_count      :=  1;
               v_mm_total   :=  0;
               v_grp_count  :=  1;
               -- MarkS SR5867 Optimization   
--              
            FOR v IN (SELECT a.line_cd, a.trty_seq_no, a.trty_yy, NVL( a.prnt_ri_cd,a.ri_cd)prnt_ri_cd, b.ri_sname, SUM(a.trty_shr_pct) shr_pct
                     ,count(1) over() rec_count --added by MarkS SR5867 Optimization 
                     FROM giis_trty_panel a, 
                            giis_reinsurer b 
                    WHERE b.ri_cd = DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd)
                      AND line_cd = NVL (UPPER (v_list.line_cd), line_cd)
                      AND trty_seq_no = i.share_cd
                      AND trty_yy = i.treaty_yy
                 GROUP BY a.line_cd, a.trty_seq_no, a.trty_yy, NVL(a.prnt_ri_cd,a.ri_cd), b.ri_sname
                 ORDER BY b.ri_sname)
         LOOP
            v_list.ri_sname := v.ri_sname;
            v_list.shr_pct := v.shr_pct;
            v_list.premium_shr := null;
            
            
            FOR y IN(SELECT cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd, prnt_ri_cd, SUM(premium_amt) premium_shr
                       FROM gixx_trty_prem_comm
                      WHERE user_id = p_user_id
                        AND cession_year = v_list.cession_year
                        AND cession_mm = v_list.cession_mm
                        AND line_cd = j.line_cd
                        AND share_cd = j.share_cd
                        AND branch_cd = j.branch_cd
                        AND line_cd = v.line_cd
                        AND share_cd = v.trty_seq_no
                        AND prnt_ri_cd = v.prnt_ri_cd
                   GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd, prnt_ri_cd)
            LOOP
                v_list.premium_shr := y.premium_shr;
                -- edited by MarkS SR5867 Optimization 
                IF v_count <= 7 or v.rec_count > v_count THEN
                    IF v_count = 1 THEN
                        v_list.premium_shr1 := y.premium_shr;
                    END IF; 
                    IF v_count = 2 THEN
                        v_list.premium_shr2 := y.premium_shr;
                    END IF; 
                    IF v_count = 3 THEN
                        v_list.premium_shr3 := y.premium_shr;
                    END IF; 
                    IF v_count = 4 THEN
                        v_list.premium_shr4 := y.premium_shr;
                    END IF;
                    IF v_count = 5 THEN
                        v_list.premium_shr5 := y.premium_shr;
                    END IF; 
                    IF v_count = 6 THEN
                        v_list.premium_shr6 := y.premium_shr;
                    END IF; 
                    IF v_count = 7 THEN
                        v_list.premium_shr7 := y.premium_shr;
                    END IF;  
                    v_mm_total := v_mm_total + y.premium_shr;
                END IF;
                
                    
             END LOOP;
            v_count := v_count + 1;
            IF v_count > 7 or v_count > v.rec_count THEN
                v_list.mm_total := v_mm_total;
                IF v_count = 2 THEN
                   v_list.premium_shr2 := v_mm_total;
                END IF; 
                        
                IF v_count = 3 THEN
                    v_list.premium_shr3 := v_mm_total;
                END IF; 
                        
                IF v_count = 4 THEN
                    v_list.premium_shr4 := v_mm_total;
                END IF; 
                        
                IF v_count = 5 THEN
                    v_list.premium_shr5 := v_mm_total;
                END IF;
                        
                IF v_count = 6 THEN
                   v_list.premium_shr6 := v_mm_total;
                END IF; 
                        
                IF v_count = 7 THEN
                   v_list.premium_shr7 := v_mm_total;
                END IF; 
                v_list.grp_ris   := v_list.line_cd || v_list.share_cd || v_grp_count;
                IF last_val_grp_ris = NULL AND last_val_share_cd = 0 THEN
                    v_list.cf_month_dum := v_list.cf_month;
                ELSE
                    IF last_val_grp_ris = v_list.grp_ris AND  v_list.share_cd = last_val_share_cd THEN
                        v_list.cf_month_dum := NULL;
                    ELSE
                        v_list.cf_month_dum := v_list.cf_month;
                    END IF;
                                    
                END IF; 
                last_val_grp_ris := v_list.grp_ris;
                last_val_share_cd := v_list.share_cd;
                v_grp_count     := v_grp_count + 1;
               
               PIPE ROW (v_list);
               v_count := 1;
               v_list.premium_shr1 := null;
               v_list.premium_shr2 := null;
               v_list.premium_shr3 := null;
               v_list.premium_shr4 := null;
               v_list.premium_shr5 := null;
               v_list.premium_shr6 := null;
               v_list.premium_shr7 := null;
              END IF; 
            --MarkS SR5867 Optimization   
            END LOOP;
         END LOOP;
      END LOOP;
      
      IF v_header THEN
            v_list.header_flag  := 'Y';
            PIPE ROW(v_list);
      END IF;
      
      RETURN;
   END get_giacr136_dtls;

   FUNCTION get_giacr136_header (
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd      gixx_trty_prem_comm.share_cd%TYPE,
        p_treaty_yy     giis_trty_panel.trty_yy%TYPE
   )
      RETURN get_giacr136_tab PIPELINED
   IS
      v_list            get_giacr136_type;
      v_count           NUMBER :=   1;
      v_grp_count       NUMBER :=   1;
   BEGIN
   
         FOR i IN (SELECT a.line_cd, a.trty_seq_no, a.trty_yy, NVL( a.prnt_ri_cd,a.ri_cd)prnt_ri_cd, b.ri_sname, 
                          SUM(a.trty_shr_pct) shr_pct,count(1) over() rec_count
                     FROM giis_trty_panel a, 
                          giis_reinsurer b 
                    WHERE b.ri_cd = DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd)
                      AND line_cd = p_line_cd
                      AND trty_seq_no = p_share_cd
                      AND trty_yy = p_treaty_yy                    
                 GROUP BY a.line_cd, a.trty_seq_no, a.trty_yy, NVL(a.prnt_ri_cd, a.ri_cd),         b.ri_sname
                 ORDER BY b.ri_sname)
         LOOP
            -- edited by MarkS SR5867 Optimization 
             IF v_count <= 7 or i.rec_count > v_count THEN
                
                IF v_count = 1 THEN
                    v_list.ri_sname1 := i.ri_sname;
                    v_list.shr_pct1 := i.shr_pct;
                END IF; 
                IF v_count = 2 THEN
                    v_list.ri_sname2 := i.ri_sname;
                    v_list.shr_pct2 := i.shr_pct;
                END IF; 
                IF v_count = 3 THEN
                    v_list.ri_sname3 := i.ri_sname;
                    v_list.shr_pct3 := i.shr_pct;
                END IF; 
                
                IF v_count = 4 THEN
                    v_list.ri_sname4 := i.ri_sname;
                    v_list.shr_pct4 := i.shr_pct;
                END IF;
                
                IF v_count = 5 THEN
                    v_list.ri_sname5 := i.ri_sname;
                    v_list.shr_pct5 := i.shr_pct;
                END IF; 
                IF v_count = 6 THEN
                    v_list.ri_sname6 := i.ri_sname;
                    v_list.shr_pct6 := i.shr_pct;
                END IF; 
                
                IF v_count = 7 THEN
                    v_list.ri_sname7 := i.ri_sname;
                    v_list.shr_pct7 := i.shr_pct;
                END IF; 
                v_count := v_count + 1;
                IF v_count > 7 or v_count > i.rec_count THEN
                
                IF v_count = 2 THEN
                    v_list.ri_sname2 := 'TOTAL';
                    v_list.shr_pct2 := 100;
                END IF; 
                
                IF v_count = 3 THEN
                    v_list.ri_sname3 := 'TOTAL';
                    v_list.shr_pct3 := 100;
                END IF; 
                
                IF v_count = 4 THEN
                    v_list.ri_sname4 := 'TOTAL';
                    v_list.shr_pct4 := 100;
                END IF; 
                
                IF v_count = 5 THEN
                    v_list.ri_sname5 := 'TOTAL';
                    v_list.shr_pct5 := 100;
                END IF;
                
                IF v_count = 6 THEN
                    v_list.ri_sname6 := 'TOTAL';
                    v_list.shr_pct6 :=100;
                END IF; 
                
                IF v_count = 7 THEN
                    v_list.ri_sname7 := 'TOTAL';
                    v_list.shr_pct7 := 100;
                END IF;
                    v_list.grp_ris   := p_line_cd || p_share_cd || v_grp_count;
                    v_grp_count     := v_grp_count + 1;
                    v_count :=1;
                    PIPE ROW (v_list);  
                END IF; 
             END IF; 
         END LOOP;
         
         
   END get_giacr136_header;   

   FUNCTION get_giacr136_dtls2 (
      p_quarter        VARCHAR2,
      p_line_cd        VARCHAR2,
      p_treaty_yy      VARCHAR2,
      p_share_cd       VARCHAR2,
      p_cession_year   VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN get_giacr136_tab PIPELINED
   IS
      v_list        get_giacr136_type;
      v_count       number :=   1;
      v_mm_total    number :=   0;
   BEGIN
      FOR i IN (SELECT cession_year,  cession_mm, line_cd, share_cd, treaty_yy, branch_cd, SUM(premium_amt) premium_per_branch
                  FROM gixx_trty_prem_comm
                 WHERE cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                   AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3) 
                   AND user_id = p_user_id
                   AND share_cd LIKE (NVL (p_share_cd, '%'))
                   AND UPPER(line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
                   AND cession_year = p_cession_year
              GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd)
      LOOP
         v_list.cession_mm := i.cession_mm;
         v_list.cf_month := (TO_CHAR (TO_DATE (i.cession_mm, 'MM'), 'MONTH'));
         v_list.branch_cd := i.branch_cd;
         v_count :=1;
         FOR v IN (SELECT a.line_cd, a.trty_seq_no, a.trty_yy, NVL( a.prnt_ri_cd,a.ri_cd)prnt_ri_cd, b.ri_sname, SUM(a.trty_shr_pct) shr_pct
                     ,count(1) over() rec_count
                     FROM giis_trty_panel a, 
                            giis_reinsurer b 
                    WHERE b.ri_cd = DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd)
                      AND UPPER(line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
                      AND trty_seq_no LIKE (NVL (p_share_cd, '%'))
                      AND trty_yy = p_treaty_yy
                 GROUP BY a.line_cd, a.trty_seq_no, a.trty_yy, NVL(a.prnt_ri_cd,a.ri_cd), b.ri_sname
                 ORDER BY b.ri_sname)
         LOOP
            v_list.ri_sname := v.ri_sname;
            v_list.shr_pct := v.shr_pct;
            v_list.premium_shr := null;
            
            
            FOR y IN(SELECT cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd, prnt_ri_cd, SUM(premium_amt) premium_shr
                       FROM gixx_trty_prem_comm
                      WHERE user_id = p_user_id
                        AND cession_year = i.cession_year
                        AND cession_mm = i.cession_mm
                        AND line_cd = i.line_cd
                        AND share_cd = i.share_cd
                        AND branch_cd = i.branch_cd
                        AND line_cd = v.line_cd
                        AND share_cd = v.trty_seq_no
                        AND prnt_ri_cd = v.prnt_ri_cd
                   GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd, prnt_ri_cd)
            LOOP
                v_list.premium_shr := y.premium_shr;
                IF v_count <= 7 or v.rec_count > v_count THEN
                    IF v_count = 1 THEN
                        v_list.premium_shr1 := y.premium_shr;
                    END IF; 
                    IF v_count = 2 THEN
                        v_list.premium_shr2 := y.premium_shr;
                    END IF; 
                    IF v_count = 3 THEN
                        v_list.premium_shr3 := y.premium_shr;
                    END IF; 
                    IF v_count = 4 THEN
                        v_list.premium_shr4 := y.premium_shr;
                    END IF;
                    IF v_count = 5 THEN
                        v_list.premium_shr5 := y.premium_shr;
                    END IF; 
                    IF v_count = 6 THEN
                        v_list.premium_shr6 := y.premium_shr;
                    END IF; 
                    IF v_count = 7 THEN
                        v_list.premium_shr7 := y.premium_shr;
                    END IF;  
                    v_mm_total := v_mm_total + y.premium_shr;
                END IF;
             END LOOP;
             
            IF v_count > 7 or v_count > v.rec_count THEN
                v_list.mm_total := v_mm_total;
                IF v_count = 1 THEN
                   v_list.premium_shr2 := v_mm_total;
                END IF; 
                        
                IF v_count = 2 THEN
                    v_list.premium_shr3 := v_mm_total;
                END IF; 
                        
                IF v_count = 3 THEN
                    v_list.premium_shr4 := v_mm_total;
                END IF; 
                        
                IF v_count = 4 THEN
                    v_list.premium_shr5 := v_mm_total;
                END IF;
                        
                IF v_count = 5 THEN
                   v_list.premium_shr6 := v_mm_total;
                END IF; 
                        
                IF v_count = 6 THEN
                   v_list.premium_shr7 := v_mm_total;
                END IF; 
               PIPE ROW (v_list); 
              END IF; 
         v_count := v_count + 1;
          
         END LOOP;
      END LOOP;   

      RETURN;
   END get_giacr136_dtls2;
FUNCTION get_giacr136_dtls3 (
      p_quarter        VARCHAR2,
      p_line_cd        VARCHAR2,
      p_treaty_yy      VARCHAR2,
      p_share_cd       VARCHAR2,
      p_cession_year   VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN get_giacr136_tab PIPELINED
   IS
      v_list        get_giacr136_type;
      v_count       number :=   1;
      v_mm_total    number :=   0;
   BEGIN
      FOR i IN (SELECT cession_year,  cession_mm, line_cd, share_cd, treaty_yy, branch_cd, SUM(premium_amt) premium_per_branch
                  FROM gixx_trty_prem_comm
                 WHERE cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                   AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3) 
                   AND user_id = p_user_id
                   AND share_cd LIKE (NVL (p_share_cd, '%'))
                   --AND share_cd = NVL (p_share_cd, share_cd)
                   AND UPPER(line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
                   --AND line_cd = NVL (UPPER (p_line_cd), line_cd) mk
                   AND cession_year = p_cession_year
              GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd)
      LOOP
         v_list.cession_mm := i.cession_mm;
         v_list.cf_month := (TO_CHAR (TO_DATE (i.cession_mm, 'MM'), 'MONTH'));
         v_list.branch_cd := i.branch_cd;
         v_count :=1;
         FOR v IN (SELECT a.line_cd, a.trty_seq_no, a.trty_yy, NVL( a.prnt_ri_cd,a.ri_cd)prnt_ri_cd, b.ri_sname, SUM(a.trty_shr_pct) shr_pct
                     ,count(1) over() rec_count --added by  MarkS sr5867
                     FROM giis_trty_panel a, 
                            giis_reinsurer b 
                    WHERE b.ri_cd = DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd)
                      AND UPPER(line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
                      AND trty_seq_no LIKE (NVL (p_share_cd, '%'))
                      AND trty_yy = p_treaty_yy
                 GROUP BY a.line_cd, a.trty_seq_no, a.trty_yy, NVL(a.prnt_ri_cd,a.ri_cd), b.ri_sname
                 ORDER BY b.ri_sname)
         LOOP
            v_list.ri_sname := v.ri_sname;
            v_list.shr_pct := v.shr_pct;
            v_list.premium_shr := null;
            
            
            FOR y IN(SELECT cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd, prnt_ri_cd, SUM(premium_amt) premium_shr
                       FROM gixx_trty_prem_comm
                      WHERE user_id = p_user_id
                        AND cession_year = i.cession_year
                        AND cession_mm = i.cession_mm
                        AND line_cd = i.line_cd
                        AND share_cd = i.share_cd
                        AND branch_cd = i.branch_cd
                        AND line_cd = v.line_cd
                        AND share_cd = v.trty_seq_no
                        AND prnt_ri_cd = v.prnt_ri_cd
                   GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd, prnt_ri_cd)
            LOOP
                v_list.premium_shr := y.premium_shr;
                IF v_count <= 7 or v.rec_count > v_count THEN
                    IF v_count = 1 THEN
                        v_list.premium_shr1 := y.premium_shr;
                    END IF; 
                    IF v_count = 2 THEN
                        v_list.premium_shr2 := y.premium_shr;
                    END IF; 
                    IF v_count = 3 THEN
                        v_list.premium_shr3 := y.premium_shr;
                    END IF; 
                    IF v_count = 4 THEN
                        v_list.premium_shr4 := y.premium_shr;
                    END IF;
                    IF v_count = 5 THEN
                        v_list.premium_shr5 := y.premium_shr;
                    END IF; 
                    IF v_count = 6 THEN
                        v_list.premium_shr6 := y.premium_shr;
                    END IF; 
                    IF v_count = 7 THEN
                        v_list.premium_shr7 := y.premium_shr;
                    END IF;  
                    v_mm_total := v_mm_total + y.premium_shr;
                END IF;
                
                    
             END LOOP;
            -- edited by MarkS SR5867 Optimization 
            IF v_count > 1 or v_count> v.rec_count THEN
                v_list.mm_total := v_mm_total;
               PIPE ROW (v_list); 
              END IF; 
         v_count := v_count + 1;
          
         END LOOP;
      END LOOP;   

      RETURN;
   END get_giacr136_dtls3;
   FUNCTION get_giacr136_total (
      p_line_cd        VARCHAR2,
      p_treaty_yy      VARCHAR2,
      p_share_cd       VARCHAR2,
      p_cession_year   VARCHAR2,
      p_quarter        VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN get_giacr136_tab PIPELINED
   IS
      v_list   get_giacr136_type;
      
      -- edited by MarkS SR5867 Optimization 
      v_count       NUMBER :=   1;
      v_mm_total    NUMBER :=   0;
      v_grp_count   NUMBER :=   1;
   BEGIN
      FOR i IN (SELECT cession_year,  cession_mm, line_cd, share_cd, treaty_yy, branch_cd, SUM(premium_amt) premium_per_branch
                  FROM gixx_trty_prem_comm
                 WHERE cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                   AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3) 
                   AND user_id = p_user_id
                   AND share_cd = NVL (p_share_cd, share_cd)
                   AND line_cd = NVL (UPPER (p_line_cd), line_cd)
                   AND cession_year = p_cession_year
              GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd)
      LOOP
         v_list.cession_mm := i.cession_mm;
         v_list.cf_month := (TO_CHAR (TO_DATE (i.cession_mm, 'MM'), 'MONTH'));
         v_count      :=  1;
         v_mm_total   :=  0;
         v_grp_count  :=  1;
         FOR v IN (SELECT a.line_cd, a.trty_seq_no, a.trty_yy, NVL( a.prnt_ri_cd,a.ri_cd)prnt_ri_cd, b.ri_sname, SUM(a.trty_shr_pct) shr_pct
                     ,count(1) over() rec_count --added by  MarkS sr5867
                     FROM giis_trty_panel a, 
                            giis_reinsurer b 
                    WHERE b.ri_cd = DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd)
                      AND line_cd = NVL (UPPER (p_line_cd), line_cd)
                      AND trty_seq_no =  NVL (p_share_cd, trty_seq_no)
                      AND trty_yy = p_treaty_yy
                 GROUP BY a.line_cd, a.trty_seq_no, a.trty_yy, NVL(a.prnt_ri_cd,a.ri_cd), b.ri_sname
                 ORDER BY b.ri_sname)
         LOOP
            v_list.ri_sname := v.ri_sname;
            v_list.shr_pct := v.shr_pct;
            FOR y IN(SELECT cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd, prnt_ri_cd, SUM(premium_amt) premium_shr
                       FROM gixx_trty_prem_comm
                      WHERE user_id = p_user_id
                        AND cession_year = i.cession_year
                        AND cession_mm = i.cession_mm
                        AND line_cd = i.line_cd
                        AND share_cd = i.share_cd
                        AND branch_cd = i.branch_cd
                        AND line_cd = v.line_cd
                        AND share_cd = v.trty_seq_no
                        AND prnt_ri_cd = v.prnt_ri_cd
                   GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd, prnt_ri_cd)
            LOOP
                IF v_count <= 7 or v.rec_count > v_count THEN
                    IF v_count <= 1 THEN
                        v_list.premium_shr1 := y.premium_shr;
                    END IF; 
                    IF v_count = 2 THEN
                        v_list.premium_shr2 := y.premium_shr;
                    END IF; 
                    IF v_count = 3 THEN
                        v_list.premium_shr3 := y.premium_shr;
                    END IF; 
                    IF v_count = 4 THEN
                        v_list.premium_shr4 := y.premium_shr;
                    END IF;
                    IF v_count = 5 THEN
                        v_list.premium_shr5 := y.premium_shr;
                    END IF; 
                    IF v_count = 6 THEN
                        v_list.premium_shr6 := y.premium_shr;
                    END IF; 
                    IF v_count = 7 THEN
                        v_list.premium_shr7 := y.premium_shr;
                    END IF;  
                    v_mm_total := v_mm_total + y.premium_shr;
                END IF;
            END LOOP;
            v_count := v_count + 1;
            IF v_count > 7 or v_count > v.rec_count THEN
                v_list.mm_total := v_mm_total;
               v_list.grp_ris   := p_line_cd || p_share_cd || v_grp_count;
               v_grp_count     := v_grp_count + 1;
               PIPE ROW (v_list);
               v_count := 1; 
              END IF; 
         
         END LOOP;
      END LOOP;   
      RETURN;
   END get_giacr136_total;
END;
/
