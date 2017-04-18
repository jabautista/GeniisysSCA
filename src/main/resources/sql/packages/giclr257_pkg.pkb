CREATE OR REPLACE PACKAGE BODY CPI.GICLR257_PKG
    /*
    **  Created by        : bonok
    **  Date Created      : 03.07.2013
    **  Reference By      : GICLR257 - Claim Listing Per Adjuster
    **  Modified By       : Gzelle 09.24.2013 - Cancel date and noOfDays
    */
AS
    FUNCTION get_giclr257_details(
        p_payee_no          giis_payees.payee_no%TYPE,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_ldate        VARCHAR2,
        p_to_ldate          VARCHAR2,
        p_as_of_ldate       VARCHAR2,
        p_from_adate        VARCHAR2,
        p_to_adate          VARCHAR2,
        p_as_of_adate       VARCHAR2,
        p_stat              VARCHAR2,
        p_user_id           VARCHAR2
    ) RETURN giclr257_tab PIPELINED AS
        res                 giclr257_type;
    BEGIN
        IF p_stat = 'outstanding' THEN
            FOR i IN (SELECT b.payee_no||' - '||DECODE(b.payee_first_name, '-', b.payee_last_name, b.payee_first_name||' '||b.payee_middle_name||' '||b.payee_last_name) payee_name, 
                             b.payee_class_cd,  f.clm_stat_desc, d.assign_date, d.complt_date, 
                             a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd ||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR( a.clm_seq_no,'0000009')) claim_no,
                             a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd ||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')) policy_no,
                             a.assured_name, a.loss_date, a.clm_file_date, d.adj_company_cd, d.priv_adj_cd, d.claim_id
                        FROM gicl_claims a, giis_payees b, gicl_clm_adjuster d, giis_clm_stat f 
                       WHERE b.payee_class_cd = (SELECT param_value_v 
                                                   FROM giac_parameters 
                                                  WHERE param_name = 'ADJP_CLASS_CD')
                         AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,'GICLS257',p_user_id) = 1                         
                         AND f.clm_stat_cd = a.clm_stat_cd
                         AND a.claim_id = d.claim_id
                         AND b.payee_no = d.adj_company_cd
                         AND b.payee_no = p_payee_no
                         AND ((TRUNC(a.clm_file_date)    >= TO_DATE(p_from_date,'mm/dd/yyyy')
                              AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                               OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                          OR (TRUNC(a.loss_date)     >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                              AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                               OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy'))
                          OR (TRUNC(d.assign_date)     >= TO_DATE(p_from_adate,'mm/dd/yyyy')
                              AND TRUNC(d.assign_date) <= TO_DATE(p_to_adate,'mm/dd/yyyy')
                               OR TRUNC(d.assign_date) <= TO_DATE(p_as_of_adate,'mm/dd/yyyy')))  
                         AND d.claim_id IN (SELECT claim_id
                                              FROM gicl_claims 
                                             WHERE check_user_per_line2(line_cd,ISS_CD,'GICLS257',p_user_id)=1)  
                         AND d.claim_id IN (SELECT d.claim_id 
                                              FROM gicl_clm_adjuster d, gicl_claims a
                                             WHERE a.claim_id = d.claim_id                         
                                               AND ((TRUNC(a.clm_file_date)    >= TO_DATE(p_from_date,'mm/dd/yyyy')
                                                    AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                                                     OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                                                OR (TRUNC(a.loss_date)     >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                                                    AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                                                     OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy'))
                                                OR (TRUNC(d.assign_date)     >= TO_DATE(p_from_adate,'mm/dd/yyyy')
                                                    AND TRUNC(d.assign_date) <= TO_DATE(p_to_adate,'mm/dd/yyyy')
                                                     OR TRUNC(d.assign_date) <= TO_DATE(p_as_of_adate,'mm/dd/yyyy')))  
                                               AND adj_company_cd = p_payee_no
                                               AND complt_date IS NULL
                                               AND cancel_tag IS NULL)                   
                       ORDER BY b.payee_first_name, b.payee_last_name, b.payee_middle_name, a.line_cd, a.subline_cd, 
                                a.iss_cd, a.clm_yy, a.clm_seq_no, a.assured_name, a.issue_yy, a.renew_no, a.pol_seq_no, 
                                a.loss_date, d.priv_adj_cd, d.adj_company_cd, b.payee_class_cd,a.clm_file_date) 
            LOOP
                res.payee_name    := i.payee_name;
                res.claim_no      := i.claim_no;
                res.policy_no     := i.policy_no;
                res.assured_name  := i.assured_name;
                res.loss_date     := i.loss_date;
                res.clm_file_date := i.clm_file_date;
                res.clm_stat_desc := i.clm_stat_desc;
                res.assign_date   := i.assign_date;
                res.complt_date   := i.complt_date;         
                --res.no_of_days    := TRUNC(NVL(i.complt_date,SYSDATE)) - TRUNC(i.assign_date);      
                      
                FOR j IN (SELECT payee_name
                            FROM giis_adjuster
                           WHERE adj_company_cd = i.adj_company_cd
                             AND priv_adj_cd    = i.priv_adj_cd)
                LOOP
                    res.private_adjuster := j.payee_name;
                END LOOP;
                
--                FOR k IN (SELECT cancel_date 
--                            FROM gicl_clm_adj_hist
--                           WHERE adj_company_cd = i.adj_company_cd
--                             AND priv_adj_cd    = i.priv_adj_cd)
--                LOOP
--                    res.cancel_date := k.cancel_date;
--                END LOOP;
                BEGIN
                    SELECT cancel_date
                    INTO res.cancel_date
                            FROM gicl_clm_adj_hist x
                           WHERE adj_hist_no = (SELECT MAX (adj_hist_no)
                                                  FROM GICL_CLM_ADJ_HIST g
                                                 WHERE g.claim_id = x.claim_id
                                                   AND g.adj_company_cd = x.adj_company_cd
                                                   AND g.cancel_date IS NOT NULL)
                             AND claim_id = i.claim_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        res.cancel_date := NULL;        
                END; 
                
                IF res.cancel_date IS NULL THEN 
                    res.no_of_days    := TRUNC(NVL(i.complt_date, SYSDATE)) - TRUNC (i.assign_date);
                ELSE
                    res.no_of_days    := NULL;
                END IF;
                
                FOR l IN (SELECT SUM(paid_amt) paid_amt
                            FROM gicl_clm_loss_exp
                           WHERE payee_cd       = i.adj_company_cd
                             AND payee_class_cd = (SELECT param_value_v
                                                       FROM giac_parameters
                                                      WHERE param_name = 'ADJP_CLASS_CD')
                             AND tran_id IS NOT NULL
                             AND claim_id = i.claim_id)
                LOOP
                    res.paid_amt := NVL(l.paid_amt, 0);
                END LOOP;
                
                FOR m IN (SELECT param_value_v 
                            FROM giis_parameters
                           WHERE UPPER(param_name) = 'COMPANY_NAME')
                LOOP
                    res.company_name := m.param_value_v;
                END LOOP;
         
                FOR n IN (SELECT param_value_v 
                            FROM giis_parameters
                           WHERE UPPER(param_name) = 'COMPANY_ADDRESS')
                LOOP
                    res.company_address := n.param_value_v;
                END LOOP;
                
                IF p_as_of_date IS NOT NULL THEN
                    res.date_type := ('Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
                    res.date_type := ('Claim File Date From '||TO_CHAR(TO_DATE(p_from_date,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_date,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_as_of_ldate IS NOT NULL THEN
                    res.date_type := ('Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
                    res.date_type := ('Loss Date From '||TO_CHAR(TO_DATE(p_from_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_as_of_adate IS NOT NULL THEN 
                    res.date_type := ('Date Assigned As of '||TO_CHAR(TO_DATE(p_as_of_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_adate IS NOT NULL AND p_to_adate IS NOT NULL THEN
                    res.date_type := ('Date Assigned From '||TO_CHAR(TO_DATE(p_from_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));                
                ELSE
                    res.date_type := NULL;                
                END IF;
                            
                PIPE ROW(res);
            END LOOP;
        ELSIF p_stat = 'cancelled' THEN 
            FOR i IN (SELECT b.payee_no||' - '||DECODE(b.payee_first_name, '-', b.payee_last_name, b.payee_first_name||' '||b.payee_middle_name||' '||b.payee_last_name) payee_name, 
                             b.payee_class_cd,  f.clm_stat_desc, d.assign_date, d.complt_date, 
                             a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd ||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR( a.clm_seq_no,'0000009')) claim_no,
                             a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd ||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')) policy_no,
                             a.assured_name, a.loss_date, a.clm_file_date, d.adj_company_cd, d.priv_adj_cd, d.claim_id
                        FROM gicl_claims a, giis_payees b, gicl_clm_adjuster d, giis_clm_stat f 
                       WHERE b.payee_class_cd = (SELECT param_value_v 
                                                   FROM giac_parameters 
                                                  WHERE param_name = 'ADJP_CLASS_CD')
                         AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,'GICLS257',p_user_id) = 1                         
                         AND f.clm_stat_cd = a.clm_stat_cd
                         AND a.claim_id = d.claim_id
                         AND b.payee_no = d.adj_company_cd
                         AND b.payee_no = p_payee_no
                         AND ((TRUNC(a.clm_file_date)    >= TO_DATE(p_from_date,'mm/dd/yyyy')
                              AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                               OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                          OR (TRUNC(a.loss_date)     >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                              AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                               OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy'))
                          OR (TRUNC(d.assign_date)     >= TO_DATE(p_from_adate,'mm/dd/yyyy')
                              AND TRUNC(d.assign_date) <= TO_DATE(p_to_adate,'mm/dd/yyyy')
                               OR TRUNC(d.assign_date) <= TO_DATE(p_as_of_adate,'mm/dd/yyyy')))  
                         AND d.claim_id IN (SELECT claim_id
                                              FROM gicl_claims 
                                             WHERE check_user_per_line2(line_cd,ISS_CD,'GICLS257',p_user_id)=1)  
                         AND d.claim_id IN (SELECT d.claim_id 
                                              FROM gicl_clm_adjuster d, gicl_claims a
                                             WHERE a.claim_id = d.claim_id                         
                                               AND ((TRUNC(a.clm_file_date)    >= TO_DATE(p_from_date,'mm/dd/yyyy')
                                                    AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                                                     OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                                                OR (TRUNC(a.loss_date)     >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                                                    AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                                                     OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy'))
                                                OR (TRUNC(d.assign_date)     >= TO_DATE(p_from_adate,'mm/dd/yyyy')
                                                    AND TRUNC(d.assign_date) <= TO_DATE(p_to_adate,'mm/dd/yyyy')
                                                     OR TRUNC(d.assign_date) <= TO_DATE(p_as_of_adate,'mm/dd/yyyy')))  
                                               AND adj_company_cd = p_payee_no
                                               AND cancel_tag = 'Y')                   
                       ORDER BY b.payee_first_name, b.payee_last_name, b.payee_middle_name, a.line_cd, a.subline_cd, 
                                a.iss_cd, a.clm_yy, a.clm_seq_no, a.assured_name, a.issue_yy, a.renew_no, a.pol_seq_no, 
                                a.loss_date, d.priv_adj_cd, d.adj_company_cd, b.payee_class_cd,a.clm_file_date) 
            LOOP
                res.payee_name    := i.payee_name;
                res.claim_no      := i.claim_no;
                res.policy_no     := i.policy_no;
                res.assured_name  := i.assured_name;
                res.loss_date     := i.loss_date;
                res.clm_file_date := i.clm_file_date;
                res.clm_stat_desc := i.clm_stat_desc;
                res.assign_date   := i.assign_date;
                res.complt_date   := i.complt_date;         
--                res.no_of_days    := TRUNC(NVL(i.complt_date,SYSDATE)) - TRUNC(i.assign_date);      
                      
                FOR j IN (SELECT payee_name
                            FROM giis_adjuster
                           WHERE adj_company_cd = i.adj_company_cd
                             AND priv_adj_cd    = i.priv_adj_cd)
                LOOP
                    res.private_adjuster := j.payee_name;
                END LOOP;
                
--                FOR k IN (SELECT cancel_date 
--                            FROM gicl_clm_adj_hist
--                           WHERE adj_company_cd = i.adj_company_cd
--                             AND priv_adj_cd    = i.priv_adj_cd)
--                LOOP
--                    res.cancel_date := k.cancel_date;
--                END LOOP;
                BEGIN
                    SELECT cancel_date
                    INTO res.cancel_date
                            FROM gicl_clm_adj_hist x
                           WHERE adj_hist_no = (SELECT MAX (adj_hist_no)
                                                  FROM GICL_CLM_ADJ_HIST g
                                                 WHERE g.claim_id = x.claim_id
                                                   AND g.adj_company_cd = x.adj_company_cd
                                                   AND g.cancel_date IS NOT NULL)
                             AND claim_id = i.claim_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        res.cancel_date := NULL;        
                END; 
                
                IF res.cancel_date IS NULL THEN 
                    res.no_of_days    := TRUNC(NVL(i.complt_date, SYSDATE)) - TRUNC (i.assign_date);
                ELSE
                    res.no_of_days    := NULL;
                END IF;
                
                FOR l IN (SELECT SUM(paid_amt) paid_amt
                            FROM gicl_clm_loss_exp
                           WHERE payee_cd       = i.adj_company_cd
                             AND payee_class_cd = (SELECT param_value_v
                                                       FROM giac_parameters
                                                      WHERE param_name = 'ADJP_CLASS_CD')
                             AND tran_id IS NOT NULL
                             AND claim_id = i.claim_id)
                LOOP
                    res.paid_amt := NVL(l.paid_amt, 0);
                END LOOP;
                
                FOR m IN (SELECT param_value_v 
                            FROM giis_parameters
                           WHERE UPPER(param_name) = 'COMPANY_NAME')
                LOOP
                    res.company_name := m.param_value_v;
                END LOOP;
         
                FOR n IN (SELECT param_value_v 
                            FROM giis_parameters
                           WHERE UPPER(param_name) = 'COMPANY_ADDRESS')
                LOOP
                    res.company_address := n.param_value_v;
                END LOOP;
                
                IF p_as_of_date IS NOT NULL THEN
                    res.date_type := ('Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
                    res.date_type := ('Claim File Date From '||TO_CHAR(TO_DATE(p_from_date,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_date,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_as_of_ldate IS NOT NULL THEN
                    res.date_type := ('Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
                    res.date_type := ('Loss Date From '||TO_CHAR(TO_DATE(p_from_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_as_of_adate IS NOT NULL THEN 
                    res.date_type := ('Date Assigned As of '||TO_CHAR(TO_DATE(p_as_of_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_adate IS NOT NULL AND p_to_adate IS NOT NULL THEN
                    res.date_type := ('Date Assigned From '||TO_CHAR(TO_DATE(p_from_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));                
                ELSE
                    res.date_type := NULL;                
                END IF;
                            
                PIPE ROW(res);
            END LOOP;
        ELSIF p_stat = 'completed' THEN
            FOR i IN (SELECT b.payee_no||' - '||DECODE(b.payee_first_name, '-', b.payee_last_name, b.payee_first_name||' '||b.payee_middle_name||' '||b.payee_last_name) payee_name, 
                             b.payee_class_cd,  f.clm_stat_desc, d.assign_date, d.complt_date, 
                             a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd ||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR( a.clm_seq_no,'0000009')) claim_no,
                             a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd ||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')) policy_no,
                             a.assured_name, a.loss_date, a.clm_file_date, d.adj_company_cd, d.priv_adj_cd, d.claim_id
                        FROM gicl_claims a, giis_payees b, gicl_clm_adjuster d, giis_clm_stat f 
                       WHERE b.payee_class_cd = (SELECT param_value_v 
                                                   FROM giac_parameters 
                                                  WHERE param_name = 'ADJP_CLASS_CD')
                         AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,'GICLS257',p_user_id) = 1                         
                         AND f.clm_stat_cd = a.clm_stat_cd
                         AND a.claim_id = d.claim_id
                         AND b.payee_no = d.adj_company_cd
                         AND b.payee_no = p_payee_no
                         AND ((TRUNC(a.clm_file_date)    >= TO_DATE(p_from_date,'mm/dd/yyyy')
                              AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                               OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                          OR (TRUNC(a.loss_date)     >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                              AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                               OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy'))
                          OR (TRUNC(d.assign_date)     >= TO_DATE(p_from_adate,'mm/dd/yyyy')
                              AND TRUNC(d.assign_date) <= TO_DATE(p_to_adate,'mm/dd/yyyy')
                               OR TRUNC(d.assign_date) <= TO_DATE(p_as_of_adate,'mm/dd/yyyy'))) 
                         AND d.claim_id IN (SELECT claim_id
                                              FROM gicl_claims 
                                             WHERE check_user_per_line2(line_cd,ISS_CD,'GICLS257',p_user_id)=1)  
                         AND d.claim_id IN (SELECT d.claim_id 
                                              FROM gicl_clm_adjuster d, gicl_claims a
                                             WHERE a.claim_id = d.claim_id                         
                                               AND ((TRUNC(a.clm_file_date)    >= TO_DATE(p_from_date,'mm/dd/yyyy')
                                                    AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                                                     OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                                                OR (TRUNC(a.loss_date)     >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                                                    AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                                                     OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy'))
                                                OR (TRUNC(d.assign_date)     >= TO_DATE(p_from_adate,'mm/dd/yyyy')
                                                    AND TRUNC(d.assign_date) <= TO_DATE(p_to_adate,'mm/dd/yyyy')
                                                     OR TRUNC(d.assign_date) <= TO_DATE(p_as_of_adate,'mm/dd/yyyy')))  
                                               AND adj_company_cd = p_payee_no
                                               AND complt_date IS NOT NULL)                    
                       ORDER BY b.payee_first_name, b.payee_last_name, b.payee_middle_name, a.line_cd, a.subline_cd, 
                                a.iss_cd, a.clm_yy, a.clm_seq_no, a.assured_name, a.issue_yy, a.renew_no, a.pol_seq_no, 
                                a.loss_date, d.priv_adj_cd, d.adj_company_cd, b.payee_class_cd,a.clm_file_date) 
            LOOP
                res.payee_name    := i.payee_name;
                res.claim_no      := i.claim_no;
                res.policy_no     := i.policy_no;
                res.assured_name  := i.assured_name;
                res.loss_date     := i.loss_date;
                res.clm_file_date := i.clm_file_date;
                res.clm_stat_desc := i.clm_stat_desc;
                res.assign_date   := i.assign_date;
                res.complt_date   := i.complt_date;         
--                res.no_of_days    := TRUNC(NVL(i.complt_date,SYSDATE)) - TRUNC(i.assign_date);      
                      
                FOR j IN (SELECT payee_name
                            FROM giis_adjuster
                           WHERE adj_company_cd = i.adj_company_cd
                             AND priv_adj_cd    = i.priv_adj_cd)
                LOOP
                    res.private_adjuster := j.payee_name;
                END LOOP;
                
--                FOR k IN (SELECT cancel_date 
--                            FROM gicl_clm_adj_hist
--                           WHERE adj_company_cd = i.adj_company_cd
--                             AND priv_adj_cd    = i.priv_adj_cd)
--                LOOP
--                    res.cancel_date := k.cancel_date;
--                END LOOP;
                BEGIN
                    SELECT cancel_date
                    INTO res.cancel_date
                            FROM gicl_clm_adj_hist x
                           WHERE adj_hist_no = (SELECT MAX (adj_hist_no)
                                                  FROM GICL_CLM_ADJ_HIST g
                                                 WHERE g.claim_id = x.claim_id
                                                   AND g.adj_company_cd = x.adj_company_cd
                                                   AND g.cancel_date IS NOT NULL)
                             AND claim_id = i.claim_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        res.cancel_date := NULL;        
                END; 

                IF res.cancel_date IS NULL THEN 
                    res.no_of_days    := TRUNC(NVL(i.complt_date, SYSDATE)) - TRUNC (i.assign_date);
                ELSE
                    res.no_of_days    := NULL;
                END IF;
                
                FOR l IN (SELECT SUM(paid_amt) paid_amt
                            FROM gicl_clm_loss_exp
                           WHERE payee_cd       = i.adj_company_cd
                             AND payee_class_cd = (SELECT param_value_v
                                                       FROM giac_parameters
                                                      WHERE param_name = 'ADJP_CLASS_CD')
                             AND tran_id IS NOT NULL
                             AND claim_id = i.claim_id)
                LOOP
                    res.paid_amt := NVL(l.paid_amt, 0);
                END LOOP;
                
                FOR m IN (SELECT param_value_v 
                            FROM giis_parameters
                           WHERE UPPER(param_name) = 'COMPANY_NAME')
                LOOP
                    res.company_name := m.param_value_v;
                END LOOP;
         
                FOR n IN (SELECT param_value_v 
                            FROM giis_parameters
                           WHERE UPPER(param_name) = 'COMPANY_ADDRESS')
                LOOP
                    res.company_address := n.param_value_v;
                END LOOP;
                
                IF p_as_of_date IS NOT NULL THEN
                    res.date_type := ('Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
                    res.date_type := ('Claim File Date From '||TO_CHAR(TO_DATE(p_from_date,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_date,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_as_of_ldate IS NOT NULL THEN
                    res.date_type := ('Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
                    res.date_type := ('Loss Date From '||TO_CHAR(TO_DATE(p_from_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_as_of_adate IS NOT NULL THEN 
                    res.date_type := ('Date Assigned As of '||TO_CHAR(TO_DATE(p_as_of_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_adate IS NOT NULL AND p_to_adate IS NOT NULL THEN
                    res.date_type := ('Date Assigned From '||TO_CHAR(TO_DATE(p_from_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));                
                ELSE
                    res.date_type := NULL;                
                END IF;
                            
                PIPE ROW(res);
            END LOOP;             
        ELSE
            FOR i IN (SELECT b.payee_no||' - '||DECODE(b.payee_first_name, '-', b.payee_last_name, b.payee_first_name||' '||b.payee_middle_name||' '||b.payee_last_name) payee_name, 
                             b.payee_class_cd,  f.clm_stat_desc, d.assign_date, d.complt_date, 
                             a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd ||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR( a.clm_seq_no,'0000009')) claim_no,
                             a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd ||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')) policy_no,
                             a.assured_name, a.loss_date, a.clm_file_date, d.adj_company_cd, d.priv_adj_cd, d.claim_id
                        FROM gicl_claims a, giis_payees b, gicl_clm_adjuster d, giis_clm_stat f 
                       WHERE b.payee_class_cd = (SELECT param_value_v 
                                                   FROM giac_parameters 
                                                  WHERE param_name = 'ADJP_CLASS_CD')
                         AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,'GICLS257',p_user_id) = 1                         
                         AND f.clm_stat_cd = a.clm_stat_cd
                         AND a.claim_id = d.claim_id
                         AND b.payee_no = d.adj_company_cd
                         AND b.payee_no = p_payee_no
                         AND ((TRUNC(a.clm_file_date)    >= TO_DATE(p_from_date,'mm/dd/yyyy')
                              AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                               OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                          OR (TRUNC(a.loss_date)     >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                              AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                               OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy'))
                          OR (TRUNC(d.assign_date)     >= TO_DATE(p_from_adate,'mm/dd/yyyy')
                              AND TRUNC(d.assign_date) <= TO_DATE(p_to_adate,'mm/dd/yyyy')
                               OR TRUNC(d.assign_date) <= TO_DATE(p_as_of_adate,'mm/dd/yyyy')))                     
                       ORDER BY b.payee_first_name, b.payee_last_name, b.payee_middle_name, a.line_cd, a.subline_cd, 
                                a.iss_cd, a.clm_yy, a.clm_seq_no, a.assured_name, a.issue_yy, a.renew_no, a.pol_seq_no, 
                                a.loss_date, d.priv_adj_cd, d.adj_company_cd, b.payee_class_cd,a.clm_file_date) 
            LOOP
                res.payee_name    := i.payee_name;
                res.claim_no      := i.claim_no;
                res.policy_no     := i.policy_no;
                res.assured_name  := i.assured_name;
                res.loss_date     := i.loss_date;
                res.clm_file_date := i.clm_file_date;
                res.clm_stat_desc := i.clm_stat_desc;
                res.assign_date   := i.assign_date;
                res.complt_date   := i.complt_date;         
--                res.no_of_days    := TRUNC(NVL(i.complt_date,SYSDATE)) - TRUNC(i.assign_date);      
                      
                FOR j IN (SELECT payee_name
                            FROM giis_adjuster
                           WHERE adj_company_cd = i.adj_company_cd
                             AND priv_adj_cd    = i.priv_adj_cd)
                LOOP
                    res.private_adjuster := j.payee_name;
                END LOOP;
                
--                FOR k IN (SELECT cancel_date 
--                            FROM gicl_clm_adj_hist
--                           WHERE adj_company_cd = i.adj_company_cd
--                             AND priv_adj_cd    = i.priv_adj_cd)
--                LOOP
--                    res.cancel_date := k.cancel_date;
--                END LOOP;

                BEGIN
                    SELECT cancel_date
                    INTO res.cancel_date
                            FROM gicl_clm_adj_hist x
                           WHERE adj_hist_no = (SELECT MAX (adj_hist_no)
                                                  FROM GICL_CLM_ADJ_HIST g
                                                 WHERE g.claim_id = x.claim_id
                                                   AND g.adj_company_cd = x.adj_company_cd
                                                   AND g.cancel_date IS NOT NULL)
                             AND claim_id = i.claim_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        res.cancel_date := NULL;        
                END; 

                IF res.cancel_date IS NULL THEN 
                    res.no_of_days    := TRUNC(NVL(i.complt_date, SYSDATE)) - TRUNC (i.assign_date);
                ELSE
                    res.no_of_days    := NULL;
                END IF;    
                            
                FOR l IN (SELECT SUM(paid_amt) paid_amt
                            FROM gicl_clm_loss_exp
                           WHERE payee_cd       = i.adj_company_cd
                             AND payee_class_cd = (SELECT param_value_v
                                                       FROM giac_parameters
                                                      WHERE param_name = 'ADJP_CLASS_CD')
                             AND tran_id IS NOT NULL
                             AND claim_id = i.claim_id)
                LOOP
                    res.paid_amt := NVL(l.paid_amt, 0);
                END LOOP;
                
                FOR m IN (SELECT param_value_v 
                            FROM giis_parameters
                           WHERE UPPER(param_name) = 'COMPANY_NAME')
                LOOP
                    res.company_name := m.param_value_v;
                END LOOP;
         
                FOR n IN (SELECT param_value_v 
                            FROM giis_parameters
                           WHERE UPPER(param_name) = 'COMPANY_ADDRESS')
                LOOP
                    res.company_address := n.param_value_v;
                END LOOP;
                
                IF p_as_of_date IS NOT NULL THEN
                    res.date_type := ('Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
                    res.date_type := ('Claim File Date From '||TO_CHAR(TO_DATE(p_from_date,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_date,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_as_of_ldate IS NOT NULL THEN
                    res.date_type := ('Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
                    res.date_type := ('Loss Date From '||TO_CHAR(TO_DATE(p_from_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_as_of_adate IS NOT NULL THEN 
                    res.date_type := ('Date Assigned As of '||TO_CHAR(TO_DATE(p_as_of_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
                ELSIF p_from_adate IS NOT NULL AND p_to_adate IS NOT NULL THEN
                    res.date_type := ('Date Assigned From '||TO_CHAR(TO_DATE(p_from_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_adate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));                
                ELSE
                    res.date_type := NULL;                
                END IF;
                            
                PIPE ROW(res);
            END LOOP;             
        END IF;
    END;
    
END GICLR257_PKG;
/


