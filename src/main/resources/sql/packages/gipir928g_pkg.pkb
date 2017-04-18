CREATE OR REPLACE PACKAGE BODY CPI.GIPIR928G_PKG AS

    /*
    ** Created by       : Marie Kris Felipe
    ** Date Created     : January 17, 2013
    ** Reference by     : GIPIR928G - Distribution Register with Breakdown - Detailed (Longer Format)
    ** Description      : To retrieve basic details of the report.
    **                      Q1 was used.
    */
    FUNCTION populate_gipir928g(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER,
        p_user_id       IN      GIPI_UWREPORTS_DIST_PERIL_EXT.USER_ID%TYPE  --Halley 01.29.14
    ) RETURN gipir928g_tab PIPELINED 
    IS
        v_report    gipir928g_type;
    BEGIN
        -- Q1
        FOR dtl IN (SELECT DISTINCT DECODE(p_iss_param, 1, b.cred_branch, b.iss_cd) iss_cd,
                           DECODE(p_iss_param, 1, b.cred_branch, b.iss_cd) iss_cd1,
                           INITCAP(g.iss_name) iss_name, 
                           b.line_cd line_cd, 
                           INITCAP(e.line_name) line_name, 
                           b.subline_cd, 
                           INITCAP(f.subline_name) subline_name, 
                           b.policy_no policy_no2, 
                           b.policy_id policy_id,
                           b.share_cd share_cd, -- kris 2.11.2013
                           sum(nvl(nr_dist_prem,0) + nvl(tr_dist_prem,0) + nvl(fa_dist_prem,0)) prem_amt,
                           sum(decode(b.peril_type,'B',nvl(nr_dist_tsi,0),0) +
                               decode(b.peril_type,'B',nvl(tr_dist_tsi,0),0) +
                               decode(b.peril_type,'B',nvl(fa_dist_tsi,0),0)) tsi_amt
                      FROM gipi_uwreports_dist_peril_ext b,  
                           giis_subline f,
                           giis_issource g,
                           giis_line e
                     WHERE 1 = 1
                       AND b.line_cd = f.line_cd
                       AND b.subline_cd = f.subline_cd
                       AND b.line_cd = e.line_cd 
                       and DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = g.iss_cd
                       AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                       AND b.line_cd=NVL(UPPER(p_line_cd),b.line_cd)
                       AND b.user_id = user
                       AND ((p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                            OR  (p_scope = 1 AND b.endt_seq_no = 0)
                            OR  (p_scope = 2 AND b.endt_seq_no > 0))
                       and b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                     group by DECODE(p_iss_param,1,b.cred_branch,b.iss_cd),
                           DECODE(p_iss_param, 1, b.cred_branch, b.iss_cd), 
                           g.iss_name, b.line_cd, e.line_name, b.subline_cd, f.subline_name, b.policy_no, b.policy_id, b.share_cd
                     -- kris 2.8.2013
                     ORDER BY iss_cd, iss_cd1, line_name, line_cd, subline_cd, subline_name, policy_no2      
                    ) 
        LOOP
            v_report.iss_cd         :=  dtl.iss_cd;
            v_report.iss_cd1        :=  dtl.iss_cd1;
            v_report.iss_name       :=  dtl.iss_name;
            v_report.line_cd        :=  dtl.line_cd;
            v_report.line_name      :=  dtl.line_name;
            v_report.subline_cd     :=  dtl.subline_cd;
            v_report.subline_name   :=  dtl.subline_name;
            v_report.policy_no      :=  dtl.policy_no2;
            v_report.policy_id      :=  dtl.policy_id;
            v_report.share_cd       :=  dtl.share_cd;
            v_report.prem_amt       :=  dtl.prem_amt;
            v_report.tsi_amt        :=  dtl.tsi_amt;
            
            -- fetch fields for the report header
            SELECT GIPIR928G_PKG.CF_companyFormula
              INTO v_report.company
              FROM dual;
              
            SELECT GIPIR928G_PKG.CF_comaddressFormula
              INTO v_report.company_address
              FROM dual; 
              
            SELECT GIPIR928G_PKG.CF_report_titleFormula
              INTO v_report.report_title
              FROM dual;
              
            SELECT GIPIR928G_PKG.CF_based_onFormula
              INTO v_report.based_on
              FROM dual;
              
            SELECT GIPIR928G_PKG.CF_toggleFormula(p_scope)
              INTO v_report.toggle
              FROM dual; 
            
            SELECT GIPIR928G_PKG.CF_from_dateFormula(p_user_id)  --added parameter, Halley 01.29.14
              INTO v_report.date_from
              FROM dual;
            
            SELECT GIPIR928G_PKG.CF_to_dateFormula(p_user_id)  --added parameter, Halley 01.29.14
              INTO v_report.date_to
              FROM dual;
              
            SELECT GIPIR928G_PKG.CF_iss_headerFormula(p_iss_param)
              INTO v_report.iss_header
              FROM dual;
              
              v_report.date_from_to := 'From ' || TO_CHAR(v_report.date_from, 'fmMonth DD, RRRR') || ' to ' || TO_CHAR(v_report.date_to, 'fmMonth DD, RRRR');
              
            PIPE ROW(v_report);
        END LOOP;
    
    END populate_gipir928g;
    
    /*
    ** Date Created     : January 18, 2012
    ** Created by       : Marie Kris Felipe
    ** Reference by     : GIPIR928G - Distribution Register with Breakdown - Detailed (Longer Format) 
    ** Description      : For retrieving policy numbers and their respective perils, tsi_amt, prem_amt
    **                     Q4 was used.
    */    
    FUNCTION get_details(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER 
    ) RETURN gipir928g_dtl_tab PIPELINED
    IS
        v_detail    gipir928g_dtl_type;
        v_count     NUMBER;
    BEGIN
        -- Q4 was used here.
        FOR dtl IN (SELECT DECODE(p_iss_param, 1, b.cred_branch, b.iss_cd) iss_cd7,
                           b.line_cd line_cd11,
                           b.subline_cd subline_cd5,
                           b.policy_no polic_no1,
                           b.policy_id policy_id2,
                           b.share_type,
                           b.share_cd share_cd7,
                           INITCAP(trty_name) trty_name, 
                           DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname)peril_sname3,
                           SUM(DECODE(c.peril_type,'B',NVL(decode(b.share_type,1,b.nr_dist_tsi,2,b.tr_dist_tsi,3,b.fa_dist_tsi),0),0))f_tr_dist_tsi5,
                           SUM(NVL(DECODE(B.SHARE_TYPE,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem),0)) nr_peril_prem,
                           SUM(NVL(DECODE(B.SHARE_TYPE,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi),0)) nr_peril_ts
                           -- SUM(NVL(b.tr_dist_tsi,0)) tr_peril_tsi,
                           --- SUM(NVL(b.tr_dist_prem,0)) tr_peril_prem
                      FROM gipi_uwreports_dist_peril_ext b,  
                           giis_peril c
                     WHERE 1 = 1
                       AND b.line_cd = c.line_cd
                       AND b.peril_cd = c.peril_cd
                       --AND b.iss_cd=NVL(UPPER(p_iss_cd),b.iss_cd)
                       AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                       AND b.line_cd = NVL(UPPER(p_line_cd),b.line_cd)
                       ------AND b.share_type = 2
                       AND b.user_id = user
                       AND ((p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                            OR  (p_scope = 1 AND b.endt_seq_no = 0)
                            OR  (p_scope = 2 AND b.endt_seq_no > 0))
                       and b.subline_cd = NVL(p_subline_cd, b.subline_cd) 
                     GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd), 
                           b.line_cd, 
                           b.subline_cd, 
                           b.policy_no, 
                           b.policy_id, 
                           b.share_type, 
                           b.share_cd,
                           DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname),
                           trty_name   
                     /*ORDER BY b.iss_cd, b.line_cd, b.subline_cd, b.policy_no, b.policy_id  */    )        
        LOOP
        
            v_detail.iss_cd         :=  dtl.iss_cd7;
            v_detail.line_cd        :=  dtl.line_cd11;
            v_detail.policy_id      :=  dtl.policy_id2;
            v_detail.policy_no      :=  dtl.polic_no1;
--            v_detail.subline_name   :=  dtl.subline_name; 
            v_detail.subline_cd     :=  dtl.subline_cd5;
            v_detail.peril_sname    :=  dtl.peril_sname3;
            v_detail.f_tr_dist_tsi  :=  dtl.f_tr_dist_tsi5;
            v_detail.nr_peril_prem  :=  dtl.nr_peril_prem;
            v_detail.nr_peril_ts    :=  dtl.nr_peril_ts;
            v_detail.share_cd       :=  dtl.share_cd7;
            v_detail.share_type     :=  dtl.share_type;
            v_detail.trty_name      :=  dtl.trty_name; 
        
            PIPE ROW(v_detail);
        END LOOP;
        
        -- added by Kris 01.23.2013: 
        -- **Work around to display zeros in subline/treaties without records 
        
        -- OUTER LOOP: Get the treaties using Q11 [also used in function GET_TREATY_NAMES]
        FOR j IN (SELECT DISTINCT DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd3, 
                         line_cd line_cd4,
                         share_type,
                         share_cd share_cd1, 
                         INITCAP(trty_name) trty_name
                    FROM gipi_uwreports_dist_peril_ext
                   WHERE DECODE(p_iss_param, 1, cred_branch, iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param, 1, cred_branch, iss_cd))
                     AND line_cd = NVL(UPPER(p_line_cd),line_cd)
--                     AND subline_cd = NVL(p_subline_cd, subline_cd)
                     AND user_id = user  
--                     AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
--                           OR  (p_scope=1 AND endt_seq_no=0)
--                           OR  (p_scope=2 AND endt_seq_no>0))
                   order by share_cd)
        LOOP
        
            -- INNER LOOP: Get the sublines 
            FOR k IN (SELECT DISTINCT line_cd, 
                             subline_cd
                        FROM gipi_uwreports_dist_peril_ext    
                       WHERE 1 = 1
                         AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                NVL (p_iss_cd, DECODE (p_iss_param, 1, cred_branch, iss_cd))
                         AND line_cd = NVL (UPPER (p_line_cd), line_cd)
--                         AND share_type = 2            
                         AND user_id = user              
                         AND ((p_scope = 3 AND endt_seq_no = endt_seq_no)
                              OR (p_scope = 1 AND endt_seq_no = 0)
                              OR (p_scope = 2 AND endt_seq_no > 0)
                             )
                         AND subline_cd = NVL (p_subline_cd, subline_cd))
            LOOP
                v_count := 0;
                
                -- Check if there are records
                FOR a IN (SELECT count(*)
                            FROM gipi_uwreports_dist_peril_ext  
                           WHERE 1 = 1
                             AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                    NVL (p_iss_cd, DECODE (p_iss_param, 1, cred_branch, iss_cd))
                             AND line_cd = NVL (UPPER (p_line_cd), line_cd)
    --                         AND share_type = 2            
                             AND user_id = user              
                             AND ((p_scope = 3 AND endt_seq_no = endt_seq_no)
                                  OR (p_scope = 1 AND endt_seq_no = 0)
                                  OR (p_scope = 2 AND endt_seq_no > 0)
                                 )
                             AND subline_cd = k.subline_cd
                             AND share_cd = j.share_cd1
                           GROUP BY DECODE(p_iss_param,1,cred_branch,iss_cd),
                                 line_cd, subline_cd, share_type, share_cd, trty_name)
                LOOP
                    v_count := 1;
                    EXIT;
                END LOOP; -- end loop of 'a'
                
                IF v_count = 0 THEN
                    
                    -- Get at least one policy/peril record
                    FOR c IN (SELECT a1.policy_no, 
                                     a1.policy_id,
                                     DECODE (c1.peril_type,
                                             'B', '*' || c1.peril_sname,
                                             ' ' || c1.peril_sname
                                            ) peril_sname3
                                FROM gipi_uwreports_dist_peril_ext a1, 
                                     giis_peril c1
                               WHERE 1 = 1
                                 AND a1.line_cd = c1.line_cd
                                 AND a1.peril_cd = c1.peril_cd
                                 AND DECODE (p_iss_param, 1, a1.cred_branch, a1.iss_cd) =
                                          NVL (p_iss_cd, DECODE (p_iss_param, 1, a1.cred_branch, a1.iss_cd))
                                 AND a1.line_cd = NVL (UPPER (p_line_cd), a1.line_cd)
--                                 AND a1.share_type = 2             
                                   AND a1.user_id = user             
                                 AND (   (p_scope = 3 AND a1.endt_seq_no = a1.endt_seq_no)
                                      OR (p_scope = 1 AND a1.endt_seq_no = 0)
                                      OR (p_scope = 2 AND a1.endt_seq_no > 0)
                                     )
                                 AND a1.subline_cd = NVL (p_subline_cd, a1.subline_cd)
                                 AND a1.subline_cd = k.subline_cd)
                    LOOP
                        v_detail.policy_no   :=  c.policy_no;
                        v_detail.policy_id   :=  c.policy_id;
                        v_detail.peril_sname :=  c.peril_sname3;                        
                        EXIT;
                    END LOOP; -- end loop of 'c'
                    
                    v_detail.iss_cd         :=  j.iss_cd3;
                    v_detail.line_cd        :=  j.line_cd4;
                   -- v_detail.policy_id      :=  dtl.policy_id2;
                   -- v_detail.policy_no      :=  dtl.polic_no1;
                    v_detail.subline_cd     :=  k.subline_cd;
                   -- v_detail.peril_sname    :=  dtl.peril_sname3;
                    v_detail.f_tr_dist_tsi  :=  0;
                    v_detail.nr_peril_prem  :=  0;
                    v_detail.nr_peril_ts    :=  0;
                    v_detail.share_cd       :=  j.share_cd1;
                    v_detail.share_type     :=  NULL;
                    v_detail.trty_name      :=  j.trty_name; 
                    
                    PIPE ROW(v_detail);
                    
                END IF;
            END LOOP; -- end of inner loop 'k'
        
        END LOOP; -- end of outer loop 'j'
        
--        RETURN;
    
    END get_details;
    
     /*
    ** Date Created     : January 18, 2012
    ** Created by       : Marie Kris Felipe
    ** Reference by     : GIPIR928G - Distribution Register with Breakdown - Detailed (Longer Format) 
    ** Description      : For retrieving treaty names
    **                     Q11 was used.
    */    
    FUNCTION get_treaty_names(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER
    ) RETURN treaty_name_tab PIPELINED
    IS
        v_treaty    treaty_name_type;
    BEGIN
            -- Q11 was used here.
            FOR trty IN (SELECT DISTINCT DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd3, 
                               line_cd line_cd4,
                               share_type,
                               share_cd share_cd1, 
                               INITCAP(trty_name) trty_name
                          FROM gipi_uwreports_dist_peril_ext
                         WHERE DECODE(p_iss_param,
                                                1, cred_branch,
                                                iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,
                                                                                          1, cred_branch,
                                                                                          iss_cd))
                           AND line_cd = NVL(UPPER(p_line_cd),line_cd)
                           AND subline_cd = NVL(p_subline_cd, subline_cd)
                           AND user_id = user  
                           AND ((p_scope = 3 AND endt_seq_no = endt_seq_no)
                                OR  (p_scope = 1 AND endt_seq_no = 0)
                                OR  (p_scope = 2 AND endt_seq_no > 0))
                         /*order by share_type, share_cd*/)                        
            LOOP
                v_treaty.iss_cd         :=  trty.iss_cd3;
                v_treaty.line_cd        :=  trty.line_cd4;
                v_treaty.share_cd       :=  trty.share_cd1;
                v_treaty.share_type     :=  trty.share_type;
                v_treaty.trty_name      :=  trty.trty_name;
                
                PIPE ROW(v_treaty);
            END LOOP;
    
    END get_treaty_names;
    
    
    /*
    ** Date Created     : January 22, 2012
    ** Created by       : Marie Kris Felipe
    ** Reference by     : GIPIR928G - Distribution Register with Breakdown - Detailed (Longer Format) 
    ** Description      : For retrieving subline recap values
    **                     Q5 was used.
    */    
     FUNCTION get_subline_recap(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER
    ) RETURN subline_recap_tab PIPELINED
    IS
        v_subline_recap     subline_recap_type;
        v_count             NUMBER;
    BEGIN
    
        FOR rec IN (SELECT DECODE(p_iss_param,
                                            1, b.cred_branch,
                                            b.iss_cd)  iss_cd11,
                           b.line_cd line_cd6,
                           b.subline_cd subline_cd3,
                           DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname)peril_sname5,
                           INITCAP(trty_name) trty_name, -- added by Kris 01.22.2013: For jasper crosstab header
                           /*SUM(DECODE(c.peril_type,'B',NVL(b.tr_dist_tsi,0),'0')) f_tr_dist_tsi2,
                           SUM(NVL(b.tr_dist_tsi,0)) tr_peril_tsi2,
                           SUM(NVL(b.tr_dist_prem,0)) tr_peril_prem2,
                           sum(nvl(nr_dist_prem,0) + nvl(tr_dist_prem,0) + nvl(fa_dist_prem,0)) prem_amt,
                           sum(nvl(nr_dist_tsi,0) + nvl(tr_dist_tsi,0) + nvl(fa_dist_tsi,0)) tsi_amt*/
                           
                           ------ from query1   
                           b.share_type,
                           b.share_cd share_cd7,
                           SUM(DECODE(c.peril_type,'B',NVL(decode(b.share_type,1,b.nr_dist_tsi,2,b.tr_dist_tsi,3,b.fa_dist_tsi),0),0))f_tr_dist_tsi5,                         
                           SUM(NVL(DECODE(B.SHARE_TYPE,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem),0)) nr_peril_prem,
                           SUM(NVL(DECODE(B.SHARE_TYPE,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi),0)) nr_peril_ts                          
                      FROM gipi_uwreports_dist_peril_ext b,  
                           giis_peril c
                     WHERE 1 = 1
                       AND b.line_cd = c.line_cd
                       AND b.peril_cd = c.peril_cd
                    ----AND share_type = 2
                    --AND b.iss_cd=NVL(UPPER(:p_iss_cd),b.iss_cd)
                       AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                       AND b.line_cd = NVL(UPPER(p_line_cd),b.line_cd)
                       AND b.user_id = user
                       AND ((p_scope=3 AND b.endt_seq_no=b.endt_seq_no)
                            OR  (p_scope=1 AND b.endt_seq_no=0)
                            OR  (p_scope=2 AND b.endt_seq_no>0))
                       and b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                     GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd), 
                           b.line_cd,
                           b.subline_cd,
                           DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname), --c.peril_sname,
                           --   c.peril_type, 
                           trty_name, 
                           b.share_cd, 
                           b.share_type 
                     --ORDER BY /*share_type,*/ share_cd 
                    )        
        LOOP
            v_subline_recap.iss_cd          :=  rec.iss_cd11;
            v_subline_recap.line_cd         :=  rec.line_cd6;
            v_subline_recap.subline_cd      :=  rec.subline_cd3;
            v_subline_recap.peril_sname     :=  rec.peril_sname5;
            v_subline_recap.trty_name       :=  rec.trty_name;
            v_subline_recap.share_type      :=  rec.share_type;     
            v_subline_recap.share_cd        :=  rec.share_cd7;      
            v_subline_recap.f_tr_dist_tsi   :=  rec.f_tr_dist_tsi5; 
            v_subline_recap.tr_peril_tsi    :=  rec.nr_peril_ts;    
            v_subline_recap.tr_peril_prem   :=  rec.nr_peril_prem;  

            PIPE ROW(v_subline_recap);
        ENd LOOP;
        
        -- added by Kris 01.23.2013: 
        -- **Work around to display zeros in subline/treaties without records 
        
        -- OUTER LOOP: Get the treaties using Q11 [also used in function GET_TREATY_NAMES]
        FOR j IN (SELECT DISTINCT DECODE(p_iss_param,
                                                   1, cred_branch,
                                                   iss_cd) iss_cd3, 
                         line_cd line_cd4,
                         share_type,
                         share_cd share_cd1, 
                         INITCAP(trty_name) trty_name
                    FROM gipi_uwreports_dist_peril_ext
                   WHERE DECODE(p_iss_param,
                                          1, cred_branch,
                                          iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,
                                                                                    1, cred_branch,
                                                                                    iss_cd))
                     AND line_cd = NVL(UPPER(p_line_cd),line_cd)
--                     AND subline_cd = NVL(p_subline_cd, subline_cd)
                     AND user_id = user  
                     /*AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                           OR  (p_scope=1 AND endt_seq_no=0)
                           OR  (p_scope=2 AND endt_seq_no>0))*/
                   order by share_cd )
        LOOP
        
            -- INNER LOOP: Get the sublines 
            FOR k IN (SELECT DISTINCT line_cd, 
                             subline_cd
                        FROM gipi_uwreports_dist_peril_ext    
                       WHERE 1 = 1
                         AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                NVL (p_iss_cd, DECODE (p_iss_param, 1, cred_branch, iss_cd))
                         AND line_cd = NVL (UPPER (p_line_cd), line_cd)
--                         AND share_type = 2            
                         AND user_id = user              
                         AND ((p_scope = 3 AND endt_seq_no = endt_seq_no)
                              OR (p_scope = 1 AND endt_seq_no = 0)
                              OR (p_scope = 2 AND endt_seq_no > 0)
                             )
                         AND subline_cd = NVL (p_subline_cd, subline_cd))
            LOOP
                v_count := 0;
                
                -- Check if there are records
                FOR a IN (SELECT count(*)
                            FROM gipi_uwreports_dist_peril_ext  
                           WHERE 1 = 1
                             AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                    NVL (p_iss_cd, DECODE (p_iss_param, 1, cred_branch, iss_cd))
                             AND line_cd = NVL (UPPER (p_line_cd), line_cd)
    --                         AND share_type = 2            
                             AND user_id = user              
                             AND ((p_scope = 3 AND endt_seq_no = endt_seq_no)
                                  OR (p_scope = 1 AND endt_seq_no = 0)
                                  OR (p_scope = 2 AND endt_seq_no > 0)
                                 )
                             AND subline_cd = k.subline_cd
                             AND share_cd = j.share_cd1
                           GROUP BY DECODE(p_iss_param,1,cred_branch,iss_cd),
                                 line_cd, subline_cd, share_type, share_cd, trty_name)
                LOOP
                    v_count := 1;
                    EXIT;
                END LOOP; -- end loop of 'a'
                
                IF v_count = 0 THEN
                    
                    -- Get at least one policy/peril record
                    FOR c IN (SELECT DECODE (c1.peril_type,
                                             'B', '*' || c1.peril_sname,
                                             ' ' || c1.peril_sname
                                            ) peril_sname3
                                FROM gipi_uwreports_dist_peril_ext a1, 
                                     giis_peril c1
                               WHERE 1 = 1
                                 AND a1.line_cd = c1.line_cd
                                 AND a1.peril_cd = c1.peril_cd
                                 AND DECODE (p_iss_param, 1, a1.cred_branch, a1.iss_cd) =
                                          NVL (p_iss_cd, DECODE (p_iss_param, 1, a1.cred_branch, a1.iss_cd))
                                 AND a1.line_cd = NVL (UPPER (p_line_cd), a1.line_cd)
--                                 AND a1.share_type = 2             
                                   AND a1.user_id = user            
                                 AND (   (p_scope = 3 AND a1.endt_seq_no = a1.endt_seq_no)
                                      OR (p_scope = 1 AND a1.endt_seq_no = 0)
                                      OR (p_scope = 2 AND a1.endt_seq_no > 0)
                                     )
                                 AND a1.subline_cd = NVL (p_subline_cd, a1.subline_cd)
                                 AND a1.subline_cd = k.subline_cd)
                    LOOP
                        v_subline_recap.peril_sname :=  c.peril_sname3;
                        
                        EXIT;
                    END LOOP; -- end loop of 'c'
                    
                    v_subline_recap.iss_cd          :=  j.iss_cd3;
                    v_subline_recap.line_cd         :=  j.line_cd4;
                    v_subline_recap.subline_cd      :=  k.subline_cd;
                    v_subline_recap.share_type      :=  NULL;
                    v_subline_recap.share_cd        :=  j.share_cd1;
                    v_subline_recap.f_tr_dist_tsi   :=  0;
                    v_subline_recap.tr_peril_tsi    :=  0;
                    v_subline_recap.tr_peril_prem   :=  0;
                    v_subline_recap.trty_name       :=  j.trty_name;
                 
                    PIPE ROW(v_subline_recap);
                END IF;
            END LOOP; -- end of inner loop 'k'
        
        END LOOP; -- end of outer loop 'j'
        
--        RETURN;
        
    END get_subline_recap;
    
    /*
    ** Date Created     : January 23, 2012
    ** Created by       : Marie Kris Felipe
    ** Reference by     : GIPIR928G - Distribution Register with Breakdown - Detailed (Longer Format) 
    ** Description      : For retrieving line recap values
    **                     Q10 was used.
    */   
    FUNCTION get_line_recap (
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER
    ) RETURN line_recap_tab PIPELINED
    IS
        v_line_recap        line_recap_type;
    BEGIN
    
        FOR rec IN (SELECT DECODE(p_iss_param,
                                            1, b.cred_branch,
                                            b.iss_cd) iss_cd10,
                           b.line_cd line_cd10,
                           b.share_type,
                           b.share_cd share_cd6,
                           DECODE(c.peril_type, 'B', '*'||c.peril_sname,' '||c.peril_sname)peril_sname6,
                           INITCAP(b.trty_name) trt_name3,
                           SUM(DECODE(c.peril_type, 'B', NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,b.tr_dist_tsi,3,b.fa_dist_tsi),0),0))f_tr_dist_tsi5,
                           SUM(NVL(DECODE(b.share_type, 1, b.nr_dist_prem, 2, tr_dist_prem, fa_dist_prem),0)) nr_peril_prem,
                           SUM(NVL(DECODE(b.share_type, 1, b.nr_dist_tsi, 2, tr_dist_tsi, fa_dist_tsi),0)) nr_peril_ts,
                           SUM(NVL(DECODE(c.special_risk_tag, 'Y', DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem)),0)) sr_peril_prem,
                           SUM(NVL(DECODE(c.special_risk_tag, 'Y', DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi)),0)) sr_peril_ts,
                           SUM(NVL(DECODE(c.special_risk_tag, 'Y', 0, DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem)),0)) fr_peril_prem,
                           SUM(NVL(DECODE(c.special_risk_tag, 'Y', 0, DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi)),0)) fr_peril_ts
                      FROM gipi_uwreports_dist_peril_ext b,
                           giis_peril c
                     WHERE 1 = 1
                       AND b.line_cd = c.line_cd
                       AND b.peril_cd = c.peril_cd
                       --AND b.iss_cd=NVL(UPPER(:p_iss_cd),b.iss_cd)
                       AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                       AND b.line_cd = NVL(UPPER(p_line_cd),b.line_cd)
                       AND b.user_id = USER
                       AND (    (p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                            OR  (p_scope = 1 AND b.endt_seq_no = 0)
                            OR  (p_scope = 2 AND b.endt_seq_no > 0))
                       AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                     GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd), 
                           b.line_cd, b.share_type, b.share_cd, b.trty_name,
                           --c.peril_type, c.peril_sname
                           DECODE(c.peril_type, 'B', '*'||c.peril_sname,' '||c.peril_sname))
        LOOP
            v_line_recap.iss_cd         :=  rec.iss_cd10;
            v_line_recap.line_cd        :=  rec.line_cd10;
            v_line_recap.share_type     :=  rec.share_type;
            v_line_recap.share_cd       :=  rec.share_cd6;
            v_line_recap.peril_sname    :=  rec.peril_sname6;
            v_line_recap.trty_name      :=  rec.trt_name3;
            v_line_recap.f_tr_dist_tsi  :=  rec.f_tr_dist_tsi5;
            v_line_recap.nr_peril_prem  :=  rec.nr_peril_prem;
            v_line_recap.nr_peril_tsi   :=  rec.nr_peril_ts;
            v_line_recap.cp_sr_prem     :=  rec.sr_peril_prem;
            v_line_recap.cp_sr_tsi      :=  rec.sr_peril_ts;
            v_line_recap.cp_fr_prem     :=  rec.fr_peril_prem;
            v_line_recap.cp_fr_tsi      :=  rec.fr_peril_ts;
            
            SELECT GIPIR928G_PKG.get_special_risk_tag(p_line_cd)
              INTO v_line_recap.special_risk_tag
              FROM dual; 
        
            PIPE ROW(v_line_recap);
        END LOOP;
    
    END get_line_recap;
    
    /*
    ** Date Created     : January 23, 2012
    ** Created by       : Marie Kris Felipe
    ** Reference by     : GIPIR928G - Distribution Register with Breakdown - Detailed (Longer Format) 
    ** Description      : For retrieving branch recap values
    **                     Q12 was used.
    */  
    FUNCTION get_branch_recap(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER
    ) RETURN branch_recap_tab PIPELINED
    IS
        v_branch        branch_recap_type;
    BEGIN
    
        -- this is Q12            
        FOR rec IN (SELECT DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd11,
                           b.share_type,
                           b.share_cd share_cd6,
                           DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname)peril_sname6,
                           INITCAP(b.trty_name) trt_name3,
                           SUM(DECODE(c.peril_type,'B',NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,b.tr_dist_tsi,3,b.fa_dist_tsi),0),0))f_tr_dist_tsi5,
                           SUM(NVL(DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem),0)) nr_peril_prem,
                           SUM(NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi),0)) nr_peril_ts
                      FROM gipi_uwreports_dist_peril_ext b,  
                           giis_peril c
                     WHERE 1 = 1
                       AND b.line_cd = c.line_cd
                       AND b.peril_cd = c.peril_cd
                       --AND b.iss_cd=NVL(UPPER(:p_iss_cd),b.iss_cd)
                       AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                       AND b.line_cd = NVL(UPPER(p_line_cd),b.line_cd)
                       AND b.user_id = USER
                       AND ((p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                            OR  (p_scope = 1 AND b.endt_seq_no = 0)
                            OR  (p_scope = 2 AND b.endt_seq_no > 0))
                       AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                     GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd), 
                           b.share_type,
                           b.share_cd,
                           b.trty_name,
                           c.peril_type,
                           c.peril_sname)
        LOOP
        
            v_branch.share_type     :=  rec.share_type;
            v_branch.share_cd       :=  rec.share_cd6;
            v_branch.iss_cd         :=  rec.iss_cd11;
            v_branch.peril_sname    :=  rec.peril_sname6;
            v_branch.trty_name      :=  rec.trt_name3;
            v_branch.f_tr_dist_tsi  :=  rec.f_tr_dist_tsi5;
            v_branch.nr_peril_tsi   :=  rec.nr_peril_ts;
            v_branch.nr_peril_prem  :=  rec.nr_peril_prem;
            
            PIPE ROW(v_branch);
            
        END LOOP;
    
    END get_branch_recap;
    
    
    FUNCTION get_grand_total(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER
    ) RETURN grand_total_tab PIPELINED
    IS
        v_total    grand_total_type;
    BEGIN
        FOR rec IN (SELECT DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd, 
                           b.share_type,
                           b.share_cd share_cd6,
                           INITCAP(b.trty_name) trt_name3,
                           DECODE(c.peril_type,'B','*'||c.peril_sname,' '||c.peril_sname)peril_sname6,
                           SUM(DECODE(c.peril_type,'B',NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,b.tr_dist_tsi,3,b.fa_dist_tsi),0),0))f_tr_dist_tsi5,
                           SUM(NVL(DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem),0)) nr_peril_prem,
                           SUM(NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi),0)) nr_peril_ts,
                           SUM(NVL(DECODE(c.special_risk_tag,'Y', DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem)),0)) sr_peril_prem,
                           SUM(NVL(DECODE(c.special_risk_tag,'Y', DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi)),0)) sr_peril_tsi,
--                           SUM(NVL(DECODE(c.special_risk_tag,'Y',0, DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi)),0)) fr_peril_tsi,
                           SUM(NVL(DECODE(c.special_risk_tag,'Y',0, DECODE(b.share_type,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem)),0)) fr_peril_prem
                           ,SUM(NVL(DECODE(c.special_risk_tag,'Y',0,DECODE(b.peril_type,'A',0, DECODE(b.share_type,1,b.nr_dist_tsi,2,tr_dist_tsi,fa_dist_tsi))),0)) fr_peril_tsi
                      FROM gipi_uwreports_dist_peril_ext b,  
                              /* (SELECT y.line_cd, y.peril_cd, y.special_risk_tag, y.peril_type, y.peril_sname
                                FROM giis_peril y
                               WHERE y.line_cd IN (SELECT z.line_cd
                                                     FROM giis_peril z
                                                    WHERE z.special_risk_tag = 'Y')) c*/
                           giis_peril c
                     WHERE 1 = 1
                       AND b.line_cd = c.line_cd
                       AND b.peril_cd = c.peril_cd
--                       AND b.iss_cd=NVL(UPPER(p_iss_cd),b.iss_cd)--comment this line and repalce with:  
                       AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                       AND b.line_cd = NVL(UPPER(p_line_cd),b.line_cd) 
                       AND b.user_id = USER
                       AND ((p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                            OR  (p_scope = 1 AND b.endt_seq_no = 0)
                            OR  (p_scope = 2 AND b.endt_seq_no > 0))
                       AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                     GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd), 
                           b.share_type, b.share_cd, b.trty_name,
                           c.peril_type, c.peril_sname
                     ORDER BY b.share_type,
                         b.share_cd)
        LOOP
            v_total.iss_cd         :=  rec.iss_cd;
            v_total.share_type     :=  rec.share_type;
            v_total.share_cd       :=  rec.share_cd6;
            v_total.trty_name      :=  rec.trt_name3;
            v_total.peril_sname    :=  rec.peril_sname6;
            v_total.f_tr_dist_tsi  :=  rec.f_tr_dist_tsi5;
            v_total.nr_peril_prem  :=  rec.nr_peril_prem;
            v_total.nr_peril_tsi   :=  rec.nr_peril_ts;
            v_total.sr_peril_prem  :=  rec.sr_peril_prem;
            v_total.sr_peril_tsi   :=  rec.sr_peril_tsi;
            v_total.fr_peril_prem  :=  rec.fr_peril_prem;
            v_total.fr_peril_tsi   :=  rec.fr_peril_tsi;
        
            PIPE ROW(v_total);
        END LOOP;
        
    END get_grand_total;
    
    
    FUNCTION get_special_risk_tag(
        p_line_cd   GIIS_LINE.line_cd%TYPE
    ) RETURN VARCHAR2
    IS
        v_risk_tag  VARCHAR2(1)    := 'N';
    BEGIN
        FOR abc IN (SELECT text 
                      FROM giis_document
                     WHERE report_id = 'GIPIR928F'
                       AND title = 'PRINT_SPECIAL_RISK') 
        LOOP
            IF abc.text = 'Y' THEN
                FOR b IN (SELECT distinct line_cd
                            FROM giis_peril
                           WHERE special_risk_tag = 'Y') 
                LOOP
                    IF p_line_cd = b.line_cd THEN
                        v_risk_tag := 'Y';           
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
        
        RETURN v_risk_tag;
    END get_special_risk_tag;
    
    -------- Functions for retrieving header details.
    FUNCTION CF_companyFormula RETURN VARCHAR2
    IS
        v_comname varchar2(150);
    BEGIN
        SELECT param_value_v
          INTO v_comname
          FROM giac_parameters
         WHERE param_name = 'COMPANY_NAME';
        RETURN (v_comname);
        RETURN NULL; 
    
    EXCEPTION
        WHEN no_data_found THEN
            v_comname := 'No address available in GIAC_PARAMETERS';
            RETURN (v_comname);
        WHEN too_many_rows THEN
            v_comname := 'Too many values for address in GIAC_PARAMETERS';  
            RETURN (v_comname);
    END CF_companyFormula;
    
    FUNCTION CF_comaddressFormula RETURN VARCHAR2
    IS
        v_comaddress varchar2(200);
    BEGIN
        RETURN giisp.v('COMPANY_ADDRESS');
    END CF_comaddressFormula;
    
    FUNCTION CF_report_titleFormula RETURN VARCHAR2
    IS
        v_title     varchar2(100);
        v_exists    boolean := FALSE;
    BEGIN
        FOR c IN (SELECT report_title
                    FROM giis_reports
                   WHERE UPPER(report_id) = 'GIPIR928G') 
        LOOP
            v_title     :=  c.report_title;
            v_exists    :=  TRUE;
            EXIT;
        END LOOP;
        
        IF v_exists = TRUE THEN
            RETURN(v_title);
        ELSE
            v_title := '(This report was not found in GIIS_REPORTS)';
            RETURN(v_title);
        END IF;
        
        RETURN NULL;
    END CF_report_titleFormula;
    
    FUNCTION CF_based_onFormula RETURN VARCHAR2
    IS
        v_param_date  NUMBER(1);
        v_based_on    VARCHAR2(100);
    BEGIN
        SELECT param_date
          INTO v_param_date
          FROM gipi_uwreports_dist_peril_ext
         WHERE user_id = user
           AND rownum = 1;
        
        IF v_param_date = 1 THEN
            v_based_on := 'Based on Issue Date';
        ELSIF v_param_date = 2 THEN
            v_based_on := 'Based on Inception Date';
        ELSIF v_param_date = 3 THEN
            v_based_on := 'Based on Booking month - year';
        ELSIF v_param_date = 4 THEN
            v_based_on := 'Based on Acctg Entry Date';
        END IF;
        
        RETURN(v_based_on);
           
    END CF_based_onFormula;

    FUNCTION CF_toggleFormula(p_scope   IN  NUMBER) RETURN VARCHAR2
    IS
        v_scope         NUMBER(1);
        v_policy_label  VARCHAR2(300);
    BEGIN
        v_scope:= p_scope;
         
        IF v_scope = 1 THEN
            v_policy_label := 'Policies Only';
        ELSIF v_scope = 2 THEN
            v_policy_label := 'Endorsements Only';
        ELSIF v_scope = 3 THEN
            v_policy_label := 'Policies and Endorsements';
        END IF;
              
        RETURN(v_policy_label);
    END CF_toggleFormula;
    
    FUNCTION CF_from_dateFormula (p_user_id GIPI_UWREPORTS_DIST_PERIL_EXT.USER_ID%TYPE)  --added parameter, Halley 01.29.14
        RETURN DATE
    IS
        f_from DATE;
    BEGIN
    
        SELECT from_date1
          INTO f_from
          FROM gipi_uwreports_dist_peril_ext
         WHERE user_id = p_user_id
           AND rownum = 1;   
                
        RETURN(f_from);
        
    END CF_from_dateFormula;
    
    FUNCTION CF_to_dateFormula (p_user_id GIPI_UWREPORTS_DIST_PERIL_EXT.USER_ID%TYPE)  --added parameter, Halley 01.29.14
        RETURN DATE
    IS
        to_date DATE;
    BEGIN
    
        SELECT to_date1
          INTO to_date
          FROM gipi_uwreports_dist_peril_ext
         WHERE user_id = p_user_id
           AND rownum = 1;
           
        RETURN(to_date);
        
    END CF_to_dateFormula;
    
    FUNCTION CF_iss_headerFormula(p_iss_param   IN  NUMBER) RETURN VARCHAR2
    IS
    
    BEGIN
        IF p_iss_param = 1 THEN
              RETURN ('Crediting Branch');
        ELSIF p_iss_param = 2 THEN
              RETURN ('Issue Source');
        ELSE 
              RETURN NULL;
        END IF;
    END CF_iss_headerFormula;
    
    
END GIPIR928G_PKG;
/


