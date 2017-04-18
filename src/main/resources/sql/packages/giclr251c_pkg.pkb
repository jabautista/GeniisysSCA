CREATE OR REPLACE PACKAGE BODY CPI.giclr251c_pkg
AS
   FUNCTION get_giclr251c_report (
      p_free_text       VARCHAR2,
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr251c_report_tab PIPELINED
   IS
      v_list   giclr251c_report_type;
   BEGIN
      FOR i IN
         (SELECT   *
              FROM (SELECT DISTINCT 'ASSURED - ' || a.assured_name free_text,
                                    get_clm_no (a.claim_id) claim_no,
                                    a.claim_id,
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
                                    || LTRIM (TO_CHAR (a.renew_no, '09'))
                                                                       pol_no
                               FROM gicl_claims a,
                                    gicl_clm_recovery b,
                                    gicl_recovery_payor c
                              WHERE UPPER ('ASSURED - ' || a.assured_name) LIKE
                                                           UPPER ('%' ||p_free_text || '%')
                                AND a.claim_id = b.claim_id
                                AND b.claim_id = c.claim_id
                                AND check_user_per_line2 (a.line_cd,
                                                          a.iss_cd,
                                                          p_module_id,
                                                          p_user_id
                                                         ) = 1
                                AND (   (    (DECODE (p_search_by_opt,
                                                      'lossDate', TRUNC(dsp_loss_date),
                                                      'fileDate', TRUNC(clm_file_date)
                                                     ) >=
                                                 TO_DATE (p_date_from,
                                                          'MM-DD-YYYY'
                                                         )
                                             )
                                         AND (DECODE (p_search_by_opt,
                                                      'lossDate', TRUNC(dsp_loss_date),
                                                      'fileDate', TRUNC(clm_file_date)
                                                     ) <=
                                                 TO_DATE (p_date_to,
                                                          'MM-DD-YYYY'
                                                         )
                                             )
                                        )
                                     OR (DECODE (p_search_by_opt,
                                                 'lossDate', TRUNC(dsp_loss_date),
                                                 'fileDate', TRUNC(clm_file_date)
                                                ) <=
                                            TO_DATE (p_date_as_of,
                                                     'MM-DD-YYYY'
                                                    )
                                        )
                                    )
                    UNION
                    SELECT 'ITEM    - ' || e.item_title free_text,
                           get_clm_no (a.claim_id) claim_no, a.claim_id,
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
                           || LTRIM (TO_CHAR (a.renew_no, '09')) pol_no
                      FROM gicl_clm_item e,
                           gicl_claims a,
                           gicl_clm_recovery b,
                           gicl_recovery_payor c
                     WHERE a.claim_id = e.claim_id
                       AND a.claim_id = b.claim_id
                       AND b.claim_id = c.claim_id
                       AND b.recovery_id = c.recovery_id
                       AND UPPER ('ITEM    - ' || e.item_title) LIKE
                                                           UPPER ('%' || p_free_text || '%')
                       AND check_user_per_line2 (a.line_cd,
                                                 a.iss_cd,
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1
                       AND (   (    (DECODE (p_search_by_opt,
                                             'lossDate', TRUNC(dsp_loss_date),
                                             'fileDate', TRUNC(clm_file_date)
                                            ) >=
                                           TO_DATE (p_date_from, 'MM-DD-YYYY')
                                    )
                                AND (DECODE (p_search_by_opt,
                                             'lossDate', TRUNC(dsp_loss_date),
                                             'fileDate', TRUNC(clm_file_date)
                                            ) <=
                                             TO_DATE (p_date_to, 'MM-DD-YYYY')
                                    )
                               )
                            OR (DECODE (p_search_by_opt,
                                        'lossDate', TRUNC(dsp_loss_date),
                                        'fileDate', TRUNC(clm_file_date)
                                       ) <=
                                          TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                               )
                           )
                    UNION
                    SELECT 'GROUPED - ' || f.grouped_item_title free_text,
                           get_clm_no (a.claim_id) claim_no, a.claim_id,
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
                           || LTRIM (TO_CHAR (a.renew_no, '09')) pol_no
                      FROM gicl_claims a,
                           gicl_clm_item e,
                           gicl_accident_dtl f,
                           gicl_clm_recovery b,
                           gicl_recovery_payor c
                     WHERE f.claim_id = e.claim_id
                       AND a.claim_id = b.claim_id
                       AND b.claim_id = c.claim_id
                       AND b.recovery_id = c.recovery_id
                       AND UPPER ('GROUPED ITEM - ' || f.grouped_item_title) LIKE
                                                           UPPER ('%' || p_free_text || '%')
                       AND check_user_per_line2 (a.line_cd,
                                                 a.iss_cd,
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1
                       AND (   (    (DECODE (p_search_by_opt,
                                             'lossDate', TRUNC(dsp_loss_date),
                                             'fileDate', TRUNC(clm_file_date)
                                            ) >=
                                           TO_DATE (p_date_from, 'MM-DD-YYYY')
                                    )
                                AND (DECODE (p_search_by_opt,
                                             'lossDate', TRUNC(dsp_loss_date),
                                             'fileDate', TRUNC(clm_file_date)
                                            ) <=
                                             TO_DATE (p_date_to, 'MM-DD-YYYY')
                                    )
                               )
                            OR (DECODE (p_search_by_opt,
                                        'lossDate', TRUNC(dsp_loss_date),
                                        'fileDate', TRUNC(clm_file_date)
                                       ) <=
                                          TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                               )
                           )
                       AND a.claim_id = e.claim_id
                       AND f.item_no = e.item_no
                       AND f.grouped_item_no = e.grouped_item_no)
          )
      LOOP
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.pol_no;
         v_list.claim_id := i.claim_id;

         IF v_list.company_name IS NULL
         THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;

         IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL
         THEN
            v_list.date_as_of :=
                  TRIM (TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'),
                                 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.date_from IS NULL AND p_date_from IS NOT NULL
         THEN
            v_list.date_from :=
                  TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to :=
                  TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month'))
               || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr251c_report;

   FUNCTION get_giclr251c_details (
      p_free_text   VARCHAR2,
      p_claim_id    NUMBER,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giclr251c_details_tab PIPELINED
   IS
      v_list   giclr251c_details_type;
   BEGIN
      FOR i IN (SELECT 'ASSURED - ' || a.assured_name free_text,
                       a.dsp_loss_date, b.recovery_id,
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
                 WHERE a.claim_id = b.claim_id
                   AND b.claim_id = c.claim_id
                   AND b.recovery_id = c.recovery_id
                   AND UPPER ('ASSURED - ' || a.assured_name) LIKE
                                                           UPPER ('%' || p_free_text || '%')
                   AND a.claim_id = p_claim_id
                   AND check_user_per_line2 (a.line_cd,
                                             a.iss_cd,
                                             p_module_id,
                                             p_user_id
                                            ) = 1
                UNION
                SELECT 'ITEM    - ' || e.item_title free_text,
                       a.dsp_loss_date, b.recovery_id,
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
                  FROM gicl_clm_item e,
                       gicl_claims a,
                       gicl_clm_recovery b,
                       gicl_recovery_payor c
                 WHERE a.claim_id = e.claim_id
                   AND a.claim_id = b.claim_id
                   AND b.claim_id = c.claim_id
                   AND b.recovery_id = c.recovery_id
                   AND UPPER ('ITEM    - ' || e.item_title) LIKE
                                                           UPPER ('%' || p_free_text || '%')
                   AND a.claim_id = p_claim_id
                   AND check_user_per_line2 (a.line_cd,
                                             a.iss_cd,
                                             p_module_id,
                                             p_user_id
                                            ) = 1
                UNION
                SELECT 'GROUPED - ' || f.grouped_item_title free_text,
                       a.dsp_loss_date, b.recovery_id,
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
                       gicl_clm_item e,
                       gicl_accident_dtl f,
                       gicl_clm_recovery b,
                       gicl_recovery_payor c
                 WHERE f.claim_id = e.claim_id
                   AND a.claim_id = b.claim_id
                   AND b.claim_id = c.claim_id
                   AND b.recovery_id = c.recovery_id
                   AND UPPER ('GROUPED ITEM - ' || f.grouped_item_title) LIKE
                                                           UPPER ('%' || p_free_text || '%')
                   AND a.claim_id = p_claim_id
                   AND a.claim_id = e.claim_id
                   AND f.item_no = e.item_no
                   AND f.grouped_item_no = e.grouped_item_no
                   AND check_user_per_line2 (a.line_cd,
                                             a.iss_cd,
                                             p_module_id,
                                             p_user_id
                                            ) = 1)
      LOOP
         v_list.free_text := i.free_text;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.recovery_id := i.recovery_id;
         v_list.recovery_no := i.rec_no;
         v_list.recoverable_amt := i.recoverable_amt;
         v_list.recovered_amt := i.recovered_amt;
         v_list.lawyer_cd := i.lawyer_cd;

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

         BEGIN
            IF i.cancel_tag = 'CD'
            THEN
               v_list.recovery_status := 'CLOSED';
            ELSIF i.cancel_tag = 'CC'
            THEN
               v_list.recovery_status := 'CANCELLED';
            ELSIF i.cancel_tag = 'WO'
            THEN
               v_list.recovery_status := 'WRITTEN OFF';
            ELSE
               v_list.recovery_status := 'IN PROGRESS';
            END IF;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr251c_details;

   FUNCTION get_giclr251c_payor_details (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_recovery_id   gicl_clm_recovery.recovery_id%TYPE
   )
      RETURN giclr251c_payor_details_tab PIPELINED
   IS
      v_list   giclr251c_payor_details_type;
   BEGIN
      FOR i IN (SELECT   payor_cd, payor_class_cd, recovered_amt
                    FROM gicl_recovery_payor
                   WHERE claim_id = p_claim_id
                         AND recovery_id = p_recovery_id
                ORDER BY payor_cd)
      LOOP
         v_list.recovered_amt := i.recovered_amt;

         BEGIN
            SELECT    payee_last_name
                   || DECODE (payee_first_name,
                              NULL, NULL,
                              ', ' || payee_first_name
                             )
                   || DECODE (payee_middle_name,
                              NULL, NULL,
                              ' ' || SUBSTR (payee_middle_name, 1, 1) || '.'
                             ) pname
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
   END get_giclr251c_payor_details;
END;
/


