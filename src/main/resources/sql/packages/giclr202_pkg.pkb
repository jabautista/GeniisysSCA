CREATE OR REPLACE PACKAGE BODY CPI.giclr202_pkg
AS
    FUNCTION get_giclr_202_report (
        p_user_id         VARCHAR2,
        p_as_of_date      VARCHAR2,
        p_line_cd         VARCHAR2,
        p_iss_cd          VARCHAR2,
        p_rec_type_cd     VARCHAR2
    ) RETURN report_tab PIPELINED
    IS
        v_list        report_type;
        v_print       BOOLEAN := FALSE;
    BEGIN
        v_list.company_name := giisp.v ('COMPANY_NAME');  -- moved outside the loop : shan 01.22.2014
        v_list.company_address := giisp.v ('COMPANY_ADDRESS');
            
        IF p_as_of_date IS NOT NULL THEN
            v_list.date_sw :='As of '||TO_CHAR(TO_DATE(p_as_of_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
        END IF;
        FOR i IN (SELECT a.claim_id, b.recovery_id, a.line_cd, a.iss_cd,
                         a.line_cd
                         || '-' 
                         || a.subline_cd 
                         || '-' 
                         || a.iss_cd 
                         || '-' 
                         || LPAD (TO_CHAR (a.clm_yy), 2, '0') 
                         || '-' 
                         || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_no,
                         a.line_cd 
                         || '-' 
                         || a.subline_cd 
                         || '-' 
                         || a.pol_iss_cd 
                         || '-' 
                         || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                         || '-' 
                         || LPAD (TO_CHAR (a.pol_seq_no), 7, '0') 
                         || '-' 
                         || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_no,
                         b.line_cd 
                         || '-' 
                         || b.iss_cd
                         || '-' 
                         || rec_year 
                         || '-'
                         || LPAD (TO_CHAR (rec_seq_no), 3, '0') recovery_no,
                         a.assd_no, a.dsp_loss_date, a.clm_file_date, b.rec_type_cd,
                         b.cancel_tag, b.rec_file_date,
                         NVL (b.recoverable_amt, 0) recoverable_amt,
                         NVL (b.recovered_amt, 0) recovered_amt,
                         NVL (b.recoverable_amt, 0) - NVL (b.recovered_amt, 0) 
                         rec_sum,
                         b.lawyer_class_cd, b.lawyer_cd
                    FROM gicl_claims a, gicl_clm_recovery b
                   WHERE a.claim_id = b.claim_id
                     AND TRUNC (b.rec_file_date) <= TO_DATE(p_as_of_date, 'MM-DD-RRRR')
                     AND a.line_cd = 
                            NVL (p_line_cd, 
                                DECODE (check_user_per_iss_cd (a.line_cd, NULL, 'GICLS201'),
                                                             1, a.line_cd,
                                                             0, ''
                                                            )
                                          )
                     AND a.iss_cd = 
                            NVL (p_iss_cd, 
                                DECODE (check_user_per_iss_cd (NULL, a.iss_cd,
                                'GICLS201'),
                                                             1, a.iss_cd,
                                                             0, ''
                                                            )
                                        )
                     AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS201') = 1
                     AND NVL (b.cancel_tag, 'IP') NOT IN ('CC', 'CD', 'WO')
                     AND (NVL (b.recoverable_amt, 0) - NVL (b.recovered_amt, 0)) != 0
                     AND (  (NVL (b.recoverable_amt, 0) - NVL (b.recovered_amt, 0))
                              + ABS ((NVL (b.recoverable_amt, 0) - NVL 
                              (b.recovered_amt, 0)))
                          ) != 0
                     AND b.rec_type_cd = NVL (p_rec_type_cd, b.rec_type_cd)
                   ORDER BY a.line_cd 
                            || '-' 
                            || a.subline_cd 
                            || '-' 
                            || a.iss_cd 
                            || '-'
                            || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                            || '-' 
                            || LPAD (TO_CHAR (a.clm_seq_no), 7, '0'), 
                             b.line_cd 
                            || '-' 
                            || rec_year 
                            || '-' 
                            || LPAD (TO_CHAR (rec_seq_no), 3, '0')
        )
        LOOP
            v_print := TRUE;
            v_list.print_details := 'Y';
            v_list.claim_id := i.claim_id;
            v_list.recovery_id := i.recovery_id;
            v_list.lawyer_cd := i.lawyer_cd;
            v_list.lawyer_class_cd := i.lawyer_class_cd;
            v_list.cancel_tag := i.cancel_tag;
            v_list.rec_type_cd := i.rec_type_cd;
            v_list.rec_file_date := i.rec_file_date;
            v_list.claim_id := i.claim_id;
            v_list.claim_no := i.claim_no;
            v_list.policy_no := i.policy_no;
            v_list.assd_no := i.assd_no;
            v_list.dsp_loss_date := i.dsp_loss_date;
            v_list.clm_file_date := i.clm_file_date;
            /*v_list.company_name := giisp.v ('COMPANY_NAME');  -- moved outside the loop : shan 01.22.2014
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');*/
                     
            BEGIN
                SELECT assd_name
                  INTO v_list.assd_name
                  FROM giis_assured
                 WHERE assd_no = i.assd_no;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                   v_list.assd_name := NULL;
            END;
                     
            /* moved outside the loop : shan 01.22.2014
            IF p_as_of_date IS NOT NULL THEN
                v_list.date_sw :='As of '||TO_CHAR(TO_DATE(p_as_of_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
            END IF;
            */
                                     
            PIPE ROW (v_list);
           
        END LOOP;

         IF v_print = FALSE THEN
            v_list.print_details := 'N';
            PIPE ROW (v_list);
        END IF;
            
        RETURN;
    END get_giclr_202_report;
   
   
   FUNCTION get_giclr_202_details_report (
      p_claim_id        VARCHAR2,
      p_recovery_id     VARCHAR2,
      p_rec_file_date   VARCHAR2,
      p_rec_type_cd     VARCHAR2,
      p_cancel_tag      VARCHAR2,
      p_lawyer_cd       VARCHAR2,
      p_lawyer_class_cd VARCHAR2
   )
      RETURN giclr202_tab PIPELINED
   IS
      v_list        giclr202_type;
      
   BEGIN
      FOR i IN (SELECT 
            line_cd
         || '-'
         || iss_cd
         || '-'
         || rec_year
         || '-'
         || LPAD (TO_CHAR (rec_seq_no), 3, '0') recovery_no, recoverable_amt
    FROM gicl_clm_recovery
   WHERE claim_id = p_claim_id
   AND recovery_id = p_recovery_id

    )
      LOOP
         v_list.recovery_no := i.recovery_no;
         v_list.recoverable_amt := i.recoverable_amt;
         
         BEGIN

          FOR d IN (SELECT rec_type_desc
                      FROM giis_recovery_type
                     WHERE rec_type_cd = p_rec_type_cd)
          LOOP
            v_list.rec_type_desc := d.rec_type_desc;
          END LOOP;          

        END;
         
         BEGIN

              IF p_cancel_tag IS NULL THEN
                 v_list.rec_status := 'IN PROGRESS';
              ELSIF p_cancel_tag = GIISP.V('CLOSE_REC_STAT') THEN
                 v_list.rec_status := 'CLOSED';
              ELSIF p_cancel_tag = GIISP.V('CANCEL_REC_STAT') THEN
                 v_list.rec_status := 'CANCELLED';
              ELSIF p_cancel_tag = GIISP.V('WRITE_OFF_REC_STAT') THEN
                 v_list.rec_status := 'WRITTEN OFF';
              END IF;

         END;
         
         BEGIN
               FOR l IN (SELECT DECODE (payee_first_name,
                                        NULL, payee_last_name,
                                           payee_last_name
                                        || ', '
                                        || payee_first_name
                                        || ' '
                                        || payee_middle_name
                                       ) lawyer
                           FROM giis_payees
                          WHERE payee_class_cd = p_lawyer_class_cd
                            AND payee_no = p_lawyer_cd)
               LOOP
                  v_list.lawyer := l.lawyer;
               END LOOP;

         END;
                         
         PIPE ROW (v_list);
         
      END LOOP;

      RETURN;
   END get_giclr_202_details_report;
END;
/
