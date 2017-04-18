CREATE OR REPLACE PACKAGE BODY CPI.giclr251b_pkg
AS
   FUNCTION get_giclr251b_report (
      p_free_text       VARCHAR2,
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN (SELECT   'ASSURED - ' || a.assured_name free_text,
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999'))
                                                                    claim_no,
                         a.dsp_loss_date, a.clm_file_date, e.clm_stat_desc,
                         NVL (a.loss_res_amt, 0) loss_res_amt,
                         NVL (a.exp_res_amt, 0) exp_res_amt,
                         NVL (a.loss_pd_amt, 0) loss_pd_amt,
                         NVL (a.exp_pd_amt, 0) exp_pd_amt
                    FROM gicl_claims a, giis_clm_stat e
                   WHERE a.clm_stat_cd = e.clm_stat_cd
                     AND UPPER ('ASSURED - ' || a.assured_name) LIKE
                                                           UPPER ('%' || p_free_text || '%')
                     AND check_user_per_line2 (a.line_cd,
                                               iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
					 -- added trunc by robert 01.06.2014
                     AND (   (    (DECODE (p_search_by_opt,
                                           'lossDate', TRUNC(a.dsp_loss_date),
                                           'fileDate', TRUNC(a.clm_file_date)
                                          ) >=
                                           TO_DATE (p_date_from, 'MM-DD-YYYY')
                                  )
                              AND (DECODE (p_search_by_opt,
                                           'lossDate', TRUNC(a.dsp_loss_date),
                                           'fileDate', TRUNC(a.clm_file_date)
                                          ) <=
                                             TO_DATE (p_date_to, 'MM-DD-YYYY')
                                  )
                             )
                          OR (DECODE (p_search_by_opt,
                                      'lossDate', TRUNC(a.dsp_loss_date),
                                      'fileDate', TRUNC(a.clm_file_date)
                                     ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                             )
                         )
                UNION
                SELECT   'ITEM    - ' || b.item_title free_text,
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999'))
                                                                     claim_no,
                         a.dsp_loss_date, a.clm_file_date, e.clm_stat_desc,
                         NVL (a.loss_res_amt, 0) loss_res_amt,
                         NVL (a.exp_res_amt, 0) exp_res_amt,
                         NVL (a.loss_pd_amt, 0) loss_pd_amt,
                         NVL (a.exp_pd_amt, 0) exp_pd_amt
                    FROM gicl_clm_item b, gicl_claims a, giis_clm_stat e
                   WHERE a.claim_id = b.claim_id
                     AND a.clm_stat_cd = e.clm_stat_cd
                     AND UPPER ('ITEM    - ' || b.item_title) LIKE
                                                           UPPER ('%' || p_free_text || '%')
                     AND check_user_per_line2 (a.line_cd,
                                               iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
					 -- added trunc by robert 01.06.2014
                     AND (   (    (DECODE (p_search_by_opt,
                                           'lossDate', TRUNC(a.dsp_loss_date),
                                           'fileDate', TRUNC(a.clm_file_date)
                                          ) >=
                                           TO_DATE (p_date_from, 'MM-DD-YYYY')
                                  )
                              AND (DECODE (p_search_by_opt,
                                           'lossDate', TRUNC(a.dsp_loss_date),
                                           'fileDate', TRUNC(a.clm_file_date)
                                          ) <=
                                             TO_DATE (p_date_to, 'MM-DD-YYYY')
                                  )
                             )
                          OR (DECODE (p_search_by_opt,
                                      'lossDate', TRUNC(a.dsp_loss_date),
                                      'fileDate', TRUNC(a.clm_file_date)
                                     ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                             )
                         )
                UNION
                SELECT   'GROUPED - ' || c.grouped_item_title free_text,
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999'))
                                                                     claim_no,
                         a.dsp_loss_date, a.clm_file_date, e.clm_stat_desc,
                         NVL (a.loss_res_amt, 0) loss_res_amt,
                         NVL (a.exp_res_amt, 0) exp_res_amt,
                         NVL (a.loss_pd_amt, 0) loss_pd_amt,
                         NVL (a.exp_pd_amt, 0) exp_pd_amt
                    FROM gicl_claims a,
                         gicl_clm_item b,
                         gicl_accident_dtl c,
                         giis_clm_stat e
                   WHERE c.claim_id = b.claim_id
                     AND a.clm_stat_cd = e.clm_stat_cd
                     AND UPPER ('GROUPED ITEM - ' || c.grouped_item_title) LIKE
                                                           UPPER ('%' || p_free_text || '%')
                     AND a.claim_id = b.claim_id
                     AND c.item_no = b.item_no
                     AND c.grouped_item_no = b.grouped_item_no
                     AND check_user_per_line2 (a.line_cd,
                                               iss_cd,
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
                                          ) <=
                                             TO_DATE (p_date_to, 'MM-DD-YYYY')
                                  )
                             )
                          OR (DECODE (p_search_by_opt,
                                      'lossDate', TRUNC(a.dsp_loss_date),
                                      'fileDate', TRUNC(a.clm_file_date)
                                     ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                             )
                         )
                ORDER BY policy_no, claim_no)
      LOOP
         v_list.policy_no := i.policy_no;
         v_list.claim_no := i.claim_no;
         v_list.free_text := i.free_text;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.clm_stat_desc := i.clm_stat_desc;
         v_list.loss_reserve := i.loss_res_amt;
         v_list.expense_reserve := i.exp_res_amt;
         v_list.losses_paid := i.loss_pd_amt;
         v_list.expenses_paid := i.exp_pd_amt;
         
         IF v_list.company_name IS NULL THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         --ELSE
            --v_list.company_name := ' ';
            --v_list.company_address := ' ';
         END IF;
         
         IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL THEN
            v_list.date_as_of := TRIM(TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
         --ELSE
            --v_list.date_as_of := ' ';   
         END IF;
         
         IF v_list.date_from IS NULL AND p_date_from IS NOT NULL THEN
            v_list.date_from := TRIM(TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to := TRIM(TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         --ELSE
            --v_list.date_from := ' ';
            --v_list.date_to := ' ';    
         END IF;
--         
         
         
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr251b_report;
END;
/


