CREATE OR REPLACE PACKAGE BODY CPI.giclr251a_pkg
AS
   FUNCTION get_giclr251a_report (
      p_assd_no         NUMBER,
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr251a_report_tab PIPELINED
   IS
      v_list   giclr251a_report_type;
   BEGIN
      FOR i IN (SELECT a.claim_id,
                          a.line_cd
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
                       c.payor_class_cd, c.recovery_id
                  FROM gicl_claims a,
                       gicl_clm_recovery b,
                       gicl_recovery_payor c
                 WHERE a.assd_no = p_assd_no
                   AND a.claim_id = b.claim_id
                   AND b.claim_id = c.claim_id
                   AND b.recovery_id = c.recovery_id
                   AND check_user_per_line2 (a.line_cd,
                                             a.iss_cd,
                                             p_module_id,
                                             p_user_id
                                            ) = 1
                   AND (   (    (DECODE (p_search_by_opt,
                                         'lossDate', TRUNC(a.dsp_loss_date),
                                         'fileDate', TRUNC(a.clm_file_date)
                                        ) >=
                                           TO_DATE (p_date_from, 'MM-DD-YYYY')
                                )
                            AND (DECODE (p_search_by_opt,
                                         'lossDate', TRUNC(a.dsp_loss_date),
                                         'fileDate', TRUNC(a.clm_file_date)
                                        ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                                )
                           )
                        OR (DECODE (p_search_by_opt,
                                    'lossDate', TRUNC(a.dsp_loss_date),
                                    'fileDate', TRUNC(a.clm_file_date)
                                   ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                           )
                       ))
      LOOP
         v_list.claim_number := i.claim_no;
         v_list.policy_number := i.pol_no;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.assured_name := i.assured_name;
         v_list.recovery_number := i.rec_no;
         v_list.recoverable_amt := NVL(i.recoverable_amt, 0);
         v_list.recovered_amt := NVL(i.recovered_amt, 0);
         v_list.claim_id := i.claim_id;
         v_list.recovery_id := i.recovery_id;
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         v_list.date_as_of :=
               TRIM (TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'), 'Month'))
            || TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
         v_list.date_from :=
               TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month'))
            || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
         v_list.date_to :=
               TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month'))
            || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');

         BEGIN
            SELECT rec_type_desc type_desc
              INTO v_list.recovery_type
              FROM giis_recovery_type
             WHERE rec_type_cd = i.rec_type_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.recovery_type := NULL;
         END;

         BEGIN
            IF i.cancel_tag = 'CD'
            THEN
               v_list.recovery_status := 'Closed';
            ELSIF i.cancel_tag = 'CC'
            THEN
               v_list.recovery_status := 'Cancelled';
            ELSIF i.cancel_tag = 'WO'
            THEN
               v_list.recovery_status := 'Written Off';
            ELSE
               v_list.recovery_status := 'In Progress';
            END IF;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr251a_report;

   FUNCTION get_giclr251a_payor_details (
      p_claim_id      NUMBER,
      p_recovery_id   NUMBER
   )
      RETURN giclr251a_payor_details_tab PIPELINED
   IS
      v_list   giclr251a_payor_details_type;
   BEGIN
      FOR i IN (SELECT   payor_cd, payor_class_cd, recovered_amt
                    FROM gicl_recovery_payor
                   WHERE recovery_id = p_recovery_id
                         AND claim_id = p_claim_id
                ORDER BY 1, 2, 3)
      LOOP
         v_list.recovered_amt := NVL(i.recovered_amt, 0);

         BEGIN
            SELECT    payee_last_name
                   || DECODE (payee_first_name, NULL, '', ', ')
                   || payee_first_name
                   || DECODE (payee_middle_name, NULL, '', ' ')
                   || payee_middle_name pname
              INTO v_list.payor
              FROM giis_payees
             WHERE payee_no = i.payor_cd AND payee_class_cd = i.payor_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.payor := NULL;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr251a_payor_details;
END;
/


