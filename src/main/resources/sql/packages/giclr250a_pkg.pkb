CREATE OR REPLACE PACKAGE BODY CPI.giclr250a_pkg
AS
   FUNCTION get_giclr250a_report (
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_pol_iss_cd      VARCHAR2,
      p_issue_yy        NUMBER,
      p_pol_seq_no      NUMBER,
      p_renew_no        NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr250a_tab PIPELINED
   IS
      v_list   giclr250a_type;
   BEGIN
      FOR i IN (SELECT    a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || TRIM (TO_CHAR (a.clm_yy, '09'))
                       || '-'
                       || TRIM (TO_CHAR (a.clm_seq_no, '0000009')) claim_no,
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.pol_iss_cd
                       || '-'
                       || TRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || TRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09')) pol_no,
                       a.dsp_loss_date, a.assured_name,
                          b.line_cd
                       || '-'
                       || b.iss_cd
                       || '-'
                       || SUBSTR (TO_CHAR (b.rec_year, '0009'), 4)
                       || '-'
                       || TRIM (TO_CHAR (b.rec_seq_no, '0000009')) rec_no,
                       b.cancel_tag, b.rec_type_cd, b.recoverable_amt,
                       b.recovered_amt, b.lawyer_cd, c.payor_cd,
                       c.payor_class_cd, c.recovered_amt payr_rec_amt
                  FROM gicl_claims a,
                       gicl_clm_recovery b,
                       gicl_recovery_payor c
                 WHERE a.line_cd = UPPER (p_line_cd)
                   AND a.subline_cd = UPPER (p_subline_cd)
                   AND a.pol_iss_cd = UPPER (p_pol_iss_cd)
                   AND a.issue_yy = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no = p_renew_no
                   AND a.claim_id = b.claim_id
                   AND b.claim_id = c.claim_id
                   AND b.recovery_id = c.recovery_id
                   AND check_user_per_line2 (a.line_cd,a.iss_cd,p_module_id,p_user_id) = 1
                   AND (((DECODE(p_search_by_opt, 'lossDate', dsp_loss_date, 'fileDate', clm_file_date) >= TO_DATE (p_date_from, 'MM-DD-YYYY'))
                     AND (DECODE (p_search_by_opt, 'lossDate', dsp_loss_date, 'fileDate', clm_file_date ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')))
                      OR (DECODE (p_search_by_opt, 'lossDate', dsp_loss_date, 'fileDate', clm_file_date ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')))
                )
      LOOP
         v_list.policy_number := i.pol_no;
         v_list.assured_name := i.assured_name;
         v_list.claim_number := i.claim_no;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.recovery_number := i.rec_no;
         v_list.recoverable_amt := i.recoverable_amt;
         v_list.recovered_amt := i.recovered_amt;
         v_list.payor_rec_amt := i.payr_rec_amt;
         
         IF i.cancel_tag = 'CD' THEN
            v_list.stat_desc := 'Closed';
         ELSIF i.cancel_tag = 'CC' THEN
            v_list.stat_desc := 'Cancelled';
         ELSIF i.cancel_tag = 'WO' THEN
            v_list.stat_desc := 'Written Off';
         ELSE
            v_list.stat_desc := 'In Progress';
         END IF;
         
         BEGIN
            SELECT rec_type_desc
              INTO v_list.recovery_type
              FROM giis_recovery_type
             WHERE rec_type_cd = i.rec_type_cd;
         EXCEPTION  WHEN NO_DATA_FOUND THEN
            v_list.recovery_type := NULL;    
         END;
         
         BEGIN
            SELECT payee_last_name||DECODE(payee_first_name,NULL,'',', ')||
                   payee_first_name||DECODE(payee_middle_name,NULL,'',' ')||
                   payee_middle_name pname
              INTO v_list.payor     
              FROM giis_payees
             WHERE payee_no = i.payor_cd
               AND payee_class_cd = i.payor_class_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.payor := NULL;      
         END;
         
          IF v_list.company_name IS NULL
         THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;

         IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL
         THEN
            v_list.date_as_of := TRIM (TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'), 'Month')) || TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.date_from IS NULL AND p_date_from IS NOT NULL
         THEN
            v_list.date_from := TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')) || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to := TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month')) || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
         
         PIPE ROW (v_list);
      END LOOP RETURN;
   END get_giclr250a_report;
END;
/


