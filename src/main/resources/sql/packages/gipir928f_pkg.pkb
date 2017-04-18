CREATE OR REPLACE PACKAGE BODY CPI.GIPIR928F_PKG
AS
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 1/3/2013
   **  Reference By : GIPIR928F - Distribution Report(Detailed)
   */

    FUNCTION get_page_header(
        p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
        p_iss_param     NUMBER,
        p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
        p_scope         NUMBER,
        p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
        p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE
    )
        RETURN report_tab PIPELINED
    AS
        report          report_type;
        v_param_date    NUMBER(1);
        v_exists   BOOLEAN  := FALSE;

    BEGIN
        
       FOR i IN (SELECT DISTINCT DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd,
                        DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd_header,
                        INITCAP(f.iss_name) iss_name,
                        b.line_cd line_cd,
                        INITCAP(e.line_name) line_name,
                        b.subline_cd subline_cd,
                        INITCAP(d.subline_name) subline_name,
                        b.policy_no policy_no,
                        b.policy_id policy_id,
                        b.share_cd,
                        SUM(NVL(nr_dist_prem,0) + NVL(tr_dist_prem,0) + NVL(fa_dist_prem,0)) prem_amt,
                        SUM(DECODE(b.peril_type,'B',NVL(nr_dist_tsi,0),0) +
                            DECODE(b.peril_type,'B',NVL(tr_dist_tsi,0),0) +
                            DECODE(b.peril_type,'B',NVL(fa_dist_tsi,0),0)) tsi_amt
                   FROM GIPI_UWREPORTS_DIST_PERIL_EXT b,  
                        GIIS_SUBLINE d,
                        GIIS_LINE e,
                        GIIS_ISSOURCE f
                  WHERE 1 = 1
                    AND b.line_cd = d.line_cd
                    AND b.subline_cd = d.subline_cd
                    AND b.line_cd = e.line_cd 
                    AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = f.iss_cd
                    AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                    AND b.line_cd = NVL(UPPER(p_line_cd),b.line_cd)
                    AND b.user_id = p_user_id
                    AND ((p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                        OR  (p_scope = 1 AND b.endt_seq_no=0)
                        OR  (p_scope = 2 AND b.endt_seq_no>0))
                    AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                    AND policy_id = policy_id
               GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd),
                        DECODE(p_iss_param,1,b.cred_branch,b.iss_cd),
                        b.line_cd,
                        e.line_name,
                        f.iss_name,
                        b.subline_cd,
                        d.subline_name,
                        b.policy_no,
                        b.policy_id,
                        b.share_cd
               ORDER BY iss_cd, iss_cd_header, line_name, line_cd, subline_cd, subline_name, policy_no)
        LOOP
            report.iss_cd           := i.iss_cd;
            report.iss_cd_header    := i.iss_cd_header;
            report.iss_name         := i.iss_name;
            report.line_cd          := i.line_cd;
            report.line_name        := i.line_name;
            report.subline_cd       := i.subline_cd;
            report.subline_name     := i.subline_name;
            report.policy_no        := i.policy_no;
            report.policy_id        := i.policy_id;
            report.share_cd         := i.share_cd; 
            report.prem_amt         := i.prem_amt;
            report.tsi_amt          := i.tsi_amt;
            report.company_name     := giisp.v('COMPANY_NAME');
            report.company_address  := giisp.v('COMPANY_ADDRESS');
            
            BEGIN
                SELECT iss_name
                  INTO report.iss_name
                  FROM giis_issource
                 WHERE iss_cd = report.iss_cd_header;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    report.iss_name := NULL;
            END;

            BEGIN
                IF p_iss_param = 1
                THEN
                    report.iss_header := 'Crediting Branch';
                ELSIF p_iss_param = 2
                THEN    
                    report.iss_header := 'Issue Source';
                ELSE
                    report.iss_header := NULL;
                END IF;
            END;            
            
            BEGIN
                IF p_scope = 1 then
                    report.toggle := 'Policies Only';
                ELSIF p_scope = 2 then
                    report.toggle := 'Endorsements Only';
                ELSIF p_scope = 3 then
                    report.toggle := 'Policies and Endorsements';
                END IF;
            END;
            
            BEGIN
                SELECT from_date1
                  INTO report.date_from
                  FROM gipi_uwreports_dist_peril_ext
                 WHERE user_id = p_user_id
                   AND ROWNUM = 1;
            END;
            
            BEGIN
                SELECT to_date1
                  INTO report.date_to
                  FROM gipi_uwreports_dist_peril_ext
                 WHERE user_id = p_user_id
                   AND ROWNUM = 1;
            END;
            
            BEGIN
                SELECT param_date
                  INTO v_param_date
                  FROM gipi_uwreports_dist_peril_ext
                 WHERE user_id = p_user_id
                   AND ROWNUM = 1;

                IF v_param_date = 1 THEN
                    report.based_on := 'Based on Issue Date';
                ELSIF v_param_date = 2 THEN
                    report.based_on := 'Based on Inception Date';
                ELSIF v_param_date = 3 THEN
                    report.based_on := 'Based on Booking month - year';
                ELSIF v_param_date = 4 THEN
                    report.based_on := 'Based on Acctg Entry Date';
                END IF;
             
            END;
            
            BEGIN
                FOR k IN (SELECT report_title
                            FROM giis_reports
                           WHERE report_id = 'GIPIR928F')
                LOOP
                    report.reportnm := k.report_title;
                    v_exists := TRUE;
                EXIT;
                END LOOP;

                IF v_exists
                THEN
                    report.reportnm := report.reportnm;
                ELSE
                    report.reportnm := 'No report found in GIIS_REPORTS';
                END IF;
            END;
            
            PIPE ROW(report);
            
        END LOOP;
        
        RETURN;    
    
    END;

    FUNCTION get_policy_detail (
        p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
        p_iss_param     NUMBER,
        p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
        p_scope         NUMBER,
        p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
        p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE
   )
        RETURN report_detail_tab PIPELINED
   AS
        report report_detail_type;
        v_count NUMBER;
   
   BEGIN
   
        FOR i IN (SELECT DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd,
                         b.line_cd line_cd,
                         b.subline_cd subline_cd,
                         b.policy_no policy_no,
                         b.policy_id policy_id,
                         b.share_type share_type,
                         b.share_cd share_cd,
                         DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname)peril_sname,
                         SUM(DECODE(c.peril_type,'B',NVL(decode(b.share_type,1,b.nr_dist_tsi,2,b.tr_dist_tsi,3,b.fa_dist_tsi),0),0))f_tr_dist_tsi,
                         SUM(NVL(DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem),0)) nr_peril_prem,
                         SUM(NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi),0)) nr_peril_tsi 
                    FROM GIPI_UWREPORTS_DIST_PERIL_EXT b,  
                         GIIS_PERIL c
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                     AND b.line_cd = NVL(UPPER(p_line_cd),b.line_cd)
                     AND b.user_id = p_user_id
                     AND ((p_scope = 3 AND b.endt_seq_no=b.endt_seq_no)
                         OR  (p_scope = 1 AND b.endt_seq_no=0)
                         OR  (p_scope = 2 AND b.endt_seq_no>0))
                     AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd),
                         b.line_cd,
                         b.subline_cd,
                         b.policy_no,
                         b.policy_id,
                         b.share_type,
                         b.share_cd,
                         c.peril_type,
                         c.peril_sname)
                    
        LOOP
            report.iss_cd          := i.iss_cd;
            report.line_cd         := i.line_cd;
            report.subline_cd      := i.subline_cd;
            report.share_cd        := i.share_cd;
            report.peril_sname     := i.peril_sname;
            report.policy_no       := i.policy_no;
            report.policy_id       := i.policy_id;
            report.share_type      := i.share_type;
            report.f_tr_dist_tsi   := i.f_tr_dist_tsi;
            report.nr_peril_tsi    := i.nr_peril_tsi;
            report.nr_peril_prem   := i.nr_peril_prem;
            
            PIPE ROW(report);
            
        END LOOP;
        
        FOR j IN (SELECT DISTINCT DECODE(p_iss_param,1,cred_branch,iss_cd) iss_cd,
                         line_cd,
                         share_type,
                         share_cd,
                         INITCAP(trty_name) trty_name
                    FROM GIPI_UWREPORTS_DIST_PERIL_EXT
                   WHERE DECODE(p_iss_param,1,cred_branch,iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,cred_branch,iss_cd))
                     AND line_cd = NVL(UPPER(p_line_cd),line_cd)
                     AND user_id = p_user_id
                ORDER BY share_cd)
        LOOP
            FOR k IN (SELECT DISTINCT line_cd, 
                             subline_cd
                        FROM GIPI_UWREPORTS_DIST_PERIL_EXT 
                       WHERE 1 = 1
                         AND DECODE(p_iss_param,1,cred_branch,iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,cred_branch,iss_cd))
                         AND line_cd = NVL(UPPER(p_line_cd),line_cd)
                         AND user_id = p_user_id
                         AND ((p_scope = 3 AND endt_seq_no=endt_seq_no)
                             OR  (p_scope = 1 AND endt_seq_no=0)
                             OR  (p_scope = 2 AND endt_seq_no>0))
                         AND subline_cd = NVL(p_subline_cd, subline_cd))
            LOOP
                v_count := 0;
                
                FOR l IN(SELECT COUNT(*)
                           FROM GIPI_UWREPORTS_DIST_PERIL_EXT 
                          WHERE 1=1
                            AND DECODE(p_iss_param,1,cred_branch,iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,cred_branch,iss_cd))
                            AND line_cd = NVL(UPPER(p_line_cd),line_cd)
                            AND user_id = p_user_id
                            AND ((p_scope = 3 AND endt_seq_no=endt_seq_no)
                                OR  (p_scope = 1 AND endt_seq_no=0)
                                OR  (p_scope = 2 AND endt_seq_no>0))
                            AND subline_cd = k.subline_cd
                            AND share_cd = j.share_cd
                       GROUP BY DECODE(p_iss_param,1,cred_branch,iss_cd),line_cd,subline_cd,share_type,share_cd, trty_name)
                LOOP
                    v_count := 1;
                    EXIT;
                END LOOP;
                
                
                IF v_count = 0 
                THEN
                    FOR m IN (SELECT b1.policy_no policy_no,
                                     b1.policy_id policy_id,
                                     DECODE(c1.peril_type,'B','*'||c1.peril_sname,' '||c1.peril_sname)peril_sname 
                                FROM GIPI_UWREPORTS_DIST_PERIL_EXT b1,  
                                     GIIS_PERIL c1
                               WHERE 1 = 1
                                 AND b1.line_cd = c1.line_cd
                                 AND b1.peril_cd = c1.peril_cd
                                 AND DECODE(p_iss_param,1,b1.cred_branch,b1.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,b1.cred_branch,b1.iss_cd))
                                 AND b1.line_cd = NVL(UPPER(p_line_cd),b1.line_cd)
                                 AND b1.user_id = p_user_id
                                 AND ((p_scope = 3 AND b1.endt_seq_no=b1.endt_seq_no)
                                     OR  (p_scope = 1 AND b1.endt_seq_no=0)
                                     OR  (p_scope = 2 AND b1.endt_seq_no>0))
                                 AND b1.subline_cd = NVL(p_subline_cd, b1.subline_cd)
                                 AND b1.subline_cd = k.subline_cd)
                    LOOP
                        report.policy_no    := m.policy_no;
                        report.policy_id    := m.policy_id;
                        report.peril_sname  := m.peril_sname;
                        EXIT;
                    END LOOP;
                    
                    report.iss_cd           := j.iss_cd;
                    report.line_cd          := j.line_cd;
                    report.subline_cd       := k.subline_cd;
                    report.share_cd         := j.share_cd;
                    report.share_type       := NULL;
                    report.f_tr_dist_tsi    := 0;
                    report.nr_peril_tsi     := 0;
                    report.nr_peril_prem    := 0;
                    report.trty_name        := j.trty_name;
                    
                    PIPE ROW (report);
                    
                END IF;
               
            END LOOP;
            
        END LOOP;                  
   
   END;
   
    FUNCTION get_trty_name_header(
        p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
        p_iss_param     NUMBER,
        p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
        p_scope         NUMBER,
        p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
        p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE
    )
        RETURN report_trty_name_tab PIPELINED
   AS
        report report_trty_name_type;
   
   BEGIN
   
        FOR i IN (SELECT DISTINCT DECODE(p_iss_param,1,cred_branch,iss_cd) iss_cd,
                         line_cd line_cd,
                         share_type,
                         share_cd share_cd,
                         INITCAP(trty_name) trty_name
                    FROM GIPI_UWREPORTS_DIST_PERIL_EXT
                   WHERE DECODE(p_iss_param,1,cred_branch,iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,cred_branch,iss_cd))
                     AND line_cd = NVL(UPPER(p_line_cd),line_cd)
                     AND subline_cd = NVL(p_subline_cd, subline_cd)
                     AND user_id = p_user_id
                     AND ((p_scope = 3 AND endt_seq_no = endt_seq_no)
                         OR  (p_scope = 1 AND endt_seq_no = 0)
                         OR  (p_scope = 2 AND endt_seq_no > 0)))
                    
        LOOP
            report.iss_cd          := i.iss_cd;
            report.line_cd         := i.line_cd;
            report.share_type      := i.share_type;
            report.share_cd        := i.share_cd;
            report.trty_name       := i.trty_name;
            
            PIPE ROW(report);
            
        END LOOP;                   
   
   END;


    FUNCTION get_subline_recap (
        p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
        p_iss_param     NUMBER,
        p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
        p_scope         NUMBER,
        p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
        p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE
   )
        RETURN report_subline_recap_tab PIPELINED
   AS
        report report_subline_recap_type;
         v_count NUMBER;
   BEGIN
   
        FOR i IN (SELECT DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd,
                         b.line_cd line_cd,
                         b.subline_cd subline_cd,
                         b.share_type,
                         b.share_cd share_cd,
                         DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname)peril_sname,
                         b.trty_name trty_name,
                         SUM(DECODE(c.peril_type,'B',NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,b.tr_dist_tsi,3,b.fa_dist_tsi),0),0))f_tr_dist_tsi,
                         SUM(NVL(DECODE(B.SHARE_TYPE,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem),0)) nr_peril_prem,
                         SUM(NVL(DECODE(B.SHARE_TYPE,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi),0)) nr_peril_ts
                    FROM GIPI_UWREPORTS_DIST_PERIL_EXT b,  
                         GIIS_PERIL c
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                     AND b.line_cd = NVL(UPPER(p_line_cd),b.line_cd)
                     AND b.user_id = p_user_id
                     AND ((p_scope = 3 AND b.endt_seq_no=b.endt_seq_no)
                         OR  (p_scope = 1 AND b.endt_seq_no=0)
                         OR  (p_scope = 2 AND b.endt_seq_no>0))
                     AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd),
                         b.line_cd,
                         b.subline_cd,
                         b.share_type,
                         b.share_cd,
                         DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname),
                         b.trty_name)
                
        LOOP
            report.iss_cd           := i.iss_cd;
            report.line_cd          := i.line_cd;
            report.subline_cd       := i.subline_cd;
            report.share_type       := i.share_type;
            report.share_cd         := i.share_cd;
            report.peril_sname      := i.peril_sname;
            report.trty_name        := i.trty_name;
            report.f_tr_dist_tsi    := i.f_tr_dist_tsi;
            report.nr_peril_prem    := i.nr_peril_prem;
            report.nr_peril_ts      := i.nr_peril_ts;
            
            PIPE ROW(report);
            
        END LOOP;
        
        FOR j IN (SELECT DISTINCT DECODE(p_iss_param,1,cred_branch,iss_cd) iss_cd,
                         line_cd,
                         share_type,
                         share_cd,
                         INITCAP(trty_name) trty_name
                    FROM GIPI_UWREPORTS_DIST_PERIL_EXT
                   WHERE DECODE(p_iss_param,1,cred_branch,iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,cred_branch,iss_cd))
                     AND line_cd = NVL(UPPER(p_line_cd),line_cd)
                     AND user_id = p_user_id
                ORDER BY share_cd)
        LOOP
            FOR k IN (SELECT DISTINCT line_cd, 
                             subline_cd
                        FROM GIPI_UWREPORTS_DIST_PERIL_EXT 
                       WHERE 1 = 1
                         AND DECODE(p_iss_param,1,cred_branch,iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,cred_branch,iss_cd))
                         AND line_cd = NVL(UPPER(p_line_cd),line_cd)
                         AND user_id = p_user_id
                         AND ((p_scope = 3 AND endt_seq_no=endt_seq_no)
                             OR  (p_scope = 1 AND endt_seq_no=0)
                             OR  (p_scope = 2 AND endt_seq_no>0))
                         AND subline_cd = NVL(p_subline_cd, subline_cd))
            LOOP
                v_count := 0;
                
                FOR l IN(SELECT COUNT(*)
                           FROM GIPI_UWREPORTS_DIST_PERIL_EXT 
                          WHERE 1=1
                            AND DECODE(p_iss_param,1,cred_branch,iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,cred_branch,iss_cd))
                            AND line_cd = NVL(UPPER(p_line_cd),line_cd)
                            AND user_id = p_user_id
                            AND ((p_scope = 3 AND endt_seq_no=endt_seq_no)
                                OR  (p_scope = 1 AND endt_seq_no=0)
                                OR  (p_scope = 2 AND endt_seq_no>0))
                            AND subline_cd = k.subline_cd
                            AND share_cd = j.share_cd
                       GROUP BY DECODE(p_iss_param,1,cred_branch,iss_cd),line_cd,subline_cd,share_type,share_cd, trty_name)
                LOOP
                    v_count := 1;
                    EXIT;
                END LOOP;
                
                
                IF v_count = 0 
                THEN
                    FOR m IN (SELECT DECODE(c1.peril_type,'B','*'||c1.peril_sname,' '||c1.peril_sname)peril_sname 
                                FROM GIPI_UWREPORTS_DIST_PERIL_EXT b1,  
                                     GIIS_PERIL c1
                               WHERE 1 = 1
                                 AND b1.line_cd = c1.line_cd
                                 AND b1.peril_cd = c1.peril_cd
                                 AND DECODE(p_iss_param,1,b1.cred_branch,b1.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,b1.cred_branch,b1.iss_cd))
                                 AND b1.line_cd = NVL(UPPER(p_line_cd),b1.line_cd)
                                 AND b1.user_id = p_user_id
                                 AND ((p_scope = 3 AND b1.endt_seq_no=b1.endt_seq_no)
                                     OR  (p_scope = 1 AND b1.endt_seq_no=0)
                                     OR  (p_scope = 2 AND b1.endt_seq_no>0))
                                 AND b1.subline_cd = NVL(p_subline_cd, b1.subline_cd)
                                 AND b1.subline_cd = k.subline_cd)
                    LOOP
                        report.peril_sname  := m.peril_sname;
                        EXIT;
                    END LOOP;
                    
                    report.iss_cd           := j.iss_cd;
                    report.line_cd          := j.line_cd;
                    report.subline_cd       := k.subline_cd;
                    report.share_cd         := j.share_cd;
                    report.share_type       := NULL;
                    report.f_tr_dist_tsi    := 0;
                    report.nr_peril_ts      := 0;
                    report.nr_peril_prem    := 0;
                    report.trty_name        := j.trty_name;
                    
                    PIPE ROW (report);
                    
                END IF;
               
            END LOOP;
            
        END LOOP;               
   
   END;
   
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 1/14/2013
   **  Reference By : GIPIR928F - Distribution Report(Detailed)
   */
    FUNCTION get_line_recap (
        p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
        p_iss_param     NUMBER,
        p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
        p_scope         NUMBER,
        p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
        p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE
   )
        RETURN report_line_recap_tab PIPELINED
   AS
        report report_line_recap_type;
   
   BEGIN
   
        FOR i IN (SELECT DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd,
                         b.line_cd line_cd,
                         b.share_type,
                         b.share_cd share_cd,
                         DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname)peril_sname,
                         b.trty_name trty_name,
                         SUM(DECODE(c.peril_type,'B',NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,b.tr_dist_tsi,3,b.fa_dist_tsi),0),0))f_tr_dist_tsi,
                         SUM(NVL(DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem),0)) nr_peril_prem,
                         SUM(NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi),0)) nr_peril_ts,
                         SUM(NVL(DECODE(c.special_risk_tag,'Y', DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi)),0)) sr_peril_ts,
                         SUM(NVL(DECODE(c.special_risk_tag,'Y', DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem)),0)) sr_peril_prem,
                         SUM(NVL(DECODE(c.special_risk_tag,'Y',0, DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi)),0)) fr_peril_ts,         
                         SUM(NVL(DECODE(c.special_risk_tag,'Y',0, DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem)),0)) fr_peril_prem
                    FROM GIPI_UWREPORTS_DIST_PERIL_EXT b,  
                         GIIS_PERIL c
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                     AND b.line_cd = NVL(UPPER(p_line_cd),b.line_cd)
                     AND b.user_id = p_user_id
                     AND ((p_scope = 3 AND b.endt_seq_no=b.endt_seq_no)
                         OR  (p_scope = 1 AND b.endt_seq_no=0)
                         OR  (p_scope = 2 AND b.endt_seq_no>0))
                     AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd),
                         b.line_cd,
                         b.share_type,
                         b.share_cd,
                         b.trty_name,
                         c.peril_type,
                         c.peril_sname)
                
        LOOP
            report.iss_cd           := i.iss_cd;
            report.line_cd          := i.line_cd;
            report.share_type       := i.share_type;
            report.share_cd         := i.share_cd;
            report.peril_sname      := i.peril_sname;
            report.trty_name        := i.trty_name;
            report.f_tr_dist_tsi    := i.f_tr_dist_tsi;
            report.nr_peril_prem    := i.nr_peril_prem;
            report.nr_peril_ts      := i.nr_peril_ts;
            report.sr_peril_prem    := i.sr_peril_prem;
            report.sr_peril_ts      := i.sr_peril_ts;
            report.fr_peril_prem    := i.fr_peril_prem;
            report.fr_peril_ts      := i.fr_peril_ts;
            
            PIPE ROW(report);
            
        END LOOP;                   
   
   END;      


    FUNCTION get_branch_recap (
        p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
        p_iss_param     NUMBER,
        p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
        p_scope         NUMBER,
        p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
        p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE
   )
        RETURN report_branch_recap_tab PIPELINED
   AS
        report report_branch_recap_type;
   
   BEGIN
   
        IF p_iss_cd IS NOT NULL
        THEN
            FOR i IN (SELECT DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd,
                         b.share_type,
                         b.share_cd share_cd,
                         DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname)peril_sname,
                         INITCAP(b.trty_name) trty_name,
                         SUM(DECODE(c.peril_type,'B',NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,b.tr_dist_tsi,3,b.fa_dist_tsi),0),0))f_tr_dist_tsi,
                         SUM(NVL(DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem),0)) nr_peril_prem,
                         SUM(NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi),0)) nr_peril_ts
                    FROM GIPI_UWREPORTS_DIST_PERIL_EXT b,  
                         GIIS_PERIL c
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                     AND b.line_cd = NVL(UPPER(p_line_cd),b.line_cd)
                     AND b.user_id = p_user_id
                     AND ((p_scope = 3 AND b.endt_seq_no=b.endt_seq_no)
                         OR  (p_scope = 1 AND b.endt_seq_no=0)
                         OR  (p_scope = 2 AND b.endt_seq_no>0))
                     AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd),
                         b.share_type,
                         b.share_cd,
                         b.trty_name,
                         c.peril_type,
                         c.peril_sname)
                
            LOOP
                report.iss_cd           := i.iss_cd;
                report.share_type       := i.share_type;
                report.share_cd         := i.share_cd;
                report.peril_sname      := i.peril_sname;
                report.trty_name        := i.trty_name;
                report.f_tr_dist_tsi    := i.f_tr_dist_tsi;
                report.nr_peril_prem    := i.nr_peril_prem;
                report.nr_peril_ts      := i.nr_peril_ts;
                pipe row(report);
            END LOOP;     
            
        end if;  
        
       
    END; 
   
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 1/15/2013
   **  Reference By : GIPIR928F - Distribution Report(Detailed)
   */
FUNCTION get_grand_total (
        p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
        p_iss_param     NUMBER,
        p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
        p_scope         NUMBER,
        p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
        p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE
   )
        RETURN report_grand_total_tab PIPELINED
   AS
        report report_grand_total_type;
   
   BEGIN
   
        FOR i IN (SELECT DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd,
                         b.share_type,
                         b.share_cd share_cd,
                         DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname)peril_sname,
                         INITCAP(b.trty_name) trty_name,
                         SUM(DECODE(c.peril_type,'B',NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,b.tr_dist_tsi,3,b.fa_dist_tsi),0),0)) f_tr_dist_tsi,
                         SUM(NVL(DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem),0)) nr_peril_prem,
                         SUM(NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi),0)) nr_peril_ts,
                         SUM(NVL(DECODE(c.special_risk_tag,'Y', DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem)),0)) sr_peril_prem,
                         SUM(NVL(DECODE(c.special_risk_tag,'Y', DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi)),0)) sr_peril_ts,
                         SUM(NVL(DECODE(c.special_risk_tag,'Y',0, DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem)),0)) fr_peril_prem,
                         SUM(NVL(DECODE(c.special_risk_tag,'Y',0,DECODE(b.peril_type,'A',0, DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi))),0)) fr_peril_ts
                    FROM GIPI_UWREPORTS_DIST_PERIL_EXT b,  
                         GIIS_PERIL c
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                     AND b.line_cd=NVL(UPPER(p_line_cd),b.line_cd)
                     AND b.user_id = p_user_id
                     AND ((p_scope=3 AND b.endt_seq_no=b.endt_seq_no)
                         OR  (p_scope=1 AND b.endt_seq_no=0)
                         OR  (p_scope=2 AND b.endt_seq_no>0))
                     AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd),b.share_type,b.share_cd,b.trty_name,
                         c.peril_type,c.peril_sname
                ORDER BY b.share_type,
                         b.share_cd)
                
        LOOP
            report.iss_cd           := i.iss_cd;
            report.share_type       := i.share_type;
            report.share_cd         := i.share_cd;
            report.peril_sname      := i.peril_sname;
            report.trty_name        := i.trty_name;
            report.f_tr_dist_tsi    := i.f_tr_dist_tsi;
            report.nr_peril_prem    := i.nr_peril_prem;
            report.nr_peril_ts      := i.nr_peril_ts;
            report.sr_peril_prem    := i.sr_peril_prem;
            report.sr_peril_ts      := i.sr_peril_ts;
            report.fr_peril_prem    := i.fr_peril_prem;
            report.fr_peril_ts      := i.fr_peril_ts;
            
            PIPE ROW(report);
            
        END LOOP;                   

   END; 


    
END gipir928f_pkg;
/


