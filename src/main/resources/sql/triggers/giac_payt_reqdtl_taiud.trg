CREATE OR REPLACE TRIGGER CPI.GIAC_PAYT_REQDTL_TAIUD
AFTER UPDATE OF payt_req_flag ON CPI.GIAC_PAYT_REQUESTS_DTL FOR EACH ROW
WHEN (
NEW.payt_req_flag = 'X'
      )
DECLARE 
    v_limit     NUMBER := 0;  --added by John Daniel 04.11.2016 SR-22053
BEGIN
/* modified by judyann 06222004
** added updates on batch dv/special csr-related tables
*/
/* modified by alfie 05272010
** added creation of REV transaction for posted BCS transactions
*/
  FOR i IN (SELECT b.claim_id, b.advice_id, b.batch_csr_id, b.batch_dv_id
              FROM GICL_ADVICE b,
                   GIAC_DIRECT_CLAIM_PAYTS a
             WHERE b.advice_id = a.advice_id
               AND b.claim_id = a.claim_id
               AND a.gacc_tran_id = :NEW.tran_id
            UNION
            SELECT b.claim_id, b.advice_id, b.batch_csr_id, b.batch_dv_id
              FROM GICL_ADVICE b,
                   GIAC_INW_CLAIM_PAYTS a
             WHERE b.advice_id = a.advice_id
               AND b.claim_id = a.claim_id
               AND a.gacc_tran_id = :NEW.tran_id)
  LOOP
    UPDATE GICL_ADVICE
       SET apprvd_tag = 'N'
     WHERE claim_id = i.claim_id
       AND advice_id = i.advice_id;
    IF i.batch_csr_id IS NOT NULL THEN
       UPDATE GICL_BATCH_CSR
          SET batch_flag = 'N',
              tran_id = NULL,
              ref_id = NULL,
              req_dtl_no = NULL
        WHERE batch_csr_id = i.batch_csr_id;
    ELSIF i.batch_dv_id IS NOT NULL THEN
       UPDATE GIAC_BATCH_DV
          SET batch_flag = 'X'
        WHERE batch_dv_id = i.batch_dv_id;
       UPDATE GICL_ADVICE
          SET batch_dv_id = NULL
        WHERE advice_id = i.advice_id;
       --alfie 05272010: modifications start here
       DECLARE
         v_tran_flag   VARCHAR2(3); --for transaction flag, like C for CLOSED, P for Posted, O for Open, D for deleted
         v_tran_year NUMBER; --for transaction year
         v_tran_month NUMBER; --for transaction month
         v_rev_tran_id NUMBER; --the tran_id to be used for the REV transaction
         v_tran_seq_no NUMBER; --tran_seq_no, to be inserted in giac_acctrans, for the REV transaction
         v_tran_class_no NUMBER; --tran_class_no, to be inserted in tran_class_no, for the REV transaction
       BEGIN
         --
         SELECT tran_flag
           INTO v_tran_flag
             FROM GIAC_ACCTRANS
               WHERE tran_id = :NEW.tran_id;
         --
           SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),
                  TO_NUMBER(TO_CHAR(SYSDATE, 'MM'))
             INTO v_tran_year, v_tran_month
               FROM DUAL;
         --
         IF v_tran_flag = 'P' THEN --if BCS transactions are already posted in the trial balance
             FOR bcs_tran IN (SELECT DISTINCT b.tran_id,
                              b.gfun_fund_cd, 
                              b.gibr_branch_cd 
                         FROM GIAC_BATCH_DV_DTL a, GIAC_ACCTRANS b
                           WHERE batch_dv_id = i.batch_dv_id
                            AND b.tran_id = a.jv_tran_id)
             LOOP
               --
               IF v_limit = 1 THEN  --added by John Daniel 04.11.2016 SR-22053
                    EXIT;
               ELSE 
                    v_limit := 1;
               END IF;
               
               SELECT acctran_tran_id_s.NEXTVAL 
                 INTO  v_rev_tran_id 
                   FROM dual;
               --             
               v_tran_seq_no := Giac_Sequence_Generation(bcs_tran.gfun_fund_cd,bcs_tran.gibr_branch_cd, 'ACCTRAN_TRAN_SEQ_NO',v_tran_year,v_tran_month);
               v_tran_class_no := Giac_Sequence_Generation(bcs_tran.gfun_fund_cd,bcs_tran.gibr_branch_cd,'REV', 0, 0);
               INSERT INTO GIAC_ACCTRANS(tran_id, gfun_fund_cd, 
                                         gibr_branch_cd, tran_year,
                                         tran_month, tran_seq_no,
                                         tran_date, tran_flag,                             
                                         tran_class, tran_class_no,
                                         particulars, user_id,
                                         last_update)
                 VALUES(v_rev_tran_id, bcs_tran.gfun_fund_cd,
                        bcs_tran.gibr_branch_cd, v_tran_year, 
                        v_tran_month, v_tran_seq_no,
                        SYSDATE, 'C', 
                        'REV', v_tran_class_no,
                        'Reversing entry for '||Get_Ref_No(bcs_tran.tran_id), NVL (giis_users_pkg.app_user, USER),
                        SYSDATE);
               IF SQL%NOTFOUND THEN
                 RAISE_APPLICATION_ERROR(-20124, 'Cancel DV1: Unable to insert into acctrans.');
               ELSE
                 --creates accounting entries for the REV transaction created (starts here)
                 DECLARE
                   CURSOR tr_closed IS 
                     SELECT acct_entry_id, gl_acct_id,
                            gl_acct_category, gl_control_acct,
                            gl_sub_acct_1, gl_sub_acct_2,
                            gl_sub_acct_3, gl_sub_acct_4, 
                            gl_sub_acct_5, gl_sub_acct_6, 
                            gl_sub_acct_7, sl_cd,
                            debit_amt, credit_amt,
                            generation_type, sl_type_cd
                         FROM GIAC_ACCT_ENTRIES
                           WHERE gacc_tran_id = bcs_tran.tran_id;  
                 --
                   v_debit_amt        GIAC_ACCT_ENTRIES.debit_amt%TYPE;  
                   v_credit_amt       GIAC_ACCT_ENTRIES.credit_amt%TYPE;  
                   v_debit_amt2       GIAC_ACCT_ENTRIES.debit_amt%TYPE;  
                   v_credit_amt2      GIAC_ACCT_ENTRIES.credit_amt%TYPE;  
                   v_acct_entry_id    GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;            
                 BEGIN
                   FOR tr_closed_rec IN tr_closed LOOP
                     FOR entr_id IN (
                       SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
                         FROM GIAC_ACCT_ENTRIES
                           WHERE gacc_gibr_branch_cd = bcs_tran.gibr_branch_cd
                             AND gacc_gfun_fund_cd = bcs_tran.gfun_fund_cd
                             AND gacc_tran_id = v_rev_tran_id            
                             AND NVL(gl_acct_id, gl_acct_id) = tr_closed_rec.gl_acct_id
                             AND generation_type = tr_closed_rec.generation_type
                             AND NVL(sl_cd, 0) = NVL(tr_closed_rec.sl_cd, NVL(sl_cd, 0))
                             AND NVL(sl_type_cd, '-') = NVL(tr_closed_rec.sl_type_cd, NVL(sl_type_cd, '-'))) 
                     LOOP
                       v_acct_entry_id := entr_id.acct_entry_id;
                     EXIT;
                     END LOOP;
                     -- 
                     IF NVL(v_acct_entry_id,0) = 0 THEN
                       v_acct_entry_id := NVL(v_acct_entry_id,0) + 1;
                     --
                       INSERT INTO GIAC_ACCT_ENTRIES(
                           gacc_tran_id, gacc_gfun_fund_cd,
                           gacc_gibr_branch_cd, gl_acct_id, 
                           gl_acct_category, gl_control_acct,
                           gl_sub_acct_1, gl_sub_acct_2, 
                           gl_sub_acct_3, gl_sub_acct_4, 
                           gl_sub_acct_5, gl_sub_acct_6, 
                           gl_sub_acct_7, sl_cd, 
                           debit_amt, credit_amt, 
                           generation_type, sl_type_cd,
                           user_id, last_update)
                         VALUES(v_rev_tran_id, bcs_tran.gfun_fund_cd,
                                bcs_tran.gibr_branch_cd, tr_closed_rec.gl_acct_id, 
                                tr_closed_rec.gl_acct_category, tr_closed_rec.gl_control_acct, 
                                tr_closed_rec.gl_sub_acct_1, tr_closed_rec.gl_sub_acct_2, 
                                tr_closed_rec.gl_sub_acct_3, tr_closed_rec.gl_sub_acct_4,  
                                tr_closed_rec.gl_sub_acct_5, tr_closed_rec.gl_sub_acct_6,  
                                tr_closed_rec.gl_sub_acct_7, tr_closed_rec.sl_cd,
                                tr_closed_rec.credit_amt, tr_closed_rec.debit_amt, 
                                tr_closed_rec.generation_type, tr_closed_rec.sl_type_cd,
                                NVL (giis_users_pkg.app_user, USER), SYSDATE);
                     ELSE
                       UPDATE GIAC_ACCT_ENTRIES
                         SET debit_amt  = debit_amt  + tr_closed_rec.credit_amt,
                             credit_amt = credit_amt + tr_closed_rec.debit_amt
                           WHERE generation_type = tr_closed_rec.generation_type
                             AND gl_acct_id = tr_closed_rec.gl_acct_id
                             AND gacc_gibr_branch_cd = bcs_tran.gibr_branch_cd
                             AND gacc_gfun_fund_cd = bcs_tran.gfun_fund_cd 
                             AND gacc_tran_id = v_rev_tran_id
                             AND NVL(sl_cd, 0) = NVL(tr_closed_rec.sl_cd, 0)
                             AND NVL(sl_type_cd, '-') = NVL(tr_closed_rec.sl_type_cd, NVL(sl_type_cd, '-'));
                     END IF;
                   END LOOP;
                 END;--(ends here)
               END IF; 
               --
               IF SQL%NOTFOUND THEN
                 ROLLBACK;
                 RAISE_APPLICATION_ERROR(-20125,'Cancel DV: Unable to insert into acct entries.');
               ELSE
                 --insert the created BCS and REV transaction for data linking purposes
                 INSERT INTO GIAC_REVERSALS(
                   gacc_tran_id, reversing_tran_id, rev_corr_tag)
                 VALUES(bcs_tran.tran_id, v_rev_tran_id, 'R');
                 IF SQL%NOTFOUND THEN
                   ROLLBACK;
                   RAISE_APPLICATION_ERROR(-20126,'Cancel DV: Unable to insert into reversals.');
                 END IF;
               END IF;
             END LOOP;
         ELSE  --if BCS transactions are not yet posted in the trial balance
           FOR j IN (SELECT jv_tran_id
                       FROM GIAC_BATCH_DV_DTL
                      WHERE batch_dv_id = i.batch_dv_id)
           LOOP
               UPDATE GIAC_ACCTRANS
                SET tran_flag = 'D'
              WHERE tran_id = j.jv_tran_id;
           END LOOP;
         END IF;
       END; --alfie 05272010: modifications end here
    END IF;
  END LOOP;
END;
/


