CREATE OR REPLACE PACKAGE BODY CPI.CSV_CLM_PER_USER_GICLR271
AS
/*
    **  Created by   :  Carlo de guzman
    **  Date Created : 3.09.2016
    */
   FUNCTION csv_giclr271(
      p_in_hou_adj    gicl_claims.in_hou_adj%TYPE,
      p_as_of_date    DATE,
      p_as_of_ldate   DATE,
      p_from_date     DATE,
      p_from_ldate    DATE,
      p_to_date       DATE,
      p_to_ldate      DATE,
      p_as_of_edate   DATE,
      p_from_edate    DATE,
      p_to_edate      DATE,
      p_user_id       VARCHAR2
   )
      RETURN claims_per_user_tab PIPELINED
   IS
      v_detail   claims_per_user_type;
   BEGIN
      FOR i IN (SELECT   a.in_hou_adj, a.assured_name, a.user_id,
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
                         a.dsp_loss_date, a.clm_file_date, b.clm_stat_desc,
                         NVL (a.loss_res_amt, 0) loss_res_amt,
                         NVL (a.exp_res_amt, 0) exp_res_amt,
                         NVL (a.loss_pd_amt, 0) loss_pd_amt,
                         NVL (a.exp_pd_amt, 0) exp_pd_amt, a.entry_date,
                         a.loss_dtls
                    FROM gicl_claims a, giis_clm_stat b
                   WHERE a.clm_stat_cd = b.clm_stat_cd
                     AND a.in_hou_adj = p_in_hou_adj
                     AND check_user_per_line2 (a.line_cd, a.iss_cd, 'GICLS271', p_user_id) = 1
                     AND (   (       TRUNC (a.clm_file_date) >= p_from_date
                                 AND TRUNC (a.clm_file_date) <= p_to_date
                              OR TRUNC (a.clm_file_date) <= p_as_of_date
                             )
                          OR (       TRUNC (a.loss_date) >= p_from_ldate
                                 AND TRUNC (a.loss_date) <= p_to_ldate
                              OR TRUNC (a.loss_date) <= p_as_of_ldate
                             )
                          OR (       TRUNC (a.entry_date) >= p_from_edate
                                 AND TRUNC (a.entry_date) <= p_to_edate
                              OR TRUNC (a.entry_date) <= p_as_of_edate
                             )
                         )
                ORDER BY a.in_hou_adj,
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')),
                         a.assured_name,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')))
      LOOP
         v_detail.claim_processor := i.in_hou_adj;
         v_detail.assured_name := i.assured_name;
         v_detail.claim_number := i.claim_no;
         v_detail.policy_number := i.policy_no;
         v_detail.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-RRRR');
         v_detail.file_date := TO_CHAR (i.clm_file_date, 'MM-DD-RRRR');
         v_detail.entry_date := TO_CHAR (i.entry_date, 'MM-DD-RRRR');
         v_detail.claim_status := i.clm_stat_desc;
         v_detail.loss_details := i.loss_dtls;
         v_detail.loss_reserve := NVL(i.loss_res_amt, 0);
         v_detail.losses_paid := NVL(i.loss_pd_amt, 0);
         v_detail.expense_reserve := NVL(i.exp_res_amt, 0);
         v_detail.expenses_paid := NVL(i.exp_pd_amt, 0);

       

         PIPE ROW (v_detail);
      END LOOP;

      RETURN;
   END csv_giclr271;
END CSV_CLM_PER_USER_GICLR271;
/
