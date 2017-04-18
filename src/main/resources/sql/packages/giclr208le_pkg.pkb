CREATE OR REPLACE PACKAGE BODY CPI.giclr208le_pkg
AS
   FUNCTION get_giclr208le_report (
     p_session_id      NUMBER,
     p_claim_id        NUMBER,
     p_intm_break      NUMBER,
     p_search_by_opt   VARCHAR2,
     p_date_as_of      VARCHAR2,
     p_date_from       VARCHAR2,
     p_date_to         VARCHAR2
   )
     RETURN giclr208le_tab PIPELINED
   IS
     v_list giclr208le_type;
     v_pol_iss_cd     gicl_claims.pol_iss_cd%type;
     v_share_type     NUMBER := 0;
     v_exist          BOOLEAN := false;
   BEGIN
     v_list.exist := 'N';
   
     FOR i IN(SELECT a.session_id, a.iss_cd, a.line_cd, a.subline_cd, a.claim_id, a.assd_no, a.claim_no,
                     a.policy_no, a.clm_file_date, a.loss_date, a.loss_cat_cd, a.item_no,
                     a.grouped_item_no, a.peril_cd, a.intm_no, NVL (a.tsi_amt, 0) tsi_amt,
                     SUM ((NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0))) outstanding_expense,
                     SUM ((NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0))) outstanding_loss
                FROM gicl_res_brdrx_extr a
               WHERE a.session_id = p_session_id
                 AND a.claim_id = NVL (p_claim_id, a.claim_id)
                 AND ((NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                  OR (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0)
            GROUP BY a.session_id, a.iss_cd, a.line_cd, a.subline_cd, a.claim_id, a.assd_no,
                     a.claim_no, a.policy_no, a.clm_file_date, a.loss_date,
                     a.loss_cat_cd, a.item_no, a.grouped_item_no, a.peril_cd,
                     a.intm_no, NVL (a.tsi_amt, 0)
            ORDER BY a.intm_no, a.iss_cd, a.line_cd)
     LOOP
       v_list.intm_no := NVL (LTRIM (TO_CHAR (i.intm_no, '0009')), ' ');
       v_list.iss_cd  := i.iss_cd;
       v_list.line_cd := i.line_cd;
       v_list.claim_id := i.claim_id;
       v_list.claim_no := get_clm_no(i.claim_id);
       v_list.policy_no := i.policy_no;
       v_list.assd_no := i.assd_no;
       v_list.loss_date := i.loss_date;
       v_list.clm_file_date := i.clm_file_date;
       v_list.item_no := i.item_no;
       v_list.grouped_item_no := i.grouped_item_no;
       v_list.item := get_gpa_item_title(i.claim_id,i.line_cd,i.item_no,i.grouped_item_no);
       v_list.peril_cd := i.peril_cd;
       v_list.outstanding_loss := i.outstanding_loss;
       v_list.outstanding_exp := i.outstanding_expense;
       v_list.tsi_amount := i.tsi_amt;
       --v_list.session_id := i.session_id;
       
       
       BEGIN
         SELECT intm_name
           INTO v_list.intm_name
           FROM giis_intermediary
          WHERE intm_no = i.intm_no;
       EXCEPTION WHEN NO_DATA_FOUND THEN
         v_list.intm_name := ' ';    
       END;
       
       
       BEGIN
         SELECT iss_name
           INTO v_list.iss_name
           FROM giis_issource
          WHERE iss_cd = i.iss_cd;
       EXCEPTION WHEN NO_DATA_FOUND THEN
         v_list.iss_name := ' ';    
       END;
       
       BEGIN
         SELECT line_name
           INTO v_list.line_name
           FROM giis_line
          WHERE line_cd = i.line_cd;
       EXCEPTION WHEN NO_DATA_FOUND THEN
         v_list.line_name := ' ';
       END;
       
       BEGIN
         SELECT assd_name
           INTO v_list.assd_name
           FROM giis_assured
          WHERE assd_no = i.assd_no;
       EXCEPTION WHEN NO_DATA_FOUND THEN
         v_list.assd_name := ' ';    
       END;
       
       BEGIN
         SELECT pol_iss_cd
           INTO v_pol_iss_cd
           FROM gicl_claims
          WHERE claim_id = i.claim_id;
       EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_pol_iss_cd := NULL;
       END;
       
       v_list.intm_ri := '';
       
       IF v_pol_iss_cd = GIACP.V('RI_ISS_CD') THEN
         BEGIN 
           FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                       FROM gicl_claims a, giis_reinsurer b
                      WHERE a.ri_cd = b.ri_cd
                        AND a.claim_id = i.claim_id)
           LOOP
             v_list.intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           END LOOP;
         END;
       ELSE            
         IF p_intm_break = 1 THEN
           BEGIN
             FOR s IN (SELECT a.intm_no intm_no, b.intm_name intm_name, 
                              b.ref_intm_cd ref_intm_cd
                         FROM gicl_res_brdrx_extr a, giis_intermediary b
                        WHERE a.intm_no = b.intm_no
                          AND a.session_id = p_session_id 
                          AND a.claim_id = i.claim_id
                          AND a.item_no = i.item_no
                          AND a.peril_cd = i.peril_cd
                          AND a.intm_no = i.intm_no) 
             LOOP
               v_list.intm_ri := TO_CHAR(s.intm_no)||'/'||s.ref_intm_cd||'/'||
                            s.intm_name;
             END LOOP;
           END;    
         ELSIF p_intm_break = 0 THEN
           BEGIN 
             FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                         FROM gicl_intm_itmperil a, giis_intermediary b
                        WHERE a.intm_no = b.intm_no
                          AND a.claim_id = i.claim_id
                          AND a.item_no = i.item_no
                          AND a.peril_cd = i.peril_cd) 
             LOOP
               v_list.intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||
                            m.intm_name||CHR(10)||
                            v_list.intm_ri;
             END LOOP;
           END; 
         END IF;
       END IF;
       
       BEGIN
         SELECT TO_CHAR(pol_eff_date,'MM-DD-YYYY')
           INTO v_list.eff_date
           FROM gicl_claims
          WHERE claim_id = i.claim_id;
       END;
       
       BEGIN
         SELECT TO_CHAR(expiry_date,'MM-DD-YYYY')
           INTO v_list.expiry_date
           FROM gicl_claims
          WHERE claim_id = i.claim_id;
       END;
       
       BEGIN
         SELECT loss_cat_des
           INTO v_list.loss_cat_des
           FROM giis_loss_ctgry
          WHERE line_cd = i.line_cd
            AND loss_cat_cd = i.loss_cat_cd;
       EXCEPTION WHEN NO_DATA_FOUND THEN
         v_list.loss_cat_des := ' ';     
       END;
       
       BEGIN
         SELECT loss_loc1 || ' ' || loss_loc2 || ' ' || loss_loc3
           INTO v_list.loc_of_risk
           FROM gicl_claims
          WHERE loss_cat_cd = i.loss_cat_cd
            AND claim_id = i.claim_id;
       EXCEPTION WHEN NO_DATA_FOUND THEN
         v_list.loc_of_risk := ' ';     
       END;
       
       BEGIN
         SELECT peril_name
           INTO v_list.peril_name
           FROM giis_peril
          WHERE peril_cd = i.peril_cd
            AND line_cd = i.line_cd;
       EXCEPTION WHEN NO_DATA_FOUND THEN
         v_list.peril_name := ' ';     
       END;
       
       BEGIN
         SELECT NVL(b.clm_stat_desc, NULL)
           INTO v_list.clm_stat_desc
           FROM gicl_clm_loss_exp a, giis_clm_stat b
          WHERE claim_id = i.claim_id
            AND NVL (cancel_sw, 'N') = 'N'
            AND item_no = i.item_no
            AND peril_cd = i.peril_cd
            AND clm_loss_id IN (
                   SELECT MAX (clm_loss_id)
                     FROM gicl_clm_loss_exp
                    WHERE claim_id = i.claim_id
                      AND NVL (cancel_sw, 'N') = 'N'
                      AND item_no = i.item_no
                      AND peril_cd = i.peril_cd)
            AND b.clm_stat_cd = a.item_stat_cd;
             
         EXCEPTION WHEN NO_DATA_FOUND THEN
           BEGIN
           SELECT b.clm_stat_desc
             INTO v_list.clm_stat_desc
             FROM gicl_claims a, giis_clm_stat b
            WHERE a.claim_id = i.claim_id
              AND b.clm_stat_cd = a.clm_stat_cd;
           EXCEPTION WHEN NO_DATA_FOUND THEN
             v_list.clm_stat_desc := ' ';
         END; 
       END;
       
       BEGIN
          v_list.pt_loss := 0;
          FOR l1 IN (SELECT (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) pt_loss
                       FROM gicl_res_brdrx_ds_extr a
                      WHERE a.session_id = p_session_id
                        AND a.grp_seq_no IN (SELECT a.share_cd
                                               FROM giis_dist_share a
                                              WHERE a.line_cd = i.line_cd AND a.share_type = 2)
                        AND a.claim_id = i.claim_id
                        AND a.item_no = i.item_no
                        AND a.peril_cd = i.peril_cd
                        AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0)
          LOOP
            v_list.pt_loss := v_list.pt_loss + l1.pt_loss;
          END LOOP;               
       END;
       
        BEGIN
           v_list.pt_exp := 0;

           FOR e1 IN (SELECT (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) pt_exp
                        FROM gicl_res_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.grp_seq_no IN (
                                        SELECT a.share_cd
                                          FROM giis_dist_share a
                                         WHERE a.line_cd = i.line_cd
                                               AND a.share_type = 2)
                         AND a.claim_id = i.claim_id
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0)
           LOOP
              v_list.pt_exp := v_list.pt_exp + e1.pt_exp;
           END LOOP;
        END;
       
        BEGIN
           v_list.net_loss := 0;
           v_exist := FALSE;                    --Start: added by Kevin SR 21723
           FOR exist IN (SELECT a.claim_id
                            FROM gicl_res_brdrx_extr a,
                                 (SELECT   MAX (clm_res_hist_id) clm_res_hist_id,
                                           MAX (brdrx_record_id) brdrx_record_id, claim_id, item_no,
                                           grouped_item_no, peril_cd, loss_cat_cd, buss_source
                                      FROM gicl_res_brdrx_extr
                                     WHERE session_id = p_session_id
                                       AND losses_paid+expenses_paid
                                     < 0 AND claim_id = i.claim_id
                                  GROUP BY claim_id,
                                           item_no,
                                           peril_cd,
                                           loss_cat_cd,
                                           buss_source,
                                           grouped_item_no,DECODE (1,
                                               1, 1,
                                               2, clm_res_hist_id
                                              )) b
                           WHERE session_id = p_session_id
                             AND a.claim_id = b.claim_id
                             AND a.item_no = b.item_no
                             AND a.peril_cd = b.peril_cd
                             AND a.grouped_item_no = b.grouped_item_no
                             AND a.brdrx_record_id = b.brdrx_record_id)
           LOOP
              v_exist := TRUE;
           END LOOP;
           
           IF v_exist
           THEN
                FOR l2 IN (SELECT (NVL (SUM(loss_reserve), 0) - NVL (SUM(losses_paid), 0)) net_loss FROM (SELECT DISTINCT a.loss_reserve, a.losses_paid
                        FROM gicl_res_brdrx_ds_extr a
                       WHERE a.grp_seq_no IN (
                                      SELECT a.share_cd
                                        FROM giis_dist_share a
                                       WHERE a.line_cd = i.line_cd
                                         AND a.share_type = 1)
                         AND a.claim_id = i.claim_id
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND a.losses_paid <= 0
                         AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0))
                LOOP
                    v_list.net_loss := v_list.net_loss + l2.net_loss;
                END LOOP;               --End: added by Kevin SR 21723
           ELSE
                FOR l2 IN (SELECT (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) net_loss
                            FROM gicl_res_brdrx_ds_extr a
                           WHERE a.session_id = p_session_id
                             AND a.grp_seq_no IN (
                                          SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = i.line_cd
                                                 AND a.share_type = 1)
                             AND a.claim_id = i.claim_id
                             AND a.item_no = i.item_no
                             AND a.peril_cd = i.peril_cd
                             AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0)
               LOOP
                  v_list.net_loss := v_list.net_loss + l2.net_loss;
               END LOOP;
           END IF;
        END;
        
        BEGIN
           v_list.net_exp := 0;

           FOR e2 IN (SELECT (NVL(a.expense_reserve,0) - NVL (a.expenses_paid,0)) net_exp
                        FROM gicl_res_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.grp_seq_no IN (
                                      SELECT a.share_cd
                                        FROM giis_dist_share a
                                       WHERE a.line_cd = i.line_cd
                                             AND a.share_type = 1)
                         AND a.claim_id = i.claim_id
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0)
           LOOP
              v_list.net_exp := v_list.net_exp + e2.net_exp;
           END LOOP;
        END;
                
        BEGIN
           v_list.fac_loss := 0;

           FOR l3 IN (SELECT (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) fac_loss
                        FROM gicl_res_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.grp_seq_no IN (SELECT a.share_cd
                                                FROM giis_dist_share a
                                               WHERE a.line_cd = i.line_cd
                         AND a.share_type = 3)
                         AND a.claim_id = i.claim_id
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0)
           LOOP
              v_list.fac_loss := v_list.fac_loss + l3.fac_loss;
           END LOOP;
        END;
        
        BEGIN
           v_list.fac_exp := 0;

           FOR e3 IN (SELECT (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) fac_exp
                        FROM gicl_res_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.grp_seq_no IN (SELECT a.share_cd
                                                FROM giis_dist_share a
                                               WHERE a.line_cd = i.line_cd
                         AND a.share_type = 3)
                         AND a.claim_id = i.claim_id
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0)
           LOOP
              v_list.fac_exp  := v_list.fac_exp + e3.fac_exp;
           END LOOP;
        END;
        
        BEGIN
           v_list.npt_loss := 0;
           v_list.npt_exp := 0;
           
           IF v_share_type = 0 THEN
             SELECT param_value_v
               INTO v_share_type
               FROM giac_parameters
              WHERE param_name LIKE 'XOL_TRTY_SHARE_TYPE';
           END IF;

           FOR l4 IN
              (SELECT (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) npt_loss
                      --(NVL(a.expense_reserve, 0) - NVL(a.expenses_paid, 0)) npt_exp
                 FROM gicl_res_brdrx_ds_extr a
                WHERE a.session_id = p_session_id
                  AND a.grp_seq_no IN (
                         SELECT a.share_cd
                           FROM giis_dist_share a
                          WHERE a.line_cd = i.line_cd
                            AND a.share_type = v_share_type)
                  AND a.claim_id = i.claim_id
                  AND a.item_no = i.item_no
                  AND a.peril_cd = i.peril_cd
                  AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0)
           LOOP
              v_list.npt_loss := v_list.npt_loss + l4.npt_loss;
              --v_list.npt_exp := v_list.npt_exp + l4.npt_exp;
           END LOOP;
           
           FOR e4 IN
              (SELECT (NVL(a.expense_reserve, 0) - NVL(a.expenses_paid, 0)) npt_exp
                 FROM gicl_res_brdrx_ds_extr a
                WHERE a.session_id = p_session_id
                  AND a.grp_seq_no IN (
                         SELECT a.share_cd
                           FROM giis_dist_share a
                          WHERE a.line_cd = i.line_cd
                            AND a.share_type = v_share_type)
                  AND a.claim_id = i.claim_id
                  AND a.item_no = i.item_no
                  AND a.peril_cd = i.peril_cd
                  AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0)
           LOOP
              v_list.npt_exp := v_list.npt_exp + e4.npt_exp;
           END LOOP;
        END;
        
        v_list.rec_loss := v_list.pt_loss + v_list.fac_loss;
        v_list.rec_exp := v_list.pt_exp + v_list.fac_exp;
        
        IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL THEN
              v_list.date_as_of := TRIM(TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
            END IF;
         
       IF v_list.date_from IS NULL AND p_date_from IS NOT NULL THEN
         v_list.date_from := TRIM(TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
         v_list.date_to := TRIM(TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
       END IF;
       
       IF v_list.company_name IS NULL THEN
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');
       END IF;
       
       v_list.exist := 'Y';
       
       PIPE ROW(v_list);
     END LOOP;
     
     IF v_list.exist = 'N' THEN
       IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL THEN
         v_list.date_as_of := TRIM(TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
       END IF;
         
       IF v_list.date_from IS NULL AND p_date_from IS NOT NULL THEN
         v_list.date_from := TRIM(TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
         v_list.date_to := TRIM(TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
       END IF;
       
       IF v_list.company_name IS NULL THEN
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');
       END IF;
       
       PIPE ROW(v_list);
     END IF;
     RETURN;  
   END get_giclr208le_report;     
END;
/


