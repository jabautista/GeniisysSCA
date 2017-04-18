CREATE OR REPLACE PACKAGE BODY CPI.GIACS289_PKG
    AS
    FUNCTION get_bill_per_policy_lov(
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_intm_no           GIIS_INTERMEDIARY.intm_no%TYPE,
            p_assd_no           GIIS_ASSURED.assd_no%TYPE,
            p_module_id         giis_modules.module_id%TYPE,
            p_user_id           giis_users.user_id%TYPE
    )
            RETURN bill_per_policy_lov_tab PIPELINED
    IS
            v_list bill_per_policy_lov_type;
    BEGIN
        FOR i IN(  
        SELECT DISTINCT --gp.policy_id,
                 gp.line_cd, gp.subline_cd, gp.iss_cd, gp.issue_yy,
                 gp.pol_seq_no, gp.renew_no, gp.ref_pol_no,gi.intm_no, gi.intm_name, ga.assd_no,ga.assd_name
            FROM gipi_polbasic gp, gipi_comm_invoice gci, giis_assured ga,
                 giis_intermediary gi
           WHERE gp.policy_id = gci.policy_id
             AND gci.intrmdry_intm_no = gi.intm_no
             AND gp.assd_no = ga.assd_no
             AND gp.line_cd = NVL(p_line_cd ,gp.line_cd)
             AND gp.subline_cd = NVL(p_subline_cd  ,gp.subline_cd)
             AND gp.iss_cd = NVL(p_iss_cd ,gp.iss_cd)
             AND gp.issue_yy = NVL(p_issue_yy ,gp.issue_yy)
             AND gp.pol_seq_no = NVL(p_pol_seq_no ,gp.pol_seq_no)
             AND gp.renew_no = NVL(p_renew_no ,gp.renew_no)
             AND gi.intm_no = NVL(p_intm_no ,gi.intm_no)
             AND ga.assd_no = NVL(p_assd_no ,ga.assd_no)
            -- AND check_user_per_iss_cd2(NULL, gp.iss_cd, p_module_id, p_user_id) = 1
             AND ((SELECT access_tag
                     FROM giis_user_modules
                    WHERE userid = p_user_id
                      AND module_id = p_module_id
                      AND tran_cd IN (SELECT b.tran_cd 
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = p_user_id
                                         AND b.iss_cd = gp.iss_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = p_module_id)) = 1
                    OR 
                  (SELECT access_tag
                     FROM giis_user_grp_modules
                    WHERE module_id = p_module_id
                      AND (user_grp, tran_cd) IN (SELECT a.user_grp, b.tran_cd
                                                    FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                   WHERE a.user_grp = b.user_grp
                                                     AND a.user_id = p_user_id
                                                     AND b.iss_cd = gp.iss_cd
                                                     AND b.tran_cd = c.tran_cd
                                                     AND c.module_id = p_module_id)) = 1
                    )
             )
        LOOP
            --v_list.policy_id    :=  i.policy_id;  
            v_list.line_cd      :=  i.line_cd;    
            v_list.subline_cd   :=  i.subline_cd; 
            v_list.iss_cd       :=  i.iss_cd;     
            v_list.issue_yy     :=  i.issue_yy;   
            v_list.pol_seq_no   :=  i.pol_seq_no; 
            v_list.renew_no     :=  i.renew_no;   
            v_list.ref_pol_no   :=  i.ref_pol_no; 
            v_list.intm_no      :=  i.intm_no;    
            v_list.intm_name    :=  i.intm_name;  
            v_list.assd_no      :=  i.assd_no;    
            v_list.assd_name    :=  i.assd_name;
            --v_list.policy_no    :=  get_policy_no(i.policy_id);    
                   
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
    END get_bill_per_policy_lov;
    
    FUNCTION get_bill_per_policy2 ( 
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_intm_no           GIIS_INTERMEDIARY.intm_no%TYPE,
            p_prem_os           VARCHAR2,
            p_prem_comm_os      VARCHAR2
    ) 
        RETURN bill_per_policy_tab PIPELINED
    IS
        v_list bill_per_policy_type;
        v_exists                VARCHAR2(1) := 'N';
        
    BEGIN
        FOR i IN (
            SELECT gi.currency_rt, gp.line_cd, gp.subline_cd, gp.iss_cd iss_cd_gp, gp.issue_yy,
                gp.pol_seq_no, gp.renew_no, gp.endt_iss_cd, gp.endt_yy,
                gp.endt_seq_no, gi.iss_cd, gi.prem_seq_no,
                NVL (gi.prem_amt, 0) prem_amt, NVL (gi.tax_amt, 0) tax_amt,
                NVL (gi.prem_amt, 0) + NVL (gi.tax_amt, 0) receivable,
                  (NVL (gi.prem_amt, 0)
                + NVL (gi.tax_amt, 0) 
                - NVL ((SELECT SUM (NVL (a.collection_amt, 0) / convert_rate) ---
                          FROM giac_direct_prem_collns a, giac_acctrans b
                         WHERE a.b140_prem_seq_no = gi.prem_seq_no
                           AND a.b140_iss_cd = gi.iss_cd
                           AND a.gacc_tran_id = b.tran_id
                           AND b.tran_flag <> 'D'
                           AND NOT EXISTS (
                                  SELECT x.gacc_tran_id
                                    FROM giac_reversals x, giac_acctrans y
                                   WHERE x.reversing_tran_id = y.tran_id
                                     AND y.tran_flag <> 'D'
                                     AND x.gacc_tran_id = a.gacc_tran_id)),
                       0
                      ))  prem_os,
                NVL ((SELECT SUM (NVL (a.collection_amt, 0)) ---
                        FROM giac_direct_prem_collns a, giac_acctrans b
                       WHERE a.b140_prem_seq_no = gi.prem_seq_no
                         AND a.b140_iss_cd = gi.iss_cd
                         AND a.gacc_tran_id = b.tran_id
                         AND b.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT x.gacc_tran_id
                                  FROM giac_reversals x, giac_acctrans y
                                 WHERE x.reversing_tran_id = y.tran_id
                                   AND y.tran_flag <> 'D'
                                   AND x.gacc_tran_id = a.gacc_tran_id)),
                     0
                    ) prem_paid,
                NVL ((SELECT SUM (  ((NVL (a.comm_amt, 0))
                                  - NVL (a.wtax_amt, 0)
                                  + NVL (a.input_vat_amt, 0))      -- uncommented wtax_amt and input_vat_amt : shan 11.24.2014
                                  
                                ) ---
                        FROM giac_comm_payts a, giac_acctrans b
                       WHERE a.prem_seq_no = gi.prem_seq_no
                         AND a.iss_cd = gi.iss_cd
                         AND a.intm_no = p_intm_no     -- must be per intm_no : shan 11.21.2014
                         AND a.gacc_tran_id = b.tran_id
                         AND b.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT x.gacc_tran_id
                                  FROM giac_reversals x, giac_acctrans y
                                 WHERE x.reversing_tran_id = y.tran_id
                                   AND y.tran_flag <> 'D'
                                   AND x.gacc_tran_id = a.gacc_tran_id)),
                     0
                    ) comm_paid, ga.assd_no, ga.assd_name
            FROM gipi_polbasic gp, gipi_invoice gi,giis_assured ga
            WHERE gp.policy_id = gi.policy_id
            AND gp.pol_flag <> '5'
            AND ga.assd_no  = gp.assd_no
            AND gp.line_cd  = p_line_cd
            AND gp.subline_cd = p_subline_cd
            AND gp.iss_cd   = p_iss_cd
            AND gp.issue_yy = p_issue_yy
            AND gp.pol_seq_no = p_pol_seq_no
            AND gp.renew_no = p_renew_no
            )
            LOOP
                v_list.currency_rt  :=  i.currency_rt; 
                v_list.line_cd      :=  i.line_cd;    
                v_list.subline_cd   :=  i.subline_cd; 
                v_list.iss_cd_gp    :=  i.iss_cd_gp;     
                v_list.issue_yy     :=  i.issue_yy;   
                v_list.pol_seq_no   :=  i.pol_seq_no; 
                v_list.renew_no     :=  i.renew_no;   
                v_list.endt_iss_cd  :=  i.endt_iss_cd; 
                v_list.endt_yy      :=  i.endt_yy;    
                v_list.endt_seq_no  :=  i.endt_seq_no;  
                v_list.iss_cd       :=  i.iss_cd;    
                v_list.prem_seq_no  :=  i.prem_seq_no;
                v_list.prem_amt     :=  i.prem_amt;    
                v_list.tax_amt      :=  i.tax_amt; 
                v_list.receivable   :=  i.receivable;     
                v_list.prem_os      :=  i.prem_os;   
                v_list.prem_paid    :=  i.prem_paid; 
                v_list.comm_paid    :=  i.comm_paid; 
                    
                v_list.comm    := 0; 
                v_list.wtax    := 0; 
                v_list.ivat    := 0; 
                v_exists       := 'N'; 
                
                FOR j IN (
                 SELECT a.commission_amt, a.wholding_tax, NVL(c.input_vat_paid, 0)+((NVL(a.commission_amt, 0)-NVL(c.comm_amt, 0))*(NVL(b.input_vat_rate, 0)/100)) input_vat
                                  FROM gipi_comm_inv_dtl a, giis_intermediary b, 
                                       (SELECT j.intm_no, j.iss_cd, j.prem_seq_no,
                                                 SUM(j.comm_amt) comm_amt, SUM(j.wtax_amt) w_tax_amt,
                                                     SUM(j.input_vat_amt) input_vat_paid
                                              FROM giac_comm_payts j, giac_acctrans k
                                             WHERE j.gacc_tran_id = k.tran_id
                                               AND k.tran_flag <> 'D'
                                               AND NOT EXISTS (SELECT 1
                                                                 FROM giac_reversals x, giac_acctrans y
                                                                        WHERE x.REVERSING_TRAN_ID = y.tran_id
                                                                            AND y.tran_flag <> 'D'
                                                                            AND x.gacc_tran_id = j.gacc_tran_id)
                                             GROUP BY intm_no, iss_cd, prem_seq_no) c
                                 WHERE a.intrmdry_intm_no = b.intm_no
                                   AND a.iss_cd = c.iss_cd(+)
                                   AND a.prem_seq_no = c.prem_seq_no(+)
                                   AND a.intrmdry_intm_no = c.intm_no(+)
                                   AND a.iss_cd = i.iss_cd
                                   AND a.prem_seq_no = i.prem_seq_no
                                   AND a.intrmdry_intm_no = p_intm_no           
                )
                LOOP
                    v_exists       := 'Y';
                    v_list.comm    :=  NVL(j.commission_amt,0);   
                    v_list.wtax    :=  NVL(j.wholding_tax,0); 
                    v_list.ivat    :=  NVL(j.input_vat,0);
                END LOOP; 
                    
                IF v_exists = 'N' THEN
                    FOR j IN (
                         SELECT a.commission_amt, a.wholding_tax, NVL(c.input_vat_paid, 0)+((NVL(a.commission_amt, 0)-NVL(c.comm_amt, 0))*(NVL(b.input_vat_rate, 0)/100)) input_vat
                                      FROM gipi_comm_invoice a, giis_intermediary b, 
                                           (SELECT j.intm_no, j.iss_cd, j.prem_seq_no,
                                                     SUM(j.comm_amt) comm_amt, SUM(j.wtax_amt) w_tax_amt,
                                                         SUM(j.input_vat_amt) input_vat_paid
                                                  FROM giac_comm_payts j, giac_acctrans k
                                                 WHERE j.gacc_tran_id = k.tran_id
                                                   AND k.tran_flag <> 'D'
                                                   AND NOT EXISTS (SELECT 1
                                                                     FROM giac_reversals x, giac_acctrans y
                                                                            WHERE x.REVERSING_TRAN_ID = y.tran_id
                                                                                AND y.tran_flag <> 'D'
                                                                                AND x.gacc_tran_id = j.gacc_tran_id)
                                                 GROUP BY intm_no, iss_cd, prem_seq_no) c
                                     WHERE a.intrmdry_intm_no = b.intm_no
                                       AND a.iss_cd = c.iss_cd(+)
                                       AND a.prem_seq_no = c.prem_seq_no(+)
                                       AND a.intrmdry_intm_no = c.intm_no(+)
                                       AND a.iss_cd = i.iss_cd
                                       AND a.prem_seq_no = i.prem_seq_no
                                       AND a.intrmdry_intm_no = p_intm_no           
                    )
                    LOOP
                        v_exists       := 'Y';
                        v_list.comm    :=  NVL(j.commission_amt,0);   
                        v_list.wtax    :=  NVL(j.wholding_tax,0); 
                        v_list.ivat    :=  NVL(j.input_vat,0);
                    END LOOP; 
                END IF;
                    
                 v_list.net_comm  := NVL(v_list.comm,0) - NVL(v_list.wtax,0) + NVL(v_list.ivat,0);
                 v_list.net_recv  := NVL(v_list.receivable,0) - NVL(v_list.net_comm,0); 
                 --v_list.comm_os   := (v_list.comm * v_list.currency_rt)- v_list.comm_paid;
                 v_list.comm_os   := v_list.net_comm - v_list.comm_paid; -- bonok :: 6.10.2015 :: SR4638 replaced based on fmb
                
                IF p_prem_os = 0 THEN
                   IF v_list.prem_os = 0 THEN 
                        PIPE ROW(v_list); 
                   END IF;  
                ELSIF  p_prem_comm_os = 0 THEN
                   IF v_list.comm_os = 0 AND v_list.prem_os = 0 THEN 
                        PIPE ROW(v_list); 
                   END IF;
                ELSE
                    null;  
                END IF;
                
            END LOOP;
    RETURN;
    END;
    
    FUNCTION get_bill_per_policy_table( 
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_intm_no           GIIS_INTERMEDIARY.intm_no%TYPE,
            p_prem_os           VARCHAR2,
            p_prem_comm_os      VARCHAR2
    )
    RETURN bill_per_policy_tab PIPELINED
    IS
        v_list bill_per_policy_type;
        counter NUMBER;
        
    BEGIN
        counter :=0;
        FOR i IN (
            SELECT a.*,SUM(prem_os) over() prem_os_total,SUM(tax_amt) over() tax_amt_total,SUM(prem_amt) over() prem_amt_total,SUM(receivable) over() receivable_total,SUM(prem_paid) over() prem_paid_total,
               SUM(comm_paid) over() comm_paid_total,SUM(comm) over() comm_total,SUM(wtax) over() wtax_total,SUM(ivat) over() ivat_total,SUM(net_comm) over() net_comm_total,SUM(net_recv) over() net_recv_total,SUM(comm_os) over() comm_os_total FROM TABLE (get_bill_per_policy(p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,p_intm_no)) a 
            MINUS
            SELECT b.*,SUM(prem_os) over() prem_os_total1,SUM(tax_amt) over() tax_amt_total1,SUM(prem_amt) over() prem_amt_total1,SUM(receivable) over() receivable_total1,SUM(prem_paid) over() prem_paid_total,
               SUM(comm_paid) over() comm_paid_total1,SUM(comm) over() comm_total1,SUM(wtax) over() wtax_total1,SUM(ivat) over() ivat_total1,SUM(net_comm) over() net_comm_total1,SUM(net_recv) over() net_recv_total1,SUM(comm_os) over() comm_os_total1 FROM TABLE (get_bill_per_policy2(p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,p_intm_no, p_prem_os, p_prem_comm_os)) b 
        )
        LOOP
            v_list.currency_rt := i.currency_rt;
            v_list.line_cd     := i.line_cd;   
            v_list.subline_cd  := i.subline_cd;  
            v_list.iss_cd_gp   := i.iss_cd_gp;   
            v_list.issue_yy    := i.issue_yy;    
            v_list.pol_seq_no  := i.pol_seq_no;  
            v_list.renew_no    := i.renew_no;    
            v_list.endt_iss_cd := i.endt_iss_cd; 
            v_list.endt_yy     := i.endt_yy;     
            v_list.endt_seq_no := i.endt_seq_no; 
            v_list.iss_cd      := i.iss_cd;      
            v_list.prem_seq_no := i.prem_seq_no; 
            v_list.prem_amt    := i.prem_amt * i.currency_rt;       
            v_list.tax_amt     := i.tax_amt * i.currency_rt;         
            v_list.receivable  := i.receivable * i.currency_rt;  
            v_list.prem_os     := i.prem_os * i.currency_rt;   
            v_list.comm_os     := i.comm_os;       
            v_list.prem_paid   := i.prem_paid;     
            v_list.comm_paid   := i.comm_paid;     
            v_list.comm        := i.comm * i.currency_rt;             
            v_list.wtax        := i.wtax * i.currency_rt;             
            v_list.ivat        := i.ivat * i.currency_rt;
            v_list.net_comm    := i.net_comm * i.currency_rt;       
            v_list.net_recv    := i.net_recv * i.currency_rt;
            --ADDED BY MarkS 04.25.2016 SR-22136
            v_list.prem_os_tot := i.prem_os_total;
            v_list.prem_amt_tot       := i.prem_amt_total;
            v_list.tax_amt_tot        := i.tax_amt_total;
            v_list.receivable_tot  := i.receivable_total * i.currency_rt;  
            v_list.prem_os_tot     := i.prem_os_total * i.currency_rt;   
            v_list.comm_os_tot     := i.comm_os_total;       
            v_list.prem_paid_tot   := i.prem_paid_total;     
            v_list.comm_paid_tot   := i.comm_paid_total;     
            v_list.comm_tot        := i.comm_total * i.currency_rt;             
            v_list.wtax_tot        := i.wtax_total * i.currency_rt;             
            v_list.ivat_tot        := i.ivat_total * i.currency_rt;
            v_list.net_comm_tot    := i.net_comm_total * i.currency_rt;       
            v_list.net_recv_tot    := i.net_recv_total * i.currency_rt;
            --END SR-22136
            COUNTER := COUNTER+1;
            PIPE ROW(v_list);  
            
        END LOOP;
        
        RETURN;
    END;
    
    FUNCTION get_bill_per_policy ( 
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_intm_no           GIIS_INTERMEDIARY.intm_no%TYPE
    ) 
        RETURN bill_per_policy_tab PIPELINED
    IS
        v_list                  bill_per_policy_type;
        v_exists                VARCHAR2(1) := 'N';
        
    BEGIN
        FOR i IN (
            SELECT gi.currency_rt, gp.line_cd, gp.subline_cd, gp.iss_cd iss_cd_gp, gp.issue_yy,
                gp.pol_seq_no, gp.renew_no, gp.endt_iss_cd, gp.endt_yy,
                gp.endt_seq_no, gi.iss_cd, gi.prem_seq_no,
                NVL (gi.prem_amt, 0) prem_amt, NVL (gi.tax_amt, 0) tax_amt,
                NVL (gi.prem_amt, 0) + NVL (gi.tax_amt, 0) receivable,
                  (NVL (gi.prem_amt, 0)
                + NVL (gi.tax_amt, 0)
                - NVL ((SELECT SUM (NVL (a.collection_amt, 0) / convert_rate) ---
                          FROM giac_direct_prem_collns a, giac_acctrans b
                         WHERE a.b140_prem_seq_no = gi.prem_seq_no
                           AND a.b140_iss_cd = gi.iss_cd
                           AND a.gacc_tran_id = b.tran_id
                           AND b.tran_flag <> 'D'
                           AND NOT EXISTS (
                                  SELECT x.gacc_tran_id
                                    FROM giac_reversals x, giac_acctrans y
                                   WHERE x.reversing_tran_id = y.tran_id
                                     AND y.tran_flag <> 'D'
                                     AND x.gacc_tran_id = a.gacc_tran_id)),
                       0
                      ))  prem_os,
                NVL ((SELECT SUM (NVL (a.collection_amt, 0))  ---
                        FROM giac_direct_prem_collns a, giac_acctrans b
                       WHERE a.b140_prem_seq_no = gi.prem_seq_no
                         AND a.b140_iss_cd = gi.iss_cd
                         AND a.gacc_tran_id = b.tran_id
                         AND b.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT x.gacc_tran_id
                                  FROM giac_reversals x, giac_acctrans y
                                 WHERE x.reversing_tran_id = y.tran_id
                                   AND y.tran_flag <> 'D'
                                   AND x.gacc_tran_id = a.gacc_tran_id)),
                     0
                    ) prem_paid,
                NVL ((SELECT SUM (  ((NVL (a.comm_amt, 0)) 
                                  - NVL (a.wtax_amt, 0)
                                  + NVL (a.input_vat_amt, 0))   -- uncommented wtax_amt and input_vat_amt : shan 11.24.2014
                                  
                                )  
                        FROM giac_comm_payts a, giac_acctrans b
                       WHERE a.prem_seq_no = gi.prem_seq_no
                         AND a.iss_cd = gi.iss_cd
                         AND a.intm_no = p_intm_no     -- must be per intm_no : shan 11.21.2014
                         AND a.gacc_tran_id = b.tran_id
                         AND b.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT x.gacc_tran_id
                                  FROM giac_reversals x, giac_acctrans y
                                 WHERE x.reversing_tran_id = y.tran_id
                                   AND y.tran_flag <> 'D'
                                   AND x.gacc_tran_id = a.gacc_tran_id)),
                     0
                    ) comm_paid, ga.assd_no, ga.assd_name
            FROM gipi_polbasic gp, gipi_invoice gi,giis_assured ga
            WHERE gp.policy_id = gi.policy_id
            AND gp.pol_flag <> '5'
            AND ga.assd_no  = gp.assd_no
            AND gp.line_cd  = p_line_cd
            AND gp.subline_cd = p_subline_cd
            AND gp.iss_cd   = p_iss_cd
            AND gp.issue_yy = p_issue_yy
            AND gp.pol_seq_no = p_pol_seq_no
            AND gp.renew_no = p_renew_no
            )
            LOOP
                v_list.currency_rt  :=  i.currency_rt; 
                v_list.line_cd      :=  i.line_cd;    
                v_list.subline_cd   :=  i.subline_cd; 
                v_list.iss_cd_gp    :=  i.iss_cd_gp;     
                v_list.issue_yy     :=  i.issue_yy;   
                v_list.pol_seq_no   :=  i.pol_seq_no; 
                v_list.renew_no     :=  i.renew_no;   
                v_list.endt_iss_cd  :=  i.endt_iss_cd; 
                v_list.endt_yy      :=  i.endt_yy;    
                v_list.endt_seq_no  :=  i.endt_seq_no;  
                v_list.iss_cd       :=  i.iss_cd;    
                v_list.prem_seq_no  :=  i.prem_seq_no;
                v_list.prem_amt     :=  NVL(i.prem_amt,0);    
                v_list.tax_amt      :=  NVL(i.tax_amt,0); 
                v_list.receivable   :=  NVL(i.receivable,0);     
                v_list.prem_os      :=  NVL(i.prem_os,0);   
                v_list.prem_paid    :=  NVL(i.prem_paid,0); 
                v_list.comm_paid    :=  NVL(i.comm_paid,0); 
                    
                v_list.comm    := 0;
                v_list.wtax    := 0; 
                v_list.ivat    := 0;
                v_exists       := 'N'; 
                
                FOR j IN (
                 SELECT a.commission_amt, a.wholding_tax, NVL(c.input_vat_paid, 0)+((NVL(a.commission_amt, 0)-NVL(c.comm_amt, 0))*(NVL(b.input_vat_rate, 0)/100)) input_vat
                                  FROM gipi_comm_inv_dtl a, giis_intermediary b, 
                                       (SELECT j.intm_no, j.iss_cd, j.prem_seq_no,
                                                 SUM(j.comm_amt) comm_amt, SUM(j.wtax_amt) w_tax_amt,
                                                     SUM(j.input_vat_amt) input_vat_paid
                                              FROM giac_comm_payts j, giac_acctrans k
                                             WHERE j.gacc_tran_id = k.tran_id
                                               AND k.tran_flag <> 'D'
                                               AND NOT EXISTS (SELECT 1
                                                                 FROM giac_reversals x, giac_acctrans y
                                                                        WHERE x.REVERSING_TRAN_ID = y.tran_id
                                                                            AND y.tran_flag <> 'D'
                                                                            AND x.gacc_tran_id = j.gacc_tran_id)
                                             GROUP BY intm_no, iss_cd, prem_seq_no) c
                                 WHERE a.intrmdry_intm_no = b.intm_no
                                   AND a.iss_cd = c.iss_cd(+)
                                   AND a.prem_seq_no = c.prem_seq_no(+)
                                   AND a.intrmdry_intm_no = c.intm_no(+)
                                   AND a.iss_cd = i.iss_cd
                                   AND a.prem_seq_no = i.prem_seq_no
                                   AND a.intrmdry_intm_no = p_intm_no           
                )
                LOOP
                    v_exists       := 'Y';
                    v_list.comm    :=  NVL(j.commission_amt,0);   
                    v_list.wtax    :=  NVL(j.wholding_tax,0); 
                    v_list.ivat    :=  NVL(j.input_vat,0);
                END LOOP; 
                    
                IF v_exists = 'N' THEN
                    FOR j IN (
                         SELECT a.commission_amt, a.wholding_tax, NVL(c.input_vat_paid, 0)+((NVL(a.commission_amt, 0)-NVL(c.comm_amt, 0))*(NVL(b.input_vat_rate, 0)/100)) input_vat
                                      FROM gipi_comm_invoice a, giis_intermediary b, 
                                           (SELECT j.intm_no, j.iss_cd, j.prem_seq_no,
                                                     SUM(j.comm_amt) comm_amt, SUM(j.wtax_amt) w_tax_amt,
                                                         SUM(j.input_vat_amt) input_vat_paid
                                                  FROM giac_comm_payts j, giac_acctrans k
                                                 WHERE j.gacc_tran_id = k.tran_id
                                                   AND k.tran_flag <> 'D'
                                                   AND NOT EXISTS (SELECT 1
                                                                     FROM giac_reversals x, giac_acctrans y
                                                                            WHERE x.REVERSING_TRAN_ID = y.tran_id
                                                                                AND y.tran_flag <> 'D'
                                                                                AND x.gacc_tran_id = j.gacc_tran_id)
                                                 GROUP BY intm_no, iss_cd, prem_seq_no) c
                                     WHERE a.intrmdry_intm_no = b.intm_no
                                       AND a.iss_cd = c.iss_cd(+)
                                       AND a.prem_seq_no = c.prem_seq_no(+)
                                       AND a.intrmdry_intm_no = c.intm_no(+)
                                       AND a.iss_cd = i.iss_cd
                                       AND a.prem_seq_no = i.prem_seq_no
                                       AND a.intrmdry_intm_no = p_intm_no           
                    )
                    LOOP
                        v_exists       := 'Y';
                        v_list.comm    :=  NVL(j.commission_amt,0);   
                        v_list.wtax    :=  NVL(j.wholding_tax,0); 
                        v_list.ivat    :=  NVL(j.input_vat,0);
                    END LOOP; 
                END IF;
                    
                v_list.net_comm  := NVL(v_list.comm,0) - NVL(v_list.wtax,0) + NVL(v_list.ivat,0);
                v_list.net_recv  := NVL(v_list.receivable,0) - NVL(v_list.net_comm,0); 
                --v_list.comm_os   := (v_list.comm * v_list.currency_rt)- v_list.comm_paid;
                v_list.comm_os   := v_list.net_comm - v_list.comm_paid; -- bonok :: 6.10.2015 :: SR4638 replaced based on fmb
                
                PIPE ROW(v_list);                
            END LOOP;
    RETURN;
    END;
    
    
   FUNCTION get_bill_per_policy_prem ( 
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_prem_seq_no       GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE
    )
    RETURN bill_per_policy_prem_tab PIPELINED
    IS
            v_list bill_per_policy_prem_type;
    BEGIN
        FOR i IN(
          SELECT gdpc.collection_amt, gdpc.b140_iss_cd, gdpc.b140_prem_seq_no,
                 ga.gibr_branch_cd, ga.tran_date, get_ref_no(gdpc.gacc_tran_id) ref_no,
                 gp.line_cd, gp.subline_cd, gp.iss_cd, gp.issue_yy, gp.pol_seq_no,
                 gp.renew_no
          FROM giac_direct_prem_collns gdpc,
               giac_acctrans ga,
               gipi_invoice gi,
               gipi_polbasic gp
         WHERE gdpc.gacc_tran_id = ga.tran_id
           AND ga.tran_flag != 'D'
           AND gdpc.b140_iss_cd = gi.iss_cd
           AND gdpc.b140_prem_seq_no = gi.prem_seq_no
           AND gp.policy_id = gi.policy_id
           AND gacc_tran_id NOT IN (
                              SELECT aa.gacc_tran_id
                              FROM giac_reversals aa, giac_acctrans bb
                              WHERE aa.reversing_tran_id = bb.tran_id
                              AND bb.tran_flag != 'D')
           AND gp.line_cd            = p_line_cd        
           AND gp.subline_cd         = p_subline_cd        
           AND gp.iss_cd             = p_iss_cd       
           AND gp.issue_yy           = p_issue_yy      
           AND gp.pol_seq_no         = p_pol_seq_no       
           AND gp.renew_no           = p_renew_no        
           --AND gdpc.b140_prem_seq_no = p_prem_seq_no                
        )
        LOOP
            v_list.collection_amt   :=  i.collection_amt;                   
            v_list.b140_iss_cd      :=  i.b140_iss_cd;                
            v_list.b140_prem_seq_no :=  i.b140_prem_seq_no;                    
            v_list.branch_cd        :=  i.gibr_branch_cd;                  
            v_list.tran_date        :=  i.tran_date;                
            v_list.ref_no           :=  i.ref_no;                  
            v_list.line_cd          :=  i.line_cd;                
            v_list.subline_cd       :=  i.subline_cd;                   
            v_list.iss_cd           :=  i.iss_cd;                 
            v_list.issue_yy         :=  i.issue_yy;                   
            v_list.pol_seq_no       :=  i.pol_seq_no;                 
            v_list.renew_no         :=  i.renew_no;               
              
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
    END get_bill_per_policy_prem;
     
    FUNCTION get_bill_per_policy_comm ( 
            p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
            p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
            p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
            p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
            p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
            p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
            p_prem_seq_no       GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
            p_intm_no           GIIS_INTERMEDIARY.intm_no%TYPE  -- shan 11.24.2014
    )
    RETURN bill_per_policy_comm_tab PIPELINED
    IS
            v_list bill_per_policy_comm_type;
    BEGIN
        FOR i IN(
          SELECT NVL (gcp.comm_amt, 0) comm_amt, NVL (gcp.wtax_amt, 0) wtax_amt,
                NVL (gcp.input_vat_amt, 0) input_vat_amt,
                NVL (gcp.comm_amt - wtax_amt + input_vat_amt, 0) net_comm,
                get_ref_no (gcp.gacc_tran_id) ref_no, gcp.iss_cd gcp_iss_cd,
                gcp.prem_seq_no, ga.gibr_branch_cd, ga.tran_date, gp.line_cd,
                gp.subline_cd, gp.iss_cd, gp.issue_yy, gp.pol_seq_no, gp.renew_no
         FROM giac_comm_payts gcp,
                giac_acctrans ga,
                gipi_invoice gi,
                gipi_polbasic gp
         WHERE gcp.gacc_tran_id = ga.tran_id
           AND ga.tran_flag <> 'D'
           AND gcp.gacc_tran_id NOT IN (
                          SELECT c.gacc_tran_id
                            FROM giac_reversals c, giac_acctrans d
                           WHERE c.reversing_tran_id = d.tran_id
                                 AND d.tran_flag <> 'D')
           AND gcp.iss_cd = gi.iss_cd
           AND gcp.prem_seq_no = gi.prem_seq_no
           AND gp.policy_id = gi.policy_id
           AND gp.line_cd            = p_line_cd        
           AND gp.subline_cd         = p_subline_cd        
           AND gp.iss_cd             = p_iss_cd       
           AND gp.issue_yy           = p_issue_yy      
           AND gp.pol_seq_no         = p_pol_seq_no       
           AND gp.renew_no           = p_renew_no        
           --AND gcp.prem_seq_no       = p_prem_seq_no
           AND gcp.INTM_NO           = NVL(p_intm_no, gcp.intm_no)            
        )
        LOOP
            v_list.comm_amt       :=  i.comm_amt;                   
            v_list.wtax_amt       :=  i.wtax_amt;                
            v_list.input_vat_amt  :=  i.input_vat_amt;                    
            v_list.net_comm       :=  i.net_comm;                  
            v_list.ref_no         :=  i.ref_no;                
            v_list.gcp_iss_cd     :=  i.gcp_iss_cd;                  
            v_list.prem_seq_no    :=  i.prem_seq_no;                
            v_list.branch_cd      :=  i.gibr_branch_cd;                   
            v_list.tran_date      :=  i.tran_date;                 
            v_list.line_cd        :=  i.line_cd;                     
            v_list.subline_cd     :=  i.subline_cd;                  
            v_list.iss_cd         :=  i.iss_cd;      
            v_list.issue_yy       :=  i.issue_yy;   
            v_list.pol_seq_no     :=  i.pol_seq_no; 
            v_list.renew_no       :=  i.renew_no;   
                        
              
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
    END get_bill_per_policy_comm;
    
END;
/
