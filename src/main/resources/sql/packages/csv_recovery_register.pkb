CREATE OR REPLACE PACKAGE BODY CPI.CSV_RECOVERY_REGISTER AS

--START SR5397 hdrtagudin 04052016 CSV printing
FUNCTION CSV_GICLR201 (
  p_user_id       VARCHAR2, 
  p_date_sw       NUMBER,
  p_from_date     DATE,
  p_to_date       DATE,
  p_line_cd       gicl_claims.line_cd%TYPE,
  p_iss_cd        gicl_claims.iss_cd%TYPE,
  p_rec_type_cd   gicl_clm_recovery.rec_type_cd%TYPE,
  p_intm_no       giis_intermediary.intm_no%TYPE
)
  RETURN giclr201_type PIPELINED
IS
  v_giclr201                 giclr201_rec_type;
  v_intm_no                  VARCHAR2 (4000);                               --collection of distinct intermediary number.
  v_intm_name                VARCHAR2 (4000);                               --collection of all intermediary name based on the intm_no in v_intm_no.
  v_intm_temp                VARCHAR2 (50);                                 --temporary variable for intermediary.
  v_prev_claim               gicl_claims.claim_id%TYPE;                     --hold previous claim id.
  v_prev_recovery_id         gicl_clm_recovery.recovery_id%TYPE;            --hold previous recovery id.
  v_prev_payor               VARCHAR2 (50);                                 --hold previous payor.
  v_recovered_per_recovery   gicl_recovery_payt.recovered_amt%TYPE   := 0;  --total recovered amount per recovery
BEGIN

  --G_CLAIM group
  FOR rec IN
     (SELECT a.claim_id, b.recovery_id, a.line_cd, a.iss_cd,
                a.line_cd
             || '-'
             || a.subline_cd
             || '-'
             || a.iss_cd
             || '-'
             || LTRIM (TO_CHAR (a.clm_yy, '09'))
             || '-'
             || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) claim_number,
                a.line_cd
             || '-'
             || a.subline_cd
             || '-'
             || a.pol_iss_cd
             || '-'
             || LTRIM (TO_CHAR (a.issue_yy, '09'))
             || '-'
             || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
             || '-'
             || LTRIM (TO_CHAR (a.renew_no, '09')) policy_number,
                b.line_cd
             || '-'
             || b.iss_cd
             || '-'
             || rec_year
             || '-'
             || LTRIM (TO_CHAR (rec_seq_no, '099')) recovery_number,
             a.assd_no, a.dsp_loss_date, a.clm_file_date, b.rec_type_cd,
             b.cancel_tag, b.recoverable_amt, c.payor_class_cd,
             c.payor_cd, d.recovered_amt, d.acct_tran_id, d.tran_date,
             b.lawyer_class_cd, b.lawyer_cd, f.intm_name,
             b.rec_file_date
        FROM gicl_claims a,
             gicl_clm_recovery b,
             gicl_recovery_payor c,
             gicl_recovery_payt d,
             giis_intermediary f,
             gicl_intm_itmperil e
       WHERE a.claim_id = b.claim_id
         AND UPPER (a.user_id) = UPPER (p_user_id)
         AND b.claim_id = c.claim_id(+)
         AND b.recovery_id = c.recovery_id(+)
         AND c.claim_id = d.claim_id(+)
         AND c.recovery_id = d.recovery_id(+)
         AND c.payor_class_cd = d.payor_class_cd(+)
         AND e.intm_no = f.intm_no
         AND e.claim_id = a.claim_id
         AND e.intm_no = NVL (p_intm_no, e.intm_no)
         AND c.payor_cd = d.payor_cd(+)
         AND NVL (d.cancel_tag, 'N') = 'N'
         AND DECODE (p_date_sw,
                     1, TRUNC (a.loss_date),
                     2, TRUNC (a.clm_file_date),
                     3, TRUNC (d.tran_date),
                     4, TRUNC (b.rec_file_date)
                    ) BETWEEN p_from_date AND p_to_date
         AND a.line_cd =
                NVL (p_line_cd,
                     DECODE (check_user_per_iss_cd2 (a.line_cd,
                                                     NULL,
                                                     'GICLS201',
                                                     UPPER (p_user_id)
                                                    ),
                             1, a.line_cd,
                             0, ''
                            )
                    )
         AND a.iss_cd =
                NVL (p_iss_cd,
                     DECODE (check_user_per_iss_cd2 (NULL,
                                                     a.iss_cd,
                                                     'GICLS201',
                                                     UPPER (p_user_id)
                                                    ),
                             1, a.iss_cd,
                             0, ''
                            )
                    )
         AND check_user_per_iss_cd2 (a.line_cd,
                                     a.iss_cd,
                                     'GICLS201',
                                     UPPER (p_user_id)
                                    ) = 1
         AND b.rec_type_cd = NVL (p_rec_type_cd, b.rec_type_cd)
         AND (   EXISTS (
                    SELECT *
                      FROM gicl_intm_itmperil e
                     WHERE e.claim_id = a.claim_id
                       AND e.intm_no = NVL (p_intm_no, e.intm_no))
              OR (a.pol_iss_cd = 'RI' AND p_intm_no IS NULL)
             ))
  LOOP
     --get assured name
     FOR a IN (SELECT assd_name
                 FROM giis_assured
                WHERE assd_no = rec.assd_no)
     LOOP
        v_giclr201.assured := a.assd_name;
     END LOOP;

     --select intermediary number and name from giis_intermediary based on the intm_no from gicl_intm_itmperil
     FOR intm IN
        (SELECT DISTINCT f.intm_no, f.intm_name
                    FROM gicl_intm_itmperil e, giis_intermediary f
                   WHERE e.intm_no = f.intm_no
                     AND e.claim_id = rec.claim_id
                     AND e.intm_no = NVL (p_intm_no, e.intm_no))
                 --return all intermediary if p_intm_no parameter is null.
     LOOP
        v_intm_temp := '#' || intm.intm_no || '#';

        --check if intm_no does not yet exist before storing to avoid duplicate intermediary
        IF NVL (INSTR (v_intm_no, v_intm_temp), 0) = 0
        THEN
           IF v_intm_no IS NULL
           THEN
              v_intm_no := v_intm_temp;
              v_intm_name := intm.intm_name;
           ELSE
              v_intm_no := v_intm_no || ',' || v_intm_temp;
              v_intm_name := v_intm_name || CHR (10) || intm.intm_name;
           END IF;
        END IF;
     END LOOP;

     v_giclr201.intermediary := v_intm_name;
     v_intm_no := NULL;
     v_intm_name := NULL;
     v_giclr201.claim_number := rec.claim_number;
     v_giclr201.policy_number := rec.policy_number;
     v_giclr201.loss_date := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
     v_giclr201.file_date := TO_CHAR(rec.clm_file_date,'MM-DD-RRRR');
         
         
     --G_RECOVERY group
     v_prev_claim := rec.claim_id;                    --get previous claim

      --get lawyer
     FOR l IN (SELECT DECODE (payee_first_name,
                              NULL, payee_last_name,
                                 payee_last_name
                              || ', '
                              || payee_first_name
                              || ' '
                              || payee_middle_name
                             ) lawyer
                 FROM giis_payees
                WHERE payee_class_cd = rec.lawyer_class_cd
                  AND payee_no = rec.lawyer_cd)
     LOOP
        v_giclr201.lawyer := l.lawyer;
     END LOOP;

     --get recovery type
     FOR d IN (SELECT rec_type_desc
                 FROM giis_recovery_type
                WHERE rec_type_cd = rec.rec_type_cd)
     LOOP
        v_giclr201.recovery_type := d.rec_type_desc;
     END LOOP;

     --get recovery status
     IF rec.cancel_tag IS NULL
     THEN
        v_giclr201.recovery_status := 'IN PROGRESS';
     ELSIF rec.cancel_tag = giisp.v ('CLOSE_REC_STAT')
     THEN
        v_giclr201.recovery_status := 'CLOSED';
     ELSIF rec.cancel_tag = giisp.v ('CANCEL_REC_STAT')
     THEN
        v_giclr201.recovery_status := 'CANCELLED';
     ELSIF rec.cancel_tag = giisp.v ('WRITE_OFF_REC_STAT')
     THEN
        v_giclr201.recovery_status := 'WRITTEN OFF';
     END IF;

     v_giclr201.recovery_file_date := TO_CHAR(rec.rec_file_date,'MM-DD-RRRR');
     v_giclr201.recovery_number := rec.recovery_number;
     v_giclr201.recoverable_amt := TRIM(TO_CHAR(rec.recoverable_amt,'999,999,999,990.99'));

     --get recovered amount per recovery number
     FOR i IN
        (SELECT SUM (d.recovered_amt) recovered_per_recovery
           FROM gicl_claims a,
                gicl_clm_recovery b,
                gicl_recovery_payor c,
                gicl_recovery_payt d
          WHERE a.claim_id = b.claim_id
            AND b.claim_id = c.claim_id(+)
            AND b.recovery_id = c.recovery_id(+)
            AND c.claim_id = d.claim_id(+)
            AND c.recovery_id = d.recovery_id(+)
            AND c.payor_class_cd = d.payor_class_cd(+)
            AND c.payor_cd = d.payor_cd(+)
            AND NVL (d.cancel_tag, 'N') = 'N'
            AND DECODE (p_date_sw,
                        1, TRUNC (a.loss_date),
                        2, TRUNC (a.clm_file_date),
                        3, TRUNC (d.tran_date),
                        4, TRUNC (b.rec_file_date)
                       ) BETWEEN (p_from_date) AND (p_to_date)
            AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS201') =
                                                                         1
            AND b.rec_type_cd = NVL (p_rec_type_cd, b.rec_type_cd)
            AND (   EXISTS (
                       SELECT *
                         FROM gicl_intm_itmperil e
                        WHERE e.claim_id = a.claim_id
                          AND e.intm_no = NVL (p_intm_no, e.intm_no))
                 OR (a.pol_iss_cd = 'RI' AND p_intm_no IS NULL)
                )
            AND a.claim_id = rec.claim_id
            AND d.recovery_id = rec.recovery_id)
     LOOP
        v_recovered_per_recovery := i.recovered_per_recovery;
        v_giclr201.recovered_amt := TRIM(TO_CHAR(v_recovered_per_recovery,'999,999,999,990.99'));
     END LOOP;

     --G_PAYOR group
     v_prev_recovery_id := rec.recovery_id;

     --get payor
     FOR p IN (SELECT    payee_last_name
                      || DECODE (payee_first_name,
                                 NULL, NULL,
                                 ', ' || payee_first_name
                                )
                      || DECODE (payee_middle_name,
                                 NULL, NULL,
                                    ' '
                                 || SUBSTR (payee_middle_name, 1, 1)
                                 || '.'
                                ) payor
                 FROM giis_payees
                WHERE payee_class_cd = rec.payor_class_cd
                  AND payee_no = rec.payor_cd)
     LOOP
        v_giclr201.payee := p.payor;
     END LOOP;

     --get recovered amount per payor
     FOR i IN
        (SELECT SUM (d.recovered_amt) recovered_per_payor
           FROM gicl_claims a,
                gicl_clm_recovery b,
                gicl_recovery_payor c,
                gicl_recovery_payt d
          WHERE a.claim_id = b.claim_id
            AND b.claim_id = c.claim_id(+)
            AND b.recovery_id = c.recovery_id(+)
            AND c.claim_id = d.claim_id(+)
            AND c.recovery_id = d.recovery_id(+)
            AND c.payor_class_cd = d.payor_class_cd(+)
            AND c.payor_cd = d.payor_cd(+)
            AND NVL (d.cancel_tag, 'N') = 'N'
            AND DECODE (p_date_sw,
                        1, TRUNC (a.loss_date),
                        2, TRUNC (a.clm_file_date),
                        3, TRUNC (d.tran_date),
                        4, TRUNC (b.rec_file_date)
                       ) BETWEEN (p_from_date) AND (p_to_date)
            AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS201') =
                                                                         1
            AND b.rec_type_cd = NVL (p_rec_type_cd, b.rec_type_cd)
            AND (   EXISTS (
                       SELECT *
                         FROM gicl_intm_itmperil e
                        WHERE e.claim_id = a.claim_id
                          AND e.intm_no = NVL (p_intm_no, e.intm_no))
                 OR (a.pol_iss_cd = 'RI' AND p_intm_no IS NULL)
                )
            AND a.claim_id = rec.claim_id
            AND d.recovery_id = rec.recovery_id
            AND d.payor_class_cd = rec.payor_class_cd
            AND d.payor_cd = rec.payor_cd)
     LOOP
        v_giclr201.recovered_amt_per_payor := TRIM(TO_CHAR(i.recovered_per_payor,'999,999,999,990.99'));
     END LOOP;

     --G_PAYMENT group
     v_prev_payor := rec.payor_class_cd || '-' || rec.payor_cd;

     v_giclr201.recovery_date := TO_CHAR(rec.tran_date,'MM-DD-RRRR');

     --get reference number
     FOR t IN (SELECT tran_class, tran_class_no
                 FROM giac_acctrans
                WHERE tran_id = rec.acct_tran_id)
     LOOP
        IF t.tran_class = 'COL'
        THEN
           FOR c IN (SELECT or_pref_suf, or_no
                       FROM giac_order_of_payts
                      WHERE gacc_tran_id = rec.acct_tran_id)
           LOOP
              IF c.or_no IS NOT NULL
              THEN
                 v_giclr201.reference_no :=
                       c.or_pref_suf
                    || '-'
                    || LTRIM (TO_CHAR (c.or_no, '0999999999'));
              ELSE
                 v_giclr201.reference_no := NULL;
              END IF;
           END LOOP;
        ELSIF t.tran_class = 'DV'
        THEN
           FOR r IN (SELECT document_cd, branch_cd, line_cd, doc_year,
                            doc_mm, doc_seq_no
                       FROM giac_payt_requests a,
                            giac_payt_requests_dtl b
                      WHERE a.ref_id = b.gprq_ref_id
                        AND b.tran_id = rec.acct_tran_id)
           LOOP
              v_giclr201.reference_no :=
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
                         WHERE gacc_tran_id = rec.acct_tran_id)
              LOOP
                 IF d.dv_no IS NOT NULL
                 THEN
                    v_giclr201.reference_no :=
                          d.dv_pref
                       || '-'
                       || LTRIM (TO_CHAR (d.dv_no, '0999999999'));
                 ELSE
                    v_giclr201.reference_no := NULL;
                 END IF;
              END LOOP;
           END LOOP;
        ELSIF t.tran_class = 'JV'
        THEN
           IF t.tran_class_no IS NOT NULL
           THEN
              v_giclr201.reference_no :=
                    t.tran_class
                 || '-'
                 || LTRIM (TO_CHAR (t.tran_class_no, '0999999999'));
           ELSE
              v_giclr201.reference_no := NULL;
           END IF;
        END IF;
     END LOOP;

     PIPE ROW (v_giclr201);
  END LOOP;

  RETURN;
END;
--END SR5397 hdrtagudin 04052016 CSV printing
FUNCTION CSV_GICLR202(p_date DATE,
                      p_line_cd gicl_claims.line_cd%TYPE,
                      p_iss_cd gicl_claims.iss_cd%TYPE, 
                      p_rec_type_cd gicl_clm_recovery.rec_type_cd%TYPE)
                      RETURN giclr202_type PIPELINED
IS 
    v_giclr202                  giclr202_rec_type;
    v_prev_claim                gicl_claims.claim_id%TYPE; --hold previous claim id.
    v_total_recoverable_amt     gicl_clm_recovery.recoverable_amt%TYPE := 0; --total recoverable amount per claim.
    v_grand_recoverable_amt     gicl_clm_recovery.recoverable_amt%TYPE := 0; --grand total recoverable amount.
    v_label                     VARCHAR2(50) := 'Totals per Claim :';
BEGIN
  FOR rec IN (SELECT   a.claim_id, b.recovery_id, a.line_cd, a.iss_cd,
                        a.line_cd
                     || '-'
                     || a.subline_cd
                     || '-'
                     || a.iss_cd
                     || '-'
                     || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_number,
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
                     || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_number,
                        b.line_cd
                     || '-'
                     || b.iss_cd
                     || '-'
                     || rec_year
                     || '-'
                     || LPAD (TO_CHAR (rec_seq_no), 3, '0') recovery_number,
                     a.assd_no, a.dsp_loss_date, a.clm_file_date, b.rec_type_cd,
                     b.cancel_tag, b.rec_file_date,
                     NVL (b.recoverable_amt, 0) recoverable_amt,
                     NVL (b.recovered_amt, 0) recovered_amt,
                     NVL (b.recoverable_amt, 0) - NVL (b.recovered_amt, 0) rec_sum,
                     b.lawyer_class_cd, b.lawyer_cd
                FROM gicl_claims a, gicl_clm_recovery b
               WHERE a.claim_id = b.claim_id
                 AND TRUNC (b.rec_file_date) <= p_date
                 AND a.line_cd =
                        NVL (p_line_cd,
                             DECODE (check_user_per_iss_cd (a.line_cd, NULL, 'GICLS201'),
                                     1, a.line_cd,
                                     0, ''
                                    )
                            )
                 AND a.iss_cd =
                        NVL (p_iss_cd,
                             DECODE (check_user_per_iss_cd (NULL, a.iss_cd, 'GICLS201'),
                                     1, a.iss_cd,
                                     0, ''
                                    )
                            )
                 AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS201') = 1
                 AND NVL (b.cancel_tag, 'IP') NOT IN ('CC', 'CD', 'WO')
                 AND (NVL (b.recoverable_amt, 0) - NVL (b.recovered_amt, 0)) != 0
                 AND (  (NVL (b.recoverable_amt, 0) - NVL (b.recovered_amt, 0))
                      + ABS ((NVL (b.recoverable_amt, 0) - NVL (b.recovered_amt, 0)))
                     ) != 0
                 AND b.rec_type_cd = NVL (p_rec_type_cd, b.rec_type_cd)
            ORDER BY    a.line_cd
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
                     || LPAD (TO_CHAR (rec_seq_no), 3, '0'))
  LOOP
    --print total amount per claim
    IF v_prev_claim IS NOT NULL AND v_prev_claim != rec.claim_id THEN
      v_giclr202.claim_number := NULL;
      v_giclr202.policy_number := NULL;
      v_giclr202.assd_name := NULL;
      v_giclr202.loss_date := NULL;
      v_giclr202.file_date := NULL;
      v_giclr202.recovery_number := NULL;
      v_giclr202.rec_type := NULL;
      v_giclr202.rec_status := NULL;
      v_giclr202.lawyer := v_label;
      v_giclr202.recoverable_amt := v_total_recoverable_amt;
     PIPE ROW(v_giclr202); 
      v_grand_recoverable_amt := v_grand_recoverable_amt + v_total_recoverable_amt; --get grand total recoverable amount.
      v_total_recoverable_amt := 0;
      v_giclr202.lawyer := NULL;
    END IF;
    
    v_giclr202.claim_number := rec.claim_number;
    v_giclr202.policy_number := rec.policy_number;
     
    --get assured
    FOR a IN (SELECT assd_name
              FROM giis_assured
             WHERE assd_no = rec.assd_no)
    LOOP
       v_giclr202.assd_name := a.assd_name;
    END LOOP;
    
    v_giclr202.loss_date := rec.dsp_loss_date;
    v_giclr202.file_date := rec.clm_file_date;  
    
    --G_RECOVERY group 
      IF v_prev_claim IS NULL OR v_prev_claim != rec.claim_id THEN
        v_prev_claim := rec.claim_id;
      ELSE
        v_giclr202.claim_number := NULL;
        v_giclr202.policy_number := NULL;
        v_giclr202.assd_name := NULL;
        v_giclr202.loss_date := NULL;
        v_giclr202.file_date := NULL;  
      END IF;   
        v_giclr202.recovery_number := rec.recovery_number; 
        
        --get recovery type
        FOR d IN
        (SELECT rec_type_desc
           FROM giis_recovery_type
          WHERE rec_type_cd = rec.rec_type_cd)
        LOOP
            v_giclr202.rec_type := d.rec_type_desc;
        END LOOP;
        
        --get recovery status
        IF rec.cancel_tag IS NULL THEN
            v_giclr202.rec_status := 'IN PROGRESS';
        ELSIF rec.cancel_tag = GIISP.V('CLOSE_REC_STAT') THEN
            v_giclr202.rec_status := 'CLOSED';
        ELSIF rec.cancel_tag = GIISP.V('CANCEL_REC_STAT') THEN
            v_giclr202.rec_status := 'CANCELLED';
        ELSIF rec.cancel_tag = GIISP.V('WRITE_OFF_REC_STAT') THEN
            v_giclr202.rec_status := 'WRITTEN OFF';
        END IF;  
        
        --get lawyer
        FOR l IN (SELECT DECODE(payee_first_name, NULL, payee_last_name,
                              payee_last_name||', '||payee_first_name||' '||payee_middle_name) lawyer
                  FROM giis_payees
                 WHERE payee_class_cd = rec.lawyer_class_cd
                   AND payee_no = rec.lawyer_cd)
        LOOP
            v_giclr202.lawyer := l.lawyer;
        END LOOP;
        
        v_giclr202.recoverable_amt := rec.rec_sum;
        v_total_recoverable_amt := v_total_recoverable_amt + rec.rec_sum;
        PIPE ROW(v_giclr202); 
  END LOOP;
  
  IF v_prev_claim IS NOT NULL THEN
      --print total of last claim
      v_giclr202.claim_number := NULL;
      v_giclr202.policy_number := NULL;
      v_giclr202.assd_name := NULL;
      v_giclr202.loss_date := NULL;
      v_giclr202.file_date := NULL;
      v_giclr202.recovery_number := NULL;
      v_giclr202.rec_type := NULL;
      v_giclr202.rec_status := NULL;
      v_giclr202.lawyer := v_label;
      v_giclr202.recoverable_amt := v_total_recoverable_amt;
     PIPE ROW(v_giclr202); 
     
      v_grand_recoverable_amt := v_grand_recoverable_amt + v_total_recoverable_amt; --get grand total recoverable amount.
      
      --print grand total
      v_giclr202.claim_number := NULL;
      v_giclr202.policy_number := NULL;
      v_giclr202.assd_name := NULL;
      v_giclr202.loss_date := NULL;
      v_giclr202.file_date := NULL;
      v_giclr202.recovery_number := NULL;
      v_giclr202.rec_type := NULL;
      v_giclr202.rec_status := NULL;
      v_giclr202.lawyer := 'Grand Totals';
      v_giclr202.recoverable_amt := v_grand_recoverable_amt;
     PIPE ROW(v_giclr202); 
   END IF;
   RETURN;
END;

END;
/


