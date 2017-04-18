CREATE OR REPLACE PACKAGE BODY CPI.gicls269_pkg
AS
/*
**  Created by   : Windell Valle
**  Date Created : June 10, 2013
**  Description  : Populate GICLS269 - Recovery Status
*/
   FUNCTION get_recovery_status (
      p_line_cd         giis_line.line_cd%TYPE,
      p_iss_cd          giis_issource.iss_cd%TYPE,
      p_user_id         giis_users.user_id%TYPE,
      p_rec_stat_type   giis_clm_stat.clm_stat_type%TYPE,
      p_search_by       VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN recovery_status_tab PIPELINED
   IS
      v_list   recovery_status_type;
   BEGIN
      FOR i IN
         (SELECT   gcr.*, gc.assured_name, gc.dsp_loss_date, clm_file_date,
                   loss_cat_cd,
                   DECODE (gcr.cancel_tag,
                           'CD', 'Closed',
                           'CC', 'Cancelled',
                           'WO', 'Written Off',
                           'In Progress'
                          ) AS status,
                      gc.line_cd
                   || '-'
                   || gc.subline_cd
                   || '-'
                   || gc.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (gc.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (gc.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (gc.renew_no, '09')) policy_no
              FROM gicl_clm_recovery gcr, gicl_claims gc
             WHERE gcr.claim_id = gc.claim_id
               AND gcr.claim_id IN (
                      SELECT DISTINCT claim_id
                                 FROM gicl_claims
                                WHERE check_user_per_line2 (line_cd,
                                                            iss_cd,
                                                            'GICLS269',
                                                            p_user_id
                                                           ) = 1)
               AND NVL (gcr.cancel_tag, '1') =
                      DECODE (p_rec_stat_type,
                              'A', NVL (gcr.cancel_tag, '1'),
                              'P', '1',
                              p_rec_stat_type
                             )
               AND (   (    (DECODE (p_search_by,
                                     'lossDate', TRUNC (gc.dsp_loss_date),
                                     'claimFileDate', TRUNC (gc.clm_file_date)
                                    ) >= TO_DATE (p_date_from, 'MM-DD-YYYY')
                            )
                        AND (DECODE (p_search_by,
                                     'lossDate', TRUNC (gc.dsp_loss_date),
                                     'claimFileDate', TRUNC (gc.clm_file_date)
                                    ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                            )
                       )
                    OR (DECODE (p_search_by,
                                'lossDate', TRUNC (gc.dsp_loss_date),
                                'claimFileDate', TRUNC (gc.clm_file_date)
                               ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                       )
                   )
          ORDER BY gcr.line_cd, gcr.iss_cd, gcr.rec_year, gcr.rec_seq_no)
      LOOP
         v_list.recovery_id := i.recovery_id;
         v_list.claim_id := i.claim_id;
         v_list.recovery_no := get_recovery_no (i.recovery_id);
         v_list.claim_no := get_claim_number (i.claim_id);
         v_list.recovery_status := i.status;
         v_list.policy_no := i.policy_no;
         v_list.clm_file_date := i.clm_file_date;
         v_list.assured_name := i.assured_name;
         v_list.loss_date := i.dsp_loss_date;
         v_list.lawyer_cd := i.lawyer_cd;
         v_list.tp_item_desc := i.tp_item_desc;
         v_list.recoverable_amt := i.recoverable_amt;
         v_list.recovered_amt_r := i.recovered_amt;
         v_list.plate_no := i.plate_no;

         FOR cat IN (SELECT loss_cat_des
                       FROM giis_loss_ctgry
                      WHERE loss_cat_cd = i.loss_cat_cd
                        AND line_cd = i.line_cd)
         LOOP
            v_list.loss_category :=
                                   i.loss_cat_cd || ' - ' || cat.loss_cat_des;
            EXIT;
         END LOOP;

         FOR rec IN (SELECT    payee_last_name
                            || DECODE (payee_first_name, NULL, '', ', ')
                            || payee_first_name
                            || DECODE (payee_middle_name, NULL, '', ' ')
                            || payee_middle_name pname
                       FROM giis_payees
                      WHERE payee_no = i.lawyer_cd
                        AND payee_class_cd = i.lawyer_class_cd)
         LOOP
            v_list.lawyer := rec.pname;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_recovery_status;

   FUNCTION get_recovery_details (p_claim_id NUMBER, p_recovery_id NUMBER)
      RETURN recovery_detail_tab PIPELINED
   IS
      v_list   recovery_detail_type;
   BEGIN
      FOR i IN
         (SELECT *
            FROM gicl_recovery_payor
           WHERE claim_id IN (
                    SELECT DISTINCT claim_id
                               FROM gicl_claims
                              WHERE check_user_per_line (line_cd,
                                                         iss_cd,
                                                         'GICLS269'
                                                        ) = 1)
             AND claim_id = p_claim_id
             AND recovery_id = p_recovery_id)
      LOOP
         v_list.payor_class_cd := i.payor_class_cd;
         v_list.payor_cd := i.payor_cd;
         v_list.recovered_amt_p := i.recovered_amt;

         FOR rec IN (SELECT class_desc
                       FROM giis_payee_class
                      WHERE payee_class_cd = i.payor_class_cd)
         LOOP
            v_list.payee_class_desc := rec.class_desc;
         END LOOP;

         FOR rec IN (SELECT    payee_last_name
                            || DECODE (payee_first_name, NULL, '', ', ')
                            || payee_first_name
                            || DECODE (payee_middle_name, NULL, '', ' ')
                            || payee_middle_name pname
                       FROM giis_payees
                      WHERE payee_no = i.payor_cd
                        AND payee_class_cd = i.payor_class_cd)
         LOOP
            v_list.payee_name := rec.pname;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_recovery_details;

   FUNCTION get_recovery_history (p_recovery_id NUMBER)
      RETURN recovery_history_tab PIPELINED
   IS
      v_list   recovery_history_type;
   BEGIN
      FOR i IN
         (SELECT *
            FROM gicl_rec_hist
           WHERE recovery_id IN (
                    SELECT DISTINCT recovery_id
                               FROM gicl_clm_recovery
                              WHERE claim_id IN (
                                       SELECT DISTINCT claim_id
                                                  FROM gicl_claims
                                                 WHERE check_user_per_line
                                                                  (line_cd,
                                                                   iss_cd,
                                                                   'GICLS269'
                                                                  ) = 1))
             AND recovery_id = p_recovery_id)
      LOOP
         v_list.rec_hist_no := i.rec_hist_no;
         v_list.rec_stat_cd := i.rec_stat_cd;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI AM');

         FOR rec IN (SELECT rec_stat_desc
                       FROM giis_recovery_status
                      WHERE rec_stat_cd = i.rec_stat_cd)
         LOOP
            v_list.rec_stat_desc := rec.rec_stat_desc;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;
   END get_recovery_history;
END;
/


