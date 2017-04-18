CREATE OR REPLACE PACKAGE BODY CPI.GICLR266A_PKG
AS
/******************************************************************************
   NAME:       Recovery Listing Per Intermediary
   PURPOSE:    Recovery Listing Per Intermediary

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0         
   1.1        12/09/2013  Jeff Dojello     outer joined gicl_recovery_payor
******************************************************************************/
   FUNCTION get_giclr266a_report (
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2,
      p_intm_no     NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;      
   BEGIN
      FOR i IN
         (SELECT   *
              FROM (SELECT DISTINCT a.claim_id, d.recovery_id,
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
                                                                policy_number,
                                    a.dsp_loss_date, a.assured_name,
                                       LTRIM (TO_CHAR (b.intm_no, '0009')
                                             )
                                    || '-'
                                    || b.intm_name intm,
                                       d.line_cd
                                    || '-'
                                    || d.iss_cd
                                    || '-'
                                    || SUBSTR (TO_CHAR (d.rec_year, '0009'),
                                               4)
                                    || '-'
                                    || TRIM (TO_CHAR (d.rec_seq_no, '0000009'))
                                                              recovery_number,
                                    d.cancel_tag, d.rec_type_cd,
                                    d.recoverable_amt, d.recovered_amt,
                                    d.lawyer_cd, e.payor_cd, e.payor_class_cd,
                                    e.recovered_amt payor_recovered_amt
                               FROM giis_intermediary b,
                                    gicl_intm_itmperil c,
                                    gicl_claims a,
                                    gicl_clm_recovery d,
                                    gicl_recovery_payor e
                              WHERE b.intm_no = p_intm_no
                                AND c.intm_no = b.intm_no
                                AND a.claim_id = c.claim_id
                                AND a.claim_id = d.claim_id
                                AND d.claim_id = e.claim_id(+)  --outer join added by jeffdojello 12.06.2013
                                AND d.recovery_id = e.recovery_id(+) --outer join added by jeffdojello 12.06.2013
                                AND check_user_per_line2 (a.line_cd,
                                                          a.iss_cd,
                                                          p_module_id,
                                                          p_user_id
                                                         ) = 1 AND (   (    (DECODE (p_search_by_opt,
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
                          ))
          ORDER BY get_clm_no (claim_id), policy_number)
      LOOP
         v_list.intm := i.intm;
         v_list.claim_number := get_clm_no (i.claim_id);
         v_list.policy_number := i.policy_number;
         v_list.claim_id := i.claim_id;
         v_list.recovery_id := i.recovery_id;
         v_list.assured_name := i.assured_name;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.recovery_number := i.recovery_number;
         v_list.recoverable_amt := i.recoverable_amt;
         v_list.recovered_amt := i.recovered_amt;

         BEGIN
            SELECT rec_type_desc
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
         
         IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL THEN
            v_list.date_as_of := TRIM(TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
         
         IF v_list.date_from IS NULL AND p_date_from IS NOT NULL THEN
            v_list.date_from := TRIM(TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to := TRIM(TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
         
         IF v_list.company_name IS NULL
         THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;

         BEGIN --Dren Niebres SR-5370 05.10.2016 - Start
            FOR x IN (SELECT payor_cd, payor_class_cd, recovered_amt
                      FROM gicl_recovery_payor
                     WHERE claim_id = v_list.claim_id AND recovery_id = v_list.recovery_id)
            LOOP
             v_list.payor_recovered_amt1 := x.recovered_amt;

                BEGIN
                    SELECT    payee_last_name
                           || DECODE (payee_first_name, NULL, '', ', ')
                           || payee_first_name
                           || DECODE (payee_middle_name, NULL, '', ' ')
                           || payee_middle_name pname
                      INTO v_list.payor1
                      FROM giis_payees
                     WHERE payee_no = x.payor_cd AND payee_class_cd = x.payor_class_cd;
                EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                          v_list.payor1 := NULL;
                END;
            END LOOP;
         END get_payor; --Dren Niebres SR-5370 05.10.2016 - End

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr266a_report;

   /*FUNCTION get_payor (p_claim_id NUMBER, p_recovery_id NUMBER)
      RETURN payor_tab PIPELINED
   IS
      v_list   payor_type;
   BEGIN
      FOR i IN (SELECT payor_cd, payor_class_cd, recovered_amt
                  FROM gicl_recovery_payor
                 WHERE claim_id = p_claim_id AND recovery_id = p_recovery_id)
      LOOP
         v_list.payor_recovered_amt := i.recovered_amt;

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
   END get_payor;*/ --Dren Niebres SR-5370 05.10.2016
END;
/


