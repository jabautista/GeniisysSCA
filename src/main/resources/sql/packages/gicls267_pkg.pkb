CREATE OR REPLACE PACKAGE BODY CPI.gicls267_pkg
AS
   FUNCTION get_clm_list_per_ceding (
      p_ri_cd           gicl_claims.ri_cd%TYPE,
      p_user_id         giis_users.user_id%TYPE,
      p_claim_no        VARCHAR2,
      p_claim_status    VARCHAR2,
      p_loss_res_amt    NUMBER,
      p_exp_res_amt     NUMBER,
      p_loss_pd_amt     NUMBER,
      p_exp_pd_amt      NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN clm_list_per_ceding_tab PIPELINED
   IS
      v_list   clm_list_per_ceding_type;
   BEGIN
      FOR i IN
         (SELECT get_clm_no (a.claim_id) claim_no, b.clm_stat_desc,
                 NVL (a.loss_res_amt, 0) loss_res_amt,
                 NVL (a.exp_res_amt, 0) exp_res_amt,
                 NVL (a.loss_pd_amt, 0) loss_pd_amt,
                 NVL (a.exp_pd_amt, 0) exp_pd_amt,
                 (   a.line_cd
                  || '-'
                  || a.subline_cd
                  || '-'
                  || a.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (a.renew_no, '09'))
                 ) policy_number,
                 a.assured_name, a.loss_date, a.clm_file_date
            FROM gicl_claims a, giis_clm_stat b
           WHERE a.clm_stat_cd = b.clm_stat_cd
             AND a.ri_cd = p_ri_cd
             AND check_user_per_line2 (a.line_cd,a.iss_cd,'GICLS267', UPPER(p_user_id))=1           --pol 05.27.13
             AND get_clm_no (a.claim_id) LIKE UPPER (NVL (p_claim_no, get_clm_no (a.claim_id)))
             AND UPPER (b.clm_stat_desc) LIKE UPPER (NVL (p_claim_status, b.clm_stat_desc))
             AND NVL (a.loss_res_amt, 0) LIKE NVL (p_loss_res_amt, NVL (a.loss_res_amt, 0))
             AND NVL (a.exp_res_amt, 0) LIKE NVL (p_exp_res_amt, NVL (a.exp_res_amt, 0))
             AND NVL (a.loss_pd_amt, 0) LIKE NVL (p_loss_pd_amt, NVL (a.loss_pd_amt, 0))
             AND NVL (a.exp_pd_amt, 0) LIKE NVL (p_exp_pd_amt, NVL (a.exp_pd_amt, 0))
             AND (   (    (DECODE (p_search_by_opt,
                                   'lossDate', TRUNC(a.loss_date),
                                   'fileDate', TRUNC(a.clm_file_date)
                                  ) >= TO_DATE (p_date_from, 'MM-DD-YYYY')
                          )
                      AND (DECODE (p_search_by_opt,
                                   'lossDate', TRUNC(a.loss_date),
                                   'fileDate', TRUNC(a.clm_file_date)
                                  ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                          )
                     )
                  OR (DECODE (p_search_by_opt,
                              'lossDate', TRUNC(a.loss_date),
                              'fileDate', TRUNC(a.clm_file_date)
                             ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                     )
                 ))
      LOOP
         v_list.claim_no := i.claim_no;
         v_list.clm_stat_desc := i.clm_stat_desc;
         v_list.loss_res_amt := i.loss_res_amt;
         v_list.exp_res_amt := i.exp_res_amt;
         v_list.loss_pd_amt := i.loss_pd_amt;
         v_list.exp_pd_amt := i.exp_pd_amt;
         v_list.policy_number := i.policy_number;
         v_list.assured_name := i.assured_name;
         v_list.loss_date := i.loss_date;
         v_list.clm_file_date := i.clm_file_date;

         IF v_list.tot_loss_res_amt IS NULL
         THEN
            FOR t IN
               (SELECT SUM (NVL (a.loss_res_amt, 0)) tot_loss_res_amt,
                       SUM (NVL (a.exp_res_amt, 0)) tot_exp_res_amt,
                       SUM (NVL (a.loss_pd_amt, 0)) tot_loss_pd_amt,
                       SUM (NVL (a.exp_pd_amt, 0)) tot_exp_pd_amt
                  FROM gicl_claims a, giis_clm_stat b
                 WHERE a.clm_stat_cd = b.clm_stat_cd
                   AND check_user_per_line2 (a.line_cd,
                                             a.iss_cd,
                                             'GICLS267',
                                             p_user_id
                                            ) = 1
                   AND a.ri_cd = p_ri_cd
                   AND get_clm_no (a.claim_id) LIKE
                             UPPER (NVL (p_claim_no, get_clm_no (a.claim_id)))
                   AND UPPER (b.clm_stat_desc) LIKE
                                 UPPER (NVL (p_claim_status, b.clm_stat_desc))
                   AND NVL (a.loss_res_amt, 0) LIKE
                                 NVL (p_loss_res_amt, NVL (a.loss_res_amt, 0))
                   AND NVL (a.exp_res_amt, 0) LIKE
                                   NVL (p_exp_res_amt, NVL (a.exp_res_amt, 0))
                   AND NVL (a.loss_pd_amt, 0) LIKE
                                   NVL (p_loss_pd_amt, NVL (a.loss_pd_amt, 0))
                   AND NVL (a.exp_pd_amt, 0) LIKE
                                     NVL (p_exp_pd_amt, NVL (a.exp_pd_amt, 0))
				   -- added trunc by robert 01.06.2014
                   AND (   (    (DECODE (p_search_by_opt,
                                         'lossDate', TRUNC(dsp_loss_date),
                                         'fileDate', TRUNC(clm_file_date)
                                        ) >=
                                           TO_DATE (p_date_from, 'MM-DD-YYYY')
                                )
                            AND (DECODE (p_search_by_opt,
                                         'lossDate', TRUNC(dsp_loss_date),
                                         'fileDate', TRUNC(clm_file_date)
                                        ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                                )
                           )
                        OR (DECODE (p_search_by_opt,
                                    'lossDate', TRUNC(dsp_loss_date),
                                    'fileDate', TRUNC(clm_file_date)
                                   ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                           )
                       ))
            LOOP
               v_list.tot_loss_res_amt := t.tot_loss_res_amt;
               v_list.tot_exp_res_amt := t.tot_exp_res_amt;
               v_list.tot_loss_pd_amt := t.tot_loss_pd_amt;
               v_list.tot_exp_pd_amt := t.tot_exp_pd_amt;
            END LOOP;
         END IF;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_clm_list_per_ceding;
END;
/


