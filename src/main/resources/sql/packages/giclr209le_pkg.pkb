CREATE OR REPLACE PACKAGE BODY CPI.GICLR209LE_PKG
AS
    FUNCTION get_giclr209LE_report (
      p_claim_id        NUMBER,
      p_intm_break      NUMBER,
      p_iss_break       NUMBER,
      p_paid_date       VARCHAR2,
      p_session_id      NUMBER,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
    )
        RETURN giclr209le_tab PIPELINED
    IS
        v_list          giclr209le_type;
        v_clm_stat      giis_clm_stat.clm_stat_desc%type;
        v_clm_stat1     giis_clm_stat.clm_stat_desc%type;
        var_clm_stat    varchar2(5000);
        v_tran_date	    varchar2(100);
        var_tran_date   varchar2(200);
        v_loss          number;
        v_not_exist     BOOLEAN := TRUE;
    BEGIN
        v_list.company_name := giisp.v ('COMPANY_NAME');
        v_list.company_address := giisp.v ('COMPANY_ADDRESS');  
          
        BEGIN
          BEGIN
            SELECT report_title
              INTO v_list.title_sw
              FROM giis_reports
             WHERE report_id = 'GICLR209LE';
          END;

          IF p_intm_break = 0 THEN
             v_list.title_sw := v_list.title_sw || ' - PER BRANCH';
          ELSIF p_intm_break = 1 THEN
             v_list.title_sw := v_list.title_sw || ' - PER INTERMEDIARY';   
          END IF;
        END;
                            
        BEGIN
            SELECT DECODE(p_paid_date,1,'Transaction Date',2,'Posting Date')  
              INTO v_list.date_title
              FROM dual;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_list.date_title := NULL;
        END;
            
        BEGIN
            SELECT 'from '||TO_CHAR(TO_DATE(p_date_from,'mm-dd-yyyy'),'fmMonth DD, YYYY')||
                   ' to '||TO_CHAR(TO_DATE(p_date_to,'mm-dd-yyyy'),'fmMonth DD, YYYY')
              INTO v_list.date_sw
              FROM dual; 
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_list.date_sw := NULL;
        END;
                
        FOR i IN(SELECT   a.buss_source, a.iss_cd, a.line_cd, a.subline_cd, a.claim_id,
                         a.assd_no, a.claim_no, a.policy_no, a.clm_file_date, a.loss_date,
                         a.loss_cat_cd, a.item_no, a.grouped_item_no, a.peril_cd, a.intm_no,
                         a.clm_loss_id, NVL (a.tsi_amt, 0) tsi_amt,
                         NVL (a.losses_paid, 0) paid_loss,
                         NVL (a.expenses_paid, 0) paid_expense,
                         a.pd_date_opt
                    FROM gicl_res_brdrx_extr a
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND (NVL (a.losses_paid, 0) <> 0 OR NVL (a.expenses_paid, 0) <> 0)
                ORDER BY a.intm_no, a.iss_cd, a.line_cd, a.claim_id, a.item_no, a.grouped_item_no
        )
        LOOP
            v_list.flag := 'N';
            v_not_exist := FALSE;
            v_list.intm_no := NVL (LTRIM (TO_CHAR (i.intm_no, '0009')), ' ');
            v_list.paid_expense := i.paid_expense;
            v_list.buss_source := i.buss_source;
            v_list.iss_cd := i.iss_cd;
            v_list.line_cd := i.line_cd;
            v_list.subline_cd := i.subline_cd;
            v_list.claim_id := i.claim_id;
            v_list.assd_no := i.assd_no;
            v_list.claim_no := i.claim_no;
            v_list.policy_no := i.policy_no;
            v_list.clm_file_date := i.clm_file_date;
            v_list.loss_date := i.loss_date;
            v_list.clm_loss_id := i.clm_loss_id;
            v_list.loss_cat_cd := i.loss_cat_cd;
            v_list.item_no := i.item_no;
            v_list.grouped_item_no := i.grouped_item_no;
            v_list.peril_cd := i.peril_cd;
            v_list.paid_loss := i.paid_loss;
            v_list.tsi_amt := i.tsi_amt;
            v_list.item_name := get_gpa_item_title(i.claim_id,i.line_cd,i.item_no,NVL(i.grouped_item_no,0));           
                    
            BEGIN
               FOR a IN (SELECT intm_name
                           FROM giis_intermediary
                          WHERE intm_no = i.intm_no)
               LOOP
                  v_list.intm_name := a.intm_name;
               END LOOP;
             EXCEPTION WHEN NO_DATA_FOUND THEN
                v_list.intm_name := '';    
            END;
              
            BEGIN
               FOR a IN (SELECT assd_name
                           FROM giis_assured
                          WHERE assd_no = i.assd_no)
               LOOP
                  v_list.assd_name := a.assd_name;
               END LOOP;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_list.assd_name := NULL;
            END;
                         
            BEGIN
                SELECT iss_name
                  INTO v_list.iss_name
                  FROM giis_issource
                 WHERE iss_cd = i.iss_cd;
             EXCEPTION WHEN NO_DATA_FOUND THEN
                v_list.iss_name := NULL;     
            END;

            BEGIN
                SELECT line_name
                  INTO v_list.line_name
                  FROM giis_line
                 WHERE line_cd = i.line_cd;
             EXCEPTION WHEN NO_DATA_FOUND THEN
                v_list.line_name := NULL;     
            END;

            BEGIN
                SELECT pol_iss_cd
                  INTO v_list.pol_iss_cd 
                  FROM gicl_claims
                 WHERE claim_id = i.claim_id;   
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_list.pol_iss_cd := NULL; 
              END;
               
              IF v_list.pol_iss_cd = GIACP.V('RI_ISS_CD') THEN
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
                     FOR j IN (SELECT a.intm_no intm_no, b.intm_name intm_name, 
                                      b.ref_intm_cd ref_intm_cd
                                 FROM gicl_res_brdrx_extr a, giis_intermediary b
                                WHERE a.intm_no = b.intm_no
                                  AND a.session_id = p_session_id 
                                  AND a.claim_id = i.claim_id
                                  AND a.item_no = i.item_no
                                  AND a.peril_cd = i.peril_cd
                                  AND a.intm_no = i.intm_no) 
                     LOOP
                       v_list.intm_ri := TO_CHAR(j.intm_no)||'/'||j.ref_intm_cd||'/'||
                                    j.intm_name;
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
                                    m.intm_name||CHR(10);
                                    --||
                                       -- v_list.intm_ri;
                     END LOOP;
                   END; 
                END IF;
              END IF;

            BEGIN
              FOR f IN (SELECT pol_eff_date
                          FROM gicl_claims
                         WHERE claim_id = i.claim_id)
              LOOP
                v_list.eff_date := f.pol_eff_date;
              END LOOP;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                v_list.eff_date := NULL; 
            END;
            
            BEGIN
              FOR x IN (SELECT expiry_date
                          FROM gicl_claims
                         WHERE claim_id = i.claim_id)
              LOOP
                v_list.expiry_date := x.expiry_date;
              END LOOP;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                v_list.expiry_date := NULL;
            END;

            BEGIN
                SELECT loss_cat_des
                  INTO v_list.loss_cat_category
                  FROM giis_loss_ctgry
                 WHERE line_cd = i.line_cd
                   AND loss_cat_cd = i.loss_cat_cd;
             EXCEPTION WHEN NO_DATA_FOUND THEN
                v_list.loss_cat_category := NULL;       
            END;
              
            BEGIN
              FOR l IN (SELECT loss_loc1, loss_loc2, loss_loc3
                          FROM gicl_claims
                         WHERE loss_cat_cd = i.loss_cat_cd
                           AND claim_id = i.claim_id)
              LOOP
                v_list.loc := l.loss_loc1||' '||l.loss_loc2||' '||l.loss_loc3;
              END LOOP;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                v_list.loc := NULL;
            END;
                   
            BEGIN
              FOR p IN (SELECT peril_name
                          FROM giis_peril
                         WHERE peril_cd = i.peril_cd
                           AND line_cd = i.line_cd)
              LOOP
                v_list.peril := p.peril_name;
              END LOOP;
            END;
            
            BEGIN
                FOR k IN (SELECT b.le_stat_desc
                    FROM gicl_clm_loss_exp a, gicl_le_stat b
                   WHERE claim_id = i.claim_id
                     AND NVL(cancel_sw,'N') = 'N'
                     AND item_no = i.item_no
                     AND peril_cd = i.peril_cd
                     AND clm_loss_id = i.clm_loss_id
                     AND payee_type = 'E'
                     AND b.le_stat_cd = a.item_stat_cd)
                LOOP
                  v_clm_stat := k.le_stat_desc;

                    IF var_clm_stat IS NULL THEN
                    var_clm_stat := v_clm_stat;
                    ELSE
                    var_clm_stat := v_clm_stat||'/'||CHR(10);
                    END IF;

                    END LOOP;

                IF var_clm_stat IS NULL THEN
                    BEGIN
                       SELECT b.clm_stat_desc
                         INTO v_list.clm_stat
                         FROM gicl_claims a, giis_clm_stat b
                        WHERE a.claim_id = i.claim_id
                          AND b.clm_stat_cd = a.clm_stat_cd;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                       v_list.clm_stat := null;
                    END;
                         ELSE
                       v_list.clm_stat := var_clm_stat;
                    END IF;
            END;
            
            BEGIN
              v_list.cf_share_type1_LOSS := 0;
              FOR j IN (SELECT NVL(A.LOSSES_PAID,0) PAID_LOSS
                          FROM GICL_RES_BRDRX_DS_EXTR A
                         WHERE A.SESSION_ID = P_SESSION_ID
                           AND a.grp_seq_no in (SELECT a.share_cd
                                                  FROM giis_dist_share a
                                                 WHERE a.line_cd = i.line_cd
                                                   AND a.share_type = 1)
                           AND A.CLAIM_ID = NVL(i.CLAIM_ID,A.CLAIM_ID)
                           AND A.ITEM_NO  = i.ITEM_NO 
                           AND A.PERIL_CD = i.PERIL_CD   
                           AND NVL(A.LOSSES_PAID,0) <> 0) 
              LOOP
                v_list.cf_share_type1_LOSS :=  j.paid_loss + v_list.cf_share_type1_LOSS;
              END LOOP;
            END;
            
            BEGIN
              v_list.cf_share_type1_EXPENSE := 0;
              FOR j IN (SELECT NVL(A.EXPENSES_PAID,0) PAID_LOSS
                          FROM GICL_RES_BRDRX_DS_EXTR A
                         WHERE A.SESSION_ID = P_SESSION_ID
                           AND a.grp_seq_no in (SELECT a.share_cd
                                                  FROM giis_dist_share a
                                                 WHERE a.line_cd = i.line_cd
                                                   AND a.share_type = 1)
                           AND A.CLAIM_ID = NVL(i.CLAIM_ID,A.CLAIM_ID)
                           AND A.ITEM_NO  = i.ITEM_NO 
                           AND A.PERIL_CD = i.PERIL_CD   
                           AND NVL(A.EXPENSES_PAID,0) <> 0) 
              LOOP
                v_list.cf_share_type1_EXPENSE :=  j.paid_loss + v_list.cf_share_type1_EXPENSE;
              END LOOP;
            END;
            
            BEGIN
              v_list.cf_share_type3_LOSS := 0;
              FOR j IN (SELECT NVL(A.LOSSES_PAID,0) PAID_LOSS
                          FROM GICL_RES_BRDRX_DS_EXTR A
                         WHERE A.SESSION_ID = P_SESSION_ID
                           AND a.grp_seq_no in (SELECT a.share_cd
                                                  FROM giis_dist_share a
                                                 WHERE a.line_cd = i.line_cd
                                                   AND a.share_type = 3)
                           AND A.CLAIM_ID = NVL(i.CLAIM_ID,A.CLAIM_ID)
                           AND A.ITEM_NO  = i.ITEM_NO
                           AND A.PERIL_CD = i.PERIL_CD  
                           AND NVL(A.LOSSES_PAID,0) <> 0) 
              LOOP
                v_list.cf_share_type3_LOSS :=  j.paid_loss + v_list.cf_share_type3_LOSS;
              END LOOP;
            END;
            
            BEGIN
              v_list.cf_share_type3_EXPENSE := 0;
              FOR j IN (SELECT NVL(A.EXPENSES_PAID,0) PAID_LOSS
                          FROM GICL_RES_BRDRX_DS_EXTR A
                         WHERE A.SESSION_ID = P_SESSION_ID
                           AND a.grp_seq_no in (SELECT a.share_cd
                                                  FROM giis_dist_share a
                                                 WHERE a.line_cd = i.line_cd
                                                   AND a.share_type = 3)
                           AND A.CLAIM_ID = NVL(i.CLAIM_ID,A.CLAIM_ID)
                           AND A.ITEM_NO  = i.ITEM_NO
                           AND A.PERIL_CD = i.PERIL_CD  
                           AND NVL(A.EXPENSES_PAID,0) <> 0) 
              LOOP
                v_list.cf_share_type3_EXPENSE :=  j.paid_loss + v_list.cf_share_type3_EXPENSE;
              END LOOP;
            END;
            
            BEGIN
              v_list.cf_share_type2_LOSS := 0;
              FOR j IN (SELECT NVL(A.LOSSES_PAID,0) PAID_LOSS
                          FROM GICL_RES_BRDRX_DS_EXTR A
                         WHERE A.SESSION_ID = P_SESSION_ID
                           AND a.grp_seq_no in (SELECT a.share_cd
                                                  FROM giis_dist_share a
                                                 WHERE a.line_cd = i.line_cd
                                                   AND a.share_type = 2)
                           AND A.CLAIM_ID = NVL(i.CLAIM_ID,A.CLAIM_ID)
                           AND A.ITEM_NO  = i.ITEM_NO
                           AND A.PERIL_CD = i.PERIL_CD  
                           AND NVL(A.LOSSES_PAID,0) <> 0) 
              LOOP
                v_list.cf_share_type2_LOSS :=  j.paid_loss + v_list.cf_share_type2_LOSS;
              END LOOP;
            END;

            BEGIN
              v_list.cf_share_type2_EXPENSE := 0;
              FOR j IN (SELECT NVL(A.EXPENSES_PAID,0) PAID_LOSS
                          FROM GICL_RES_BRDRX_DS_EXTR A
                         WHERE A.SESSION_ID = P_SESSION_ID
                           AND a.grp_seq_no in (SELECT a.share_cd
                                                  FROM giis_dist_share a
                                                 WHERE a.line_cd = i.line_cd
                                                   AND a.share_type = 2)
                           AND A.CLAIM_ID = NVL(i.CLAIM_ID,A.CLAIM_ID)
                           AND A.ITEM_NO  = i.ITEM_NO
                           AND A.PERIL_CD = i.PERIL_CD  
                           AND NVL(A.EXPENSES_PAID,0) <> 0) 
              LOOP
                v_list.cf_share_type2_EXPENSE :=  j.paid_loss + v_list.cf_share_type2_EXPENSE;
              END LOOP;
            END;
           
            BEGIN
              v_list.cf_share_type4_LOSS := 0;
              FOR g IN (SELECT NVL(A.LOSSES_PAID,0) PAID_LOSS
                          FROM GICL_RES_BRDRX_DS_EXTR A
                         WHERE A.SESSION_ID = P_SESSION_ID
                           AND a.grp_seq_no in (SELECT a.share_cd
                                                  FROM giis_dist_share a
                                                 WHERE a.line_cd = i.line_cd
                                                   AND a.share_type = 4)
                           AND A.CLAIM_ID = NVL(i.CLAIM_ID,A.CLAIM_ID)
                           AND A.ITEM_NO  = i.ITEM_NO
                           AND A.PERIL_CD = i.PERIL_CD  
                           AND NVL(A.LOSSES_PAID,0) <> 0) 
                  LOOP
                    v_list.cf_share_type4_LOSS :=  g.paid_loss + v_list.cf_share_type4_LOSS;
                  END LOOP;
            END;
            
            BEGIN
              v_list.cf_share_type4_EXPENSE := 0;
              FOR g IN (SELECT NVL(A.EXPENSES_PAID,0) PAID_LOSS
                          FROM GICL_RES_BRDRX_DS_EXTR A
                         WHERE A.SESSION_ID = P_SESSION_ID
                           AND a.grp_seq_no in (SELECT a.share_cd
                                                  FROM giis_dist_share a
                                                 WHERE a.line_cd = i.line_cd
                                                   AND a.share_type = 4)
                           AND A.CLAIM_ID = NVL(i.CLAIM_ID,A.CLAIM_ID)
                           AND A.ITEM_NO  = i.ITEM_NO
                           AND A.PERIL_CD = i.PERIL_CD  
                           AND NVL(A.EXPENSES_PAID,0) <> 0) 
                  LOOP
                    v_list.cf_share_type4_EXPENSE :=  g.paid_loss + v_list.cf_share_type4_EXPENSE;
                  END LOOP;
            END;

            BEGIN
              BEGIN
                SELECT (NVL(v_list.cf_share_type2_LOSS,0) + NVL(v_list.cf_share_type3_LOSS,0))
                  INTO v_list.recoverable_loss
                  FROM dual;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                  v_list.recoverable_loss := NULL;
              END;
            END;

            BEGIN
              BEGIN
                SELECT (NVL(v_list.cf_share_type2_EXPENSE,0) + NVL(v_list.cf_share_type3_EXPENSE,0))
                  INTO v_list.recoverable_expense
                  FROM dual;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   v_list.recoverable_expense := NULL;
              END;
            END;
            v_list.tran_date_loss := GICLS202_EXTRACTION_PKG.GET_GICLR209_DTL(i.claim_id, TO_DATE (p_date_from, 'MM-DD-YYYY'), TO_DATE (p_date_to, 'MM-DD-YYYY'), i.pd_date_opt, 'L', 'TRAN_DATE');
            v_list.tran_date_expense := GICLS202_EXTRACTION_PKG.GET_GICLR209_DTL(i.claim_id, TO_DATE (p_date_from, 'MM-DD-YYYY'), TO_DATE (p_date_to, 'MM-DD-YYYY'), i.pd_date_opt, 'E', 'TRAN_DATE');
            
            PIPE ROW(v_list);
        END LOOP;

        IF v_not_exist THEN
           v_list.flag  := 'Y';
           PIPE ROW(v_list);
        END IF;        
        RETURN;    
    END get_giclr209le_report;
   
END;
/


