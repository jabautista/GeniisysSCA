CREATE OR REPLACE PACKAGE BODY CPI.giclr250_pkg
AS
   FUNCTION get_giclr250_report (
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
      RETURN giclr250_tab PIPELINED
   IS
      v_list   giclr250_type;
   BEGIN
      FOR i IN (SELECT      a.line_cd
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
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) claim_no,
                         a.assd_no, a.assured_name, a.dsp_loss_date,
                         a.clm_file_date, b.clm_stat_desc,
                         NVL (a.loss_res_amt, 0) loss_res_amt,
                         NVL (a.exp_res_amt, 0) exp_res_amt,
                         NVL (a.loss_pd_amt, 0) loss_pd_amt,
                         NVL (a.exp_pd_amt, 0) exp_pd_amt
                    FROM gicl_claims a, giis_clm_stat b
                   WHERE a.clm_stat_cd = b.clm_stat_cd
                     AND a.line_cd = UPPER (p_line_cd)
                     AND a.subline_cd = UPPER (p_subline_cd)
                     AND a.pol_iss_cd = UPPER (p_pol_iss_cd)
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                     AND check_user_per_line2 (line_cd, iss_cd, p_module_id, p_user_id) = 1
                     AND (((DECODE(p_search_by_opt, 'lossDate', dsp_loss_date, 'fileDate', clm_file_date) >= TO_DATE (p_date_from, 'MM-DD-YYYY'))
                       AND (DECODE (p_search_by_opt, 'lossDate', dsp_loss_date, 'fileDate', clm_file_date ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')))
                        OR (DECODE (p_search_by_opt, 'lossDate', dsp_loss_date, 'fileDate', clm_file_date ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')))
                ORDER BY b.clm_stat_desc,
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd,
                         a.clm_yy,
                         a.clm_seq_no)
      LOOP
         v_list.policy_number := i.policy_no;
         v_list.assured_name := i.assured_name;
         v_list.claim_number := i.claim_no;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.loss_reserve := i.loss_res_amt;
         v_list.losses_paid := i.loss_pd_amt;
         v_list.expense_reserve := i.exp_res_amt;
         v_list.expenses_paid := i.exp_pd_amt;
         v_list.claim_status := i.clm_stat_desc;

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
      END LOOP;

      RETURN;
   END get_giclr250_report;
END;
/


