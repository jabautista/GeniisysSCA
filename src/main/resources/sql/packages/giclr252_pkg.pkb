CREATE OR REPLACE PACKAGE BODY CPI.giclr252_pkg
AS
   FUNCTION get_giclr_252_report (
      p_user_id         VARCHAR2,
      p_stat            VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN (SELECT    line_cd
                       || '-'
                       || subline_cd
                       || '-'
                       || iss_cd
                       || '-'
                       || TRIM (TO_CHAR (clm_yy, '09'))
                       || '-'
                       || TRIM (TO_CHAR (clm_seq_no, '0000009')) claim_no,
                          line_cd
                       || '-'
                       || subline_cd
                       || '-'
                       || iss_cd
                       || '-'
                       || TRIM (TO_CHAR (issue_yy, '09'))
                       || '-'
                       || TRIM (TO_CHAR (pol_seq_no, '0000009'))
                       || '-'
                       || TRIM (TO_CHAR (renew_no, '09')) policy_no,
                       assured_name, a.clm_stat_cd, dsp_loss_date, entry_date,
                       clm_file_date, close_date, in_hou_adj,
                       NVL (loss_res_amt, 0) loss_res_amt,
                       NVL (exp_res_amt, 0) exp_res_amt,
                       NVL (loss_pd_amt, 0) loss_pd_amt,
                       NVL (exp_pd_amt, 0) exp_pd_amt, a.remarks
                  FROM gicl_claims a, giis_clm_stat b
                 WHERE a.clm_stat_cd = b.clm_stat_cd
                 --  AND b.clm_stat_type like NVL(p_stat, b.clm_stat_type)  gzelle 06.03.2013
                   AND check_user_per_iss_cd2 (line_cd,
                                               iss_cd,
                                               'GICLS252',
                                               UPPER (p_user_id)
                                              ) = 1
                   --AND UPPER (a.user_id) = UPPER (p_user_id)  gzelle 06.03.2013
                   AND (   (    (DECODE (p_search_by_opt,
                                         'lossDate', TRUNC(loss_date),--dsp_loss_date
                                         'fileDate', TRUNC(clm_file_date),
                                         'entryDate',TRUNC(entry_date),
                                         'closeDate', TRUNC(close_date)
                                        ) >=
                                           TO_DATE (p_date_from, 'MM-DD-YYYY')
                                )
                            AND (DECODE (p_search_by_opt,
                                         'lossDate', TRUNC(loss_date),--dsp_loss_date
                                         'fileDate', TRUNC(clm_file_date),
                                         'entryDate', TRUNC(entry_date),
                                         'closeDate', TRUNC(close_date)
                                        ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                                )
                           )
                        OR (DECODE (p_search_by_opt,
                                    'lossDate', TRUNC(loss_date),--dsp_loss_date
                                    'fileDate', TRUNC(clm_file_date),
                                    'entryDate', TRUNC(entry_date),
                                    'closeDate', TRUNC(close_date)
                                   ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                           )
                       )
                   AND (DECODE(UPPER(p_stat), 'N', a.clm_stat_cd) NOT IN ('CD','DN','WD','CC')  --added by Gzelle 06.03.2013, from gicls252 p_stat parameter
                       OR (DECODE(UPPER(p_stat), 'C', a.clm_stat_cd) = 'CD')
                       OR (DECODE(UPPER(p_stat), 'D', a.clm_stat_cd) = 'DN')
                       OR (DECODE(UPPER(p_stat), 'W', a.clm_stat_cd) = 'WD')
                       OR (DECODE(UPPER(p_stat), 'X', a.clm_stat_cd) = 'CC')
                       OR (DECODE(UPPER(p_stat), '', a.clm_stat_cd) = a.clm_stat_cd)
                       ) 
                       order by claim_no, line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no
                   )
      LOOP
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.assured_name := i.assured_name;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.entry_date := i.entry_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.in_hou_adj := i.in_hou_adj;
         v_list.loss_res_amt := i.loss_res_amt;
         v_list.exp_res_amt := i.exp_res_amt;
         v_list.loss_pd_amt := i.loss_pd_amt;
         v_list.exp_pd_amt := i.exp_pd_amt;
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         v_list.remarks := i.remarks;

         IF p_date_as_of IS NOT NULL
         THEN
            v_list.date_type :=
                  'As of '
               || TO_CHAR (TO_DATE (p_date_as_of, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          );
         ELSIF p_date_from IS NOT NULL AND p_date_to IS NOT NULL
         THEN
            v_list.date_type :=
                  'From '
               || TO_CHAR (TO_DATE (p_date_from, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          )
               || ' to '
               || TO_CHAR (TO_DATE (p_date_to, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          );
         END IF;

         --PIPE ROW (v_list);

         BEGIN
            SELECT clm_stat_desc
              INTO v_list.clm_stat_desc
              FROM giis_clm_stat
             WHERE clm_stat_cd = i.clm_stat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.clm_stat_desc := NULL;
         END;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr_252_report;
END;
/


