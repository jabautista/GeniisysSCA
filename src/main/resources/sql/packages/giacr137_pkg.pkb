CREATE OR REPLACE PACKAGE BODY CPI.GIACR137_PKG
AS
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.05.2013
   **  Reference By : GIACR137A (report for GIACS136)
   */    
    FUNCTION cf_company_name
       RETURN CHAR
    IS
       v_company_name   giis_parameters.param_value_v%TYPE;
    BEGIN
       FOR i IN (SELECT param_value_v
                   FROM giis_parameters
                  WHERE param_name = 'COMPANY_NAME')
       LOOP
          v_company_name := i.param_value_v;
          EXIT;
       END LOOP;

       RETURN (v_company_name);
    END cf_company_name;    

    FUNCTION cf_company_address
       RETURN CHAR
    IS
       v_company_address   giac_parameters.param_value_v%TYPE;
    BEGIN
       BEGIN
          SELECT param_value_v
            INTO v_company_address
            FROM giac_parameters
           WHERE param_name = 'COMPANY_ADDRESS';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             v_company_address := ' ';
       END;

       RETURN (v_company_address);
    END;
    
    FUNCTION get_main_report(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd      gixx_trty_prem_comm.share_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN main_report_record_tab PIPELINED
    IS
        v_rep   main_report_record_type;
        v_header                BOOLEAN         := TRUE;
        v_count                 NUMBER          := 1;
        v_grp_count             NUMBER          := 0;
        v_mm_total              NUMBER          :=   0;
        last_val_cf_month       VARCHAR2(100)   := null;
    BEGIN
        v_rep.company_name      := cf_company_name;
        v_rep.company_address   := cf_company_address;  
          
        FOR q IN(SELECT cession_year, a.line_cd, a.share_cd, treaty_yy,
                        DECODE(p_quarter,
                                1, 'FIRST QUARTER',
                                2, 'SECOND QUARTER',
                                3, 'THIRD QUARTER',
                                4, 'FOURTH QUARTER')
                        ||' '||cession_year quarter_year,
                        c.line_name||' - '||b.trty_name line_treaty, 
                        a.trty_com_rt
                   FROM giis_line c,
                        giis_dist_share b,
                        gixx_trty_prem_comm a       
                  WHERE 1=1 
                    AND a.line_cd = b.line_cd 
                    AND a.share_cd = b.share_cd 
                    AND a.treaty_yy = b.trty_yy 
                    AND a.line_cd = c.line_cd 
                    AND a.share_cd = NVL(p_share_cd, a.share_cd)  
                    AND a.line_cd = NVL(UPPER(p_line_cd), a.line_cd) 
                    AND a.cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                    AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3) 
                    AND a.cession_year = TO_NUMBER(NVL(p_cession_year, TO_CHAR(SYSDATE, 'YYYY'))) 
                    AND NVL(a.commission_amt,0) <> 0 
                    AND a.user_id = p_user_id
               GROUP BY a.cession_year, a.line_cd, line_name, a.share_cd, a.treaty_yy, b.trty_name, a.trty_com_rt
               ORDER BY a.cession_year, a.line_cd, line_name, a.share_cd, a.treaty_yy, b.trty_name, a.trty_com_rt)
        
        LOOP
            v_header := FALSE;
            v_rep.header_flag := 'N';        
            v_rep.cession_year      := q.cession_year;
            v_rep.line_cd           := q.line_cd;
            v_rep.share_cd          := q.share_cd;
            v_rep.treaty_yy         := q.treaty_yy;
            v_rep.quarter_year      := q.quarter_year;
            v_rep.line_treaty       := q.line_treaty;
            
            FOR w IN(SELECT cession_year, cession_mm, line_cd, share_cd, 
                            treaty_yy, branch_cd,
                            SUM(commission_amt) comm_per_branch
                       FROM gixx_trty_prem_comm
                      WHERE cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                        AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)
                        AND user_id = p_user_id 
                        AND line_cd = q.line_cd
                        AND cession_year = q.cession_year
                        AND share_cd = q.share_cd
                        AND trty_com_rt = q.trty_com_rt
                   GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd
                   ORDER BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd)
            LOOP
                v_rep.cf_month          := TO_CHAR(TO_DATE(w.cession_mm,'MM'),'MONTH');
                v_rep.cf_month_dum  := v_rep.cf_month;
                v_rep.comm_per_branch   := w.comm_per_branch;
                v_rep.cession_year1     := w.cession_year;
                v_rep.cession_mm1       := w.cession_mm;
                v_rep.line_cd1          := w.line_cd;
                v_rep.share_cd1         := w.share_cd;
                v_rep.branch_cd1        := w.branch_cd;
                v_rep.branch_cd         := w.branch_cd;
                v_count                 :=  1;
                v_mm_total              :=  0;
                v_grp_count             :=  1;
                --added by MarkS SR-5867
                FOR x IN(SELECT a.line_cd, a.trty_seq_no, a.trty_yy, NVL( a.prnt_ri_cd,a.ri_cd)prnt_ri_cd, 
                            b.ri_sname, SUM(a.trty_shr_pct) shr_pct,count(1) over() rec_count
                       FROM giis_trty_panel a, 
                            giis_reinsurer b 
                      WHERE b.ri_cd = DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd)
                        AND a.line_cd = v_rep.line_cd
                        AND a.trty_seq_no = v_rep.share_cd
                        AND trty_yy = w.treaty_yy
                   GROUP BY a.line_cd, a.trty_seq_no, a.trty_yy, NVL(a.prnt_ri_cd,a.ri_cd), b.ri_sname
                   ORDER BY ri_sname, shr_pct)
                LOOP
                    v_rep.share_pct     := TO_CHAR(x.shr_pct);
                    v_rep.ri_sname      := x.ri_sname;
                    v_rep.trty_seq_no2  := x.trty_seq_no;
                    v_rep.commission    := null;
                    
                    FOR e IN(SELECT cession_year, cession_mm, line_cd, share_cd, treaty_yy, 
                                    branch_cd, prnt_ri_cd, SUM(commission_amt)  commission
                               FROM gixx_trty_prem_comm
                              WHERE user_id = p_user_id
                               AND cession_year = q.cession_year
                               AND cession_mm = w.cession_mm    
                               AND line_cd = q.line_cd
                               AND share_cd = q.SHARE_CD
                               AND branch_cd    = w.branch_cd
                               AND line_cd = w.line_cd
                               AND share_cd = x.trty_seq_no
                               AND prnt_ri_cd = x.prnt_ri_cd
                               AND trty_com_rt = q.trty_com_rt
                           GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd, prnt_ri_cd)
                    LOOP
                        v_rep.commission := e.commission;
                        IF v_count <= 7 or x.rec_count > v_count THEN
                        
                            IF v_count = 1 THEN
                                v_rep.commission1 := e.commission;
                            END IF; 
                            IF v_count = 2 THEN
                                v_rep.commission2 := e.commission;
                            END IF; 
                            IF v_count = 3 THEN
                                v_rep.commission3 := e.commission;
                            END IF; 
                            IF v_count = 4 THEN
                                v_rep.commission4 := e.commission;
                            END IF;
                            IF v_count = 5 THEN
                                v_rep.commission5 := e.commission;
                            END IF; 
                            IF v_count = 6 THEN
                                v_rep.commission6 := e.commission;
                            END IF; 
                            IF v_count = 7 THEN
                                v_rep.commission7 := e.commission;
                            END IF;  
                            v_mm_total := v_mm_total + e.commission;
                        END IF;
                        --PIPE ROW(v_rep);
                    END LOOP;
                    v_count := v_count + 1;
                    IF v_count > 7 or v_count > x.rec_count   THEN
                        v_rep.mm_total := v_mm_total;
                        IF v_count = 2 THEN
                           v_rep.commission2 := v_mm_total;
                        END IF; 
                                
                        IF v_count = 3 THEN
                            v_rep.commission3 := v_mm_total;
                        END IF; 
                                
                        IF v_count = 4 THEN
                            v_rep.commission4 := v_mm_total;
                        END IF; 
                                
                        IF v_count = 5 THEN
                            v_rep.commission5 := v_mm_total;
                        END IF;
                                
                        IF v_count = 6 THEN
                           v_rep.commission6 := v_mm_total;
                        END IF; 
                                
                        IF v_count = 7 THEN
                           v_rep.commission7 := v_mm_total;
                        END IF; 
                        v_rep.grp_ris := v_rep.line_cd1 || v_rep.share_cd || v_grp_count;
                        v_grp_count := v_grp_count +1;
                       PIPE ROW (v_rep); 
                       v_count := 1;
                    END IF; 
                 
                    --PIPE ROW(v_rep);                
                END LOOP; 
                
                
                --PIPE ROW(v_rep); --Commented out by MarkS SR-5867
                --end 
                
                
                
            END LOOP;  
                
        END LOOP;
       IF v_header THEN
            v_rep.header_flag  := 'Y';
            PIPE ROW(v_rep);
       END IF;   
               
    END get_main_report;

    FUNCTION get_report_header(
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd      gixx_trty_prem_comm.share_cd%TYPE,
        p_treaty_yy     giis_trty_panel.trty_yy%TYPE
    )
        RETURN report_detail_record_tab PIPELINED
    IS
        v_rep                   report_detail_record_type;
        v_count                 NUMBER          := 1;
        v_grp_count             NUMBER          := 1;
    BEGIN
        
        FOR q IN(SELECT a.line_cd, a.trty_seq_no, a.trty_yy, NVL( a.prnt_ri_cd,a.ri_cd)prnt_ri_cd, 
                        b.ri_sname, SUM(a.trty_shr_pct) shr_pct,count(1) over() rec_count
                   FROM giis_trty_panel a, 
                          giis_reinsurer b 
                  WHERE b.ri_cd = DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd)
                    AND a.line_cd = p_line_cd
                    AND a.trty_seq_no = p_share_cd
                    AND trty_yy = p_treaty_yy
               GROUP BY a.line_cd, a.trty_seq_no, a.trty_yy, NVL(a.prnt_ri_cd,a.ri_cd), b.ri_sname
               ORDER BY ri_sname, shr_pct)
        LOOP
            v_rep.line_cd2     := q.line_cd;
            v_rep.trty_seq_no2 := q.trty_seq_no;
            v_rep.prnt_ri_cd2  := q.prnt_ri_cd;
            v_rep.ri_sname     := q.ri_sname;
            v_rep.share_pct    := TO_CHAR(q.shr_pct);
            --added by MarkS SR-5867
            IF v_count <= 7 or q.rec_count > v_count THEN
                
                IF v_count = 1 THEN
                    v_rep.ri_sname1 := q.ri_sname;
                    v_rep.shr_pct1 := q.shr_pct;
                END IF; 
                IF v_count = 2 THEN
                    v_rep.ri_sname2 := q.ri_sname;
                    v_rep.shr_pct2 := q.shr_pct;
                END IF; 
                IF v_count = 3 THEN
                    v_rep.ri_sname3 := q.ri_sname;
                    v_rep.shr_pct3 := q.shr_pct;
                END IF; 
                
                IF v_count = 4 THEN
                    v_rep.ri_sname4 := q.ri_sname;
                    v_rep.shr_pct4 := q.shr_pct;
                END IF;
                
                IF v_count = 5 THEN
                    v_rep.ri_sname5 := q.ri_sname;
                    v_rep.shr_pct5 := q.shr_pct;
                END IF; 
                IF v_count = 6 THEN
                    v_rep.ri_sname6 := q.ri_sname;
                    v_rep.shr_pct6 := q.shr_pct;
                END IF; 
                
                IF v_count = 7 THEN
                    v_rep.ri_sname7 := q.ri_sname;
                    v_rep.shr_pct7 := q.shr_pct;
                END IF; 
                v_count := v_count + 1;
                IF v_count > 7 or v_count > q.rec_count  THEN
                
                    IF v_count = 1 THEN
                        v_rep.ri_sname1 := 'TOTAL';
                        v_rep.shr_pct1 := 100;
                    END IF; 
                    
                    IF v_count = 2 THEN
                        v_rep.ri_sname2 := 'TOTAL';
                        v_rep.shr_pct2 := 100;
                    END IF; 
                    
                    IF v_count = 3 THEN
                        v_rep.ri_sname3 := 'TOTAL';
                        v_rep.shr_pct3 := 100;
                    END IF; 
                    
                    IF v_count = 4 THEN
                        v_rep.ri_sname4 := 'TOTAL';
                        v_rep.shr_pct4 := 100;
                    END IF;
                    
                    IF v_count = 5 THEN
                        v_rep.ri_sname5 := 'TOTAL';
                        v_rep.shr_pct5 :=100;
                    END IF; 
                    
                    IF v_count = 6 THEN
                        v_rep.ri_sname6 := 'TOTAL';
                        v_rep.shr_pct6 := 100;
                    END IF;
                    
                    IF v_count = 7 THEN
                        v_rep.ri_sname7 := 'TOTAL';
                        v_rep.shr_pct7 := 100;
                    END IF;
                    
                    v_rep.grp_ris := v_rep.line_cd2 || p_share_cd || v_grp_count;
                    v_grp_count := v_grp_count +1;
                    PIPE ROW (v_rep);  
                    v_count := 1;
                END IF; 
             END IF; 
            --PIPE ROW(v_rep);
        END LOOP;
        
    END get_report_header;    

    FUNCTION get_report_detail(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_treaty_yy     giis_trty_panel.trty_yy%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd      gixx_trty_prem_comm.share_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_trty_com_rt   gixx_trty_prem_comm.trty_com_rt%TYPE
    )
        RETURN report_detail_record_tab PIPELINED
    IS
        v_rep   report_detail_record_type;
        --added by MarkS SR-5867
        v_count                 NUMBER          := 1;
        v_grp_count             NUMBER          := 0;
        v_mm_total              NUMBER          :=   0;
        last_val_cf_month       VARCHAR2(100)   := null;
        --
    BEGIN
        FOR q IN(SELECT cession_year, cession_mm, line_cd, share_cd, treaty_yy, 
                        branch_cd, SUM(commission_amt) comm_per_branch
                       FROM gixx_trty_prem_comm
                      WHERE cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                        AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)
                        AND user_id = p_user_id 
                        AND line_cd = NVL(p_line_cd, line_cd)
                        AND cession_year = p_cession_year
                        AND share_cd = NVL(p_share_cd,share_cd)
                        AND trty_com_rt = p_trty_com_rt
                   GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd)
        LOOP
            v_rep.branch_cd  := q.branch_cd;
            v_rep.cession_mm := q.cession_mm;
            v_rep.cf_month   := TO_CHAR(TO_DATE(q.cession_mm,'MM'),'MONTH');
            v_count := 1;
            v_grp_count             := 1;
            
            FOR w IN(SELECT a.line_cd, a.trty_seq_no, a.trty_yy, NVL( a.prnt_ri_cd,a.ri_cd)prnt_ri_cd, 
                            b.ri_sname, SUM(a.trty_shr_pct) shr_pct, count(1) over() rec_count
                       FROM giis_trty_panel a, 
                            giis_reinsurer b 
                      WHERE b.ri_cd = DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd)
                        AND a.line_cd = NVL(p_line_cd,a.line_cd)
                        AND a.trty_seq_no = NVL(p_share_cd,a.TRTY_SEQ_NO)
                        AND trty_yy = p_treaty_yy
                   GROUP BY a.line_cd, a.trty_seq_no, a.trty_yy, NVL(a.prnt_ri_cd,a.ri_cd), b.ri_sname
                   ORDER BY ri_sname, shr_pct)
            LOOP
                v_rep.share_pct     := TO_CHAR(w.shr_pct);
                v_rep.ri_sname      := w.ri_sname;
                v_rep.trty_seq_no2  := w.trty_seq_no;
                
                FOR e IN(SELECT cession_year, cession_mm, line_cd, share_cd, treaty_yy, 
                                trty_com_rt, branch_cd, prnt_ri_cd, SUM(commission_amt)  commission
                           FROM gixx_trty_prem_comm
                          WHERE user_id = p_user_id
                           AND cession_year = q.cession_year
                           AND cession_mm = q.cession_mm    
                           AND line_cd = NVL(p_line_cd,q.line_cd)
                           AND share_cd = NVL(p_share_cd,q.SHARE_CD)
                           AND branch_cd    = q.branch_cd
                           AND line_cd = NVL(p_line_cd,w.line_cd)
                           AND share_cd = w.trty_seq_no
                           AND prnt_ri_cd = w.prnt_ri_cd
                       GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd, prnt_ri_cd)
                LOOP
                    v_rep.commission := e.commission;
                    --PIPE ROW(v_rep);
                    --added by MarkS SR-5867
                    IF v_count <= 7 or w.rec_count > v_count THEN
                        
                            IF v_count = 1 THEN
                                v_rep.commission1 := e.commission;
                            END IF; 
                            IF v_count = 2 THEN
                                v_rep.commission2 := e.commission;
                            END IF; 
                            IF v_count = 3 THEN
                                v_rep.commission3 := e.commission;
                            END IF; 
                            IF v_count = 4 THEN
                                v_rep.commission4 := e.commission;
                            END IF;
                            IF v_count = 5 THEN
                                v_rep.commission5 := e.commission;
                            END IF; 
                            IF v_count = 6 THEN
                                v_rep.commission6 := e.commission;
                            END IF; 
                            IF v_count = 7 THEN
                                v_rep.commission7 := e.commission;
                            END IF;  
                            v_mm_total := v_mm_total + e.commission;
                        END IF;
                    --
                END LOOP;
                    --added by MarkS SR-5867
                v_count := v_count + 1;
                IF v_count > 7 or v_count> w.rec_count THEN
                   v_rep.grp_ris := p_line_cd || p_share_cd || v_grp_count;
                   v_grp_count := v_grp_count +1;
                   PIPE ROW (v_rep);
                   v_count      :=  1; 
                END IF; 
                 
            END LOOP; 
        END LOOP;
                 
    END get_report_detail;

    FUNCTION get_report_column_detail(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_treaty_yy     giis_trty_panel.trty_yy%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd      gixx_trty_prem_comm.share_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_trty_com_rt   gixx_trty_prem_comm.trty_com_rt%TYPE
    )
        RETURN report_detail_record_tab PIPELINED
    IS
        v_rep   report_detail_record_type;
        v_count  number := 1;
        v_mm_total    number :=   0;
    BEGIN
        FOR q IN(SELECT cession_year, cession_mm, line_cd, share_cd, treaty_yy, 
                        branch_cd, SUM(commission_amt) comm_per_branch
                       FROM gixx_trty_prem_comm
                      WHERE cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                        AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)
                        AND user_id = p_user_id 
                        AND line_cd = NVL(p_line_cd, line_cd)
                        AND cession_year = p_cession_year
                        AND share_cd = NVL(p_share_cd,share_cd)
                        AND trty_com_rt = p_trty_com_rt
                   GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd)
        LOOP
            v_rep.branch_cd  := q.branch_cd;
            v_rep.cession_mm := q.cession_mm;
            v_rep.cf_month   := TO_CHAR(TO_DATE(q.cession_mm,'MM'),'MONTH');
            v_count :=1;
            FOR w IN(SELECT a.line_cd, a.trty_seq_no, a.trty_yy, NVL( a.prnt_ri_cd,a.ri_cd)prnt_ri_cd, 
                            b.ri_sname, SUM(a.trty_shr_pct) shr_pct, count(1) over() rec_count
                       FROM giis_trty_panel a, 
                            giis_reinsurer b 
                      WHERE b.ri_cd = DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd)
                        AND a.line_cd = NVL(p_line_cd,a.line_cd)
                        AND a.trty_seq_no = NVL(p_share_cd,a.TRTY_SEQ_NO)
                        AND trty_yy = p_treaty_yy
                   GROUP BY a.line_cd, a.trty_seq_no, a.trty_yy, NVL(a.prnt_ri_cd,a.ri_cd), b.ri_sname
                   ORDER BY ri_sname, shr_pct)
            LOOP
                v_rep.share_pct     := TO_CHAR(w.shr_pct);
                v_rep.ri_sname      := w.ri_sname;
                v_rep.trty_seq_no2  := w.trty_seq_no;
                v_rep.commission    := null;
                
                FOR e IN(SELECT cession_year, cession_mm, line_cd, share_cd, treaty_yy, 
                                trty_com_rt, branch_cd, prnt_ri_cd, SUM(commission_amt)  commission
                           FROM gixx_trty_prem_comm
                          WHERE user_id = p_user_id
                           AND cession_year = q.cession_year
                           AND cession_mm = q.cession_mm    
                           AND line_cd = NVL(p_line_cd,q.line_cd)
                           AND share_cd = NVL(p_share_cd,q.SHARE_CD)
                           AND branch_cd    = q.branch_cd
                           AND line_cd = NVL(p_line_cd,w.line_cd)
                           AND share_cd = w.trty_seq_no
                           AND prnt_ri_cd = w.prnt_ri_cd
                       GROUP BY cession_year, cession_mm, line_cd, share_cd, treaty_yy, branch_cd, prnt_ri_cd)
                LOOP
                    v_rep.commission := e.commission;
                    --added by MarkS SR-5867
                    IF v_count <= 7 or w.rec_count > v_count THEN
                        
                            IF v_count = 1 THEN
                                v_rep.commission1 := e.commission;
                            END IF; 
                            IF v_count = 2 THEN
                                v_rep.commission2 := e.commission;
                            END IF; 
                            IF v_count = 3 THEN
                                v_rep.commission3 := e.commission;
                            END IF; 
                            IF v_count = 4 THEN
                                v_rep.commission4 := e.commission;
                            END IF;
                            IF v_count = 5 THEN
                                v_rep.commission5 := e.commission;
                            END IF; 
                            IF v_count = 6 THEN
                                v_rep.commission6 := e.commission;
                            END IF; 
                            IF v_count = 7 THEN
                                v_rep.commission7 := e.commission;
                            END IF;  
                            v_mm_total := v_mm_total + e.commission;
                        END IF;
                END LOOP;
                --added by MarkS SR-5867
                IF v_count = 7 or v_count > w.rec_count THEN
                    v_rep.mm_total := v_mm_total;
                    IF v_count = 1 THEN
                       v_rep.commission2 := v_mm_total;
                    END IF; 
                                
                    IF v_count = 2 THEN
                        v_rep.commission3 := v_mm_total;
                    END IF; 
                                
                    IF v_count = 3 THEN
                        v_rep.commission4 := v_mm_total;
                    END IF; 
                                
                    IF v_count = 4 THEN
                        v_rep.commission5 := v_mm_total;
                    END IF;
                                
                    IF v_count = 5 THEN
                       v_rep.commission6 := v_mm_total;
                    END IF; 
                                
                    IF v_count = 6 THEN
                       v_rep.commission7 := v_mm_total;
                    END IF; 
                   PIPE ROW (v_rep); 
                END IF; 
                 v_count := v_count + 1;
                --
                --PIPE ROW(v_rep); --commented out by MarkS SR5867 Optimization                
            END LOOP; 
        END LOOP;
                 
    END get_report_column_detail;
END GIACR137_PKG;
/
