CREATE OR REPLACE PACKAGE BODY CPI.GICLS125_PKG
AS
    
    FUNCTION get_reopen_recovery(
        p_claim_id      VARCHAR2,
        p_module_id     VARCHAR2,
        p_user_id       VARCHAR2,
        p_line_cd       VARCHAR2    --Gzelle 09102015 SR3292
    )
        RETURN reopen_recovery_tab PIPELINED
    IS
        v_list  reopen_recovery_type;
    BEGIN
        FOR i IN(
            SELECT recovery_id,claim_id,
                   DECODE(cancel_tag,'','In Progress','CD','Closed','CC','Cancelled','WO','Written Off') status,
                   lawyer_cd, lawyer_class_cd, tp_item_desc, recoverable_amt, recovered_amt, plate_no, line_cd  --(line_cd) Gzelle 09102015 SR3292
              FROM gicl_clm_recovery
             WHERE check_user_per_line2(line_cd,iss_cd,'GICLS125', p_user_id)=1 
               AND cancel_tag is not null
               AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS125', p_user_id) = 1
               AND line_cd LIKE NVL(p_line_cd, '%')    --Gzelle 09102015 SR3292
               --AND claim_id = p_claim_id
                )

        LOOP
            v_list.recovery_id      := i.recovery_id;    
            v_list.claim_id         := i.claim_id;       
            v_list.recovery_no      := get_recovery_no(i.recovery_id);    
            v_list.claim_no         := get_claim_number(i.claim_id);
            v_list.recovery_type    := get_rec_type(i.recovery_id);       
            v_list.status           := UPPER(i.status);         
            v_list.lawyer_cd        := i.lawyer_cd;      
            v_list.lawyer_class_cd  := i.lawyer_class_cd;
            v_list.tp_item_desc     := i.tp_item_desc;
            v_list.recoverable_amt  := i.recoverable_amt;
            v_list.recovered_amt    := i.recovered_amt;  
            v_list.plate_no         := i.plate_no;       
            v_list.line_cd          := i.line_cd;  --Gzelle 09102015 SR3292
            v_list.policy_no     := '';
            v_list.assd_name     := '';
            v_list.loss_cat_desc := '';
            v_list.loss_date     := '';
            v_list.clm_file_date := '';
            
            FOR cl IN(
                  SELECT line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no,
                         assd_no, loss_cat_cd, 
                         loss_date, clm_file_date
                    FROM gicl_claims
                   WHERE claim_id = i.claim_id
            )
            LOOP
                v_list.policy_no        := get_policy_no(get_policy_id(cl.line_cd, cl.subline_cd, cl.pol_iss_cd, cl.issue_yy, cl.pol_seq_no, cl.renew_no));
                v_list.assd_name        := get_assd_name(cl.assd_no);
                v_list.loss_cat_desc    := cl.loss_cat_cd||' - '||get_loss_cat_des(cl.loss_cat_cd,cl.line_cd);
                v_list.loss_date        := cl.loss_date;
                v_list.clm_file_date    := cl.clm_file_date;
                
            END LOOP;  
            
            
            v_list.lawyer_name := '';
            FOR rec IN (
                  SELECT payee_last_name||DECODE(payee_first_name,NULL,'',', ')||
                         payee_first_name||DECODE(payee_middle_name,NULL,'',' ')||
                         payee_middle_name pname
                    FROM giis_payees
                   WHERE payee_no =       i.lawyer_cd      
                     AND payee_class_cd = i.lawyer_class_cd
                 )
            LOOP
               v_list.lawyer_name    := rec.pname;
            END LOOP;       
            
            PIPE ROW(v_list);
        END LOOP;
        RETURN;
    
    END get_reopen_recovery;
    
    
    PROCEDURE reopen_recovery_gicls125(
        p_claim_id          NUMBER,
        p_recovery_id       NUMBER,
        p_user_id           VARCHAR2
    )
    IS
        v_hist_no  NUMBER;
        v_rec_stat VARCHAR2(5);
    
    BEGIN
       
        UPDATE gicl_clm_recovery
           SET cancel_tag = NULL
         WHERE claim_id = p_claim_id
           AND recovery_id = p_recovery_id;
        
        v_hist_no := 0;  
                       
        FOR get_max_hist IN (
                             SELECT MAX(rec_hist_no) hist_no
                               FROM gicl_rec_hist
                              WHERE recovery_id = p_recovery_id
                              ) 
        LOOP
          v_hist_no := get_max_hist.hist_no;
          EXIT;
        END LOOP;
        
        FOR reopen IN (
                        SELECT Giisp.v('REOPEN_REC_STAT') rec_stat
                          FROM dual
                      )
        LOOP
            v_rec_stat := reopen.rec_stat;
        EXIT;
        END LOOP;
                
        INSERT INTO gicl_rec_hist
                   (recovery_id,rec_hist_no,rec_stat_cd,user_id,last_update)
             VALUES 
                   (p_recovery_id,v_hist_no + 1,v_rec_stat,p_user_id,sysdate);        
        COMMIT;
   END;	
        
END;
/


