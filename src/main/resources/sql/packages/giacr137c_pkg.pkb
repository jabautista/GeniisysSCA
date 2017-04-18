CREATE OR REPLACE PACKAGE BODY CPI.GIACR137C_PKG
AS
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.05.2013
   **  Reference By : GIACR137B (report for GIACS136)
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
    
    FUNCTION cf_quarter(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE    
    )
       RETURN VARCHAR2
    IS
       v_q   VARCHAR2 (30);
    BEGIN
       IF p_quarter = 1 OR p_quarter IS NULL THEN
          v_q := 'FIRST QUARTER ';
       ELSIF p_quarter = 2 THEN
          v_q := 'SECOND QUARTER ';
       ELSIF p_quarter = 3 THEN
          v_q := 'THIRD QUARTER ';
       ELSIF p_quarter = 4 THEN
          v_q := 'FOURTH QUARTER ';
       END IF;

       RETURN (v_q || ' ' || p_cession_year);
    END;

    FUNCTION get_branch_count(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_month         NUMBER
    )
       RETURN VARCHAR2
    IS
       v_count   VARCHAR2 (30);
    BEGIN
        SELECT ROW_NUMBER() OVER (ORDER BY branch_cd) branch_count
          INTO v_count
                   FROM gixx_trty_prem_comm a
                  WHERE a.user_id    = p_user_id  
                    AND a.line_cd    = NVL(p_line_cd,line_cd)
                    AND cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                    AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3) 
                    AND cession_year = TO_NUMBER(NVL(p_cession_year, TO_CHAR(SYSDATE, 'YYYY')))
                    AND cession_mm = p_month
                 HAVING SUM(a.commission_amt) <> 0
               GROUP BY a.branch_cd;
        RETURN (v_count);               
    EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        v_count := 2;
       RETURN (v_count);
    END;    
    
    FUNCTION get_main_report(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN main_report_record_tab PIPELINED
    IS
        v_rep   main_report_record_type;
        v_header       BOOLEAN := TRUE;
    BEGIN
        v_rep.company_name    := cf_company_name;
        v_rep.company_address := cf_company_address;
        
        FOR q IN(SELECT a.line_cd, b.trty_name, d.line_name || ' - ' || b.trty_name line_trty_name, a.cession_year,  a.share_cd, 
                        DECODE(TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH'),
                                                                          LAG(TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH'),1,0) OVER(ORDER BY  a.share_cd, a.cession_mm, branch_cd),DECODE(a.share_cd,LAG(a.share_cd,1,0) OVER(ORDER BY  a.share_cd, a.cession_mm, branch_cd),
                                                                                                                                                                                                                                                                            NULL,TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH')),TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH')) month,-- added by MarkS SR5867  
                        a.cession_mm,
                        DECODE(a.branch_cd,LAG(a.branch_cd,1,0) OVER(ORDER BY  a.share_cd, a.cession_mm, branch_cd), DECODE(a.share_cd,LAG(a.share_cd,1,0) OVER(ORDER BY  a.share_cd, a.cession_mm, branch_cd),NULL,branch_cd), a.branch_cd) branch_cd_dum,
                        a.branch_cd, 
                        a.prnt_ri_cd, c.ri_sname, a.trty_shr_pct, SUM(a.commission_amt) commission
                   FROM gixx_trty_prem_comm a,
                        giis_dist_share b,
                        giis_reinsurer c,
                        giis_line d
                  WHERE a.user_id    = p_user_id  
                    AND a.line_cd    = b.line_cd
                    AND a.line_cd    = d.line_cd
                    AND a.line_cd    = NVL(p_line_cd,b.line_cd)
                    AND a.share_cd   = b.share_cd
                    AND a.treaty_yy  = b.trty_yy
                    AND a.prnt_ri_cd = c.ri_cd
                    AND cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                    AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3) 
                    AND cession_year = TO_NUMBER(NVL(p_cession_year, TO_CHAR(SYSDATE, 'YYYY')))
                 HAVING SUM(a.commission_amt) <> 0
               GROUP BY a.share_cd, a.line_cd, d.line_name, b.trty_name, a.cession_year,  a.cession_mm,  a.branch_cd, a.prnt_ri_cd, c.ri_sname, a.trty_shr_pct, a.share_cd
               ORDER BY  a.share_cd, a.cession_mm, branch_cd)
        LOOP
            v_header := FALSE;
            v_rep.header_flag := 'N';
            v_rep.quarter         := cf_quarter(p_quarter, p_cession_year);
            v_rep.line_cd         := q.line_cd;
            v_rep.trty_name       := q.trty_name;
            v_rep.line_trty_name  := q.line_trty_name;
            v_rep.cession_year    := q.cession_year;
            v_rep.cf_month        := q.month;
            v_rep.cession_mm      := q.cession_mm;
            v_rep.branch_cd       := q.branch_cd;    
            v_rep.commmission     := q.commission;
            v_rep.share_cd        := q.share_cd;
            -- added by MarkS SR5867 
            v_rep.branch_cd_dum   := q.branch_cd_dum;
            v_rep.prnt_ri_cd      := q.prnt_ri_cd;
            v_rep.ri_sname        := q.ri_sname;
            v_rep.trty_shr_pct    := q.trty_shr_pct;
            --
            PIPE ROW(v_rep);    
        END LOOP;
        
        IF v_header THEN
            v_rep.header_flag  := 'Y';
            PIPE ROW(v_rep);
        END IF;         
    END get_main_report;

    FUNCTION get_report_detail(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN report_detail_record_tab PIPELINED
    IS
        v_rep   report_detail_record_type;
    BEGIN
        FOR q IN(SELECT distinct a.line_cd, b.trty_name, d.line_name || ' - ' || b.trty_name line_trty_name, a.cession_year,  a.trty_com_rt, a.share_cd,
                        TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH') month, a.cession_mm, a.branch_cd,
                        a.prnt_ri_cd, c.ri_sname, a.trty_shr_pct, SUM(a.commission_amt) commission
                   FROM gixx_trty_prem_comm a,
                        giis_dist_share b,
                        giis_reinsurer c,
                        giis_line d
                  WHERE a.user_id    = p_user_id  
                    AND a.line_cd    = b.line_cd
                    AND a.line_cd    = d.line_cd
                    AND a.line_cd    = NVL(p_line_cd,b.line_cd)
                    AND a.share_cd   = b.share_cd
                    AND a.treaty_yy  = b.trty_yy
                    AND a.prnt_ri_cd = c.ri_cd
                    AND cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                    AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3) 
                    AND cession_year = TO_NUMBER(NVL(p_cession_year, TO_CHAR(SYSDATE, 'YYYY')))
                 HAVING SUM(a.commission_amt) <> 0
               GROUP BY a.share_cd, a.line_cd, d.line_name, b.trty_name, a.cession_year,  a.cession_mm,  a.branch_cd, a.prnt_ri_cd, c.ri_sname, a.trty_shr_pct, a.share_cd
               ORDER BY a.share_cd, a.cession_mm, c.ri_sname)
        LOOP
            v_rep.cession_mm      := q.cession_mm;
            v_rep.branch_cd       := q.branch_cd;          
            v_rep.prnt_ri_cd      := q.prnt_ri_cd;
            v_rep.ri_sname        := q.ri_sname;
            v_rep.trty_shr_pct    := q.trty_shr_pct;
            v_rep.commmission     := q.commission;
            v_rep.share_cd        := q.share_cd;
            v_rep.branch_count    := get_branch_count(p_quarter, p_cession_year, p_line_cd, p_user_id, q.cession_mm);    
            PIPE ROW(v_rep);
            
        END LOOP;
                
    END get_report_detail;
    
    FUNCTION get_report_recap(
        p_quarter       gixx_trty_prem_comm.cession_mm%TYPE,
        p_cession_year  gixx_trty_prem_comm.cession_year%TYPE,
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN report_recap_record_tab PIPELINED
    IS
        v_rep   report_recap_record_type; 
    BEGIN
        FOR q IN(SELECT DISTINCT a.line_cd, b.trty_name, a.cession_year,  a.share_cd,
                        TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH') month, a.cession_mm
                   FROM gixx_trty_prem_comm a,
                        giis_dist_share b,
                        giis_reinsurer c,
                        giis_line d
                  WHERE a.user_id    = p_user_id  
                    AND a.line_cd    = b.line_cd
                    AND a.line_cd    = d.line_cd
                    AND a.line_cd    = NVL(p_line_cd,b.line_cd)
                    AND a.share_cd   = b.share_cd
                    AND a.treaty_yy  = b.trty_yy
                    AND a.prnt_ri_cd = c.ri_cd
                    AND cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2 
                    AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3) 
                    AND cession_year = TO_NUMBER(NVL(p_cession_year, TO_CHAR(SYSDATE, 'YYYY')))
                 HAVING SUM(a.commission_amt) <> 0
               GROUP BY a.share_cd, a.line_cd, d.line_name, b.trty_name, a.cession_year,  a.cession_mm,  a.branch_cd
               ORDER BY  a.share_cd, a.cession_mm)
        LOOP
            
            FOR w IN(SELECT DISTINCT a.line_cd line_cd_grand, c.trty_name, a.cession_year, a.cession_mm,
                                     TO_CHAR(TO_DATE(cession_mm,'MM'),'MONTH') month_grand, 
                                     b.ri_sname ri_sname_grand, SUM(a.commission_amt) commission_grand, a.share_cd
                                FROM gixx_trty_prem_comm a, 
                                     giis_reinsurer b, 
                                     giis_dist_share c
                               WHERE a.prnt_ri_cd = b.ri_cd    
                                 AND a.line_cd = c.line_cd
                                 AND a.share_cd = c.share_cd
                                 AND a.treaty_yy = c.trty_yy
                                 AND a.line_cd = NVL(p_line_cd,a.line_cd)
                                 AND a.cession_year = NVL(p_cession_year,a.cession_year)   
                                 AND cession_mm  BETWEEN DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3)-2
                                 AND DECODE(p_quarter,1,3,2,6,3,9,4,12,NULL,3) 
                                 AND a.user_id = p_user_id
                                 AND a.line_cd = q.line_cd
                                 AND cession_mm = q.cession_mm
                                 AND a.cession_year = q.cession_year
                                 AND c.trty_name = q.trty_name
                                 AND a.cession_mm = q.cession_mm
                                 AND TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH') = q.month 
                            GROUP BY a.line_cd, c.trty_name, a.cession_year, a.cession_mm,  b.ri_sname, a.share_cd
                            ORDER BY a.line_cd, c.trty_name, a.cession_year, a.cession_mm,  b.ri_sname, a.share_cd)
            LOOP
                v_rep.line_cd_grand     := w.line_cd_grand;
                v_rep.trty_name1        := w.trty_name;
                v_rep.cession_year1     := w.cession_year;
                v_rep.cession_mm1       := w.cession_mm;
                v_rep.month_grand       := w.month_grand;
                v_rep.ri_sname_grand    := w.ri_sname_grand;
                v_rep.commission_grand  := w.commission_grand;
                v_rep.share_cd          := w.share_cd; 
                PIPE ROW(v_rep);
            END LOOP;           
        END LOOP;
    END get_report_recap;   

END GIACR137C_PKG;
/
