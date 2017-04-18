CREATE OR REPLACE PACKAGE BODY CPI.giclr201_pkg
AS
    FUNCTION get_giclr_201_report (
        p_user_id         VARCHAR2,
        p_date_sw         VARCHAR2,
        p_from_date       VARCHAR2,
        p_to_date         VARCHAR2,
        p_iss_cd          VARCHAR2,
        p_intm_no         VARCHAR2,
        p_line_cd         VARCHAR2,
        p_rec_type_cd     VARCHAR2
    ) RETURN report_tab PIPELINED
    IS
        v_list        report_type;
        v_print       BOOLEAN := false;
    BEGIN        
        v_list.company_name := giisp.v ('COMPANY_NAME');
        v_list.company_address := giisp.v ('COMPANY_ADDRESS');
        
        BEGIN
            IF p_date_sw = 1 THEN
                v_list.date_title := 'CLAIMS RECOVERY REGISTER (Based on Loss Date)';
            ELSIF p_date_sw = 2 THEN
                v_list.date_title := 'CLAIMS RECOVERY REGISTER (Based on Claim File Date)';
            ELSIF p_date_sw = 3 THEN
                v_list.date_title := 'CLAIMS RECOVERY REGISTER (Based on Recovery Date)';
            ELSIF p_date_sw = 4 THEN 
                v_list.date_title := 'CLAIMS RECOVERY REGISTER (Based on Recovery File Date)';
            END IF;
        END;

        BEGIN
          v_list.date_coverage := 'For the period of '||TO_CHAR (TO_DATE(p_from_date,'mm-dd-yyyy'),'fmMonth DD, YYYY')||
                  ' to '||TO_CHAR(TO_DATE(p_to_date,'mm-dd-yyyy'),'fmMonth DD, YYYY');
        END;
            
        FOR i IN ( SELECT   a.claim_id, b.recovery_id, a.line_cd, a.iss_cd,
                            a.line_cd || '-' || a.subline_cd || '-' || a.iss_cd || '-' || LTRIM (TO_CHAR (a.clm_yy, '09')) 
                                || '-' || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) claim_no,
                            a.line_cd || '-' || a.subline_cd || '-' || a.pol_iss_cd || '-' || LTRIM (TO_CHAR (a.issue_yy, '09'))
                                || '-' || LTRIM (TO_CHAR (a.pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                            b.line_cd || '-' || b.iss_cd || '-' || rec_year || '-' || LTRIM (TO_CHAR (rec_seq_no, '099')) recovery_no,
                            a.assd_no, a.dsp_loss_date, a.clm_file_date, b.rec_type_cd,
                            b.cancel_tag, b.recoverable_amt, c.payor_class_cd, c.payor_cd,
                            d.recovered_amt, d.acct_tran_id, d.tran_date, b.lawyer_class_cd,
                            b.lawyer_cd, f.intm_name, b.rec_file_date
                       FROM gicl_claims a,
                            gicl_clm_recovery b,
                            gicl_recovery_payor c,
                            gicl_recovery_payt d,
                            giis_intermediary f,
                            gicl_intm_itmperil e
                      WHERE a.claim_id = b.claim_id
                        AND UPPER(a.user_id) = UPPER(p_user_id)
                        AND b.claim_id = c.claim_id(+)
                        AND b.recovery_id = c.recovery_id(+)
                        AND c.claim_id = d.claim_id(+)
                        AND c.recovery_id = d.recovery_id(+)
                        AND c.payor_class_cd = d.payor_class_cd(+)
                        AND e.intm_no = f.intm_no
                        AND e.claim_id = a.claim_id
                        AND e.intm_no = NVL(p_intm_no, e.intm_no)
                        AND c.payor_cd = d.payor_cd(+)
                        AND NVL (d.cancel_tag, 'N') = 'N'
                        AND DECODE (p_date_sw,
                                    1, TRUNC (a.loss_date),
                                    2, TRUNC (a.clm_file_date),
                                    3, TRUNC (d.tran_date),
                                    4, TRUNC (b.rec_file_date)
                                   ) BETWEEN (TO_DATE(p_from_date,'mm-dd-yyyy')) AND (TO_DATE(p_to_date,'mm-dd-yyyy'))
                        AND a.line_cd = NVL (p_line_cd, DECODE (check_user_per_iss_cd2 (a.line_cd, NULL, 'GICLS201', UPPER(p_user_id)),
                                                        1, a.line_cd,
                                                        0, ''
                                                       )
                                            )
                        AND a.iss_cd = NVL (p_iss_cd, DECODE (check_user_per_iss_cd2 (NULL, a.iss_cd, 'GICLS201', UPPER(p_user_id)),
                                                                1, a.iss_cd,
                                                                0, ''
                                                               )
                                           )
                        AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS201', UPPER(p_user_id)) = 1
                        AND b.rec_type_cd = NVL (p_rec_type_cd, b.rec_type_cd)
                        AND (   EXISTS (
                                   SELECT *
                                     FROM gicl_intm_itmperil e
                                    WHERE e.claim_id = a.claim_id
                                      AND e.intm_no = NVL (p_intm_no, e.intm_no))
                             OR (a.pol_iss_cd = 'RI' AND p_intm_no IS NULL)
                            )
        )
        LOOP
            v_list.print_details := 'Y';
            v_print := TRUE;
            v_list.claim_id := i.claim_id;
            v_list.intm_name := i.intm_name;
            v_list.recovery_id := i. recovery_id;
            v_list.recoverable_amt := i. recoverable_amt;
            v_list.recovered_amt := i. recovered_amt;
            v_list.line_cd := i.line_cd;
            v_list.iss_cd := i.iss_cd;
            v_list.claim_no := i.claim_no;
            v_list.policy_no := i.policy_no;
            v_list.assd_no := i.assd_no;
            v_list.dsp_loss_date := i.dsp_loss_date;
            v_list.clm_file_date := i.clm_file_date;
            v_list.cancel_tag := i.cancel_tag;
            v_list.acct_tran_id := i.acct_tran_id;
            v_list.lawyer_class_cd := i.lawyer_class_cd;
            /*v_list.company_name := giisp.v ('COMPANY_NAME'); -- moved outside the loop : shan 01.22.2014
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');*/
            v_list.lawyer_cd := i.lawyer_cd;
         
            BEGIN
                SELECT assd_name
                  INTO v_list.assd_name
                  FROM giis_assured
                 WHERE assd_no = i.assd_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   v_list.assd_name := NULL;
            END;
         
            /* moved outside the loop : shan 01.22.2014
            BEGIN
                IF p_date_sw = 1 THEN
                    v_list.date_title := 'CLAIMS RECOVERY REGISTER (Based on Loss Date)';
                ELSIF p_date_sw = 2 THEN
                    v_list.date_title := 'CLAIMS RECOVERY REGISTER (Based on Claim File Date)';
                ELSIF p_date_sw = 3 THEN
                    v_list.date_title := 'CLAIMS RECOVERY REGISTER (Based on Recovery Date)';
                ELSIF p_date_sw = 4 THEN 
                    v_list.date_title := 'CLAIMS RECOVERY REGISTER (Based on Recovery File Date)';
                END IF;
            END;

            BEGIN
              v_list.date_coverage := 'For the period of '||TO_CHAR (TO_DATE(p_from_date,'mm-dd-yyyy'),'fmMonth DD, YYYY')||
                      ' to '||TO_CHAR(TO_DATE(p_to_date,'mm-dd-yyyy'),'fmMonth DD, YYYY');
            END;*/
            
            PIPE ROW (v_list);
         
        END LOOP;
        
        IF v_print = FALSE THEN
            v_list.print_details := 'N';
            PIPE ROW(v_list);
        END IF;
        
        RETURN;
    END get_giclr_201_report;
   
   FUNCTION get_giclr201_2details (
     p_claim_id         NUMBER,
     p_recovery_id      NUMBER
   )
      RETURN giclr201_detail2_tab PIPELINED
   IS
      v_list        giclr201_detail2_type;
      
   BEGIN
      FOR i IN (SELECT a.recovered_amt, b.payor_cd, b.payor_class_cd
                FROM gicl_clm_recovery a, gicl_recovery_payor b
               WHERE a.claim_id = b.claim_id(+)
                 AND b.claim_id = p_claim_id
                 AND a.recovery_id = b.recovery_id(+)
                 AND b.recovery_id = p_recovery_id)
      LOOP
         v_list.recovered_amt := i.recovered_amt;
         v_list.payor_cd := i.payor_cd;
         v_list.payor_class_cd := i.payor_class_cd;
         
         BEGIN
            SELECT payee_last_name||decode(payee_first_name,NULL,NULL,
                   ', '||payee_first_name)||decode(payee_middle_name,NULL,NULL,
                   ' '||substr(payee_middle_name,1,1)||'.') payor
              INTO v_list.payor
              FROM giis_payees
             WHERE payee_class_cd = i.payor_class_cd
               AND payee_no = i.payor_cd;
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.payor := NULL;
         END;
         
         PIPE ROW(v_list);
         
      END LOOP;

      RETURN;
   END get_giclr201_2details;
   
   
   FUNCTION get_giclr201_3details (
     p_claim_id         NUMBER,
     p_recovery_id      NUMBER,
     p_acct_tran_id     VARCHAR2
   )
      RETURN giclr201_detail3_tab PIPELINED
   IS
      v_list        giclr201_detail3_type;
      
   BEGIN
      FOR i IN (SELECT tran_date
                  FROM gicl_recovery_payt
                 WHERE claim_id = p_claim_id
                   AND recovery_id = p_recovery_id)
      LOOP
       v_list.tran_date := i.tran_date;
       
             BEGIN
               FOR t IN (SELECT tran_class, tran_class_no
                           FROM giac_acctrans
                          WHERE tran_id = p_acct_tran_id)
               LOOP
                  IF t.tran_class = 'COL'
                  THEN
                     FOR c IN (SELECT or_pref_suf, or_no
                                 FROM giac_order_of_payts
                                WHERE gacc_tran_id = p_acct_tran_id)
                     LOOP
                        IF c.or_no IS NOT NULL
                        THEN
                           v_list.ref_no :=
                                 c.or_pref_suf
                              || '-'
                              || LTRIM (TO_CHAR (c.or_no, '0999999999'));
                        ELSE
                           v_list.ref_no := NULL;
                        END IF;
                     END LOOP;
                  ELSIF t.tran_class = 'DV'
                  THEN
                     FOR r IN (SELECT document_cd, branch_cd, line_cd, doc_year, doc_mm,
                                      doc_seq_no
                                 FROM giac_payt_requests a, giac_payt_requests_dtl b
                                WHERE a.ref_id = b.gprq_ref_id
                                  AND b.tran_id = p_acct_tran_id)
                     LOOP
                        v_list.ref_no :=
                              r.document_cd
                           || '-'
                           || r.branch_cd
                           || '-'
                           || r.line_cd
                           || '-'
                           || LTRIM (TO_CHAR (r.doc_year, '0999'))
                           || '-'
                           || LTRIM (TO_CHAR (r.doc_mm, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (r.doc_seq_no, '099999'));

                        FOR d IN (SELECT dv_pref, dv_no
                                    FROM giac_disb_vouchers
                                   WHERE gacc_tran_id = p_acct_tran_id)
                        LOOP
                           IF d.dv_no IS NOT NULL
                           THEN
                              v_list.ref_no :=
                                    d.dv_pref
                                 || '-'
                                 || LTRIM (TO_CHAR (d.dv_no, '0999999999'));
                           ELSE
                              v_list.ref_no := NULL;
                           END IF;
                        END LOOP;
                     END LOOP;
                  ELSIF t.tran_class = 'JV'
                  THEN
                     IF t.tran_class_no IS NOT NULL
                     THEN
                        v_list.ref_no :=
                              t.tran_class
                           || '-'
                           || LTRIM (TO_CHAR (t.tran_class_no, '0999999999'));
                     ELSE
                        v_list.ref_no := NULL;
                     END IF;
                  END IF;
               END LOOP;

            END;

        PIPE ROW(v_list);
        
      END LOOP

      RETURN;
   END get_giclr201_3details;
   
   FUNCTION get_giclr201_details(
     p_claim_id NUMBER,
     p_recovery_id NUMBER
   )
     RETURN giclr201_details_tab PIPELINED
   IS
     v_list giclr201_details_type;
   BEGIN
     FOR i IN(SELECT line_cd
                 || '-'
                 || iss_cd
                 || '-'
                 || rec_year
                 || '-'
                 || LTRIM (TO_CHAR (rec_seq_no, '099')) recovery_no, lawyer_cd, lawyer_class_cd,
                     rec_file_date, rec_type_cd, cancel_tag, recoverable_amt, recovered_amt
                FROM gicl_clm_recovery
               WHERE claim_id = p_claim_id
                 AND recovery_id = p_recovery_id) 
     LOOP
       v_list.recovery_no := i.recovery_no;
       v_list.rec_file_date := i.rec_file_date;
       v_list.cancel_tag := i.cancel_tag;
       v_list.lawyer_cd := i.lawyer_cd;
       v_list.lawyer_class_cd := i.lawyer_class_cd;
       v_list.recoverable_amt := i.recoverable_amt;
       v_list.recovered_amt := i.recovered_amt;
       
       BEGIN
            SELECT DECODE(payee_first_name, NULL, payee_last_name,
                          payee_last_name||', '||payee_first_name||' '||payee_middle_name)
              INTO v_list.lawyer
              FROM giis_payees
             WHERE payee_class_cd = i.lawyer_class_cd
               AND payee_no = i.lawyer_cd;
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.lawyer := NULL;
         END;
       
       BEGIN
            SELECT rec_type_desc
              INTO v_list.rec_type_desc
              FROM giis_recovery_type
             WHERE rec_type_cd = i.rec_type_cd;
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.rec_type_desc := NULL;
         END;
         
         IF i.cancel_tag IS NULL THEN
             v_list.rec_status := 'IN PROGRESS';
          ELSIF i.cancel_tag = GIISP.V('CLOSE_REC_STAT') THEN
             v_list.rec_status := 'CLOSED';
          ELSIF i.cancel_tag = GIISP.V('CANCEL_REC_STAT') THEN
             v_list.rec_status := 'CANCELLED';
          ELSIF i.cancel_tag = GIISP.V('WRITE_OFF_REC_STAT') THEN
             v_list.rec_status := 'WRITTEN OFF';
          END IF;    
         
       PIPE ROW(v_list);
     END LOOP;
     RETURN;
   END get_giclr201_details;  
     
END;
/


