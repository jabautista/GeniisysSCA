CREATE OR REPLACE PACKAGE BODY CPI.GIACR157_PKG
AS
    FUNCTION get_giacr157_booked_tab(
        p_assd_no         VARCHAR2,
        p_intm_no         VARCHAR2,    
        p_pfrom_date      DATE,
        p_pto_date        DATE,
        p_cfrom_date      DATE,
        p_cto_date        DATE,
        p_or_no           VARCHAR2,
        p_user_id       VARCHAR2
        )
    RETURN giacr157_booked_tab PIPELINED
    IS
        v_list  giacr157_booked_type;
        v_not_exist boolean := true;
    BEGIN
        FOR i IN (
            SELECT  e.or_pref_suf, e.or_no orno,    
                    e.or_pref_suf ||'-'|| e.or_no  or_no ,
                    a.incept_date,
                    DECODE( a.endt_seq_no, 0,
                            SUBSTR(a.line_cd ||'-'|| a.subline_cd||'-'|| a.iss_cd||'-'||
                            TO_CHAR( a.issue_yy,'fm00')||'-'|| TO_CHAR(a.pol_seq_no,'fm0000000' )||'-'||
                            TO_CHAR( a.renew_no, 'fm00' ) , 1,37),
                            SUBSTR( a.line_cd ||'-'|| a.subline_cd||'-'|| a.iss_cd||'-'||
                            TO_CHAR( a.issue_yy,'fm00')||'-'|| TO_CHAR( a.pol_seq_no , 'fm0000000' ) ||'-'|| a.endt_iss_cd
                            ||'-'|| TO_CHAR( a.endt_yy) ||'-'||TO_CHAR( a.endt_seq_no, 'fm000000' )||'-'||
                            TO_CHAR( a.renew_no, 'fm00' ), 1,37)) policy_no,
                    c.b140_iss_cd, c.b140_prem_seq_no, 
                    c.inst_no, d.tran_date,
                    c.collection_amt, d.tran_flag,
                    DECODE(d.tran_flag,'P',NVL(c.collection_amt,0)) posted,
                    DECODE(d.tran_flag,'P',0,NVL(c.collection_amt,0)) unposted,
                    d.posting_date,
                    a.par_id,
                    g.assd_no,
                    g.assd_name,
                    e.intm_no,
                    a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.endt_seq_no
                FROM GIPI_POLBASIC  a,
                     GIPI_INVOICE   b,
                     GIAC_DIRECT_PREM_COLLNS c,
                     GIAC_ACCTRANS  d, 
                     GIAC_ORDER_OF_PAYTS  e,
                     GIPI_PARLIST f,
                     GIIS_ASSURED g
                WHERE a.policy_id = b.policy_id
                  AND b.iss_cd = c.b140_iss_cd
                  AND b.prem_Seq_no = c.b140_prem_Seq_no
                  AND c.gacc_tran_id = d.tran_id
                  AND d.tran_id = e.gacc_tran_id
                  AND a.par_id = f.par_id
                  AND f.assd_no = g.assd_no
                  AND g.assd_no = NVL(p_assd_no , g.assd_no)
                  AND a.acct_ent_date IS NOT NULL
                  AND TRUNC(a.acct_ent_date) >= NVL(p_pfrom_date ,TRUNC(a.acct_ent_date))           
                  AND TRUNC(a.acct_ent_date) <=  NVL(p_pto_date   , TRUNC(a.acct_ent_date))       
                  AND TRUNC(d.tran_date)     >= NVL(p_cfrom_date  , TRUNC(d.tran_date))               
                  AND TRUNC(d.tran_date)     <=  NVL(p_cto_date  , TRUNC(d.tran_date))            
                  AND e.or_no = NVL(p_or_no , e.or_no)
                  AND d.tran_flag != 'D'
                  AND a.line_cd != 'BB'
                  AND d.tran_id NOT IN (SELECT z.gacc_tran_id
                                        FROM giac_reversals z, giac_acctrans x
                                        WHERE z.reversing_tran_id = x.tran_id
                                       AND x.tran_flag <> 'D')
                  AND e.intm_no =  nvl(p_intm_no , e.intm_no)
                  --AND check_user_per_iss_cd_acctg2(a.line_cd, a.iss_cd, 'GIACS148', p_user_id) = 1
                  -- replacement for function above : shan 01.08.2015
                   AND ((SELECT access_tag
                         FROM giis_user_modules
                        WHERE userid = p_user_id
                          AND module_id = 'GIACS148'
                          AND tran_cd IN (SELECT b.tran_cd 
                                            FROM giis_users aa, giis_user_iss_cd b, giis_modules_tran c
                                           WHERE aa.user_id = b.userid
                                             AND aa.user_id = p_user_id
                                             AND b.iss_cd = a.iss_cd
                                             AND b.tran_cd = c.tran_cd
                                             AND c.module_id = 'GIACS148')) = 1
                        OR 
                        (SELECT access_tag
                           FROM giis_user_grp_modules
                          WHERE module_id = 'GIACS148'
                            AND (user_grp, tran_cd) IN ( SELECT aa.user_grp, b.tran_cd
                                                           FROM giis_users aa, giis_user_grp_dtl b, giis_modules_tran c
                                                          WHERE aa.user_grp = b.user_grp
                                                            AND aa.user_id = p_user_id
                                                            AND b.iss_cd = a.iss_cd
                                                            AND b.tran_cd = c.tran_cd
                                                            AND c.module_id = 'GIACS148')) = 1)
                   -- end of replacement : 01.08.2015
                ORDER BY e.intm_no, e.or_pref_suf, e.or_no,  a.line_cd, a.subline_cd, a.iss_Cd, a.issue_yy, a.pol_seq_no        
         )
         LOOP
            v_not_exist := false;
            v_list.or_pref_suf       :=   i.or_pref_suf;     
            v_list.orno              :=   i.orno;            
            v_list.or_no             :=   i.or_no;           
            v_list.incept_date       :=   i.incept_date;     
            v_list.policy_no         :=   i.policy_no;       
            v_list.b140_iss_cd       :=   i.b140_iss_cd;     
            v_list.b140_prem_seq_no  :=   i.b140_prem_seq_no;
            v_list.inst_no           :=   i.inst_no;         
            v_list.tran_date         :=   i.tran_date;       
            v_list.collection_amt    :=   NVL(i.collection_amt,0);  
            v_list.tran_flag         :=   i.tran_flag;       
            v_list.posted            :=   NVL(i.posted,0);          
            v_list.unposted          :=   NVL(i.unposted,0);        
            v_list.posting_date      :=   i.posting_date;    
            v_list.par_id            :=   i.par_id;          
            v_list.assd_no           :=   i.assd_no;         
            v_list.assd_name         :=   i.assd_name;       
            v_list.intm_no           :=   i.intm_no;         
            v_list.line_cd           :=   i.line_cd;         
            v_list.subline_cd        :=   i.subline_cd;      
            v_list.iss_cd            :=   i.iss_cd;          
            v_list.issue_yy          :=   i.issue_yy;        
            v_list.pol_seq_no        :=   i.pol_seq_no;      
            v_list.endt_seq_no       :=   i.endt_seq_no;
            v_list.intm_name         :=   get_intm_name(i.intm_no);      
            
            PIPE ROW(v_list);
         END LOOP;
         IF v_not_exist THEN
            v_list.flag := 'T';
            PIPE ROW(v_list);
         END IF;
         
         RETURN;
    END;
    
    
    FUNCTION get_giacr157_unbooked_tab(
        p_assd_no         VARCHAR2,
        p_intm_no         VARCHAR2,    
        p_cfrom_date      DATE,
        p_cto_date        DATE,
        p_or_no           VARCHAR2,
        p_user_id       VARCHAR2
        )
    RETURN giacr157_unbooked_tab PIPELINED
    IS
        v_list  giacr157_unbooked_type;
        v_not_exist boolean := true;
    BEGIN
        FOR i IN (
             SELECT  e.or_pref_suf, e.or_no orno,    
                     e.or_pref_suf ||'-'|| e.or_no  or_no ,
                     a.incept_date,
                     DECODE( a.endt_seq_no, 0,
                     SUBSTR(A.line_cd ||'-'|| a.subline_cd||'-'|| a.iss_cd||'-'||
                     TO_CHAR( a.issue_yy,'fm00')||'-'|| TO_CHAR( a.pol_seq_no,'fm0000000' )||'-'||
                     TO_CHAR( A.renew_no, 'fm00' ) , 1,37),
                     SUBSTR( a.line_cd ||'-'|| a.subline_cd||'-'|| a.iss_cd||'-'||
                     TO_CHAR( a.issue_yy,'fm00')||'-'|| TO_CHAR( a.pol_seq_no , 'fm0000000' ) ||'-'|| a.endt_iss_cd
                     ||'-'|| TO_CHAR( a.endt_yy) ||'-'||TO_CHAR( a.endt_seq_no, 'fm000000' )||'-'||
                     TO_CHAR( a.renew_no, 'fm00' ), 1,37)) policy_no,
                     c.b140_iss_cd, c.b140_prem_seq_no, 
                     c.inst_no, d.tran_date,
                     c.collection_amt, d.tran_flag,
                     DECODE(d.tran_flag,'P',NVL(c.collection_amt,0)) posted,
                     DECODE(d.tran_flag,'P',0,NVL(c.collection_amt,0)) unposted,
                     d.posting_date,
                     a.par_id,
                     g.assd_no,
                     g.assd_name,
                     e.intm_no,
                     a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.endt_seq_no
                    -- h.intrmdry_intm_no,
                    -- i.intm_name
                    FROM gipi_polbasic  a,
                         gipi_invoice   b,
                         giac_direct_prem_collns c,
                         giac_acctrans  d, 
                         giac_order_of_payts  e,
                         gipi_parlist f,
                         giis_assured g
                    --     gipi_comm_invoice h,
                    --     giis_intermediary i
                    WHERE a.policy_id = b.policy_id
                      AND b.iss_cd = c.b140_iss_cd
                      AND b.prem_Seq_no = c.b140_prem_Seq_no
                    --  and b.iss_cd = h.iss_cd
                    --  and b.prem_Seq_no = h.prem_Seq_no
                      AND c.gacc_tran_id = d.tran_id
                      AND d.tran_id = e.gacc_tran_id
                      AND a.par_id = f.par_id
                      AND f.assd_no = g.assd_no
                      AND g.assd_no = nvl(p_assd_no, g.assd_no)
                      AND a.acct_ent_date is null
                    --  and trunc(a.acct_ent_date) >= nvl(:p_fr_date,trunc(a.acct_ent_date))           
                    --  and trunc(a.acct_ent_date) <=  nvl(:p_to_date, trunc(a.acct_ent_date))       
                    --  and a.pol_flag != '5'                                                                                    
                      AND trunc(d.tran_date)     >= nvl(p_cfrom_date , trunc(d.tran_date))               
                      AND trunc(d.tran_date)     <=  nvl(p_cto_date  , trunc(d.tran_date))            
                      AND e.or_no = nvl(p_or_no , e.or_no)
                      AND d.tran_flag != 'D'
                      AND a.line_cd != 'BB'
                      AND d.tran_id not in (SELECT z.gacc_tran_id
                                            FROM giac_reversals z, giac_acctrans x
                                            WHERE z.reversing_tran_id = x.tran_id
                                            AND x.tran_flag != 'D')    
                    --  and h.share_percentage = (SELECT max(share_percentage)
                    --                                                FROM gipi_comm_invoice y
                    --                                              WHERE y.iss_cd = :b140_iss_cd
                    --                                             AND y.prem_seq_no = :b140_prem_Seq_no
                    --                                      )
                    --  and h.intrmdry_intm_no =  nvl(:c_intm_no, h.intrmdry_intm_no)
                    --  and h.intrmdry_intm_no = i.intm_no
                      AND e.intm_no =  nvl(p_intm_no  , e.intm_no)
                      --AND check_user_per_iss_cd_acctg2(a.line_cd, a.iss_cd, 'GIACS148', p_user_id)=1 --Jongs 03.14.2013 added to provide limited access depending on user account
                    -- replacement for function above : shan 01.08.2015
                   AND ((SELECT access_tag
                         FROM giis_user_modules
                        WHERE userid = p_user_id
                          AND module_id = 'GIACS148'
                          AND tran_cd IN (SELECT b.tran_cd 
                                            FROM giis_users aa, giis_user_iss_cd b, giis_modules_tran c
                                           WHERE aa.user_id = b.userid
                                             AND aa.user_id = p_user_id
                                             AND b.iss_cd = a.iss_cd
                                             AND b.tran_cd = c.tran_cd
                                             AND c.module_id = 'GIACS148')) = 1
                        OR 
                        (SELECT access_tag
                           FROM giis_user_grp_modules
                          WHERE module_id = 'GIACS148'
                            AND (user_grp, tran_cd) IN ( SELECT aa.user_grp, b.tran_cd
                                                           FROM giis_users aa, giis_user_grp_dtl b, giis_modules_tran c
                                                          WHERE aa.user_grp = b.user_grp
                                                            AND aa.user_id = p_user_id
                                                            AND b.iss_cd = a.iss_cd
                                                            AND b.tran_cd = c.tran_cd
                                                            AND c.module_id = 'GIACS148')) = 1)
                   -- end of replacement : 01.08.2015
                    --order by h.intrmdry_intm_no, e.or_pref_suf, e.or_no,  a.line_cd, a.subline_cd, a.iss_Cd, a.issue_yy, a.pol_seq_no
                    ORDER BY e.intm_no, e.or_pref_suf, e.or_no,  a.line_cd, a.subline_cd, a.iss_Cd, a.issue_yy, a.pol_seq_no        
         )
         LOOP
            v_not_exist              :=   false;
            v_list.or_pref_suf       :=   i.or_pref_suf;     
            v_list.orno              :=   i.orno;            
            v_list.or_no             :=   i.or_no;           
            v_list.incept_date       :=   i.incept_date;     
            v_list.policy_no         :=   i.policy_no;       
            v_list.b140_iss_cd       :=   i.b140_iss_cd;     
            v_list.b140_prem_seq_no  :=   i.b140_prem_seq_no;
            v_list.inst_no           :=   i.inst_no;         
            v_list.tran_date         :=   i.tran_date;       
            v_list.collection_amt    :=   NVL(i.collection_amt,0);  
            v_list.tran_flag         :=   i.tran_flag;       
            v_list.posted            :=   NVL(i.posted,0);          
            v_list.unposted          :=   NVL(i.unposted,0);         
            v_list.posting_date      :=   i.posting_date;    
            v_list.par_id            :=   i.par_id;          
            v_list.assd_no           :=   i.assd_no;         
            v_list.assd_name         :=   i.assd_name;       
            v_list.intm_no           :=   i.intm_no;         
            v_list.line_cd           :=   i.line_cd;         
            v_list.subline_cd        :=   i.subline_cd;      
            v_list.iss_cd            :=   i.iss_cd;          
            v_list.issue_yy          :=   i.issue_yy;        
            v_list.pol_seq_no        :=   i.pol_seq_no;      
            v_list.endt_seq_no       :=   i.endt_seq_no;
            v_list.intm_name         :=   get_intm_name(i.intm_no);    
            
            PIPE ROW(v_list);
         END LOOP;
         IF v_not_exist THEN
            v_list.flag := 'T';
            PIPE ROW(v_list);
         END IF;
         RETURN;
    END;
    
    FUNCTION get_giacr157_header(
        v_report_title VARCHAR2,
        p_pfrom_date      DATE,
        p_pto_date        DATE,
        p_cfrom_date      DATE,
        p_cto_date        DATE,
        p_assd_no         VARCHAR2,
        p_intm_no         VARCHAR2,
        p_or_no           VARCHAR2,
        p_user_id       VARCHAR2
    )
        RETURN giacr157_header_tab PIPELINED
    IS
        v_list giacr157_header_type;
        v_col1       NUMBER(16,2) := 0;
        v_post1      NUMBER(16,2) := 0;
        v_unpost1    NUMBER(16,2) := 0;
        v_col2       NUMBER(16,2) := 0;
        v_post2      NUMBER(16,2) := 0;
        v_unpost2    NUMBER(16,2) := 0;
    BEGIN
        select param_value_v INTO v_list.company_name FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_NAME';
        select param_value_v INTO v_list.company_address FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_ADDRESS';
        
        IF v_report_title = 'U' THEN
            v_list.report_title := 'Total Collections for Unbooked Policies';
        ELSIF v_report_title = 'B' THEN   
            v_list.report_title := 'Total Collections for Booked Policies';
        ELSE
            v_list.report_title := 'Total Collections for All Policies';
        END IF;
        
        v_list.p_report_header := 'Production From ' ||to_char(p_pfrom_date, 'FmMonth dd, yyyy') || ' to ' ||to_char(p_pto_date, 'FmMonth dd, yyyy');
        v_list.c_report_header := 'Collection From ' ||to_char(p_cfrom_date, 'FmMonth dd, yyyy') || ' to ' ||to_char(p_cto_date, 'FmMonth dd, yyyy');
        
        --UNBOOKED
        BEGIN
            SELECT SUM (c.collection_amt),
                   SUM (DECODE (d.tran_flag, 'P', NVL (c.collection_amt, 0))) posted,
                   SUM (DECODE (d.tran_flag, 'P', 0, NVL (c.collection_amt, 0))) unposted,
                   COUNT(*)
              INTO v_col1, v_post1, v_unpost1, v_list.v_unbooked_count
              FROM gipi_polbasic a,
                   gipi_invoice b,
                   giac_direct_prem_collns c,
                   giac_acctrans d,
                   giac_order_of_payts e,
                   gipi_parlist f,
                   giis_assured g
             WHERE a.policy_id = b.policy_id
               AND b.iss_cd = c.b140_iss_cd
               AND b.prem_seq_no = c.b140_prem_seq_no
               AND c.gacc_tran_id = d.tran_id
               AND d.tran_id = e.gacc_tran_id
               AND a.par_id = f.par_id
               AND f.assd_no = g.assd_no
               AND g.assd_no = NVL (p_assd_no, g.assd_no)
               AND a.acct_ent_date IS NULL
               AND TRUNC (d.tran_date) >= NVL (p_cfrom_date, TRUNC (d.tran_date))
               AND TRUNC (d.tran_date) <= NVL (p_cto_date, TRUNC (d.tran_date))
               AND e.or_no = NVL (p_or_no, e.or_no)
               AND d.tran_flag != 'D'
               AND a.line_cd != 'BB'
               AND d.tran_id NOT IN (
                              SELECT z.gacc_tran_id
                                FROM giac_reversals z, giac_acctrans x
                               WHERE z.reversing_tran_id = x.tran_id
                                     AND x.tran_flag != 'D')
               AND e.intm_no = NVL (p_intm_no, e.intm_no)
               --AND check_user_per_iss_cd_acctg2 (a.line_cd, a.iss_cd, 'GIACS148', p_user_id) = 1;
               -- replacement for function above : shan 01.08.2015
                   AND ((SELECT access_tag
                         FROM giis_user_modules
                        WHERE userid = p_user_id
                          AND module_id = 'GIACS148'
                          AND tran_cd IN (SELECT b.tran_cd 
                                            FROM giis_users aa, giis_user_iss_cd b, giis_modules_tran c
                                           WHERE aa.user_id = b.userid
                                             AND aa.user_id = p_user_id
                                             AND b.iss_cd = a.iss_cd
                                             AND b.tran_cd = c.tran_cd
                                             AND c.module_id = 'GIACS148')) = 1
                        OR 
                        (SELECT access_tag
                           FROM giis_user_grp_modules
                          WHERE module_id = 'GIACS148'
                            AND (user_grp, tran_cd) IN ( SELECT aa.user_grp, b.tran_cd
                                                           FROM giis_users aa, giis_user_grp_dtl b, giis_modules_tran c
                                                          WHERE aa.user_grp = b.user_grp
                                                            AND aa.user_id = p_user_id
                                                            AND b.iss_cd = a.iss_cd
                                                            AND b.tran_cd = c.tran_cd
                                                            AND c.module_id = 'GIACS148')) = 1);
                   -- end of replacement : 01.08.2015
        END;
        
        --BOOKED
        BEGIN
            SELECT SUM (c.collection_amt),
                   SUM (DECODE (d.tran_flag, 'P', NVL (c.collection_amt, 0))) posted,
                   SUM (DECODE (d.tran_flag, 'P', 0, NVL (c.collection_amt, 0))) unposted,
                   COUNT(*)
              INTO v_col2, v_post2, v_unpost2, v_list.v_booked_count
              FROM gipi_polbasic a,
                   gipi_invoice b,
                   giac_direct_prem_collns c,
                   giac_acctrans d,
                   giac_order_of_payts e,
                   gipi_parlist f,
                   giis_assured g
             WHERE a.policy_id = b.policy_id
               AND b.iss_cd = c.b140_iss_cd
               AND b.prem_seq_no = c.b140_prem_seq_no
               AND c.gacc_tran_id = d.tran_id
               AND d.tran_id = e.gacc_tran_id
               AND a.par_id = f.par_id
               AND f.assd_no = g.assd_no
               AND g.assd_no = NVL (p_assd_no, g.assd_no)
               AND a.acct_ent_date IS NOT NULL
               AND TRUNC (a.acct_ent_date) >= NVL (p_pfrom_date, TRUNC (a.acct_ent_date))
               AND TRUNC (a.acct_ent_date) <= NVL (p_pto_date, TRUNC (a.acct_ent_date))
               AND TRUNC (d.tran_date) >= NVL (p_cfrom_date, TRUNC (d.tran_date))
               AND TRUNC (d.tran_date) <= NVL (p_cto_date, TRUNC (d.tran_date))
               AND e.or_no = NVL (p_or_no, e.or_no)
               AND d.tran_flag != 'D'
               AND a.line_cd != 'BB'
               AND d.tran_id NOT IN (
                              SELECT z.gacc_tran_id
                                FROM giac_reversals z, giac_acctrans x
                               WHERE z.reversing_tran_id = x.tran_id
                                     AND x.tran_flag <> 'D')
               AND e.intm_no = NVL (p_intm_no, e.intm_no)
               --AND check_user_per_iss_cd_acctg2 (a.line_cd, a.iss_cd, 'GIACS148', p_user_id) = 1;
               -- replacement for function above : shan 01.08.2015
                   AND ((SELECT access_tag
                         FROM giis_user_modules
                        WHERE userid = p_user_id
                          AND module_id = 'GIACS148'
                          AND tran_cd IN (SELECT b.tran_cd 
                                            FROM giis_users aa, giis_user_iss_cd b, giis_modules_tran c
                                           WHERE aa.user_id = b.userid
                                             AND aa.user_id = p_user_id
                                             AND b.iss_cd = a.iss_cd
                                             AND b.tran_cd = c.tran_cd
                                             AND c.module_id = 'GIACS148')) = 1
                        OR 
                        (SELECT access_tag
                           FROM giis_user_grp_modules
                          WHERE module_id = 'GIACS148'
                            AND (user_grp, tran_cd) IN ( SELECT aa.user_grp, b.tran_cd
                                                           FROM giis_users aa, giis_user_grp_dtl b, giis_modules_tran c
                                                          WHERE aa.user_grp = b.user_grp
                                                            AND aa.user_id = p_user_id
                                                            AND b.iss_cd = a.iss_cd
                                                            AND b.tran_cd = c.tran_cd
                                                            AND c.module_id = 'GIACS148')) = 1);
                   -- end of replacement : 01.08.2015
        END;
        
        v_list.v_col_total      := nvl(v_col1,0) + nvl(v_col2,0);
        v_list.v_post_total     := nvl(v_post1,0) + nvl(v_post2,0);
        v_list.v_unpost_total   := nvl(v_unpost1,0) + nvl(v_unpost2,0);
        
        PIPE ROW(v_list);
        RETURN;
    END get_giacr157_header;
END;
/


