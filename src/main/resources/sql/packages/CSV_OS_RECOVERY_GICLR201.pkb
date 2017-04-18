CREATE OR REPLACE PACKAGE BODY CPI.CSV_OS_RECOVERY_GICLR201
AS
    /*
     **  Created by   : Mary Cris Invento
     **  Date Created : 03.29.2016
     **  Reference By : GICLR202
     **  Description  : Outstanding Claim Recoveries
     **  SR No.:      : 5398
     */
    FUNCTION CSV_GICLR202 (
        p_as_of_date      VARCHAR2,
        p_line_cd         VARCHAR2,
        p_iss_cd          VARCHAR2,
        p_rec_type_cd     VARCHAR2
    ) RETURN report_tab PIPELINED
    IS
        v_list        report_type;
    BEGIN
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
            v_list.claim_number := i.claim_no;
            v_list.policy_number := i.policy_no;
            
            BEGIN
                SELECT assd_name
                  INTO v_list.assured
                  FROM giis_assured
                 WHERE assd_no = i.assd_no;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                   v_list.assured := NULL;
            END;
            
            v_list.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-DD-RRRR');
            v_list.file_date := TO_CHAR(i.clm_file_date, 'MM-DD-RRRR');
            v_list.recovery_number := i.recovery_no;
            v_list.recoverable_amount := TRIM(TO_CHAR(i.recoverable_amt, '999,999,999,990.00'));
            
            FOR d IN (SELECT rec_type_desc
                    FROM giis_recovery_type
                    WHERE rec_type_cd = i.rec_type_cd)
            LOOP
                v_list.recovery_type := d.rec_type_desc;
            END LOOP;
            
            
            IF i.cancel_tag IS NULL THEN
                 v_list.recovery_status := 'IN PROGRESS';
              ELSIF i.cancel_tag = GIISP.V('CLOSE_REC_STAT') THEN
                 v_list.recovery_status := 'CLOSED';
              ELSIF i.cancel_tag = GIISP.V('CANCEL_REC_STAT') THEN
                 v_list.recovery_status := 'CANCELLED';
              ELSIF i.cancel_tag = GIISP.V('WRITE_OFF_REC_STAT') THEN
                 v_list.recovery_status := 'WRITTEN OFF';
            END IF;
            
            FOR l IN (SELECT DECODE (payee_first_name,
                                        NULL, payee_last_name,
                                           payee_last_name
                                        || ', '
                                        || payee_first_name
                                        || ' '
                                        || payee_middle_name
                                       ) lawyer
                           FROM giis_payees
                          WHERE payee_class_cd = i.lawyer_class_cd
                            AND payee_no =  i.lawyer_cd)
            LOOP
                v_list.lawyer := l.lawyer;
            END LOOP;          
            
            PIPE ROW (v_list);
            v_list.lawyer := NULL;
           
        END LOOP;
        RETURN;
    END CSV_GICLR202;
END;
/